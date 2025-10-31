import { hilog } from '@kit.PerformanceAnalysisKit';

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
const DOMAIN = 0x0000;
// [Start NavigationCreate]
@Entry
@Component
struct Index {
  // 创建一个导航控制器对象并传入Navigation
  pageStack: NavPathStack = new NavPathStack();
  // [StartExclude NavigationCreate]
  isUseInterception: boolean = false;

  registerInterception() {
    // [Start setInterception]
    this.pageStack.setInterception({
      willShow: (from: NavDestinationContext | 'navBar', to: NavDestinationContext | 'navBar',
        operation: NavigationOperation, animated: boolean) => {
        if (typeof to === 'string') {
          hilog.info(DOMAIN, 'testTag', 'target page is navigation home');
          return;
        }
        // 将跳转到PageTwo的路由重定向到PageOne
        let target: NavDestinationContext = to as NavDestinationContext;
        if (target.pathInfo.name === 'pageTwo') {
          target.pathStack.pop();
          target.pathStack.pushPathByName('pageOne', null);
        }
      }
    })
    // [End setInterception]
  };
  // [EndExclude NavigationCreate]
  build() {
    Navigation(this.pageStack) {
      // [StartExclude NavigationCreate]
      Column() {
        Button('pushPath', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            // [Start PushPathParam]
            this.pageStack.pushPath({ name: 'pageOne', param: 'PageOne Param' });
            // [End PushPathParam]
          })
        Button('use interception', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.isUseInterception = !this.isUseInterception;
            if (this.isUseInterception) {
              this.registerInterception();
            } else {
              this.pageStack.setInterception(undefined);
            }
          })
      }
      // [EndExclude NavigationCreate]
    }.title('Main')
  }
}
// [End NavigationCreate]