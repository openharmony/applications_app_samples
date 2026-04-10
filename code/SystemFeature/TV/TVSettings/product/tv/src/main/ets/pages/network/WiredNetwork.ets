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

import { SettingBackground } from '../../default/layout/SettingBackground';
import router from '@ohos.router';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import { KeyCode } from '../../common/constants/KeyCode';
import { Ratio } from '../../common/Ratio';

import ethernet from '@ohos.net.ethernet';
import promptAction from '@ohos.promptAction';
import Ipv4Model from '../../model/manualNetworkImpl/Ipv4Model';
import gatewayModel from '../../model/manualNetworkImpl/GatewayModel';
import netMaskModel from '../../model/manualNetworkImpl/NetmaskModel';
import dnsModel from '../../model/manualNetworkImpl/DnsModel';
import netTypeModel from '../../model/manualNetworkImpl/NetTypeModel';
import { inputEventClient } from '@kit.InputKit';
import { Duration } from '../../common/constants/Duration';
import wifiManager from '@ohos.wifiManager';
import WifiModel, { IPConvertor } from '../../model/wifiImpl/WifiModel';
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG = 'WiredNetwork ';
const IPV4_ADDRESS: string = getContext(this).resourceManager.getStringByNameSync('IPV4Address')

class InjectedKeyEventPayload {
}

@Entry
@Component
struct wiredNetwork {
  @State imageUrl: string = Ratio.resName('icon_wirednetwork')
  @State des: string = '有线网络连接'
  @State settingList: SettingItemTvModel[] = []
  @State focusIndex: number = -1
  @State curActiveIFace: string = ''
  @State curActiveIFaceConfig: ethernet.InterfaceConfiguration = {
    ipAddr: '',
    netMask: '',
    dnsServers: '',
    gateway: '',
    route: '',
    mode: 1
  }
  @StorageLink('ipStr') ipStr: string = '';
  @StorageLink('maskStr') maskStr: string = '';
  @StorageLink('gatewayStr') gatewayStr: string = '';
  @StorageLink('dnsStr') @Watch('onDNSStrChange') dnsStr: string = '';
  @State netTypeName: string = '自动';
  @State netTypeNameIndex: number = 0
  private routeStr: string = '0.0.0.0';
  private domain: string = '';
  private ipType: string = 'IPV4';
  private netCon: connection.NetConnection = connection.createNetConnection();

  pageTransition() {
    PageTransitionEnter({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
    PageTransitionExit({ type: RouteType.None, duration: Duration.pageTransition_duration, curve: Curve.Ease })
      .slide(SlideEffect.Right)
  }

  aboutToAppear() {
    this.tabClick()
    this.getCurActiveIFaceConfig();
    this.initAppList();
    getContext(this).eventHub.on('updateIpRecord', () => {
      this.setManualFaceConfig();
    })
  }
onPageShow(): void {
  this.onNetRegister()
}
  aboutToDisappear(): void {
    getContext(this).eventHub.off('updateIpRecord')
    this.offNetRegister()
  }

  /**
   * 初始化列表
   */
  initAppList() {
    this.settingList = [];

    this.netTypeName = netTypeModel.getNetMask();

    let item1 = new SettingItemTvModel();
    item1.name = '配置网络';
    item1.value = this.netTypeName;
    item1.focusKeys = ['WIRED_CONFIG_FOCUS_1']
    item1.isSetFocusKey = true
    item1.style = SettingItemStyle.valueChange;

    let item2 = new SettingItemTvModel();
    item2.name = 'IP类型';
    item2.value = this.ipType;
    item2.focusKeys = ['WIRED_CONFIG_FOCUS_2']
    item2.isSetFocusKey = true
    item2.style = SettingItemStyle.valueChange;

    let item3 = new SettingItemTvModel();
    item3.name = IPV4_ADDRESS;
    item3.isDisableFocus = item1.value === '自动';
    item3.isEnable = !(item1.value === '自动');
    item3.chooseDes = this.ipStr;
    this.processStringip(this.ipStr).then(res => {
      item3.setChooseDes(res)
    });
    item3.pageUrl = 'pages/network/IpUpdate';
    item3.style = (item1.value === '自动') ? SettingItemStyle.info : SettingItemStyle.default;

    let item4 = new SettingItemTvModel();
    item4.name = '子网掩码';
    item4.isEnable = !(item1.value === '自动');
    item4.isDisableFocus = item1.value === '自动';
    item4.chooseDes = this.processStringmaskStr(this.maskStr);
    item4.pageUrl = 'pages/network/NetMaskUpdate';
    item4.style = (item1.value === '自动') ? SettingItemStyle.info : SettingItemStyle.default;

    let item5 = new SettingItemTvModel();
    item5.name = '默认网关';
    item5.isEnable = !(item1.value === '自动');
    item5.isDisableFocus = item1.value === '自动';
    item5.chooseDes = this.processString(this.gatewayStr);
    item5.pageUrl = 'pages/network/GatewayUpdate';
    item5.style = (item1.value === '自动') ? SettingItemStyle.info : SettingItemStyle.default;

    let item6 = new SettingItemTvModel();
    item6.name = 'DNS服务器';
    item6.isEnable = !(item1.value === '自动');
    item6.isDisableFocus = item1.value === '自动';
    item6.chooseDes = this.dnsStr.split(',', 1).toString();
    item6.pageUrl = 'pages/network/DnsUpdate';
    item6.style = (item1.value === '自动') ? SettingItemStyle.info : SettingItemStyle.default;

    this.settingList.push(item1, item3, item4, item5, item6);
  }

  processString(ipAddress: string) {
    LogUtil.info(TAG + ' processString ipAddress ==> ' + ipAddress);
    if (ipAddress.includes(',')) {
      const parts = ipAddress.split(',');
      const filtered = parts.filter(part =>!part.includes(':'));
      if (filtered.length > 0) {
        if (!this.ipStr) {
          //空值
          return ''
        } else {
          return filtered.join(',')
        }
      } else {
        return ''
      }
    } else {
      if (ipAddress.includes(':')) {
        return ''
      } else {
        if (!this.ipStr) {
          //空值
          return ''
        } else {
          return ipAddress
        }
      }
    }
  }

  //ipv4地址
  async processStringip(ipAddress: string): Promise<string> {
    LogUtil.info(TAG + ' processStringip ipAddress ==> ' + ipAddress);
    if (ipAddress.includes(',')) {
      LogUtil.info(TAG + ' ipAddress includes');
      const parts = ipAddress.split(',');
      const filtered = parts.filter(part =>!part.includes(':'));
      LogUtil.info(TAG + ' ipAddress includes filtered ==> ' + JSON.stringify(filtered));
      if (filtered.length > 0) {
        LogUtil.info(TAG + ' filtered.length ==> ' + filtered.length);
        if (filtered.length == 1) {
          try {
            // 使用await等待异步结果
            const data = await wifiManager.getLinkedInfo();
            LogUtil.info(TAG + ' getLinkedInfo data.ipAddress ==> ' + JSON.stringify(data.ipAddress));
            const filteredArray = filtered.filter(item => item !== IPConvertor.numberToIp(data.ipAddress))
            return filteredArray.length == 1 ? filteredArray[0].replace(/,+$/, '') : '';
          } catch (error) {
            LogUtil.error(TAG + ' getLinkedInfo error');
            return filtered[0].replace(/,+$/, '')
          }
        } else if (filtered.length == 2) {
          try {
            const data = await wifiManager.getLinkedInfo();
            LogUtil.info(TAG + ' getLinkedInfo data.ipAddress ==> ' + JSON.stringify(data.ipAddress));
            const filteredArray = filtered.filter(item => item !== IPConvertor.numberToIp(data.ipAddress));
            if (filteredArray.length == 0) {
              return ''
            } else if (filteredArray.length == 1) {
              return filteredArray[0].replace(/,+$/, '')
            } else {
              return filtered.join(',')
            }
          } catch (error) {
            LogUtil.error(TAG + ' getLinkedInfo error');
            return filtered.join(','); // 错误时返回默认值
          }
        } else {
          return filtered.join(','); // 其他情况直接返回
        }
      } else {
        return ''; // 空数组返回空字符串
      }
    } else {
      LogUtil.info(TAG + ' ipAddress not includes');
      if (ipAddress.includes(':')) {
        return ''
      } else {
        try {
          // 使用await等待异步结果
          const data = await wifiManager.getLinkedInfo();
          LogUtil.info(TAG + ' getLinkedInfo data.ipAddress ==> ' + JSON.stringify(data.ipAddress));
          const filteredArray = ipAddress.split(',').filter(item => item !== IPConvertor.numberToIp(data.ipAddress))
          return filteredArray.length == 1 ? filteredArray[0].replace(/,+$/, '') : '';
        } catch (error) {
          LogUtil.error(TAG + ' getLinkedInfo error');
          return ipAddress
        }
      }
    }
  }

  //子网掩码
  processStringmaskStr(ipAddress: string) {
    LogUtil.info(TAG + ' processStringmaskStr ipAddress ==> ' + ipAddress);
    if (ipAddress.includes(',')) {
      const parts = ipAddress.split(',');
      const filtered = parts.filter(part =>!part.includes(':'));
      if (filtered.length > 0) {
        if (!this.ipStr) {
          //空值
          return ''
        } else {
          return filtered[0].replace(/,+$/, ''); // 同步返回
        }
      } else {
        return ''; // 空数组返回空字符串
      }
    } else {
      if (ipAddress.includes(':')) {
        return ''
      } else {
        if (!this.ipStr) {
          //空值
          return ''
        } else {
          return ipAddress
        }
      }
    }
  }

  onDNSStrChange() {
    if (!this.ipStr) {
      //空值
      this.dnsStr = ''
    }
  }

  tabClick() {
    let keyDownOpt: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUpOpt: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let eventDown: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventDown, 'KeyEvent', keyDownOpt)
    let eventUp: InjectedKeyEventPayload = new InjectedKeyEventPayload()
    Reflect.set(eventUp, 'KeyEvent', keyUpOpt)

    try {
      inputEventClient.injectEvent(eventDown as never);
      inputEventClient.injectEvent(eventUp as never);
    } catch (err) {
      LogUtil.error('settingList inputEventClient' + err)
    }
  }

  /**
   * 获取当前网络配置（手动/自动）
   */
  getCurActiveIFaceConfig() {
    ethernet.getAllActiveIfaces()
      .then((iFaces) => {
        LogUtil.info(TAG + ' getCurActiveIFaceConfig getAllActiveIfaces iFaces ==> ' + JSON.stringify(iFaces));
        for (let i = 0; i < iFaces.length; i++) {
          this.curActiveIFace = iFaces[i];
        }
        LogUtil.info(TAG + ' getCurActiveIFaceConfig this.curActiveIFace ==> ' + JSON.stringify(this.curActiveIFace));
        ethernet.getIfaceConfig(this.curActiveIFace)
          .then(async (data) => {
            this.curActiveIFaceConfig = data;
            LogUtil.info(TAG + ' getIfaceConfig data ==> ' + JSON.stringify(data));
            this.ipStr = await this.processStringip(data.ipAddr);
            this.gatewayStr = this.processString(data.gateway);
            this.maskStr = this.processStringmaskStr(data.netMask);
            this.dnsStr = data.dnsServers.split(',', 1).toString();
            this.netTypeName = data.mode === 1 ? '自动' : '手动';
            this.settingList[1].setChooseDes(this.ipStr)
            this.settingList[2].setChooseDes(this.maskStr)
            this.settingList[3].setChooseDes(this.gatewayStr)
            this.settingList[4].setChooseDes(this.dnsStr)
          })
          .catch(async () => {
            Ipv4Model.setIpv4(await this.processStringip(this.ipStr));
            AppStorage.setOrCreate('ipStr', await this.processStringip(this.ipStr));

            gatewayModel.setGateway(this.processString(this.gatewayStr));
            AppStorage.setOrCreate('gatewayStr', this.processString(this.gatewayStr));

            netMaskModel.setNetmask(this.processStringmaskStr(this.maskStr));
            AppStorage.setOrCreate('maskStr', this.processStringmaskStr(this.maskStr))

            dnsModel.setDns(this.dnsStr);
            AppStorage.setOrCreate('dnsStr', this.dnsStr)
          })
      })
      .catch((err: Error) => {
        LogUtil.info(TAG + 'getCurActiveIFaceConfig getAllActiveIfaces fail, err: ' + JSON.stringify(err));
      })
  }

  updateAppList() {
    this.settingList.forEach((item: SettingItemTvModel, index: number) => {
      if (index > 0) {
        item.setIsDisableFocus(this.netTypeName === '自动')
        item.setIsEnable(this.netTypeName !== '自动')
        item.style = (this.netTypeName === '自动' ? SettingItemStyle.info : SettingItemStyle.default)
      }
    })
  }

  // 恢复原先的自动配置属性
  setAutoIFaceConfig(curActiveIFace: string) {
    ethernet.setIfaceConfig(curActiveIFace,
      {
        mode: 1,
        ipAddr: '',
        route: '',
        gateway: '',
        netMask: '',
        dnsServers: '',
      })
      .then(() => {
        this.getCurActiveIFaceConfig();
      })
      .catch((err: Error) => {
        console.log(err + '')
      })
  }

  /**
   * 获取全局手动配置
   */
  async getManualFaceConfig() {
    this.settingList[1].setChooseDes(await this.processStringip(this.ipStr))
    this.settingList[2].setChooseDes(this.processStringmaskStr(this.maskStr))
    this.settingList[3].setChooseDes(this.processString(this.gatewayStr))
    this.settingList[4].setChooseDes(this.dnsStr)
  }

  /**
   * 设置手动配置信息
   */
  async setManualFaceConfig() {
    ethernet.setIfaceConfig(this.curActiveIFace,
      {
        mode: 0,
        ipAddr: await this.processStringip(this.ipStr),
        route: this.routeStr,
        gateway: this.processString(this.gatewayStr),
        netMask: this.processStringmaskStr(this.maskStr),
        dnsServers: this.dnsStr
      }).then(() => {
      this.getCurActiveIFaceConfig();
      promptAction.showToast({
        message: '设置成功'
      })
    }).catch(() => {
      promptAction.showToast({
        message: '设置失败'
      })
    })
  }
  //注册网络监听事件
  onNetRegister(){
    // 创建NetConnection对象
    // 先使用register接口注册订阅事件
    this.netCon.register((error: BusinessError) => {
      console.log(TAG, '开始网络监听')
      console.error(JSON.stringify(error));
    });

    // 订阅网络丢失事件。调用register后，才能接收到此事件通知
    this.netCon.on('netLost', () => {
      router.back()
    });
  }

  /**
   *取消网络监听
   */
  offNetRegister(){
    // 使用unregister接口取消订阅
    this.netCon.unregister((error: BusinessError) => {
      console.log(TAG, '取消网络监听')
    });
  }

  build() {
    Column() {
      Stack() {
        SettingBackground()
          .position({ x: 0, y: 0 })
          .height(ConfigData.WH_100_100)
          .width(ConfigData.WH_100_100)

        Row() {
          SettingListTvComponent({
            settingList: this.settingList,
            isAlignCenter: true,
            title: '有线网络',
            onValueChangeLeftHandle:  (item: SettingItemTvModel) => {//为了灵犀的点击事件与触控事件
              if (item.name === '配置网络') {
                let origins: string[] = ['自动', '手动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.netTypeNameIndex = index
                  }
                })
                if (this.netTypeNameIndex > 0) {
                  this.netTypeNameIndex--;
                }
                this.netTypeName = origins[this.netTypeNameIndex];
                item.setValue(this.netTypeName);
                if (this.netTypeName === '自动') {
                  this.updateAppList();
                  this.setAutoIFaceConfig(this.curActiveIFace);
                  netTypeModel.setNetmask('自动')
                } else if (this.netTypeName === '手动') {
                  this.updateAppList();
                  this.getManualFaceConfig();
                  netTypeModel.setNetmask('手动')
                }
              }
            },
            onValueChangeRightHandle: (item: SettingItemTvModel) => { //为了灵犀的点击事件与触控事件
              if (item.name === '配置网络') {
                let origins: string[] = ['自动', '手动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.netTypeNameIndex = index
                  }
                })
                if (this.netTypeNameIndex < 1) {
                  this.netTypeNameIndex++;
                }
                this.netTypeName = origins[this.netTypeNameIndex];
                item.setValue(this.netTypeName);
                if (this.netTypeName === '自动') {
                  this.updateAppList();
                  this.setAutoIFaceConfig(this.curActiveIFace);
                  netTypeModel.setNetmask('自动')
                } else if (this.netTypeName === '手动') {
                  this.updateAppList();
                  this.getManualFaceConfig();
                  netTypeModel.setNetmask('手动')
                }
              }
            },
            onMouseClickHandle:(item:SettingItemTvModel)=>{
              if (this.netTypeName === '手动') {
                if (item.name === IPV4_ADDRESS ) {
                  router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                }
                if (item.name === '子网掩码') {
                  router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                }
                if (item.name === '默认网关') {
                  router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                }
                if (item.name === 'DNS服务器') {
                  router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                }
              }
            },
            onKeyEventHandle: (item: SettingItemTvModel, event: KeyEvent) => {
              if (event.type === KeyType.Down && item.name === '配置网络') {
                let origins: string[] = ['自动', '手动']
                origins.forEach((originItem, index) => {
                  if (item.value === originItem) {
                    this.netTypeNameIndex = index
                  }
                })
                if (event.keyCode == KeyCode.KEY_DPAD_LEFT && this.netTypeNameIndex > 0) {
                  this.netTypeNameIndex--;
                }
                if (event.keyCode == KeyCode.KEY_DPAD_RIGHT && this.netTypeNameIndex < 1) {
                  this.netTypeNameIndex++;
                }
                this.netTypeName = origins[this.netTypeNameIndex];
                item.setValue(this.netTypeName);
                if (this.netTypeName === '自动') {
                  this.updateAppList();
                  this.setAutoIFaceConfig(this.curActiveIFace);
                  netTypeModel.setNetmask('自动')
                } else if (this.netTypeName === '手动') {
                  this.updateAppList();
                  this.getManualFaceConfig();
                  netTypeModel.setNetmask('手动')
                }
              }
              if (item.name === IPV4_ADDRESS && event.keyCode == KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
              }
              if (item.name === '子网掩码' && event.keyCode == KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
              }
              if (item.name === '默认网关' && event.keyCode == KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
              }
              if (item.name === 'DNS服务器' && event.keyCode == KeyCode.KEY_ENTER && event.type === KeyType.Up) {
                router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
              }
            }
          })
            .width(ConfigData.WH_100_100)
            .height(ConfigData.WH_100_100)
            .margin(0)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.Center)
      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
}
