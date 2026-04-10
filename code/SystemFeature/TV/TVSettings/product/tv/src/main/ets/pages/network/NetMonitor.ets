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

import { SettingItemStyle } from '../../common/constants/StyleConstants';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { KeyCode } from '../../common/constants/KeyCode';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { router } from '@kit.ArkUI';
import { connection } from '@kit.NetworkKit';
import { http } from '@kit.NetworkKit';
import { wifiManager } from '@kit.ConnectivityKit';
import { Ratio } from '../../common/Ratio';
import { NetMonitorDesLayout } from '../../default/layout/NetMonitorDesLayout';
import { BusinessError } from '@kit.BasicServicesKit';
import { Duration } from '../../common/constants/Duration';

const NETWORK_CHECK_DURATION: number = 2000;
const NETWORK_CONNECT_TIME_OUT: number = 10000;
const RESPONSE_CODE_OK: number = 200;

@Entry
@Component
export struct NetMonitor {
  @State imageUrl: string = Ratio.resName('manualNetwork');
  @State item: SettingItemTvModel = new SettingItemTvModel();
  @State item1: SettingItemTvModel = new SettingItemTvModel();
  @State item2: SettingItemTvModel = new SettingItemTvModel();
  @State item3: SettingItemTvModel = new SettingItemTvModel();
  @State item4: SettingItemTvModel = new SettingItemTvModel();
  @State settingList: SettingItemTvModel[] = []
  @State showStateText: boolean = false;
  @State isRouterError: boolean = false;
  @State isNetworkError: boolean = false;
  monitorArrayDes: string[] = [];
  isWifiNetwork: boolean = false;

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  getTestDomain(): string {
    return getContext().resourceManager.getStringSync($r('app.string.network_monitor_test_domain').id)
  }

  getInternetTestUrl(): string {
    return getContext().resourceManager.getStringSync($r('app.string.network_monitor_test_internet').id)
  }

  getResourceTestUrl(): string {
    return getContext().resourceManager.getStringSync($r('app.string.network_monitor_test_resource').id)
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        Column() {
          SettingListTvComponent({
            settingList: this.settingList,
            title: $r('app.string.network_monitor'),
            isFocusable: false,
            onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
              if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Down) {
                router.pushUrl({
                  url: item.pageUrl
                }, router.RouterMode.Single)
              }
            },
            onFocusHandle: (item: SettingItemTvModel) => {
              this.imageUrl = item.imageUrl;
            }
          })
            .width(ConfigData.WH_48_100)
            .height(this.isWifiNetwork ? lpx(821) : lpx(699))
            .margin({ left: lpx(84) })

          Text($r('app.string.network_ok'))
            .height(lpx(36))
            .fontColor(Color.White)
            .fontSize(lpx(36))
            .fontWeight(500)
            .textAlign(TextAlign.Start)
            .margin({ left: lpx(98), top: lpx(-24) })
            .visibility(this.showStateText ? Visibility.Visible : Visibility.Hidden)
        }.height('100%').alignItems(HorizontalAlign.Start)

        NetMonitorDesLayout({ isRouterError: this.isRouterError, isNetworkError: this.isNetworkError })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
  }

  async aboutToAppear() {
    let params = router.getParams() as Record<string, boolean>;
    this.isWifiNetwork = params?.isWifiEnable as boolean;
    console.debug('NetMonitor aboutToAppear isWifiNetwork = ' + this.isWifiNetwork);
    this.initDate();

    this.checkIntranetAccess()
      .then((): Promise<void> => {
        return this.checkInternetAccess();
      })
      .then((): Promise<void> => {
        return this.checkDNSConfig();
      })
      .then((): Promise<void> => {
        return this.checkSignalStrength();
      })
      .then((): Promise<void> => {
        return this.checkResourceAccess();
      })
      .catch((error: BusinessError) => {
        if (!this.isRouterError) {
          this.isNetworkError = true;
        }
        console.error(`network error, message:${error.message}`);
      })
  }

  initDate() {
    try {
      this.monitorArrayDes =
        getContext().resourceManager.getStringArrayValueSync($r('app.strarray.network_monitor_description').id);
      let monitorArray =
        getContext().resourceManager.getStringArrayValueSync($r('app.strarray.network_monitor_type').id);
      this.item.name = monitorArray[0];
      this.item.style = SettingItemStyle.loading
      this.item.isEnable = false
      this.item.textColor = '#FFFFFF'

      this.item1.name = monitorArray[1];
      this.item1.style = SettingItemStyle.hidden
      this.item1.isEnable = false
      this.item1.textColor = '#FFFFFF'

      this.item2.name = monitorArray[2];
      this.item2.style = SettingItemStyle.hidden
      this.item2.isEnable = false
      this.item2.textColor = '#FFFFFF'

      this.item3.name = monitorArray[3];
      this.item3.style = SettingItemStyle.hidden
      this.item3.isEnable = false
      this.item3.textColor = '#FFFFFF'

      this.item4.name = monitorArray[4];
      this.item4.style = SettingItemStyle.hidden
      this.item4.isEnable = false
      this.item4.textColor = '#FFFFFF'

      if (!this.isWifiNetwork) {
        this.settingList.push(this.item, this.item1, this.item2, this.item4);
      } else {
        this.settingList.push(this.item, this.item1, this.item2, this.item3, this.item4);
      }
    } catch (error) {
      console.error(`NetMonitor initDate failed,  message: ${error.message}.`);
    }
  }

  // 获取内网连接
  async checkIntranetAccess(): Promise<void> {
    console.debug('checkIntranetAccess start.');
    await this.timeout(NETWORK_CHECK_DURATION);

    let netHandle = await connection.getDefaultNet();
    if (netHandle.netId == 0) {
      this.handleIntranetError();
      throw new Error('checkIntranetAccess netID is invalid.');
    }
    let connectionProperties = await connection.getConnectionProperties(netHandle);
    if (!connectionProperties) {
      this.handleIntranetError();
      throw new Error('checkIntranetAccess connectionProperties error.');
    }

    let ip = connectionProperties.linkAddresses[0]?.address?.address;
    let isPrivate = this.isPrivateIP(ip);

    console.debug('checkIntranetAccess isPrivate = ' + isPrivate);
    if (isPrivate) {
      this.item.style = SettingItemStyle.finished
      this.item.name = this.monitorArrayDes[0];
      this.item1.style = SettingItemStyle.loading
    } else {
      this.handleIntranetError();
      throw new Error('checkIntranetAccess is not private IP.');
    }
  }

  // 检测外网连通性
  async checkInternetAccess() {
    console.debug('checkInternetAccess start.');
    await this.timeout(NETWORK_CHECK_DURATION);

    // 需要设置网络超时机制, 因为可能会抛出异常Couldn't connect to server
    try {
      let httpRequest = http.createHttp();
      let options: http.HttpRequestOptions = {
        connectTimeout: NETWORK_CONNECT_TIME_OUT,
        readTimeout: NETWORK_CONNECT_TIME_OUT,
        usingCache: false
      };
      let response = await httpRequest.request(this.getInternetTestUrl(), options);
      if (response && response.responseCode == RESPONSE_CODE_OK) {
        this.item1.style = SettingItemStyle.finished
        this.item1.name = this.monitorArrayDes[2];
        this.item2.style = SettingItemStyle.loading
      } else {
        this.item1.style = SettingItemStyle.error
        this.item1.name = this.monitorArrayDes[3];
        throw new Error('checkInternetAccess error.');
      }
    } catch (error) {
      this.item1.style = SettingItemStyle.error
      this.item1.name = this.monitorArrayDes[3];
      throw new Error(`checkInternetAccess error, message:${error.message}`);
    }
  }

  // 检查DNS配置
  async checkDNSConfig() {
    console.debug('checkDNSConfig start.');
    await this.timeout(NETWORK_CHECK_DURATION);
    try {
      let data = await connection.getAddressesByName(this.getTestDomain());
      if (data && data.length > 0) {
        this.item2.style = SettingItemStyle.finished
        this.item2.name = this.monitorArrayDes[4];
        this.item3.style = this.isWifiNetwork ? SettingItemStyle.loading : SettingItemStyle.hidden
      } else {
        this.item2.style = SettingItemStyle.error
        this.item2.name = this.monitorArrayDes[5];
        throw new Error('checkDNSConfig error.');
      }
    } catch (error) {
      this.item2.style = SettingItemStyle.error
      this.item2.name = this.monitorArrayDes[5];
      throw new Error('checkDNSConfig error.');
    }
  }

  async checkSignalStrength() {
    console.debug('checkSignalStrength start, ' + this.isWifiNetwork);
    if (!this.isWifiNetwork) {
      this.item4.style = SettingItemStyle.loading;
      return;
    }
    await this.timeout(NETWORK_CHECK_DURATION);
    let signalArray: string[] = [];
    let strength: string = '';
    try {
      signalArray = getContext().resourceManager.getStringArrayValueSync($r('app.strarray.signal_strength').id);
      let linkedInfo = await wifiManager.getLinkedInfo()
      let result = wifiManager.getSignalLevel(linkedInfo?.rssi, linkedInfo?.band);
      console.debug('checkSignalStrength result:' + result + ',rssi =' + linkedInfo?.rssi + ',band =' +
        linkedInfo?.band);
      if (result <= 1) {
        strength = signalArray[0]; //弱
      } else if (result == 2) {
        strength = signalArray[1]; //较弱
      } else if (result == 3) {
        strength = signalArray[2]; //较强
      } else {
        strength = signalArray[3]; //强
      }
      if (strength) {
        this.item3.style = SettingItemStyle.finished
        this.item3.name = strength;
        this.item4.style = SettingItemStyle.loading
      }
    } catch (error) {
      this.item3.style = SettingItemStyle.error
      this.item3.name = this.monitorArrayDes[6];
      throw new Error('checkSignalStrength error.');
    }
  }

  // 检测通用资源访问是否正常
  async checkResourceAccess() {
    console.debug('checkResourceAccess start.');
    await this.timeout(NETWORK_CHECK_DURATION);
    try {
      let httpRequest = http.createHttp();
      let options: http.HttpRequestOptions = {
        connectTimeout: NETWORK_CONNECT_TIME_OUT,
        readTimeout: NETWORK_CONNECT_TIME_OUT,
        usingCache: false
      };
      let response = await httpRequest.request(this.getResourceTestUrl(), options);
      if (response && response.responseCode == RESPONSE_CODE_OK) {
        this.item4.style = SettingItemStyle.finished;
        this.item4.name = this.monitorArrayDes[7];
        this.showStateText = true;
      } else {
        this.item4.style = SettingItemStyle.error;
        this.item4.name = this.monitorArrayDes[8];
      }
    } catch (error) {
      this.item4.style = SettingItemStyle.error;
      this.item4.name = this.monitorArrayDes[8];
      throw new Error('checkResourceAccess error.');
    }
  }

  // 检测是否是私有IP
  isPrivateIP(ip: string): boolean {
    return /^(10\.\d+\.\d+\.\d+|192\.168\.\d+\.\d+|172\.(1[6-9]|2\d|3[0-1])\.\d+\.\d+)$/.test(ip);
  }

  handleIntranetError() {
    this.item.style = SettingItemStyle.error;
    this.item.name = this.monitorArrayDes[1];
    this.isRouterError = true;
  }

  timeout(timeout: number): Promise<void> {
    return new Promise((resolve, reject) => {
      setTimeout(() => {
        resolve();
      }, timeout)
    })
  }
}
