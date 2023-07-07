/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
export default struct FloatingWindowComponent {
  private res: Resource = $r('app.media.ic_call_green');
  private tips?: Resource = $r('app.string.Tips_call');

  build() {
    Column() {
      Image(this.res)
        .objectFit(ImageFit.Contain)
        .width('40%')
        .height('40%')

      Text(this.tips)
        .fontSize(12)
        .fontColor($r('app.color.background_green'))
        .fontWeight(FontWeight.Regular)
        .fontFamily($r('app.string.Font_family_regular'))
    }
    .width(80)
    .height(80)
    .backgroundColor($r('app.color.white'))
    .borderRadius(16)
    .shadow({ radius: 15, color: $r('app.color.btn_border_color') })
    .justifyContent(FlexAlign.SpaceAround)
  }
}