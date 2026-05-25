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
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import LogManager from '../../common/Log/LogManager';

const TAG = 'ThumbnailList';

@Component
export default struct ThumbnailList {
  @Link @Watch('updateThumbnails') thumbnails: PixelMap[];
  @Link photoInfos: photoAccessHelper.PhotoAsset[];
  private itemHeight: number = 230;
  private space: number = 20;
  @State private columnsTemplate: string = '1fr 1fr 1fr';
  @State private rowsTemplate: string = '1fr';
  @State private gridHeight: number = 0;

  private updateThumbnails() {
    LogManager.hilogIWithTag(TAG, `updateThumbnails, thumbnails.length: ${JSON.stringify(this.thumbnails.length)}`);
    let lineCount = (this.thumbnails.length % 3 == 0) ? Math.floor(this.thumbnails.length / 3) :
      (Math.floor(this.thumbnails.length / 3) + 1);
    this.gridHeight = lineCount * this.itemHeight + (lineCount - 1) * this.space;

    LogManager.hilogIWithTag(TAG,
      `updateThumbnails, lineCount: ${JSON.stringify(lineCount)}, gridHeight: ${JSON.stringify(this.gridHeight)}`);

    let rowsTemplate = '1fr';
    for (let index = 1; index < lineCount; index++) {
      rowsTemplate += ' 1fr';
    }
    this.rowsTemplate = rowsTemplate;
    LogManager.hilogIWithTag(TAG, `updateThumbnails, rowsTemplate: ${JSON.stringify(rowsTemplate)}`);
  }

  build() {
    Grid() {
      ForEach(this.thumbnails, (item: PixelMap, index) => {
        GridItem() {
          Image(item)
            .width('100%')
            .height(this.itemHeight + 'lpx');
        };
      });
    }
    .columnsTemplate(this.columnsTemplate)
    .rowsTemplate(this.rowsTemplate)
    .columnsGap(this.space + 'lpx')
    .rowsGap(this.space + 'lpx')
    .height(this.gridHeight + 'lpx');
  }
}