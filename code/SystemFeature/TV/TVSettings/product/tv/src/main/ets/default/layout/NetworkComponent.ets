import ethernet from '@ohos.net.ethernet';
import { SettingItemStyle } from '../../common/constants/StyleConstants';
import { Ratio } from '../../common/ratio';
import WifiModel, { WifiScanInfo } from '../../model/wifiImpl/WifiModel';
import { SettingItemTvModel } from '../model/SettingItemTvModel';
import { SettingBackground } from './SettingBackground';
import { SettingItemDesLayout } from './SettingItemDesLayout';
import { SettingListTvComponent } from './SettingListTvComponent';
import { KeyCode } from '../../common/constants/KeyCode';
import router from '@ohos.router';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import { SettingItemTvComponent } from '../../default/layout/SettingItemTvComponent'
import lpx from '../../common/lpx'
import wifiManager from '@ohos.wifiManager';
import { connection } from '@kit.NetworkKit';

const NETWORK_MONITOR_TITLE: string = '网络检测';
const NETWORK_MONITOR_URL: string = 'pages/network/netMonitor';
const NETWORK_SPEED_TITLE: string = '网络测速';
const NETWORK_SPEED_URL: string = 'pages/network/netSpeed';
const wirelessNetwork: string = getContext(this).resourceManager.getStringByNameSync("wirelessNetwork")
const NETWORK_PERSONAL_HOTSPOT_TITLE:string = "个人热点";
const NETWORK_PERSONAL_HOTSPOT_URL:string = "pages/hotspot/hotspot";
interface SlConnectedWifi {
  settingTitle: string
  settingArrow: string
  apInfo: WifiScanInfo,
}

@Component
export struct NetWorkComponent {
  private scanTaskId: number = -1;
  @State imageUrl: string = '';
  @State isEnable: boolean = true;
  @State des: string | Resource = '';
  @State settingList: SettingItemTvModel[] = []
  @StorageLink('slConnectedWifi') @Watch("onConnectedWifiChange") slConnectedWifi: SlConnectedWifi = {
    settingTitle: '',
    settingArrow: '',
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
  @State enableEthernet: boolean = false;
  @State ssid: string = ''
  @State activities: string[] = [];
  isWifiEnable: boolean = false;
  @Link pageTranState: boolean; //判断是进场动效还是出场动效

  build() {
    Stack() {
      SettingBackground()
        .position({ x: 0, y: 0 })
        .height(ConfigData.WH_100_100)
        .width(ConfigData.WH_100_100)

      Row() {
        SettingListTvComponent({
          isEnable: this.isEnable,
          settingList: this.settingList,
          title: "网络",
          onKeyEventHandle: async (item: SettingItemTvModel, event: KeyEvent) => {
            if (event.keyCode == KeyCode.KEY_ENTER && event.type == KeyType.Down) {
              if (item.name === "有线网络") {
                if (!this.enableEthernet) {
                  return;
                }
              } else if (item.name === NETWORK_MONITOR_TITLE) {
                await this.isWifiNetworkEnable();
                router.pushUrl({
                  url: item.pageUrl,
                  params: {
                    isWifiEnable: this.isWifiEnable
                  }
                }, router.RouterMode.Single)
                this.pageTranState = true
                return;
              } else if (item.name == wirelessNetwork) {
                if (this.enableEthernet) {
                  return;
                }
              }else if(item.name === NETWORK_PERSONAL_HOTSPOT_TITLE){
                console.log("打开个人热点页面" + item.pageUrl)
                router.pushUrl({
                  url: item.pageUrl,
                }, router.RouterMode.Single)
                this.pageTranState = true
                return;
              }
              router.pushUrl({
                url: item.pageUrl
              }, router.RouterMode.Single)
              this.pageTranState = true
            }
          },
          onMouseClickHandle:async (item:SettingItemTvModel)=>{
            if (item.name === "有线网络") {
              if (!this.enableEthernet) {
                return;
              }
            } else if (item.name === NETWORK_MONITOR_TITLE) {
              await this.isWifiNetworkEnable();
              router.pushUrl({
                url: item.pageUrl,
                params: {
                  isWifiEnable: this.isWifiEnable
                }
              }, router.RouterMode.Single)
              this.pageTranState = true
              return;
            } else if (item.name == wirelessNetwork) {
              if (this.enableEthernet) {
                return;
              }
            }
            router.pushUrl({
              url: item.pageUrl
            }, router.RouterMode.Single)
            this.pageTranState = true
          },
          onFocusHandle: (item: SettingItemTvModel) => {
            this.imageUrl = item.imageUrl;
            this.des = item.description;
          }
        })
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
          .margin({ left: lpx(84) })

        SettingItemDesLayout({ imageUrl: this.imageUrl, des: this.des })//          .backgroundColor(Color.Red)
          .width(ConfigData.WH_48_100)
          .height(ConfigData.WH_100_100)
      }
    }
  }

  getSlConnectedWifi(ssid: string, bssid: string, rssi: number, band: number, frequency: number, timestamp: number,
    securityType: wifiManager.WifiSecurityType): WifiScanInfo {
    return {
      ssid: ssid,
      bssid: bssid,
      rssi: rssi,
      band: band,
      frequency: frequency,
      timestamp: timestamp,
      securityType: securityType
    }
  }

  getssid() {
    WifiModel.getLinkedWifiInfo().then((wifi: wifiManager.WifiLinkedInfo|null) => {
      if (!wifi) {
        return;
      }
      this.ssid = wifi.ssid;
      this.slConnectedWifi.settingTitle = wifi.ssid;
      let signalLevel: string = wifiManager.getSignalLevel(wifi.rssi, wifi.band).toString();
      let lockPrefix: string = 'lock_';
      try {
        let scanInfoList = wifiManager.getScanInfoList();
        let resArrItem = scanInfoList.find(item => {
          return item.ssid == this.ssid
        })
        if (!resArrItem) {
          this.slConnectedWifi.settingArrow = "";
          this.slConnectedWifi.apInfo = this.getSlConnectedWifi("", "", 0, 0, 0, 0, 0);
        } else {
          if (resArrItem.securityType == 1) {
            lockPrefix = '';
          }
          let result: string = `/res/image/ic_wifi_${lockPrefix}signal_${signalLevel}_dark.svg`;
          this.slConnectedWifi.settingArrow = result
          this.slConnectedWifi.apInfo =
            this.getSlConnectedWifi(resArrItem.ssid, resArrItem.bssid, resArrItem.rssi, resArrItem.band,
              resArrItem.frequency, resArrItem.timestamp, resArrItem.securityType);
        }
      } catch (error) {
        this.slConnectedWifi.settingArrow = "";
        this.slConnectedWifi.apInfo = this.getSlConnectedWifi("", "", 0, 0, 0, 0, 0);
        LogUtil.info('error msg is' + error)
      }
    })
  }

  getActiveIface() {
    ethernet.getAllActiveIfaces().then((activity: string[]) => {
      this.activities = activity;
      if (this.activities.length === 0) {
        //第一项亮，第二项暗
        this.isEnable = false
        this.settingList[0].setIsEnable(true)
        this.settingList[0].setIsDisableFocus(false)
        this.settingList[1].setIsEnable(false)
        this.settingList[1].setIsDisableFocus(true)
        this.getssid();
        AppStorage.setOrCreate('linkWifiOff', true);
      } else {
        //第一项暗，第二项亮
        this.isEnable = true
        this.settingList[1].setIsEnable(true)
        this.settingList[1].setIsDisableFocus(false)
        setTimeout(() => {
          this.settingList[0].setIsEnable(false)
          this.settingList[0].setIsDisableFocus(true)
        }, 50)
        AppStorage.setOrCreate('linkWifiOff', false);
      }
      this.enableEthernet = this.isEnable;
    })
  }

  async aboutToAppear() {
    this.getActiveIface();
    let item = new SettingItemTvModel();
    item.name = wirelessNetwork;
    item.pageUrl = "pages/network/wifi"
    item.imageUrl = Ratio.resName('icon_wifi')
    item.description = "连接无线网络"
    item.chooseDes = this.ssid;
    item.style = SettingItemStyle.default
    item.isEnable = this.enableEthernet

    let item1 = new SettingItemTvModel();
    item1.name = '有线网络';
    item1.pageUrl = "pages/network/wiredNetwork";
    item1.imageUrl = Ratio.resName('manualNetwork')
    item1.description = "连接有线网络"
    item1.style = SettingItemStyle.default
    item1.isEnable = !this.enableEthernet

    let item2 = new SettingItemTvModel();
    item2.name = NETWORK_MONITOR_TITLE;
    item2.pageUrl = NETWORK_MONITOR_URL
    if(this.enableEthernet){
      item2.imageUrl = Ratio.resName('icon_wifi')
    }else{
      item1.imageUrl = Ratio.resName('manualNetwork')
    }
    item2.description = NETWORK_MONITOR_TITLE
    item2.style = SettingItemStyle.default

    let item3 = new SettingItemTvModel();
    item3.name = NETWORK_SPEED_TITLE;
    item3.pageUrl = NETWORK_SPEED_URL
    if(this.enableEthernet){
      item2.imageUrl = Ratio.resName('icon_wifi')
    }else{
      item1.imageUrl = Ratio.resName('manualNetwork')
    }
    item3.description = NETWORK_SPEED_TITLE
    item3.style = SettingItemStyle.default

    let item4 = new SettingItemTvModel();
    item4.name = '个人热点';
    item4.pageUrl = NETWORK_PERSONAL_HOTSPOT_URL
    item4.imageUrl = Ratio.resName('icon_wifi')
    item4.description = NETWORK_PERSONAL_HOTSPOT_TITLE
    item4.style = SettingItemStyle.default
    this.settingList.push(item, item1, item2, item3, item4);

    this.scanTaskId = setInterval(() => {
      this.getActiveIface();
    }, 1000);
  }

  aboutToDisappear(): void {
    clearInterval(this.scanTaskId);
  }

  async isEnableEthernet() {
    console.log("NetWorkComponent isEnableEthernet is begin!")
    let iFaces: string[] = await ethernet.getAllActiveIfaces();
    let enable = iFaces.length > 0;
    return enable;
  }

  onConnectedWifiChange() {
    for (let i = 0; this.settingList.length; i++) {
      if (this.settingList[i].name == wirelessNetwork) {
        this.settingList[i].setChooseDes(this.slConnectedWifi.settingTitle)
        break;
      }
    }
  }

  // 获取当前网络是否是WIFI类型, 1：wifi 3：Ethernet
  async isWifiNetworkEnable() {
    console.debug('NetWorkComponent isWifiNetworkEnable.');
    let netHandle = await connection.getDefaultNet();
    if (netHandle.netId == 0) {
      console.error('NetWorkComponent netId is 0!');
      return;
    }

    let netCapabilities = await connection.getNetCapabilities(netHandle);
    if (!netCapabilities) {
      console.error("NetWorkComponent netCapabilities error! ");
      return;
    }
    this.isWifiEnable = netCapabilities.bearerTypes.includes(connection.NetBearType.BEARER_WIFI);
    console.debug('NetWorkComponent isWifiNetworkEnable = ' + this.isWifiEnable);
  }
}