//
//  TopupInteractor.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/05.
//

import ModernRIBs
import RIBsUtil
import FinanceEntity
import FinanceRepository
import CombineUtil
import SuperUI

protocol TopupRouting: Routing {
  func cleanupViews()
  
  func attachAddPaymentMethod(closeButtonType: DismissButtonType)
  func detachAddPaymentMethod()
  
  func attachEnterAmount()
  func detachEnterAmount()
  
  func attachCardOnFile(paymentMethods: [PaymentMethod])
  func detachCardOnFile()
  
  func popToRoot()
}

protocol TopupListener: AnyObject {
  func topupDidClose()
  func topupDidFinish()
}

protocol TopupInteractorDependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var paymentMethodStream: CurrentValuePublisher<PaymentMethod> { get }
}

final class TopupInteractor: Interactor,
                             TopupInteractable,
                             AdaptivePresentationControllerDelegate {
  
  let presentationDelegateProxy: AdaptivePresentationControllerDelegateProxy
  
  private var isEnterAmountRoot: Bool = false
  
  private var paymentMehods: [PaymentMethod] {
    dependency.cardOnFileRepository.cardOnFile.value
  }
  
  weak var router: TopupRouting?
  weak var listener: TopupListener?

  private let dependency: TopupInteractorDependency
  
  init(
    dependency: TopupInteractorDependency
  ) {
    self.presentationDelegateProxy = AdaptivePresentationControllerDelegateProxy()
    self.dependency = dependency
    super.init()
    self.presentationDelegateProxy.delegate = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    if let card = dependency.cardOnFileRepository.cardOnFile.value.first {
      // 금액 입력 화면
      isEnterAmountRoot = true
      dependency.paymentMethodStream.send(card)
      router?.attachEnterAmount()
    } else {
      // 카드 추가 화면
      isEnterAmountRoot = false
      router?.attachAddPaymentMethod(closeButtonType: .close)
    }
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    router?.cleanupViews()
    // TODO: Pause any business logic.
  }
  
  func presentationControllerDidDismiss() {
    listener?.topupDidClose()
  }
  
  func addPaymentMethodDidTapClose() {
    router?.detachAddPaymentMethod()
    
    if isEnterAmountRoot == false {
      // viewLess riblet이라 부모가 직접 present한 view가 없어서 부모가 dismiss 처리 하지 않는다.
      listener?.topupDidClose()
    }
  }
  
  func addPaymentMethodDidAddCard(paymentMethod: PaymentMethod) {
    dependency.paymentMethodStream.send(paymentMethod)
    
    if isEnterAmountRoot == true {
      router?.popToRoot()
    } else {
      isEnterAmountRoot = true
      router?.attachEnterAmount()
    }
  }
  
  func enterAmountDidTapClose() {
    router?.detachEnterAmount()
    listener?.topupDidClose()
  }
  
  func enterAmountDidTapPaymentMethod() {
    router?.attachCardOnFile(paymentMethods: paymentMehods)
  }
  
  func enterAmountDidFinishTopup() {
    listener?.topupDidFinish()
  }
  
  func cardOnFileDidTapClose() {
    router?.detachCardOnFile()
  }
  
  func cardOnFileDidTapAddCard() {
    router?.attachAddPaymentMethod(closeButtonType: .back)
  }
  
  func CardOnFileDidSelect(at index: Int) {
    if let selected = paymentMehods[safe: index] {
      dependency.paymentMethodStream.send(selected)
    }
    router?.detachCardOnFile()
  }
}
