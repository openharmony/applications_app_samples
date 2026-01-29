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

// 字体透明度
const TEXT_OPACITY: number = 0.8;

@Component
export struct IconItem {
  @Link renderGroupFlag: boolean;
  image: string | Resource = '';
  text: string | Resource = '';

  build() {
    Flex({ direction: FlexDirection.Column, justifyContent: FlexAlign.Center, alignContent: FlexAlign.Center }) {
      Image(this.image)
        .height($r('app.integer.RenderGroup_item_image_height'))
        .width($r('app.integer.RenderGroup_item_image_width'))
        .objectFit(ImageFit.Contain)
        .margin({
          left: $r('app.integer.RenderGroup_item_image_margin')
        })

      Text(this.text)
        .fontSize($r('app.integer.RenderGroup_item_text_font'))
        .fontColor($r('app.color.RenderGroup_item_text_fontColor'))
        .margin({
          top: $r('app.integer.RenderGroup_item_text_margin_top')
        })
        .width($r('app.integer.RenderGroup_item_text_width'))
        .opacity(TEXT_OPACITY)
        .textAlign(TextAlign.Center)
    }
    .backgroundColor($r('app.color.RenderGroup_item_backgroundColor'))
    .width($r('app.integer.RenderGroup_item_width'))
    .height($r('app.integer.RenderGroup_item_height'))
    .borderRadius($r('app.integer.RenderGroup_item_borderRadius'))
    // 在IconItem内调用renderGroup,true为开启，false为关闭
    .renderGroup(this.renderGroupFlag)
  }
}