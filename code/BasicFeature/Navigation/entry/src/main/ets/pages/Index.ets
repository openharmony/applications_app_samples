import {RouterModule} from "RouterModule/src/main/ets/components/mainpage/RouterModule"

@Entry
@Component
struct HapA {
  @State HapA_Router: NavPathStack = new NavPathStack()
  aboutToAppear() {
    if(!this.HapA_Router){
      this.HapA_Router = new NavPathStack()
    }
    RouterModule.createRouter('HapA_Router', this.HapA_Router)
  }

  @Builder
  routerMap(name: string, param:object) {
    RouterModule.getBuilder(name).builder(param)
  }

  build() {
    Navigation(this.HapA_Router) {
      Button('ToIndex', { stateEffect: true, type: ButtonType.Capsule})
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(()=>{
          RouterModule.push("harA/src/main/ets/components/mainpage/HarA-HapA_Router-HarA_Builder")
        })
      Button('ToHarB', { stateEffect: true, type: ButtonType.Capsule})
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(()=>{
          RouterModule.push("harB/src/main/ets/components/mainpage/HarB-HapA_Router-HarB_Builder")
        })
    }
    .title('NavIndex')
    .navDestination(this.routerMap)
  }
}