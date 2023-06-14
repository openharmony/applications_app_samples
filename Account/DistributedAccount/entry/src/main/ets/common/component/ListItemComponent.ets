/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';

@Component
export struct ListItemComponent {
  private title: string | Resource;
  private endText: string | Resource;
  private endArrowIsShow: boolean;
  private targetPage: string;
  private paramInfo: any;

  aboutToAppear() {
    if (this.endText === 'true') {
      this.endText = $r('app.string.Yes')
    } else if (this.endText === 'false') {
      this.endText = $r('app.string.No')
    } else if (this.endText === '') {
      this.endText = $r('app.string.Null')
    }
  }

  build() {
    Row() {
      Text(this.title)
        .minFontSize(16)
        .maxFontSize(24)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      Blank()
      Text(this.endText)
        .width('50%')
        .maxLines(2)
        .minFontSize(16)
        .maxFontSize(24)
        .textAlign(TextAlign.End)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
      if (this.endArrowIsShow) {
        Image($r('app.media.ic_arrow'))
          .width(24)
          .aspectRatio(1)
      }
    }
    .width('100%')
    .padding($r('sys.float.ohos_id_card_margin_middle'))
    .onClick(() => {
      router.pushUrl({
        url: this.targetPage,
        params: {
          paramInfo: this.paramInfo
        }
      })
    })
  }
}