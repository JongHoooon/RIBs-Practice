//
//  EnterAmountInteractorTests.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/23.
//

@testable import TopupImp
import XCTest
import FinanceEntity
import FinanceRepositoryTestSupport

final class EnterAmountInteractorTests: XCTestCase {
  
  private var sut: EnterAmountInteractor!
  private var presenter: EnterAmountPresentableMock!
  private var dependency: EnterAmountDependencyMock!
  private var listener: EnterAmountListenerMock!
  
  private var repository: SuperPayRepositoryMock! {
    dependency.superPayRepository as? SuperPayRepositoryMock
  }
  
  // TODO: declare other objects and mocks you need as private vars
  
  override func setUp() {
    super.setUp()
    
    self.presenter = EnterAmountPresentableMock()
    self.dependency = EnterAmountDependencyMock()
    self.listener = EnterAmountListenerMock()
    
    sut = EnterAmountInteractor(
      presenter: presenter,
      dependency: dependency
    )
    
    sut.listener = self.listener
  }
  
  // MARK: - Tests
  
  /*
   given: 테스트 환경 설정
   when:  실행
   then:  예상하는 행동을 했는지 검증
   */
  
  func testActivate() {
    // given
    let paymnetMethod = PaymentMethod(
      id: "id_0",
      name: "name_0",
      digits: "9999",
      color: "#13ABE8FF",
      isPrimary: false
    )
    dependency.selectedPaymentMethodSubject.send(paymnetMethod)
    
    // when
    sut.activate()
    
    // then
    XCTAssertEqual(presenter.updateSelectedPaymentMethodCallCount, 1)
    XCTAssertEqual(presenter.updateSelectedPaymentMethodViewModel?.name, "name_0 9999")
    XCTAssertNotNil(presenter.updateSelectedPaymentMethodViewModel?.image)
  }
  
  func testTopupWithValidAmount() {
    // given
    let paymnetMethod = PaymentMethod(
      id: "id_0",
      name: "name_0",
      digits: "9999",
      color: "#13ABE8FF",
      isPrimary: false
    )
    dependency.selectedPaymentMethodSubject.send(paymnetMethod)
    
    // when
    sut.didTapTopup(with: 1_000_000)
    
    // then
    XCTAssertEqual(presenter.startLoadingCallCount, 1)
    XCTAssertEqual(presenter.stopLoadingCallCount, 1)
    XCTAssertEqual(repository.topupCallCount, 1)
    XCTAssertEqual(repository.paymentMethodID, "id_0")
    XCTAssertEqual(repository.topupAmount, 1_000_000)
    XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 1)
  }
    
  func testTopupWithFailure() {
    // given
    let paymnetMethod = PaymentMethod(
      id: "id_0",
      name: "name_0",
      digits: "9999",
      color: "#13ABE8FF",
      isPrimary: false
    )
    dependency.selectedPaymentMethodSubject.send(paymnetMethod)
    repository.shouldTopupSucced = false // 실패 검증
    
    // when
    sut.didTapTopup(with: 1_000_000)
    
    // then
    XCTAssertEqual(presenter.startLoadingCallCount, 1)
    XCTAssertEqual(presenter.stopLoadingCallCount, 1) // 실패시에도 불리는지 확인
    XCTAssertEqual(listener.enterAmountDidFinishTopupCallCount, 0)
  }
  
  func testDidTapClose() {
    // given
    
    // when
    sut.didTapClose()
    
    // then
    XCTAssertEqual(listener.enterAmountDidTapCloseCallCount, 1)
  }
  
  func testDidTapPaymentMethod() {
    // given
    
    // when
    sut.didTapPaymentMethod()
    
    // then
    XCTAssertEqual(listener.enterAmountDidTapPaymentMethodCallCount, 1)
  }
}
