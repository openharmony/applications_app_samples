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
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import BaseModel from '../../../../../../../common/utils/src/main/ets/default/model/BaseModel';
import wifiManager  from '@ohos.wifiManager';
import settings from '@ohos.settings';
import data_dataShare from '@ohos.data.dataShare';
import { promptAction } from '@kit.ArkUI';

const MODULE_TAG = ConfigData.TAG + 'WifiModel -> ';
const undefinedTaskId = -1;

export interface WifiScanInfo {
  ssid: string,
  bssid: string,
  securityType: wifiManager.WifiSecurityType,
  rssi: number,
  band: number,
  frequency: number,
  timestamp: number,
}

interface StaticIp {
  ipAddress: number
  gateway: number
  dnsServers: number[]
}

interface WifiConfig {
  ipType?: number
  staticIp?: StaticIp
}

interface ThrottleOptions {
  leading: boolean
  trailing: boolean
}

type CallbackArg = string | number | boolean | Object | null | undefined
type DelayCallback = (...args: CallbackArg[]) => void

class WifiConfigChildren implements WifiConfig {
  ipType?: number = 0
  staticIp?: StaticIp = {
    ipAddress: 0,
    gateway: 0,
    dnsServers: []
  }
}

export interface ScanWifi {
  settingIcon: string,
  settingSummary: number,
  settingTitle: string,
  settingValue: string,
  settingArrow: string,
  settingArrowStyle: string,
  settingUri: string,
  apInfo: WifiScanInfo,
}

export enum WiFiSummaryMap {
  CONNECTED,
  CONNECTING,
  SAVE_ENCRYPTED,
  SAVE_OPEN,
  ENCRYPTED,
  OPEN,
  OBTAINING_IP,
  CONNECTED_PRO
}

export enum WiFiIntensityMap {
  GOOD,
  WELL,
  NORMAL,
  BAD,
}

export enum WiFiEncryptMethodMap {
  OPEN,
  WEP,
  WPA,
  WPA2,
}

export class ApScanResult {
  private apInfo: WifiScanInfo = {
    ssid: '',
    bssid: '',
    rssi: -100,
    band: 0,
    frequency: 0,
    timestamp: 0,
    securityType: 0,
  };
  private connectStatus: number = wifiManager.ConnState.UNKNOWN;
  private isSaved: boolean = false;

  constructor(apInfo?: WifiScanInfo) {
    if (apInfo === null || apInfo === undefined) {
      return;
    }
    this.apInfo = apInfo;
    LogUtil.debug(MODULE_TAG + 'constructor=='+JSON.stringify(this.apInfo));
  };

  static fromDeviceConfig(config: wifiManager.WifiDeviceConfig): ApScanResult {
    const mockScanInfo: WifiScanInfo = {
      ssid: config.ssid || '',
      bssid: config.bssid || '',
      rssi: -100,
      band: 0,
      frequency: 2412,
      timestamp: Date.now(),
      securityType: config.securityType || 0
    };
    return new ApScanResult(mockScanInfo);
  }

  getApInfo(): WifiScanInfo {
    return this.apInfo;
  }

  getSignalLevel(): number {
    try {
      return wifiManager.getSignalLevel(this.apInfo.rssi, this.apInfo.band);
    } catch (error) {
      LogUtil.error(MODULE_TAG + 'getSignalLevel failed: ' + JSON.stringify(error));
      return 0;
    }
  }

  isConnected(): boolean {
    return this.connectStatus === wifiManager.ConnState.CONNECTED;
  }

  isSavedConfig(): boolean {
    return this.isSaved === true;
  }

  isSecurityAp(): boolean {
    // WiFiSecurityType is enum from 0 to 4, 0 is `Invalid`, 1 is `Open`, 2 to 4 is `Encrypted`
    return (this.apInfo.securityType !== 1);
  }

  isValidAp(): boolean {
    // no ssid or signal level 0 is invalid
    return (this.apInfo.ssid !== '' && this.getSignalLevel() != 0);
  }

  updateConnectStatus(status: number): void {
    this.connectStatus = status;
  }

  updateSavedStatus(status: boolean): void {
    this.isSaved = status;
  }


  private generateArrow(): string {
    let signalLevel: string = this.getSignalLevel().toString();
    let lockPrefix: string = 'lock_';
    if (this.isSecurityAp() !== true) {
      if (this.isConnected()) {
        lockPrefix = 'warn_';
        signalLevel = '4'
      } else {
        lockPrefix = ''
      }
    }
    return `/res/image/ic_wifi_${lockPrefix}signal_${signalLevel}_dark.svg`;
  }

  private generateSummary(): number {
    if (this.isConnected()) {
      if (this.isSecurityAp()) {
        return WiFiSummaryMap.CONNECTED;
      }
      const flag = AppStorage.get(this.apInfo.ssid) as boolean | undefined
      if (flag) {
        return WiFiSummaryMap.CONNECTED;
      }
      return WiFiSummaryMap.CONNECTED_PRO;
    }
    if (this.connectStatus === wifiManager.ConnState.CONNECTING) {
      return WiFiSummaryMap.CONNECTING;
    }
    if (this.connectStatus === wifiManager.ConnState.OBTAINING_IPADDR) {
      return WiFiSummaryMap.OBTAINING_IP;
    }
    if (this.isSavedConfig()) {
      if (this.isSecurityAp()) {
        return WiFiSummaryMap.SAVE_ENCRYPTED;
      }
      return WiFiSummaryMap.SAVE_OPEN;
    }
    if (this.isSecurityAp()) {
      return WiFiSummaryMap.ENCRYPTED;
    }
    return WiFiSummaryMap.OPEN;
  }

  renderToListModel(): ScanWifi {
    let ret: ScanWifi = {
      settingIcon: '',
      settingSummary: this.generateSummary(),
      settingTitle: this.apInfo.ssid,
      settingValue: '',
      settingArrow: this.generateArrow(),
      settingArrowStyle: 'wifi',
      settingUri: '',
      apInfo: this.apInfo,
    };
    LogUtil.debug(MODULE_TAG + 'renderToListModel'+JSON.stringify(ret));
    return ret;
  }

  toString(): string {
    return `apInfo is: ssid=${this.getApInfo().ssid} signal=${this.getSignalLevel()} isConnected=${this.isConnected()}`;
  }

  static compare(x: ApScanResult, y: ApScanResult): number {
    let xApInfo = x.getApInfo();
    let yApInfo = y.getApInfo();
    // rssi value is negative number
    return ((-xApInfo.rssi) - (-yApInfo.rssi));
  }

  static filter(arr: ApScanResult[]): ApScanResult[] {
    const seenSsids = new Set<string>();
    return arr.filter(item => {
      const ssid = item.getApInfo().ssid;
      if (seenSsids.has(ssid)) {
        return false;
      }
      seenSsids.add(ssid);
      return true;
    });
  }

  static index(arr: ApScanResult[], target: ApScanResult): number {
    return arr.map((item) => {
      return item.getApInfo().ssid;
    }).indexOf(target.getApInfo().ssid);
  }
}

export class WifiModel extends BaseModel {
  private userSelectedAp: ApScanResult = new ApScanResult();
  private linkedApInfo: wifiManager.WifiLinkedInfo | null = null;
  private scanTaskId: number = undefinedTaskId;
  private isScanning: boolean = false;
  private isRefreshing: boolean = false;
  private dataShareHelper: data_dataShare.DataShareHelper | null = null;
  private readonly listenUri = 'dataShare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=' + ConfigData.SETTINGSDATA_WIFI;

  constructor() {
    super();
    if (!globalThis.settingsAbilityContext) {
      LogUtil.info(`global context settingsAbilityContext is null`);
      return;
    }
    data_dataShare.createDataShareHelper(globalThis.settingsAbilityContext, this.listenUri)
      .then((dataHelper) => {
        this.dataShareHelper = dataHelper;
        LogUtil.info('createDataShareHelper success');
        LogUtil.debug('createDataShareHelper state: ' + !!this.dataShareHelper);
      })
      .catch((error: Error) => {
        LogUtil.error('createDataShareHelper failed:' + JSON.stringify(error));
      });
  }

  setSettingsData(scanWiFiResults: WifiScanInfo[]): void {
    try {
      for (let i = 0; i < scanWiFiResults.length; i++) {
        const process = [scanWiFiResults[i]];
        settings.setValueSync(
          globalThis.settingsAbilityContext, 
          ConfigData.SETTINGSDATA_WIFI, 
          JSON.stringify(process), 
          settings.domainName.DEVICE_SHARED
        );
      }
    } catch (error) {
      LogUtil.error('setSettingsData failed:' + JSON.stringify(error));
    }
  }

  getSettingData(): string {
    try {
      const scanWifiList = settings.getValueSync(
        globalThis.settingsAbilityContext, 
        ConfigData.SETTINGSDATA_WIFI, 
        '', 
        settings.domainName.DEVICE_SHARED
      );
      if (scanWifiList) {
        LogUtil.debug('slWiFiLists: ' + scanWifiList);
      }
      return scanWifiList;
    } catch (error) {
      LogUtil.error('getSettingData failed:' + JSON.stringify(error));
      return '';
    }
  }

  destroyWiFiModelData(): void {
    this.linkedApInfo = null;
    this.setUserSelectedAp(null);
    AppStorage.setOrCreate('slWiFiLists', []);
    AppStorage.setOrCreate('slConnectedWifi', (new ApScanResult()).renderToListModel());
  }

  registerWiFiStatusObserver(callback: (state: number) => void): void {
    LogUtil.info(MODULE_TAG + 'start register wifi status observer');
    try {
      wifiManager.on('wifiStateChange', callback);
    } catch (error) {
      LogUtil.error(MODULE_TAG + 'register wifi status observer failed: ' + JSON.stringify(error));
    }
  }

  unregisterWiFiStatusObserver(): void {
    LogUtil.info(MODULE_TAG + 'start unregister wifi status observer');
    try {
      wifiManager.off('wifiStateChange')
    } catch (error) {
      LogUtil.error(MODULE_TAG + 'unregister wifi status observer failed: ' + JSON.stringify(error));
    }
  }

  registerWiFiConnectionObserver(callback: () => void) : void {
    LogUtil.info(MODULE_TAG + 'start register wifi connection observer');
    try {
      wifiManager.on('wifiConnectionChange', callback);
    } catch (error) {
      LogUtil.error(MODULE_TAG + 'register wifi connection observer failed: ' + JSON.stringify(error));
    }
  }

  unregisterWiFiConnectionObserver(): void {
    LogUtil.info(MODULE_TAG + 'start unregister wifi connection observer');
    try {
      wifiManager.off('wifiConnectionChange');
    } catch (error) {
      LogUtil.error('wifiConnectionChange failed:' + JSON.stringify(error));
    }
  }

  setUserSelectedAp(apInfo?: WifiScanInfo | null): void {
    if (apInfo === null || apInfo === undefined) {
      this.userSelectedAp = new ApScanResult();
    } else {
      this.userSelectedAp = new ApScanResult(apInfo);
    }
  }

  isSavedAp(ssid: string): boolean {
    try {
      const deviceConfigs = wifiManager.getDeviceConfigs();
      return deviceConfigs.some(config => config.ssid === ssid);
    } catch (error) {
      LogUtil.error('isSavedAp failed:' + JSON.stringify(error));
      return false;
    }
  }

  isWiFiActive(): boolean {
    try {
      const isActive = wifiManager.isWifiActive();
      LogUtil.info(MODULE_TAG + 'check WiFi isActive : ' + isActive);
      return isActive;
    } catch (error) {
      LogUtil.error('isWiFiActive failed:' + JSON.stringify(error));
      return false;
    }
  }

  isWiFiConnected(): boolean {
    try {
      const ret = wifiManager.isConnected();
      LogUtil.info(MODULE_TAG + 'check WiFi connected status is : ' + ret);
      return ret;
    } catch (error) {
      LogUtil.error('isWiFiConnected failed:' + JSON.stringify(error));
      return false;
    }
  }

  isWifEnable(): boolean {
    return this.isWiFiActive();
  }

  enableWiFi(): boolean {
    try {
      const isActive = wifiManager.isWifiActive();
      LogUtil.info(MODULE_TAG + 'enable WiFi result is 0 ' + isActive);
      if (isActive === true) {
        LogUtil.debug(MODULE_TAG + 'wifi is already active');
        return true;
      }
      wifiManager.enableWifi();
      LogUtil.info(MODULE_TAG + 'enable WiFi result is 1 ' + wifiManager.isWifiActive());
      return true;
    } catch (error) {
      LogUtil.error('enable WiFi result is failed:' + JSON.stringify(error));
      return false;
    }
  }

  disableWifi(): void {
    this.setUserSelectedAp(null);
    try {
      if (!wifiManager.isWifiActive()) {
        LogUtil.info(MODULE_TAG + 'wifi is already inactive');
        return;
      }
      wifiManager.disableWifi()
      this.stopScanTask()
      LogUtil.info(MODULE_TAG + 'disable WiFi result is true ');
    } catch (e) {
      LogUtil.error(MODULE_TAG + 'disable WiFi result is : ' + e);
    }
  }

  scanWiFi(): boolean {
    try {
      wifiManager.startScan();
      LogUtil.debug(MODULE_TAG + 'start scan WiFi result is Ok ');
      return true;
    } catch (e) {
      LogUtil.error(MODULE_TAG + 'start scan WiFi failed:' + JSON.stringify(e));
      return false;
    }
  }

  connectWiFi(password: string,tobeConnectedSSID:string): boolean {
    let apInfo = this.userSelectedAp.getApInfo();
    let targetSsid = tobeConnectedSSID || apInfo.ssid;
    let connectParam: wifiManager.WifiDeviceConfig = {
      'ssid': targetSsid,
      'bssid': apInfo.bssid,
      'preSharedKey': password,
      'isHiddenSsid': false, // we don't support connect to hidden ap yet
      'securityType': apInfo.securityType
    };

    try {
      if (wifiManager.isConnected() === true) {
        wifiManager.disconnect();
        LogUtil.info(MODULE_TAG + 'disconnect WIFI: ' + JSON.stringify(connectParam));
      }
      wifiManager.connectToDevice(connectParam);
      LogUtil.info(MODULE_TAG + 'WiFi connect successful: ' + JSON.stringify(connectParam));
      return true;
    } catch (error) {
      LogUtil.error(MODULE_TAG + 'connect WiFi ret is failed,error:' + JSON.stringify(error));
      return false;
    }
  }

  /**
   * Disconnect wifi
   */
  disconnectWiFi(): boolean {
    this.setUserSelectedAp(null);
    try {
      wifiManager.disconnect();
      LogUtil.info(MODULE_TAG + 'disconnect WiFi successful');
      return true;
    } catch (e) {
      LogUtil.error(MODULE_TAG + 'disconnect WiFi result is failed.error: ' + JSON.stringify(e));
      return false;
    }
  }

  removeDeviceConfig(apInfo: WifiScanInfo): void {
    try {
      const deviceConfigs = wifiManager.getDeviceConfigs();
      const networkId = deviceConfigs.find(config => config.ssid === apInfo.ssid)?.netId ?? -1;
      if (networkId === -1) {
        return;
      }
      
      wifiManager.removeDevice(networkId);
      LogUtil.debug(MODULE_TAG + 'removeDeviceConfig success: ' + apInfo.ssid);
    } catch (error) {
      LogUtil.error(MODULE_TAG + 'removeDeviceConfig failed:' + JSON.stringify(error));
    }
  }

  async connectByDeviceConfig(apInfo: WifiScanInfo): Promise<boolean> {
    try {
      const deviceConfigs = wifiManager.getDeviceConfigs();
      
      for (let i = 0; i < deviceConfigs.length; i++) {
        if (deviceConfigs[i].ssid === apInfo.ssid) {
          LogUtil.debug(MODULE_TAG + 'start wifiManager.connectToDevice');
          wifiManager.connectToDevice(deviceConfigs[i]);
          LogUtil.debug(MODULE_TAG + 'connect initiated for SSID: ' + apInfo.ssid);
          
          // 等待连接结果
          return await this.waitForConnection(apInfo, deviceConfigs[i], 50);
        }
      }
      
      // 未找到配置
      LogUtil.warn(MODULE_TAG + 'No device config found for SSID: ' + apInfo.ssid);
      promptAction.openToast({
        message: '连接失败',
        duration: 2000,
        bottom: globalThis.screenHeight / 4
      });
      return false;
      
    } catch (error) {
      LogUtil.error(MODULE_TAG + 'connectByDeviceConfig failed: ' + JSON.stringify(error));
      return false;
    }
  }

  private async waitForConnection(
    targetAp: WifiScanInfo,
    config: wifiManager.WifiDeviceConfig,
    maxAttempts: number
  ): Promise<boolean> {
    return new Promise((resolve) => {
      let count = 0;
      const intervalId = setInterval(() => {
        count++;
        LogUtil.debug(MODULE_TAG + 'Checking connection status. Attempt: ' + count);
        
        wifiManager.getLinkedInfo((err, linkInfo) => {
          if (err) {
            LogUtil.error(MODULE_TAG + 'getLinkedInfo error: ' + JSON.stringify(err));
            return;
          }
          
          if (linkInfo.connState === wifiManager.ConnState.CONNECTED) {
            if (linkInfo.ssid === targetAp.ssid) {
              // 成功连接到目标网络
              LogUtil.info(MODULE_TAG + 'Successfully connected to target WiFi: ' + targetAp.ssid);
              clearInterval(intervalId);
              resolve(true);
            } else {
              // 连接到其他网络，重新连接
              this.disconnectWiFi();
              wifiManager.connectToDevice(config);
              count = 0; // 重置计数
            }
          }
          
          // 超时处理
          if (count >= maxAttempts) {
            LogUtil.error(MODULE_TAG + 'Connection timed out after ' + maxAttempts + ' attempts.');
            promptAction.openToast({
              message: $r('app.string.wifiTipsConnectAuthFailed'),
              duration: 2000,
              bottom: globalThis.screenHeight / 4
            });
            clearInterval(intervalId);
            this.removeDeviceConfig(targetAp);
            resolve(false);
          }
        });
      }, 500);
    });
  }

  private getSavedConfigs(): ApScanResult[] {
    try {
      const deviceConfigs = wifiManager.getDeviceConfigs() || [];
      return deviceConfigs.map(config => ApScanResult.fromDeviceConfig(config));
    } catch (e) {
      LogUtil.warn(`${MODULE_TAG} Failed to get device configs: ` + JSON.stringify(e));
      return [];
    }
  }

  private markSavedNetworks(
    scanResults: ApScanResult[],
    savedConfigs: ApScanResult[]
  ): ApScanResult[] {
    const ssidSet = new Set(savedConfigs.map(c => c.getApInfo().ssid));

    return scanResults.map(ap => {
      if (ssidSet.has(ap.getApInfo().ssid)) {
        ap.updateSavedStatus(true);
      }
      return ap;
    });
  }

  private processScanResults(scanInfoList: WifiScanInfo[]): ApScanResult[] {
    // 1. 去重 + 过滤无效AP
    let results = scanInfoList
      .map(info => new ApScanResult(info))
      .filter(ap => ap.isValidAp());

    results = ApScanResult.filter(results); // 静态去重方法

    // 2. 标记已保存的网络
    const savedConfigs = this.getSavedConfigs();
    results = this.markSavedNetworks(results, savedConfigs);

    // 3. 排序
    results.sort(ApScanResult.compare);

    return results;
  }

  private async handleConnectedAp(scanResults: ApScanResult[]): Promise<ApScanResult[]> {
    if (!this.linkedApInfo?.ssid) {
      this.updateConnectedWifiState(null);
      return scanResults;
    }
    
    // 查找已连接的AP
    const connectedAp = scanResults.find(
      ap => ap.getApInfo().ssid === this.linkedApInfo!.ssid
    );

    if (!connectedAp) {
      // 未在扫描结果中找到已连接AP（可能信号弱）
      this.updateConnectedWifiState(null);
      return scanResults;
    }

    // 更新连接状态
    connectedAp.updateConnectStatus(this.linkedApInfo.connState);

    if (connectedAp.isConnected()) {
      // 已连接：从列表移除，并更新全局连接状态
      const filteredResults = scanResults.filter(
        ap => ap.getApInfo().ssid !== connectedAp.getApInfo().ssid
      );
      this.updateConnectedWifiState(connectedAp);
      return filteredResults;
    } else {
      // 连接中：移到列表顶部
      const filtered = scanResults.filter(
        ap => ap.getApInfo().ssid !== connectedAp.getApInfo().ssid
      );
      filtered.unshift(connectedAp);
      this.updateConnectedWifiState(null);
      return filtered;
    }
  }

  private updateConnectedWifiState(connectedAp: ApScanResult | null): void {
    const newConnectedWifi = connectedAp
      ? connectedAp.renderToListModel()
      : new ApScanResult().renderToListModel();
    
    const existWifi = AppStorage.get('slConnectedWifi') as ScanWifi | undefined;
    if (!existWifi || existWifi.settingTitle !== newConnectedWifi.settingTitle) {
      AppStorage.setOrCreate('slConnectedWifi', newConnectedWifi);
    }
  }

  async refreshApScanResults(): Promise<void> {
    // 防止并发执行
    if (this.isRefreshing) {
      LogUtil.debug(`${MODULE_TAG} refreshApScanResults is already running, skip`);
      return;
    }
    this.isRefreshing = true;

    try {
      LogUtil.info(`${MODULE_TAG} refreshApScanResults start`);
      // Step 1: 获取当前连接信息
      this.linkedApInfo = await this.getLinkedWifiInfo();
      // Step 2: 获取扫描列表
      const scanInfoList: WifiScanInfo[] = wifiManager.getScanInfoList() || [];
      LogUtil.debug(`${MODULE_TAG} Raw scan results count: ${scanInfoList.length}`);
      // Step 3: 处理扫描结果
      let processedResults = this.processScanResults(scanInfoList);
      // Step 4: 处理已连接的AP
      if (this.linkedApInfo?.ssid) {
        processedResults = await this.handleConnectedAp(processedResults);
      }
      // Step 5: 更新全局状态
      AppStorage.setOrCreate(
        'slWiFiLists',
        processedResults.map((item: ApScanResult): ScanWifi => item.renderToListModel())
      );
      LogUtil.info(`${MODULE_TAG} Refresh completed, final count: ${processedResults.length}`);
    } catch (error) {
      LogUtil.error(`${MODULE_TAG} Refresh failed: ` + JSON.stringify(error));
      // 即使失败也要确保UI有默认状态
      AppStorage.setOrCreate('slWiFiLists', []);
    } finally {
      this.isRefreshing = false;
    }
  }

  startScanTask(): void {
    LogUtil.debug(MODULE_TAG + 'start the wifi scan task');
    if (this.scanTaskId !== undefinedTaskId) {
      clearInterval(this.scanTaskId);
      this.scanTaskId = undefinedTaskId;
    }

    this.scanTaskId = setInterval(() => {
      if (this.isWiFiActive() === true && this.isScanning === true) {
        this.refreshApScanResults();
        return;
      }
      if (this.isWiFiActive() === true && this.scanWiFi() === true) {
        this.isScanning = true;
        this.refreshApScanResults();
      }
    }, 1000);
  }

  stopScanTask(): void {
    LogUtil.debug(MODULE_TAG + 'stop the wifi scan task');
    if (this.scanTaskId !== undefinedTaskId) {
      clearInterval(this.scanTaskId);
      this.scanTaskId = undefinedTaskId;
    }
    this.isScanning = false;
  }

  async getLinkedWifiInfo(): Promise<wifiManager.WifiLinkedInfo | null> {
    try {
      const linkInfo = await wifiManager.getLinkedInfo();
      LogUtil.debug(MODULE_TAG + `getLinkedWifiInfo, Result: ` + JSON.stringify(linkInfo));
      return linkInfo;
    } catch (error) {
      LogUtil.warn(`getLinkedWifiInfo failed:` + JSON.stringify(error));
      return null;
    }
  }

  getWifiIpInfo(): wifiManager.IpInfo {
    try {
      return wifiManager.getIpInfo();
    } catch (error) {
      LogUtil.error('getWifiIpInfo failed:' + JSON.stringify(error));
      return {} as wifiManager.IpInfo;
    }
  }

  getLinkedWifiConfig(linkSsid: string): WifiConfigChildren {
    let result: WifiConfigChildren = {
      ipType: 0,
      staticIp: {
        ipAddress: 0,
        gateway: 0,
        dnsServers: []
      }
    };
    
    try {
      const configs = wifiManager.getDeviceConfigs();
      const config = configs.find(c => c.ssid === linkSsid);
      if (config) {
        if (config.ipType !== undefined) {
          result.ipType = config.ipType;
        }
        if (config.staticIp) {
          result.staticIp = {
            ipAddress: config.staticIp.ipAddress,
            gateway: config.staticIp.gateway,
            dnsServers: config.staticIp.dnsServers
          };
        }
      }
    } catch (error) {
      LogUtil.error('getLinkedWifiConfig failed:' + JSON.stringify(error));
    }
    
    return result;
  }

  updateWifiConfig(config: wifiManager.WifiDeviceConfig): boolean {
    try {
      const result = wifiManager.updateNetwork(config);
      return result !== -1;
    } catch (error) {
      LogUtil.error('updateWifiConfig failed:' + JSON.stringify(error));
      return false;
    }
  }


  public debounce = (func: DelayCallback, wait: number, immediate: boolean = false): DelayCallback => {
    let timeout: number = 0;
    return (...args: CallbackArg[]) => {
      if (timeout !== 0) {
        clearTimeout(timeout);
      }

      if (immediate && !timeout) {
        // 如果设置了立即执行且当前没有定时器，则立即调用函数
        func(...args);
      }

      // 设置新的定时器
      timeout = setTimeout(() => {
        if (!immediate) {
          func(...args);
        }
        timeout = 0;
      }, wait);
    };
  };

  public throttle = (func: DelayCallback, wait: number, options: ThrottleOptions = {
    leading: true,
    trailing: true
  }): DelayCallback => {
    let timeout: number = 0;
    let lastExecTime = 0;

    const shouldHandle = (now: number): boolean => {
      if (!lastExecTime) {
        return true;
      }
      if (options.leading === false) {
        lastExecTime = now;
        return false;
      }
      if (now - lastExecTime >= wait) {
        return true;
      }
      return false;
    };

    const later = (args: CallbackArg[]): void => {
      timeout = 0;
      if (options.trailing !== false) {
        lastExecTime = Date.now();
        func(...args);
      }
    };

    return (...args: CallbackArg[]) => {
      const now = Date.now();
      if (shouldHandle(now)) {
        lastExecTime = now;
        func(...args);
      }

      if (timeout === 0 && options.trailing !== false) {
        timeout = setTimeout(later, wait, args);
      }
    };
  };
}

let wifiModel = new WifiModel();
export default wifiModel as WifiModel;

export class IPConvertor {
  public static ipToNumber(ipStr: string): number {
    let ipArray: string[] = ipStr.split('.');
    if (ipArray.length != 4) {
      throw new Error('the input ip is not normal')
    }
    let result: number = 0;
    for (let i = 0; i < ipArray.length; i++) {
      let power = 3 - i;
      let ip: number = parseInt(ipArray[i]);
      result += ip * Math.pow(256, power);
    }
    return result;
  }

  public static numberToIp(ipNum: number): string {
    // 处理负数情况，将其转换为对应的无符号32位整数
    if (ipNum < 0) {
      ipNum = ipNum >>> 0; // 使用无符号右移操作符将负数转换为无符号形式
    }

    // 检查是否超出32位无符号整数范围
    if (ipNum > 0xFFFFFFFF) {
      throw new Error('The number is not normal!');
    }

    return (ipNum >>> 24) + '.' + (ipNum >> 16 & 0xFF) + '.' + (ipNum >> 8 & 0xFF) + '.' + (ipNum & 0xFF);
  }
}
