//
//  Formatter.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/29.
//

import Foundation

struct Formatter {
  static let balanceFormatter: NumberFormatter = {
    let formatter = NumberFormatter()    
    formatter.numberStyle = .decimal
    return formatter
  }()
}
