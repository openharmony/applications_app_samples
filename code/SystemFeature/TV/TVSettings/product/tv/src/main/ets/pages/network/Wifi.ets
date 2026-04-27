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

import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import router from '@ohos.router';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { KeyCode } from '../../common/constants/KeyCode';
import WifiModel, { ScanWifi, WiFiSummaryMap } from '../../model/wifiImpl/WifiModel';
import lpx from '../../common/Lpx';
import { WifiScanInfo, ApScanResult, } from '../../model/wifiImpl/WifiModel';
import promptAction from '@ohos.promptAction';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { CustomDialogContentStyle, SettingItemStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import { inputEventClient } from '@kit.InputKit';
import { BusinessError, emitter, settings  } from '@kit.BasicServicesKit';
import { Duration } from '../../common/constants/Duration';
import { PreferencesUtil } from '../../staticSubscriber/PreferencesUtil';
import wifiManager from '@ohos.wifiManager';
import { EventUtil } from '../../common/EventUtil';
import http from '@ohos.net.http';
import { CustomDialogTvComponent, DialogContent } from '../../default/layout/CustomDialogTvComponent';
import { connection } from '@kit.NetworkKit';
import BasicDataSource from '../../../../../../../common/utils/src/main/ets/default/model/BasicDataSource';
import ImageAnimatorComponent from '../../../../../../../common/component/src/main/ets/default/ImageAnimatorComponent';
import { common } from '@kit.AbilityKit';
import { CustomDialogComponent } from '../hotspot/CustomDialogComponent';

export interface Params {
  apInfo: WifiScanInfo,
  isConnected: boolean
}

const WIFI_ENTRY_COMPONENT_HEIGHT: number = 98;
const LIST_ITEM_PADDING: number = 6;
const LIST_ITEM_BORDER: number = 2;
const LIST_SPACE: number = 12;
const SINGLE_LIST_ITEM_HEIGHT = WIFI_ENTRY_COMPONENT_HEIGHT + LIST_ITEM_PADDING * 2 + LIST_ITEM_BORDER * 2;
const SCREEN_HEIGHT: number = px2lpx(globalThis.screenHeight);
const BUFFER_HEIGHT: number = 150;
// Miracast相关
const MIRACAST_QUICK_PLAY_KEY = 'settings.wifi.miracast.quickplay';
const FALSE = '0';
const TRUE = '1';
const wificonnectPromption: string = getContext(this).resourceManager.getStringByNameSync('wificonnectPromption')
const DIALOGWIDTH = 692
const DIALOGHEIGHT = 400
const MODULE_TAG = ConfigData.TAG + 'WifiModel.wifi -> ';
const CONNECTIVITY_CHECK_PROTOCOL = 'http'
const CONNECTIVITY_CHECK_HOST = ['connectivitycheck', 'platform', 'hicloud', 'com'].join('.')
const CONNECTIVITY_CHECK_PATH = 'generate_204'
const CONNECTIVITY_CHECK_URL =
  `${CONNECTIVITY_CHECK_PROTOCOL}://${CONNECTIVITY_CHECK_HOST}/${CONNECTIVITY_CHECK_PATH}`

@CustomDialog
struct ConnectProgressDialog {
  controller: CustomDialogController;
  @Prop ssid: string;
  @State message: string = ''

  aboutToAppear() {
    this.message = wificonnectPromption + this.ssid;
  }

  build() {
    Column() {
      Row() {
        Text(this.message)
          .fontSize('40lpx')
          .fontColor(Color.White)
          .fontWeight(500)
          .align(Alignment.Start)
          .maxLines(1)
          .textOverflow({overflow:TextOverflow.Ellipsis})
          .maxFontSize(10)
          .height('47lpx')
          .width('373lpx')
        ImageAnimatorComponent({
          imageWidth: lpx(48),
          imageHeight: lpx(48),
        })
      }
      .width('100%')
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('100%')
    }
    .height('96lpx')
    .width('527lpx')
    .border({
      style: BorderStyle.Solid,
      width: lpx(2),
      radius: lpx(24),
      color: Color.White
    })
    .stateStyles({
      focused: {
        .border({
          color: Color.Transparent
        })
      }
    })
    .backgroundColor('#666666')
  }
}



@Entry
@Component
struct Wifi {
  @State isPageReady: boolean = false;  // 添加页面就绪标志
  @State tobeConnectedSSID: string = '';
  @State apInfoWifiScanInfo: WifiScanInfo = {
    ssid: '',
    bssid: '',
    rssi: -100,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 1,
  };
  @State imageUrl: string = Ratio.resName('icon_wifi')
  @State des: string = '连接无线网络'
  @State
  isOne: boolean = true
  @State
  isTwo: boolean = true
  @State focusIndex: number = -2
  @State userSelectedApInfo: WifiScanInfo = {
    ssid: '',
    bssid: '',
    rssi: -100,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 1,
  };
  @State isWiFiEnabled: boolean = false;
  @StorageLink('slWiFiLists') @Watch('onWiFiResultsChange') scanWiFiResults: ScanWifi[] = [];
  @State filterWifiList: FilteredWiFiDataSource = new FilteredWiFiDataSource();
  @StorageLink('slConnectedWifi') @Watch('onConnectedWifiChange') slConnectedWifi: ScanWifi = {
    settingIcon: '',
    settingSummary: 0,
    settingTitle: '',
    settingValue: '',
    settingArrow: '',
    settingArrowStyle: '',
    settingUri: '',
    apInfo: {
      ssid: '',
      bssid: '',
      rssi: 0,
      band: 0,
      frequency: 0,
      timestamp: 0,
      securityType: 0,
    }
  };
  @State isHotSpotEnabled:boolean = false
  scroller: Scroller = new Scroller();
  listScroller: ListScroller = new ListScroller()
  private switchDebounceFlag: number = 0;
  private timerId: number = -1;
  private errorMessage: string = '开启WLAN失败，请检查硬件设施';
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  private netCon: connection.NetConnection = connection.createNetConnection();
  @State  jump: boolean = false
  @StorageLink('currentLink') currentLinkedWifi: ScanWifi = {
    settingIcon: '',
    settingSummary: 0,
    settingTitle: '',
    settingValue: '',
    settingArrow: '',
    settingArrowStyle: '',
    settingUri: '',
    apInfo: {
      ssid: '',
      bssid: '',
      rssi: -100,
      band: 0,
      frequency: 0,
      timestamp: 0,
      securityType: 1,
    },
  }
  @State isSetUpWizard:boolean = true
  private content: DialogContent = new DialogContent('开启WLAN', '开启WLAN将关闭热点，是否继续', '', '', DIALOGWIDTH, DIALOGHEIGHT);
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogComponent({
      cancel: (): void => this.onCancel(),
      confirm: (): void => this.onConfirm(),
      content: this.content,
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })
  onConfirm() {
    wifiManager.disableHotspot()
    this.isHotSpotEnabled = false
    this.SetStatus()
    this.isWiFiEnabled = true;
    this.SetWifiStatus()
    wifiManager.enableWifi()
    this.dialogController.close();
  }

  onCancel() {
    this.isWiFiEnabled = false;
    wifiManager.disableWifi()
    this.SetWifiStatus()
    this.dialogController.close();
  }
  onWiFiResultsChange() {
    // 更新数据源
    this.filterWifiList.setData(this.scanWiFiResults, this.slConnectedWifi);
    const length = this.filterWifiList.totalCount();
    // 调整焦点，越界处理
    if (this.focusIndex >= length) {
      this.focusIndex = length - 1
    }
    if (this.focusIndex >= 0) {
      this.adjustOffsetY()
    }
  }

  onConnectedWifiChange() {
    LogUtil.info(`Wifi: Connected WiFi changed to: ${this.slConnectedWifi.settingTitle}`);
    this.filterWifiList.updateConnectedWifi(this.slConnectedWifi);

    // 重新调整焦点
    const length = this.filterWifiList.totalCount();
    if (this.focusIndex >= length) {
      this.focusIndex = Math.max(-1, length - 1);
    }

    // 移植：当 slConnectedWifi 变化时，更新 currentLinkedWifi
    if (
      this.slConnectedWifi.settingTitle &&
      this.slConnectedWifi.settingTitle !== this.currentLinkedWifi.settingTitle
    ) {
      console.log('wifiPro onConnectedWifiChange center')
      this.currentLinkedWifi = this.slConnectedWifi;
      AppStorage.setOrCreate('currentLink', this.currentLinkedWifi);
    }
    if (this.slConnectedWifi.settingSummary === WiFiSummaryMap.CONNECTED_PRO) {
      if (
        this.slConnectedWifi.settingTitle &&
        this.slConnectedWifi.settingTitle !== this.currentLinkedWifi.settingTitle
      ) {
        console.log('wifiPro onConnectedWifiChange end')
        this.checkInternetAccess(true)
      }
    }
  }
  // 简化的网络检测功能，移除通知相关逻辑
  async checkInternetAccess(flag: boolean): Promise<void> {
    const connected: boolean = await this.isWifiConnected();
    const titleSign: string | boolean =
      (this.slConnectedWifi.settingTitle) && (this.slConnectedWifi.settingTitle.length > 0);
    LogUtil.debug(MODULE_TAG + 'connected=' + connected + 'this.isWiFiEnabled=' +
    this.isWiFiEnabled +
      'this.slConnectedWifi.settingTitle=' + this.slConnectedWifi.settingTitle)
    if (connected && this.isWiFiEnabled && titleSign) {
      const httpRequest = http.createHttp();
      httpRequest.request(
        CONNECTIVITY_CHECK_URL,
        {
          method: http.RequestMethod.GET,
          header: { 'Content-Type': 'application/json' },
          connectTimeout: 5000,
          readTimeout: 5000
        }).then((data: http.HttpResponse) => {
        LogUtil.debug(MODULE_TAG + 'wifiPro httpRequest.request code:' + JSON.stringify(data.responseCode));
        // 移植：确保 currentLinkedWifi 有值
        if (!this.currentLinkedWifi.settingTitle && this.slConnectedWifi.settingTitle) {
          console.debug('wifiPro httpRequest.request center')
          this.currentLinkedWifi = this.slConnectedWifi;
        }
        console.debug('wifiPro httpRequest.request end=' + this.currentLinkedWifi.settingTitle)
        const typeFlag = AppStorage.get(this.currentLinkedWifi.settingTitle) as boolean | undefined
        if (data.responseCode === 204 && this.currentLinkedWifi.settingTitle) {
          if (typeFlag == false) {
            AppStorage.setOrCreate(this.currentLinkedWifi.settingTitle, true)
          } else {
            // TV版本可能不需要持久化存储
            AppStorage.setOrCreate(this.currentLinkedWifi.settingTitle, true)
          }
          this.slConnectedWifi.settingSummary = WiFiSummaryMap.CONNECTED
        } else {
          if (typeFlag == true) {
            AppStorage.setOrCreate(this.currentLinkedWifi.settingTitle, false)
          }
          this.slConnectedWifi.settingSummary = WiFiSummaryMap.CONNECTED_PRO
          if (flag && this.jump) {
            console.debug('wifiPro flag && this.jump startBrowserAbility')
            this.startBrowserAbility()
            this.jump = false
          }
        }
      }).catch(async (err: Error) => {
        LogUtil.error(MODULE_TAG + 'wifiPro err: +' + JSON.stringify(err))
        const netHandle: connection.NetHandle = await connection.getDefaultNet()
        const datas: connection.NetCapabilities = await connection.getNetCapabilities(netHandle)
        if (!datas.networkCap?.includes(16) && !datas.networkCap?.includes(31)) {
          console.debug('wifiPro catch if')
          AppStorage.setOrCreate(this.currentLinkedWifi.settingTitle, false)
          this.slConnectedWifi.settingSummary = WiFiSummaryMap.CONNECTED_PRO
        } else {
          console.debug('wifiPro catch else')
          AppStorage.setOrCreate(this.currentLinkedWifi.settingTitle, true)
          this.slConnectedWifi.settingSummary = WiFiSummaryMap.CONNECTED
        }
      })
    }
  }

  // WiFi连接状态检查
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

  // 浏览器启动功能
  startBrowserAbility(): void {
    let context = getContext(this) as common.UIAbilityContext;
    let wantInfo: Want = {
      action: 'ohos.want.action.viewData',
      entities: ['entity.system.browsable'],
      uri: CONNECTIVITY_CHECK_URL,
    }
    context.startAbility(wantInfo).then(() => {
      LogUtil.info(MODULE_TAG + 'startAbility ohos.want.action.viewData success!!!')
    }).catch((err: BusinessError) => {
      LogUtil.info(MODULE_TAG + 'startAbility ohos.want.action.viewData fail, err: ' + JSON.stringify(err))
    })
  }

  // 通过focusIndex调整列表滚动条
  adjustOffsetY() {
    // 计算列表高度比例和实际高度
    const visibleHeightProportion: number =
      parseInt(this.slConnectedWifi.settingTitle ? ConfigData.WH_45_100 : ConfigData.WH_58_100) / 100
    const visibleHeight = SCREEN_HEIGHT * visibleHeightProportion

    // 获取当前滚动位置和可见区域上下边界
    const curYOffset = vp2px(this.scroller.currentOffset()?.yOffset || 0)
    const enableAreaTop = curYOffset + BUFFER_HEIGHT
    const enableAreaBottom = curYOffset + visibleHeight - BUFFER_HEIGHT

    // 计算当前焦点项的上下边界
    const curFocusItemTop = this.focusIndex * SINGLE_LIST_ITEM_HEIGHT + this.focusIndex * LIST_SPACE
    const curFocusItemBottom = curFocusItemTop + SINGLE_LIST_ITEM_HEIGHT

    // 检查焦点项是否在可见区域内
    const isInEnableArea = curFocusItemTop >= enableAreaTop && curFocusItemBottom <= enableAreaBottom

    // 如果已经在可见区域内，无需调整
    if (isInEnableArea) {
      return;
    }

    //计算需要滚动的位置并执行滚动
    const newYOffset: string = curFocusItemTop < enableAreaTop ? (curFocusItemTop - BUFFER_HEIGHT) + 'lpx' :
      (curFocusItemBottom - visibleHeight + BUFFER_HEIGHT) + 'lpx'

    this.scroller.scrollTo({
      xOffset: 0,
      yOffset: newYOffset,
      animation: true
    })

  }

  pageTransition() {
    if (this.pageTranState) {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Left)
    } else {
      PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
      PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
        .slide(SlideEffect.Right)
    }
  }

  async handleFocus(data: string) {
    if (data == 'delete') {
      this.focusIndex = -2
    } else if (data == 'link') {
      let res = await wifiManager.getLinkedInfo()
      if (res.networkId) {
        this.focusIndex = -2
      }else {
        this.focusIndex = -1
      }
    }
  }
  private connectDialog: CustomDialogController = new CustomDialogController({
    builder: ConnectProgressDialog({
      ssid: this.apInfoWifiScanInfo.ssid,
    }),
    alignment: DialogAlignment.Center,
    offset: ({ dx: 0, dy: 0 }),
    autoCancel: false,
    customStyle: true
  });

  wifiConnectDialog: CustomDialogController = new CustomDialogController({
    builder: CustomDialogTvComponent({
      cancel: () => {
        this.wifiConnectDialog.close()
        this.activateFocusStyle(false)
        emitter.emit('linkFocus', { data: { type:'link' } })
      },
      confirm: async () => {
        // 开始连接时停止扫描和关闭p2p
        WifiModel.stopScanTask();
        this.setDiscoverableFalse()
        this.wifiConnectDialog.close()
        this.connectDialog.open()
        WifiModel.disconnectWiFi();
        LogUtil.info('wifiConnectDialog' + 'after disconnectWiFi, before connectByDeviceConfig');
        // 把这个函数改写成异步函数，保证有连接结果的返回再刷新列表与关闭弹窗
        await WifiModel.connectByDeviceConfig(this.apInfoWifiScanInfo);
        LogUtil.info('wifiConnectDialog' + 'after connectByDeviceConfig, before refreshApScanResults');
        this.connectDialog.close()
        WifiModel.refreshApScanResults();
        WifiModel.startScanTask();
        this.activateFocusStyle(false)
        emitter.emit('linkFocus', { data: { type:'link' } })
      },
      content: new DialogContent('是否连接wifi?', `此操作将会连接当前wifi`, '取消', '连接', 692, 332),
      contentStyle: CustomDialogContentStyle.titleContent
    }),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    customStyle: true
  })

  //注册网络监听事件
  onNetRegister(){
    // 创建NetConnection对象
    // 先使用register接口注册订阅事件
    this.netCon.register((error: BusinessError) => {
      console.log('hsq', '开始网络监听')
      console.error(JSON.stringify(error));
    });
    // 订阅网络可用事件。调用register后，才能接收到此事件通知
    this.netCon.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
      console.log('hsq', '执行1')
      if (data.netCap.bearerTypes[0] === 3) {
        router.replaceUrl({
          url: 'pages/network/Network'
        }, router.RouterMode.Single)
        setTimeout(()=>{
          this.offNetRegister()
        },100)
      }
    });
  }
  /**
   *取消网络监听
   */
  offNetRegister(){
    // 使用unregister接口取消订阅
    this.netCon.unregister((error: BusinessError) => {
      console.log('hsq', '取消网络监听')
    });
  }

  setDiscoverableFalse() {
    settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, FALSE);
    LogUtil.info(`Wifi: set discoverable false`)
  }

  setDiscoverableTrue() {
    settings.setValue(getContext(this), MIRACAST_QUICK_PLAY_KEY, TRUE);
    LogUtil.info(`Wifi: set discoverable true`)
  }
  GetStatus(){
    const context = this.getSafeAbilityContext();
    if (context === null) {
      return;
    }
    const value = settings.getValueSync(context,'hotspotStatus','false');
    console.log(`get hotspotStatus:${value}`);
    if(value == 'true'){
      this.isHotSpotEnabled = true
      console.log('GetStatus this.isHotSpotEnabled true ',this.isHotSpotEnabled)
    }else {
      this.isHotSpotEnabled = false
      console.log('GetStatus this.isHotSpotEnabled false ',this.isHotSpotEnabled)
    }
  }
  async SetStatus(){
    const context = this.getSafeAbilityContext();
    if (context === null) {
      return;
    }
    await new Promise<string>(()=>{
      settings.setValue(context, 'hotspotStatus', JSON.stringify(this.isHotSpotEnabled), (status) => {
        console.info('Callback return whether value is set. this.isHotSpotEnabled',this.isHotSpotEnabled);
      });
    })
  }

  private getSafeAbilityContext(): common.Context | null {
    return getContext(this) as common.Context ?? null;
  }

  private activateFocusStyle(isActive: boolean): void {
    let activeFlag = isActive;
    activeFlag = activeFlag;
  }

  GetWifiStatus(){
    try {
      // 检查 UI 上下文是否可用
      if (!this.isPageReady) {
        return;
      }
      const context: common.Context | null = this.getSafeAbilityContext();
      if (context === null) {
        return;
      }
      const value = settings.getValueSync(context, 'WifiStatus', 'false');
      this.isWiFiEnabled = (value == 'true') ? true : false;
    } catch (error) {
      LogUtil.error('GetWifiStatus failed:' +  JSON.stringify(error));
      this.isWiFiEnabled = false;
    }
  }
  async SetWifiStatus(){
    // 检查 UI 上下文是否可用
    if (!this.isPageReady) {
      return;
    }
    const context: common.Context | null = this.getSafeAbilityContext();
    if (context === null) {
      return;
    }
    let status : string = (this.isWiFiEnabled) ? 'true' : 'false';
    settings.setValueSync(context, 'WifiStatus', status);
    LogUtil.debug('setValueSync WifiStatus:' + status);
  }
  GetSetUpWizardStatus(){
    // 检查 UI 上下文是否可用
    if (!this.isPageReady) {
      return;
    }
    const context: common.Context | null = this.getSafeAbilityContext();
    if (context === null) {
      return;
    }
    const value = settings.getValueSync(context, 'SetUpWizard','true')
    LogUtil.debug('GetStatus is SetUpWizard: ' + value);
    this.isSetUpWizard = (value == 'true') ? true : false;
  }
  async SetSetUpWizardStatus(){
    // 检查 UI 上下文是否可用
    if (!this.isPageReady) {
      return;
    }
    const context: common.Context | null = this.getSafeAbilityContext();
    if (context === null) {
      return;
    }
    await new Promise<string>(()=>{
      settings.setValue(context, 'SetUpWizard', JSON.stringify(this.isSetUpWizard), () => {
        LogUtil.debug('setValue SetUpWizard: ' + this.isSetUpWizard);
      });
    })
  }
  build() {
    Row() {
      Column() {
        Text($r('app.string.wirelessNetwork'))
          .width(lpx(868))
          .height(lpx(75))
          .lineHeight(lpx(75))
          .fontColor(Color.White)
          .fontSize(lpx(64))
          .fontWeight(500)
          .textAlign(TextAlign.Start)
          .alignSelf(ItemAlign.Start)
          .margin({
            top: lpx(48),
            bottom: lpx(48),
            left: lpx(12)
          })

        Row() {
          Row() {
            Text('无线局域网')
              .height(lpx(98))
              .fontColor(this.focusIndex == -2 ? '#000000' : '#ffffff')
              .fontSize(lpx(36))
              .align(Alignment.Center)
              .textAlign(TextAlign.Start)
              .margin({
                left: lpx(24)
              })

            Blank()

            Toggle({ type: ToggleType.Switch, isOn: this.isWiFiEnabled })
              .width(lpx(83))
              .height(lpx(46))
              .selectedColor('#2056f7')
              .switchPointColor(0xe5ffffff)
              .align(Alignment.Center)
              .margin({ right: lpx(24) })
              .stateStyles({
                focused: {
                  .border({
                    color: Color.Transparent
                  })
                }
              })
              .focusable(true)
              .onClick(()=>{
                this.isWiFiEnabled = !this.isWiFiEnabled;
                if (this.isWiFiEnabled) {
                  this.GetStatus()
                  if(this.isHotSpotEnabled){
                    this.dialogController.open()
                  }else {
                    this.isWiFiEnabled = true;
                    wifiManager.enableWifi()
                    this.SetWifiStatus()
                  }
                } else {
                  this.isWiFiEnabled = false
                  this.SetWifiStatus()
                  WifiModel.destroyWiFiModelData();
                  WifiModel.disableWifi();
                }
                this.switchWiFiActiveStatus();
              })
          }
          .width(lpx(840))
          .height(lpx(98))
          .backgroundColor(this.focusIndex === -2 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
          .borderRadius(lpx(18))
        }
        .padding(lpx(6))
        .border({
          width: lpx(2),
          color: this.focusIndex === -2 ? Color.White : Color.Transparent,
          radius: lpx(24),
          style: BorderStyle.Solid
        })
        .justifyContent(FlexAlign.Center)
        .alignItems(VerticalAlign.Center)
        .focusable(true)
        .onHover(() => {
          this.focusIndex = -2;
        })
        .onTouch((event?: TouchEvent) => {
          if (!event) {
            return;
          }
          if (!EventUtil.isTouchEvent(event)) {
            return;
          }
          if (!EventUtil.isPenOrMouseClick(event, SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK)) {
            return;
          }
        })

        Column() {
          //wifi列表
          if (this.isWiFiEnabled) {
            if (this.filterWifiList.totalCount() > 0) {
              Column() {
                Text('已连接网络')
                  .fontColor('rgba(255, 255, 255, 0.9)')
                  .fontSize(lpx(30))
                  .lineHeight(lpx(36))
                  .textAlign(TextAlign.Start)
                  .width(ConfigData.WH_100_100)
                  .padding({
                    top: lpx(16),
                    left: lpx(12),
                    bottom: lpx(16)
                  })
                  .visibility(this.slConnectedWifi.settingTitle ? Visibility.Visible : Visibility.None)
                Column() {
                  Row() {
                    Column() {
                      Text(this.slConnectedWifi.settingTitle)
                        .fontSize(lpx(36))
                        .fontColor(this.focusIndex === -1 ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
                        .focusable(true)
                        .fontWeight(FontWeight.Medium);
                    }
                    .margin({
                      left: lpx(24)
                    })
                    .alignItems(HorizontalAlign.Start)

                    Text()
                      .flexGrow(1)
                    Image(this.slConnectedWifi.settingArrow)
                      .width(lpx(68))
                      .aspectRatio(1)
                      .margin({ right: lpx(20) })
                      .fillColor(this.focusIndex === -1 ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.86)')
                  }
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .backgroundColor(this.focusIndex === -1 ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
                  .height(lpx(98))
                  .width(lpx(840))
                  .borderRadius(lpx(18))
                  .alignItems(VerticalAlign.Center)
                  .borderColor('rgba(255, 255, 255, 0.2)')
                }
                .alignItems(HorizontalAlign.Center)
                .justifyContent(FlexAlign.Center)
                .focusable(this.isNeedRenderConnectedWiFi() ? true : false)
                .padding(lpx(6))
                .border({
                  width: lpx(2),
                  color: this.focusIndex === -1 ? Color.White : Color.Transparent,
                  style: BorderStyle.Solid,
                  radius: lpx(24)
                })
                .onAppear(() => {
                  if (this.slConnectedWifi.settingTitle) {
                    this.focusIndex = -1;
                  }
                })
                .onHover(() => {
                  this.focusIndex = -1;
                })
                .onClick(()=>{
                  router.pushUrl({
                    url: 'pages/network/WifiInfoDetail',
                    params: {
                      apInfo: this.slConnectedWifi.apInfo,
                      isConnected: true
                    }
                  }, router.RouterMode.Single)
                  this.pageTranState = true
                })
                .onTouch((event?: TouchEvent) => {
                  if (!event) {
                    return;
                  }
                  if (!EventUtil.isTouchEvent(event)) {
                    return;
                  }
                  if (!EventUtil.isPenOrMouseClick(event, SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK)) {
                    return;
                  }
                  router.pushUrl({
                    url: 'pages/network/WifiInfoDetail',
                    params: {
                      apInfo: this.slConnectedWifi.apInfo,
                      isConnected: true
                    }
                  }, router.RouterMode.Single)
                  this.pageTranState = true
                })
                .visibility(this.isNeedRenderConnectedWiFi() ? Visibility.Visible : Visibility.None);
              }
              .alignItems(HorizontalAlign.Start)
              .justifyContent(FlexAlign.Start)

              Text('其他网络')
                .fontColor('rgba(255, 255, 255, 0.9)')
                .fontSize(lpx(30))
                .lineHeight(lpx(36))
                .textAlign(TextAlign.Start)
                .width(ConfigData.WH_100_100)
                .padding({
                  top: lpx(16),
                  left: lpx(12),
                  bottom: lpx(16)
                })
              List({ space: lpx(12), scroller: this.scroller }) {
                LazyForEach(this.filterWifiList, (item: ScanWifi, index) => {
                  ListItem() {
                    WiFiEntryComponent({
                      settingTitle: item.settingTitle,
                      settingArrow: item.settingArrow,
                      isFocus: this.focusIndex === index,
                    })
                  }
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
                  .borderRadius(lpx(18))
                  .focusable(true)
                  .padding(lpx(LIST_ITEM_PADDING))
                  .border({
                    width: lpx(LIST_ITEM_BORDER),
                    color: this.focusIndex === index ? Color.White : Color.Transparent,
                    style: BorderStyle.Solid,
                    radius: '24lpx'
                  })
                  .onHover(() => {
                    this.focusIndex = index;
                  })
                  .onClick(()=>{
                    this.userSelectedApInfo = item.apInfo;
                    console.log('wifiPro other this.jump = true')
                    this.jump = true
                    if (WifiModel.isSavedAp(item.settingTitle)) {
                      this.apInfoWifiScanInfo=item.apInfo
                      this.wifiConnectDialog.open()
                      this.activateFocusStyle(true)
                    } else {
                      this.jumpToConnectApPage(item.apInfo);
                    }
                  })
                  .onTouch((event?: TouchEvent) => {
                    if (!event) {
                      return;
                    }
                    if (!EventUtil.isTouchEvent(event)) {
                      return;
                    }
                    if (!EventUtil.isPenOrMouseClick(event, SourcetoolConstants.SOURCE_TOOL_MOUSE_CLICK)) {
                      return;
                    }
                  })
                }, (item: ScanWifi, index: number) => {
                  return JSON.stringify(item.apInfo.bssid) + index;
                });
              }
              .cachedCount(3)
              .scrollBar(BarState.Off)
              .width(ConfigData.WH_100_100)
              .margin({
                bottom: lpx(178),
              })
              .height(this.slConnectedWifi.settingTitle ? ConfigData.WH_45_100 : ConfigData.WH_58_100)
            } else {
              Text('正在搜索...')
                .fontColor('rgba(255, 255, 255, 0.9)')
                .fontSize(lpx(30))
                .lineHeight(lpx(36))
                .textAlign(TextAlign.Start)
                .width(ConfigData.WH_100_100)
                .padding({
                  top: lpx(16),
                  left: lpx(12),
                  bottom: lpx(16)
                })
            }
          }
        }
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)
        .width(ConfigData.WH_100_100)

      }
      .alignItems(HorizontalAlign.Start)
      .width(ConfigData.WH_50_100)
      .height(ConfigData.WH_100_100)
      .margin({ left: lpx(84) })


      SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
        .width(ConfigData.WH_50_100)
        .height(ConfigData.WH_100_100)
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
    .backgroundColor('rgb(24, 24, 26)')
    .onKeyEvent((event?: KeyEvent) => {
      if (!event) {
        return;
      }
      event.stopPropagation?.()
      if (event.type === KeyType.Down) {
        if (this.focusIndex === -2) {
          // toggle的按键事件
          if (event.keyCode === KeyCode.KEY_ENTER) {
            // 确认键
            this.isWiFiEnabled = !this.isWiFiEnabled;
            if (this.isWiFiEnabled) {
              this.GetStatus()
              if(this.isHotSpotEnabled){
                this.dialogController.open()
              }else {
                this.isWiFiEnabled = true;
                wifiManager.enableWifi()
                this.SetWifiStatus()
              }
            } else {
              this.isWiFiEnabled = false
              this.SetWifiStatus()
              WifiModel.destroyWiFiModelData();
              WifiModel.disableWifi();
            }
            this.switchWiFiActiveStatus();
          }
        } else if (this.focusIndex === -1) {
          // 已连接网络的按键事件
          if (event.keyCode === KeyCode.KEY_ENTER) {
            // 确认键
            router.pushUrl({
              url: 'pages/network/WifiInfoDetail',
              params: {
                apInfo: this.slConnectedWifi.apInfo,
                isConnected: true
              }
            }, router.RouterMode.Single)
            this.pageTranState = true
          }
        } else if (this.focusIndex >= 0) {
          // WIFI列表的按键事件
          if (event.keyCode === KeyCode.KEY_ENTER) {
            console.log(JSON.stringify(this.scanWiFiResults),'wifipsdd所有列表')
            console.log(JSON.stringify(this.focusIndex),'wifipsdd索引')
            // 确认键
            const item = this.filterWifiList.getData(this.focusIndex);
            this.userSelectedApInfo = item.apInfo;
            console.log('wifiPro other this.jump = true')
            this.jump = true
            if (WifiModel.isSavedAp(item.settingTitle)) {
              this.apInfoWifiScanInfo=item.apInfo
              this.wifiConnectDialog.open()
              this.activateFocusStyle(true)
            } else {
              this.jumpToConnectApPage(item.apInfo);
              this.pageTranState = true
            }
          }
        }
      } else if (event.type === KeyType.Up) {
        let isPlus: boolean | undefined = undefined;
        if (event.keyCode === KeyCode.KEY_DPAD_UP) {
          isPlus = false;
        } else if (event.keyCode === KeyCode.KEY_DPAD_DOWN) {
          isPlus = true;
        }
        if (isPlus === undefined) {
          return;
        }
        let nextFocusIndex = isPlus ? this.focusIndex + 1 : this.focusIndex - 1;
        // 判断边界条件
        if (nextFocusIndex < -2) {
          return;
        }
        if (nextFocusIndex >= this.filterWifiList.totalCount()) {
          nextFocusIndex = this.filterWifiList.totalCount() - 1;
        }
        // 下一个焦点特殊处理
        if (!this.isWiFiEnabled) {
          nextFocusIndex = -2;
        } else {
          const hasWifiItems = this.filterWifiList.totalCount() > 0;
          const hasConnectedWifi = this.slConnectedWifi.settingTitle;
          if (nextFocusIndex === -1 && !hasConnectedWifi) {
            nextFocusIndex = isPlus ? (hasWifiItems ? 0 : -2) : -2;
          } else if (nextFocusIndex > -1 && !hasWifiItems) {
            nextFocusIndex = hasConnectedWifi ? -1 : -2;
          }
        }
        this.focusIndex = nextFocusIndex;
        this.adjustOffsetY();
      }
    })

  }

  aboutToAppear() {
    this.GetSetUpWizardStatus()
    let wifiSatus = wifiManager.isWifiActive()
    if(this.isSetUpWizard && wifiSatus){
      this.isSetUpWizard = false
      this.SetSetUpWizardStatus()
      this.isWiFiEnabled = true
    }
    emitter.on('linkFocus', (data) => {
      if (data && data.data) {
        this.handleFocus(data.data.type)
      }
    })

    setTimeout(() => {
      this.isPageReady = true;
      this.SetWifiStatus()
      this.GetWifiStatus()
    }, 200); // 延迟 300ms 确保页面完全初始化

    try {
      WifiModel.registerWiFiStatusObserver((code: number) => {
        if ((!this.switchDebounceFlag) && (code == 0 || code == 1)) {
          this.GetWifiStatus()
          if (this.timerId != -1) {
            clearTimeout(this.timerId);
            this.timerId = -1;
          }
        }
      });
      AppStorage.get('linkWifiOff') ? this.initWifiStatus() : '';
    } catch (error) {
      promptAction.showToast({
        message: 'wifi状态检测失败,错误码：' + error
      })
    }
  }

  timeLimits() {
    this.timerId = setTimeout(() => {
      if (this.isWiFiEnabled == WifiModel.isWiFiActive()) {
        this.timerId = -1;
        return;
      }
      this.isWiFiEnabled = WifiModel.isWiFiActive();
      this.timerId = -1;
      promptAction.showToast({
        message: this.errorMessage,
        duration: 1000,
      });
    }, 10000)
  }

  switchWiFiActiveStatus() {

    // delay the wifi status change event
    if (this.switchDebounceFlag) {
      clearTimeout(this.switchDebounceFlag);
    }

    if (this.timerId != -1) {
      clearTimeout(this.timerId);
    }
    this.switchDebounceFlag = setTimeout(() => {
      this.switchDebounceFlag = 0;
      this.timeLimits();
    }, 500);
  }

  private initWifiStatus() {
    this.GetWifiStatus()
    if (this.isWiFiEnabled) {
      WifiModel.refreshApScanResults();
    } else {
      AppStorage.setOrCreate('slConnectedWifi', (new ApScanResult()).renderToListModel());
    }
  }

  onPageShow() {
    this.GetWifiStatus()
    // 移植：检查是否有存储的 currentLink，并初始化
    console.log('wifiPro onPageShow=' + AppStorage.get('currentLink'))
    if (AppStorage.get('currentLink')) {
      this.currentLinkedWifi = AppStorage.get('currentLink') as ScanWifi;
      console.log('wifiPro onPageShow this.currentLinkedWifi=' + this.currentLinkedWifi)
    }
    console.log('wifiPro onPageShow end')
    // 从5.0.0移植的网络检测
    this.checkInternetAccess(false)
    // 进入页面关闭P2P
    this.setDiscoverableFalse()
    // 接管焦点通过onKeyEvent控制
    this.activateFocusStyle(false);
    WifiModel.registerWiFiConnectionObserver(() => {
      WifiModel.refreshApScanResults();
    });

    WifiModel.startScanTask();
    focusControl.requestFocus('switch');
    WifiModel.registerWiFiConnectionObserver(() => {
      WifiModel.getLinkedWifiInfo()
        .then((result) => {
          if (!result) {
            return;
          }
          if (result.ssid == this.userSelectedApInfo.ssid) {
            // 立即刷新列表
            WifiModel.refreshApScanResults();
            if (result.connState == 4) {
              AppStorage.setOrCreate('slConnectedWifi', new ApScanResult(this.userSelectedApInfo).renderToListModel());
            }
          }
        })
    })
    this.onNetRegister()

    // 初始化数据源
    this.initWifiStatus()
    setTimeout(() => {
      this.filterWifiList.setData(this.scanWiFiResults, this.slConnectedWifi);
    }, 100)
  }

  onPageHide() {
    // 页面离开打开P2P
    this.setDiscoverableTrue()
    this.activateFocusStyle(true);
    this.pageTranState = false
    if (!wifiManager.isConnected()) {
      WifiModel.unregisterWiFiConnectionObserver();
    }
    WifiModel.stopScanTask();
  }

  onBackPress() {
    setTimeout(()=>{
      router.back();
    },50)
    return true;
  }

  aboutToDisappear(): void {
    WifiModel.stopScanTask();
    this.isPageReady = false; // 离开页面时重置标志
    PreferencesUtil.setParam(getContext(), 'WIFI_STATE', 'WIFI_STATE', this.isWiFiEnabled ? '1' : '0');
  }

  isNeedRenderConnectedWiFi() {
    if (!this.isWiFiEnabled) {
      return false;
    }

    if (typeof this.slConnectedWifi.settingTitle === 'undefined') {
      return false;
    }
    // as the ConnectionStateChange event is diff with the getLinkInfo callback,
    // we always get the diff status between them
    let titleSign: string | boolean =
      (this.slConnectedWifi.settingTitle) && (this.slConnectedWifi.settingTitle.length > 0);
    let arrowSign: string | boolean =
      (this.slConnectedWifi.settingArrow) && (this.slConnectedWifi.settingArrow.length > 0);
    if (titleSign && arrowSign) {
      return true;
    }
    return false;
  }

  jumpToConnectApPage(apInfo: WifiScanInfo) {
    WifiModel.setUserSelectedAp(apInfo);
    // direct connect to wifi in security type 1(Open)
    if (apInfo.securityType === 1) {
      WifiModel.connectWiFi('', '');
      return;
    }
    let params: Params = {
      apInfo: apInfo,
      isConnected: false
    };
    router.pushUrl({
      url: 'pages/network/WifiPsd',
      params: params,
    }, router.RouterMode.Single);
  }
}

@Component
struct WiFiEntryComponent {
  @Prop settingTitle: string; // SSID
  @Prop settingArrow: string; // WiFi图标
  @Prop isFocus: boolean = false
  @State iFontColor: string = '#FFFFFF'
  @State iBackGroundColor: string = 'rgba(255, 255, 255, 0.2)'
  @State iLpx: string = lpx(846)

  build() {
    Row() {
      Column() {
        Text(this.settingTitle)
          .fontSize(lpx(36))
          .fontColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : '#FFFFFF')
          .fontWeight(FontWeight.Medium)
          .focusable(true)
      }
      .margin({ left: lpx(24) })
      .alignItems(HorizontalAlign.Start)

      Column() {
        Image(this.settingArrow)
          .width(lpx(68))
          .aspectRatio(1)
          .fillColor(this.isFocus ? 'rgba(0, 0, 0, 0.86)' : 'rgba(255, 255, 255, 0.86)')
      }
      .margin({ right: lpx(20) })
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
    }
    .width(this.isFocus ? lpx(846) : lpx(840))
    .backgroundColor(this.isFocus ? 'rgba(255, 255, 255, 0.86)' : 'rgba(255, 255, 255, 0.2)')
    .height(lpx(WIFI_ENTRY_COMPONENT_HEIGHT))
    .borderRadius(lpx(18))
    .justifyContent(FlexAlign.SpaceBetween)
  }
}

// 过滤已连接WiFi数据源
class FilteredWiFiDataSource extends BasicDataSource {
  private originalData: ScanWifi[] = [];
  private filteredData: ScanWifi[] = [];
  private connectedWifiBssid: string = '';

  setData(newData: ScanWifi[], connectedWifi: ScanWifi): void {
    this.originalData = newData || [];
    this.connectedWifiBssid = connectedWifi?.apInfo?.bssid || '';
    this.applyFilters();
    LogUtil.info(`FilteredWiFiDataSource: ${this.originalData.length} -> ${this.filteredData.length} items`);
    this.notifyDataReload();
  }

  private applyFilters(): void {
    this.filteredData = this.originalData.filter((item: ScanWifi) => {
      // 排除已连接的WiFi
      if (this.connectedWifiBssid && item.apInfo.bssid === this.connectedWifiBssid) {
        LogUtil.info(`FilteredWiFiDataSource: Filtered connected WiFi - ${item.settingTitle}`);
        return false;
      }
      if (!item.settingTitle || item.settingTitle.trim().length === 0) {
        return false;
      }
      return true;
    });
    this.filteredData.sort((a, b) => b.apInfo.rssi - a.apInfo.rssi);
  }

  updateConnectedWifi(connectedWifi: ScanWifi): void {
    const newBssid = connectedWifi?.apInfo?.bssid || '';
    if (this.connectedWifiBssid !== newBssid) {
      LogUtil.info(`FilteredWiFiDataSource: Connected WiFi changed to ${newBssid}`);
      this.connectedWifiBssid = newBssid;
      this.applyFilters();
      this.notifyDataReload();
    }
  }

  public totalCount(): number {
    return this.filteredData ? this.filteredData.length : 0;
  }

  public getData(index: number): ScanWifi {
    if (!this.filteredData || index < 0 || index >= this.totalCount()) {
      return {
        settingIcon: '',
        settingSummary: 0,
        settingTitle: '',
        settingValue: '',
        settingArrow: '',
        settingArrowStyle: '',
        settingUri: '',
        apInfo: {
          ssid: '',
          bssid: '',
          rssi: -100,
          band: 0,
          frequency: 0,
          timestamp: 0,
          securityType: 1,
        }
      } as ScanWifi;
    }
    return this.filteredData[index];
  }
}
