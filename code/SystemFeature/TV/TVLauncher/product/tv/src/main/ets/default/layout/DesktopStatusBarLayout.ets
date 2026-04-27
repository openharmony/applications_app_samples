/**
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

import { connection } from '@kit.NetworkKit';
import { AppItemInfo } from '../../common/bean/AppItemInfo';
import DesktopStatusBarAppItem from './DesktopStatusBarAppItem';
import { wifiManager } from '@kit.ConnectivityKit';
import { ethernet } from '@kit.NetworkKit';
import { BusinessError, commonEventManager } from '@kit.BasicServicesKit';

let subscribeInfoCustom: commonEventManager.CommonEventSubscribeInfo = {
  events: [
    'user.event.SET_TIME'
  ]
};
let subscriberCustom: commonEventManager.CommonEventSubscriber | null = null;

const TAG = 'DesktopStatusBarLayout';
const DELAY_SECONDS = 2000 // 延迟两秒

export enum NetworkState {
  INIT, // 初始查询中
  ETHERNET, // 有线网络ok
  NOETH_OR_WIFIDISABLE, // 没有有线且WIFI开关未打开
  WIFI_NO_NETWORK, // WIFI已经连接但无网络
  WIFI_RSSI_LEVEL_0, // WIFI信号0
  WIFI_RSSI_LEVEL_1, // WIFI信号1
  WIFI_RSSI_LEVEL_2, // WIFI信号2
  WIFI_RSSI_LEVEL_3, // WIFI信号3
  WIFI_RSSI_LEVEL_4, // WIFI信号4
}

@Component
export struct DesktopStatusBarLayout {
  @State appList: AppItemInfo[] = [];
  private netConnection: connection.NetConnection | null = null;
  @State appNetwork: AppItemInfo | undefined = undefined

  appSetting: AppItemInfo | undefined = undefined
  appSearch: AppItemInfo | undefined = undefined
  @State @Watch('networkStateWatch')
  networkState: NetworkState = NetworkState.INIT
  @State currentTime: string = ''

  networkIconUpdate() {
    switch (this.networkState) {
      case NetworkState.ETHERNET: // 有线网
        this.appNetwork!.appName = 'ETH'
        this.appNetwork!.icon = '/common/pics/statusBar/icon_eth_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_eth_onfocus.svg'
        break;
      case NetworkState.NOETH_OR_WIFIDISABLE:
        this.appNetwork!.appName = 'NET' // 有线与无线都没有
        this.appNetwork!.icon = '/common/pics/statusBar/icon_net_disable_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_net_disable_onfocus.svg'
        // 这里必须要加，不然公版6320可能由于性能问题不起作用
       setTimeout(()=>{
          this.getAllNet()
          this.netConnection?.unregister(()=>{
          // 取消监听后再打开
         this.register()
          })
        },5000)
        break;
      case NetworkState.WIFI_NO_NETWORK: // 无有线 但链接了wifi 但wifi无法上网
        this.appNetwork!.appName = 'WIFI'
        this.appNetwork!.icon = '/common/pics/statusBar/icon_wifi_disconnect_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_wifi_disconnect_onfocus.svg'
        break;
      case NetworkState.WIFI_RSSI_LEVEL_0: // 无有线 但链接了wifi  wifi信号0
        this.appNetwork!.appName = 'WIFI'
        this.appNetwork!.icon = '/common/pics/statusBar/icon_wifi_level0_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_wifi_level0_onfocus.svg'
        break;
      case NetworkState.WIFI_RSSI_LEVEL_1: // 无有线 但链接了wifi  wifi信号1
        this.appNetwork!.appName = 'WIFI'
        this.appNetwork!.icon = '/common/pics/statusBar/icon_wifi_level1_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_wifi_level1_onfocus.svg'
        break;
      case NetworkState.WIFI_RSSI_LEVEL_2: // 无有线 但链接了wifi  wifi信号2
        this.appNetwork!.appName = 'WIFI'
        this.appNetwork!.icon = '/common/pics/statusBar/icon_wifi_level2_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_wifi_level2_onfocus.svg'
        break;
      case NetworkState.WIFI_RSSI_LEVEL_3: // 无有线 但链接了wifi  wifi信号3
        this.appNetwork!.appName = 'WIFI'
        this.appNetwork!.icon = '/common/pics/statusBar/icon_wifi_level3_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_wifi_level3_onfocus.svg'
        break;
      case NetworkState.WIFI_RSSI_LEVEL_4: // 无有线 但链接了wifi  wifi信号3
        this.appNetwork!.appName = 'WIFI'
        this.appNetwork!.icon = '/common/pics/statusBar/icon_wifi_level4_offfocus.svg'
        this.appNetwork!.onFocusIcon = '/common/pics/statusBar/icon_wifi_level4_onfocus.svg'
        break;
    }
  }

  networkStateWatch() {
    console.log(TAG, 'networkStateWatch state = ' + this.networkState)

    let networkOk =
      this.networkState != NetworkState.INIT && this.networkState != NetworkState.NOETH_OR_WIFIDISABLE &&
        this.networkState != NetworkState.WIFI_NO_NETWORK && this.networkState != NetworkState.WIFI_RSSI_LEVEL_0
    AppStorage.setOrCreate('networkOk', networkOk)
    this.networkIconUpdate();
  }

  aboutToAppear() {
    this.getLocalTimer()

    this.appNetwork = new AppItemInfo()
    this.appNetwork.isFocus = false

    this.appSetting = new AppItemInfo();
    this.appSetting.appName = 'SETTINGS'
    this.appSetting.icon = '/common/pics/statusBar/icon_settings_offfocus.svg'
    this.appSetting.onFocusIcon = '/common/pics/statusBar/icon_settings_onfocus.svg'
    this.appSetting.isFocus = false

    this.appSearch = new AppItemInfo();
    this.appSearch.appName = 'SEARCH'
    this.appSearch.icon = '/common/pics/statusBar/search.svg'
    this.appSearch.onFocusIcon = '/common/pics/statusBar/search_focus.svg'
    this.appSearch.isFocus = false

    let list: AppItemInfo[] = [this.appSearch!, this.appNetwork!, this.appSetting!]

    this.appList = this.resetId(list)

    this.netConnection = connection.createNetConnection({
      netCapabilities: { bearerTypes: [connection.NetBearType.BEARER_ETHERNET, connection.NetBearType.BEARER_WIFI] }
    });

    commonEventManager.createSubscriber(subscribeInfoCustom,
      (err: BusinessError, data: commonEventManager.CommonEventSubscriber) => {
        if (err) {
          return;
        }
        subscriberCustom = data;
        if (subscriberCustom !== null) {
          commonEventManager.subscribe(subscriberCustom,
            (err, data) => {
              if (!err) {
                this.getLocalTimer(true);
              }
            })
        }
      })

    setTimeout(()=>{
     this.getAllNet();
     this.networkIconUpdate();
     this.register()
     },3000)
  }
  aboutToDisappear(): void {
    this.netConnection?.unregister(()=>{
      console.log('取消监听')
    })
  }

  register() {
    this.netConnection?.register((error, data) => {
      if (error) {
        console.error(TAG, `register error: ${JSON.stringify(error)}`)
        let id=setTimeout(() => {
          this.register()
          clearTimeout(id)
        }, DELAY_SECONDS) // 网络服务建立时间晚于launcher启动 所以需要延迟一下
      } else {
        console.log(TAG, `register success: ${JSON.stringify(error)}`)
        this.listen()
      }
    })
  }

  listen() {
    try {
      // 监听有线变化
      ethernet.on('interfaceStateChange', (stateInfo: ethernet.InterfaceStateInfo) => {
        console.log(TAG, 'interfaceStateChange：' + JSON.stringify(stateInfo));
        setTimeout(()=>{
          this.getAllNet()
        }, 100)
      });

      // 监听wifi开关是否打开
      wifiManager.on('wifiStateChange', r => { // wifi已经打开 是否连接网络
        console.info(TAG, `wifiStateChange: ${JSON.stringify(r)}`)
        this.getAllNet()
      })

      // 监听wifi是否可以联网
      wifiManager.on('wifiConnectionChange', r => { // wifi已经打开 是否连接网络
        console.info(TAG, `wifiConnectionChange: ${JSON.stringify(r)}`)
        this.getAllNet()
      })

      // 监听wifi强度
      wifiManager.on('wifiRssiChange', (data) => {
        console.info(TAG, `wifiConnectionChange: ${JSON.stringify(data)}`)
        this.getAllNet()
      })
    } catch (error) {
      console.error(TAG, `Llisten error: ${JSON.stringify(error)}`)
    }
  }

  resetId(list: AppItemInfo[]) {
    let date = new Date();
    list.forEach(a => a.appId = a.appName + '_' + date.toTimeString())
    return list
  }

  getAllNet() {
    this.networkState = NetworkState.INIT

    console.log(TAG, 'getAllNet start')
    ethernet.getAllActiveIfaces((error: BusinessError, value: string[]) => {
      if (error) {
        console.log(TAG, 'getAllActiveIfaces callback error = ' + JSON.stringify(error));
        this.getAllNet()
      } else {
        console.log(TAG, 'getAllActiveIfaces callback value = ' + JSON.stringify(value));
        if (value?.length >= 1) {
          this.networkState = NetworkState.ETHERNET // 已激活:1,未激活:0
        } else {
          this.getWifi()
        }
      }
    });
  }

  getWifi() {
    try {
      if (this.networkState == NetworkState.ETHERNET) {
        return
      }
      let isWifiManager = wifiManager.isWifiActive();
      if (!isWifiManager) {
        console.log(TAG, `getWifi 1 isWifiActive`)
        this.networkState = NetworkState.NOETH_OR_WIFIDISABLE
      } else if (!wifiManager.isConnected()) {
        console.log(TAG, `getWifi 2 isConnected`)
        this.networkState = NetworkState.WIFI_NO_NETWORK
      } else {
        wifiManager.getLinkedInfo((error, res) => {
          if (this.networkState == NetworkState.ETHERNET) {
            return;
          }
          if (error) {
            console.error(TAG, `getWifi 3 error ${error}`)
            this.networkState = NetworkState.WIFI_NO_NETWORK
          } else {
            console.log(TAG, `getWifi 4 sucess ${JSON.stringify(res)}`)
            let level = wifiManager.getSignalLevel(res.rssi, res.band)
            console.log(TAG, `getWifi 5 getSignalLevel = ` + level)

            switch (level) {
              case 0:
                this.networkState = NetworkState.WIFI_RSSI_LEVEL_0
                break;
              case 1:
                this.networkState = NetworkState.WIFI_RSSI_LEVEL_1
                break;
              case 2:
                this.networkState = NetworkState.WIFI_RSSI_LEVEL_2
                break;
              case 3:
                this.networkState = NetworkState.WIFI_RSSI_LEVEL_3
                break;
              case 4:
                this.networkState = NetworkState.WIFI_RSSI_LEVEL_4
                break;
            }
          }
        })
      }
    } catch (e) {
      console.log(TAG, 'Operation failed Message:', e)
    }
  }

  getLocalTimer= (adjust?:boolean)=>{
    let localTime = new Date()
    this.currentTime = localTime.toLocaleTimeString('zh-Hans-CN', {
      hour: '2-digit',
      minute: '2-digit',
      hour12: true,
    });
    console.debug( `getLocalTimer is, ${this.currentTime}, adjust is: ${adjust}` )

    // 距离下一分钟的秒数 = 60 - 当前秒数（比如当前35秒，延迟25秒）
    if (!adjust) {
      setTimeout(this.getLocalTimer, (60 - localTime.getSeconds())*1000)
    }
  }

  build() {
    Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.End }) {
      Image('')
        .position({ x: 0, y: 0 })
        .height('100%')
        .width('100%')

      ForEach(this.appList, (item: AppItemInfo, index: number) => {
        Row() {
          DesktopStatusBarAppItem({ app: item, idx: index })
        }
        .aspectRatio(1)
        .width(80 + 'lpx')
        .margin({ right: '2%' })
      }, (item: AppItemInfo) => {
        return `${item.appId}`
      })

      Text(this.currentTime)
        .fontSize(36 + 'lpx')
        .fontWeight(FontWeight.Bold)
        .fontColor('rgba(255,255,255,0.9)')
        .margin({ right: '5%' })
    }
    .size({ width: '100%', height: '15%' })
    .focusable(true)
  }
}