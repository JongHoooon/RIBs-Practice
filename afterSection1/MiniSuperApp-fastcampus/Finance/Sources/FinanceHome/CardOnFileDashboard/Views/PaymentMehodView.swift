//
//  PaymentMehodView.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/30.
//

import UIKit

final class PaymentMethodView: UIView {
  
  private let nameLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 18.0, weight: .semibold)
    label.textColor = .white
    label.text = "우리은행"
    return label
  }()
  
  private let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = .systemFont(ofSize: 15.0, weight: .regular)
    label.textColor = .white
    label.text = "**** 9999"
    return label
  }()
  
  init(viewModel: PaymentMethodViewModel) {
    super.init(frame: .zero)
    
    setViews()
    
    nameLabel.text = viewModel.name
    subtitleLabel.text = viewModel.digits
    backgroundColor = viewModel.color
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func setViews() {
    [
      nameLabel,
      subtitleLabel
    ].forEach { addSubview($0) }
    backgroundColor = .systemIndigo
    
    NSLayoutConstraint.activate([
      nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24.0),
      nameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
      
      subtitleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -24.0),
      subtitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
