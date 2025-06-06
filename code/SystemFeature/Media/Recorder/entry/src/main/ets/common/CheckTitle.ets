/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
export struct CheckTitle {
  @Link checkNum: number;
  @Link checkState: boolean;

  build() {
    Row() {
      Image($r('app.media.close'))
        .id('closeCheck')
        .size({ width: 40, height: '100%' })
        .objectFit(ImageFit.Contain)
        .margin(10)
        .onClick(() => {
          this.checkState = false;
        })
      if (this.checkNum > 0) {
        Text($r('app.string.check_title_selected'))
          .fontColor(Color.Black)
          .fontSize(25)
        Text(this.checkNum.toString())
          .id('checkedNum')
          .fontColor(Color.Black)
          .fontSize(25)
        Text($r('app.string.check_title_selected_end'))
          .fontColor(Color.Black)
          .fontSize(25)
      } else {
        Text($r('app.string.check_title_unselected'))
          .fontColor(Color.Black)
          .fontSize(25)
      }
    }
    .width('100%')
    .height('8%')
    .constraintSize({ minHeight: 50 })
  }
}