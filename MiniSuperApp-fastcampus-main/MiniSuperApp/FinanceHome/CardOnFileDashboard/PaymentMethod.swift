//
//  PaymentMethod.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/30.
//

import Foundation

struct PaymentMethod: Decodable {
  let id: String
  let name: String
  let digits: String
  let color: String
  let isPrimary: Bool
}
