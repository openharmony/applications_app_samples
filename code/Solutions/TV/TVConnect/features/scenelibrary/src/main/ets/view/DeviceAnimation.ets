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
import DragSceneConstants from '../common/constants/DragSceneConstants';
import DeviceItem from '../common/bean/DeviceItem';
import DevicesModel from '../viewmodel/DeviceModel';
import { Logger } from '@ohos/common';
import { KeyCode } from '@kit.InputKit';

/**
 * 待连接设备组件(拖拽)
 */
@Component
export struct DeviceAnimation {
  @ObjectLink item: DeviceItem;
  @State isHide: boolean = true;
  @Consume devicesModel: DevicesModel;
  //当前正在拖拽的设备id
  @LocalStorageLink('draggingIndex') draggingIndex: string = '';
  @Prop index: number;
  @State selectItem: string = '';
  @Link selectIndex: number;
  cbFunction: (result: DeviceItem) => void = (result: DeviceItem) => {
  };

  aboutToAppear() {
    setTimeout(() => {
      this.isHide = false;
    }, 50);
  }

  // 当前设备未设置或已设置
  isVisible(): boolean {
    Logger.info('this.devicesModel.triggers:' + JSON.stringify(this.devicesModel.triggers));
    Logger.info('this.devicesModel.actions:' + JSON.stringify(this.devicesModel.actions));
    let isTriggerVisible = this.devicesModel.triggers.filter((item: DeviceItem) => {
      return item.deviceId == this.item.deviceId;
    }).length == 0;
    let isActionVisible: boolean = this.devicesModel.actions.filter((item: DeviceItem) => {
      return item.deviceId == this.item.deviceId;
    }).length == 0;
    return this.draggingIndex != this.item.deviceId && isTriggerVisible && isActionVisible;
  }

  build() {
    Column() {
      Stack() {
        Button()
          .width(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .borderRadius('30vp')
          .backgroundColor($r('app.color.button_opcaity'))
          .border({ width: this.index == this.selectIndex ? '10lpx' : 0, color: $r('app.color.divider') });
        Image($r('app.media.bg_light_equipment'))
          .width(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .draggable(false);
        Image(this.item.image)
          .width('12lpx')
          .draggable(false);
      }
      .onKeyEvent((event) => {
        if (event.type == KeyType.Down) {
          if (event.keyCode == KeyCode.KEYCODE_ENTER || event.keyCode == KeyCode.KEYCODE_DPAD_CENTER) {
            this.selectItem = this.item.deviceId;
            this.selectIndex = this.index;
            AppStorage.setOrCreate('selectItem', this.item.deviceName);
            this.cbFunction(this.item);
            return;
          }
        }

      });

      Text(this.item.deviceName)
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
    .draggable(true)
    .onDragStart((event: DragEvent, extraParams?: string) => {
      Logger.debug('onDragStart(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
      this.draggingIndex = this.item.deviceId;
      this.cbFunction(this.item);
    })
    .onDragEnd((event: DragEvent, extraParams?: string) => {
      Logger.debug('onDragEnd(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
      this.cbFunction(new DeviceItem('', $r('app.media.ic_device'), '', ''));
      //取消拖拽状态
      this.draggingIndex = '';
    });
  }
}