# RIBs-Practice

## What are RIBs For?

> RIBs는 Uber의 cross-platform 아키텍처 프레임워크입니다. 많은 nested state를 포함하는 큰 규모의 모바일 어플리케이션을 위해 설계됐습니다.

### Cross-Platform 협업 장려

iOS 와 Android 에서 앱의 복잡한 부분은 비슷합니다. RIBs는 iOS와 Android 에서 비슷한 개발 패턴을 나타냅니다. iOS, Android 개발자들은 `공동 설계된 단일 아키텍처를 공유할 수 있습니다.`

### Global State & Decision 최소화

Global state의 변화는 예상하지 못한 동작을 유발하고 개발자가 Global state 변화의 완전한 영향력을 아는 것이 불가능합니다. RIBs는 잘 격리된 `개별 RIB 의 깊은 계층 구조 내에서 state 캡슐화하도록 권장`해 상태 문제를 방지합니다.

### Testability & Isolation

class 는 unit test 하기 쉬워야하고 격리(isolation)된 상태에서 추론해야 합니다. 각각 RIB 클래스에는 `고유한 책임`(i.e. routing, buisiness logic, view logic, creation of other RIB classes)이 있습니다. 또한 부모 RIB 의 로직은 대부분 `자식 RIB 의 로직으로부터 분리`됩니다. 따라서 RIB 클래스를 쉽게 테스트하고 독립적으로 추론할 수 있습니다.

### 개발자 생산성을 위한 도구

사소하지 않은 아키텍처 패턴을 채택하는 것은 강력한 도구가 없다면 대규모 어플리케이션으로 확장하기 힘듭니다. RIBs는 코드 생성, static analysis, runtime integration 와 관련된 `IDE 도구들을 제공`합니다. - 도구들은 팀의 개발자 생산성을 향상시킵니다.

### [Open-Closed Principle](https://ko.wikipedia.org/wiki/%EA%B0%9C%EB%B0%A9-%ED%8F%90%EC%87%84_%EC%9B%90%EC%B9%99)

개발자들은 `가능한 기존의 코드 수정없이 새로운 기능을 추가`할 수 있어야합니다. 이것은 RIBs를 사용할 때 몇군데에서 볼 수 있습니다. 예를 들어, 개발자는 부모 RIB을 거의 변경하지 않고 부모로부터 의존성이 필요한 복잡한 자식 RIB을 attach 하거나 build 할 수 있습니다. 

### 비지니스 로직의 구조화

앱의 비지니스 로직 구조는 UI 구조를 엄격하게 미러링할 필요가 없습니다. 예를 들어, animation을 만들고 performance을 보여주기 위해, view 계층 구조는 RIB 계층 구조보다 더 얕기를 원할 수 있습니다. 또는 단일 기능 RIB은 UI의 서로 다른 위치에 나타나는 3 가지 view의 appearance를 제어할 수 있습니다.

### 분명한 계약(Explicit Contracts)

요구 사항은 컴파일 타임에 안전한 계약으로 선언되어야 합니다. 의존성과 ordering 의존성이 충족되지 않았다면 클래스를 컴파일하면 안 됩니다. 우리는 ReactiveX를 사용해 ordering dependency를 지정하고 type safe 의존성 주입(DI) 시스템을 사용하여 클래스 의존성을 나타내며 많은 DI 범위를 사용해 데이터 불변량 생성을 장려합니다.

<br><br>

## Parts Of a RIB

### Interactor

interactor는 `비지니스 로직을 포함`합니다. Rx 구독, 상태 변경 결정, data를 어디에 저장할지 결정, 어떤 RIB이 자식으로 붙어야하는지 결정합니다.

interactor에 의해 수행되는 모든 작업들은 lifecycle안에 제한되어야 합니다. 이렇게 하면 interactor가 비활성화됐지만 구독이 계속 실행돼 비지니스 로직 또는 UI 상태에 대한 원치 않은 업데이트가 발생하는 상황을 방지할 수 있습니다. 

### Router

router는 `interactor을 listen 하고 그 출력을 child RIB의 attaching & detaching 으로 번역`합니다. 

router는 3가지 이유로 존재합니다.

- router는 자식 interactor를 mock 처리하거나 그 존재에 신경 쓸 필요 없이 복잡한 interactor 로직을 쉽게 테스트할 수 있도록 해주는 Humble Object 역할을 합니다.
- router는 부모 interactor와 자식 interactor 사이의 추가적인 추상화 layer을 생섭합니다. 이로 인해 interator 간의 동기식 통신이 조금 더 어려워지고 RIB 간의 직접 연결 대신 반응형 통신의 채택이 권장됩니다.
- router는 interactor에 구현됐어야할 간단하고 반복적인 routing 로직이 포함되어 있습니다. 이 boilerplate code를 제외하면 interactor를 작게 유지하고 RIB에서 제공하는 핵심 비지니스 로직에 더 집중할 수 있습니다.

### Builder

builder의 책임은 `모든 RIB의 구성 클래스와 각 RIB의 자식에 대한 builder를 인스턴스화`하는 것입니다. 

builder에서 클래스 생성 로직을 분리하면 iOS에서 mockablity 지원이 추가되고 나머지 RIB 코드는 DI 구현의 세부 사항과 무관하게 만들어줍니다. builder는 프로젝트에서 사용되는 DI 시스템을 알고있는 RIB의 유일한 부분입니다. 다른 builder를 구현하면 다른 DI 메카니즘을 사용하는 프로젝트에서 RIB 코드를 재사용할 수 있습니다.

### Presenter

presenter는 `비지니스 모델을 뷰 모델로 또는 그 반대로 변역`하는 stateless 클래스입니다. 뷰 모델 변환 테스트를 용이하게 하는 데 사용할 수 있습니다. 그러나 종종 이 번역은 너무 사소해서 전용 presenter 클래스의 생성을 보증하지는 않습니다. 만약 presenter가 생략되면 뷰 모델 번역은 view(controller) 또는 interactor의 책임이 됩니다.

### View(Controller)

view는 `UI를 빌드하고 업데이트`합니다. UI 구성요소를 인스턴스화 및 배치, 사용자 상호 작용 처리, 데이터로 UI 구성 요서 채우기 및 애니메이션이 포함됩니다. view는 가능한 dumb로 설계 됩니다. view는 정보만 보여줍니다. 일반적으로 unit test가 필요한 코드는 포함되지 않습니다.

### Componenet

component는 RIB 의존성을 관리하기 위해 사용됩니다. RIB을 구성하는 다른 유닛들을 인스턴스화하여 빌더를 돕습니다. component RIB을 빌드하기 위해 필요한 외부 의존성에 대한 엑세스를 제공하고 RIB 자체에서 생성한 의존성을 소유하고 다른 RIB에서 이에 대한 엑세스를 제어합니다. 자식이 부모 RIB의 의존성에 접근할 수 있도록 부모 RIB의 component는 일반적으로 자식 RIB의 빌더로 주입됩니다.


<br><br>

## State Management

어플리케이션 상태는 주로 현재 RIB 트리에 연결된 RIB에 의해 관리되고 표시됩니다.

<br><br>

## Communication Between RIBs

### Downward

- rx stream을 사용해 전달
- 자식 RIB의 build() method에 파라미터로 전달(이 경우 자식의 lifecycle 동안 불변값이다.) 

### Upward

- listener interface를 통해 전달합니다. (부모가 자식보다 오래살아서)
- 부모가 자식의 Rx stream을 직접 구독하는대신 이 패턴을 사용하면 몇가지 이점이 있다.
  - 메모리 누수 방지
  - 어떤 자식이 연결되었는지 알지 못한 채 부모를 작성, 테스트 및 유지 관리할 수 있도록 한다.
  - 자식 RIB을 연결/분리하는 데 필요한 ceremocy의 양을 줄인다.

## 참고

- https://github.com/uber/RIBs
- https://github.com/nsoojin/MiniSuperApp-fastcampus
