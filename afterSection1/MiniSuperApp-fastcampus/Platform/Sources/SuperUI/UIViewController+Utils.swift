//
//  UIViewController+Utils.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/05.
//

import UIKit
import RIBsUtil

public extension UIViewController {
  
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
