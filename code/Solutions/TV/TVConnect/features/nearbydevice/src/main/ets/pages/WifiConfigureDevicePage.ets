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

import { CommonConstants, InfDeviceState, Logger, NavBar, PageViewUtils, RelativeRules } from '@ohos/common';
import { TipButton } from '../view/TipButton';
import { AddDeviceItem } from '../viewmodel/AddDeviceItem';
import { HMRouter, HMRouterMgr } from '@hadss/hmrouter';
import { HttpApi, Project, VerifyCode } from '@ohos/connect_cloud';
import { ColorMetrics, LengthMetrics, promptAction } from '@kit.ArkUI';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { BusinessError } from '@kit.BasicServicesKit';
import { WifiAddDevicesManager } from '../viewmodel/WifiAddDevicesManager';
import { IpBean, IpDeviceInfo } from '../viewmodel/IpDeviceModel';
import PreferenceModel from '../viewmodel/PreferenceModel';
import PreferenceConstants from '../constants/PreferenceConstants';
import { DeviceManagerFactory, MessageAction } from '@ohos/device_manager';
import { KeyCode } from '@kit.InputKit';
import { registrationMonitoring } from './DeviceDetailPage';
import { inputMethod } from '@kit.IMEKit';

const TAG = 'WifiConfigureDevicePage';

/**
 * 配置设备页面
 * @param aboutDevice 设备相关信息
 */
@HMRouter({ pageUrl: 'WifiConfigureDevicePage' })
@Component
export struct WifiConfigureDevicePage {
  @State aboutDevice: AddDeviceItem | undefined = undefined;
  public addDevicesModel?: WifiAddDevicesManager;
  @State @Watch('calculateProgress') isConfiguring: boolean = false;
  @State currentProcess: number = 0;
  @State netName: string = 'WR300N-344258';
  @State cfgNetTips: ResourceStr = $r('app.string.connecting');
  @StorageProp('currentProject') currentSelect: Project = new Project();
  private netPassword: string = '12345678';
  private isConnect: ConnectType = ConnectType.CONNECTING;
  private cfgRes: CfgProgress = CfgProgress.CONFIGURING;
  private getIpRes: CfgProgress = CfgProgress.CONFIGURING;
  private timer: number = -1;
  private configureDeviceId: string | undefined;
  @State ipArray: IpBean[] = [];
  private receiversType: string = 'WifiConfigureDevicePage';
  inputController: inputMethod.InputMethodController | null = inputMethod.getController();

  aboutToAppear(): void {
    setTimeout(() => {
      PageViewUtils.tabClick();
      this.inputController = inputMethod.getController();
    }, 100);
    let device = this.aboutDevice;
    let params = HMRouterMgr.getCurrentParam() as Map<string, Object>;
    Logger.debug(TAG, `===>aboutToAppear currentItem = ${JSON.stringify(params['currentItem'])}`);
    this.aboutDevice = params['currentItem'] as AddDeviceItem;
    this.addDevicesModel = params['addDevicesModel'] as WifiAddDevicesManager;
  }

  aboutToDisappear(): void {
    if (this.timer !== -1) {
      clearInterval(this.timer);
    }
  }

  calculateProgress() {
    if (this.isConfiguring) {
      if (this.timer !== -1) {
        clearInterval(this.timer);
      }
      this.currentProcess = 0;
      Logger.info(TAG,
        `===>calculateProgress start, isConfiguring=${this.isConfiguring}, isConnect=${this.isConnect}, cfgRes=${this.cfgRes}`);
      this.timer = setInterval(() => {
        Logger.info(TAG,
          `===>calculateProgress loop: currentProcess=${this.currentProcess}, isConnect=${this.isConnect}, cfgRes=${this.cfgRes}`);
        if (this.currentProcess == 30) {
          Logger.info(TAG, `===>calculateProgress = 30, isConnect=${this.isConnect}, cfgRes=${this.cfgRes}`);
          if (this.isConnect == ConnectType.ONLINE) {
            this.cfgNetTips = $r('app.string.configuring');
          } else {
            Logger.warn(TAG, `===>calculateProgress = 30, isConnect is NOT ONLINE (${this.isConnect}), STOP!`);
            return;
          }
        } else if (this.currentProcess == 50) {
          Logger.info(TAG, `===>calculateProgress = 50, cfgRes=${this.cfgRes}`);
          if (this.cfgRes == CfgProgress.CFG_SUCCESS) {
            Logger.info(TAG, `===>calculateProgress = 50, CFG_SUCCESS, continue`);
          } else {
            Logger.warn(TAG, `===>calculateProgress = 50, cfgRes is NOT CFG_SUCCESS (${this.cfgRes}), STOP at 50%!`);
            return;
          }
        } else if (this.currentProcess == 99) {
          Logger.info(TAG, `===>calculateProgress = 99, cfgRes=${this.cfgRes}`);
          if (this.cfgRes == CfgProgress.CFG_SUCCESS) {
            return;
          }
        }
        ++this.currentProcess;
      }, 500);
    }
  }

  async configureNetMsg() {
    Logger.info(TAG, `===>configureNetMsg start, aboutDevice=${this.aboutDevice?.getUnionCode()}`);
    this.addDevicesModel?.connect(this.aboutDevice?.getUnionCode() as string, async (isConnect: number) => {
      Logger.info(TAG,
        `===>configureNetMsg connect callback: isConnect=${isConnect}, ConnectType.ONLINE=${ConnectType.ONLINE}`);
      this.isConnect = isConnect;
      if (isConnect == ConnectType.ONLINE) {
        Logger.info(TAG, `===>configureNetMsg: device ONLINE, starting queryDeviceSn`);
        let sn = await this.addDevicesModel?.queryDeviceSn();
        Logger.info(TAG,
          `===>configureNetMsg queryDeviceSn result: sn=${sn}, productId=${this.aboutDevice?.getProductID()}, projectId=${this.currentSelect.id}`);

        Logger.info(TAG, `===>configureNetMsg: calling getDevVerifyCode API`);
        let res: VerifyCode = await HttpApi.getInstance().getDevVerifyCode({
          projectId: this.currentSelect.id,
          sn: sn,
          productId: this.aboutDevice?.getProductID(),
          registryType: '',
          uniqueDeviceId: false
        });
        Logger.info(TAG, `===>getDevVerifyCode response: ${JSON.stringify(res)}`);

        if (!res || !res.verifyCode) {
          Logger.error(TAG, `===>getDevVerifyCode FAILED: verifyCode is empty!`);
          this.cfgRes = CfgProgress.CFG_FAILED;
          this.backToPage();
          return;
        }

        Logger.info(TAG,
          `===>configureNetMsg: verifyCode=${res.verifyCode}, devId=${res.deviceId}, cloudAddress=${res.cloudAddress}`);
        let netCfgMsg: Record<string, string> = {};
        netCfgMsg['configType'] = 'cloud';
        netCfgMsg['code'] = res.verifyCode;
        netCfgMsg['devId'] = res.deviceId;
        netCfgMsg['password'] = this.netPassword;
        netCfgMsg['psk'] = res.psk;
        netCfgMsg['ssid'] = this.netName;
        netCfgMsg['cloudPrimaryUrl'] = res.cloudAddress;
        netCfgMsg['cloudStandbyUrl'] = res.cloudAddress;
        Logger.info(TAG, `===>configureNetMsg: calling configureNetwork`);
        this.addDevicesModel?.configureNetwork(netCfgMsg).then(netRes => {
          Logger.info(TAG, `===>configureNetwork result = ${JSON.stringify(netRes)}`);
          this.cfgRes = netRes ? CfgProgress.CFG_SUCCESS : CfgProgress.CFG_FAILED;
          if (netRes) {
            promptAction.showToast({
              message: $r('app.string.cfg_success')
            });
            setTimeout(async () => {
              AppStorage.setOrCreate('needRefreshDeviceList', Date.now());
              AppStorage.setOrCreate('isWifiConnect', 'connect');
              this.backToPage();
            }, 30000);
          } else {
            promptAction.showToast({
              message: $r('app.string.cfg_failed')
            });
            this.backToPage();
          }

        }).catch((err: BusinessError) => {
          this.cfgRes = CfgProgress.CFG_FAILED;
          promptAction.showToast({
            message: $r('app.string.cfg_failed')
          });
          this.backToPage();
          Logger.error(TAG, `===>configureNetwork err = ${JSON.stringify(err)}`);
        });
      } else if (isConnect == ConnectType.OFFLINE || isConnect == ConnectType.DISCONNECT) {
        Logger.warn(TAG,
          `===>configureNetMsg: device OFFLINE or DISCONNECT, isConnect=${isConnect}, returning to previous page`);
        this.backToPage();
      } else if (isConnect == ConnectType.CONNECTING) {
        Logger.warn(TAG, `===>configureNetMsg: device still CONNECTING, waiting...`);
      }
    });
  }

  backToPage() {
    clearInterval(this.timer);
    this.addDevicesModel?.disconnect();
    HMRouterMgr.pop({
      pageUrl: 'DevicesMainPage',
    });
  }

  @Builder
  configureNet() {
    NavBar({
      title: $r('app.string.configure_device'), paddingLeft: $r('app.string.scan_tip_margin_top')
    });
    Column() {
      Image(this.aboutDevice?.getImageResource())
        .width($r('app.string.configure_device_image'))
        .height($r('app.string.configure_device_image'));
      Text(this.aboutDevice?.deviceName)
        .width(CommonConstants.FULL_HEIGHT_PERCENT)
        .textAlign(TextAlign.Center)
        .fontSize($r('app.string.button_font_size'))
        .textOverflow({ overflow: TextOverflow.Ellipsis })
        .maxLines(1);
    }
    .backgroundColor(Color.White)
    .height($r('app.string.configure_image_height'))
    .borderRadius($r('app.string.radius_16'))
    .padding({
      left: $r('app.string.configure_image_left_right_border'),
      right: $r('app.string.configure_image_left_right_border'),
      top: $r('app.string.configure_image_top')
    });

    Text($r('app.string.net_configure'))
      .textStyle();

    Column() {
      Row() {
        TextInput({ placeholder: '', text: this.netName })
          .textInputFancy()
          .id('netName')
          .onChange((value: string) => {
            this.netName = value;
          })
          .onKeyEvent((e) => {
            if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
              focusControl.requestFocus('netPassword');
            }
            return false;
          });
        Image($r('app.media.ic_public_arrow_right'))
          .width($r('app.string.wh_value_12'))
          .height($r('app.string.wh_value_24'));
      }
      .layoutWeight(1)
      .padding({ right: $r('app.string.scan_tip_margin_top') })
      .onFocus(() => {
        registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
          focusControl.requestFocus('netName');
        });
      });

      Divider().padding({ right: $r('app.string.scan_tip_margin_top') });

      Row() {
        TextInput({ placeholder: '', text: this.netPassword })
          .textInputFancy()
          .id('netPassword')
          .type(InputType.Password)
          .onChange((value: string) => {
            this.netPassword = value;
          })
          .onKeyEvent((e) => {
            if (e.keyCode == KeyCode.KEYCODE_DPAD_UP && e.type == KeyType.Down) {
              focusControl.requestFocus('netName');
            }
            if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
              focusControl.requestFocus('TipButton');
            }
            return false;
          });
      }.layoutWeight(1)
      .onFocus(() => {
        registrationMonitoring(KeyCode.KEYCODE_ENTER, () => {
          focusControl.requestFocus('netPassword');
        });
      });
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .borderRadius($r('app.string.radius_16'))
    .height($r('app.string.list_item_height'))
    .backgroundColor($r('app.color.white'))
    .padding({ left: $r('app.string.scan_tip_margin_top') });

    Blank();

    Button(
      $r('app.string.next_step'),
      { type: ButtonType.Capsule, stateEffect: true }
    )
      .onClick(() => {
        if (this.netName.trim() == '') {
          promptAction.showToast({ message: $r('app.string.please_input_net_configure_msg') });
          return;
        }
        this.isConfiguring = true;
        if (this.aboutDevice?.getUnionCode()) {
          Logger.debug(TAG, `===>configureNet${this.netName} ${this.netPassword}}`);
          this.addDevicesModel?.setSsidMsg(this.netName, this.netPassword);
          try {
            this.configureNetMsg();
          } catch (e) {
            Logger.error(TAG, `ConfigureDevicePage err = ${JSON.stringify(e)}`);
            promptAction.showToast({
              message: $r('app.string.cfg_failed')
            });
            this.backToPage();
          }
        }
      })
      .id('TipButton')
      .focusable(true)
      .fontColor(Color.White)
      .fontSize($r('app.string.font_16'))
      .width($r('app.string.tip_button_width'))
      .height($r('app.string.btn_height'))
      .backgroundColor($r('app.color.add_text_color'))
      .focusBox({
        margin: LengthMetrics.px(5),
        strokeColor: ColorMetrics.resourceColor($r('app.color.black')),
        strokeWidth: LengthMetrics.px(2)
      })
      .margin({ bottom: '30lpx' });
  }

  build() {
    Column() {
      if (!this.isConfiguring) {
        this.configureNet();
      } else {
        RelativeContainer() {
          Progress({ value: this.currentProcess, total: 100, type: ProgressType.Ring })
            .width($r('app.string.progress_size'))
            .height($r('app.string.progress_size'))
            .style({ strokeWidth: $r('app.string.vp_30'), shadow: true })
            .alignRules(RelativeRules.centerRule)
            .id('progress');
          Row() {
            Text(this.currentProcess.toString())
              .fontSize($r('app.string.progress_font_size'))
              .fontWeight(FontWeight.Medium);
            Text('%').fontSize($r('app.string.font_16')).margin({ bottom: $r('app.string.vp_10') });
          }.alignRules(RelativeRules.centerRule)
          .alignItems(VerticalAlign.Bottom)
          .id('row');

          Text(this.cfgNetTips)
            .fontSize($r('app.string.button_font_size'))
            .fontColor($r('sys.color.mask_secondary'))
            .fontWeight(FontWeight.Regular)
            .id('text')
            .alignRules({
              top: { 'anchor': 'row', 'align': VerticalAlign.Bottom },
              middle: { 'anchor': '__container__', align: HorizontalAlign.Center }
            });

          Text($r('app.string.patient_wait'))
            .fontSize($r('app.string.fp_20'))
            .fontWeight(FontWeight.Medium)
            .id('wait').alignRules({
            top: { 'anchor': 'progress', 'align': VerticalAlign.Bottom },
            middle: { 'anchor': '__container__', align: HorizontalAlign.Center }
          });
        };
      }
    }
    .width(CommonConstants.FULL_WIDTH_PERCENT)
    .height(CommonConstants.FULL_HEIGHT_PERCENT)
    .backgroundColor($r('app.color.page_color_f1f3f5'))
    .padding({ left: $r('app.string.scan_tip_margin_top'), right: $r('app.string.scan_tip_margin_top') })
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM]);
  }
}

@Extend(TextInput)
function textInputFancy() {
  .placeholderColor(Color.Grey)
  .backgroundColor($r('app.color.white'))
  .placeholderFont({ size: $r('app.string.font_16'), weight: FontWeight.Medium })
  .fontSize($r('app.string.font_16'))
  .fontColor($r('app.color.font_color_E6000000'))
  .layoutWeight(1);
}

@Extend(Text)
function textStyle() {
  .width(CommonConstants.FULL_WIDTH_PERCENT)
  .padding({ left: $r('app.string.scan_tip_margin_top') })
  .textAlign(TextAlign.Start)
  .fontColor($r('app.color.tips_button_backgroundColor'))
  .fontSize($r('app.string.button_font_size'))
  .margin({ top: $r('app.string.wh_value_22'), bottom: $r('app.string.wh_value_8') });
}

export enum CfgProgress {
  CONFIGURING, // 配网中
  CFG_SUCCESS, // 配网成功

  CFG_FAILED, // 配网失败
}