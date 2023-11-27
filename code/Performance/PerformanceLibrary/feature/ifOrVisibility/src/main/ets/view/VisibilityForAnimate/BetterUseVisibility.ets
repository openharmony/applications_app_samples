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
export struct BetterUseVisibility {
  @State isVisible: boolean = true;
  private data: number[] = [];

  aboutToAppear() {
    for (let i: number = 0; i < Constants.IMAGE_TOTAL_NUM; i++) {
      this.data.push(i);
    }
  }

  build() {
    Column() {
      Button($r('app.string.switch_button_text'))
        .onClick(() => {
          this.isVisible = !(this.isVisible);
        })
        .width($r('app.string.layout_100_percent'))
      Scroll() {
        Column() {
          ForEach(this.data, (item: number) => {
            Image($r('app.media.icon'))
              .width($r('app.string.foreach_image_width'))
              .height($r('app.string.foreach_image_height'))
          }, (item: number) => item.toString())
        }
      }.visibility(this.isVisible ? Visibility.Visible : Visibility.None) // 使用显隐控制切换，不会频繁创建与销毁组件
    }
  }
}
