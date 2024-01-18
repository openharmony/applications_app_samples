import {RouterModule} from "RouterModule/src/main/ets/components/mainpage/RouterModule"

@Builder
export function HarB_Builder(value: object) {
  NavDestination(){
    Column(){
      Button('ToIndex', { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(()=>{
          RouterModule.clear("HapA_Router")
        })
      Button('ToHarA', { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(()=>{
          RouterModule.push("harA/src/main/ets/components/mainpage/HarA-HapA_Router-HarA_Builder")
        })
    }.width('100%').height('100%')
  }.title('HarB')
  .onBackPressed(() =>{
    RouterModule.pop("HapA_Router")
    return true
  })
}

export function HarB_Init(){
  if(!RouterModule.getBuilder('HarB_Builder')){
    let builder: WarppedBuider<[object]> = warpperBuider(HarA_Builder)
    RouterModule.registerBuilder('HarB_Builder', builder)
  }
}

//自执行函数，在首次引用时出发，将builder注册到RouterModule中
HarB_Init()