//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/01.
//

import UIKit

public protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

public final class AdaptivePresentationControllerDelegateProxy: NSObject,
                                                         UIAdaptivePresentationControllerDelegate {
  
  public weak var delegate: AdaptivePresentationControllerDelegate?
  
  public func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}
