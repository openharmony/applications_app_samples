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
import ConfigData from '../viewmodel/ConfigData';
import { DeviceDetailDialog } from '../view/DeviceDetailDialog';
import DevicesManager from '../viewmodel/DevicesManager';
import { Device, DeviceLibraryAccess, Logger, NavBar, PageViewUtils } from '@ohos/common';
import { BusinessError } from '@kit.BasicServicesKit';
import DeviceInfoView from '../view/DeviceInfoView';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';
import { inputConsumer, KeyCode } from '@kit.InputKit';

import { CloudDeviceModel } from '@ohos/connect_cloud';
import { DeviceManagerFactory } from '@ohos/device_manager';
import { ProfileComponents } from '../view/profileview/ProfileComponents';
import { WifiProfileComponents } from '../view/profileview/WifiProfileComponents';
import { WifiDeviceDetailDialog } from '../view/WifiDeviceDetailDialog';
import CoapDevicesManager from '../viewmodel/CoapDevicesManager';
import { scale } from '../util/ScreenAdaptation';

const OFFSET_VALUE = 500;
const TAG = 'DeviceDetailPage';

export function registrationMonitoring(keyValue: KeyCode, callbackVoid: () => void) {
  let keyOptions: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyValue,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };
  let callback = (keyOptions: inputConsumer.KeyOptions) => {
    Logger.info('registrationMonitoring  keyOptions ', JSON.stringify(keyOptions));
    callbackVoid();
  };
  try {
    inputConsumer.on('key', keyOptions, callback);
    Logger.info(`Subscribe success`);
  } catch (error) {
    Logger.info(`Subscribe failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
  }
}

export function unRegistrationMonitoring(keyValue: KeyCode) {
  // 取消订阅单个回调函数
  let keyOption: inputConsumer.KeyOptions = {
    preKeys: [],
    finalKey: keyValue,
    isFinalKeyDown: false,
    finalKeyDownDuration: 0
  };
  try {
    inputConsumer.off('key', keyOption);
    Logger.info(`Unsubscribe success`);
  } catch (error) {
    Logger.info(`Execute failed, error: ${JSON.stringify(error, [`code`, `message`])}`);
  }
}

/**
 * Route params
 * productId  产品ID
 * deviceName 设备名称
 * deviceId 设备ID
 * projectId 项目ID
 * enterType 页面类型 0-点对点本地控 1-云控
 */
@HMRouter({ pageUrl: 'WifiDeviceDetailPage' })
@Component
export struct WifiDeviceDetailPage {
  @State deviceInfo: Device | null = null;
  @State deviceName: string = '';
  @State enterType: number = 0;
  @State productId: string = '';
  @State deviceId: string = '';
  @State gatewayId: string = '';
  @State projectId: string = '';
  @State ip: string = '';
  scroller: Scroller = new Scroller();

  aboutToAppear() {
    registrationMonitoring(KeyCode.KEYCODE_DPAD_UP, () => {
      this.scroller.scrollTo({ xOffset: 0, yOffset: 0, animation: { duration: 500, curve: Curve.Ease } });
    });
    registrationMonitoring(KeyCode.KEYCODE_DPAD_DOWN, () => {
      this.scroller.scrollTo({ xOffset: 0, yOffset: OFFSET_VALUE, animation: { duration: 500, curve: Curve.Ease } });
    });
    setTimeout(() => {
      PageViewUtils.tabClick();
    }, 100);
    let routerParams = HMRouterMgr.getCurrentParam() as Record<string, string | number | object>;
    Logger.info('WifiDeviceDetailPage1111', `===>routerParams ${JSON.stringify(routerParams)}`);
    this.deviceName = routerParams['deviceName'] as string;
    let productID = routerParams['productId'] as string;
    this.productId = routerParams['productId'] as string;
    this.deviceId = routerParams['deviceId'] as string;
    this.gatewayId = routerParams['gatewayId'] as string;
    this.projectId = routerParams['projectId'] as string;
    this.ip = routerParams['ip'] as string;
    let type = routerParams['enterType'];
    if (type != undefined) {
      this.enterType = type as number;
    }
    Logger.info('WifiDeviceDetailPage',
      `===>this.enterType ${this.enterType}, this.deviceName: ${this.deviceName}, this.productId: ${this.productId}, this.deviceId: ${this.deviceId}, this.gatewayId: ${this.gatewayId}, this.projectId: ${this.projectId}`);
  }

  @Builder
  getDeviceInfoView() {
    GridContainer({ gutter: ConfigData.GRID_CONTAINER_GUTTER_24, margin: ConfigData.GRID_CONTAINER_MARGIN_24 }) {
      Button($r('app.string.disconnect_device'))
        .onClick(() => {
          CoapDevicesManager.getInstance().disconnect();
          HMRouterMgr.pop();
        })
        .fontColor(Color.Red)
        .backgroundColor($r('app.color.default_button_bg'))
        .fontSize($r('app.string.button_font_size'))
        .padding({
          left: $r('app.string.button_padding_horizontal'),
          right: $r('app.string.button_padding_horizontal'),
          top: $r('app.string.button_padding_vertical'),
          bottom: $r('app.string.button_padding_vertical')
        })
        .margin({
          top: $r('app.string.distance_24')
        })
        .focusBox({
          margin: LengthMetrics.lpx(8),
          strokeColor: ColorMetrics.resourceColor($r('app.color.white')),
          strokeWidth: LengthMetrics.lpx(2)
        });
    }
    .width(ConfigData.WH_100_100);
  }

  @Builder
  getHeadTitleView() {
    if (this.enterType == 1) {
      NavBar({
        title: this.deviceName, rightIcon: $r('app.media.ic_public_setting'), clickCallback: () => {
          HMRouterMgr.push({ pageUrl: 'AboutDevicePage' });
        }
      });
    } else {
      NavBar({
        title: this.deviceName
      });
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column }) {
      Row() {
        Text(this.deviceName)
          .fontSize(scale(17))
          .fontColor('#FFFFFF')
          .focusable(false);
      }
      .width('100%')
      .margin({ bottom: $r('app.string.10_vp') })
      .justifyContent(FlexAlign.Center);

      Scroll(this.scroller) {
        Column() {
          WifiDeviceDetailDialog({
            deviceName: this.deviceName,
            pageType: 'DeviceDetailPage',
            ip: this.ip
          });
          this.getDeviceInfoView();
          Blank().height(scale(50));
        }
        .backgroundColor($r('app.color.page_background'));
      }
      .scrollable(ScrollDirection.Vertical)
      .edgeEffect(EdgeEffect.Spring)
      .align(Alignment.Top)
      .width('100%')
      .height('100%');
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.page_background'))
    .padding({ top: $r('app.string.default_page_padding') })
    .margin({ bottom: $r('app.string.default_page_padding') })
    .onVisibleAreaChange([0.0], (isVisible: boolean, currentRatio: number) => {
      if (!isVisible) {
        Logger.info(`DeviceDetailPage isVisible: ${isVisible}, currentRatio: ${currentRatio}`);
        unRegistrationMonitoring(KeyCode.KEYCODE_DPAD_UP);
        unRegistrationMonitoring(KeyCode.KEYCODE_DPAD_DOWN);
      }
    });
  }
}
