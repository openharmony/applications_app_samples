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
import { HistoryRecordManager } from '../../viewmodel/HistoryRecordManager';

@Component
export struct HistoryRecordComponent {
  @Consume currentSearchField: string;
  @Consume historyRecordManager: HistoryRecordManager;

  build() {
    if (this.historyRecordManager.historyRecord.length != 0) {
      Column() {
        Row() {
          Text($r('app.string.search_for_records'))
            .fontSize($r('app.string.font_20'))
            .fontColor($r('app.color.text_color_white'))
            .fontWeight(FontWeight.Bold);
          Blank();
          Text($r('app.string.purge'))
            .fontSize($r('app.string.font_20'))
            .fontColor($r('app.color.text_color_white'))
            .onClick(() => {
              this.historyRecordManager.deleteHistoryRecord();
            });
        }.width('100%').margin({ bottom: 10 });

        Flex({ wrap: FlexWrap.Wrap }) {
          ForEach(this.historyRecordManager.historyRecord.reverse(), (record: string) => {
            Text(record)
              .onClick(() => {
                this.currentSearchField = record;
              })
              .borderRadius(10)
              .padding({
                left: 10,
                right: 10,
                top: 5,
                bottom: 5
              })
              .height(25)
              .backgroundColor($r('app.color.default_search_bg'))
              .margin(5)
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .fontSize(12)
              .constraintSize({ maxWidth: 100 });
          });
        }.width('100%');
      }.width('100%').padding({ left: 20, right: 20, top: 20 });
    }
  }
}