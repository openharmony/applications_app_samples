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

// [Start force_update_counterexample]
@Entry
@Component
struct MyComponent {
  @State needsUpdate: boolean = true;
  realStateArr: Array<number> = [4, 1, 3, 2]; // 未使用状态变量装饰器。
  realState: Color = Color.Yellow;

  updateUIArr(param: Array<number>): Array<number> {
    const triggerAGet = this.needsUpdate;
    return param;
  }
  updateUI(param: Color): Color {
    const triggerAGet = this.needsUpdate;
    return param;
  }
  build() {
    Column({ space: 20 }) {
      ForEach(this.updateUIArr(this.realStateArr),
        (item: number) => {
          Text(`${item}`)
        })
      Text('add item')
        .onClick(() => {
          // 改变realStateArr不会触发UI视图更新。
          this.realStateArr.push(this.realStateArr[this.realStateArr.length-1] + 1);

          // 触发UI视图更新。
          this.needsUpdate = !this.needsUpdate;
        })
      Text('chg color')
        .onClick(() => {
          // 改变realState不会触发UI视图更新。
          this.realState = this.realState == Color.Yellow ? Color.Red : Color.Yellow;

          // 触发UI视图更新。
          this.needsUpdate = !this.needsUpdate;
        })
    }.backgroundColor(this.updateUI(this.realState))
    .width(200).height(500)
  }
}
// [End force_update_counterexample]