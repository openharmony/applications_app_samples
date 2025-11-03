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

//[Start GridEts_start]
import { image } from '@kit.ImageKit';
import { unifiedDataChannel as UDC } from '@kit.ArkData';
import { dragController } from '@kit.ArkUI';

export const gridRoutePrefix: string = 'gridExample';

@Entry
@Component
export struct GridEts {
  @Consume pathStack: NavPathStack;
  @State pixmap: image.PixelMap | undefined = undefined;
  @State numbers: number[] = [];
  //[Start grid_previewData_start]
  @State previewData: DragItemInfo[] = [];
  @State isSelectedGrid: boolean[] = [];
  //[StartExclude grid_previewData_start]
  //[Start grid_numberBadge_start]
  @State numberBadge: number = 0;
  unifiedData: UnifiedData | undefined = undefined;
  timeout: number = 1;
  finished: boolean = false;
  dragEvent: DragEvent | undefined;

  //[Start grid_styles_start]
  @Styles
  normalStyles(): void {
    .opacity(1.0)
  }

  @Styles
  selectStyles(): void {
    .opacity(0.4)
  }

  //[StartExclude grid_styles_start]
  aboutToAppear(): void {
    let i: number = 0
    for (i = 0; i < 500; i++) {
      this.numbers.push(i)
      this.isSelectedGrid.push(false)
      this.previewData.push({})
    }
  }

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
    NavDestination() {
      Column({ space: 5 }) {
        Button('全选')
          .onClick(() => {
            for (let i = 0; i < this.isSelectedGrid.length; i++) {
              if (this.isSelectedGrid[i] === false) {
                this.numberBadge++;
                this.isSelectedGrid[i] = true;
                let data: UDC.Image = new UDC.Image();
                // '../../../resources/base/media/background.png'需要替换为开发者所需的图像资源文件
                data.uri = '/resources/base/media/background.png';
                if (!this.unifiedData) {
                  this.unifiedData = new UDC.UnifiedData(data);
                }
                this.unifiedData.addRecord(data);
                let gridItemName = 'grid' + i;
                // 选中状态下提前调用componentSnapshot中的get接口获取pixmap
                this.getUIContext().getComponentSnapshot().get(gridItemName, (error: Error, pixmap: image.PixelMap) => {
                  this.pixmap = pixmap
                  this.previewData[i] = {
                    pixelMap: this.pixmap
                  }
                })
              }
            }
          })
        //[Start grid_start]
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
            //[Start dragPreview_Start]
            //[StartExclude grid_start]
            .dragPreview({
              pixelMap: this.pixmap
            })
            //[End dragPreview_Start]
            .dragPreview(this.previewData[idx])
            //[EndExclude grid_start]
            .onDragStart(() => {
            })
            .selectable(true)
            //[Start grid_isSelected_start]
            .selected(this.isSelectedGrid[idx])
            //[StartExclude grid_isSelected_start]
            // 设置多选显示效果
            //[EndExclude grid_styles_start]
            .stateStyles({
              normal: this.normalStyles,
              selected: this.selectStyles
            })
            //[End grid_styles_start]
            //[EndExclude grid_isSelected_start]
            //[EndExclude grid_previewData_start]
            //[StartExclude grid_numberBadge_start]
            .onClick(() => {
              this.isSelectedGrid[idx] = !this.isSelectedGrid[idx];
              //[StartExclude grid_isSelected_start]
              if (this.isSelectedGrid[idx]) {
                //[StartExclude grid_previewData_start]
                //[StartExclude grid_numberBadge_start]
                let data: UDC.Image = new UDC.Image();
                // '../../../resources/base/media/background.png'需要替换为开发者所需的图像资源文件
                data.uri = '../../../resources/base/media/background.png';
                if (!this.unifiedData) {
                  this.unifiedData = new UDC.UnifiedData(data);
                }
                this.unifiedData.addRecord(data);
                //[EndExclude grid_numberBadge_start]
                this.numberBadge++;
                //[EndExclude grid_previewData_start]
                let gridItemName = 'grid' + idx;
                // 选中状态下提前调用componentSnapshot中的get接口获取pixmap
                this.getUIContext().getComponentSnapshot().get(gridItemName, (error: Error, pixmap: image.PixelMap) => {
                  this.pixmap = pixmap;
                  this.previewData[idx] = {
                    pixelMap: this.pixmap
                  }
                })
                //[StartExclude grid_previewData_start]
              } else {
                this.numberBadge--;
                //[StartExclude grid_numberBadge_start]
                for (let i = 0; i < this.isSelectedGrid.length; i++) {
                  if (this.isSelectedGrid[i] === true) {
                    let data: UDC.Image = new UDC.Image();
                    // '../../../resources/base/media/background.png'需要替换为开发者所需的图像资源文件
                    data.uri = '../../../resources/base/media/background.png';
                    if (!this.unifiedData) {
                      this.unifiedData = new UDC.UnifiedData(data);
                    }
                    this.unifiedData.addRecord(data);
                  }
                }
              }
              //[EndExclude grid_isSelected_start]
              //[EndExclude grid_previewData_start]
              //[EndExclude grid_numberBadge_start]
            })
            .dragPreviewOptions({ numberBadge: this.numberBadge })
            //[End grid_numberBadge_start]
            //[Start grid_isSelected_start]
            .onPreDrag((status: PreDragStatus) => {
              // 1.长按时通知，350ms回调
              if (status == PreDragStatus.PREPARING_FOR_DRAG_DETECTION) {
                // 2.用户按住一段时间，还没有松手，有可能会拖拽，此时可准备数据
                this.loadData()
              } else if (status == PreDragStatus.ACTION_CANCELED_BEFORE_DRAG) {
                // 3.用户停止拖拽交互，取消数据准备(模拟方法：定时器取消)
                clearTimeout(this.timeout);
              }
            })
            // >=500ms,移动超过10vp触发
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
            .onDragEnd(() => {
              this.finished = false;
            })

            //[EndExclude grid_start]
          }, (idx: string) => idx)
        }
        //[End grid_previewData_start]
        //[End grid_start]
        .width('100%')
        .height('100%')
        .columnsTemplate('1fr 1fr 1fr 1fr 1fr')
        .columnsGap(5)
        .rowsGap(10)
        .backgroundColor(0xFAEEE0)

        //[Start gridExample_start]
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
            .stateStyles({
              normal: this.normalStyles,
              selected: this.selectStyles
            })
            .onClick(() => {
              this.isSelectedGrid[idx] = !this.isSelectedGrid[idx];
            })
          }, (idx: string) => idx)
        }

        //[End gridExample_start]
      }.width('100%').margin({ top: 5 }).height('100%')
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .title($r('app.string.Pages_Index_GridExample'))
  }
}

//[End GridEts_start]