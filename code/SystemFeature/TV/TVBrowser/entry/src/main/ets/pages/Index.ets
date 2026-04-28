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
import { deviceInfo } from '@kit.BasicServicesKit';
import { TabletTitle, BrowserTabs, WebTab } from '../common/TitleBar';
import { Browser } from '../model/Browser';
import Logger from '../model/Logger';
import { webview } from '@kit.ArkWeb';
import { common } from '@kit.AbilityKit';
import { wifiManager } from '@kit.ConnectivityKit';
import { connection } from '@kit.NetworkKit';

const TAG = '[index]';
// 此处可按照需求到浏览器请求里获取（浏览器请求的HEAD部分，字段为USER_AGENT）
const PAD_USER_AGENT: string =
  'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTMl, like Gecko) Chrome/92.0.4515.105 Safari/537.36';
const PHONE_USER_AGENT: string = 'HuaweiBrowser/12.0.4.1';

@Entry
@Component
struct Index {
  @State isPhone: boolean = false;
  @State browser: Browser = new Browser();
  private isInit: Boolean = false;
  @State isLand: boolean = false;
  @State inputKey: string = 'key';
  @StorageProp('url') url: string = '';
  @State hasNet: boolean = true;
  @State refresh: boolean = true;
  @State controller: webview.WebviewController = new webview.WebviewController();

  build() {
    Column() {
      if (!this.hasNet && this.url) {
        Web({ src: this.url, controller: this.controller })
          .onPageBegin((event) => {
            if (event) {
              console.log(JSON.stringify(event.url), '跳入的为空白页----跳转到wifi列表');
              if (event.url === 'about:blank') {
                console.log(JSON.stringify(event.url), '跳入的为空白页----跳转到wifi列表进入');
                let context = getContext(this) as common.UIAbilityContext;
                let want: Want = {
                  bundleName: 'com.ohos.settings',
                  abilityName: 'com.ohos.settings.MainAbility',
                  action: 'action.system.home',
                  parameters: { router: 'wifi', pageUrl: 'WIFI' }
                };
                context.startAbility(want).then(() => {
                  context.terminateSelfWithResult({
                    resultCode: 1,
                    want: want
                  });
                });
              }
            }
          });
      } else {
        TabletTitle({ browser: $browser, inputKey: $inputKey });
        Progress({ value: this.browser?.progress, total: 100 })
          .color('#0000ff')
          .visibility(this.browser.progress === 100 || this.browser.progress === 0 ? Visibility.None :
          Visibility.Visible)
          .onVisibleAreaChange([0.0, 1.0], (isExpanding: boolean, currentRatio: number) => {
            if (!isExpanding && currentRatio <= 0.0) {
              this.browser.progress = 0;
            }
          });
        BrowserTabs({ browser: $browser });
        Divider().color('#c6c6c6').width('100%');
        WebTab({ browser: $browser, isPhone: $isPhone, inputKey: this.inputKey })
          .layoutWeight(1);
      }
    }
  }

  async onPageShow() {
    try {
      const connected: boolean = await this.isWifiConnected();
      if (connected) {
        const netid = await connection.getDefaultNet();
        if (netid) {
          const netAbility = await connection.getNetCapabilities(netid);
          if (netAbility.networkCap?.length === 2) { // 检查网络能力数组长度是否为2，表示网络连接正常
            this.hasNet = true; // 设置网络状态为已连接
          } else {
            this.hasNet = false;
          }
        } else {
          this.hasNet = false;
        }

        if (!this.hasNet) {
          const currentwifi = await wifiManager.getLinkedInfo();
          const oldwifi = AppStorage.get('oldWifi') as string;
          if (currentwifi.ssid === oldwifi) {
            this.refresh = false;
          } else {
            this.refresh = true;
            AppStorage.setOrCreate('oldWifi', currentwifi.ssid);
            if (oldwifi) {
              this.url = '';
              setTimeout(() => {
                this.url = AppStorage.get('url') as string;
              }, 100);
            }
          }
        }
      }
    } catch (err) {
      Logger.info(TAG, `wifi error: ${err}`);
    }
  }

  async isWifiConnected(): Promise<boolean> {
    try {
      const wifiInfo = await wifiManager.getLinkedInfo();
      if (wifiInfo && wifiInfo.ssid) {
        return true;
      } else {
        return false;
      }
    } catch (error) {
      return false;
    }
  }


  aboutToAppear() {
    Logger.info(TAG, `enter aboutToAppear`);
    try {
      if (AppStorage.get('url')) {
        this.url = AppStorage.get('url') as string;
        Logger.info(TAG + 'url', this.url);
        this.browser.loadUrl(this.url);
        this.browser.setInputVal(this.url);
      }

      let deviceType = deviceInfo.deviceType;
      if (deviceType !== 'default') {
        this.isPhone = false;
      }
    } catch (e) {
      Logger.info(TAG, `getSync unexpected error: ${e}`);
    }
  }

  onBackPress(): boolean {
    Logger.info(TAG, `enter onBackPress`);
    let curWebController = this.browser.getCurrentWebController();
    try {
      if (curWebController?.accessBackward()) {
        curWebController.backward();
        return true;
      }
    } catch (error) {
      Logger.error(TAG, 'backward err ' + JSON.stringify(error));
    }

    return false;
  }

  onDeviceChange() {
    this.browser = new Browser();
  }
}
