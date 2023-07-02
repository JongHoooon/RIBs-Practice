//
//  CardOnFileDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/01.
//

import ModernRIBs

protocol CardOnFileDashboardDependency: Dependency {
  var cardsOnFileRepository: CardOnFileRepository { get }
}

final class CardOnFileDashboardComponent: Component<CardOnFileDashboardDependency>,
                                          CardOnFileDashboardInteractorDependency{
  
  var cardOnFileRepository: CardOnFileRepository { dependency.cardsOnFileRepository }
}

// MARK: - Builder

protocol CardOnFileDashboardBuildable: Buildable {
  func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting
}

final class CardOnFileDashboardBuilder: Builder<CardOnFileDashboardDependency>,
                                        CardOnFileDashboardBuildable {
  
  override init(dependency: CardOnFileDashboardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: CardOnFileDashboardListener) -> CardOnFileDashboardRouting {
    let component = CardOnFileDashboardComponent(dependency: dependency)
    let viewController = CardOnFileDashboardViewController()
    let interactor = CardOnFileDashboardInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return CardOnFileDashboardRouter(interactor: interactor, viewController: viewController)
  }
}
