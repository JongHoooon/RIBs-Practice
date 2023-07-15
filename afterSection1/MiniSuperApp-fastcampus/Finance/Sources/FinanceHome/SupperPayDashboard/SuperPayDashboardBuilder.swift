//
//  SuperPayDashboardBuilder.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/06/27.
//

import Foundation
import ModernRIBs
import CombineUtil

protocol SuperPayDashboardDependency: Dependency {
  var balance: ReadOnlyCurrentValuePublisher<Double> { get }
}

final class SuperPayDashboardComponent: Component<SuperPayDashboardDependency>,
                                        SuperPayDashboardInteractorDependency {
  
  // builder 에서 새로만들 거나, 부모한테 받든가 -> 화면의 일부 담당(UI그리는) -> 부모로 부터 받는게 적당
  var balance: ReadOnlyCurrentValuePublisher<Double> { dependency.balance }
  var balanceFormatter: NumberFormatter { Formatter.balanceFormatter }

  
  // TODO: Declare 'fileprivate' dependencies that are only used by this RIB.
}

// MARK: - Builder

protocol SuperPayDashboardBuildable: Buildable {
  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting
}

final class SuperPayDashboardBuilder: Builder<SuperPayDashboardDependency>, SuperPayDashboardBuildable {
  
  override init(dependency: SuperPayDashboardDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: SuperPayDashboardListener) -> SuperPayDashboardRouting {
    let component = SuperPayDashboardComponent(dependency: dependency)
    let viewController = SuperPayDashboardViewController()
    let interactor = SuperPayDashboardInteractor(
      presenter: viewController,
      dependency: component
    )
    interactor.listener = listener
    return SuperPayDashboardRouter(interactor: interactor, viewController: viewController)
  }
}
