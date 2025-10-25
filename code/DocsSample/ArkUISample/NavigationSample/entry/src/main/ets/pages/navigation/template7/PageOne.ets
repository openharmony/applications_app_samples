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
class NavParam {
  public desc: string = 'navigationOnReady-param'
};

@Builder
export function PageOneBuilder(name: string, param: Object) {
    Page01();
};
// [Start onReady]
@Component
struct Page01 {
  private pathStack: NavPathStack | undefined = undefined;
  private name: string = '';
  // [StartExclude onReady]
  private pageParam: string = '';
  // [EndExclude onReady]
  build() {
    NavDestination() {
      // [StartExclude onReady]
      Column() {
        Text('NavPathInfo: name: ' + this.name + ', paramNum: ' + this.pageParam)
      }
      .width('100%')
      .height('100%')
    }
    // [EndExclude onReady]
    .title('Page01')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
      this.pageParam = context.pathInfo.param as string;
    })
  }
}
// [End onReady]
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
            this.stack.pushPath({ name: 'temp7-pageOne', param: p.desc });
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