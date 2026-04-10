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

import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import lpx from '../../common/Lpx';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import router from '@ohos.router';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { Duration } from '../../common/constants/Duration';
import { settings } from '@kit.BasicServicesKit';
import deviceInfo from '@ohos.deviceInfo';
import usbSetting from '@ohos.tvservice.usbSetting';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';

import remoteControl from '@ohos.multimodalInput.remoteControl';
import { inputDevice } from '@kit.InputKit';
import aboutDeviceModel from '../../model/aboutDeviceImpl/AboutDeviceModel';
import { WatchTvKeyModel } from '../../model/general/WatchTvKeyModel';
import displaySetting from '@ohos.tvservice.displaySetting';


const AUTO_SCREEN_OFF_TITLE: string = '自动熄屏';
const AUTO_SCREEN_OFF_URL: string = 'pages/general/AutoScreenOff';
const TRUE = '1'
const FALSE = '0'
const FUNUI_SWITCH = 'settings.funui.enable'
const TAG = 'General'
const DEVICEINFO = 'GK6320'

interface UsbPortInfo {
  name: string;
  status: boolean;
  visibility: boolean;
}

const VENDOR = 0x000d
const PRODUCT = 0x3840

@Entry
@Component
struct General {
  @State imageUrl: string = Ratio.resName('general_pics')
  @State des: string | Resource = ''
  @State settingList: SettingItemTvModel[] = []
  @State isHaiBaoOn: string = FALSE
  @State isConnController: boolean = true //当前是否连接遥控器
  @State isPoint: boolean = false //是否是指向遥控器
  @State connVal: number = -1 //遥控器连接状态枚举
  @State isReport: boolean = false //指向遥控器接收器是否插入
  @State deviceId: number[] = []; //接收器id
  @State controllerBatteryLevel: number = 50 //当前电量
  @State isOpenUwb: boolean = false;
  @State isCharge: boolean = false;
  private deviceName: string = ''
  private pageTranState: boolean = false; //判断是进场动效还是出场动效

  onPageHide(): void {
    this.pageTranState = false
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
  
  /**
   * 注册指向遥控器监听
   */
  onControllerListener() {
    console.log(TAG, '注册指向遥控器监听事件');
    remoteControl.on('RemoteControlChange', (data: remoteControl.RemoteControlListener) => {
      if (data.type === 'ConnectStatusChange') {
        if (data.changeVal === 1) { //配对已连接
          this.connVal = data.changeVal
          this.isPoint = true
          this.settingList[0].chooseDes = this.controllerBatteryLevel + '%';
        } else if (data.changeVal === 0) { //未配对
          this.connVal = data.changeVal
          this.isPoint = false
          this.settingList[0].chooseDes = '';
        } else { //配对未连接
          this.connVal = data.changeVal
          this.isPoint = false
          this.settingList[0].chooseDes = '';
        }
        AppStorage.setOrCreate('isConPoint', this.isPoint)
        AppStorage.setOrCreate('connVal', this.connVal)
        console.log(TAG, '指向遥控器监听事件--连接状态' + JSON.stringify(data.changeVal));
      } else if (data.type === 'ChargeStatusChange') {
        if (data.changeVal === 0) {
          this.isCharge = false
        } else {
          this.isCharge = true
        }
        AppStorage.setOrCreate('isCharge', this.isCharge);
      } else if (data.type === 'ReceiverStatusChange') {
        if (data.changeVal === 0) {
          console.log(TAG, `遥控器接收器拔出`);
          this.isReport = false;
          this.isPoint = false;
          this.settingList[0].chooseDes = '';
          AppStorage.setOrCreate('isConPoint', this.isPoint)
        } else {
          console.log(TAG, `遥控器接收器插入`);
          this.isReport = true;
        }
        AppStorage.setOrCreate('isReport', this.isReport)
      } else if (data.type === 'BatteryValueChange') {
        this.controllerBatteryLevel = data.changeVal;
        AppStorage.setOrCreate('BatteryLevel', this.controllerBatteryLevel)
        console.log(TAG, `遥控器接电量：` + this.controllerBatteryLevel);
      }
    })
  }

  /**
   * 注销指向遥控器监听
   */
  offControllerListener() {
    remoteControl.off('RemoteControlChange')
    console.log(TAG, '注销指向遥控器监听事件');
  }

  /**
   * 判断当前是否连接指向遥控器
   */
  isConnectRemoteController() {
    try {
      let remoteControllerInfo: remoteControl.PairingStatus = remoteControl.getRemoteControlConnectStatusSync()
      if (remoteControllerInfo === 1) {
        this.isPoint = true
        console.log(TAG, '当前指向遥控器已经连接')
        this.getRemoteControllerBattery()
        this.getRemoteControllerChargeStatus()
      } else {
        this.isPoint = false
        console.log(TAG, '当前指向遥控器未连接')
      }
      AppStorage.setOrCreate('isConPoint', this.isPoint)
    } catch (err) {
      console.log(TAG, 'getRemoteControlConnectStatusSync err:' + err)
    }
  }

  /**
   * 查询指向遥控器的电量
   */
  getRemoteControllerBattery() {
    let battery = remoteControl.getRemoteControlBatteryValueSync();
    this.controllerBatteryLevel = battery;
    AppStorage.setOrCreate('BatteryLevel', this.controllerBatteryLevel)
    console.log(TAG, 'general页面遥控器的电量为：' + battery);
  }

  /**
   * 获取指向遥控器充电状态
   */
  getRemoteControllerChargeStatus() {
    let chargeStatus = remoteControl.getRemoteControlChargeStatusSync();
    if (chargeStatus == 0) {
      this.isCharge = false;
    } else {
      this.isCharge = true;
    }
    AppStorage.setOrCreate('isCharge', this.isCharge);
  }


  getDeviceName() {
    let deviceName =
      settings.getValueSync(getContext(), settings.general.DEVICE_NAME, '', settings.domainName.DEVICE_SHARED)
    if (deviceName !== '') {
      this.deviceName = deviceName.slice(0, 6).toUpperCase()
    } else {
      this.deviceName = aboutDeviceModel.getDeviceName().slice(0, 6).toUpperCase()
    }
  }

  async aboutToAppear() {
    this.getDeviceName()
console.log('===111',Date.now())
    this.isHaiBaoOn = settings.getValueSync(getContext(this), FUNUI_SWITCH, FALSE, settings.domainName.DEVICE_SHARED)

    if (this.deviceName != DEVICEINFO) { //6320不支持遥控器和输入源
      let item0 = new SettingItemTvModel();
      item0.name = '遥控器';
      item0.pageUrl = 'pages/general/RemoteController'
      item0.imageUrl = Ratio.resName('icon_remoteController')
      item0.description = '遥控器设置'
      item0.chooseDes = this.isPoint ? this.controllerBatteryLevel + '%' : ''
      item0.style = SettingItemStyle.default
      this.settingList.push(item0);
    }

    let item3 = new SettingItemTvModel();
    item3.name = AUTO_SCREEN_OFF_TITLE;
    item3.pageUrl = AUTO_SCREEN_OFF_URL
    item3.imageUrl = Ratio.resName('auto_screenoff_title')
    item3.description = AUTO_SCREEN_OFF_TITLE
    item3.style = SettingItemStyle.default
    this.settingList.push(item3);

    let item = new SettingItemTvModel();
    item.name = 'HDMI设置';
    item.pageUrl = 'pages/general/Hdmi'
    item.imageUrl = Ratio.resName('icon_inputsource')
    item.description = 'HDMI设置'
    item.style = SettingItemStyle.default
    this.settingList.push(item);

    if (this.deviceName != DEVICEINFO) { //6320不支持遥控器和输入源
      let item1 = new SettingItemTvModel();
      item1.name = '输入源设置';
      item1.pageUrl = 'pages/general/InputSource'
      item1.imageUrl = Ratio.resName('icon_inputsource')
      item1.description = '输入源设置'
      item1.style = SettingItemStyle.default
      this.settingList.push(item1);
    }

    let item2 = new SettingItemTvModel();
    item2.name = '输入法设置';
    item2.pageUrl = 'pages/general/Ime'
    item2.imageUrl = Ratio.resName('icon_general')
    item2.description = '输入法设置'
    item2.style = SettingItemStyle.default
    this.settingList.push(item2);


    let item5 = new SettingItemTvModel();
    item5.name = '悬浮球设置';
    item5.pageUrl = 'pages/general/FloatBall'
    item5.imageUrl = Ratio.resName('float_ball')
    item5.description = '悬浮球设置'
    item5.style = SettingItemStyle.default
    this.settingList.push(item5);


    let isSourceListEmpty:boolean = await WatchTvKeyModel.isSourceListEmpty()
    if(WatchTvKeyModel.isSupport3ModeRemote() && !isSourceListEmpty) {
      let watchTvKeyItem = new SettingItemTvModel();
      watchTvKeyItem.name = getContext().resourceManager.getStringSync($r('app.string.watch_tv_key_title').id)
      watchTvKeyItem.pageUrl = 'pages/general/WatchTvKeyPage'
      watchTvKeyItem.imageUrl = Ratio.resName('icon_inputsource')
      watchTvKeyItem.description = $r('app.string.watch_tv_key_description')
      watchTvKeyItem.style = SettingItemStyle.default
      this.settingList.push(watchTvKeyItem);
    }


    let item8 = new SettingItemTvModel();
    item8.name = '屏幕旋转';
    item8.pageUrl = 'pages/general/ScreenRotation'
    item8.imageUrl = 'app.media.icon_screen_rotation'
    item8.style = SettingItemStyle.default
    item8.description = '屏幕旋转'
    this.settingList.push(item8);

    let item9 = new SettingItemTvModel();
    item9.name = '开机模式';
    item9.pageUrl = 'pages/general/StartupMode'
    item9.imageUrl = 'app.media.startup_mode'
    item9.style = SettingItemStyle.default
    item9.description = '开机模式'
    this.settingList.push(item9);

    let item10 = new SettingItemTvModel();
    item10.name = '待机模式';
    item10.pageUrl = 'pages/general/StandbyMode'
    item10.imageUrl = 'app.media.standby_mode'
    item10.style = SettingItemStyle.default
    item10.description = '待机模式'
    this.settingList.push(item10);

    let item11 = new SettingItemTvModel();
    item11.name = '待机';
    item11.pageUrl = 'pages/general/Standby'
    item11.imageUrl = 'app.media.standby'
    item11.style = SettingItemStyle.default
    item11.description = '待机'
    this.settingList.push(item11);

    if (deviceInfo.productModel == 'Hi3751V352') {
      let item4 = new SettingItemTvModel();
      item4.name = '风行海报开关';
      item4.isOn = this.isHaiBaoOn == TRUE
      item4.description = '风行海报开关'
      item4.style = SettingItemStyle.switch
      this.settingList.push(item4);
    }
    if (this.deviceName !== DEVICEINFO) { //6320不支持遥控器和输入源
      try {
        this.onControllerListener()
      } catch (err) {
        console.log(TAG, 'onControllerListener err:' + JSON.stringify(err))
      }
    }

  }

  async onPageShow(): Promise<void> {
    const USB_PORT_NAMES = ['USB1', 'USB2', 'USB3', 'USB4'];
    const MAX_USB_PORTS = 4;
    const statusResults: boolean[] = new Array(MAX_USB_PORTS).fill(false);
    const visibilityResults: boolean[] = new Array(MAX_USB_PORTS).fill(false);
    const usbPortList: UsbPortInfo[] = [];
    try {
      const supportedUsbList: number[] = await usbSetting.GetSupportUsbList();
      LogUtil.log(`${TAG} usbSetting GetSupportUsbList Success: ${JSON.stringify(supportedUsbList)}`);
      const keepThese = [0, 1, 2, 3];
      const filteredArray = supportedUsbList.filter(item => keepThese.includes(item));
      LogUtil.log(`${TAG} usbSetting GetSupportUsbList1 Success: ${JSON.stringify(filteredArray)}`);

      if (filteredArray.length <= 0) {
        // 无任何USB开关
        LogUtil.log(`${TAG} usbSetting No USB ports supported`);
        AppStorage.setOrCreate('GetSupportUsbList', []);
      } else {
        // 并行检查所有支持的USB端口状态
        const checkPromises = filteredArray.map(async (portId: number) => {
          if (portId >= 0 && portId < MAX_USB_PORTS) {
            try {
              const status: boolean = await usbSetting.IsUsbEnable(portId);
              LogUtil.log(`${TAG} usbSetting USB${portId} status: ${status}`);
              statusResults[portId] = status;
              visibilityResults[portId] = true;
            } catch (error) {
              LogUtil.log(`${TAG} usbSetting USB${portId} check failed: ${JSON.stringify(error)}`);
              statusResults[portId] = false;
              visibilityResults[portId] = true;
            }
          }
        });
        await Promise.all(checkPromises);
      }
      // 构建USB端口信息列表
      for (let i = 0; i < MAX_USB_PORTS; i++) {
        const isSupported = filteredArray.includes(i);
        usbPortList.push({
          name: USB_PORT_NAMES[i],
          status: isSupported ? statusResults[i] : false,
          visibility: isSupported ? visibilityResults[i] : false
        });
      }
      const visibleUsbPortList = usbPortList.filter(port => port.visibility);
      console.log(JSON.stringify(visibleUsbPortList), 'usbSetting visibleUsbPortList aboutToAppear')
      AppStorage.setOrCreate('GetSupportUsbList', visibleUsbPortList);
    } catch (error) {
      LogUtil.log(`${TAG} usbSetting GetSupportUsbList failed: ${JSON.stringify(error)}`);
      AppStorage.setOrCreate('GetSupportUsbList', []);
    }
    const powerMode= await displaySetting.getPowerOnMode()
    AppStorage.setOrCreate<number>('startupMode',powerMode)
    //遥控器状态更新耗时较长移到这里
    if (this.deviceName != DEVICEINFO) {
      setTimeout(()=> {//宏任务
        this.isConnectRemoteController()
        let item0 = this.settingList[0]
        this.settingList[0].chooseDes = this.isPoint ? this.controllerBatteryLevel + '%' : ''
      }, 1)
    }

  }

  aboutToDisappear(): void {
    if (this.deviceName !== DEVICEINFO) {
      try {
        this.offControllerListener()
      } catch (err) {
        console.log(TAG, 'offControllerListener err:' + JSON.stringify(err))
      }
    }
  }

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        SettingListTvComponent({
          settingList: this.settingList,
          title: '通用',
          onMouseClickHandle: (item: SettingItemTvModel) => {
              router.pushUrl({
                url: item.pageUrl
              }, router.RouterMode.Single)
              this.pageTranState = true
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            this.imageUrl = item.imageUrl;
            this.des = item.description;
          },
          onToggleChangedHandle: (item: SettingItemTvModel, isOn: boolean) => {
            if (item.isOn) {
              settings.setValueSync(getContext(), FUNUI_SWITCH, TRUE,
                settings.domainName.DEVICE_SHARED)
            } else {
              settings.setValueSync(getContext(), FUNUI_SWITCH, FALSE,
                settings.domainName.DEVICE_SHARED)
            }
          }
        })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
          .margin({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)

  }
}

