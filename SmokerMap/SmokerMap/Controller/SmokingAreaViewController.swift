//
//  SmokingAreaViewController.swift
//  SmokerMap
//
//  Created by 정의석 on 2020/03/09.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit
import NMapsMap
import SnapKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

public let DEFAULT_CAMERA_POSITION = NMFCameraPosition(NMGLatLng(lat: 37.5666102, lng: 126.9783881), zoom: 18, tilt: 0, heading: 0)

class SmokingAreaViewController: UIViewController {
    
  // MARK: - Properties
  let uid = Auth.auth().currentUser?.uid
  let ref = Database.database().reference()
  weak var mapView: NMFMapView!
  let naverMapView: NMFNaverMapView = {
    let naverMapView = NMFNaverMapView()
    naverMapView.mapView.moveCamera(NMFCameraUpdate(position: DEFAULT_CAMERA_POSITION))
    //    naverMapView.positionMode = .compass
    naverMapView.positionMode = .direction
    naverMapView.showLocationButton = true
    return naverMapView
  }()
  let plusButton = UIButton()
  let plusImage = UIImageView()
  var addSmokingAreaViews: [AddSmokingAreaView] = []
  var smokingAreas: [SmokingArea] = []
  let marker = NMFMarker()
  var markers: [NMFMarker] = []
  let infoWindow = NMFInfoWindow()
  var customInfoWindowDataSource = CustomInfoWindowDataSource()
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.isNavigationBarHidden = true
    mapView = naverMapView.mapView
    setUI()
    mapView.delegate = self
    //    marker.position = mapView.cameraPosition.target
    //    marker.mapView = mapVie
    //    mapView.logoAlign = .
    mapView.logoInteractionEnabled = false
    mapView.isRotateGestureEnabled = false
    if self.traitCollection.userInterfaceStyle == .dark {
      mapView.mapType = .navi
      mapView.isNightModeEnabled = true
    } else {
      mapView.mapType = .basic
      mapView.isNightModeEnabled = false
    }
    addSmokeArea { }
    infoWindow.anchor = CGPoint(x: 0.5, y: 1)
    infoWindow.dataSource = customInfoWindowDataSource
    infoWindow.offsetX = 0
    infoWindow.offsetY = 15
    infoWindow.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
      self?.infoWindow.close()
      return true
    }
    infoWindow.mapView = mapView
  }
  private func setUI(){
    self.view.addSubview(naverMapView)
    self.view.addSubview(plusButton)
    plusButton.setImage(UIImage(named: "SmokingButton"), for: .normal)
    plusButton.backgroundColor = .clear
    plusButton.tag = 1
    plusButton.addTarget(self, action: #selector(didTapButton(_:)), for: .touchUpInside)
    plusImage.image = UIImage(named: "pointer")
    setConstrait()
  }
  private func setConstrait(){
    let guide = view.safeAreaLayoutGuide
    naverMapView.snp.makeConstraints {
      $0.top.bottom.leading.trailing.equalToSuperview()
    }
    plusButton.snp.makeConstraints {
      $0.trailing.equalTo(guide).offset(-20)
      $0.top.equalTo(guide).offset(20)
      //      $0.center.equalToSuperview()
      $0.width.height.equalTo(70)
    }
  }
  private func setAddAreaImage(){
    addSmokingAreaViews.append(AddSmokingAreaView())
    addSmokingAreaViews[0].delegate = self
    self.view.addSubview(plusImage)
    self.view.addSubview(addSmokingAreaViews[0])
    addSmokingAreaViews[0].snp.makeConstraints {
      $0.leading.trailing.bottom.equalToSuperview()
      $0.height.equalTo(250)
    }
    addSmokingAreaViews[0].transform = .init(translationX: 0, y: 250)
    UIView.animate(withDuration: 1) {
      self.addSmokingAreaViews[0].transform = .identity
    }
    plusImage.snp.makeConstraints {
      $0.center.equalToSuperview()
      $0.height.width.equalTo(30)
    }
  }
  private func addSmokeArea(completion:  @escaping () -> ()){
    DispatchQueue.global().async {
      self.ref.child("SmokingArea").queryOrderedByKey().queryStarting(atValue: "0").observe(.childAdded) { (DataSnapshot) in
        guard let data = DataSnapshot.value as? [String: Any] else { print("검색 결과를 찾을 수 없습니다."); return }
        //      print(data)
        //      let locationName = DataSnapshot.key
        guard let name = data["name"] as? String else { return print("check") }
        guard let latitude = data["lat"] as? Double else { return }
        guard let longitude = data["lng"] as? Double else { return }
        guard let isInside = data["isInside"] as? Bool else { return }
        guard let spaceSize = data["size"] as? String else { return }
        let smokingArea = SmokingArea(name: name, lat: latitude, lng: longitude, isInside: isInside, uid: self.uid!, spaceSzie: spaceSize)
        let plusMarker = NMFMarker(position: NMGLatLng(lat: latitude, lng: longitude))
        plusMarker.iconImage = NMFOverlayImage(image: UIImage(named: "PinImage")!)
        plusMarker.userInfo = ["detail" : name,"isInside" : isInside, "spaceSize" : isInside]
        plusMarker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
          self?.infoWindow.open(with: plusMarker, alignType: NMFAlignType.center)
          print("check")
          return true
        }
        plusMarker.userInfo = ["detail" : name,"isInside" : isInside, "spaceSize" : spaceSize]
        plusMarker.mapView = self.mapView
        //        self.infoWindow.open(with: plusMarker)
        self.smokingAreas.append(smokingArea)
      }
    }
    print(smokingAreas)
  }
  private func createMarker(){
    //    print(datas)
    smokingAreas.forEach {
      print($0)
      let plusMarker = NMFMarker(position: NMGLatLng(lat: $0.lat, lng: $0.lng))
      markers.append(plusMarker)
    }
    markers.forEach {
      $0.iconImage = NMFOverlayImage(image: UIImage(named: "PinImage")!)
      $0.mapView = mapView
    }
  }
  var isCheck = true
  @objc private func didTapButton(_ sender: UIButton){
    if isCheck {
      setAddAreaImage()
      UIView.animate(withDuration: 1) {
        self.plusImage.transform = .init(translationX: 0, y: -130)
        self.mapView.transform = .init(translationX: 0, y: -130)
      }
    } else {
      UIView.animate(withDuration: 1, animations: {
        self.mapView.transform = .identity
        self.addSmokingAreaViews[0].transform = .init(translationX: 0, y: 250)
        self.addSmokingAreaViews[0].alpha = 0
      }) { (Bool) in
        self.addSmokingAreaViews[0].removeFromSuperview()
        self.addSmokingAreaViews.removeAll()
      }
      plusImage.removeFromSuperview()
    }
    isCheck.toggle()
  }
  deinit {
    mapView = nil
  }
}
extension NMGLatLng {
  func positionString() -> String {
    return String(format: "(%.5f, %.5f)", lat, lng)
  }
}
// MARK: - NMFMapViewDelegate
extension SmokingAreaViewController: NMFMapViewDelegate {
  func updateCrosshairCoord() {
    let coord = mapView.projection.latlng(from: plusButton.center)
    //    print( String(format: "화면좌표: (%.1f, %.1f)\n지도좌표: (%.5f, %.5f)", plusButton.center.x, plusButton.center.y, coord.lat, coord.lng))
  }
  func mapView(_ mapView: NMFMapView, regionWillChangeAnimated animated: Bool, byReason reason: Int) {
    naverMapView.positionMode = .normal
    updateCrosshairCoord()
    //    mapView.projection.
    //    let point = mapView.projection.point(from: marker.position)
    //    DispatchQueue.main.async { [weak self] in
    //      guard let marker = self?.marker else { return }
    //      marker.captionText = String(format: "화면좌표: (%.1f, %.1f)\n지도 좌표: (%.5f, %.5f)", point.x, point.y, marker.position.lat, marker.position.lng)
    //      self?.updateCrosshairCoord()
    //    }
  }
  func didTapMapView(_ point: CGPoint, latLng latlng: NMGLatLng) {
    infoWindow.close()
    if !isCheck {
      UIView.animate(withDuration: 1, animations: {
        self.mapView.transform = .identity
        self.addSmokingAreaViews[0].transform = .init(translationX: 0, y: 250)
        self.addSmokingAreaViews[0].alpha = 0
      }) { (Bool) in
        self.addSmokingAreaViews[0].removeFromSuperview()
        self.addSmokingAreaViews.removeAll()
      }
      plusImage.removeFromSuperview()
    }
    isCheck = true
    //    infoWindow.position = latlng
    print(latlng.lat,latlng.lng)
    //    infoWindow.open(with: mapView)
  }
}
// MARK: - AddSmokingAreaViewDelegate
extension SmokingAreaViewController: AddSmokingAreaViewDelegate{
  func addSmokingViewDown() {
    //    addSmokingAreaView.bounds.origin.y = addSmokingAreaView.bounds.origin.y - 250
    UIView.animate(withDuration: 1) {
      self.addSmokingAreaViews[0].transform = .identity
      self.plusImage.transform = .identity
      self.mapView.transform = .identity
    }
  }
  func addSmokingViewUp() {
    //    addSmokingAreaView.bounds.origin.y = addSmokingAreaView.bounds.origin.y + 250
    UIView.animate(withDuration: 1) {
      self.addSmokingAreaViews[0].transform = .init(translationX: 0, y: -200)
      self.plusImage.transform = .init(translationX: 0, y: -200)
      self.mapView.transform = .init(translationX: 0, y: -200)
    }
  }
  func addSmokingAreaInfo(detail: String, inside: Bool, size: String) {
    let coord = mapView.projection.latlng(from: plusImage.center)
    print( String(format: "마지막~ 지도좌표: (%.5f, %.5f)",  coord.lat, coord.lng))
    let value = ["name": detail,
                 "lat": coord.lat,
                 "lng": coord.lng,
                 "isInside": inside,
                 "size": size,
                 "user": uid!,
      ] as [String: Any]
    let randomNum = Array(1...10000000).randomElement()
    ref.child("SmokingArea").child(String(randomNum!)).setValue(value) {  err, raf in
      if err == nil {
        print("성공")
      } else {
        print("실패")
      }
    }
    plusImage.removeFromSuperview()
    addSmokingAreaViews[0].removeFromSuperview()
  }
}
//private func okPresent(){
//  let numberFormatter = NumberFormatter()
//  numberFormatter.roundingMode = .floor         // 형식을 버림으로 지정
//  numberFormatter.minimumSignificantDigits = 5  // 자르길 원하는 자릿수
//  numberFormatter.maximumSignificantDigits = 5
//
//  let coord = mapView.projection.latlng(from: plusImage.center)
//
//  print( String(format: "마지막~ 지도좌표: (%.5f, %.5f)",  coord.lat, coord.lng))
//  let AddSmokingVC = AddSmokingAreaViewController()
//  AddSmokingVC.setConfig(lat: coord.lat, lng: coord.lng)
//  let naVC = UINavigationController(rootViewController: AddSmokingVC)
//  naVC.modalPresentationStyle = .fullScreen
//  present(naVC, animated: true)
//}
