import {RouterModule} from "RouterModule/src/main/ets/components/mainpage/RouterModule"

@Builder
export function HarA_Builder(value: object) {
  NavDestination(){
    Column(){
      Button('ToIndex', { stateEffect: true, type: ButtonType.Capsule})
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(()=>{
          RouterModule.clear("HapA_Router")
        })
      Button('ToHarB', { stateEffect: true, type: ButtonType.Capsule})
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(()=>{
          RouterModule.push("harB/src/main/ets/components/mainpage/HarB-HapA_Router-HarB_Builder")
        })
    }.width('100%').height('100%')
  }.title('HarA')
  .onBackPressed(() =>{
    RouterModule.pop("HapA_Router")
    return true
  })
}

export function HarA_Init(){
  if(!RouterModule.getBuilder('HarA_Builder')){
    let builder: WarppedBuider<[object]> = warpperBuider(HarA_Builder)
    RouterModule.registerBuilder('HarA_Builder', builder)
  }
}

//自执行函数，在首次引用时出发，将builder注册到RouterModule中
HarA_Init()