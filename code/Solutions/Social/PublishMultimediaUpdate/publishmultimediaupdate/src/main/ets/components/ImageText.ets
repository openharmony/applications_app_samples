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

/**
 * 图片&文字组合
 */

@Component
export struct ImageText {
  @Prop imageStr: Resource;
  text: string | Resource = '';

  build() {
    Row() {
      Image(this.imageStr)
        .height($r('app.integer.publish_multimedia_updates_handler_icon_height'))
        .width($r('app.integer.publish_multimedia_updates_handler_icon_width'))
        .objectFit(ImageFit.Contain)
        .autoResize(false)
      Text(this.text)
        .fontSize($r('app.integer.publish_multimedia_updates_handler_text_font_size'))
        .fontColor($r('app.color.publish_multimedia_updates_title_font_color'))
        .fontFamily($r('app.string.publish_multimedia_updates_harmony_hei_ti'))
        .opacity($r('app.float.publish_multimedia_updates_opacity'))
        .margin({ left: $r('app.integer.publish_multimedia_updates_layout') })
    }
    .alignItems(VerticalAlign.Center)
  }
}
