//
//  AppRootComponent.swift
//  MiniSuperApp
//
//  Created by JongHoon on 2023/07/22.
//

import Foundation
import AppHome
import FinanceHome
import ProfileHome
import FinanceRepository
import ModernRIBs
import TransportHome
import TransportHomeImp
import Topup
import TopupImp
import AddPaymentMethod
import AddPaymentMethodImp
import Network
import NetworkImp

final class AppRootComponent: Component<AppRootDependency>,
                              AppHomeDependency,
                              FinanceHomeDependency,
                              ProfileHomeDependency,
                              TransportHomeDependency,
                              TopupDependency,
                              AddPaymentMethodDependency {
  
  var cardOnFileRepository: CardOnFileRepository
  var superPayRepository: SuperPayRepository
  
  lazy var transportHomeBuildable: TransportHomeBuildable = {
    return TransportHomeBuilder(dependency: self)
  }()
  
  
  lazy var topupBuildable: TopupBuildable = {
    return TopupBuilder(dependency: self)
  }()
  
  var topupBaseViewController: ViewControllable { rootViewController.topViewControllable }
  
  private let rootViewController: ViewControllable
  
  lazy var addPaymentMethodBuildable: AddPaymentMethod.AddPaymentMethodBuildable = {
    return AddPaymentMethodBuilder(dependency: self)
  }()
  
  init(
    dependency: AppRootDependency,
    rootViewController: ViewControllable
  ) {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [SuperAppURLProtocol.self]
    
    setupURLProtocol()
    
    let network = NetworkImp(session: URLSession(configuration: config))
    
    self.cardOnFileRepository = CardOnFileRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    self.cardOnFileRepository.fetch()
    self.superPayRepository = SuperPayRepositoryImp(network: network, baseURL: BaseURL().financeBaseURL)
    self.rootViewController = rootViewController
    super.init(dependency: dependency)
  }
}
