/**
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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
export struct SearchBox {
 build() {
   Row() {
     Image($r('app.media.ic_search'))
       .width(18)
       .height(18)
       .objectFit(ImageFit.Contain)
       .margin({left: 11})

     Text($r('app.string.searchHint'))
       .fontSize(16)
       .lineHeight(21)
       .fontWeight(FontWeight.Regular)
       .fontFamily('HarmonyHeiTi')
       .fontColor($r('sys.color.ohos_id_color_text_secondary'))
       .margin({left: 6})
   }
   .borderRadius(20)
   .backgroundColor('#0C000000')
   .height(40)
   .width('100%')
   .alignItems(VerticalAlign.Center)
 }
}