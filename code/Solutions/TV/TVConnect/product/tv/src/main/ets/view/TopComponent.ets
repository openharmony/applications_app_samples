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
import { CommonConstants } from '../common/constants/CommonConstants';

/**
 * Category top component.
 */
@Component
export struct TopComponent {
  build() {
    Column() {
      this.Title();

      Search({ placeholder: CommonConstants.SEARCH_PLACEHOLDER })
        .height($r('app.string.search_height'))
        .border({ radius: $r('app.string.search_radius') })
        .placeholderFont({
          size: $r('app.string.search_text_size'),
          weight: CommonConstants.SEARCH_WEIGHT,
          family: CommonConstants.SEARCH_FONT_FAMILY,
          style: FontStyle.Normal
        })
        .textFont({ size: $r('app.string.search_text_size') })
        .placeholderColor($r('app.color.search_placeholder'))
        .margin({
          top: $r('app.string.search_margin_top'),
          bottom: $r('app.string.search_margin_bottom')
        });
    };
  }

  @Builder
  Title() {
    Column() {
      Text($r('app.string.title'))
        .height($r('app.string.text_title_height'))
        .fontSize($r('app.string.title_font_size'))
        .fontWeight(CommonConstants.TITLE_FONT_WEIGHT)
        .textAlign(TextAlign.Start);

      Text($r('app.string.sub_title'))
        .height($r('app.string.subtitle_height'))
        .fontColor($r('app.color.sub_text'))
        .fontSize($r('app.string.subtitle_font_size'))
        .fontWeight(CommonConstants.SUBTITLE_FONT_WEIGHT)
        .textAlign(TextAlign.Start);
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height($r('app.string.title_height'))
    .alignItems(HorizontalAlign.Start)
    .margin({
      top: $r('app.string.title_margin_top'),
      left: $r('app.string.title_margin_left')
    });
  }
}