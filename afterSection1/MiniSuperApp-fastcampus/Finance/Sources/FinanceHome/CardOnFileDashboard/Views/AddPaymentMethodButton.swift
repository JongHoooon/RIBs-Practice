//
//  AddPaymentMethodButton.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/29.
//

import UIKit

final class AddPaymentMethodButton: UIControl {
  
  private let plusIcon: UIImageView = {
    let imageView = UIImageView(
      image: UIImage(
        systemName: "plus",
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 24.0, weight: .semibold))
    )
    imageView.tintColor = .white
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  init() {
    super.init(frame: .zero)
    
    setViews()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
  }
  
  private func setViews() {
    [
      plusIcon
    ].forEach { addSubview($0) }
    
    NSLayoutConstraint.activate([
      plusIcon.centerXAnchor.constraint(equalTo: centerXAnchor),
      plusIcon.centerYAnchor.constraint(equalTo: centerYAnchor)
    ])
  }
}
