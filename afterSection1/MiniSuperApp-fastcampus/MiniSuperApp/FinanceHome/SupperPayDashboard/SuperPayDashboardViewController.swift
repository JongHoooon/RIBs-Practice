//
//  SuperPayDashboardViewController.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/27.
//

import ModernRIBs
import UIKit

protocol SuperPayDashboardPresentableListener: AnyObject {
  func topupButtonDidTap()
}

final class SuperPayDashboardViewController: UIViewController, SuperPayDashboardPresentable, SuperPayDashboardViewControllable {
  
  weak var listener: SuperPayDashboardPresentableListener?
  
  private let headerStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    stackView.axis = .horizontal
    return stackView
  }()
  
  private let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22, weight: .bold)
    label.textColor = .label
    label.text = "슈퍼페이 잔고"
    return label
  }()
  
  private lazy var topupButton: UIButton = {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("충전하기", for: .normal)
    button.setTitleColor(.systemBlue, for: .normal)
    button.addTarget(self, action: #selector(touchButtonDidTap), for: .touchUpInside)
    return button
  }()
  
  private let cardView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.layer.cornerRadius = 16.0
    view.layer.cornerCurve = .continuous
    view.backgroundColor = .systemIndigo
    return view
  }()
  
  private let currencyLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22.0, weight: .semibold)
    label.text = "원"
    label.textColor = .white
    return label
  }()
  
  private let balanceAmountLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 22.0, weight: .semibold)
    label.textColor = .white
    label.text = "10,000"
    return label
  }()
  
  private let balanceStackView: UIStackView = {
    let stack = UIStackView()
    stack.translatesAutoresizingMaskIntoConstraints = false
    stack.alignment = .fill
    stack.distribution = .equalSpacing
    stack.axis = .horizontal
    stack.spacing = 4.0
    return stack
  }()
  
  init() {
    super.init(nibName: nil, bundle: nil)
    
    setViews()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func setViews() {
    [
      headerStackView,
      cardView
    ].forEach { view.addSubview($0) }
    
    [
      titleLabel,
      topupButton
    ].forEach { headerStackView.addArrangedSubview($0) }
    
    cardView.addSubview(balanceStackView)
    [
      balanceAmountLabel,
      currencyLabel
    ].forEach { balanceStackView.addArrangedSubview($0) }
    
    NSLayoutConstraint.activate([
      headerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
      headerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      headerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      
      cardView.topAnchor.constraint(equalTo: headerStackView.bottomAnchor, constant: 10),
      cardView.heightAnchor.constraint(equalToConstant: 180.0),
      cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20.0),
      cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20.0),
      cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
      
      balanceStackView.centerXAnchor.constraint(equalTo: cardView.centerXAnchor),
      balanceStackView.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
    ])
  }
  
  func updateBalance(_ balance: String) {
    balanceAmountLabel.text = balance
  }
  
  @objc
  private func touchButtonDidTap() {
    listener?.topupButtonDidTap()
  }
}
