//
//  TopupBuilder.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/07.
//

import ModernRIBs

protocol TopupDependency: Dependency {
  
  // topup riblet을 띄운 view가 지정해준 view
  var topupBaseViewController: ViewControllable { get }
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class TopupComponent: Component<TopupDependency>,
                            TopupInteractorDependency,
                            AddPaymentMethodDependency,
                            EnterAmountDependency,
                            CardOnFileDependency {
  
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  fileprivate var TopupViewController: ViewControllable {
    return dependency.topupBaseViewController
  }
  
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<PaymentMethod> { paymentMethodStream }
  let paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  
  init(
    dependency: TopupDependency,
    paymentMethodStream: CurrentValuePublisher<PaymentMethod>
  ) {
    self.paymentMethodStream = paymentMethodStream
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol TopupBuildable: Buildable {
  func build(withListener listener: TopupListener) -> TopupRouting
}

final class TopupBuilder: Builder<TopupDependency>, TopupBuildable {
  
  override init(dependency: TopupDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: TopupListener) -> TopupRouting {
    let paymentMethodStream = CurrentValuePublisher(
      PaymentMethod(id: "", name: "", digits: "", color: "", isPrimary: false)
    )
    let component = TopupComponent(
      dependency: dependency,
      paymentMethodStream: paymentMethodStream
    )
    let interactor = TopupInteractor(dependency: component)
    interactor.listener = listener
    
    let addPaymentMethodBuildable = AddPaymentMethodBuilder(dependency: component)
    let enterAmountBuildable = EnterAmountBuilder(dependency: component)
    let cardOnFileBuildable = CardOnFileBuilder(dependency: component)
    
    return TopupRouter(
      interactor: interactor,
      viewController: component.TopupViewController,
      addPaymentMethodBuildable: addPaymentMethodBuildable,
      enterAmountBuildable: enterAmountBuildable,
      cardOnFileBuildable: cardOnFileBuildable
    )
  }
}
