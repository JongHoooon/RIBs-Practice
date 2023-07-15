//
//  PaymentMethodViewModel.swift
//  
//
//  Created by JongHoon on 2023/07/15.
//

import UIKit
import FinanceEntity

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
