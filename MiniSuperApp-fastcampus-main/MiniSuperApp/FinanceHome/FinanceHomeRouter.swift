import ModernRIBs

protocol FinanceHomeInteractable: Interactable,
                                  SuperPayDashboardListener,
                                  CardOnFileDashboardListener,
                                  AddPaymentMethodListener {
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentaionControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable, FinanceHomeViewControllable>,
                               FinanceHomeRouting {
  
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?
  
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymnetMethodRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    super.init(
      interactor: interactor,
      viewController: viewController
    )
    interactor.router = self
  }
  
  func attachSuperPayDashboard() {
    if superPayRouting != nil { return }
    
    let router = superPayDashboardBuildable.build(withListener: interactor)
    
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    superPayRouting = router
    attachChild(router)
  }
  
  func attachCardOnFileDashboard() {
    if cardOnFileRouting != nil { return }
    
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    cardOnFileRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    guard addPaymnetMethodRouting == nil else { return }
    
    let router = addPaymentMethodBuildable.build(withListener: interactor)
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)
    
    addPaymnetMethodRouting = router
    attachChild(router)
  }
  
  // 자식을 책임지고 닫아야한다. 닫는 행위를 부모에게 맡겨 재사용성 증가
  func detachAddPaymentMethod() {
    guard let router = addPaymnetMethodRouting else { return }
    
    viewControllable.dismiss(completion: nil)
    detachChild(router)
    addPaymnetMethodRouting = nil
  }
}
