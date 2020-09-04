//
//  addSmokingAreaView.swift
//  SmokerMap
//
//  Created by 황정덕 on 2020/03/11.
//  Copyright © 2020 pandaman. All rights reserved.
//

import UIKit
import SnapKit
protocol AddSmokingAreaViewDelegate: class {
  func addSmokingAreaInfo(detail: String, inside: Bool, size: String)
  func addSmokingViewUp()
  func addSmokingViewDown()
  
}
class AddSmokingAreaView: UIView {
  weak var delegate: AddSmokingAreaViewDelegate?
  struct Padding {
    static let margin: CGFloat = 20
    static let inset: CGFloat = 16
    static let buttonXSpace: CGFloat = 40
    static let buttonYSpace: CGFloat = 8
    static let buttonSize: CGFloat = 70
  }
  var sizeText = "" {
    didSet{
      sizeLabel.text = sizeText
    }
  }
  private let detailLabel = UILabel()
  private let detailImageView = UIImageView()
  private let detailTextField = UITextField()
  
  private let insideLabel = UILabel()
  private let insideButton = UIButton()
  private let spaceSizeLabel = UILabel()
  private let spaceSizeButton = UIButton()
  private let sizeLabel = UILabel()
  private let leftButton = UIButton()
  private let rightButton = UIButton()
  
  private let addSmokingAreaButton = UIButton()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    self.setupUI()
    self.backgroundColor = UIColor(named: "BGcolor")
    self.setConstraints()
    detailTextField.delegate = self
  }
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setupUI(){
    [detailLabel, detailImageView ,insideLabel, insideButton, spaceSizeLabel, spaceSizeButton, leftButton, rightButton, addSmokingAreaButton, leftButton, rightButton].forEach {
      self.addSubview($0)
    }
    self.addSubview(sizeLabel)
    //    detailTextField.background = UIImage(named: "TextFieldBG")
    //    detailTextField.disabledBackground
    
    sizeLabel.text = "M"
    sizeLabel.font = UIFont.boldSystemFont(ofSize: 21)
    
    self.addSubview(detailTextField)
    addSmokingAreaButton.setImage(UIImage(named: "AddButton"), for: .normal)
    addSmokingAreaButton.addTarget(self, action: #selector(didTapAddAreaButton(sender:)), for: .touchUpInside)
    
    
    detailLabel.text = "Detail"
    detailLabel.font =  UIFont.boldSystemFont(ofSize: 21)
    
    detailImageView.image = UIImage(named: "TextFieldBG")
    detailImageView.contentMode = .scaleAspectFit
    insideLabel.text = "Inside"
    insideLabel.font = UIFont.systemFont(ofSize: 19)
    
    insideButton.setImage(UIImage(named: "CheckBox"), for: .normal)
    insideButton.addTarget(self, action: #selector(didTapInsideButton(sender:)), for: .touchUpInside)
    
    spaceSizeLabel.text = "Size"
    spaceSizeLabel.font = UIFont.systemFont(ofSize: 19)
    spaceSizeButton.setImage(UIImage(named: "CheckBox"), for: .normal)
    //    spaceSizeButton.addTarget(self, action: #selector(didTapSizeButton(sender:)), for: .touchUpInside)
    
    leftButton.setImage(UIImage(named: "LeftTriangle"), for: .normal)
    leftButton.tag = 0
    leftButton.addTarget(self, action: #selector(didTapSizeButton(sender:)), for: .touchUpInside)
    
    rightButton.setImage(UIImage(named: "RightTriangle"), for: .normal)
    rightButton.tag = 1
    rightButton.addTarget(self, action: #selector(didTapSizeButton(sender:)), for: .touchUpInside)
    let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: detailTextField.frame.height))
    detailTextField.leftView = paddingView
    detailTextField.leftViewMode = .always
    
    if self.traitCollection.userInterfaceStyle == .dark {
      detailTextField.textColor = .black
      detailLabel.textColor = .white
      insideLabel.textColor = .white
      spaceSizeLabel.textColor = .white
    } else {
      detailTextField.textColor = .black
      detailLabel.textColor = .black
      insideLabel.textColor = .black
      spaceSizeLabel.textColor = .black
    }
    
  }
  private func setConstraints(){
    addSmokingAreaButton.snp.makeConstraints {
      $0.top.equalToSuperview().offset(40)
      $0.trailing.equalToSuperview().offset(-10)
      $0.width.equalTo(70)
      $0.height.equalTo(100)
    }
    detailLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().offset(20)
    }
    detailTextField.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(detailLabel.snp.bottom).offset(5)
      $0.trailing.equalTo(addSmokingAreaButton.snp.leading).offset(-10)
    }
    insideLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(detailTextField.snp.bottom).offset(10)
    }
    insideButton.snp.makeConstraints {
      //      $0.top.equalTo(detailImageView).offset(20)
      $0.centerY.equalTo(insideLabel.snp.centerY)
      $0.trailing.equalTo(addSmokingAreaButton.snp.leading).offset(-20)
      $0.width.height.equalTo(40)
    }
    spaceSizeLabel.snp.makeConstraints {
      $0.top.equalTo(insideLabel.snp.bottom).offset(10)
      $0.leading.equalToSuperview().offset(20)
    }
    spaceSizeButton.snp.makeConstraints {
      $0.centerX.equalTo(insideButton.snp.centerX)
      $0.centerY.equalTo(spaceSizeLabel.snp.centerY)
      $0.height.width.equalTo(insideButton.snp.width)
    }
    
    detailImageView.snp.makeConstraints {
      $0.top.trailing.bottom.equalTo(detailTextField)
      $0.leading.equalTo(detailTextField.snp.leading).offset(-5)
    }
    
    sizeLabel.snp.makeConstraints {
        $0.centerX.equalTo(spaceSizeButton).offset(-2)
        $0.centerY.equalTo(spaceSizeButton).offset(-2)
    }
    
    leftButton.snp.makeConstraints {
      $0.centerY.equalTo(spaceSizeButton)
      $0.trailing.equalTo(spaceSizeButton.snp.leading).offset(-5)
      $0.height.width.equalTo(spaceSizeButton.snp.width)
    }
    
    rightButton.snp.makeConstraints {
      $0.centerY.equalTo(spaceSizeButton)
      $0.leading.equalTo(spaceSizeButton.snp.trailing).offset(5)
      $0.height.width.equalTo(spaceSizeButton.snp.width)
    }
  }
  
  
  var isCheckInside = false
  @objc private func didTapInsideButton(sender: UIButton){
    if isCheckInside {
      insideButton.setImage(UIImage(named: "CheckBox"), for: .normal)
    } else {
      insideButton.setImage(UIImage(named: "CheckBoxSelected"), for: .normal)
    }
    isCheckInside.toggle()
  }
  
  var checkSize = 0
  @objc private func didTapSizeButton(sender: UIButton){
    if sender.tag == 0 {
      if checkSize == 0 {
        sizeText = "S"
        checkSize = 1
      } else if checkSize == 1 {
        sizeText = "L"
        checkSize = 2
      } else {
        sizeText = "M"
        checkSize = 0
      }
    } else if sender.tag == 1 {
      if checkSize == 0 {
        sizeText = "L"
        checkSize = 1
      } else if checkSize == 1 {
        sizeText = "S"
        checkSize = 2
      } else {
        sizeText = "M"
        checkSize = 0
      }
    }
  }
  
  @objc private func didTapAddAreaButton(sender: UIButton){
    //     let du = detailTextField.placeholder
    delegate?.addSmokingAreaInfo(detail: detailTextField.text! != "" ? detailTextField.text! : "SmokArea" , inside: isCheckInside, size: sizeText)
  }
}

extension AddSmokingAreaView: UITextFieldDelegate {
  func textFieldDidBeginEditing(_ textField: UITextField) {
    delegate?.addSmokingViewUp()
    
  }
  func textFieldDidEndEditing(_ textField: UITextField) {
    delegate?.addSmokingViewDown()
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.endEditing(true)
    return true
  }
}
