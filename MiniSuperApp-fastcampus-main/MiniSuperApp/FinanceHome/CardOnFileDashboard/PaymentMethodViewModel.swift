//
//  PaymentMethodViewModel.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/30.
//

import UIKit

struct PaymentMethodViewModel {
  let name: String
  let digits: String
  let color: UIColor
  
  init(_ paymentMethod: PaymentMethod) {
    name = paymentMethod.name
    digits = "**** \(paymentMethod.digits)"
    color = UIColor(hex: paymentMethod.color) ?? .systemGray2
  }
}
