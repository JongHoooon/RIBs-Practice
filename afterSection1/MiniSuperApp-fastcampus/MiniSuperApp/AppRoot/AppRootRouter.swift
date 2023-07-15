import ModernRIBs

protocol AppRootInteractable: Interactable,
                              AppHomeListener,
                              FinanceHomeListener,
                              ProfileHomeListener {
  var router: AppRootRouting? { get set }
  var listener: AppRootListener? { get set }
}

protocol AppRootViewControllable: ViewControllable {
  func setViewControllers(_ viewControllers: [ViewControllable])
}

final class AppRootRouter: LaunchRouter<AppRootInteractable, AppRootViewControllable>, AppRootRouting {
  
  private let appHome: AppHomeBuildable
  private let financeHome: FinanceHomeBuildable
  private let profileHome: ProfileHomeBuildable
  
  private var appHomeRouting: ViewableRouting?
  private var financeHomeRouting: ViewableRouting?
  private var profileHomeRouting: ViewableRouting?
  
  init(
    interactor: AppRootInteractable,
    viewController: AppRootViewControllable,
    appHome: AppHomeBuildable,
    financeHome: FinanceHomeBuildable,
    profileHome: ProfileHomeBuildable
  ) {
    self.appHome = appHome
    self.financeHome = financeHome
    self.profileHome = profileHome
    
    super.init(interactor: interactor, viewController: viewController)
    interactor.router = self
  }
  
  func attachTabs() {
    let appHomeRouting = appHome.build(withListener: interactor)
    let financeHomeRouting = financeHome.build(withListener: interactor)
    let profileHomeRouting = profileHome.build(withListener: interactor)
    
    /// ribs 트리를 만들어 riblet들의 reference를 유지, interActor의 lifecycle 관련 메소드 호출
    attachChild(appHomeRouting)
    attachChild(financeHomeRouting)
    attachChild(profileHomeRouting)
    
    /// viewController를 띄운다
    let viewControllers = [
      NavigationControllerable(root: appHomeRouting.viewControllable),
      NavigationControllerable(root: financeHomeRouting.viewControllable),
      profileHomeRouting.viewControllable
    ]
    
    viewController.setViewControllers(viewControllers)
  }
}
