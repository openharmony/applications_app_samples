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
// [Start Internal_@Trace_setOrCreate_V1_pag1]
// Page1.ets
export let storage: LocalStorage = new LocalStorage();

storage.setOrCreate('count', 47);

@Entry(storage)
@Component
struct Page1 {
  @LocalStorageProp('count') count: number = 0;
  pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Column() {
        Text(`${this.count}`)
          .fontSize(50)
          .onClick(() => {
            this.count++;
          })
        Button('change Storage Count')
          .onClick(() => {
            storage.setOrCreate('count', storage.get<number>('count') as number + 100);
          })
        Button('push to Page2')
          .onClick(() => {
            this.pageStack.pushPathByName('Page2', null);
          })
      }
    }
  }
}
// [End Internal_@Trace_setOrCreate_V1_pag1]
@Component
export struct InternalTracesetOrCreateV1pag1 {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      Page1()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Internal_Trace_setOrCreate_V1_pag1'))
  }
}