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
import { KeyCode } from '../../common/constants/KeyCode';
import lpx from '../../common/Lpx';
import { Ratio } from '../../common/Ratio';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { SettingItemDesLayout } from '../../default/layout/SettingItemDesLayout';
import displaySetting from '@ohos.tvservice.displaySetting';
import audioSetting from '@ohos.tvservice.audioSetting';
import hdmitxSetting from '@ohos.tvservice.hdmitxSetting';
import { Duration } from '../../common/constants/Duration';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import promptAction from '@ohos.promptAction';
import { router } from '@kit.ArkUI';
import usbSetting from '@ohos.tvservice.usbSetting';

const TAG = 'Hdmi'
interface statusResults {
  setCecStatusboolean0: boolean,
  setCecStatusboolean1: boolean,
  setCecStatusboolean2: boolean,
  setCecStatusboolean3: boolean,
  setCecStatusboolean4: boolean,
  setCecStatusboolean5: boolean,
}

interface UsbPortInfo {
  name: string;
  status: boolean;
  visibility: boolean;
}

@Entry
@Component
struct Hdmi {
  private pageTranState: boolean = false; //判断是进场动效还是出场动效
  @State imageUrl: string = Ratio.resName('icon_inputsource')
  @State des: string | Resource = ''
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  @State isHDMICEC: boolean = false;
  @State cecValue: string = '关闭'
  @State cecIndex: number = 0;
  @State isHDMIHDCP: boolean = false;
  @State hdcpValue: string = '自动'
  @State hdcpIndex: number = 0;
  @State getCecStatusboolean0: boolean = false;
  @State getCecStatusboolean1: boolean = false;
  @State getCecStatusboolean2: boolean = false;
  @State getCecStatusboolean3: boolean = false;
  @State getCecStatusboolean4: boolean = false;
  @State getCecStatusboolean5: boolean = false;
  @State setCecStatusboolean0: boolean = false;
  @State setCecStatusboolean1: boolean = false;
  @State setCecStatusboolean2: boolean = false;
  @State setCecStatusboolean3: boolean = false;
  @State setCecStatusboolean4: boolean = false;
  @State setCecStatusboolean5: boolean = false;

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


  async aboutToAppear() {
    let item2 = new SettingItemTvModel();
    item2.name = 'HDMI CEC';
    item2.value = this.cecValue
    item2.style = SettingItemStyle.valueChange;
    item2.description='HDMI CEC'

    let item6 = new SettingItemTvModel();
    item6.name = 'HDMI输出';
    item6.pageUrl = 'pages/general/HDMIOUT'
    item6.style = SettingItemStyle.default;
    item6.description='HDMI输出'

    let item7 = new SettingItemTvModel();
    item7.name = 'HDMI输入';
    item7.pageUrl = 'pages/general/HDMIIN'
    item7.style = SettingItemStyle.default;
    item7.description='HDMI输入'

    this.settingList.push(item2,item6,item7);
  }

  onPageShow(): void {
    this.getCEC();
    this.getHDMIIN();
    this.getHDMIOUT();
  }

  async getHDMIIN(){
    const USB_PORT_NAMES = ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4'];
    const MAX_USB_PORTS = 4;
    const statusResults: boolean[] = new Array(MAX_USB_PORTS).fill(false);
    const visibilityResults: boolean[] = new Array(MAX_USB_PORTS).fill(false);
    const usbPortList: UsbPortInfo[] = [];
    try {
      const supportedUsbList: number[] = await displaySetting.GetSupportSourceList();
      LogUtil.log(`${TAG} displaySetting GetSupportHDMIINList Success: ${JSON.stringify(supportedUsbList)}`);
      const keepThese = [1, 2, 3, 4];
      const filteredArray = supportedUsbList.filter(item => keepThese.includes(item));
      LogUtil.log(`${TAG} displaySetting GetSupportHDMIINList Success: ${JSON.stringify(filteredArray)}`);
      if (filteredArray.length <= 0) {
        // 无任何HDMI输入开关
        LogUtil.log(`${TAG} displaySetting No HDMI输入 ports supported`);
        AppStorage.setOrCreate('GetSupportHDMIINList', []);
      } else {
        // 并行检查所有支持的USB端口状态
        const checkPromises = filteredArray.map(async (portId: number) => {
          if (portId >= 1 && portId <= MAX_USB_PORTS) {
            try {
              const status: boolean = await displaySetting.IsHDMIRXEnable(portId);
              LogUtil.log(`${TAG} displaySetting HDMI输入 IsHDMIRXEnable${portId} status: ${status}`);
              statusResults[portId-1] = status;
              visibilityResults[portId-1] = true;
            } catch (error) {
              LogUtil.log(`${TAG} displaySetting HDMI输入 ${portId} check failed: ${JSON.stringify(error)}`);
              statusResults[portId-1] = false;
              visibilityResults[portId-1] = true;
            }
          }
        });
        await Promise.all(checkPromises);
      }
      // 构建USB端口信息列表
      for (let i = 1; i <= MAX_USB_PORTS; i++) {
        const isSupported = filteredArray.includes(i);
        usbPortList.push({
          name: USB_PORT_NAMES[i-1],
          status: isSupported ? statusResults[i-1] : false,
          visibility: isSupported ? visibilityResults[i-1] : false
        });
      }
      const visibleUsbPortList = usbPortList.filter(port => port.visibility);
      console.log(JSON.stringify(visibleUsbPortList),'displaySetting visibleUsbPortList aboutToAppear')
      AppStorage.setOrCreate('GetSupportHDMIINList', visibleUsbPortList);
    } catch (error) {
      LogUtil.log(`${TAG} displaySetting.GetSupportSourceList failed: ${JSON.stringify(error)}`);
      AppStorage.setOrCreate('GetSupportHDMIINList', []);
    }
  }

  async getHDMIOUT(){
    const USB_PORT_NAMES = ['HDMI1', 'HDMI2', 'HDMI3', 'HDMI4'];
    const MAX_USB_PORTS = 4;
    const statusResults: boolean[] = new Array(MAX_USB_PORTS).fill(false);
    const visibilityResults: boolean[] = new Array(MAX_USB_PORTS).fill(false);
    const usbPortList: UsbPortInfo[] = [];
    try {
      const supportedUsbList: number[] = await hdmitxSetting.GetSupportHdmitxList();
      const keepThese = [0, 1, 2, 3];
      const filteredArray = supportedUsbList.filter(item => keepThese.includes(item));
      LogUtil.log(`${TAG} hdmitxSetting.GetSupportHdmitxList Success: ${JSON.stringify(filteredArray)}`);

      if (filteredArray.length <= 0) {
        // 无任何HDMI输出开关
        LogUtil.log(`${TAG} hdmitxSetting No HDMI输出 ports supported`);
        AppStorage.setOrCreate('GetSupportHDMIOUTList', []);
      } else {
        // 并行检查所有支持的USB端口状态
        const checkPromises = filteredArray.map(async (portId: number) => {
          if (portId >= 0 && portId < MAX_USB_PORTS) {
            try {
              const status: boolean = await hdmitxSetting.IsHDMITXEnable(portId);
              LogUtil.log(`${TAG} hdmitxSetting HDMI输出${portId} status: ${status}`);
              statusResults[portId] = status;
              visibilityResults[portId] = true;
            } catch (error) {
              LogUtil.log(`${TAG} hdmitxSetting HDMI输出${portId} check failed: ${JSON.stringify(error)}`);
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
      console.log(JSON.stringify(visibleUsbPortList),'hdmitxSetting HDMI输出 aboutToAppear')
      AppStorage.setOrCreate('GetSupportHDMIOUTList', visibleUsbPortList);
    } catch (error) {
      LogUtil.log(`${TAG} hdmitxSetting HDMI输出 failed: ${JSON.stringify(error)}`);
      AppStorage.setOrCreate('GetSupportHDMIOUTList', []);
    }
  }

  async getCEC() {
    // 定义参数范围（0-5）
    const params = [0, 1, 2, 3, 4, 5];
    // 临时存储每个参数的结果（避免动态访问this属性）
    const statusResults: Record<number, boolean> = {
      0: false,
      1: false,
      2: false,
      3: false,
      4: false,
      5: false
    };
    // 提取通用逻辑：获取单个参数的CEC状态并更新结果
    const getSingleCecStatus = async (param: number) => {
      try {
        const status: boolean = await audioSetting.getCecStatus(param);
        LogUtil.log(`${TAG}avgetCecStatusSuccess${param}=${JSON.stringify(status)}`);
        return status; // 返回获取到的状态（boolean）
      } catch (error) {
        LogUtil.log(`${TAG}avgetCecStatus${param}=${JSON.stringify(error)}`);
        return false; // 异常时返回false
      }
    };
    // 循环处理所有参数，并行或串行执行（根据需求选择）
    for (const param of params) {
      statusResults[param] = await getSingleCecStatus(param);
    }
    // 批量更新this属性（避免动态索引，显式赋值符合ArkTS规范）
    this.getCecStatusboolean0 = statusResults[0];
    this.getCecStatusboolean1 = statusResults[1];
    this.getCecStatusboolean2 = statusResults[2];
    this.getCecStatusboolean3 = statusResults[3];
    this.getCecStatusboolean4 = statusResults[4];
    this.getCecStatusboolean5 = statusResults[5];
    // 判断所有状态是否为true，更新UI
    const allEnabled = Object.values(statusResults).every(status => status);
    LogUtil.log(`${TAG}if----else`);
    LogUtil.log(TAG + 'getallEnabled==' + allEnabled);
      this.cecValue = allEnabled ? '开启' : '关闭';
    this.settingList[0].setValue(this.cecValue);
  }

  async setAllCecStatus() {
    const enable = this.cecValue === '关闭' ? false : true;
    LogUtil.log(TAG + 'enablevaule==' + enable);
    const maxMenuId = 5;
    // 存储每个菜单ID的状态结果
    const statusResults: statusResults = {
      setCecStatusboolean0: false,
      setCecStatusboolean1: false,
      setCecStatusboolean2: false,
      setCecStatusboolean3: false,
      setCecStatusboolean4: false,
      setCecStatusboolean5: false
    };
    // 依次设置每个菜单的CEC状态
    for (let i = 0; i <= maxMenuId; i++) {
      try {
        const setCecStatus: boolean = await audioSetting.setCecStatus({
          cecUiMenu: i,
          enable
        });
        LogUtil.log(TAG + `avsetCecStatus= SuccessBoolean${i}==:` + JSON.stringify(setCecStatus));
        // 更新状态对象
        switch (i) {
          case 0:
            statusResults.setCecStatusboolean0 = setCecStatus;
            break;
          case 1:
            statusResults.setCecStatusboolean1 = setCecStatus;
            break;
          case 2:
            statusResults.setCecStatusboolean2 = setCecStatus;
            break;
          case 3:
            statusResults.setCecStatusboolean3 = setCecStatus;
            break;
          case 4:
            statusResults.setCecStatusboolean4 = setCecStatus;
            break;
          case 5:
            statusResults.setCecStatusboolean5 = setCecStatus;
            break;
        }
      } catch (error) {
        LogUtil.log(TAG + `avsetCecStatus${i}=` + JSON.stringify(error));
        // 更新状态对象
        switch (i) {
          case 0:
            statusResults.setCecStatusboolean0 = false;
            break;
          case 1:
            statusResults.setCecStatusboolean1 = false;
            break;
          case 2:
            statusResults.setCecStatusboolean2 = false;
            break;
          case 3:
            statusResults.setCecStatusboolean3 = false;
            break;
          case 4:
            statusResults.setCecStatusboolean4 = false;
            break;
          case 5:
            statusResults.setCecStatusboolean5 = false;
            break;
        }
      }
    }

    // 将结果应用到this对象
    this.setCecStatusboolean0 = statusResults.setCecStatusboolean0;
    this.setCecStatusboolean1 = statusResults.setCecStatusboolean1;
    this.setCecStatusboolean2 = statusResults.setCecStatusboolean2;
    this.setCecStatusboolean3 = statusResults.setCecStatusboolean3;
    this.setCecStatusboolean4 = statusResults.setCecStatusboolean4;
    this.setCecStatusboolean5 = statusResults.setCecStatusboolean5;
    // 检查所有结果
    const allSuccess =
      statusResults.setCecStatusboolean0 &&
      statusResults.setCecStatusboolean1 &&
      statusResults.setCecStatusboolean2 &&
      statusResults.setCecStatusboolean3 &&
      statusResults.setCecStatusboolean4 &&
      statusResults.setCecStatusboolean5;
    LogUtil.log(TAG + 'if----else');
    LogUtil.log(TAG + 'allSuccess==' + allSuccess);
    if (!allSuccess) {
      promptAction.showToast({ message: '设置HDMI CEC失败' });
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
          title: 'HDMI设置',
          onValueChangeLeftHandle:(item: SettingItemTvModel)=>{
            if (item.name === 'HDMI CEC') {
              let origins: string[] = ['关闭', '开启']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  this.cecIndex = index
                }
              })
              if (this.cecIndex > 0) {
                this.cecIndex--;
              } else {
                this.cecIndex = 1;
              }
              this.cecValue = origins[this.cecIndex];
              item.setValue(this.cecValue);
              this.setAllCecStatus();
            }
          },
          onValueChangeRightHandle:(item: SettingItemTvModel)=>{
            if (item.name === 'HDMI CEC') {
              let origins: string[] = ['关闭', '开启']
              origins.forEach((originItem, index) => {
                if (item.value === originItem) {
                  this.cecIndex = index
                }
              })
              if (this.cecIndex < 1) {
                this.cecIndex++;
              } else {
                this.cecIndex = 0;
              }
              this.cecValue = origins[this.cecIndex];
              item.setValue(this.cecValue);
              this.setAllCecStatus();
            }
          },
          onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.type === 1) {
              if (event.keyCode === KeyCode.KEY_DPAD_RIGHT || event.keyCode === KeyCode.KEY_DPAD_LEFT) {
                if (item.name === 'HDMI CEC') {
                  let origins: string[] = ['关闭', '开启']
                  origins.forEach((originItem, index) => {
                    if (item.value === originItem) {
                      this.cecIndex = index
                    }
                  })
                  if (event.keyCode == KeyCode.KEY_DPAD_LEFT) {
                    if (this.cecIndex > 0) {
                      this.cecIndex--;
                    } else {
                      this.cecIndex = 1;
                    }
                  }
                  if (event.keyCode == KeyCode.KEY_DPAD_RIGHT) {
                    if (this.cecIndex < 1) {
                      this.cecIndex++;
                    } else {
                      this.cecIndex = 0;
                    }
                  }
                  this.cecValue = origins[this.cecIndex];
                  item.setValue(this.cecValue);
                  this.setAllCecStatus();
                }
              }
            }
          },
          onMouseClickHandle:(item: SettingItemTvModel)=>{
            if(item.name=='HDMI输出'|| item.name=='HDMI输入'){
              router.pushUrl({
                url: item.pageUrl
              }, router.RouterMode.Single)
              this.pageTranState = true
            }
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            this.imageUrl = item.imageUrl;
            this.des = item.description;
          },
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
