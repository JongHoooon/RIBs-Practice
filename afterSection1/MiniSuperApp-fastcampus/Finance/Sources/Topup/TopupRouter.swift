//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/05.
//

import ModernRIBs
import AddPaymentMethod
import SuperUI
import RIBsUtil
import FinanceEntity

/// 카드존재여부에 따라 다른 화면을 보여주는 로직은 어떤 뷰에도 종속돼 있지 않고 viewless riblet인 topup에 있다.
/// 충전하기 화면이 필요한 곳에서 topup riblet을 자식으로 붙이기만하면 된다.
/// mvc 사용시 vc가 앱의 로직을 주도해 business logic과 view가 강하게 결합됨
/// viewless riblet 덕분에 어떤 로직에도 종속되지 않는 buisiness logic을 추가함

protocol TopupInteractable: Interactable,
                            AddPaymentMethodListener,
                            EnterAmountListener,
                            CardOnFileListener {
  
  var router: TopupRouting? { get set }
  var listener: TopupListener? { get set }
  
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol TopupViewControllable: ViewControllable {
  // TODO: Declare methods the router invokes to manipulate the view hierarchy. Since
  // this RIB does not own its own view, this protocol is conformed to by one of this
  // RIB's ancestor RIBs' view.
}

final class TopupRouter: Router<TopupInteractable>, TopupRouting {
  
  /// topupRouter가 push와 pop을 할 때 필요하다.
  private var navigationControllerable: NavigationControllerable?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentRouting: Routing?
  
  private let enterAmountBuildable: EnterAmountBuildable
  private var enterAmountRouting: Routing?

  private let cardOnFileBuildable: CardOnFileBuildable
  private var cardOnFileRouting: Routing?
  
  init(
    interactor: TopupInteractable,
    viewController: ViewControllable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    enterAmountBuildable: EnterAmountBuildable,
    cardOnFileBuildable: CardOnFileBuildable
  ) {
    self.viewController = viewController
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.enterAmountBuildable = enterAmountBuildable
    self.cardOnFileBuildable = cardOnFileBuildable
    super.init(interactor: interactor)
    interactor.router = self
  }
  
  func cleanupViews() {
    // topup router가 띄어줬던 모든 화면을 닫아줘야한다.
    if viewController.uiviewController.presentationController != nil,
       navigationControllerable != nil {
      navigationControllerable?.dismiss(completion: nil)
    }
  }
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType) {
    guard addPaymentRouting == nil else { return }
    
    let router = addPaymentMethodBuildable.build(
      withListener: interactor,
      closeButtonType: closeButtonType
    )
    
    if let navigationControllerable = navigationControllerable {
      navigationControllerable.pushViewController(router.viewControllable, animated: true)
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    
    attachChild(router)
    addPaymentRouting = router
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentRouting else { return }
    
//    dismissPresentedNavigation(completion: nil)
    navigationControllerable?.popViewController(animated: true)
    detachChild(router)
    addPaymentRouting = nil
  }
  
  func attachEnterAmount() {
    guard enterAmountRouting == nil else { return }
    
    let router = enterAmountBuildable.build(withListener: interactor)
    
    if let navigation = navigationControllerable {
      navigation.setViewControllers([router.viewControllable])
      resetChildRouting()
    } else {
      presentInsideNavigation(router.viewControllable)
    }
    attachChild(router)
    enterAmountRouting = router
  }
  
  func detachEnterAmount() {
    guard let router = enterAmountRouting else { return }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    addPaymentRouting = nil
  }
  
  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    guard cardOnFileRouting == nil else { return }
    
    let router = cardOnFileBuildable.build(withListener: interactor, paymentMethods: paymentMethods)
    navigationControllerable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    cardOnFileRouting = router
  }
  
  func detachCardOnFile() {
    guard let router = cardOnFileRouting else { return }
    
    navigationControllerable?.popViewController(animated: true)
    detachChild(router)
    cardOnFileRouting = nil
  }
  
  func popToRoot() {
    navigationControllerable?.popToRoot(animated: true)
    resetChildRouting()
  }
  
  // MARK: - Private
  
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    self.navigationControllerable = navigation
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    guard self.navigationControllerable != nil else { return }
    
    viewController.dismiss(completion: nil)
    self.navigationControllerable = nil
  }
  
  private func resetChildRouting() {
    if let cardOnFileRouting = cardOnFileRouting {
      detachChild(cardOnFileRouting)
      self.cardOnFileRouting = nil
    }
    
    if let addPaymentRouting = addPaymentRouting {
      detachChild(addPaymentRouting)
      self.addPaymentRouting = nil
    }
  }
  
  // 부모가 건네준 viewController - FinanceHomeViewController
  private let viewController: ViewControllable
}
