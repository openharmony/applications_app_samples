/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Component
export struct LoadingPanel {
  @Consume isLoading: boolean;

  build() {
    if (this.isLoading) {
      Column() {
        Column() {
          LoadingProgress().width($r('app.float.loading_panel_icon_w'))
            .height($r('app.float.loading_panel_icon_w'))
            .margin({ bottom: $r('app.float.loading_panel_icon_margin') })
          Text($r('app.string.image_loading'))
            .fontSize($r('sys.float.ohos_id_text_size_body2'))
            .fontFamily($r('app.string.id_text_font_family_regular'))
            .fontColor($r('sys.color.ohos_id_color_text_secondary'))
        }
      }
      .width('100%')
      .height('100%')
      .padding({ top: $r('app.float.loading_panel_item_gap') })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
  }
}