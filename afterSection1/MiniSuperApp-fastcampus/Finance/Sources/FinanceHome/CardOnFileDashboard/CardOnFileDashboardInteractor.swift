//
//  CardOnFileDashboardInteractor.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/29.
//

import ModernRIBs
import Combine
import FinanceRepository
import CombineUtil

protocol CardOnFileDashboardRouting: ViewableRouting {
  // TODO: Declare methods the interactor can invoke to manage sub-tree via the router.
}

protocol CardOnFileDashboardPresentable: Presentable {
  var listener: CardOnFileDashboardPresentableListener? { get set }
  
  func update(with viewModels: [PaymentMethodViewModel])
}

protocol CardOnFileDashboardListener: AnyObject { // 부모에게 이벤트 전달
  func cardOnFileDashboardDidTapAddPaymentMethod()
}

protocol CardOnFileDashBaordInteractorDependency {
  var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardInteractor: PresentableInteractor<CardOnFileDashboardPresentable>,
                                           CardOnFileDashboardInteractable,
                                           CardOnFileDashboardPresentableListener {
  
  weak var router: CardOnFileDashboardRouting?
  weak var listener: CardOnFileDashboardListener?
  
  private let dependency: CardOnFileDashBaordInteractorDependency
  
  private var cancellables: Set<AnyCancellable>
  
  init(
    presenter: CardOnFileDashboardPresentable,
    dependency: CardOnFileDashBaordInteractorDependency
  ) {
    self.dependency = dependency
    self.cancellables = .init()
    super.init(presenter: presenter)
    presenter.listener = self
  }
  
  override func didBecomeActive() {
    super.didBecomeActive()
    
    dependency.cardsOnFileRepository.cardOnFile.sink { methods in
      let viewModels = methods
        .prefix(5)
        .map(PaymentMethodViewModel.init)
      self.presenter.update(with: viewModels)
    }.store(in: &cancellables)
  }
  
  override func willResignActive() {
    super.willResignActive()
    
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
  }
  
  func didTapAddPaymentMethod() {
    listener?.cardOnFileDashboardDidTapAddPaymentMethod()
  }
}
