/*
 *
 *  Copyright (c) 2023 Huawei Device Co., Ltd.
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */

import DataPreferencesUtil from '../../utils/DataPreferencesUtil';

let TAG: string = 'RecentSearches';

@Component
export struct RecentSearches {
  private context: Context;
  private preferencesUtil: DataPreferencesUtil;
  @Consume('recentList') recentList: Array<string>;
  @Link currentSearch: string;

  aboutToAppear() {
    this.preferencesUtil = new DataPreferencesUtil();
    this.preferencesUtil.getSearchList(this.context).then(list => {
      this.recentList = list;
    })
  }

  build() {
    Column({ space: 12 }) {
      Row() {
        Text($r('app.string.recent_searches'))
          .fontSize(14)
          .textAlign(TextAlign.Start)
        Blank()
        Text($r('app.string.clean'))
          .fontSize(14)
          .margin({ left: 12 })
          .fontColor(Color.Gray)
          .textAlign(TextAlign.Start)
          .onClick(async () => {
            if (this.preferencesUtil !== undefined) {
              this.recentList = await this.preferencesUtil.pushSearchList(this.context, []);
            }
            this.recentList = [];
            this.build();
          })
      }
      .width('100%')

      GridRow({ gutter: { x: vp2px(3), y: vp2px(3) }, columns: 5 }) {
        ForEach(this.recentList, (item: string, index: number) => {
          GridCol() {
            Row() {
              Text(item)
                .maxLines(1)
                .fontSize(12)
                .fontColor(Color.Gray)
                .textAlign(TextAlign.Center)
                .textOverflow({ overflow: TextOverflow.Ellipsis })
            }
            .borderRadius(20)
            .backgroundColor($r('app.color.white'))
            .justifyContent(FlexAlign.Center)
            .constraintSize({ maxWidth: 500 })
            .padding({ top: 6, bottom: 6, left: 12, right: 12 })
            .onClick(() => {
              this.currentSearch = item;
            })
          }
        })
      }
      .width('100%')
      .padding({ top: 12, bottom: 12, left: 6, right: 6 })
    }
  }
}