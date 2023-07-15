//
//  AddPaymentMethodViewController.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/01.
//

import ModernRIBs
import UIKit
import RIBsUtil
import SuperUI

protocol AddPaymentMethodPresentableListener: AnyObject {
  func didClose()
  func didTapConfirm(with number: String, cvc: String, expiry: String)
}

final class AddPaymentMethodViewController: UIViewController,
                                            AddPaymentMethodPresentable,
                                            AddPaymentMethodViewControllable {
  
  weak var listener: AddPaymentMethodPresentableListener?
  
  private let cardNumberTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "카드 번호"
    return textField
  }()
  
  private let securityTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "CVC"
    return textField
  }()
  
  private let expirationTextField: UITextField = {
    let textField = makeTextField()
    textField.placeholder = "유효기간"
    return textField
  }()
  
  private static func makeTextField() -> UITextField {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = .white
    textField.borderStyle = .roundedRect
    textField.keyboardType = .numberPad
    return textField
  }
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.axis = .horizontal
    stackView.alignment = .center
    stackView.distribution = .fillEqually
    stackView.spacing = 14.0
    return stackView
  }()
  
  private lazy var addCardButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.roundCorners()
    button.backgroundColor = .primaryRed
    button.setTitle("추가하기", for: .normal)
    button.addTarget(self, action: #selector(didTapAddCard), for: .touchUpInside)
    return button
  }()
  
  init(closeButtonType: DismissButtonType) {
    super.init(nibName: nil, bundle: nil)
    
    setupViews()
    setupNavigationItem(
      with: closeButtonType,
      target: self,
      action: #selector(didTapClose)
    )
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupViews()
    setupNavigationItem(
      with: .close,
      target: self,
      action: #selector(didTapClose)
    )
  }
  
  private func setupViews() {
    title = "카드 추가"
    
    view.backgroundColor = .backgroundColor
    
    [
      cardNumberTextField,
      stackView,
      addCardButton
    ].forEach { view.addSubview($0) }
    
    [
      securityTextField, expirationTextField
    ].forEach { stackView.addArrangedSubview($0) }
    
    NSLayoutConstraint.activate([
      cardNumberTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 40.0),
      cardNumberTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      cardNumberTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      
      cardNumberTextField.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20.0),
      stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      
      stackView.bottomAnchor.constraint(equalTo: addCardButton.topAnchor, constant: -20.0),
      addCardButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40.0),
      addCardButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40.0),
      
      cardNumberTextField.heightAnchor.constraint(equalToConstant: 60.0),
      stackView.heightAnchor.constraint(equalToConstant: 60.0),
      securityTextField.heightAnchor.constraint(equalToConstant: 60.0),
      expirationTextField.heightAnchor.constraint(equalToConstant: 60.0),
      addCardButton.heightAnchor.constraint(equalToConstant: 60.0)
    ])
  }
  
  @objc
  private func didTapAddCard() {
    if let number = cardNumberTextField.text,
       let cvc = securityTextField.text,
       let expiry = expirationTextField.text {
      listener?.didTapConfirm(with: number, cvc: cvc, expiry: expiry)
    }
  }
  
  @objc
  private func didTapClose() {
    listener?.didClose()
  }
}
