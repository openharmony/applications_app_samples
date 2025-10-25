/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

// [Start onResult]
// 在UIAbility中使用
import { uiObserver } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

// [StartExclude onResult]
const DOMAIN = 0x0000;
@Component
struct PageOne {
  build() {
    NavDestination() {
      Text('pageOne')
    }.title('pageOne')
  }
}
// [EndExclude onResult]
// callbackFunc是开发者定义的监听回调函数
function callBackFunc(info: uiObserver.NavDestinationSwitchInfo) {
  // [StartExclude onResult]
  hilog.info(DOMAIN, 'testTag', 'testTag navDestinationSwitch from: ', JSON.stringify(info.from), 'to:',
    JSON.stringify(info.to));
  // [EndExclude onResult]
};
// 看日志
// [StartExclude onResult]
@Entry
@Component
struct Index {
  private stack: NavPathStack = new NavPathStack();
  // [EndExclude onResult]
  uiContext: UIContext | null = null;
  // [StartExclude onResult]
  @Builder
  PageBuilder(name: string) {
    PageOne()
  };
  aboutToAppear() {
    // [EndExclude onResult]
    uiObserver.on('navDestinationSwitch', this.uiContext, callBackFunc)
    // [StartExclude onResult]
  }
  // [EndExclude onResult]
  // [End onResult]
  aboutToDisappear() {
    uiObserver.off('navDestinationSwitch', this.uiContext, callBackFunc)
  }

  build() {
    Column() {
      Navigation(this.stack) {
        Button('push').onClick(() => {
          this.stack.pushPath({ name: 'pageOne' });
        })
      }
      .title('Navigation')
      .navDestination(this.PageBuilder)
    }
    .width('100%')
    .height('100%')
  }
}