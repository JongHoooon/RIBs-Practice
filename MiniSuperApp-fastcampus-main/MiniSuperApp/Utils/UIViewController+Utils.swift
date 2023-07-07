//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/07.
//

import UIKit

extension UIViewController {
  
  enum DismissButtonType {
    case back
    case close
    
    var iconSystemName: String {
      switch self {
      case .back:   return "chevron.backward"
      case .close:  return "xmark"
      }
    }
  }
  
  func setupNavigationItem(
    with buttonType: DismissButtonType,
    target: Any?,
    action: Selector?
  ) {
    navigationItem.leftBarButtonItem = UIBarButtonItem(
      image: UIImage(
        systemName: buttonType.iconSystemName,
        withConfiguration: UIImage.SymbolConfiguration(pointSize: 18.0, weight: .semibold)
      ),
      style: .plain,
      target: target,
      action: action
    )
  }
}
