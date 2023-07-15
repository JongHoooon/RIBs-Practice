//
//  AddPaymentMethodInteractor.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/01.
//

import ModernRIBs
import Combine
import FinanceEntity
import FinanceRepository

protocol AddPaymentMethodRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol AddPaymentMethodPresentable: Presentable {
  var listener: AddPaymentMethodPresentableListener? { get set }
  // TODO: Declare methods the interactor can invoke the presenter to present data.
}

public protocol AddPaymentMethodListener: AnyObject {
  func addPaymentMethodDidTapClose()
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod)
}

protocol AddPaymentMethodInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
}

final class AddPaymentMethodInteractor: PresentableInteractor<AddPaymentMethodPresentable>,
                                        AddPaymentMethodInteractable,
                                        AddPaymentMethodPresentableListener {
  
  weak var router: AddPaymentMethodRouting?
  weak var listener: AddPaymentMethodListener?
  
  private let dependency: AddPaymentMethodInteractorDependency
  
  private var cancellable: Set<AnyCancellable>
  
  init(
    presenter: AddPaymentMethodPresentable,
    dependency: AddPaymentMethodInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellable = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    // TODO: Implement business logic here.
  }
  
  override func willResignActive() {
    super.willResignActive()
    // TODO: Pause any business logic.
  }
  
  func didClose() {
    listener?.addPaymentMethodDidTapClose()
  }
  
  func didTapConfirm(with number: String, cvc: String, expiry: String) {
    let info = AddPaymentMethodInfo(number: number, cvc: cvc, expiration: expiry)
    dependency.cardOnFileRepository.addCard(info: info)
      .sink(
        receiveCompletion: { _ in },
        receiveValue: { [weak self] method in
          self?.listener?.addPaymentMethodDidAddCard(paymentMethod: method)
        }
      ).store(in: &cancellable)
  }
}
