import ModernRIBs
import SuperUI
import FinanceEntity

protocol FinanceHomeRouting: ViewableRouting {
  func attachSuperPayDashboard()
  func attachCardOnFileDashboard()
  func attachAddPaymentMethod()
  func detachAddPaymentMethod()
  func attatchTopup()
  func detachTopup()
}

protocol FinanceHomePresentable: Presentable {
  var listener: FinanceHomePresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

protocol FinanceHomeListener: AnyObject {
  // TODO: Declare methods the interactor can invoke to communicate with other RIBs.
}

final class FinanceHomeInteractor: PresentableInteractor<FinanceHomePresentable>,
                                   FinanceHomeInteractable,
                                   FinanceHomePresentableListener,
                                   AdaptivePresentationControllerDelegate {
  
  weak var router: FinanceHomeRouting?
  weak var listener: FinanceHomeListener?
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  override init(presenter: FinanceHomePresentable) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    super.init(presenter: presenter)
    presenter.listener = self
    self.presentationDelegateProxy.delegate = self
  }
  
  // view did load랑 비슷
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
    
    router?.attachSuperPayDashboard()
    router?.attachCardOnFileDashboard()
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    router?.detachAddPaymentMethod()
  }
  
  // MARK: - CardOnFileDashboard Listener
  func cardOnFileDashboardDidTapAddPaymentMethod() {
    router?.attachAddPaymentMethod()
  }
  
  // MARK: - AddPaymentMethod Listener
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    router?.detachAddPaymentMethod()
  }
  
  func superPayDashboardDidTapTopup() {
    router?.attatchTopup()
  }
  
  func topupDidClose() {
    router?.detachTopup()
  }
  
  func topupDidFinish() {
    router?.detachTopup()
  }
}
