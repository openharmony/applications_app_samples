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
import { CommonConstants, Logger } from '@ohos/common';
import DragSceneConstants from '../constants/DragSceneConstants';
import DeviceItem from '../viewmodel/DeviceItem';
import DevicesManager from '../viewmodel/DevicesManager';
import DevicesModel from '../viewmodel/DevicesModel';
import DragModel from '../viewmodel/DragModel';

const TAG: string = 'DeviceAnimation';

/**
 * 待连接设备组件(拖拽)
 */
@Component
export struct DeviceAnimation {
  @ObjectLink item: DeviceItem;
  @State isHide: boolean = true;
  @Consume dragModel: DragModel;
  @Consume devicesModel: DevicesModel;

  aboutToAppear() {
    setTimeout(() => {
      this.isHide = false;
    }, 50);
  }

  isDraggable(): boolean {
    return this.dragModel.currentDraggingIndex == -1;
  }

  //当前设备未拖拽或者连接
  isVisible(): boolean {
    return this.dragModel.currentDraggingIndex != this.item.index &&
      this.devicesModel.connectingDevice?.index != this.item.index;
  }

  build() {
    Column() {
      Stack() {
        Image(this.item.isVirtual ? $r('app.media.bg_light_equipment_virtual') : $r('app.media.bg_light_equipment'))
          .width(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .draggable(false);
        Image(this.item.image)
          .alt(CommonConstants.DEFAULT_DEVICE_ICON)
          .width(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
          .draggable(false)
          .onError((err) => {
            Logger.debug(TAG, '缩略图加载异常:' + JSON.stringify(err));
          });
      };

      Text(this.item.name)
        .fontSize($r('app.string.device_item_name_font_size'))
        .height(DragSceneConstants.DEVICE_ITEM_NAME_SIZE)
        .margin({
          top: DragSceneConstants.DEVICE_ITEM_PADDING
        })
        .draggable(false);
    }
    .visibility(this.isVisible() ? Visibility.Visible : Visibility.Hidden)
    .translate(this.isHide ?
      {
        x: 0,
        y: 0
      } :
      {
        x: this.item.point.x,
        y: this.item.point.y,
      })
    .scale(
      this.isHide ?
        { x: 0.5, y: 0.5 } :
        { x: 1, y: 1 }
    )
    .opacity(this.isHide ? 0.2 : 1)
    // 控件出现时的动画效果
    .animation(
      {
        delay: 10,
        duration: this.isVisible() ? 600 : 200,
        iterations: 1,
        curve: Curve.Smooth,
        playMode: PlayMode.Normal
      }
    )
    .draggable(this.isDraggable())
    .onDragStart((event: DragEvent, extraParams?: string) => {
      Logger.debug('onDragStart(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
      this.dragModel.currentDraggingIndex = this.item.index;
    })
    .onDragEnd((event: DragEvent, extraParams?: string) => {
      Logger.debug('onDragEnd(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
      const result = event.getResult();
      const isFailed =
        result == DragResult.DRAG_FAILED || result == DragResult.DRAG_CANCELED || result == DragResult.DROP_DISABLED;
      if (!isFailed) {
        //直接开始连接
        DevicesManager.getInstance().connect(this.item.index);
      }
      //取消拖拽状态
      this.dragModel.currentDraggingIndex = -1;
    });
  }
}