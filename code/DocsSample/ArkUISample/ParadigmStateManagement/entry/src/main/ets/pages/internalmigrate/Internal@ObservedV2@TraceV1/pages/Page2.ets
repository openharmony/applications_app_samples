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
// [Start Internal_@ObservedV2_@Trace_V1_pag2]
// Page2.ets
@Builder
export function Page2Builder() {
  Page2()
}

// Page2组件获得了父亲Page1组件的LocalStorage实例
@Component
struct Page2 {
  // 页面级UI状态存储点击text文本的次数
  @LocalStorageLink('count') count: number = 0;
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Column() {
        Text(`${this.count}`)
          .fontSize(50)
          .onClick(() => {
            this.count++;
          })
        Button('change')
          .fontSize(50)
          .onClick(() => {
            const storage = this.getUIContext().getSharedLocalStorage();
            if (storage) {
              storage.set('count', 20);
            }
          })
      }
    }
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
// [End Internal_@ObservedV2_@Trace_V1_pag2]
@Component
export struct InternalObservedV2TraceV1pag2 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page2()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_ObservedV2_Trace_V1_pag2'))
  }
}