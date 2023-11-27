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

@Component
export struct AlignContentFlex {
  @Link alignStyle: FlexAlign;
  private data: number[] = [];

  aboutToAppear() {
    for (let i: number = 0; i < Constants.TEXT_TOTAL_NUM; i++) {
      this.data.push(i);
    }
  }

  build() {
    Flex({ wrap: FlexWrap.Wrap, alignContent: this.alignStyle }) {
      ForEach(this.data, (item: number) => {
        Text(`${item % Constants.TEXT_CONTENT_DIVIDER}`)
          .width($r('app.string.layout_5_percent'))
          .height($r('app.integer.layout_20'))
          .backgroundColor(item % 2 === 0 ? $r('app.color.txt_background_color1') : $r('app.color.txt_background_color2'))
      }, (item: number) => item.toString())
    }
    .size({ width: $r('app.string.layout_100_percent'), height: $r('app.integer.layout_240') })
    .padding($r('app.integer.layout_10'))
    .backgroundColor($r('app.color.flex_background_color'))
  }
}