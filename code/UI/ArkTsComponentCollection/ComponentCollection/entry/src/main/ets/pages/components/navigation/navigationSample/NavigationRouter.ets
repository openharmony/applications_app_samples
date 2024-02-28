/*
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { TitleBar } from '../../../../common/TitleBar';
import { RouterModule } from 'RouterModule/src/main/ets/utils/RouterModule';

@Entry
@Component
struct Index {
  @State hapARouter: NavPathStack = new NavPathStack();

  aboutToAppear() {
    import("@ohos/harA");
    import("@ohos/harB");
    if (!this.hapARouter) {
      this.hapARouter = new NavPathStack();
    }
    RouterModule.registRouter('HapA_Router', this.hapARouter);
  }

  @Builder
  routerMap(routerName: string, param: Object) {
    RouterModule.getBuilder(routerName).builder(param);
  }

  build() {
    Column() {
      Navigation(this.hapARouter) {
        TitleBar({ title: $r('app.string.navigation_router_title') })
        Column() {
          Button() {
            Text($r('app.string.navigation_router_har1'))
              .fontSize(16)
              .fontColor(Color.White)
          }
          .onClick(() => {
            RouterModule.push('HapA_Router', 'HarA_Builder');
          })
          .height(40)
          .width('88%')
          .backgroundColor('#007DFF')
          .borderRadius(20)
          .id('gotohar1')
        }
        .height('100%')
        .justifyContent(FlexAlign.Center)
      }
      .navDestination(this.routerMap)
      .height('100%')
      .hideTitleBar(true)
    }
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}