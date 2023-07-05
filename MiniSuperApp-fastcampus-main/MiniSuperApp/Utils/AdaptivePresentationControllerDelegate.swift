//
//  AdaptivePresentationControllerDelegate.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/03.
//

import UIKit

protocol AdaptivePresentationControllerDelegate: AnyObject {
  func presentationControllerDidDismiss()
}

/**
 Interactor을 UIKit에 대해 모르는 것을 유지하기 위해 사용한다.
 */
final class AdaptivePresentaionControllerDelegateProxy: NSObject,
                                                        UIAdaptivePresentationControllerDelegate {
  
  weak var delegate: AdaptivePresentationControllerDelegate?
  
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    delegate?.presentationControllerDidDismiss()
  }
}
