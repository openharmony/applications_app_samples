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

import {RouterModule} from "RouterModule/src/main/ets/components/mainpage/RouterModule";

@Entry
@Component
struct HapA {
  @State hapARouter: NavPathStack = new NavPathStack();

  @State buttonNameA: string = "ToHarA";
  @State buttonNameB: string = "ToHarB";

  aboutToAppear() {
    if(!this.hapARouter){
      this.hapARouter = new NavPathStack();
    };
    let routerName = "HapA_Router";
    RouterModule.createRouter(routerName, this.hapARouter);
  };

  @Builder
  routerMap(routerName: string, param:object) {
    RouterModule.getBuilder(routerName).builder(param);
  };

  build() {
    Navigation(this.hapARouter) {
      Button(this.buttonNameA, { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          let url = "harA/src/main/ets/components/mainpage/HarA-HapA_Router-HarA_Builder";
          RouterModule.push(url);
        })
      Button(this.buttonNameB, { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          let url = "harB/src/main/ets/components/mainpage/HarB-HapA_Router-HarB_Builder";
          RouterModule.push(url);
        })
    }
    .title('NavIndex')
    .navDestination(this.routerMap);
  }
}