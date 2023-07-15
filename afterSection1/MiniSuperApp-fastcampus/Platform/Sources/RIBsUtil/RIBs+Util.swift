//
//  File.swift
//  
//
//  Created by JongHoon on 2023/07/15.
//

import Foundation

public enum DismissButtonType {
  case back
  case close
  
  public var iconSystemName: String {
    switch self {
    case .back:   return "chevron.backward"
    case .close:  return "xmark"
    }
  }
}
