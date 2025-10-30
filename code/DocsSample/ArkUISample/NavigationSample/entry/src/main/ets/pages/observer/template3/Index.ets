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

import { hilog } from '@kit.PerformanceAnalysisKit';
// [Start callbackFunc]
// 在UIAbility中使用
import { UIContext, uiObserver } from '@kit.ArkUI';

// callbackFunc是开发者定义的监听回调函数
function callBackFunc(info: uiObserver.NavDestinationSwitchInfo) {
  // [StartExclude callbackFunc]
  hilog.info(DOMAIN, 'testTag', 'testTag navDestinationSwitch from: ', JSON.stringify(info.from), 'to:',
    JSON.stringify(info.to));
  // [EndExclude callbackFunc]
};
// [StartExclude callbackFunc]
const DOMAIN = 0x0000;

@Component
struct PageOne {
  context: UIContext | null = null;

  aboutToAppear() {
    // [EndExclude callbackFunc]
    uiObserver.on('navDestinationSwitch', this.context, callBackFunc);
    // [StartExclude callbackFunc]
  }
  build() {
    NavDestination() {
      Text('pageOne')
    }.title('pageOne')
  }
}
// [EndExclude callbackFunc]

// [StartExclude callbackFunc]
@Entry
@Component
struct Index {
  private stack: NavPathStack = new NavPathStack();
  // [EndExclude callbackFunc]
  // 可以通过窗口的getUIContext()方法获取对应的UIContent
  uiContext: UIContext | null = null;
  // [StartExclude callbackFunc]
  @Builder
  PageBuilder(name: string) {
    PageOne();
  }
  aboutToAppear() {
    // [EndExclude callbackFunc]
    uiObserver.on('navDestinationSwitch', this.uiContext, callBackFunc);
    // [StartExclude callbackFunc]
  }
  // [EndExclude callbackFunc]
  // [End callbackFunc]
  aboutToDisappear() {
    uiObserver.off('navDestinationSwitch', this.uiContext, callBackFunc);
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