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
import { DetailItemInfo } from '../../viewmodel/DeviceLibraryManager';
import { SearchResultsItemComponent } from './SearchResultsItemComponent';

@Component
export struct SearchResultsComponent {
  @Consume currentSearchField: string;
  @Consume searchResultList: Array<DetailItemInfo>;

  build() {
    Column() {
      if (this.searchResultList.length == 0 && this.currentSearchField != '') {
        Text($r('app.string.no_results_contain_str', this.currentSearchField))
          .textAlign(TextAlign.Start)
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.text_color_white'))
          .fontWeight(FontWeight.Bold)
          .width('100%');
      }
      if (this.searchResultList.length != 0 && this.currentSearchField != '') {
        Text($r('app.string.results_include_str', this.currentSearchField))
          .textAlign(TextAlign.Start)
          .width('100%')
          .fontSize($r('app.string.font_20'))
          .fontColor($r('app.color.text_color_white'))
          .fontWeight(FontWeight.Bold);
        List() {
          ForEach(this.searchResultList, (data: DetailItemInfo) => {
            ListItem() {
              SearchResultsItemComponent({ searchInfo: data });
            }.width('100%');
          });
        }
        .layoutWeight(1)
        .divider(new DividerTmp(1, 10, 10, '#ffe9f0f0'))
        .margin({ top: 10, bottom: 35 });
      }
    }.height('100%').margin({ left: 20, right: 20, top: 20 });
  }
}

class DividerTmp {
  public strokeWidth: Length = 1;
  public startMargin: Length = 10;
  public endMargin: Length = 10;
  public color: ResourceColor = '#ffe9f0f0';

  constructor(strokeWidth: Length, startMargin: Length, endMargin: Length, color: ResourceColor) {
    this.strokeWidth = strokeWidth;
    this.startMargin = startMargin;
    this.endMargin = endMargin;
    this.color = color;
  }
}