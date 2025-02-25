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

import { BreakpointConstants } from '../common/constants/BreakpointConstants';
import CommonConstants from '../common/constants/CommonConstants';
import { BreakpointType } from '../model/BreakpointType';
import { FontSizeScale } from '../model/FontSizeScale';

@Extend(Text)
function scanTitle(color: ResourceColor, fontWeight: FontWeight) {
  .width('100%')
  .textAlign(TextAlign.Center)
  .fontFamily('HarmonyHeiTi')
  .fontWeight(fontWeight)
  .fontColor(color)
  .constraintSize({
    maxWidth: 460
  })
  .maxLines(2)
  .textOverflow({ overflow: TextOverflow.Ellipsis })
}

@Component
export struct ScanTitle {
  @StorageLink('scanFontSizeScale') fontSizeScale: number = 1;
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @Prop navHeight: number

  build() {
    Column() {
      Text($r('app.string.Scan_barcode_tips_callback'))
        .scanTitle($r('sys.color.ohos_id_color_primary_contrary'),
          FontWeight.Regular)
        .fontSize(FontSizeScale.getLimitFontSize(this.fontSizeScale,
          CommonConstants.SCAN_FONT_SIZE_SCALE_LIMIT_TITLE_TEXT, $r('sys.float.Subtitle_L')))
        .lineHeight(CommonConstants.TITLE_MAIN_LINE_HEIGHT)
    }
    .alignItems(HorizontalAlign.Center)
    .margin({
      top: this.navHeight + CommonConstants.TOP_BUTTON_HEIGHT + CommonConstants.TITLE_MARGIN_TOP,
      bottom: CommonConstants.SCAN_LINE_MARGIN
    })
    .padding({
      left: new BreakpointType($r('app.float.container_horizontal_padding_sm'),
        $r('app.float.container_horizontal_padding_md'),
        $r('app.float.container_horizontal_padding_lg')).getValue(this.currentBreakpoint),
      right: new BreakpointType($r('app.float.container_horizontal_padding_sm'),
        $r('app.float.container_horizontal_padding_md'),
        $r('app.float.container_horizontal_padding_lg')).getValue(this.currentBreakpoint)
    })
    .width('100%')
  }
}