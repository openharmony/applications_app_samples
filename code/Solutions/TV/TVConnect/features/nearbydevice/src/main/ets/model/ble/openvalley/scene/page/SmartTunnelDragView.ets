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
import { CommonConstants, Logger, RelativeRules } from '@ohos/common/index';
import DragSceneConstants from '../../../../../constants/DragSceneConstants';
import DeviceItem from '../../../../../viewmodel/DeviceItem';
import { TunnelDeviceAnimation } from '../component/TunnelDeviceAnimation';
import TunnelSceneModel, {
  getTunnelDeviceName,
  TunnelDevice,
  TunnelDeviceType,
  TunnelSlot
} from '../model/TunnelSceneModel';
import TunnelScanManager from '../TunnelScanManager';

const TAG = 'SmartTunnelDragView';

@Component
export struct SmartTunnelDragView {
  @Consume model: TunnelSceneModel;
  originSize: number = DragSceneConstants.DEVICE_CONTROL_CIRCULAR_SIZE;

  aboutToAppear(): void {
    //只有场景未设置的时候，扫描设备，准备设置
    if (!TunnelScanManager.getInstance().isSceneSet) {
      TunnelScanManager.getInstance().startScan(getContext(this));

    }
  }

  aboutToDisappear(): void {
    if (!TunnelScanManager.getInstance().isSceneSet) {
      TunnelScanManager.getInstance().stopScan();
    }
  }

  build() {
    RelativeContainer() {
      Column() {
        Row() {
          ForEach(this.model.sensingDeviceSlots, (item: TunnelSlot, index: number) => {
            Column() {
              DeviceSlot({ slot: item });
            };
          }, (item: TunnelDeviceType) => item.toString());
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
          ForEach(this.model.controlDeviceSlots, (item: TunnelSlot, index: number) => {
            Column() {
              DeviceSlot({ slot: item });
            };
          }, (item: TunnelDeviceType) => item.toString());
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

      ForEach(this.model.discoverDevices, (item: TunnelDevice, index: number) => {
        TunnelDeviceAnimation(
          {
            item: item,
          }
        ).alignRules(
          {
            center: { 'anchor': '__container__', align: VerticalAlign.Center },
            middle: { 'anchor': '__container__', align: HorizontalAlign.Center }
          }
        ).id('device' + index);
      }, (item: DeviceItem) => JSON.stringify(item));
    }.width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT);
  }
}

@Component
struct DeviceSlot {
  @ObjectLink
  slot: TunnelSlot;
  @Consume model: TunnelSceneModel;

  build() {
    Column() {
      Stack() {
        Button() {
        }
        .linearGradient(this.model.currentDraggingDeviceType == this.slot.type ? {
          angle: 180,
          colors: [['rgba(191, 208, 238, 1)', 0], ['rgba(232, 64, 38, 0.20)', 1]]
        } : this.slot.hasInset() ?
          {
            angle: 180,
            colors: [['rgba(10, 89, 247, 0.30)', 0], ['rgba(77, 137, 255, 0.69)', 0.38], ['#0A59F7', 0.8]]
          } :
          {
            angle: 180,
            colors: [['rgba(140, 165, 210, 1)', 0], ['rgba(191, 208, 238, 1)', 0.5], ['#E2EBF9', 0.75], ['#FFFFFFF', 1]]
          })
        .width(DragSceneConstants.SCENE_SLOT_ITEM_BG_SIZE)
        .height(DragSceneConstants.SCENE_SLOT_ITEM_BG_SIZE)
        .borderStyle(BorderStyle.Dashed)
        .borderWidth(1)
        .borderColor(this.model.currentDraggingDeviceType == this.slot.type ? 'rgba(232, 64, 38, 0.6)' :
          'rgba(10,89,247,0.6)')
        .borderRadius('30vp')
        .draggable(false);

        if (this.slot.device) {
          Image(this.slot.device.image)
            .width(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
            .height(DragSceneConstants.DEVICE_ITEM_IC_SIZE)
            .draggable(false);
        }
      };

      Text(getTunnelDeviceName(this.slot.type))
        .fontSize($r('app.string.device_item_name_font_size'))
        .height(DragSceneConstants.DEVICE_ITEM_NAME_SIZE)
        .margin({
          top: DragSceneConstants.DEVICE_ITEM_PADDING
        })
        .draggable(false);
    }
    .width('60vp')
    .height('60vp')
    .onDrop((event: DragEvent, extraParams?: string) => {
      Logger.info('onDrop,x=' + event.getWindowX() + ',y=' + event.getWindowY());
      event.useCustomDropAnimation = false;

      if (this.model.currentDraggingDevice && this.model.currentDraggingDeviceType == this.slot.type) {
        this.slot.setDevice(this.model.currentDraggingDevice);
        this.model.checkFillState();
      }
    })
    .onDragMove((event: DragEvent, extraParams?: string) => {
      Logger.info('onDragMove(),x=' + event.getWindowX() + ',y=' + event.getWindowY());
    });
  }
}