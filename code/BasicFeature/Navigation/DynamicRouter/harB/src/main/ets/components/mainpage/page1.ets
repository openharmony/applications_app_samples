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
import { RouterModule } from "RouterModule/src/main/ets/utils/RouterModule";

@Builder
export function harBuilder(value: object) {
  NavDestination(){
    Column(){
      Button($r("app.string.to_index"), { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          let routerName = "HapA_Router";
          RouterModule.clear(routerName);
        })
      Button($r("app.string.to_hara_page1"), { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          let url = "HarA/src/main/ets/components/mainpage/page1/HapA_Router-HarA_Page1_Builder";
          RouterModule.push(url);
        })
      Button($r("app.string.to_hara_page2"), { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          let url = "HarA/src/main/ets/components/mainpage/page2/HapA_Router-HarA_Page2_Builder";
          RouterModule.push(url);
        })
      Button($r("app.string.to_hara_page3"), { stateEffect: true, type: ButtonType.Capsule })
        .width('80%')
        .height(40)
        .margin(20)
        .onClick(() => {
          let url = "HarA/src/main/ets/components/mainpage/page3/HapA_Router-HarA_Page3_Builder";
          RouterModule.push(url);
        })
    }.width('100%').height('100%')
  }.title('HarB_Page1')
  .onBackPressed(() => {
    RouterModule.pop("HapA_Router");
    return true;
  })
}

let builderName = 'HarB_Page1_Builder';
if (!RouterModule.getBuilder(builderName)) {
  let builder: WrappedBuilder<[object]> = wrapBuilder(harBuilder);
  RouterModule.registerBuilder(builderName, builder);
}
