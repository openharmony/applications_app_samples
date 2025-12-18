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
//[Start gridExample_start]
import { image } from '@kit.ImageKit';
import { unifiedDataChannel as UDC } from '@kit.ArkData';
import { dragController } from '@kit.ArkUI';

@Entry
@Component
struct GridEts {
  @State pixmap: image.PixelMap | undefined = undefined;
  @State numbers: number[] = [];
  @State isSelectedGrid: boolean[] = [];
  @State previewData: DragItemInfo[] = [];
  @State numberBadge: number = 0;
  unifiedData: UnifiedData | undefined = undefined;
  timeout: number = 1;
  finished: boolean = false;
  dragEvent: DragEvent | undefined;

  @Styles
  normalStyles(): void{
    .opacity(1.0);
  }

  @Styles
  selectStyles(): void{
    .opacity(0.4);
  }

  //[Start gridExample_onPageShow]
  onPageShow(): void {
    let i: number = 0;
    for (i = 0; i < 500; i++) {
      this.numbers.push(i);
      this.isSelectedGrid.push(false);
      this.previewData.push({});
    }
  }

  //[End gridExample_onPageShow]
  loadData() {
    this.timeout = setTimeout(() => {
      //数据准备完成后的状态
      if (this.dragEvent) {
        this.dragEvent.setData(this.unifiedData);
      }
      this.getUIContext().getDragController().notifyDragStartRequest(dragController.DragStartRequestStatus.READY);
      this.finished = true;
    }, 4000);
  }

  @Builder
  RandomBuilder(idx: number) {
    Column()
      .backgroundColor(Color.Blue)
      .width(50)
      .height(50)
      .opacity(1.0)
  }

  build() {
    Column({ space: 5 }) {
      // app.string.Select_All资源文件中的value值为'全选'
      Button($r('app.string.Select_All'))
        .onClick(() => {
          for (let i = 0; i < this.isSelectedGrid.length; i++) {
            if (this.isSelectedGrid[i] === false) {
              this.numberBadge++;
              this.isSelectedGrid[i] = true;
              let data: UDC.Image = new UDC.Image();
              // '/resource/image.jpeg'需要替换为开发者所需的图像资源文件
              data.uri = '/resource/image.jpeg';
              if (!this.unifiedData) {
                this.unifiedData = new UDC.UnifiedData(data);
              }
              this.unifiedData.addRecord(data);
              let gridItemName = 'grid' + i;
              // 选中状态下提前调用componentSnapshot中的get接口获取pixmap
              this.getUIContext().getComponentSnapshot().get(gridItemName, (error: Error, pixmap: image.PixelMap) => {
                this.pixmap = pixmap;
                this.previewData[i] = {
                  pixelMap: this.pixmap
                };
              });
            }
          }
        })
      Grid() {
        ForEach(this.numbers, (idx: number) => {
          GridItem() {
            Column()
              .backgroundColor(Color.Blue)
              .width(50)
              .height(50)
              .opacity(1.0)
              .id('grid' + idx)
          }
          .dragPreview(this.previewData[idx])
          .dragPreviewOptions({ numberBadge: this.numberBadge },
            { isMultiSelectionEnabled: true, defaultAnimationBeforeLifting: true })
          .selectable(true)
          .selected(this.isSelectedGrid[idx])
          // 设置多选显示效果
          .stateStyles({
            normal: this.normalStyles,
            selected: this.selectStyles
          })
          //[Start gridExample_onclick]
          .onClick(() => {
            this.isSelectedGrid[idx] = !this.isSelectedGrid[idx];
            if (this.isSelectedGrid[idx]) {
              let data: UDC.Image = new UDC.Image();
              // '/resource/image.jpeg'需要替换为开发者所需的图像资源文件
              data.uri = '/resource/image.jpeg';
              if (!this.unifiedData) {
                this.unifiedData = new UDC.UnifiedData(data);
              }
              this.unifiedData.addRecord(data);
              this.numberBadge++;
              let gridItemName = 'grid' + idx;
              // 选中状态下提前调用componentSnapshot中的get接口获取pixmap
              this.getUIContext().getComponentSnapshot().get(gridItemName, (error: Error, pixmap: image.PixelMap) => {
                this.pixmap = pixmap;
                this.previewData[idx] = {
                  pixelMap: this.pixmap
                };
              });
            } else {
              this.numberBadge--;
              for (let i = 0; i < this.isSelectedGrid.length; i++) {
                if (this.isSelectedGrid[i] === true) {
                  let data: UDC.Image = new UDC.Image();
                  // '/resource/image.jpeg'需要替换为开发者所需的图像资源文件
                  data.uri = '/resource/image.jpeg';
                  if (!this.unifiedData) {
                    this.unifiedData = new UDC.UnifiedData(data);
                  }
                  this.unifiedData.addRecord(data);
                }
              }
            }
          })
          //[End gridExample_onclick]
          //[StartExclude gridExample_start]
          //[Start gridExample_onPreDrag]
          .onPreDrag((status: PreDragStatus) => {
            if (status == PreDragStatus.PREPARING_FOR_DRAG_DETECTION) {
              this.loadData();
            }
          })
          //[End gridExample_onPreDrag]
          //[EndExclude gridExample_start]
          .onPreDrag((status: PreDragStatus) => {
            // 1.长按时通知，350ms回调
            if (status == PreDragStatus.PREPARING_FOR_DRAG_DETECTION) {
              // 2.用户按住一段时间，还没有松手，有可能会拖拽，此时可准备数据
              this.loadData();
            } else if (status == PreDragStatus.ACTION_CANCELED_BEFORE_DRAG) {
              // 3.用户停止拖拽交互，取消数据准备(模拟方法：定时器取消)
              clearTimeout(this.timeout);
            }
          })
          // >=500ms,移动超过10vp触发
          //[Start gridExample_onDragStart]
          .onDragStart((event: DragEvent) => {
            this.dragEvent = event;
            if (this.finished == false) {
              this.getUIContext()
                .getDragController()
                .notifyDragStartRequest(dragController.DragStartRequestStatus.WAITING);
            } else {
              event.setData(this.unifiedData);
            }
          })
          //[End gridExample_onDragStart]
          .onDragEnd(() => {
            this.finished = false;
          })
          .dragPreviewOptions({ numberBadge: this.numberBadge },
            { isMultiSelectionEnabled: true, defaultAnimationBeforeLifting: true })
        }, (idx: string) => idx)
      }
      .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
      .columnsGap(5)
      .rowsGap(10)
      .backgroundColor(0xFAEEE0)
    }.width('100%').margin({ top: 5 })
  }
}

//[End gridExample_start]
