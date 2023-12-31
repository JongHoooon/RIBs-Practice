//
//  EnterAmountMock.swift
//  
//
//  Created by JongHoon on 2023/07/23.
//

import Foundation
import CombineUtil
import FinanceEntity
import FinanceRepository
import FinanceRepositoryTestSupport
import CombineSchedulers
@testable import TopupImp

final class EnterAmountPresentableMock: EnterAmountPresentable {
  
  var listener: TopupImp.EnterAmountPresentableListener?
  
  var updateSelectedPaymentMethodCallCount = 0
  var updateSelectedPaymentMethodViewModel: SelectedPaymentMethodViewModel?
  func updateSelectedPaymentMethod(with viewModel: SelectedPaymentMethodViewModel) {
    updateSelectedPaymentMethodCallCount += 1
    updateSelectedPaymentMethodViewModel = viewModel
  }
  
  var startLoadingCallCount = 0
  func startLoading() {
    startLoadingCallCount += 1
  }
  
  var stopLoadingCallCount = 0
  func stopLoading() {
    stopLoadingCallCount += 1
  }
  
  init() {
    
  }
}

final class EnterAmountDependencyMock: EnterAmountInteractorDependency {
  var mainQueue: CombineSchedulers.AnySchedulerOf<DispatchQueue> { .immediate }
  
  var selectedPaymentMethodSubject = CurrentValuePublisher<PaymentMethod>(
    PaymentMethod(
      id: "",
      name: "",
      digits: "",
      color: "",
      isPrimary: false
    )
  )
  
  var selectedPaymentMethod: ReadOnlyCurrentValuePublisher<FinanceEntity.PaymentMethod> { selectedPaymentMethodSubject }
  var superPayRepository: SuperPayRepository = SuperPayRepositoryMock()
}

final class EnterAmountListenerMock: EnterAmountListener {
  
  var enterAmountDidTapCloseCallCount = 0
  func enterAmountDidTapClose() {
    enterAmountDidTapCloseCallCount += 1
  }
  
  var enterAmountDidTapPaymentMethodCallCount = 0
  func enterAmountDidTapPaymentMethod() {
    enterAmountDidTapPaymentMethodCallCount += 1
  }
  
  var enterAmountDidFinishTopupCallCount = 0
  func enterAmountDidFinishTopup() {
    enterAmountDidFinishTopupCallCount += 1
  }
  
}
