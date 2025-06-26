/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import hilog from '../model/Logger'
import promptAction from '@ohos.promptAction'
import wifi from '@ohos.wifiManager'
import router from '@ohos.router'

const TAG = 'WifiConnect'
@Entry
@Component
struct WifiConnect {
  ssid: string = ''
  password: string = ''
  selectedSecurityType: wifi.WifiSecurityType = wifi.WifiSecurityType.WIFI_SEC_TYPE_INVALID
  private linkedInfo: wifi.WifiLinkedInfo | null = null;
  @State isLinked: boolean = false;
  @State isSwitchOn: boolean = false;
  @State wifiCandidateConfig: wifi.WifiDeviceConfig = {
    ssid: '',
    bssid: '',
    preSharedKey: '',
    isHiddenSsid: false,
    securityType: 0
  }
  private controller: CustomDialogController | null = null;

  async connectwifi(deviceConfig: wifi.WifiDeviceConfig) {
    try {
      promptAction.showToast({ message : 'connect to wifi' })
      hilog.info(`connectwifi failed err is ${JSON.stringify(deviceConfig)}`);
      wifi.addCandidateConfig(deviceConfig).then(result => {
        // 连接指定网络
        wifi.connectToCandidateConfig(result);
        this.getLinkedInfo()
      });
    }catch(error){
      hilog.error('sun failed:' + JSON.stringify(error));
    }
  }

  async getLinkedInfo() {
    try {
      let wifiLinkedInfo = await wifi.getLinkedInfo();
      if (wifiLinkedInfo === null || wifiLinkedInfo.bssid === '') {
        this.isLinked = false;
        this.linkedInfo = null;
        return;
      }
      this.isLinked = true;
      this.linkedInfo = wifiLinkedInfo;
    } catch (err) {
      hilog.info(`getLinkedInfo failed err is ${JSON.stringify(err)}`);
    }
  }

  addListener() {
    // 连接状态改变时，修改连接信息
    wifi.on('wifiConnectionChange', async state => {
      hilog.info(TAG, `wifiConnectionChange: ${state}`);
      await this.getLinkedInfo();
    })
  }

  aboutToAppear() {
    // 如果wifi是开的，就记录下状态，然后扫描wifi，并获取连接信息
    if (wifi.isWifiActive()) {
      hilog.info(TAG, 'wifi is active');
      this.isSwitchOn = true;
    }
    hilog.info(TAG, 'wifi is disabled');
    // 启动监听
    this.addListener();
  }

  build() {
    Column() {
          Column() {
            Row() {
              Text('ssid').fontSize('16fp').width('18%')
              TextInput({ placeholder: $r('app.string.input_candidate_wifi_ssid') })
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: '16fp' })
                .caretColor(Color.Blue)
                .width('80%')
                .fontSize('16fp')
                .fontColor($r('app.color.title_black_color'))
                .onChange((value: string) => {
                  this.wifiCandidateConfig.ssid = value;
                })
            }
            .width('100%')
            .margin({ top: '3%' })

            // .height( CommonConstants.TEXT_INPUT_HEIGHT )
            // .backgroundColor( $r( 'app.color.input_background' ) )
            Row() {
              Text('bssid').fontSize('16fp').width('18%')
              TextInput({ placeholder: $r('app.string.input_candidate_wifi_bssid') })
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: '16fp' })
                .caretColor(Color.Blue)
                .width('80%')
                .fontSize('16fp')
                .fontColor($r('app.color.title_black_color'))
                .onChange((value: string) => {
                  this.wifiCandidateConfig.bssid = value;
                })
            }
            .width('100%')
            .margin({ top: '3%' })

            Row() {
              Text('preSharedKey').fontSize('16fp').width('28%')
              TextInput({ placeholder: $r('app.string.input_candidate_wifi_preSharedKey') })
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: '16fp' })
                .caretColor(Color.Blue)
                .width('70%')
                .fontSize('16fp')
                .fontColor($r('app.color.title_black_color'))
                .onChange((value: string) => {
                  this.wifiCandidateConfig.preSharedKey = value;
                })
            }
            .width('100%')
            .margin({ top: '3%' })


            Row() {
              Text('isHiddenSsid').fontSize('16fp').width('28%')
              TextInput({ placeholder: $r('app.string.input_candidate_wifi_isHiddenSsid') })
                .placeholderColor(Color.Grey)
                .placeholderFont({ size: '16fp' })
                .caretColor(Color.Blue)
                .width('70%')
                .fontSize('16fp')
                .fontColor($r('app.color.title_black_color'))
                .onChange((value: string) => {
                  this.wifiCandidateConfig.isHiddenSsid = parseInt(value, 10) === 1;
                })
            }
            .width('100%')
            .margin({ top: '3%' })

            Row() {
              Text('securityType').fontSize('16fp').width('28%')
              Column() {
                Select([
                  { value: 'WIFI_SEC_TYPE_INVALID' },
                  { value: 'WIFI_SEC_TYPE_OPEN' },
                  { value: 'WIFI_SEC_TYPE_PSK' },
                  { value: 'WIFI_SEC_TYPE_SAE' }
                ])
                  .fontColor($r('app.color.title_black_color'))
                  .optionBgColor($r('app.color.input_background'))
                  .selectedOptionBgColor($r('app.color.input_background'))
                  .selectedOptionFontColor($r('app.color.input_background'))
                  .selected(0)
                  .value('WIFI_SEC_TYPE_INVALID')
                  .font({ size: 16 })
                  .selectedOptionFont({ size: 17 })
                  .optionFont({ size: 15 })
                  .width('100%')
                  .onSelect((index: number) => {
                    this.wifiCandidateConfig.securityType = index;
                  })
              }
              .width('70%')
              .borderRadius(1)
            }
            .justifyContent(FlexAlign.Start)
            .alignItems(VerticalAlign.Center)
            .width('100%')
            .margin({ top: '3%' })

            Row() {
              Button($r('app.string.confirm_button'))// .dialogButtonStyle()
                .onClick(() => {
                  if(this.wifiCandidateConfig.ssid === '' || this.wifiCandidateConfig.preSharedKey === '') {
                    hilog.info(TAG, 'ssid || preSharedKey is null');
                    promptAction.showToast({ message : 'ssid or preSharedKey is null' })
                    return;
                  }
                  this.connectwifi(this.wifiCandidateConfig);
                })
                .height('100%')
            }
            .width('70')
            .height('6%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
        }
      }
  }