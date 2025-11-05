/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
// [Start button_case_1]
const DOMAIN = 0x0000;
// xxx.ets
@Entry
@Component
export struct ButtonCase1 {
  pathStack: NavPathStack = new NavPathStack();

  @Builder
  PageMap(name: string) {
    if (name === 'first_page') {
      pageOneTmp()
    } else if (name === 'second_page') {
      pageTwoTmp()
    } else if (name === 'third_page') {
      pageThreeTmp()
    }
  }

  build() {
    NavDestination() {
      Navigation(this.pathStack) {
        List({ space: 4 }) {
          ListItem() {
            Button('First').onClick(() => {
              this.pathStack.pushPath({ name: 'first_page' });
            })
              .width('100%')
          }

          ListItem() {
            Button('Second').onClick(() => {
              this.pathStack.pushPath({ name: 'second_page' });
            })
              .width('100%')
          }

          ListItem() {
            Button('Third').onClick(() => {
              this.pathStack.pushPath({ name: 'third_page' });
            })
              .width('100%')
          }
        }
        .listDirection(Axis.Vertical)
        .backgroundColor(0xDCDCDC).padding(20)
      }
      .mode(NavigationMode.Stack)
      .navDestination(this.PageMap)
    }
  }
}

// pageOne
@Component
export struct pageOneTmp {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text('first_page')
      }.width('100%').height('100%')
    }.title('pageOne')
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop(); // 弹出路由栈栈顶元素
      // $r('app.string.return_value')资源文件中的value为'返回'
      hilog.info(DOMAIN, 'testTag', 'pop' + $r('app.string.return_value') + JSON.stringify(popDestinationInfo));
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}

// pageTwo
@Component
export struct pageTwoTmp {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text('second_page')
      }.width('100%').height('100%')
    }.title('pageTwo')
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop(); // 弹出路由栈栈顶元素
      // $r('app.string.return_value')资源文件中的value为'返回'
      hilog.info(DOMAIN, 'testTag', 'pop' + $r('app.string.return_value') + JSON.stringify(popDestinationInfo));
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}

// pageThree
@Component
export struct pageThreeTmp {
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text('third_page')
      }.width('100%').height('100%')
    }.title('pageThree')
    .onBackPressed(() => {
      const popDestinationInfo = this.pathStack.pop(); // 弹出路由栈栈顶元素
      // $r('app.string.return_value')资源文件中的value为'返回'
      hilog.info(DOMAIN, 'testTag', 'pop' + $r('app.string.return_value') + JSON.stringify(popDestinationInfo));
      return true
    })
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
// [End button_case_1]