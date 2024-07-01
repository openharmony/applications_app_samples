/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import componentSnapshot from '@ohos.arkui.componentSnapshot';
import image from '@ohos.multimedia.image';

@Component
export struct MultiSelectDrag {
  @Styles normalStyles() {
    .borderColor('#E5E5E1')
    .opacity(1.0)
  }

  @Styles selectStyles() {
    .borderColor('#ff1d0e04')
    .opacity(0.4)
  }

  @State number1: number[] = [0, 1, 2, 3, 4];
  @State number2: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8];
  @State isSelectedGrid: boolean[] = [false, false, false, false, false, false, false, false, false];
  @State colors: Color[] =
    [Color.Red, Color.Blue, Color.Brown, Color.Gray, Color.Green, Color.Gray, Color.Orange, Color.Pink, Color.Yellow];
  @State previewData: DragItemInfo[] = [{}, {}, {}, {}, {}, {}, {}, {}, {}];
  @State pixmap: image.PixelMap | undefined = undefined;

  @Builder
  createGrid() {
    Grid() {
      ForEach(this.number2, (index: number) => {
        GridItem() {
          Column()
            .backgroundColor(this.colors[index])
            .width('100%')
            .height(90)
            .draggable(false)
            .id(`gridItemId${index}`)
        }
        .selectable(true)
        .selected(this.isSelectedGrid[index])
        .stateStyles({
          normal: this.normalStyles,
          selected: this.selectStyles
        })
        .onClick(() => {
          this.isSelectedGrid[index] = !this.isSelectedGrid[index];
          if (!this.isSelectedGrid[index]) {
            componentSnapshot.get(`gridItemId${index}`, (error: Error, pixmap: image.PixelMap) => {
              this.pixmap = pixmap;
              this.previewData[index] = {
                pixelMap: this.pixmap
              };
            })
          }
        })
        .dragPreviewOptions({
          mode: [DragPreviewMode.ENABLE_DEFAULT_SHADOW, DragPreviewMode.ENABLE_DEFAULT_RADIUS]
        }, { isMultiSelectionEnabled: true, defaultAnimationBeforeLifting: true })
        .dragPreview(`gridItemId${index}`)
        .onDragStart(() => {

        })
      }, (index: string) => index)
    }
    .columnsTemplate('1fr 1fr 1fr')
    .columnsGap(10)
    .rowsGap(10)
    .width(290)
    .backgroundColor(0xFAEEE0)
  }

  build() {
    Column() {
      this.createGrid();
    }
    .width('100%')
    .height(290)
  }
}