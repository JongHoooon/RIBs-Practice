import ModernRIBs

protocol FinanceHomeDependency: Dependency {
  var cardOnFileRepository: CardOnFileRepository { get }
  var superPayRepository: SuperPayRepository { get }
}

final class FinanceHomeComponent: Component<FinanceHomeDependency>,
                                  SuperPayDashboardDependency,
                                  CardOnFileDashboardDependency,
                                  AddPaymentMethodDependency,
                                  TopupDependency {
  
  var cardOnFileRepository: CardOnFileRepository { dependency.cardOnFileRepository }
  var superPayRepository: SuperPayRepository { dependency.superPayRepository }
  var balance: ReadOnlyCurrentValuePublisher<Double> { superPayRepository.balance }  // 잔액 읽기 전용
//  private let balancePublisher: CurrentValuePublisher<Double> // 잔액 업데이트시 사용
  
  let topupBaseViewController: ViewControllable
  
  init(
    dependency: FinanceHomeDependency,
//    balance: CurrentValuePublisher<Double>, -> repository로 대체
//    cardOnFileRepository: CardOnFileRepository, -> root 에서 생성하게 수정
//    superPayRepository: SuperPayRepository,
    topupBaseViewController: ViewControllable
  ) {
//    self.balancePublisher = balance
//    self.cardOnFileRepository = cardOnFileRepository
//    self.superPayRepository = superPayRepository
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
//    let balancePublisher = CurrentValuePublisher<Double>(10000)
    
    let viewController = FinanceHomeViewController()
    
    let component = FinanceHomeComponent(
        dependency: dependency,
//        balance: balancePublisher,
//        cardOnFileRepository: CardOnFileRepositoryImp(),
//        superPayRepository: SuperPayRepositoryImp(),
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
