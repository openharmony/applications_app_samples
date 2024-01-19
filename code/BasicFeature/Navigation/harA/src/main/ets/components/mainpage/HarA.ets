/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import {RouterModule} from "RouterModule/src/main/ets/components/mainpage/RouterModule"

@Builder
export function harBuilder(value: object) {
  NavDestination(){
    Column(){
      Button('ToIndex', { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          RouterModule.clear("HapA_Router")
        })
      Button('ToHarB', { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          RouterModule.push("harB/src/main/ets/components/mainpage/HarB-HapA_Router-HarB_Builder")
        })
    }.width('100%').height('100%')
  }.title('HarA')
  .onBackPressed(() => {
    RouterModule.pop("HapA_Router")
    return true
  })
}

export function harInit(){
  if(!RouterModule.getBuilder('HarA_Builder')){
    let builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder)
    RouterModule.registerBuilder('HarA_Builder', builder)
  }
}

// 自执行函数，在首次引用时触发，将builder注册到RouterModule中
harInit()