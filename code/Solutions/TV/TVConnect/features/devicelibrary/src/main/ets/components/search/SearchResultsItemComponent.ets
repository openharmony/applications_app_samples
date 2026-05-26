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
import { HMRouterMgr } from '@hadss/hmrouter';
import { DetailItemInfo, DeviceLibraryManager } from '../../viewmodel/DeviceLibraryManager';
import { LengthMetrics } from '@kit.ArkUI';

@Component
export struct SearchResultsItemComponent {
  @Consume currentSearchField: string;
  @Prop searchInfo: DetailItemInfo;
  @State titleArr: string[] = [];
  @State fontColor: ResourceStr = $r('app.color.default_text_color');
  @State fontSize: ResourceStr = $r('app.string.font_16');
  @State fontWeight: boolean = false;

  @Builder
  buildTitle() {
    Text() {
      ForEach(this.titleArr = this.searchInfo.title.split(this.currentSearchField), (str: string, index: number) => {
        Span(str)
          .fontSize(this.fontSize)
          .fontColor(this.fontColor)
          .fontWeight(this.fontWeight ? FontWeight.Bold : FontWeight.Medium);
        if (index != this.titleArr.length - 1) {
          Span(this.currentSearchField)
            .fontColor(Color.Red)
            .fontSize(this.fontSize)
            .fontWeight(this.fontWeight ? FontWeight.Bold : FontWeight.Medium);
        }
      });
    }
    .width('75%')
    .maxLines(1)
    .textOverflow({ overflow: TextOverflow.Ellipsis })
    .focusable(true)
    .focusBox({
      strokeWidth: LengthMetrics.px(0)
    })
    .onFocus(() => {
      this.fontColor = $r('app.color.text_color_white');
      this.fontSize = $r('app.string.font_20');
      this.fontWeight = true;
    })
    .onBlur(() => {
      this.fontColor = $r('app.color.default_text_color');
      this.fontSize = $r('app.string.font_16');
      this.fontWeight = false;
    });
  }

  build() {
    Row() {
      Image(this.searchInfo?.device?.deviceIcons[0]).height(50).width(50).margin(5).borderRadius(10);
      this.buildTitle();
      Blank();
      Image($r('app.media.ic_public_arrow_right')).height(15);
    }.width('100%').alignItems(VerticalAlign.Center).padding({ left: 10, right: 10 }).onClick(() => {
      // 跳转到设备详情页
      DeviceLibraryManager.getInstance().selectItem = this.searchInfo;
      HMRouterMgr.push({ pageUrl: 'DeviceLibraryDetailPage' });
    });
  }
}