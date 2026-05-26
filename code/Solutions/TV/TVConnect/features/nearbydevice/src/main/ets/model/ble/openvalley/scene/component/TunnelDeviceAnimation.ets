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
import { Logger } from '@ohos/common';
import DragSceneConstants from '../../../../../constants/DragSceneConstants';
import TunnelSceneModel, { TunnelDevice } from '../model/TunnelSceneModel';


/**
 * 待连接设备组件(拖拽)
 */

const TAG = 'TunnelDeviceAnimation';

@Component
export struct TunnelDeviceAnimation {
  @ObjectLink item: TunnelDevice;
  @State isHide: boolean = true;
  @Consume model: TunnelSceneModel;

  aboutToAppear() {
    Logger.debug(TAG, 'TunnelDeviceAnimation.aboutToAppear()');
    setTimeout(() => {
      this.isHide = false;
    }, 50);
  }

  isDraggable(): boolean {
    return !this.model.currentDraggingDevice;
  }

  //当前设备未拖拽或者连接
  isVisible(): boolean {
    return (!this.item.isInset && !this.item.isDragging);
  }

  build() {
    Column() {
      Stack() {
        Button()
          .width(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .borderRadius('30vp')
          .backgroundColor($r('app.color.button_opcaity'));
        Image($r('app.media.bg_light_equipment'))
          .width(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .draggable(false);
        Image(this.item.image)
          .width(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
          .draggable(false);
      };

      Text(this.item.desc)
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
      this.item.isDragging = true;
      this.model.currentDraggingDevice = this.item;
      this.model.currentDraggingDeviceType = this.item.type;
    })
    .onDragEnd((event: DragEvent, extraParams?: string) => {
      Logger.debug('onDragEnd(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
      const result = event.getResult();
      const isFailed =
        result == DragResult.DRAG_FAILED || result == DragResult.DRAG_CANCELED || result == DragResult.DROP_DISABLED;
      if (!isFailed) {
        //嵌入成功
        Logger.debug('当前元素嵌入成功' + JSON.stringify(this.item));
      }
      //取消拖拽状态
      this.item.isDragging = false;
      this.model.currentDraggingDevice = undefined;
      this.model.currentDraggingDeviceType = undefined;
    });
  }
}