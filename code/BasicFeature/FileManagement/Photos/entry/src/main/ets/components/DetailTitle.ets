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

import { Log } from '../utils/Log';
import { ActionBarProp } from '../common/ActionBarProp';

// Large picture title, including primary date title and secondary time and place title
@Component
export struct DetailTitle {
  private TAG: string = 'DetailTitle';
  @Consume('dateTitle') title: string;
  @Consume('timeLocationTitle') subTitle: string;
  isVideoPage: boolean = false;

  private onBuildDone(): void {
    Log.debug(this.TAG, 'onBuildDone, title: ' + this.title + ', subTitle: ' + this.subTitle);
  }

  build() {
    Row() {
      Column() {
        Text(this.title)
          .fontSize(ActionBarProp.TITLE_TEXT_SIZE)
          .fontColor(this.isVideoPage ? $r('app.color.white') : ActionBarProp.NORMAL_TEXT_COLOR)
          .fontWeight(FontWeight.Bold)
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
        Text(this.subTitle)
          .fontSize($r('sys.float.ohos_id_text_size_over_line'))
          .fontFamily(ActionBarProp.REGULAR_FONT)
          .fontColor(this.isVideoPage ? $r('app.color.white') : ActionBarProp.NORMAL_SUBTITLE_TEXT_COLOR)
          .maxLines(1)
          .lineHeight('app.float.detail_sub_title_max_lines')
          .margin({ top: $r('sys.float.ohos_id_text_margin_vertical') })
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .constraintSize({ minHeight: ('app.float.detail_title_constraint_size_min_height') })
      .alignItems(HorizontalAlign.Start)
    }.margin({ left: $r('app.float.actionbar_title_margin'),
      right: $r('app.float.actionbar_title_margin') })
    .alignItems(VerticalAlign.Center)
  }
}