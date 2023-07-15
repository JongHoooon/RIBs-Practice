#  MiniSuperApp

## Riblet 구성 요소

### Router: 

> view, view controller 간의 routing 담당
> 자식을 붙이고 싶으면 자식 riblet의 builder를 만들고 build method 통해 router을 받아와 attachChild하고 view controller를 띄운다.

### Interactor

> logic이 들어가는 곳으로 두뇌같은 역할

### Builder

> Riblet 객체들을 생성, router을 return 한다

### View Controller

