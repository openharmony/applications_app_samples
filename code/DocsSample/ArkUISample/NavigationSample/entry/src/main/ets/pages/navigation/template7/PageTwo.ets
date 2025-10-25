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
class NavParam {
  desc: string = 'navigationOnResult-param'
};
// [StartExclude onResult]
@Builder
export function PageTwoBuilder(name: string, param: Object) {
  DemoNavDestination();
};
// [StartExclude onResult]
@Component
struct DemoNavDestination {
  // [StartExclude onResult]
  private pathStack: NavPathStack | undefined = undefined;
  private name: string = '';
  private pageParam: string = '';
  // [StartExclude onResult]
  build() {
    NavDestination() {
      // [StartExclude onResult]
      Column() {
        Text('onResult')
      }
      .width('100%')
      .height('100%')
      // [StartExclude onResult]
    }
    .onResult((param: Object) => {
      if (param instanceof NavParam) {
        console.info('TestTag', 'get NavParam, its desc: ' + (param as NavParam).desc);
        return;
      }
      console.info('TestTag', 'param not instance of NavParam');
    })
  }
}
// [End onResult]
@Entry
@Component
struct NavigationExample7 {
  private stack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.stack) {
      Stack({ alignContent: Alignment.Center }) {
        Button('pushPath', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            let p = new NavParam();
            this.stack.pushPath({ name: 'temp7-pageTwo', param: p });
          })
      }
      .width('100%')
      .height('100%')
    }
    .width('100%')
    .height('100%')
    .title('Navigation')
  }
}