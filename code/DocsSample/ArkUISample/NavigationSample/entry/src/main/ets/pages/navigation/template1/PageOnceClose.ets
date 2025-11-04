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
import { uiObserver } from '@kit.ArkUI';
@Entry
@Component
struct PageOnceClose {
  // [Start PageOnceClose]
  @Provide('pageStack') pageStack: NavPathStack = new NavPathStack();
  // [End PageOnceClose]
  @Builder
  PageBuilder(name: string) {
    MyComponent();
  }

  build() {
    Column() {
      Navigation(this.pageStack) {
        Button('push').onClick(() => {
          // [Start PageOnceCloseOne]
          this.pageStack.pushPath({ name: 'MyComponent' }, false);
          // [End PageOnceCloseOne]
        })
      }
      .title('Navigation')
      .navDestination(this.PageBuilder)
    }
    .width('100%')
    .height('100%')
  }
}
@Component
struct MyComponent {
  navDesInfo: uiObserver.NavDestinationInfo | undefined;
  @Consume('pageStack') pageStack: NavPathStack;
  build() {
    NavDestination() {
      Column() {
        // $r('app.string.ToPage')需要替换为开发者所需的字符串资源文件
        Text($r('app.string.ToPage'))
          .onClick(()=>{
            // [Start PageOnceCloseTwo]
            this.pageStack.pop(false);
            // [End PageOnceCloseTwo]
          })
      }.width('100%').height('100%')
    }
    .title('MyComponent')
  }
}