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

import { ImageInfo } from '../model/WaterFlowData';

@Reusable
@Component
export struct ReusableFlowItem {
  @State item: ImageInfo | null = null;

  // TODO：知识点：从复用缓存中加入到组件树之前调用，可在此处更新组件的状态变量以展示正确的内容
  aboutToReuse(params: ESObject) {
    this.item = params.item;
  }

  build() {
    Column() {
      Image(this.item?.data)
        .objectFit(ImageFit.Contain)
        .width('100%')
        .borderRadius({
          topLeft: $r('app.integer.decode_heif_image_flow_item_image_border_radius_top_left'),
          topRight: $r('app.integer.decode_heif_image_flow_item_image_border_radius_top_right')
        })

      Text(this.item?.description)
        .fontSize($r('app.integer.decode_heif_image_flow_item_text_font_size'))
        .fontColor($r('app.color.decode_heif_image_flow_item_font_color'))
        .margin({
          top: $r('app.integer.decode_heif_image_flow_item_text_margin_top'),
          bottom: $r('app.integer.decode_heif_image_flow_item_text_margin_bottom')
        })
    }
    .width('100%')
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .borderRadius($r('app.integer.decode_heif_image_flow_item_border_radius'))
    .backgroundColor(Color.White)
  }
}
