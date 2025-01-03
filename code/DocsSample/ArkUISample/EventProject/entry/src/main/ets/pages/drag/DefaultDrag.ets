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

import { unifiedDataChannel, uniformTypeDescriptor } from '@kit.ArkData';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { image } from '@kit.ImageKit';

@Entry
@Component
export struct DefaultDrag {
  @State targetImage: string = '';
  @State imageWidth: number = 100;
  @State imageHeight: number = 100;
  @State imgState: Visibility = Visibility.Visible;
  @State pixmap: image.PixelMap | undefined = undefined;

  @Builder
  pixelMapBuilder() {
    Column() {
      Image($r('app.media.startIcon'))
        .width(120)
        .height(120)
        .backgroundColor(Color.Yellow)
    }
  }

  getDataFromUdmfRetry(event: DragEvent, callback: (data: DragEvent) => void) {
    try {
      let data: UnifiedData = event.getData();
      if (!data) {
        return false;
      }
      let records: unifiedDataChannel.UnifiedRecord[] = data.getRecords();
      if (!records || records.length <= 0) {
        return false;
      }
      callback(event);
      return true;
    } catch (e) {
      console.log('getData failed, code: ' + (e as BusinessError).code + ', message: ' + (e as BusinessError).message);
      return false;
    }
  }

  // 获取UDMF数据，首次获取失败后添加1500ms延迟重试机制
  getDataFromUdmf(event: DragEvent, callback: (data: DragEvent) => void) {
    if (this.getDataFromUdmfRetry(event, callback)) {
      return;
    }
    setTimeout(() => {
      this.getDataFromUdmfRetry(event, callback);
    }, 1500);
  }

  // 调用componentSnapshot中的createFromBuilder接口截取自定义builder的截图
  private getComponentSnapshot(): void {
    this.getUIContext().getComponentSnapshot().createFromBuilder(() => {
      this.pixelMapBuilder()
    },
      (error: Error, pixmap: image.PixelMap) => {
        if (error) {
          console.log('error: ' + JSON.stringify(error));
          return;
        }
        this.pixmap = pixmap;
      })
  }

  // 长按50ms时提前准备自定义截图的pixmap
  private PreDragChange(preDragStatus: PreDragStatus): void {
    if (preDragStatus == PreDragStatus.ACTION_DETECTING_STATUS) {
      this.getComponentSnapshot();
    }
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Row() {
          Column() {
            Text('start Drag')
              .fontSize(18)
              .width('100%')
              .height(40)
              .margin(10)
              .backgroundColor('#008888')
            Row() {
              Image($r('app.media.app_icon'))
                .width(100)
                .height(100)
                .draggable(true)
                .margin({ left: 15 })
                .visibility(this.imgState)// 绑定平行手势，可同时触发应用自定义长按手势
                .parallelGesture(LongPressGesture().onAction(() => {
                  promptAction.showToast({ duration: 100, message: 'Long press gesture trigger' });
                }))
                .onDragStart((event) => {
                  let data: unifiedDataChannel.Image = new unifiedDataChannel.Image();
                  data.imageUri = 'common/pic/img.png';
                  let unifiedData = new unifiedDataChannel.UnifiedData(data);
                  event.setData(unifiedData);

                  let dragItemInfo: DragItemInfo = {
                    pixelMap: this.pixmap,
                    extraInfo: 'this is extraInfo',
                  };
                  return dragItemInfo;
                })// 提前准备拖拽自定义背板图
                .onPreDrag((status: PreDragStatus) => {
                  this.PreDragChange(status);
                })
                .onDragEnd((event) => {
                  // onDragEnd里取到的result值在接收方onDrop设置
                  if (event.getResult() === DragResult.DRAG_SUCCESSFUL) {
                    promptAction.showToast({ duration: 100, message: 'Drag Success' });
                  } else if (event.getResult() === DragResult.DRAG_FAILED) {
                    promptAction.showToast({ duration: 100, message: 'Drag failed' });
                  }
                })
            }

            Text('Drag Target Area')
              .fontSize(20)
              .width('100%')
              .height(40)
              .margin(10)
              .backgroundColor('#008888')
            Row() {
              Image(this.targetImage)
                .width(this.imageWidth)
                .height(this.imageHeight)
                .draggable(true)
                .margin({ left: 15 })
                .border({ color: Color.Black, width: 1 })// 控制角标显示类型为MOVE，即不显示角标
                .onDragMove((event) => {
                  event.setResult(DragResult.DROP_ENABLED)
                  event.dragBehavior = DragBehavior.MOVE
                })
                .allowDrop([uniformTypeDescriptor.UniformDataType.IMAGE])
                .onDrop((dragEvent?: DragEvent) => {
                  // 获取拖拽数据
                  this.getDataFromUdmf((dragEvent as DragEvent), (event: DragEvent) => {
                    let records: unifiedDataChannel.UnifiedRecord[] = event.getData().getRecords();
                    let rect: Rectangle = event.getPreviewRect();
                    this.imageWidth = Number(rect.width);
                    this.imageHeight = Number(rect.height);
                    this.targetImage = (records[0] as unifiedDataChannel.Image).imageUri;
                    this.imgState = Visibility.None;
                    // 显式设置result为successful，则将该值传递给拖出方的onDragEnd
                    event.setResult(DragResult.DRAG_SUCCESSFUL);
                  })
                })
            }
          }
          .width('100%')
          .height('100%')
        }
        .height('100%')

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Drag_DefaultDrag_title'))
  }
}