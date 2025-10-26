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
@Component
export struct LocalUseCaseSet {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      SetSample()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.local_use_case_set'))
  }
}

// [Start Local_Use_Case_Set]
@Entry
@ComponentV2
struct SetSample {
  @Local message: Set<number> = new Set([0, 1, 2, 3, 4]);

  build() {
    Row() {
      Column() {
        ForEach(Array.from(this.message.entries()), (item: [number, number]) => { // 遍历Set的元素并渲染UI
          Text(`${item[0]}`).fontSize(30)
          Divider()
        })
        Button('init set').onClick(() => { // 按钮1：更新Set为初始状态
          this.message = new Set([0, 1, 2, 3, 4]);
        })
        Button('set new one').onClick(() => { // 按钮2：添加新元素5
          this.message.add(5);
        })
        Button('clear').onClick(() => { // 按钮3：清空Set
          this.message.clear();
        })
        Button('delete the first one').onClick(() => { // 按钮4：删除元素0
          this.message.delete(0);
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Local_Use_Case_Set]