import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  // TODO: Declare the set of dependencies required by this RIB, but cannot be
  // created by this RIB.
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>,
                                  SuperPayDashboardDependency,
                                  CardOnFileDashboardDependency,
                                  AddPaymentMethodDependency,
                                  TopupDependency {
      
  var balance: ReadOnlyCurrentValuePublisher<Double> { balancePublisher }  // 잔액 읽기 전용
  private let balancePublisher: CurrentValuePublisher<Double> // 잔액 업데이트시 사용
  
  var cardOnFileRepository: CardOnFileRepository
  
  let topupBaseViewController: ViewControllable
  
  init(
    dependency: FinanceHomeDependency,
    balance: CurrentValuePublisher<Double>,
    cardOnFileRepository: CardOnFileRepository,
    topupBaseViewController: ViewControllable
  ) {
    self.balancePublisher = balance
    self.cardOnFileRepository = cardOnFileRepository
    self.topupBaseViewController = topupBaseViewController
    super.init(dependency: dependency)
  }
}

// MARK: - Builder

protocol FinanceHomeBuildable: Buildable {
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting
}

final class FinanceHomeBuilder: Builder<FinanceHomeDependency>, FinanceHomeBuildable {
  
  override init(dependency: FinanceHomeDependency) {
    super.init(dependency: dependency)
  }
  
  func build(withListener listener: FinanceHomeListener) -> FinanceHomeRouting {
    let balancePublisher = CurrentValuePublisher<Double>(10000)
    
    let viewController = FinanceHomeViewController()
    
    let component = FinanceHomeComponent(
        dependency: dependency,
        balance: balancePublisher,
        cardOnFileRepository: CardOnFileRepositoryImp(),
        topupBaseViewController: viewController
    )
    
    let interactor = FinanceHomeInteractor(presenter: viewController)
    interactor.listener = listener
    
    let superPayDashboardBuilder = SuperPayDashboardBuilder(dependency: component)
    let cardOnFileDashboardBuilder = CardOnFileDashboardBuilder(dependency: component)
    let addPaymentMethodBuildable = AddPaymentMethodBuilder(dependency: component)
    let topupBuildable = TopupBuilder(dependency: component)
    
    return FinanceHomeRouter(
      interactor: interactor,
      viewController: viewController,
      superPayDashboardBuildable: superPayDashboardBuilder,
      cardOnFileDashboardBuildable: cardOnFileDashboardBuilder,
      addPaymentMethodBuildable: addPaymentMethodBuildable,
      topupBuildable: topupBuildable
    )
  }
}
