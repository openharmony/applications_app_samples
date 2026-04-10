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

import WifiModel, { IPConvertor, ScanWifi, WifiScanInfo } from '../../model/wifiImpl/WifiModel';
import wifiManager from '@ohos.wifiManager';
import { SettingItemTvModel } from '../../default/model/SettingItemTvModel';
import { Ratio } from '../../common/Ratio';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { SettingItemStyle, SourcetoolConstants } from '../../common/constants/StyleConstants';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingBackground } from '../../default/layout/SettingBackground';
import { SettingListTvComponent } from '../../default/layout/SettingListTvComponent';
import lpx from '../../common/Lpx';
import { KeyCode } from '../../common/constants/KeyCode';
import router from '@ohos.router';
import { inputEventClient } from '@kit.InputKit';
import { emitter } from '@kit.BasicServicesKit';
import { EventUtil } from '../../common/EventUtil';
import { FaultLogger } from '@kit.PerformanceAnalysisKit';
import { ethernet } from '@kit.NetworkKit';
import { promptAction } from '@kit.ArkUI';
import w from '@ohos.wifiManager';
import { JSON } from '@kit.ArkTS';
import json from '@ohos.util.json';

interface SlConnectedWifi {
  settingTitle: string,
  settingArrow: string,
  apInfo: WifiScanInfo,
}


const TAG = 'WifiInfoDetail';

@Entry
@Component
struct WifiInfoDetail {
  @State imageUrl: string = Ratio.resName('icon_wifi')
  @State des: string = '已连接WIFI'
  @State settingList: SettingItemTvModel[] = []
  private apInfo: WifiScanInfo = {
    ssid: '',
    bssid: '',
    rssi: -100,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 1,
  };
  private apInfo2: WifiScanInfo = {
    ssid: '',
    bssid: '',
    rssi: -100,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 1,
  };
  private isConnected: boolean = false;
  @State userSelectedApInfo: WifiScanInfo = {
    ssid: '',
    bssid: '',
    rssi: 0,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 0,
  };
  @StorageLink('slConnectedWifi') slConnectedWifi: SlConnectedWifi = {
    settingTitle: '',
    settingArrow: '',
    apInfo: {
      ssid: '',
      bssid: '',
      rssi: 0,
      band: 0,
      frequency: 0,
      timestamp: 0,
      securityType: 0
    }
  };
  @StorageLink('IsVertical') isVertical: boolean = globalThis.screenWidth < globalThis.screenHeight;
  @State focusIndex: number = -1;
  @State ipType: number = 1; //0 static ,1 dhcp

  wifiConfig: wifiManager.WifiDeviceConfig =
    {
      ssid: '****',
      bssid: '****',
      preSharedKey: '****',
      isHiddenSsid: false,
      securityType: 0,
      creatorUid: 0,
      disableReason: 0,
      netId: 0,
      randomMacType: 0,
      randomMacAddr: '****',
      ipType: 0,
      staticIp: {
        ipAddress: 0,
        gateway: 0,
        dnsServers: [],
        domains: [],
        prefixLength: 0
      },
      proxyConfig: {
        proxyMethod: 0,
        pacWebAddress: '',
        serverHostName: '',
        serverPort: 0,
        exclusionObjects: ''
      }
    }
  ipStr: string = '';
  gateWayStr: string = '';
  dnsStr: string = '';
  maskStr: string = '';
  scroller: Scroller = new Scroller();
  @State buttons: string[] = [
    '取消', '删除'
  ]



  build() {
    Column() {
      Stack() {
        SettingBackground()
          .position({ x: 0, y: 0 })
          .height(ConfigData.WH_100_100)
          .width(ConfigData.WH_100_100)

        Column() {
          Row() {
            SettingListTvComponent({
              settingList: this.settingList,
              isAlignCenter: true,
              title: this.apInfo.ssid + ' 无线网络配置',
              onKeyEventHandle:(item: SettingItemTvModel, event: KeyEvent)=>{
                if ((event.keyCode ==KeyCode.KEY_DPAD_RIGHT || event.keyCode ==KeyCode.KEY_DPAD_LEFT) &&
                  item.name === '配置网络' && event.type == KeyType.Down) {
                  this.netTypeName=this.netTypeName=='手动'?'自动':'手动'       //切换value值
                  item.setValue(this.netTypeName);
                  this.focusState = false
                  this.updateAppList(item.value)                  //刷新列表
                  this.focusState = true
                  if (this.netTypeName == '手动') {
                    this.ipState=wifiManager.IpType.STATIC
                    this.updateSettingList_static()
                  }else {
                    this.ipState=wifiManager.IpType.DHCP
                    this.updateSettingList_DHCP()
                  }
                }
              },
              onValueChangeLeftHandle:(item: SettingItemTvModel)=>{
                this.netTypeName=this.netTypeName=='手动'?'自动':'手动'       //切换value值
                item.setValue(this.netTypeName);
                this.focusState = false
                this.updateAppList(item.value)                  //刷新列表
                this.focusState = true
                if (this.netTypeName == '手动') {
                  this.ipState=wifiManager.IpType.STATIC
                  this.updateSettingList_static()
                }else {
                  this.ipState=wifiManager.IpType.DHCP
                  this.updateSettingList_DHCP()
                }
              },
              onValueChangeRightHandle:(item: SettingItemTvModel)=>{
                this.netTypeName=this.netTypeName=='手动'?'自动':'手动'       //切换value值
                item.setValue(this.netTypeName);
                this.focusState = false
                this.updateAppList(item.value)                  //刷新列表
                this.focusState = true
                if (this.netTypeName == '手动') {
                  this.ipState=wifiManager.IpType.STATIC
                  this.updateSettingList_static()
                }else {
                  this.ipState=wifiManager.IpType.DHCP
                  this.updateSettingList_DHCP()
                }
              },
              onMouseClickHandle:(item: SettingItemTvModel)=>{
                if (item.isEnable) {
                  if (item.name === 'IPV4') {
                    router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                  }
                  if (item.name === '子网掩码' ) {
                    router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                  }
                  if (item.name === '默认网关') {
                    router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                  }
                  if (item.name === 'DNS服务器') {
                    router.pushUrl({ url: item.pageUrl, params: { ips: item.chooseDes } }, router.RouterMode.Single)
                  }
                }
              }
            })
          }
          .width(ConfigData.WH_100_100)
          .height(lpx(896))
          .alignItems(VerticalAlign.Top)
          .justifyContent(FlexAlign.Start)

          Row({ space: lpx(26) }) {
            ForEach(this.buttons, (item: string, index) => {
              Column() {
                Text(item)
                  .width(lpx(248))
                  .height(lpx(72))
                  .textAlign(TextAlign.Center)
                  .fontColor(this.focusIndex === index ? Color.Black : Color.White)
                  .fontSize(lpx(36))
                  .borderRadius(lpx(200))
                  .backgroundColor(this.focusIndex === index ? Color.White : '#666666')
                  .focusable(this.focusState)
                  .stateStyles({
                    focused: {
                      .border({
                        color: Color.Transparent
                      })
                    }
                  })
              }
              .width(this.focusIndex === index ? lpx(266) : lpx(248))
              .height(this.focusIndex === index ? lpx(90) : lpx(72))
              .border({
                width: this.focusIndex === index ? lpx(2) : 0,
                radius: lpx(200),
                color: Color.White,
                style: BorderStyle.Solid
              })
              .justifyContent(FlexAlign.Center)
              .key('btn' + index.toString())
              .focusable(this.focusState)
              .onFocus(() => {
                this.focusIndex = index;
                LogUtil.info(TAG + `apInfoDialog  focusIndex======>${this.focusIndex}`)
              })
              .onClick(()=>{
                if (item == '取消') {
                  LogUtil.info(TAG + 'clicked ap info cancel');
                  router.back();
                  emitter.emit('linkFocus', { data: { type:'link' } })
                }
                if (item == '删除') {
                  LogUtil.info(TAG + 'clicked ap info to disconnect');
                  if (this.isConnected) {
                    WifiModel.disconnectWiFi();
                    emitter.emit('linkFocus', { data: { type:'delete' } })
                  }
                  WifiModel.removeDeviceConfig(this.apInfo);
                  WifiModel.refreshApScanResults();
                  router.back();
                }
                if (item == '断开连接') {
                  LogUtil.info(TAG + 'clicked ap info to disconnect');
                  if (this.isConnected) {
                    WifiModel.disconnectWiFi();
                  }
                  WifiModel.connectByDeviceConfig(this.apInfo2)
                  WifiModel.refreshApScanResults();
                  router.back();
                  emitter.emit('linkFocus', { data: { type:'delete' } })
                }
                if (item == '连接') {

                  WifiModel.disconnectWiFi();
                  WifiModel.connectByDeviceConfig(this.apInfo);
                  WifiModel.refreshApScanResults();
                  router.back();
                  emitter.emit('linkFocus', { data: { type:'link' } })

                }
              })
              .onKeyEvent((event?: KeyEvent) => {
                if (!event) {
                  return;
                }
                if (!(event.keyCode == KeyCode.KEY_DPAD_LEFT && this.focusIndex > 0 ||
                  event.keyCode == KeyCode.KEY_DPAD_RIGHT && this.focusIndex < this.buttons.length ||
                  event.keyCode == KeyCode.KEY_ENTER)) {
                  focusControl.requestFocus('btn' + index.toString());
                  event.stopPropagation?.();
                }
                if (event.keyCode == KeyCode.KEY_DPAD_UP && event.type == KeyType.Down) {
                  this.focusIndex=-1
                  focusControl.requestFocus('WIFI_CONFIG_FOCUS_0');
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

                if (item == '取消') {
                  LogUtil.info(TAG + 'clicked ap info cancel');
                  router.back();
                  emitter.emit('linkFocus', { data: { type: 'link' } })
                }

                if (item == '删除') {
                  LogUtil.info(TAG + 'clicked ap info to disconnect');
                  if (this.isConnected) {
                    WifiModel.disconnectWiFi();
                    emitter.emit('linkFocus', { data: { type: 'delete' } })
                  }
                  WifiModel.removeDeviceConfig(this.apInfo);
                  WifiModel.refreshApScanResults();
                  router.back();
                }
                if (item == '连接') {

                  WifiModel.disconnectWiFi();
                  WifiModel.connectByDeviceConfig(this.apInfo);
                  WifiModel.refreshApScanResults();
                  router.back();
                  emitter.emit('linkFocus', { data: { type: 'link' } })

                }
              })
            }, (item: ScanWifi) => item.settingTitle)
          }
          .alignItems(VerticalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .margin({
            top: $r('app.float.wh_value_16'),
            bottom: $r('app.float.wh_value_16'),
          })
          .borderRadius(lpx(50))
          .width(ConfigData.WH_100_100)
          .height(lpx(68))

        }
        .width(ConfigData.WH_100_100)
        .height(ConfigData.WH_100_100)
        .justifyContent(FlexAlign.Start)
        .alignItems(HorizontalAlign.Start)

      }
    }
    .width(ConfigData.WH_100_100)
    .height(ConfigData.WH_100_100)
  }
  @StorageLink('ipStr') @Watch('ipStr2_Change') ipStr2: string = '';            //手动ipv4
  @StorageLink('maskStr') @Watch('maskStr2_Change') maskStr2: string = ''
  @StorageLink('gatewayStr') @Watch('gateWayStr2_Change') gateWayStr2: string = ''
  @StorageLink('dnsStr') @Watch('dnsStr2_Change') dnsStr2: string = ''
  @State changeState:boolean=true                            //进入离开时清空数据，但不触发设置
  @State curActiveIFace: string = 'wlan0'                    //网络接口
  private routeStr: string = '0.0.0.0';                 //需要的一个属性 有线也没变 就这样
  @State focusState: boolean = true           //是否允许下面按钮获得焦点
  @State netTypeName: string = '自动';
  @State @Watch('state_ip') ipState:wifiManager.IpType = wifiManager.IpType.DHCP;               //是static 或者是 DHCP

  onPageShow(): void {
    this.changeState=false
    this.ipStr2=''
    this.maskStr2=''
    this.gateWayStr2=''
    this.dnsStr2=''
    this.changeState=true
  }
  onPageHide(): void {
    this.changeState=false
    this.ipStr2=''
    this.maskStr2=''
    this.gateWayStr2=''
    this.dnsStr2=''
    this.changeState=true
  }

  private formatStaticIpValue(value: number | undefined): string {
    return IPConvertor.numberToIp(value ?? 0)
  }

  private updateWifiConfigSafely() {
    try {
      w.updateNetwork(this.wifiConfig);
    } catch (error) {
      LogUtil.error(TAG + ' updateNetwork failed: ' + JSON.stringify(error))
    }
  }

  updateSettingList_static(){                                                                    //切换为static时更新列表
    this.settingList[1].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.ipAddress))
    this.settingList[2].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.prefixLength))
    this.settingList[3].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.gateway))
    this.settingList[4].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.dnsServers[0]))
  }

  updateSettingList_DHCP(){                                                                    //切换为DHCP时更新列表
    this.settingList[1].setChooseDes(IPConvertor.numberToIp(WifiModel.getWifiIpInfo().ipAddress))
    this.settingList[2].setChooseDes(IPConvertor.numberToIp(WifiModel.getWifiIpInfo().netmask))
    this.settingList[3].setChooseDes(IPConvertor.numberToIp(WifiModel.getWifiIpInfo().gateway))
    this.settingList[4].setChooseDes(IPConvertor.numberToIp(WifiModel.getWifiIpInfo().primaryDns))
    this.wifiConfig.staticIp!.ipAddress = WifiModel.getWifiIpInfo().ipAddress;
    this.wifiConfig.staticIp!.prefixLength = WifiModel.getWifiIpInfo().netmask;
    this.wifiConfig.staticIp!.gateway = WifiModel.getWifiIpInfo().gateway;
    this.wifiConfig.staticIp!.dnsServers[0] = WifiModel.getWifiIpInfo().primaryDns;     //除更新列表外，还需重新初始化变成自动分配ip等属性
    this.updateWifiConfigSafely();
  }

  ipStr2_Change(){
    if (this.changeState) {
      this.wifiConfig.staticIp!.ipAddress = IPConvertor.ipToNumber(this.ipStr2);
      this.updateWifiConfigSafely();
      this.settingList[1].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.ipAddress))
    }
  }
  maskStr2_Change(){
    if (this.changeState) {
      this.wifiConfig.staticIp!.prefixLength = IPConvertor.ipToNumber(this.maskStr2);
      this.updateWifiConfigSafely();
      this.settingList[2].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.prefixLength))
    }
  }
  gateWayStr2_Change(){
    if (this.changeState) {
      this.wifiConfig.staticIp!.gateway = IPConvertor.ipToNumber(this.gateWayStr2);
      this.updateWifiConfigSafely();
      this.settingList[3].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.gateway))
    }
  }
  dnsStr2_Change(){
    if (this.changeState) {
      this.wifiConfig.staticIp!.dnsServers[0] = IPConvertor.ipToNumber(this.dnsStr2);
      this.updateWifiConfigSafely();
      this.settingList[4].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.dnsServers[0]))
    }
  }

  state_ip(){
    this.wifiConfig.ipType=this.ipState
  }




  updateAppList(state:string) {                                                   //刷新列表
    console.log(TAG, ' updateAppList state ==> ' + state)
    this.settingList.forEach((item: SettingItemTvModel, index: number) => {
      if (index > 0) {
        if (state=='自动') {
          item.setIsDisableFocus(true)
          item.setIsEnable(false)
        }else {
          item.setIsDisableFocus(false)
          item.setIsEnable(true)
        }
      }
    })
  }
  async aboutToAppear() {
    let params = router.getParams() as Record<string, string | number | boolean | WifiScanInfo>;

    this.apInfo = params.apInfo as WifiScanInfo

    LogUtil.info(TAG + `connected dialog show:${JSON.stringify(this.apInfo)}}`)
    this.des = this.apInfo.ssid;

    this.isConnected = params.isConnected as boolean;

    if (!this.isConnected) {
        this.buttons[this.buttons.length-1] = '连接';
    }
    LogUtil.info(TAG + 'linkedWifi in......');
    this.initIpType();
  }



  private initIpType() {
    WifiModel.getLinkedWifiInfo().then((linkInfo) => {
      if (!linkInfo) {
        return;
      }
      this.updateSettingList();
      wifiManager.getDeviceConfigs().forEach((config: wifiManager.WifiDeviceConfig) => {
        console.log(TAG, 'xz_initIpType_new:', JSON.stringify(config), 'xz_initIpType_old:',
          JSON.stringify(config.staticIp ?? {}))
        if (config.ssid === linkInfo.ssid) {
          this.wifiConfig = config;
          this.wifiConfig.ipType=this.wifiConfig.ipType==0?1:0              //因为底层的ipType对应数据和应用层的0，1正好相反 所以这里转一下
          console.log(TAG, 'xz_initIpType:', JSON.stringify(this.wifiConfig))//
          if (!(this.wifiConfig.ipType==wifiManager.IpType.STATIC)) {
            console.log(TAG, 'xz_initIpType_static:')
            this.ipState=wifiManager.IpType.STATIC
            this.netTypeName = '手动'
            this.wifiConfig.ipType=wifiManager.IpType.DHCP
            setTimeout(()=>{
              console.log(TAG, 'xz_initIpType_static_updateAppList')
              this.settingList[0].setValue('手动')
              this.settingList[0].setIsDisableFocus(false)
              this.settingList[0].setIsEnable(true)
              this.updateAppList('手动')
            },0)
            this.settingList[1].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.ipAddress))
            this.settingList[2].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.prefixLength))
            this.settingList[3].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.gateway))
            this.settingList[4].setChooseDes(this.formatStaticIpValue(this.wifiConfig.staticIp?.dnsServers[0]))
            this.wifiConfig.ipType=wifiManager.IpType.STATIC
          }else {                                             //DHCP就用getWifiIpInfo()
            if (this.wifiConfig.staticIp!=undefined) {
              console.log(TAG, 'xz_initIpType_DHCP:')
              this.wifiConfig.staticIp.ipAddress=WifiModel.getWifiIpInfo().ipAddress
              this.wifiConfig.staticIp.gateway=WifiModel.getWifiIpInfo().gateway
              this.wifiConfig.staticIp.prefixLength=WifiModel.getWifiIpInfo().netmask
              this.wifiConfig.staticIp.dnsServers[0]=WifiModel.getWifiIpInfo().primaryDns
            }
          }
          setTimeout(() => {
            focusControl.requestFocus('WIFI_CONFIG_FOCUS_0');
          }, 100); // 确保渲染完成后再请求焦点
        }
      })
    });
    let type: wifiManager.IpType = this.wifiConfig.ipType as wifiManager.IpType;
    this.ipType = type;
  }

  private updateSettingList() {
    this.settingList = [];
    let item1 = new SettingItemTvModel();
    item1.name = '配置网络';
    item1.value =  this.netTypeName;
    item1.focusKeys = ['WIFI_CONFIG_FOCUS_0']
    item1.isSetFocusKey = true;
    item1.style = SettingItemStyle.valueChange;

    let item2 = new SettingItemTvModel();
    item2.name = 'IPV4';
    item2.isEnable = false;
    item2.chooseDes = IPConvertor.numberToIp(WifiModel.getWifiIpInfo().ipAddress);
    item2.isDisableFocus=true;
    item2.style = SettingItemStyle.info;
    item2.pageUrl = 'pages/network/IpUpdate';

    let item3 = new SettingItemTvModel();

    item3.name = '子网掩码';
    item3.isEnable = false;
    item3.chooseDes = IPConvertor.numberToIp(WifiModel.getWifiIpInfo().netmask);
    item3.style = SettingItemStyle.info;
    item3.isDisableFocus = true;
    item3.pageUrl = 'pages/network/NetMaskUpdate'

    let item4 = new SettingItemTvModel();
    item4.name = '默认网关';
    item4.isEnable = false;
    item4.chooseDes = IPConvertor.numberToIp(WifiModel.getWifiIpInfo().gateway);
    item4.style = SettingItemStyle.info;
    item4.isDisableFocus = true;
    item4.pageUrl = 'pages/network/GatewayUpdate'

    let item5 = new SettingItemTvModel();
    item5.name = 'DNS服务器';
    item5.isEnable = false;
    item5.chooseDes = IPConvertor.numberToIp(WifiModel.getWifiIpInfo().primaryDns);
    item5.style = SettingItemStyle.info;
    item5.isDisableFocus = true;
    item5.pageUrl = 'pages/network/DnsUpdate';
    this.settingList.push(item1,item2, item3, item4, item5);
  }

}
