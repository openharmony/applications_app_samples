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
import { CommonConstants, DefaultDialog, Logger } from '@ohos/common';
import promptAction from '@ohos.promptAction';
import DeviceItem from '../viewmodel/DeviceItem';
import DevicesModel from '../viewmodel/DevicesModel';
import { RescanButton } from './RescanButton';
import { curves, LengthMetrics } from '@kit.ArkUI';
import ScanModel, { ScanState } from '../viewmodel/ScanModel';
import DevicesManager, { ConnectState } from '../viewmodel/DevicesManager';
import { DeviceManagerFactory } from '@ohos/device_manager';
import DeviceDiscoverManager from '../viewmodel/DeviceDiscoverManager';
import { scale } from '../util/ScreenAdaptation';

export class ListClick {
  private click: boolean = false;
  private static instance: ListClick;

  public static getContext(): ListClick {
    if (!ListClick.instance) {
      ListClick.instance = new ListClick();
    }
    return ListClick.instance;
  }

  clicked() {
    this.click = !this.click;
  }
}

@Component
export struct DevicesListView {
  @Consume scanModel: ScanModel;
  @Consume devicesModel: DevicesModel;
  @Consume listClick: ListClick;
  @State selectIndex: number = 0;
  @State focusIndex: number = -1;
  @LocalStorageLink('isDragMode') isDragMode: boolean = true;
  //item转场效果
  private effect: object =
    TransitionEffect.OPACITY
      .combine(TransitionEffect.scale({ x: 0, y: 0 })
        .animation({
          curve: curves.springMotion(0.6, 1.2)
        }))
      .combine(TransitionEffect.translate({ x: scale(150), y: scale(150) })
        .combine(TransitionEffect.move(TransitionEdge.END))
        .animation({
          curve: curves.springMotion()
        }))
      .combine(TransitionEffect.asymmetric(TransitionEffect.scale({ x: 0, y: 0 }), TransitionEffect.rotate({
        angle: 90
      })));
  private dialogController: CustomDialogController = new CustomDialogController({
    builder: DefaultDialog({
      content: $r('app.string.confirm_message'),
      leftText: $r('app.string.button_text_cancel'),
      rightText: $r('app.string.btn_confirm'),
      cancel: () => {
        this.dialogController.close();
      },
      confirm: () => {
        DevicesManager.getInstance().connect(this.selectIndex);
        this.dialogController.close();
      }
    }),
    customStyle: true,
    alignment: DialogAlignment.Center,
  });

  @Builder
  itemHead(isConnected: boolean) {
    if (isConnected) {
      Text($r('app.string.connect_title'))
        .fontSize($r('app.string.fp_15'))
        .fontColor($r('app.color.white'))
        .padding({
          bottom: $r('app.string.vp_10'),
          top: $r('app.string.vp_10'),
        })
        .width(CommonConstants.FULL_WIDTH_PERCENT);
    } else {
      Row() {
        Text(this.scanModel.currentScanState == ScanState.SCANNING ? '正在扫描设备...' : '可连接设备')
          .fontSize($r('app.string.fp_15'))
          .fontColor($r('app.color.white'))
          .padding($r('app.string.vp_5'));
        if (this.scanModel.currentScanState == ScanState.SCANNING) {
          LoadingProgress()
            .color($r('app.color.white'))
            .width($r('app.string.vp_25'))
            .height($r('app.string.vp_25'));
        }
      }
      .justifyContent(FlexAlign.Start)
      .padding({
        bottom: $r('app.string.vp_10'),
        top: $r('app.string.vp_10'),
      })
      .width(CommonConstants.FULL_WIDTH_PERCENT);
    }
  }

  getRadiusConfig(index: number): BorderRadiuses | null {
    if (index == 0) {
      return {
        topLeft: $r('app.string.vp_20'),
        topRight: $r('app.string.vp_20'),
      };
    } else if (index === this.devicesModel.devicesArray.length - 1) {
      return {
        bottomLeft: $r('app.string.vp_20'),
        bottomRight: $r('app.string.vp_20'),
      };
    } else {
      return null;
    }
  }

  @Builder
  getConnectingItem() {
    if (this.devicesModel.currentConnectState != ConnectState.NOT_START) {
      Row() {
        if (this.devicesModel.connectingDevice) {
          Row() {
            Stack() {
              Row()
                .backgroundColor($r('app.color.device_list_icon'))
                .width($r('app.string.vp_30'))
                .height($r('app.string.vp_30'))
                .borderRadius('50%');
              Image(this.devicesModel.connectingDevice!.image)
                .width($r('app.string.vp_25'))
                .height($r('app.string.vp_25'))
                .draggable(false);
            };

            Text(this.devicesModel.connectingDevice!.name)
              .width(CommonConstants.EIGHTY_PERCENT)
              .fontSize(this.focusIndex == -2 ? $r('app.string.fp_20') : $r('app.string.fp_15'))
              .fontColor(this.focusIndex == -2 ? $r('app.color.text_color_white') : $r('app.color.connect_device_text'))
              .maxLines(1)
              .textOverflow({ overflow: TextOverflow.Ellipsis })
              .margin({
                left: $r('app.string.vp_10')
              })
              .focusBox({
                strokeWidth: LengthMetrics.px(0)
              })
              .onClick(() => {
                this.listClick.clicked();
              })
              .onFocus(() => {
                this.focusIndex = -2;
              })
              .onBlur(() => {
                this.focusIndex = -1;
              });
          };
        }


        if (this.devicesModel.currentConnectState == ConnectState.CONNECTING) {
          LoadingProgress()
            .color($r('app.color.white'))
            .width($r('app.string.vp_25'))
            .height($r('app.string.vp_25'));
        } else if (this.devicesModel.currentConnectState == ConnectState.CONNECT_SUCCESS) {
          Row() {
            Text($r('app.string.connect_success'))
              .fontSize($r('app.string.fp_15'))
              .fontColor($r('app.color.connect_device_text'));
            Image($r('app.media.ic_public_arrow_right'))
              .width($r('app.string.vp_10'))
              .height($r('app.string.vp_20'));
          };
        }
      }
      .width(CommonConstants.FULL_WIDTH_PERCENT)
      .padding({
        left: $r('app.string.vp_12'),
        right: $r('app.string.vp_12'),
        top: $r('app.string.vp_6'),
        bottom: $r('app.string.vp_6')
      })
      .borderRadius($r('app.string.vp_14'))
      .backgroundColor($r('app.color.canConnect_device_bg'))
      .justifyContent(FlexAlign.SpaceBetween);
    }
  }

  @Builder
  getIconItem(item: DeviceItem, index: number) {
    Row() {
      Stack() {
        Row()
          .backgroundColor($r('app.color.device_list_icon'))
          .width($r('app.string.vp_30'))
          .height($r('app.string.vp_30'))
          .borderRadius('50%');

        Image(item.image)
          .width($r('app.string.vp_25'))
          .height($r('app.string.vp_25'))
          .draggable(false);
      };

      Text(item.name)
        .fontSize(this.focusIndex == index ? $r('app.string.fp_20') : $r('app.string.fp_15'))
        .fontColor(this.focusIndex == index ? $r('app.color.text_color_white') : $r('app.color.connect_device_text'))
        .margin({
          left: $r('app.string.vp_10')
        })
        .maxLines(1)
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .focusable(true)
        .focusBox({
          strokeWidth: LengthMetrics.px(0)
        })
        .onFocus(() => {
          this.focusIndex = index;
        })
        .onBlur(() => {
          this.focusIndex = -1;
        });
    }
    .width(CommonConstants.EIGHTY_PERCENT);
  }

  getRescanBarShow(): boolean {
    return this.scanModel.currentScanState == ScanState.SCANNING_FINISH;
  }

  private async connectDevice(index: number) {
    if (DeviceManagerFactory.getDeviceManager().isConnecting()) {
      promptAction.showToast({
        message: $r('app.string.other_devices_connecting'),
        duration: 2000
      });
      return;
    }
    let connectingDevice = DevicesManager.getInstance().getConnectingDevice();
    let isConfirm = true;
    if (connectingDevice == undefined) {
      DevicesManager.getInstance().connect(index);
    } else {
      this.selectIndex = index;
      this.dialogController.open();
    }
  }

  @Builder
  getListItem(item: DeviceItem, index: number) {
    Row() {
      this.getIconItem(item, index);
      Text($r('app.string.connect_not_start'))
        .fontSize($r('app.string.fp_15'))
        .fontColor($r('app.color.connect_device_text'));
    }
    .padding({
      left: $r('app.string.vp_12'),
      right: $r('app.string.vp_12'),
      top: $r('app.string.vp_6'),
      bottom: $r('app.string.vp_6')
    })
    .justifyContent(FlexAlign.SpaceBetween)
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .onClick(() => {
      // 点击连接
      this.connectDevice(item.index);
    });
  }

  aboutToAppear(): void {
    Logger.info('DeviceListView', `===>aboutToAppear, ${this.devicesModel.devicesArray.length}`);
    if (this.devicesModel.devicesArray.length == 0) {
      this.isDragMode = true;
      DeviceDiscoverManager.getInstance().startScan();
    }
    let connectDevice = DevicesManager.getInstance().getConnectingDevice();
    if (connectDevice) {
      let index = this.devicesModel.toBeConnectDeviceByOrderSource.findInfoIndex(connectDevice.getDeviceName());
      DevicesManager.getInstance().connect(index);
    }
  }

  build() {
    Column() {
      //连接的设备
      if (this.devicesModel.currentConnectState != ConnectState.NOT_START) {
        Column() {
          this.itemHead(true);
          this.getConnectingItem();
        };
      }
      //可连接的设备
      this.itemHead(false);
      List() {
        LazyForEach(this.devicesModel.toBeConnectDeviceByOrderSource, (item: DeviceItem, index: number) => {
          ListItem() {
            this.getListItem(item, index);
          }.transition(this.effect);
        }, (item: DeviceItem) => JSON.stringify(item));
      }
      .divider({
        strokeWidth: $r('app.string.vp_1'),
        startMargin: $r('app.string.vp_60'),
        endMargin: $r('app.string.vp_10'),
        color: $r('app.color.device_list_divider')
      })
      .borderRadius($r('app.string.vp_14'))
      .backgroundColor($r('app.color.canConnect_device_bg'))
      .layoutWeight(1)
      .scrollBar(BarState.On)
      .scrollBarColor(Color.Gray);

      // 重新扫描设备
      RescanButton().margin({
        bottom: $r('app.string.button_margin_bottom'),
        top: $r('app.string.vp_10')
      }).visibility(this.getRescanBarShow() ? Visibility.Visible : Visibility.Hidden);

    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .padding({ left: $r('app.string.24_vp'), right: $r('app.string.24_vp') });
  }
}