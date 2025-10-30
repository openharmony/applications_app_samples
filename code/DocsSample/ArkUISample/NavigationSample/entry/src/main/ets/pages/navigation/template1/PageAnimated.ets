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
// NavDestination内的自定义组件
@Component
struct MyComponent {
  navDesInfo: uiObserver.NavDestinationInfo | undefined;

  build() {
    NavDestination() {
      Column() {
        Text('所属页面')
      }.width('100%').height('100%')
    }.title('MyComponent')
  }
}

@Entry
@Component
struct PageAnimated {
  // [Start PageAnimated]
  pageStack: NavPathStack = new NavPathStack();
  aboutToAppear(): void {
    this.pageStack.disableAnimation(true);
  }
  // [End PageAnimated]
  @Builder
  PageBuilder(name: string) {
    MyComponent();
  }

  build() {
    Column() {
      Navigation(this.pageStack) {
        Button('push').onClick(() => {
          this.pageStack.pushPath({ name: 'MyComponent' });
        })
      }
      .title('Navigation')
      .navDestination(this.PageBuilder)
    }
    .width('100%')
    .height('100%')
  }
}