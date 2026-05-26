/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { CommonConstants } from '@ohos/common';

@Component
export struct ScanHeader {
  @LocalStorageLink('isDragMode') isDragMode: boolean = false;
  private vis: Visibility = Visibility.Visible;

  build() {
    Row() {
      Text($r('app.string.scan_title'))
        .fontSize($r('app.string.fp_20'))
        .fontWeight(FontWeight.Medium)
        .fontColor($r('app.color.san_title_font_color'))
        .visibility(this.vis);
      Image(this.isDragMode ? $r('app.media.label_drag') : $r('app.media.label_list'))
        .width($r('app.string.vp_30'))
        .height($r('app.string.vp_30'))
        .onClick(() => {
          this.isDragMode = !this.isDragMode;
        });
    }
    .padding({
      top: $r('app.string.vp_20'),
      left: $r('app.string.vp_30'),
      right: $r('app.string.vp_30'),
      bottom: $r('app.string.vp_12')
    })
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .justifyContent(FlexAlign.SpaceBetween);
  }
}