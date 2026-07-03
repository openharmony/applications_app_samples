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

import { CommonConstants, Logger, PageViewUtils } from '@ohos/common';
import DevicesTabPage from '../view/DevicesTabPage';
import TabsConfig from '../model/TabsConfig';
import { DevicesScanPage } from './DevicesScanPage';
import DeviceListComponent from '../view/DeviceListComponent';
import { HMInterceptorAction, HMPageParam, HMParamType, HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { DeviceLibraryManager, } from '@ohos/devicelibrary';
import { connection } from '@kit.NetworkKit';
import { WifiAddDevicePage } from './WifiAddDevicePage';
import WifiDeviceListComponent from '../view/WifiDeviceListComponent';
import { TipButton } from '../view/TipButton';
import { wifiManager } from '@kit.ConnectivityKit';
import ethernet from '@ohos.net.ethernet';
import { promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { access } from '@kit.ConnectivityKit';

const TEXT_SIZE = '20lpx';
const IMAGE_HEIGHT = '91lpx';
let TAG = 'DevicesMainPage';


@HMRouter({ pageUrl: 'DevicesMainPage', singleton: true, lifecycle: 'DevicesMainPageLifecycle' })
@Component
export struct DevicesMainPage {
  @State currentIndex: number = 0;
  @State categoryTabIndex: number = 0;
  @State isConnect: boolean = false;
  @State updateFunID: number | null = null;
  @State networkStateType: number = 0;
  @State curActiveIFace: string = '';
  private timerId: number = -1; // 定时器ID
  addClick: (type: number, id?: string, isEdit?: boolean) => void = (type: number, id?: string, isEdit?: boolean) => {
  };

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, '===>aboutToAppear ');
    // 初始化默认值
    this.networkStateType = 0;
    // 启动定时器，每隔一秒执行一次查询
    this.startPolling();
    try {
      this.updateConnectState();
      Logger.info(TAG, '===>aboutToAppear after updateConnectState');
      const params = HMRouterMgr.getCurrentParam(HMParamType.all) as HMPageParam;
      DeviceLibraryManager.getInstance().registerInitCallback((inited) => {
      });
      await DeviceLibraryManager.getInstance().updateData();
    } catch (e) {
      Logger.info(TAG, '===>aboutToAppear updateData error:' + e);
    }

  }

  //根据网络连接情况来判断网络类型
  getNetBearerType(): boolean {
    Logger.info('getNetBearerType start');
    //是否连接网络
    const isHasDefaultNet = connection.hasDefaultNetSync();
    if (isHasDefaultNet) {
      return true;
    } else {
      return false;
    }
  }

  updateConnectState() {
    this.updateFunID = setInterval(() => {
      this.isConnect = this.getNetBearerType();
    }, 500);
  }

  aboutToDisappear(): void {
    clearInterval(this.updateFunID);
    // 界面隐藏时清除定时器
    this.stopPolling();
  }

  private startPolling(): void {
    // 先执行一次立即查询
    this.pollNetworkState();
    // 设置定时器，每秒执行一次
    this.timerId = setInterval(() => {
      this.pollNetworkState();
    }, 1000);
  }

  private stopPolling(): void {
    if (this.timerId !== -1) {
      clearInterval(this.timerId);
      this.timerId = -1;
    }
  }

  private async pollNetworkState(): Promise<void> {
    try {
      const isWifiActive = wifiManager.isWifiActive();
      Logger.info('pollNetworkState isWifiActive:' + isWifiActive);
      if (isWifiActive) {
        const wifiInfo = await wifiManager.getLinkedInfo();
        if (wifiInfo?.ssid) {
          await this.handleEthernetConfig();
        } else {
          // WiFi激活但无ssid，保持默认值或根据业务需要设置
          this.networkStateType = 0; // 可根据实际需求调整
        }
      } else {
        // WiFi未激活，保持默认值或根据业务需要设置
        this.networkStateType = 0; // 可根据实际需求调整
      }
    } catch (error) {
      Logger.error('pollNetworkState error：', JSON.stringify(error));
    }
  }

  private async handleEthernetConfig(): Promise<void> {
    try {
      const iFaces = await ethernet.getAllActiveIfaces();
      Logger.info('handleEthernetConfig getAllActiveIfaces iFaces ==> ' + JSON.stringify(iFaces));
      if (iFaces.length > 0) {
        this.curActiveIFace = iFaces[iFaces.length - 1];
        Logger.info('handleEthernetConfig this.curActiveIFace ==> ' + JSON.stringify(this.curActiveIFace));
        const data = await ethernet.getIfaceConfig(this.curActiveIFace);
        Logger.info('handleEthernetConfig getIfaceConfig data ==> ' + JSON.stringify(data));
        this.networkStateType = data?.ipAddr ? 0 : 1;
      } else {
        this.networkStateType = 1;
      }
    } catch (error) {
      Logger.error('handleEthernetConfig error：', JSON.stringify(error));
      this.networkStateType = 1;
    }
  }

  promptActionShowToast() {
    promptAction.showToast({
      message: $r('app.string.CoAP_network'),
      duration: 1000,
    });
  }

  build() {
    Column() {
      DevicesTabPage({
        tabItems: TabsConfig.tabItems,
        currentIndex: this.currentIndex,
        changeTab: (tab: number) => {
          Logger.info('===>tab:' + tab);
          this.currentIndex = tab;
        },
        addClick: () => {
        }
      });
      Stack() {
        Row() {
          //附近设备
          DeviceListComponent({
            categoryTabIndex: this.categoryTabIndex
          });
        }
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .layoutWeight(1)
        .visibility(this.currentIndex == 0 ? Visibility.Visible : Visibility.Hidden);

        //可连接设备
        Row() {
          DevicesScanPage({ categoryTabIndex: this.categoryTabIndex, currentIndex: this.currentIndex });
        }.width(CommonConstants.FULL_WIDTH_PERCENT)
        .layoutWeight(1)
        .visibility(this.currentIndex == 1 ? Visibility.Visible : Visibility.Hidden);

        Row() {
          Column() {
            Stack() {
              Stack() {
                TipButton({
                  btnStyle: {
                    btnRes: 'coap配网',
                    clickEvent: () => {
                      Logger.info('getCurActiveIFaceConfig coapButton' + this.networkStateType);
                      if (this.networkStateType == 0) {
                        this.promptActionShowToast();
                      } else if (this.networkStateType == 1) {
                        try {
                          let state = access.getState();
                          Logger.info('bleStartScan state==' + state);
                          if (state == 2) {
                            HMRouterMgr.push({ pageUrl: 'WifiAddDevicePage' });
                          } else {
                            this.promptActionShowToast();
                          }
                        } catch (err) {
                          Logger.error('bleStartScan errCode: ' + (err as BusinessError).code + ', errMessage: ' +
                          (err as BusinessError).message);
                          this.promptActionShowToast();
                        }
                      }
                      return HMInterceptorAction.DO_REJECT;
                    },
                    backgroundColor: $r('app.color.default_button_bg'),
                    fontColor: $r('app.color.black')
                  }
                });
              }
              .width(CommonConstants.FULL_WIDTH_PERCENT)
              .height(CommonConstants.FULL_WIDTH_PERCENT);
            }
            .width(CommonConstants.FULL_WIDTH_PERCENT)
            .height(CommonConstants.FULL_WIDTH_PERCENT)
            .borderRadius($r('app.string.vp_20'))
            .alignContent(Alignment.Top)
            .backgroundColor($r('app.color.canConnect_device_bg'));
          }
          .padding({ left: $r('app.string.wh_value_24'), right: $r('app.string.wh_value_24') })
          .width(CommonConstants.FULL_WIDTH_PERCENT)
          .height(CommonConstants.FULL_HEIGHT_PERCENT);
        }
        .width(CommonConstants.FULL_WIDTH_PERCENT)
        .layoutWeight(1)
        .visibility(this.currentIndex == 2 ? Visibility.Visible : Visibility.Hidden);

      }.width(CommonConstants.FULL_WIDTH_PERCENT)
      .layoutWeight(1);
    }
    .padding({ top: $r('app.string.default_page_padding'), bottom: $r('app.string.default_page_padding') })
    .backgroundColor($r('app.color.page_background'));
  }
}