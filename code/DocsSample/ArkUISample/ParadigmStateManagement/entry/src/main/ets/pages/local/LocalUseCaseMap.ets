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
export struct LocalUseCaseMap {
  @State egLanes: LengthConstrain = { minLength: 200, maxLength: 300 };
  @Consume pathStack: NavPathStack;

  build() {
    NavDestination() {
      MapSample()
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.local_use_case_map'))
  }
}

// [Start Local_Use_Case_Map]
@Entry
@ComponentV2
struct MapSample {
  @Local message: Map<number, string> = new Map([[0, 'a'], [1, 'b'], [3, 'c']]); // 使用@Local装饰Map类型变量

  build() {
    Row() {
      Column() {
        ForEach(Array.from(this.message.entries()), (item: [number, string]) => { // 遍历Map的键值对并渲染UI
          Text(`${item[0]}`).fontSize(30)
          Text(`${item[1]}`).fontSize(30)
          Divider()
        })
        Button('init map').onClick(() => { // 按钮1：重置Map为初始状态
          this.message = new Map([[0, 'a'], [1, 'b'], [3, 'c']]);
        })
        Button('set new one').onClick(() => { // 按钮2：添加新键值对(4, 'd')
          this.message.set(4, 'd');
        })
        Button('clear').onClick(() => { // 按钮3：清空Map
          this.message.clear();
        })
        Button('replace key 0').onClick(() => { // 按钮4：更新/添加键值为0的键值对
          this.message.set(0, 'aa');
        })
        Button('delete key 0').onClick(() => { // 按钮5：删除键值为0的键值对
          this.message.delete(0);
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End Local_Use_Case_Map]