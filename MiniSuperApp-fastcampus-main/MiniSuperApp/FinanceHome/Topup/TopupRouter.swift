//
//  TopupRouter.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/07.
//

import ModernRIBs

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
  
  var presentationDelegateProxy: AdaptivePresentaionControllerDelegateProxy { get }
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
    // TODO: Since this router does not own its view, it needs to cleanup the views
    // it may have added to the view hierarchy, when its interactor is deactivated.
  }
  
  func attachAddPaymentMethod() {
    guard addPaymentRouting == nil else { return }

    let router = addPaymentMethodBuildable.build(withListener: interactor)
    presentInsideNavigation(router.viewControllable)
    attachChild(router)
    addPaymentRouting = router
    
  }
  
  func detachAddPaymentMethod() {
    guard let router = addPaymentRouting else { return }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    addPaymentRouting = nil
  }
  
  func attachEnterAmount() {
    guard enterAmountRouting == nil else { return }
    
    let router = enterAmountBuildable.build(withListener: interactor)
    presentInsideNavigation(router.viewControllable)
    attachChild(router)
    enterAmountRouting = router
  }
  
  func detachEnterAmount() {
    guard let router = enterAmountRouting else { return }
    
    dismissPresentedNavigation(completion: nil)
    detachChild(router)
    enterAmountRouting = nil
  }
  
  func attachCardOnFile(paymentMethods: [PaymentMethod]) {
    guard cardOnFileRouting == nil else { return }
   
    let router = cardOnFileBuildable.build(
      withListener: interactor,
      paymentMethods: paymentMethods
    )
    navigationControllerable?.pushViewController(router.viewControllable, animated: true)
    attachChild(router)
    cardOnFileRouting = router
  }
  
  func detachCardOnFile() {
    guard let router = cardOnFileRouting else { return }
    
    navigationControllerable?.popViewController(animated: true)
    router.detachChild(router)
    cardOnFileRouting = nil
  }
  
  // MARK: - Private
  
  private func presentInsideNavigation(_ viewControllable: ViewControllable) {
    let navigation = NavigationControllerable(root: viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    navigationControllerable = navigation
    viewController.present(navigation, animated: true, completion: nil)
  }
  
  private func dismissPresentedNavigation(completion: (() -> Void)?) {
    guard self.navigationControllerable != nil else { return }
    
    // viewLess riblet이라 부모가 직접 present한 view가 없어서 부모가 dismiss 처리 하지 않는다.
    viewController.dismiss(completion: nil)
    navigationControllerable = nil
  }
  
  // 부모가 건네준 viewController - FinanceHomeViewController
  private let viewController: ViewControllable
}
