//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/05.
//

import ModernRIBs
import FinanceRepository
import AddPaymentMethod
import CombineUtil
import FinanceEntity
import Topup

public protocol TopupDependency: Dependency {
  
  // topup riblet을 띄운 view가 지정해준 view
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
  var addPaymentMethodBuildable: AddPaymentMethodBuildable { get }
}

final class TopupComponent: Component<TopupDependency>,
                            TopupInteractorDependency,
                            EnterAmountDependency,
                            CardOnFileDependency {
  
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  fileprivate var topupBaseViewController: ViewControllable { dependency.topupBaseViewController }
  
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  var addPaymentMethodBuildable: AddPaymentMethodBuildable {
    dependency.addPaymentMethodBuildable
  }
  
  init(
    dependency: TopupDependency,
    paymentMethodsStream: CurrentValuePublisher<PaymentMethod>
  ) {
    self.paymentMethodStream = paymentMethodsStream
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

public final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  public override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  public func build(withListener listener: TopupListener) -> Routing {
    let paymentMethodStream = CurrentValuePublisher(
      PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false)
    )
    
    let component = TopupComponent(
      dependency: dependency,
      paymentMethodsStream: paymentMethodStream
    )
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let enterAmountBuilder = EnterAmountBuilder(dependency: component)
    let cardOnFileBuilder = CardOnFileBuilder(dependency: component)

    return TopupRouter(
      interactor: interactor,
      viewController: component.topupBaseViewController,
      addPaymentMethodBuildable: component.addPaymentMethodBuildable,
      enterAmountBuildable: enterAmountBuilder,
      cardOnFileBuildable: cardOnFileBuilder
    )
  }
}
