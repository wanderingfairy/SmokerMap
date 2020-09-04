//
//  CustomInfoWindowView.swift
//  SmokerMap
//
//  Created by 황정덕 on 2020/03/12.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit
import NMapsMap
import SnapKit

class CustomInfoWindowDataSource: NSObject, NMFOverlayImageDataSource {
  var rootView: CustomInfoWindowView = CustomInfoWindowView()
  
  func view(with overlay: NMFOverlay) -> UIView {
    guard let infoWindow = overlay as? NMFInfoWindow else { return rootView }
//    if rootView == nil {
//      rootView = (Bundle.main.loadNibNamed("CustomInfoWindowView", owner: nil, options: nil)?.first as? CustomInfoWindowView)!
//    }
    if infoWindow.marker != nil {
      guard
        let detail = infoWindow.marker?.userInfo["detail"] as? String,
        let isInside = infoWindow.marker?.userInfo["isInside"] as? Bool,
        let spaceSize = infoWindow.marker?.userInfo["spaceSize"] as? String
      else { return UIView()}
      print(detail,isInside,spaceSize)
      rootView.detailLabel.text = detail
      if isInside {
        rootView.insideImageView.image = UIImage(named: "CheckBoxSelected")
      } else {
        rootView.insideImageView.image = UIImage(named: "CheckBox")
      }
      switch spaceSize {
      case "S":
        rootView.spaceSizeSetLabel.text = "S"
        rootView.spaceSizeImageView.image = UIImage(named: "CheckBox")
      case "M":
        rootView.spaceSizeSetLabel.text = "M"
        rootView.spaceSizeImageView.image = UIImage(named: "CheckBox")
      case "L":
        rootView.spaceSizeSetLabel.text = "L"
        rootView.spaceSizeImageView.image = UIImage(named: "CheckBox")
      default:
        break
      }
    }
    
//    rootView.textLabel.sizeToFit()
//    let width = rootView.textLabel.frame.size.width + 80
//    rootView.frame = CGRect(x: 0, y: 0, width: width, height: 88)
    rootView.snp.makeConstraints {
      $0.height.equalTo(120)
      $0.width.equalTo(150)
    }
    rootView.layoutIfNeeded()
    
    return rootView
  }
  
}


class CustomInfoWindowView: UIView {
  let detailLabel = UILabel()
  let insideLabel = UILabel()
  let insideImageView = UIImageView()
  let spaceSizeLabel = UILabel()
  let spaceSizeImageView = UIImageView()
  let spaceSizeSetLabel = UILabel()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    setupUI()
    setConstraints()
    self.backgroundColor = UIColor(named: "BGcolor")
    
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  func setupUI(){
//    self.addSubview(iconView)
//    self.addSubview(textLabel)
    [detailLabel,insideLabel,insideImageView,spaceSizeLabel,spaceSizeImageView,spaceSizeSetLabel].forEach {
      self.addSubview($0)
    }
    detailLabel.font =  UIFont.boldSystemFont(ofSize: 21)

    detailLabel.text = "1"
    insideLabel.text = "Inside"
    spaceSizeLabel.text = "Size"
    
    
    if self.traitCollection.userInterfaceStyle == .dark {
      detailLabel.textColor = .white
      insideLabel.textColor = .white
      spaceSizeSetLabel.textColor = .white
      spaceSizeLabel.textColor = .white
      
    } else {
      detailLabel.textColor = .black
      insideLabel.textColor = .black
      spaceSizeSetLabel.textColor = .black
      spaceSizeLabel.textColor = .black
      
    }
    
    
    self.layer.cornerRadius = 10
  }
  func setConstraints(){
    detailLabel.snp.makeConstraints {
      $0.leading.top.equalToSuperview().offset(10)
      $0.width.equalTo(self.snp.width).multipliedBy(0.8)
    }
    insideLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.equalTo(detailLabel.snp.bottom).offset(10)
    }
    insideImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-10)
      $0.centerY.equalTo(insideLabel.snp.centerY)
      $0.height.width.equalTo(insideLabel.snp.height)
    }
    spaceSizeLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.equalTo(insideLabel.snp.bottom).offset(10)
    }
    spaceSizeImageView.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-10)
      $0.centerY.equalTo(spaceSizeLabel.snp.centerY)
      $0.height.width.equalTo(spaceSizeLabel.snp.height)
    }
    
    spaceSizeSetLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-10)
      $0.centerY.equalTo(spaceSizeLabel.snp.centerY)
      $0.height.width.equalTo(spaceSizeLabel.snp.height)
    }
    //,insideLabel,insideImageView,spaceSizeLabel,spaceSizeImageView
  }
}

