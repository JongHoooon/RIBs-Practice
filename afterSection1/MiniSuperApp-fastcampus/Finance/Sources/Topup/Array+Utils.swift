//
//  File.swift
//  
//
//  Created by JongHoon on 2023/07/15.
//

import Foundation

extension Array {
  subscript(safe index: Int) -> Element? {
    return indices ~= index ? self[index] : nil
  }
}

