import ModernRIBs
import AddPaymentMethod
import SuperUI

protocol FinanceHomeInteractable: Interactable,
                                  SuperPayDashboardListener,
                                  CardOnFileDashboardListener,
                                  AddPaymentMethodListener,
                                  TopupListener {
  
  var router: FinanceHomeRouting? { get set }
  var listener: FinanceHomeListener? { get set }
  var presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy { get }
}

protocol FinanceHomeViewControllable: ViewControllable {
  func addDashboard(_ view: ViewControllable)
}

final class FinanceHomeRouter: ViewableRouter<FinanceHomeInteractable,FinanceHomeViewControllable>,
                               FinanceHomeRouting {
  
  private let superPayDashboardBuildable: SuperPayDashboardBuildable
  private var superPayRouting: Routing?
  
  private let cardOnFileDashboardBuildable: CardOnFileDashboardBuildable
  private var cardOnFileRouting: Routing?
  
  private let addPaymentMethodBuildable: AddPaymentMethodBuildable
  private var addPaymentMethodRouting: Routing?
  
  private let topupBuildable: TopupBuildable
  private var topupRouting: Routing?
  
  // TODO: Constructor inject child builder protocols to allow building children.
  init(
    interactor: FinanceHomeInteractable,
    viewController: FinanceHomeViewControllable,
    superPayDashboardBuildable: SuperPayDashboardBuildable,
    cardOnFileDashboardBuildable: CardOnFileDashboardBuildable,
    addPaymentMethodBuildable: AddPaymentMethodBuildable,
    topupBuildable: TopupBuildable
  ) {
    self.superPayDashboardBuildable = superPayDashboardBuildable
    self.cardOnFileDashboardBuildable = cardOnFileDashboardBuildable
    self.addPaymentMethodBuildable = addPaymentMethodBuildable
    self.topupBuildable = topupBuildable
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
    
    self.superPayRouting = router
    attachChild(router)
  }
  
  func attachCardOnFileDashboard() {
    if cardOnFileRouting != nil { return }
    
    let router = cardOnFileDashboardBuildable.build(withListener: interactor)
    let dashboard = router.viewControllable
    viewController.addDashboard(dashboard)
    
    self.cardOnFileRouting = router
    attachChild(router)
  }
  
  func attachAddPaymentMethod() {
    if addPaymentMethodRouting != nil { return }
    
    let router = addPaymentMethodBuildable.build(
      withListener: interactor,
      closeButtonType: .close
    )
    let navigation = NavigationControllerable(root: router.viewControllable)
    navigation.navigationController.presentationController?.delegate = interactor.presentationDelegateProxy
    viewControllable.present(navigation, animated: true, completion: nil)
    
    self.addPaymentMethodRouting = router
    attachChild(router)
  }
  
  // 자식을 책임지고 닫아야한다. 닫는 행위를 부모에게 맡겨 재사용성 증가
  func detachAddPaymentMethod() {
    guard let router = addPaymentMethodRouting else { return }
    
    viewControllable.dismiss(completion: nil)
    detachChild(router)
    addPaymentMethodRouting = nil
  }
  
  func attatchTopup() {
    guard topupRouting == nil else { return }
    
    let router = topupBuildable.build(withListener: interactor)
    // topup은 viewless riblet 이라 router.viewControllable 존재하지 않는다.
    // viewless riblet은 present 하지 않고 attachChild만 한다.
    attachChild(router)
    topupRouting = router
  }
  
  func detachTopup() {
    guard let router = topupRouting else { return }
    
    // viewless riblet은 dismiss 하지않고 detachChild만 한다.
    detachChild(router)
    topupRouting = nil
  }
}
