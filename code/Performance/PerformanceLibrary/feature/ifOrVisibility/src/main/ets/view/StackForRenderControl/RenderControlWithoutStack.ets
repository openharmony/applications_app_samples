/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import Constants from '../../util/Constants';

@Preview
@Component
export struct RenderControlWithoutStack {
  @State isVisible: boolean = true;
  private data: number[] = [];

  aboutToAppear() {
    for (let i: number = 0; i < Constants.IMAGE_TOTAL_NUM; i++) {
      this.data.push(i);
    }
  }

  build() {
    Column() {
      Stack() {
        Scroll() {
          Column() { // 刷新范围会扩展到这一层
            if (this.isVisible) { // 条件变化会触发创建和销毁该组件，影响到容器的布局，该容器内所有组件都会刷新
              Text('New item').fontSize($r('app.integer.font_size_20'))
            }
            ForEach(this.data, (item: number) => {
              Text(`Item value: ${item}`)
                .fontSize($r('app.integer.font_size_20'))
                .width($r('app.string.layout_100_percent'))
                .textAlign(TextAlign.Center)
            }, (item: number) => item.toString())
          }
        }
      }.height($r('app.string.layout_90_percent'))

      Button('Switch Hidden and Show').onClick(() => {
        this.isVisible = !(this.isVisible);
      })
    }
  }
}
