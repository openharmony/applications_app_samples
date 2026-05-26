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

import { CommonConstants, Logger, RelativeRules } from '@ohos/common';
import DeviceItem from '../common/bean/DeviceItem';
import DragSceneConstants from '../common/constants/DragSceneConstants';
import DevicesModel from '../viewmodel/DeviceModel';
import { DeviceAnimation } from './DeviceAnimation';
import { KeyCode } from '@ohos.multimodalInput.keyCode';

@Component
export struct DevicesDragView {
  originSize: number = DragSceneConstants.DEVICE_CIRCULAR_SIZE;
  @Consume devicesModel: DevicesModel;
  @Consume triggers: Array<DeviceItem>;
  @Consume actions: Array<DeviceItem>;
  @State dragDeviceInfo: DeviceItem = new DeviceItem('', $r('app.media.ic_device'), '', '');
  @State selectIndex: number = -1;
  // 拖拽回调
  cbFunction = (result: DeviceItem) => {
    this.dragDeviceInfo = result;
  };

  @Builder
  DeviceBuilder(type: number, item: DeviceItem, index: number) {
    Column() {
      Stack() {
        Button()
          .linearGradient(item.deviceType == this.dragDeviceInfo.deviceType ?
            { angle: 180, colors: [['rgba(191, 208, 238, 1)', 0], ['rgba(232, 64, 38, 0.20)', 1]] } : item.image ?
              {
                angle: 180,
                colors: [['rgba(10, 89, 247, 0.30)', 0], ['rgba(77, 137, 255, 0.69)', 0.38], ['#0A59F7', 0.8]]
              } :
              {
                angle: 180,
                colors: [['rgba(140, 165, 210, 1)', 0], ['rgba(191, 208, 238, 1)', 0.5], ['#E2EBF9', 0.75],
                  ['#FFFFFFF', 1]]
              })
          .width(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .height(DragSceneConstants.DEVICE_ITEM_BG_SIZE)
          .borderStyle(BorderStyle.Dashed)
          .borderWidth(1)
          .borderColor(item.deviceType == this.dragDeviceInfo.deviceType ? 'rgba(232, 64, 38, 0.6)' :
            'rgba(10,89,247,0.6)')
          .borderRadius('30vp')
          .onKeyEvent((event) => {
            if (event.type == KeyType.Down) {
              if (event.keyCode == KeyCode.KEYCODE_ENTER || event.keyCode == KeyCode.KEYCODE_DPAD_CENTER) {
                if (AppStorage.get('selectItem')) {
                  if (item.deviceName == AppStorage.get('selectItem')) {
                    if (type === 1) {
                      let isAdded = this.devicesModel.getAddedTriggers(type, index, this.triggers[index].deviceType,
                        this.dragDeviceInfo);
                      Logger.info('isAdded:' + isAdded);
                      if (isAdded) {
                        this.triggers[index] = new DeviceItem(this.dragDeviceInfo.deviceId, this.dragDeviceInfo.image,
                          this.dragDeviceInfo.deviceName, this.dragDeviceInfo.deviceType);
                      }
                    } else {
                      let isAdded = this.devicesModel.getAddedTriggers(type, index, this.actions[index].deviceType,
                        this.dragDeviceInfo);
                      Logger.info('isAdded:' + isAdded);
                      if (isAdded) {
                        this.actions[index] = new DeviceItem(this.dragDeviceInfo.deviceId, this.dragDeviceInfo.image,
                          this.dragDeviceInfo.deviceName, this.dragDeviceInfo.deviceType);
                      }
                    }
                  }
                }
              }
            }
          });
        Image(item.image)
          .width('15lpx');
      }
      .focusable(true)
      .groupDefaultFocus(true);

      Text(item.deviceName)
        .fontSize($r('app.string.device_item_name_font_size'))
        .height(DragSceneConstants.DEVICE_ITEM_NAME_SIZE)
        .margin({
          top: DragSceneConstants.DEVICE_ITEM_PADDING
        });
    }
    .groupDefaultFocus(true)
    .focusable(true)
    .width('80vp')
    .height('80vp')
    .onDrop((event: DragEvent, extraParams?: string) => {
      Logger.info('onDrop,x=' + event.getWindowX() + ',y=' + event.getWindowY());
      if (type === 1) {
        let isAdded =
          this.devicesModel.getAddedTriggers(type, index, this.triggers[index].deviceType, this.dragDeviceInfo);
        Logger.info('isAdded:' + isAdded);
        if (isAdded) {
          this.triggers[index] =
            new DeviceItem(this.dragDeviceInfo.deviceId, this.dragDeviceInfo.image, this.dragDeviceInfo.deviceName,
              this.dragDeviceInfo.deviceType);
        }
      } else {
        let isAdded =
          this.devicesModel.getAddedTriggers(type, index, this.actions[index].deviceType, this.dragDeviceInfo);
        Logger.info('isAdded:' + isAdded);
        if (isAdded) {
          this.actions[index] =
            new DeviceItem(this.dragDeviceInfo.deviceId, this.dragDeviceInfo.image, this.dragDeviceInfo.deviceName,
              this.dragDeviceInfo.deviceType);
        }
      }
      event.useCustomDropAnimation = false;
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      Logger.info('onDragMove(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
    });
  }

  build() {
    RelativeContainer() {
      Column() {
        Row() {
          ForEach(this.triggers, (item: DeviceItem, index: number) => {
            Column() {
              this.DeviceBuilder(1, item, index);
            }
            .key(`ocus_${index}`)
            .tabIndex(index);
          }, (item: DeviceItem) => JSON.stringify(item.deviceId));
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius({
          bottomLeft: 0,
          bottomRight: 0,
          topLeft: this.originSize / 2,
          topRight: this.originSize / 2
        })
        .width(this.originSize)
        .height(this.originSize / 2)
        .backgroundColor('rgba(10,89,247,0.5)');

        Row() {
          ForEach(this.actions, (item: DeviceItem, index: number) => {
            this.DeviceBuilder(2, item, index);
          }, (item: DeviceItem) => JSON.stringify(item.deviceId));
        }
        .justifyContent(FlexAlign.Center)
        .borderRadius({
          bottomLeft: this.originSize / 2,
          bottomRight: this.originSize / 2,
          topLeft: 0,
          topRight: 0
        })
        .width(this.originSize)
        .height(this.originSize / 2)
        .backgroundColor('rgba(10,89,247,0.1)');
      }
      .width(this.originSize)
      .height(this.originSize)
      .alignRules(RelativeRules.centerRule)
      .id('center_bg');

      ForEach(this.devicesModel.devicesArray, (item: DeviceItem, index: number) => {
        DeviceAnimation(
          {
            item: item,
            cbFunction: this.cbFunction,
            index: index,
            selectIndex: this.selectIndex
          }
        )
          .alignRules(
            {
              center: { 'anchor': '__container__', align: VerticalAlign.Center },
              middle: { 'anchor': '__container__', align: HorizontalAlign.Center }
            }
          ).id('device' + index)
          .tabIndex(this.triggers.length - 1 + index);
      }, (item: DeviceItem) => JSON.stringify(item));
    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT);
  }
}


