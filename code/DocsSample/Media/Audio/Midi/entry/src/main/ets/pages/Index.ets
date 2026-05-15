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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { mediaquery } from '@kit.ArkUI';
import { emitter, BusinessError } from '@kit.BasicServicesKit';
import { ble } from '@kit.ConnectivityKit';
import common from '@ohos.app.ability.common';
import preferences from '@ohos.data.preferences';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
import midi, {
  MidiStatusCode,
  MidiPortDirection,
  MidiDeviceType,
  MidiDeviceInfo,
  MidiPortInfo,
  MidiEvent
} from 'libentry.so';

const DOMAIN = 0xFF00;
const TAG = 'MidiSample';

// 异步回调处理的事件ID
const EVENT_DEVICE_CHANGE = 1001;
const EVENT_MIDI_RECEIVED = 1002;
const EVENT_BLE_OPENED = 1003;
const EVENT_ERROR = 1004;

// 事件数据接口
interface DeviceChangeEventData {
  action: number;
  deviceId: number;
  deviceName: string;
  deviceType: number;
  deviceAddress: string;
}

interface MidiReceivedEventData {
  umpData: number[];
}

interface BleOpenedEventData {
  opened: boolean;
  deviceId: number;
  deviceName: string;
  deviceType: number;
  deviceAddress: string;
}

interface ErrorEventData {
  code: number;
  message: string;
}

// 钢琴琴键接口
interface PianoKey {
  note: number;
  name: string;
  isBlack: boolean;
}

// 最近BLE设备接口，用于本地存储
interface RecentBleDevice {
  address: string;
  name: string;
  timestamp: number;
}

// 扫描到的BLE设备接口
interface ScannedBleDevice {
  deviceId: string;
  rssi: number;
  name: string;
}

// 钢琴琴键尺寸接口
interface PianoKeyDimensions {
  whiteKeyWidth: number;
  whiteKeyHeight: number;
  blackKeyWidth: number;
  blackKeyHeight: number;
}

// 响应式设计的断点类型
type BreakpointType = 'xs' | 'sm' | 'md' | 'lg';

// 断点尺寸接口 - 定义各断点的值
interface BreakpointSizes {
  xs: number;
  sm: number;
  md: number;
  lg: number;
}

// 字体大小配置接口
interface FontSizesConfig {
  title: BreakpointSizes;
  subtitle: BreakpointSizes;
  body: BreakpointSizes;
  caption: BreakpointSizes;
  small: BreakpointSizes;
  pianoKey: BreakpointSizes;
}

// 响应式字体大小配置
const FONT_SIZES: FontSizesConfig = {
  title: { xs: 18, sm: 20, md: 24, lg: 28 },
  subtitle: { xs: 14, sm: 16, md: 16, lg: 18 },
  body: { xs: 12, sm: 14, md: 14, lg: 14 },
  caption: { xs: 12, sm: 12, md: 12, lg: 12 },
  small: { xs: 10, sm: 10, md: 10, lg: 10 },
  pianoKey: { xs: 6, sm: 7, md: 8, lg: 8 }
};

// 辅助函数：获取字体大小（避免动态索引访问）
function getFontSize(config: FontSizesConfig, category: keyof FontSizesConfig, breakpoint: BreakpointType): number {
  let sizes: BreakpointSizes;
  switch (category) {
    case 'title':
      sizes = config.title;
      break;
    case 'subtitle':
      sizes = config.subtitle;
      break;
    case 'body':
      sizes = config.body;
      break;
    case 'caption':
      sizes = config.caption;
      break;
    case 'small':
      sizes = config.small;
      break;
    case 'pianoKey':
      sizes = config.pianoKey;
      break;
    default:
      sizes = config.body;
      break;
  }
  switch (breakpoint) {
    case 'xs':
      return sizes.xs;
    case 'sm':
      return sizes.sm;
    case 'md':
      return sizes.md;
    case 'lg':
      return sizes.lg;
    default:
      return sizes.md;
  }
}

// 钢琴琴键配置（C4到C5，一个八度）
const WHITE_KEYS: PianoKey[] = [
  { note: 60, name: 'C4', isBlack: false },
  { note: 62, name: 'D4', isBlack: false },
  { note: 64, name: 'E4', isBlack: false },
  { note: 65, name: 'F4', isBlack: false },
  { note: 67, name: 'G4', isBlack: false },
  { note: 69, name: 'A4', isBlack: false },
  { note: 71, name: 'B4', isBlack: false },
  { note: 72, name: 'C5', isBlack: false }
];

const BLACK_KEYS: PianoKey[] = [
  { note: 61, name: 'C#4', isBlack: true },
  { note: 63, name: 'D#4', isBlack: true },
  { note: 66, name: 'F#4', isBlack: true },
  { note: 68, name: 'G#4', isBlack: true },
  { note: 70, name: 'A#4', isBlack: true }
];

@Entry
@Component
struct Index {
  @State message: string = 'MIDI Sample';
  @State clientCreated: boolean = false;
  @State deviceList: MidiDeviceInfo[] = [];
  @State selectedDeviceId: number = -1;
  @State portList: MidiPortInfo[] = [];
  @State inputPorts: MidiPortInfo[] = [];
  @State outputPorts: MidiPortInfo[] = [];
  @State logMessages: string[] = []; // 改用数组以提升性能
  @State isDeviceOpen: boolean = false;
  @State openInputPorts: Set<number> = new Set<number>();
  @State openOutputPorts: Set<number> = new Set<number>();
  @State receivedMessages: string[] = []; // 改用数组以提升性能
  @State channelValue: number = 0;
  @State activeKeys: Set<number> = new Set<number>();
  @State keyDimensions: PianoKeyDimensions = {
    whiteKeyWidth: 40, whiteKeyHeight: 140, blackKeyWidth: 28, blackKeyHeight: 90
  };

  // BLE相关状态
  @State bleDeviceAddress: string = '';
  @State bleScanning: boolean = false;
  @State bleDeviceList: MidiDeviceInfo[] = [];
  @State bleConnecting: boolean = false;
  @State recentBleDevices: RecentBleDevice[] = []; // 最近连接的BLE设备，用于快速访问
  @State scannedBleDevices: ScannedBleDevice[] = []; // 扫描到的BLE MIDI设备
  @State bleScanError: string = ''; // BLE扫描错误消息

  // 响应式设计状态
  @State currentBreakpoint: BreakpointType = 'md';

  // 媒体查询监听器
  private xsMediaQueryListener: mediaquery.MediaQueryListener | null = null;
  private smMediaQueryListener: mediaquery.MediaQueryListener | null = null;
  private mdMediaQueryListener: mediaquery.MediaQueryListener | null = null;
  private lgMediaQueryListener: mediaquery.MediaQueryListener | null = null;
  private breakpointDebounceTimer: number = -1;

  private logScroller: Scroller = new Scroller();
  private midiInputScroller: Scroller = new Scroller();
  private pianoScroller: Scroller = new Scroller();
  private scrollDebounceTimer: number = -1;
  private preferencesStore: preferences.Preferences | null = null;
  private readonly MAX_LOG_ENTRIES: number = 100;
  private readonly MAX_MIDI_ENTRIES: number = 50;
  private readonly MAX_RECENT_DEVICES: number = 5;

  aboutToAppear(): void {
    hilog.info(DOMAIN, TAG, '[aboutToAppear] ++enter');
    // 设置响应式设计的媒体查询监听器
    this.setupMediaQueryListeners();
    // 注册异步回调处理的事件监听器
    this.registerEventListeners();
    // 初始化最近设备的偏好设置
    this.initPreferences();
    this.log('MIDI Sample initialized');
    this.log('Tap "Create Client" to start');
    this.log('Use BLE section to connect Bluetooth MIDI devices');
    hilog.info(DOMAIN, TAG, '[aboutToAppear] --exit');
  }

  aboutToDisappear(): void {
    hilog.info(DOMAIN, TAG, '[aboutToDisappear] ++enter');
    // 拆除响应式设计的媒体查询监听器
    this.teardownMediaQueryListeners();
    // 如果正在扫描则停止BLE扫描
    if (this.bleScanning) {
      this.stopBleScan();
    }
    this.unregisterEventListeners();
    this.cleanup();
    hilog.info(DOMAIN, TAG, '[aboutToDisappear] --exit');
  }

  // 注册事件监听器，在主线程处理回调
  registerEventListeners(): void {
    hilog.info(DOMAIN, TAG, '[registerEventListeners] ++enter');

    // 设备变更事件
    emitter.on({ eventId: EVENT_DEVICE_CHANGE }, (eventData: emitter.EventData) => {
      const data: DeviceChangeEventData = eventData.data as DeviceChangeEventData;
      hilog.info(DOMAIN, TAG,
        '[registerEventListeners] received EVENT_DEVICE_CHANGE, deviceId=%{public}d', data.deviceId);
      this.handleDeviceChange(data);
    });

    // MIDI数据接收事件
    emitter.on({ eventId: EVENT_MIDI_RECEIVED }, (eventData: emitter.EventData) => {
      const data: MidiReceivedEventData = eventData.data as MidiReceivedEventData;
      hilog.info(DOMAIN, TAG,
        '[registerEventListeners] received EVENT_MIDI_RECEIVED, dataCount=%{public}d', data.umpData.length);
      this.handleMidiReceived(data.umpData);
    });

    // BLE设备已打开事件
    emitter.on({ eventId: EVENT_BLE_OPENED }, (eventData: emitter.EventData) => {
      const data: BleOpenedEventData = eventData.data as BleOpenedEventData;
      hilog.info(DOMAIN, TAG,
        '[registerEventListeners] received EVENT_BLE_OPENED, opened=%{public}s', data.opened.toString());
      this.handleBleOpened(data);
    });

    // 错误事件
    emitter.on({ eventId: EVENT_ERROR }, (eventData: emitter.EventData) => {
      const data: ErrorEventData = eventData.data as ErrorEventData;
      hilog.error(DOMAIN, TAG,
        '[registerEventListeners] received EVENT_ERROR, code=%{public}d, message=%{public}s',
        data.code, data.message);
      this.handleMidiError(data);
    });

    hilog.info(DOMAIN, TAG, '[registerEventListeners] --exit, events registered: %{public}d, %{public}d, %{public}d, %{public}d',
      EVENT_DEVICE_CHANGE, EVENT_MIDI_RECEIVED, EVENT_BLE_OPENED, EVENT_ERROR);
  }

  unregisterEventListeners(): void {
    hilog.info(DOMAIN, TAG, '[unregisterEventListeners] ++enter');
    emitter.off(EVENT_DEVICE_CHANGE);
    emitter.off(EVENT_MIDI_RECEIVED);
    emitter.off(EVENT_BLE_OPENED);
    emitter.off(EVENT_ERROR);
    hilog.info(DOMAIN, TAG, '[unregisterEventListeners] --exit, all events unregistered');
  }

  // 初始化偏好设置，用于存储最近的BLE设备
  async initPreferences(): Promise<void> {
    try {
      // 使用getUIContext().getHostContext()替代已废弃的getContext
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      this.preferencesStore = await preferences.getPreferences(context, 'midi_recent_devices');
      await this.loadRecentBleDevices();
      hilog.info(DOMAIN, TAG, '[initPreferences] preferences initialized');
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[initPreferences] failed: %{public}s', JSON.stringify(e));
    }
  }

  // 从偏好设置加载最近的BLE设备
  async loadRecentBleDevices(): Promise<void> {
    if (!this.preferencesStore) {
      return;
    }
    try {
      const devicesJson = await this.preferencesStore.get('recent_ble_devices', '[]') as string;
      const parsed: RecentBleDevice[] = JSON.parse(devicesJson) as RecentBleDevice[];
      this.recentBleDevices = parsed;
      hilog.info(DOMAIN, TAG, '[loadRecentBleDevices] loaded %{public}d devices', this.recentBleDevices.length);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[loadRecentBleDevices] failed: %{public}s', JSON.stringify(e));
    }
  }

  // 将最近的BLE设备保存到偏好设置
  async saveRecentBleDevices(): Promise<void> {
    if (!this.preferencesStore) {
      return;
    }
    try {
      await this.preferencesStore.put('recent_ble_devices', JSON.stringify(this.recentBleDevices));
      await this.preferencesStore.flush();
      hilog.info(DOMAIN, TAG, '[saveRecentBleDevices] saved %{public}d devices', this.recentBleDevices.length);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[saveRecentBleDevices] failed: %{public}s', JSON.stringify(e));
    }
  }

  // 将设备添加到最近列表
  async addRecentBleDevice(address: string, name: string): Promise<void> {
    // 移除相同地址的已有条目
    this.recentBleDevices = this.recentBleDevices.filter(d => d.address !== address);
    // 在列表开头添加新条目
    this.recentBleDevices.unshift({
      address: address,
      name: name || 'BLE MIDI Device',
      timestamp: Date.now()
    });
    // 仅保留最大数量的设备
    if (this.recentBleDevices.length > this.MAX_RECENT_DEVICES) {
      this.recentBleDevices = this.recentBleDevices.slice(0, this.MAX_RECENT_DEVICES);
    }
    await this.saveRecentBleDevices();
  }

  // 从最近列表中移除设备
  async removeRecentBleDevice(address: string): Promise<void> {
    this.recentBleDevices = this.recentBleDevices.filter(d => d.address !== address);
    await this.saveRecentBleDevices();
  }

  // BLE扫描器方法
  private bleScanner: ble.BleScanner = ble.createBleScanner();
  private bleScanTimer: number = -1; // BLE扫描超时定时器


  // BLE设备发现回调
  onBleDeviceFound = (scanReport: ble.ScanReport): void => {
    hilog.info(DOMAIN, TAG, '[onBleDeviceFound] received scan report');

    // scanResult是数组，遍历每个结果
    if (!scanReport.scanResult || scanReport.scanResult.length === 0) {
      return;
    }

    for (const result of scanReport.scanResult) {
      const deviceId: string = result.deviceId;
      const rssi: number = result.rssi;
      // ScanResult可能没有localName，使用'Unknown'作为默认值
      // 如需要可从广播数据中解析设备名称
      const name: string = result.deviceName;

      // 检查是否已在列表中
      const exists = this.scannedBleDevices.some(d => d.deviceId === deviceId);
      if (!exists) {
        this.scannedBleDevices.push({
          deviceId: deviceId,
          rssi: rssi,
          name: name,
        });
        this.log(`Found MIDI device: ${name} (${deviceId})`);
      }
    }
  };

  // 开始扫描BLE MIDI设备
  async startBleScan(): Promise<void> {
    hilog.info(DOMAIN, TAG, '[startBleScan] ++enter');
    this.bleScanError = '';
    this.scannedBleDevices = [];

    try {
      // 请求蓝牙扫描的运行时权限
      const permissions: Permissions[] = [
        'ohos.permission.ACCESS_BLUETOOTH'
      ];

      try {
        const atManager = abilityAccessCtrl.createAtManager();
        const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        const grantResults = await atManager.requestPermissionsFromUser(context, permissions);
        hilog.info(DOMAIN, TAG, '[startBleScan] Permission request results: %{public}s', JSON.stringify(grantResults));

        // 检查是否所有权限已授予（authResults: 0 = 已授予）
        const allGranted = grantResults.authResults.every((result: number) => result === 0);
        if (!allGranted) {
          this.bleScanError = 'Required permissions not granted';
          this.log('Error: Required permissions not granted');
          return;
        }
        // 权限获取成功后刷新设备列表，蓝牙权限获取前无法发现BLE MIDI设备
        if (this.clientCreated) {
          this.refreshDevices();
        }
      } catch (permErr) {
        hilog.error(DOMAIN, TAG, '[startBleScan] Permission request failed: %{public}s', JSON.stringify(permErr));
        this.bleScanError = 'Permission request failed';
        this.log('Error: Permission request failed');
        return;
      }

      // 检查蓝牙是否已启用
      // 注意：我们直接尝试开始扫描，如果蓝牙未开启则会报错
      // 这比检查状态更可靠，因为检查状态可能需要额外的API
      hilog.info(DOMAIN, TAG, '[startBleScan] Proceeding with BLE scan...');

      // 清除已有的扫描定时器
      if (this.bleScanTimer !== -1) {
        clearTimeout(this.bleScanTimer);
        this.bleScanTimer = -1;
      }

      // 设置扫描回调
      this.bleScanner.on('BLEDeviceFind', this.onBleDeviceFound);

      // 使用适当的扫描选项开始扫描
      const scanOptions: ble.ScanOptions = {
        interval: 500,
        dutyMode: ble.ScanDuty.SCAN_MODE_LOW_POWER,
        matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE
      };
      let scanFilter: ble.ScanFilter = {
        serviceUuid : '03b80e5a-ede8-4b33-a751-6ce34ec4c700'
      }
      this.bleScanner.startScan([scanFilter], scanOptions);
      this.bleScanning = true;
      this.log('Started BLE scan for MIDI devices...');

      // 30秒后自动停止
      this.bleScanTimer = setTimeout(() => {
        if (this.bleScanning) {
          this.stopBleScan();
        }
        this.bleScanTimer = -1;
      }, 30000);

      hilog.info(DOMAIN, TAG, '[startBleScan] scan started');
    } catch (e) {
      const err = e as BusinessError;
      hilog.error(DOMAIN, TAG, '[startBleScan] Failed: %{public}d, %{public}s', err.code, err.message);
      this.bleScanError = `Scan failed: ${err.message}`;
      this.bleScanning = false;
    }
  }

  // 停止BLE扫描
  stopBleScan(): void {
    hilog.info(DOMAIN, TAG, '[stopBleScan] ++enter');
    try {
      // 清除扫描定时器
      if (this.bleScanTimer !== -1) {
        clearTimeout(this.bleScanTimer);
        this.bleScanTimer = -1;
      }
      this.bleScanner.off('BLEDeviceFind', this.onBleDeviceFound);
      this.bleScanner.stopScan();
      this.bleScanning = false;
      this.log('BLE scan stopped');
      hilog.info(DOMAIN, TAG, '[stopBleScan] scan stopped');
    } catch (e) {
      const err = e as BusinessError;
      hilog.error(DOMAIN, TAG, '[stopBleScan] Failed: %{public}d, %{public}s', err.code, err.message);
    }
  }

  // 连接到扫描到的BLE设备
  connectToScannedDevice(device: ScannedBleDevice): void {
    hilog.info(DOMAIN, TAG, '[connectToScannedDevice] ++enter, deviceId=%{public}s', device.deviceId);
    this.log(`Connecting to ${device.name}...`);
    this.bleDeviceAddress = device.deviceId;
    this.openBLEDevice(device.deviceId);
  }

  log(msg: string): void {
    hilog.info(DOMAIN, TAG, '%{public}s', msg);
    const timestamp = new Date().toLocaleTimeString();
    this.logMessages.unshift(`[${timestamp}] ${msg}`);
    // 仅保留最大条目数
    if (this.logMessages.length > this.MAX_LOG_ENTRIES) {
      this.logMessages = this.logMessages.slice(0, this.MAX_LOG_ENTRIES);
    }
    this.scrollToTopWithDebounce(this.logScroller);
  }

  logMidiInput(msg: string): void {
    hilog.info(DOMAIN, TAG, 'MIDI Input: %{public}s', msg);
    const timestamp = new Date().toLocaleTimeString();
    this.receivedMessages.unshift(`[${timestamp}] ${msg}`);
    // 仅保留最大条目数
    if (this.receivedMessages.length > this.MAX_MIDI_ENTRIES) {
      this.receivedMessages = this.receivedMessages.slice(0, this.MAX_MIDI_ENTRIES);
    }
    this.scrollToTopWithDebounce(this.midiInputScroller);
  }

  clearLog(): void {
    this.logMessages = [];
    hilog.info(DOMAIN, TAG, '[clearLog] log cleared');
  }

  clearMidiInput(): void {
    this.receivedMessages = [];
    hilog.info(DOMAIN, TAG, '[clearMidiInput] MIDI input cleared');
  }

  // 使用防抖滚动到顶部以提升性能
  scrollToTopWithDebounce(scroller: Scroller): void {
    if (this.scrollDebounceTimer !== -1) {
      clearTimeout(this.scrollDebounceTimer);
    }
    this.scrollDebounceTimer = setTimeout(() => {
      scroller.scrollEdge(Edge.Top);
      this.scrollDebounceTimer = -1;
    }, 100);
  }

  cleanup(): void {
    hilog.info(DOMAIN, TAG,
      '[cleanup] ++enter, isDeviceOpen=%{public}s, selectedDeviceId=%{public}d, clientCreated=%{public}s',
      this.isDeviceOpen.toString(), this.selectedDeviceId, this.clientCreated.toString());
    try {
      if (this.isDeviceOpen && this.selectedDeviceId >= 0) {
        hilog.info(DOMAIN, TAG, '[cleanup] closing ports, inputCount=%{public}d, outputCount=%{public}d',
          this.openInputPorts.size, this.openOutputPorts.size);
        // 关闭所有端口
        this.openInputPorts.forEach((portIndex: number) => {
          hilog.info(DOMAIN, TAG, '[cleanup] closing input port %{public}d', portIndex);
          midi.closeInputPort(this.selectedDeviceId, portIndex);
        });
        this.openOutputPorts.forEach((portIndex: number) => {
          hilog.info(DOMAIN, TAG, '[cleanup] closing output port %{public}d', portIndex);
          midi.closeOutputPort(this.selectedDeviceId, portIndex);
        });
        // 关闭设备
        hilog.info(DOMAIN, TAG, '[cleanup] closing device %{public}d', this.selectedDeviceId);
        midi.closeDevice(this.selectedDeviceId);
      }
      if (this.clientCreated) {
        hilog.info(DOMAIN, TAG, '[cleanup] destroying MIDI client');
        midi.destroyMIDIClient();
      }
      hilog.info(DOMAIN, TAG, '[cleanup] --exit, cleanup successful');
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[cleanup] error: %{public}s', JSON.stringify(e));
    }
  }

  // [Start arkts_create_client]
  createClient(): void {
    try {
      // 设备变更回调
      const deviceChangeCallback = (action: number, deviceInfo: MidiDeviceInfo) => {
        // 在回调中：仅复制数据并发射事件，不要持有锁或执行繁重操作
        // [StartExclude arkts_create_client]
        hilog.info(DOMAIN, TAG, '[createClient/callback] action=%{public}d, deviceId=%{public}d, deviceName=%{public}s',
          action, deviceInfo.deviceId, deviceInfo.deviceName);
        // [EndExclude arkts_create_client]
        const eventData: DeviceChangeEventData = {
          action: action,
          deviceId: deviceInfo.deviceId,
          deviceName: deviceInfo.deviceName,
          deviceType: deviceInfo.deviceType,
          deviceAddress: deviceInfo.deviceAddress
        };
        emitter.emit({ eventId: EVENT_DEVICE_CHANGE }, { data: eventData });
        // [StartExclude arkts_create_client]
        hilog.info(DOMAIN, TAG, '[createClient/callback] event emitted, eventId=%{public}d', EVENT_DEVICE_CHANGE);
        // [EndExclude arkts_create_client]
      };

      // 错误回调
      const errorCallback = (error: ErrorEventData) => {
        // [StartExclude arkts_create_client]
        hilog.error(DOMAIN, TAG, '[createClient/errorCallback] code=%{public}d, message=%{public}s',
          error.code, error.message);
        // [EndExclude arkts_create_client]
        emitter.emit({ eventId: EVENT_ERROR }, { data: error });
      };

      const status = midi.createMIDIClient(deviceChangeCallback, errorCallback);

      // [StartExclude arkts_create_client]
      hilog.info(DOMAIN, TAG, '[createClient] createMIDIClient returned status=%{public}d', status);
      // [EndExclude arkts_create_client]
      if (status === MidiStatusCode.OK) {
        this.clientCreated = true;
        this.log('MIDI client created successfully');
        // [StartExclude arkts_create_client]
        hilog.info(DOMAIN, TAG, '[createClient] clientCreated set to true');
        // [EndExclude arkts_create_client]
        this.refreshDevices();
      } else {
        // [StartExclude arkts_create_client]
        this.log(`Failed to create client: ${status}`);
        hilog.error(DOMAIN, TAG, '[createClient] failed with status=%{public}d', status);
        // [EndExclude arkts_create_client]
      }
      // [StartExclude arkts_create_client]
      hilog.info(DOMAIN, TAG, '[createClient] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[createClient] exception: %{public}s', JSON.stringify(e));
      this.log(`Error creating client: ${JSON.stringify(e)}`);
    }
    // [EndExclude arkts_create_client]
  }
  // [End arkts_create_client]

  // [Start arkts_destroy_client]
  destroyClient(): void {
    try {
      this.cleanup();
      this.clientCreated = false;
      this.deviceList = [];
      this.selectedDeviceId = -1;
      this.portList = [];
      this.inputPorts = [];
      this.outputPorts = [];
      this.isDeviceOpen = false;
      this.openInputPorts.clear();
      this.openOutputPorts.clear();
      this.activeKeys.clear();
      this.bleDeviceList = [];
      this.log('MIDI client destroyed');
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[destroyClient] exception: %{public}s', JSON.stringify(e));
      this.log(`Error destroying client: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_destroy_client]

  // 在主线程处理设备变更（由事件监听器调用）
  handleDeviceChange(data: DeviceChangeEventData): void {
    hilog.info(DOMAIN, TAG,
      '[handleDeviceChange] ++enter, action=%{public}d, deviceId=%{public}d, ' +
      'deviceName=%{public}s, deviceType=%{public}d, deviceAddress=%{public}s',
      data.action, data.deviceId, data.deviceName, data.deviceType, data.deviceAddress);

    if (data.action === 0) { // 已连接
      this.log(`Device connected: ${data.deviceName} (ID: ${data.deviceId})`);
      // 如果是BLE设备则添加到BLE设备列表
      if (data.deviceType === MidiDeviceType.BLE) {
        hilog.info(DOMAIN, TAG, '[handleDeviceChange] BLE device detected');
        const exists = this.bleDeviceList.find(d => d.deviceId === data.deviceId);
        if (!exists) {
          const deviceInfo: MidiDeviceInfo = {
            deviceId: data.deviceId,
            deviceName: data.deviceName,
            deviceType: data.deviceType,
            deviceAddress: data.deviceAddress,
            nativeProtocol: 0,
            vendorId: BigInt(0),
            productId: BigInt(0)
          };
          this.bleDeviceList = [...this.bleDeviceList, deviceInfo];
          hilog.info(DOMAIN, TAG,
            '[handleDeviceChange] added to BLE device list, count=%{public}d', this.bleDeviceList.length);
        }
      }
    } else { // 已断开
      this.log(`Device disconnected: ${data.deviceName} (ID: ${data.deviceId})`);
      // 从BLE设备列表中移除
      const prevCount = this.bleDeviceList.length;
      this.bleDeviceList = this.bleDeviceList.filter(d => d.deviceId !== data.deviceId);
      hilog.info(DOMAIN, TAG, '[handleDeviceChange] removed from BLE list, prevCount=%{public}d, newCount=%{public}d',
        prevCount, this.bleDeviceList.length);

      if (this.selectedDeviceId === data.deviceId) {
        hilog.info(DOMAIN, TAG, '[handleDeviceChange] selected device disconnected, resetting states');
        this.selectedDeviceId = -1;
        this.isDeviceOpen = false;
        this.portList = [];
        this.inputPorts = [];
        this.outputPorts = [];
        this.openInputPorts.clear();
        this.openOutputPorts.clear();
        this.activeKeys.clear();
      }
    }
    this.refreshDevices();
    hilog.info(DOMAIN, TAG, '[handleDeviceChange] --exit');
  }

  // [Start arkts_enum_devices]
  refreshDevices(): void {
    try {
      const count = midi.getDeviceCount();
      if (count > 0) {
        this.deviceList = midi.getDeviceInfos();
        // [StartExclude arkts_enum_devices]
        hilog.info(DOMAIN, TAG, '[refreshDevices] got %{public}d devices', this.deviceList.length);
        // 记录每个设备信息
        this.deviceList.forEach((device, index) => {
          hilog.info(DOMAIN, TAG,
            '[refreshDevices] device[%{public}d]: id=%{public}d, name=%{public}s, type=%{public}d',
            index, device.deviceId, device.deviceName, device.deviceType);
        });
        // [EndExclude arkts_enum_devices]
      } else {
        this.deviceList = [];
        hilog.info(DOMAIN, TAG, '[refreshDevices] no devices found');
      }
      // [StartExclude arkts_enum_devices]
      hilog.info(DOMAIN, TAG, '[refreshDevices] --exit, deviceList.length=%{public}d', this.deviceList.length);
      // [EndExclude arkts_enum_devices]
    } catch (e) {
      // [StartExclude arkts_enum_devices]
      hilog.error(DOMAIN, TAG, '[refreshDevices] exception: %{public}s', JSON.stringify(e));
      this.log(`Error refreshing devices: ${JSON.stringify(e)}`);
      // [EndExclude arkts_enum_devices]
    }
  }
  // [End arkts_enum_devices]

  selectDevice(deviceId: number): void {
    hilog.info(DOMAIN, TAG,
      '[selectDevice] ++enter, deviceId=%{public}d, currentSelectedId=%{public}d, isDeviceOpen=%{public}s',
      deviceId, this.selectedDeviceId, this.isDeviceOpen.toString());

    if (this.isDeviceOpen && this.selectedDeviceId !== deviceId) {
      hilog.info(DOMAIN, TAG, '[selectDevice] closing current device first');
      this.closeDevice();
    }
    this.selectedDeviceId = deviceId;
    hilog.info(DOMAIN, TAG, '[selectDevice] selectedDeviceId set to %{public}d', deviceId);
    this.loadPorts(deviceId);
    hilog.info(DOMAIN, TAG, '[selectDevice] --exit');
  }

  // [Start arkts_load_ports]
  loadPorts(deviceId: number): void {
    hilog.info(DOMAIN, TAG, '[loadPorts] ++enter, deviceId=%{public}d', deviceId);
    try {
      // [StartExclude arkts_load_ports]
      const count = midi.getPortCount(deviceId);
      hilog.info(DOMAIN, TAG, '[loadPorts] portCount=%{public}d', count);
      // [EndExclude arkts_load_ports]
      if (count > 0) {
        this.portList = midi.getPortInfos(deviceId);
        this.inputPorts = this.portList.filter(p => p.direction === MidiPortDirection.INPUT);
        this.outputPorts = this.portList.filter(p => p.direction === MidiPortDirection.OUTPUT);
        hilog.info(DOMAIN, TAG, '[loadPorts] totalPorts=%{public}d, inputPorts=%{public}d, outputPorts=%{public}d',
          this.portList.length, this.inputPorts.length, this.outputPorts.length);
        // 记录每个端口信息
        this.portList.forEach((port, index) => {
          hilog.info(DOMAIN, TAG,
            '[loadPorts] port[%{public}d]: index=%{public}d, name=%{public}s, direction=%{public}d',
            index, port.portIndex, port.name, port.direction);
        });
      } else {
        this.portList = [];
        this.inputPorts = [];
        this.outputPorts = [];
        hilog.info(DOMAIN, TAG, '[loadPorts] no ports found');
      }
      hilog.info(DOMAIN, TAG, '[loadPorts] --exit');
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[loadPorts] exception: %{public}s', JSON.stringify(e));
      this.log(`Error loading ports: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_load_ports]

  // [Start arkts_open_device]
  openDevice(): void {
    // [StartExclude arkts_open_device]
    hilog.info(DOMAIN, TAG, '[openDevice] ++enter, selectedDeviceId=%{public}d', this.selectedDeviceId);
    // [EndExclude arkts_open_device]
    if (this.selectedDeviceId < 0) {
      hilog.warn(DOMAIN, TAG, '[openDevice] no device selected');
      this.log('Please select a device first');
      return;
    }

    try {
      const status = midi.openDevice(this.selectedDeviceId);
      if (status === MidiStatusCode.OK) {
        this.isDeviceOpen = true;
        this.log(`Device ${this.selectedDeviceId} opened`);
        hilog.info(DOMAIN, TAG, '[openDevice] device opened successfully, isDeviceOpen=true');
      } else {
        this.log(`Failed to open device: ${status}`);
        hilog.error(DOMAIN, TAG, '[openDevice] failed with status=%{public}d', status);
      }
      hilog.info(DOMAIN, TAG, '[openDevice] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[openDevice] exception: %{public}s', JSON.stringify(e));
      this.log(`Error opening device: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_open_device]

  // [Start arkts_close_device]
  closeDevice(): void {
    hilog.info(DOMAIN, TAG, '[closeDevice] ++enter, selectedDeviceId=%{public}d', this.selectedDeviceId);

    if (this.selectedDeviceId < 0) {
      hilog.warn(DOMAIN, TAG, '[closeDevice] no device selected');
      return;
    }

    try {
      this.openInputPorts.forEach((portIndex: number) => {
        midi.closeInputPort(this.selectedDeviceId, portIndex);
      });
      this.openOutputPorts.forEach((portIndex: number) => {
        midi.closeOutputPort(this.selectedDeviceId, portIndex);
      });
      this.openInputPorts.clear();
      this.openOutputPorts.clear();
      this.activeKeys.clear();

      const status = midi.closeDevice(this.selectedDeviceId);

      if (status === MidiStatusCode.OK) {
        this.isDeviceOpen = false;
        this.log('Device closed');
        hilog.info(DOMAIN, TAG, '[closeDevice] device closed successfully, isDeviceOpen=false');
      } else {
        this.log(`Failed to close device: ${status}`);
        hilog.error(DOMAIN, TAG, '[closeDevice] failed with status=%{public}d', status);
      }
      hilog.info(DOMAIN, TAG, '[closeDevice] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[closeDevice] exception: %{public}s', JSON.stringify(e));
      this.log(`Error closing device: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_close_device]

  // 在主线程处理MIDI数据接收（由事件监听器调用）
  handleMidiReceived(umpData: number[]): void {
    hilog.info(DOMAIN, TAG, '[handleMidiReceived] ++enter, dataCount=%{public}d', umpData.length);

    for (const ump of umpData) {
      // 解析UMP消息
      const messageType = (ump >> 28) & 0x0F;
      const status = (ump >> 20) & 0x0F;
      const channel = (ump >> 16) & 0x0F;

      hilog.debug(DOMAIN, TAG,
        '[handleMidiReceived] UMP=0x%{public}X, type=%{public}d, status=%{public}d, ch=%{public}d',
        ump, messageType, status, channel);

      if (messageType === 0x2) { // MIDI 1.0通道语音
        switch (status) {
          case 0x8: // 音符关闭
            this.handleNoteOff(ump, channel);
            break;
          case 0x9: // 音符开启
            this.handleNoteOn(ump, channel);
            break;
          case 0xA: // 复音触后
            this.handlePolyAftertouch(ump, channel);
            break;
          case 0xB: // 控制变更
            this.handleControlChange(ump, channel);
            break;
          case 0xC: // 程序变更
            this.handleProgramChange(ump, channel);
            break;
          case 0xD: // 通道触后
            this.handleChannelAftertouch(ump, channel);
            break;
          case 0xE: // 弯音轮
            this.handlePitchBend(ump, channel);
            break;
          default:
            this.logMidiInput(`UMP: 0x${ump.toString(16).toUpperCase()}`);
            hilog.info(DOMAIN, TAG, '[handleMidiReceived] Unknown status: 0x%{public}X', status);
            break;
        }
      } else if (messageType === 0x0 || messageType === 0x1) {
        // 系统消息和工具消息 - 检查实时过滤
        const statusByte = (ump >> 16) & 0xFF;
        if (!this.shouldFilterRealtimeMessage(statusByte)) {
          this.logMidiInput(`System: 0x${ump.toString(16).toUpperCase()}`);
          hilog.info(DOMAIN, TAG, '[handleMidiReceived] System message: 0x%{public}X', ump);
        }
      } else {
        // 其他UMP类型（MIDI 2.0等）
        this.logMidiInput(`UMP: 0x${ump.toString(16).toUpperCase()}`);
        hilog.info(DOMAIN, TAG, '[handleMidiReceived] Non-MIDI1.0 UMP: 0x%{public}X', ump);
      }
    }
    hilog.info(DOMAIN, TAG, '[handleMidiReceived] --exit, activeKeys.size=%{public}d', this.activeKeys.size);
  }

  // 处理音符开启消息
  handleNoteOn(ump: number, channel: number): void {
    const note = (ump >> 8) & 0x7F;
    const velocity = ump & 0x7F;
    if (velocity > 0) {
      const noteName = this.noteToName(note);
      this.logMidiInput(`Note On: ch${channel}, ${noteName}(note=${note}), vel=${velocity}`);
      this.activeKeys.add(note);
      hilog.info(DOMAIN, TAG, '[handleNoteOn] note=%{public}d, vel=%{public}d', note, velocity);
    } else {
      // 力度为0表示音符关闭
      this.handleNoteOff(ump, channel);
    }
  }

  // 处理音符关闭消息
  handleNoteOff(ump: number, channel: number): void {
    const note = (ump >> 8) & 0x7F;
    const velocity = ump & 0x7F;
    const noteName = this.noteToName(note);
    this.logMidiInput(`Note Off: ch${channel}, ${noteName}(note=${note}), vel=${velocity}`);
    this.activeKeys.delete(note);
    hilog.info(DOMAIN, TAG, '[handleNoteOff] note=%{public}d, vel=%{public}d', note, velocity);
  }

  // 处理复音触后消息
  handlePolyAftertouch(ump: number, channel: number): void {
    const note = (ump >> 8) & 0x7F;
    const pressure = ump & 0x7F;
    const noteName = this.noteToName(note);
    this.logMidiInput(`Poly AT: ch${channel}, ${noteName}, pressure=${pressure}`);
    hilog.info(DOMAIN, TAG, '[handlePolyAftertouch] note=%{public}d, pressure=%{public}d', note, pressure);
  }

  // 处理控制变更消息
  handleControlChange(ump: number, channel: number): void {
    const controller = (ump >> 8) & 0x7F;
    const value = ump & 0x7F;
    const controllerName = this.getControllerName(controller);
    this.logMidiInput(`CC: ch${channel}, ${controllerName}(cc=${controller}), val=${value}`);
    hilog.info(DOMAIN, TAG, '[handleControlChange] cc=%{public}d, val=%{public}d', controller, value);
  }

  // 处理程序变更消息
  handleProgramChange(ump: number, channel: number): void {
    const program = (ump >> 8) & 0x7F;
    this.logMidiInput(`PC: ch${channel}, program=${program}`);
    hilog.info(DOMAIN, TAG, '[handleProgramChange] program=%{public}d', program);
  }

  // 处理通道触后消息
  handleChannelAftertouch(ump: number, channel: number): void {
    const pressure = (ump >> 8) & 0x7F;
    this.logMidiInput(`Ch AT: ch${channel}, pressure=${pressure}`);
    hilog.info(DOMAIN, TAG, '[handleChannelAftertouch] pressure=%{public}d', pressure);
  }

  // 处理弯音轮消息
  handlePitchBend(ump: number, channel: number): void {
    const lsb = (ump >> 8) & 0x7F;
    const msb = ump & 0x7F;
    const bendValue = (msb << 7) | lsb;
    const bendRange = bendValue - 8192; // 中心值为8192
    this.logMidiInput(`Pitch: ch${channel}, bend=${bendRange} (raw=${bendValue})`);
    hilog.info(DOMAIN, TAG, '[handlePitchBend] bend=%{public}d, raw=%{public}d', bendRange, bendValue);
  }

  // 检查消息是否应被过滤（实时消息）
  shouldFilterRealtimeMessage(statusByte: number): boolean {
    // 实时消息：0xF8（时钟）、0xFA（开始）、0xFB（继续）、0xFC（停止）、0xFE（活动检测）、0xFF（复位）
    return statusByte >= 0xF8;
  }

  // 将MIDI音符编号转换为名称
  noteToName(note: number): string {
    const octave = Math.floor(note / 12) - 1;
    const noteIndex = note % 12;
    let noteName: string;
    switch (noteIndex) {
      case 0:
        noteName = 'C';
        break;
      case 1:
        noteName = 'C#';
        break;
      case 2:
        noteName = 'D';
        break;
      case 3:
        noteName = 'D#';
        break;
      case 4:
        noteName = 'E';
        break;
      case 5:
        noteName = 'F';
        break;
      case 6:
        noteName = 'F#';
        break;
      case 7:
        noteName = 'G';
        break;
      case 8:
        noteName = 'G#';
        break;
      case 9:
        noteName = 'A';
        break;
      case 10:
        noteName = 'A#';
        break;
      case 11:
        noteName = 'B';
        break;
      default:
        noteName = 'C';
        break;
    }
    return `${noteName}${octave}`;
  }

  // 获取通用控制器名称
  getControllerName(controller: number): string {
    const controllerNames = new Map<number, string>([
      [0, 'Bank Select MSB'],
      [1, 'Modulation'],
      [2, 'Breath'],
      [4, 'Foot'],
      [5, 'Portamento Time'],
      [6, 'Data Entry MSB'],
      [7, 'Volume'],
      [8, 'Balance'],
      [10, 'Pan'],
      [11, 'Expression'],
      [32, 'Bank Select LSB'],
      [38, 'Data Entry LSB'],
      [64, 'Sustain'],
      [65, 'Portamento'],
      [66, 'Sostenuto'],
      [67, 'Soft'],
      [68, 'Legato'],
      [71, 'Resonance'],
      [72, 'Release'],
      [73, 'Attack'],
      [74, 'Cutoff'],
      [75, 'Decay'],
      [76, 'Vibrato Rate'],
      [77, 'Vibrato Depth'],
      [78, 'Vibrato Delay'],
      [84, 'Portamento Control'],
      [91, 'Reverb'],
      [92, 'Tremolo'],
      [93, 'Chorus'],
      [94, 'Detune'],
      [95, 'Phaser'],
      [96, 'Data Increment'],
      [97, 'Data Decrement'],
      [98, 'NRPN LSB'],
      [99, 'NRPN MSB'],
      [100, 'RPN LSB'],
      [101, 'RPN MSB'],
      [120, 'All Sound Off'],
      [121, 'Reset Controllers'],
      [122, 'Local Control'],
      [123, 'All Notes Off'],
      [124, 'Omni Off'],
      [125, 'Omni On'],
      [126, 'Mono'],
      [127, 'Poly']
    ]);
    const name = controllerNames.get(controller);
    return name !== undefined ? name : `CC${controller}`;
  }

  // [Start arkts_open_input_port]
  openInputPort(portIndex: number): void {
    hilog.info(DOMAIN, TAG, '[openInputPort] ++enter, deviceId=%{public}d, portIndex=%{public}d',
      this.selectedDeviceId, portIndex);

    try {
      const status = midi.openInputPort(
        this.selectedDeviceId,
        portIndex,
        1, // MIDI 1.0协议
        (events: MidiEvent[]) => {
          // 在回调中：仅复制数据并发射事件，不要持有锁或执行繁重操作
          hilog.debug(DOMAIN, TAG, '[openInputPort/callback] received %{public}d events', events.length);
          const umpData: number[] = [];
          for (const event of events) {
            if (event.data && event.data.length > 0) {
              // 遍历event.data数组中的所有元素
              for (let i = 0; i < event.data.length; i++) {
                umpData.push(event.data[i]);
              }
            }
          }
          if (umpData.length > 0) {
            const eventData: MidiReceivedEventData = { umpData: umpData };
            emitter.emit({ eventId: EVENT_MIDI_RECEIVED }, { data: eventData });
            hilog.debug(DOMAIN, TAG,
              '[openInputPort/callback] emitted EVENT_MIDI_RECEIVED with %{public}d UMPs', umpData.length);
          }
        }
      );

      hilog.info(DOMAIN, TAG, '[openInputPort] openInputPort returned status=%{public}d', status);
      if (status === MidiStatusCode.OK) {
        this.openInputPorts.add(portIndex);
        this.log(`Input port ${portIndex} opened with callback`);
        hilog.info(DOMAIN, TAG, '[openInputPort] port opened, openInputPorts.size=%{public}d',
          this.openInputPorts.size);
      } else {
        this.log(`Failed to open input port: ${status}`);
        hilog.error(DOMAIN, TAG, '[openInputPort] failed with status=%{public}d', status);
      }
      hilog.info(DOMAIN, TAG, '[openInputPort] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[openInputPort] exception: %{public}s', JSON.stringify(e));
      this.log(`Error opening input port: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_open_input_port]

  // [Start arkts_close_input_port]
  closeInputPort(portIndex: number): void {
    try {
      const status = midi.closeInputPort(this.selectedDeviceId, portIndex);

      if (status === MidiStatusCode.OK) {
        this.openInputPorts.delete(portIndex);
        this.log(`Input port ${portIndex} closed`);
        hilog.info(DOMAIN, TAG, '[closeInputPort] port closed, openInputPorts.size=%{public}d',
          this.openInputPorts.size);
      } else {
        this.log(`Failed to close input port: ${status}`);
        hilog.error(DOMAIN, TAG, '[closeInputPort] failed with status=%{public}d', status);
      }
      hilog.info(DOMAIN, TAG, '[closeInputPort] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[closeInputPort] exception: %{public}s', JSON.stringify(e));
      this.log(`Error closing input port: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_close_input_port]

  // [Start arkts_open_output_port]
  openOutputPort(portIndex: number): void {

    try {
      const status = midi.openOutputPort(this.selectedDeviceId, portIndex, 1);

      if (status === MidiStatusCode.OK) {
        this.openOutputPorts.add(portIndex);
        this.log(`Output port ${portIndex} opened`);
        hilog.info(DOMAIN, TAG, '[openOutputPort] port opened, openOutputPorts.size=%{public}d',
          this.openOutputPorts.size);
      } else {
        this.log(`Failed to open output port: ${status}`);
        hilog.error(DOMAIN, TAG, '[openOutputPort] failed with status=%{public}d', status);
      }
      hilog.info(DOMAIN, TAG, '[openOutputPort] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[openOutputPort] exception: %{public}s', JSON.stringify(e));
      this.log(`Error opening output port: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_open_output_port]

  // [Start arkts_close_output_port]
  closeOutputPort(portIndex: number): void {
    try {
      const status = midi.closeOutputPort(this.selectedDeviceId, portIndex);
      if (status === MidiStatusCode.OK) {
        this.openOutputPorts.delete(portIndex);
        this.log(`Output port ${portIndex} closed`);
        hilog.info(DOMAIN, TAG, '[closeOutputPort] port closed, openOutputPorts.size=%{public}d',
          this.openOutputPorts.size);
      } else {
        this.log(`Failed to close output port: ${status}`);
        hilog.error(DOMAIN, TAG, '[closeOutputPort] failed with status=%{public}d', status);
      }
      hilog.info(DOMAIN, TAG, '[closeOutputPort] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[closeOutputPort] exception: %{public}s', JSON.stringify(e));
      this.log(`Error closing output port: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_close_output_port]

  // 钢琴琴键处理函数
  // [Start arkts_on_key_press]
  onKeyPress(note: number): void {
    if (this.openOutputPorts.size === 0) {
      hilog.warn(DOMAIN, TAG, '[onKeyPress] no output port open');
      this.log('Please open an output port first');
      return;
    }

    const portIndex = Array.from(this.openOutputPorts)[0];
    this.activeKeys.add(note);

    try {
      const status = midi.sendNoteOn(this.selectedDeviceId, portIndex, this.channelValue, note, 100);
      if (status !== MidiStatusCode.OK) {
        this.log(`Failed to send Note On: ${status}`);
        hilog.error(DOMAIN, TAG, '[onKeyPress] sendNoteOn failed with status=%{public}d', status);
      } else {
        hilog.debug(DOMAIN, TAG, '[onKeyPress] NoteOn sent successfully');
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[onKeyPress] exception: %{public}s', JSON.stringify(e));
      this.log(`Error sending Note On: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_on_key_press]

  // [Start arkts_on_key_release]
  onKeyRelease(note: number): void {
    if (this.openOutputPorts.size === 0) {
      this.activeKeys.delete(note);
      hilog.debug(DOMAIN, TAG, '[onKeyRelease] no output port, just removing from activeKeys');
      return;
    }

    const portIndex = Array.from(this.openOutputPorts)[0];
    this.activeKeys.delete(note);

    try {
      hilog.debug(DOMAIN, TAG,
        '[onKeyRelease] NoteOff: dev=%{public}d, port=%{public}d, ch=%{public}d, note=%{public}d',
        this.selectedDeviceId, portIndex, this.channelValue, note);
      const status = midi.sendNoteOff(this.selectedDeviceId, portIndex, this.channelValue, note, 64);
      if (status !== MidiStatusCode.OK) {
        this.log(`Failed to send Note Off: ${status}`);
        hilog.error(DOMAIN, TAG, '[onKeyRelease] sendNoteOff failed with status=%{public}d', status);
      } else {
        hilog.debug(DOMAIN, TAG, '[onKeyRelease] NoteOff sent successfully');
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[onKeyRelease] exception: %{public}s', JSON.stringify(e));
      this.log(`Error sending Note Off: ${JSON.stringify(e)}`);
    }
    hilog.debug(DOMAIN, TAG, '[onKeyRelease] --exit');
  }
  // [End arkts_on_key_release]

  // 在主线程处理BLE设备已打开（由事件监听器调用）
  handleBleOpened(data: BleOpenedEventData): void {
    hilog.info(DOMAIN, TAG, '[handleBleOpened] opened=%{public}s, devId=%{public}d, name=%{public}s, type=%{public}d',
      data.opened.toString(), data.deviceId, data.deviceName, data.deviceType);

    this.bleConnecting = false;
    if (data.opened) {
      this.log(`BLE device connected: ${data.deviceName}`);
      this.log(`Device ID: ${data.deviceId}`);
      // 添加到最近BLE设备
      this.addRecentBleDevice(data.deviceAddress, data.deviceName);
      // 添加到BLE设备列表
      const exists = this.bleDeviceList.find(d => d.deviceId === data.deviceId);
      if (!exists) {
        const deviceInfo: MidiDeviceInfo = {
          deviceId: data.deviceId,
          deviceName: data.deviceName,
          deviceType: data.deviceType,
          deviceAddress: data.deviceAddress,
          nativeProtocol: 0,
          vendorId: BigInt(0),
          productId: BigInt(0)
        };
        this.bleDeviceList = [...this.bleDeviceList, deviceInfo];
        hilog.info(DOMAIN, TAG, '[handleBleOpened] added to BLE device list, count=%{public}d',
          this.bleDeviceList.length);
      }

      this.selectDevice(data.deviceId);

      // 设备已在C++中打开（存储在g_openedDevices中）
      // 因此需要更新状态以反映此情况
      this.isDeviceOpen = true;
      hilog.info(DOMAIN, TAG, '[handleBleOpened] device is already opened, isDeviceOpen set to true');

      // 刷新主设备列表
      this.refreshDevices();

      this.log(`Device opened automatically, you can now open ports`);
    } else {
      this.log(`Failed to connect to BLE device`);
      hilog.error(DOMAIN, TAG, '[handleBleOpened] BLE connection failed');
    }
    hilog.info(DOMAIN, TAG, '[handleBleOpened] --exit');
  }

  // 在主线程处理MIDI错误（由事件监听器调用）
  handleMidiError(data: ErrorEventData): void {
    hilog.error(DOMAIN, TAG, '[handleMidiError] ++enter, code=%{public}d, message=%{public}s',
      data.code, data.message);

    this.log(`MIDI Error: ${data.message} (code: ${data.code})`);

    // 处理服务终止错误 - 重置客户端状态
    if (data.code === MidiStatusCode.SERVICE_DIED) {
      hilog.info(DOMAIN, TAG, '[handleMidiError] service died, resetting state');
      this.clientCreated = false;
      this.selectedDeviceId = -1;
      this.isDeviceOpen = false;
      this.deviceList = [];
      this.bleDeviceList = [];
      this.portList = [];
      this.inputPorts = [];
      this.outputPorts = [];
      this.openInputPorts.clear();
      this.openOutputPorts.clear();
      this.activeKeys.clear();
      this.log('MIDI service died. Please recreate the client.');
    }

    hilog.error(DOMAIN, TAG, '[handleMidiError] --exit');
  }

  // BLE设备函数
  // [Start arkts_open_ble_device]
  openBLEDevice(deviceAddress: string): void {
    hilog.info(DOMAIN, TAG, '[openBLEDevice] ++enter, address=%{public}s', deviceAddress);
    if (!deviceAddress || deviceAddress.length === 0) {
      hilog.warn(DOMAIN, TAG, '[openBLEDevice] empty device address');
      this.log('Please enter a BLE device address');
      return;
    }
    this.bleConnecting = true;
    this.log(`Connecting to BLE device: ${deviceAddress}`);

    try {
      const status = midi.openBLEDevice(deviceAddress, (opened: boolean, deviceInfo: MidiDeviceInfo) => {
        // 在回调中：仅复制数据并发射事件，不要持有锁或执行繁重操作
        hilog.info(DOMAIN, TAG, '[openBLEDevice/cb] opened=%{public}s, devId=%{public}d, name=%{public}s',
          opened.toString(), deviceInfo.deviceId, deviceInfo.deviceName);
        const eventData: BleOpenedEventData = {
          opened: opened,
          deviceId: deviceInfo.deviceId,
          deviceName: deviceInfo.deviceName,
          deviceType: deviceInfo.deviceType,
          deviceAddress: deviceInfo.deviceAddress
        };
        emitter.emit({ eventId: EVENT_BLE_OPENED }, { data: eventData });
        hilog.info(DOMAIN, TAG, '[openBLEDevice/callback] emitted EVENT_BLE_OPENED');
      });
      hilog.info(DOMAIN, TAG, '[openBLEDevice] openBLEDevice returned status=%{public}d', status);
      if (status !== MidiStatusCode.OK) {
        this.bleConnecting = false;
        if (status === MidiStatusCode.PERMISSION_DENIED) {
          this.log('Bluetooth permission denied. Please grant ACCESS_BLUETOOTH permission.');
          hilog.error(DOMAIN, TAG, '[openBLEDevice] permission denied');
        } else {
          this.log(`Failed to start BLE connection: ${status}`);
          hilog.error(DOMAIN, TAG, '[openBLEDevice] failed with status=%{public}d', status);
        }
      }
      hilog.info(DOMAIN, TAG, '[openBLEDevice] --exit, status=%{public}d', status);
    } catch (e) {
      this.bleConnecting = false;
      hilog.error(DOMAIN, TAG, '[openBLEDevice] exception: %{public}s', JSON.stringify(e));
      this.log(`Error opening BLE device: ${JSON.stringify(e)}`);
    }
  }
  // [End arkts_open_ble_device]

  getDeviceTypeName(type: MidiDeviceType): string {
    return type === MidiDeviceType.USB ? 'USB' : 'BLE';
  }

  getPortDirectionName(direction: MidiPortDirection): string {
    return direction === MidiPortDirection.INPUT ? 'IN' : 'OUT';
  }

  // 根据断点更新响应式琴键尺寸
  updateKeyDimensions(): void {
    switch (this.currentBreakpoint) {
      case 'xs':
        this.keyDimensions = { whiteKeyWidth: 28, whiteKeyHeight: 100, blackKeyWidth: 20, blackKeyHeight: 60 };
        break;
      case 'sm':
        this.keyDimensions = { whiteKeyWidth: 34, whiteKeyHeight: 120, blackKeyWidth: 24, blackKeyHeight: 75 };
        break;
      case 'md':
        this.keyDimensions = { whiteKeyWidth: 40, whiteKeyHeight: 140, blackKeyWidth: 28, blackKeyHeight: 90 };
        break;
      case 'lg':
      default:
        this.keyDimensions = { whiteKeyWidth: 48, whiteKeyHeight: 160, blackKeyWidth: 32, blackKeyHeight: 100 };
        break;
    }
  }

  // 设置响应式设计的媒体查询监听器
  setupMediaQueryListeners(): void {
    const xsQuery = mediaquery.matchMediaSync('(width < 320vp)');
    const smQuery = mediaquery.matchMediaSync('(320vp <= width < 600vp)');
    const mdQuery = mediaquery.matchMediaSync('(600vp <= width < 840vp)');
    const lgQuery = mediaquery.matchMediaSync('(width >= 840vp)');

    this.xsMediaQueryListener = xsQuery;
    xsQuery.on('change', (result: mediaquery.MediaQueryResult) => {
      if (result.matches) {
        this.handleBreakpointChange('xs');
      }
    });

    this.smMediaQueryListener = smQuery;
    smQuery.on('change', (result: mediaquery.MediaQueryResult) => {
      if (result.matches) {
        this.handleBreakpointChange('sm');
      }
    });

    this.mdMediaQueryListener = mdQuery;
    mdQuery.on('change', (result: mediaquery.MediaQueryResult) => {
      if (result.matches) {
        this.handleBreakpointChange('md');
      }
    });

    this.lgMediaQueryListener = lgQuery;
    lgQuery.on('change', (result: mediaquery.MediaQueryResult) => {
      if (result.matches) {
        this.handleBreakpointChange('lg');
      }
    });

    // 设置初始断点
    if (xsQuery.matches) {
      this.currentBreakpoint = 'xs';
    } else if (smQuery.matches) {
      this.currentBreakpoint = 'sm';
    } else if (mdQuery.matches) {
      this.currentBreakpoint = 'md';
    } else {
      this.currentBreakpoint = 'lg';
    }
    this.updateKeyDimensions();
  }

  // 使用防抖处理断点变更
  handleBreakpointChange(breakpoint: BreakpointType): void {
    if (this.breakpointDebounceTimer !== -1) {
      clearTimeout(this.breakpointDebounceTimer);
    }
    this.breakpointDebounceTimer = setTimeout(() => {
      if (this.currentBreakpoint !== breakpoint) {
        this.currentBreakpoint = breakpoint;
        this.updateKeyDimensions();
      }
    }, 100);
  }

  // 拆除媒体查询监听器
  teardownMediaQueryListeners(): void {
    if (this.xsMediaQueryListener) {
      this.xsMediaQueryListener.off('change');
      this.xsMediaQueryListener = null;
    }
    if (this.smMediaQueryListener) {
      this.smMediaQueryListener.off('change');
      this.smMediaQueryListener = null;
    }
    if (this.mdMediaQueryListener) {
      this.mdMediaQueryListener.off('change');
      this.mdMediaQueryListener = null;
    }
    if (this.lgMediaQueryListener) {
      this.lgMediaQueryListener.off('change');
      this.lgMediaQueryListener = null;
    }
    if (this.breakpointDebounceTimer !== -1) {
      clearTimeout(this.breakpointDebounceTimer);
      this.breakpointDebounceTimer = -1;
    }
  }

  // 格式化最近设备的时间戳
  formatTimestamp(timestamp: number): string {
    const now = Date.now();
    const diff = now - timestamp;
    if (diff < 60000) {
      return 'Just now';
    } else if (diff < 3600000) {
      return `${Math.floor(diff / 60000)}m ago`;
    } else if (diff < 86400000) {
      return `${Math.floor(diff / 3600000)}h ago`;
    } else {
      return `${Math.floor(diff / 86400000)}d ago`;
    }
  }

  @Builder
  pianoKeyboard() {
    Column() {
      Text('Virtual Piano Keyboard')
        .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 12 })

      if (this.openOutputPorts.size === 0) {
        Text('Open an output port to play')
          .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
          .fontColor('#999999')
          .margin({ bottom: 8 })
      }

      // 响应式钢琴键盘容器
      if (this.currentBreakpoint === 'xs') {
        // xs断点：水平可滚动
        Scroll(this.pianoScroller) {
          Stack({ alignContent: Alignment.TopStart }) {
            this.pianoKeysBuilder()
          }
          .height(110)
        }
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Auto)
        .width('100%')
      } else {
        // 其他断点：适应容器
        Stack({ alignContent: Alignment.TopStart }) {
          this.pianoKeysBuilder()
        }
        .width('100%')
        .height(this.keyDimensions.whiteKeyHeight + 10)
      }

      // 通道选择器
      Row() {
        Text('Channel:')
          .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
        TextInput({ text: this.channelValue.toString() })
          .type(InputType.Number)
          .width(50)
          .height(32)
          .margin({ left: 8 })
          .onChange((value: string) => {
            const num = parseInt(value);
            if (!isNaN(num) && num >= 0 && num <= 15) {
              this.channelValue = num;
            }
          })
      }
      .margin({ top: 12 })
    }
    .width('100%')
    .padding(12)
    .backgroundColor(Color.White)
    .borderRadius(16)
  }

  @Builder
  pianoKeysBuilder() {
    // 白键行
    Row() {
      ForEach(WHITE_KEYS, (key: PianoKey) => {
        Column() {
          Text(key.name)
            .fontSize(getFontSize(FONT_SIZES, 'small', this.currentBreakpoint))
            .fontColor(this.activeKeys.has(key.note) ? '#FFFFFF' : '#333333')
        }
        .width(this.keyDimensions.whiteKeyWidth)
        .height(this.keyDimensions.whiteKeyHeight)
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(this.activeKeys.has(key.note) ? '#4CAF50' : '#FAFAFA')
        .borderWidth(1)
        .borderColor('#CCCCCC')
        .borderRadius({ bottomLeft: 4, bottomRight: 4 })
        .margin({ left: 1, right: 1 })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.onKeyPress(key.note);
          } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
            this.onKeyRelease(key.note);
          }
        })
      }, (key: PianoKey) => key.name)
    }
    .margin({ top: 0 })

    // 黑键行（覆盖层）
    Row() {
      ForEach(BLACK_KEYS, (key: PianoKey, index: number) => {
        Column() {
          Text(key.name.replace('#', ''))
            .fontSize(getFontSize(FONT_SIZES, 'pianoKey', this.currentBreakpoint))
            .fontColor('#FFFFFF')
        }
        .width(this.keyDimensions.blackKeyWidth)
        .height(this.keyDimensions.blackKeyHeight)
        .justifyContent(FlexAlign.End)
        .alignItems(HorizontalAlign.Center)
        .backgroundColor(this.activeKeys.has(key.note) ? '#E84026' : '#333333')
        .borderRadius({ bottomLeft: 4, bottomRight: 4 })
        .margin({
          left: index === 0
            ? this.keyDimensions.whiteKeyWidth * 0.65
            : this.keyDimensions.whiteKeyWidth * 0.3
        })
        .zIndex(1)
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Down) {
            this.onKeyPress(key.note);
          } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
            this.onKeyRelease(key.note);
          }
        })
      }, (key: PianoKey) => key.name)
    }
    .margin({ left: this.keyDimensions.whiteKeyWidth * 0.35, top: 0 })
  }

  build() {
    Column() {
      // 标题栏
      Row() {
        Text(this.message)
          .fontSize(getFontSize(FONT_SIZES, 'title', this.currentBreakpoint))
          .fontWeight(FontWeight.Bold)
          .fontColor('#182431')
          .maxLines(1)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
      }
      .width('100%')
      .height(this.currentBreakpoint === 'xs' ? 48 : 56)
      .padding({ left: 16, right: 16 })
      .backgroundColor(Color.White)

      Scroll() {
        Column({ space: 12 }) {
          // 客户端控制
          Column() {
            Text('Client Management')
              .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
              .fontWeight(FontWeight.Medium)
              .margin({ bottom: 12 })

            Row({ space: 12 }) {
              Button(this.clientCreated ? 'Destroy Client' : 'Create Client')
                .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                .width('45%')
                .backgroundColor(this.clientCreated ? '#E84026' : '#007DFF')
                .onClick(() => {
                  if (this.clientCreated) {
                    this.destroyClient();
                  } else {
                    this.createClient();
                  }
                })

              Button('Refresh Devices')
                .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                .width('45%')
                .enabled(this.clientCreated)
                .backgroundColor(this.clientCreated ? '#007DFF' : '#CCCCCC')
                .onClick(() => {
                  this.refreshDevices();
                })
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(16)

          // BLE MIDI部分
          if (this.clientCreated) {
            Column() {
              Text('Bluetooth MIDI')
                .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 12 })

              Text('Connect to BLE MIDI devices by entering their MAC address or select from recent devices')
                .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                .fontColor('#666666')
                .margin({ bottom: 8 })

              // BLE扫描部分
              Row({ space: 8 }) {
                Button(this.bleScanning ? 'Scanning...' : 'Scan for MIDI Devices')
                  .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                  .layoutWeight(1)
                  .height(40)
                  .backgroundColor(this.bleScanning ? '#CCCCCC' : '#4CAF50')
                  .enabled(!this.bleScanning)
                  .onClick(() => {
                    if (this.bleScanning) {
                      this.stopBleScan();
                    } else {
                      this.startBleScan();
                    }
                  })
                if (this.bleScanning) {
                  Button('Stop')
                    .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                    .width(70)
                    .height(40)
                    .backgroundColor('#E84026')
                    .onClick(() => {
                      this.stopBleScan();
                    })
                }
              }
              .width('100%')
              .margin({ bottom: 8 })

              // BLE扫描错误
              if (this.bleScanError.length > 0) {
                Text(this.bleScanError)
                  .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                  .fontColor('#E84026')
                  .margin({ bottom: 8 })
              }

              // 扫描到的BLE MIDI设备
              if (this.scannedBleDevices.length > 0) {
                Text('Found MIDI Devices:')
                  .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                  .fontColor('#888888')
                  .margin({ bottom: 4 })

                ForEach(this.scannedBleDevices, (device: ScannedBleDevice) => {
                  Row() {
                    Column() {
                      Text(device.name || 'MIDI Device')
                        .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                        .fontWeight(FontWeight.Medium)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(`RSSI: ${device.rssi} dBm | ${device.deviceId}`)
                        .fontSize(getFontSize(FONT_SIZES, 'small', this.currentBreakpoint))
                        .fontColor('#666666')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                    Button('Connect')
                      .fontSize(getFontSize(FONT_SIZES, 'small', this.currentBreakpoint))
                      .height(28)
                      .backgroundColor('#4CAF50')
                      .enabled(!this.bleConnecting)
                      .onClick(() => {
                        this.connectToScannedDevice(device);
                      })
                  }
                  .width('100%')
                  .padding(6)
                  .backgroundColor('#E8F5E9')
                  .borderRadius(6)
                  .margin({ bottom: 4 })
                }, (device: ScannedBleDevice) => device.deviceId)
              }

              // 分隔线
              Divider()
                .margin({ top: 8, bottom: 8 })

              // 最近连接的BLE设备，用于快速访问
              if (this.recentBleDevices.length > 0) {
                Text('Recent Devices:')
                  .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                  .fontColor('#888888')
                  .margin({ bottom: 4 })

                ForEach(this.recentBleDevices, (device: RecentBleDevice) => {
                  Row() {
                    Column() {
                      Text(device.name || 'BLE MIDI Device')
                        .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                        .fontWeight(FontWeight.Medium)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(`${device.address} - ${this.formatTimestamp(device.timestamp)}`)
                        .fontSize(getFontSize(FONT_SIZES, 'small', this.currentBreakpoint))
                        .fontColor('#666666')
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                    Row({ space: 4 }) {
                      Button('Connect')
                        .fontSize(getFontSize(FONT_SIZES, 'small', this.currentBreakpoint))
                        .height(28)
                        .backgroundColor('#4CAF50')
                        .enabled(!this.bleConnecting)
                        .onClick(() => {
                          this.bleDeviceAddress = device.address;
                          this.openBLEDevice(device.address);
                        })
                      Button('X')
                        .fontSize(getFontSize(FONT_SIZES, 'small', this.currentBreakpoint))
                        .width(45)
                        .height(28)
                        .backgroundColor('#E84026')
                        .onClick(() => {
                          this.removeRecentBleDevice(device.address);
                        })
                    }
                  }
                  .width('100%')
                  .padding(6)
                  .backgroundColor('#F0F8FF')
                  .borderRadius(6)
                  .margin({ bottom: 4 })
                }, (device: RecentBleDevice) => device.address)
              }

              Row({ space: 8 }) {
                TextInput({ placeholder: 'AA:BB:CC:DD:EE:FF', text: this.bleDeviceAddress })
                  .layoutWeight(1)
                  .height(40)
                  .onChange((value: string) => {
                    this.bleDeviceAddress = value.toUpperCase();
                  })
                Button(this.bleConnecting ? 'Connecting...' : 'Connect')
                  .width(80)
                  .height(40)
                  .enabled(!this.bleConnecting && this.bleDeviceAddress.length > 0)
                  .backgroundColor(this.bleConnecting ? '#CCCCCC' : '#007DFF')
                  .onClick(() => {
                    this.openBLEDevice(this.bleDeviceAddress);
                  })
              }
              .width('100%')
              .margin({ top: 8 })

              // 已发现的BLE设备
              if (this.bleDeviceList.length > 0) {
                Text('Connected BLE Devices:')
                  .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                  .fontColor('#666666')
                  .margin({ top: 12, bottom: 8 })

                ForEach(this.bleDeviceList, (device: MidiDeviceInfo) => {
                  Row() {
                    Column() {
                      Text(device.deviceName || 'BLE MIDI Device')
                        .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                        .fontWeight(FontWeight.Medium)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(`Address: ${device.deviceAddress}`)
                        .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                        .fontColor('#666666')
                        .margin({ top: 2 })
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)
                    Button(this.selectedDeviceId === device.deviceId ? 'Selected' : 'Select')
                      .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                      .width(100)
                      .backgroundColor(this.selectedDeviceId === device.deviceId ? '#4CAF50' : '#007DFF')
                      .onClick(() => {
                        this.selectDevice(device.deviceId);
                      })
                  }
                  .width('100%')
                  .padding(8)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(8)
                  .margin({ bottom: 4 })
                }, (device: MidiDeviceInfo) => device.deviceId.toString())
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(16)
          }

          // 设备列表
          if (this.clientCreated) {
            Column() {
              Row() {
                Text('Connected Devices')
                  .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
                  .fontWeight(FontWeight.Medium)
                Text(`(${this.deviceList.length})`)
                  .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                  .fontColor('#666666')
                  .margin({ left: 4 })
              }
              .width('100%')
              .margin({ bottom: 12 })

              if (this.deviceList.length === 0) {
                Text('No MIDI devices found. Connect a USB/BLE MIDI device.')
                  .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                  .fontColor('#999999')
                  .width('100%')
                  .textAlign(TextAlign.Center)
                  .padding(16)
              } else {
                ForEach(this.deviceList, (device: MidiDeviceInfo) => {
                  Row() {
                    Column() {
                      Text(device.deviceName || 'Unknown Device')
                        .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                        .fontWeight(FontWeight.Medium)
                        .maxLines(1)
                        .textOverflow({ overflow: TextOverflow.Ellipsis })
                      Text(`ID: ${device.deviceId} | Type: ${this.getDeviceTypeName(device.deviceType)}`)
                        .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                        .fontColor('#666666')
                        .margin({ top: 4 })
                    }
                    .alignItems(HorizontalAlign.Start)
                    .layoutWeight(1)

                    Radio({ value: device.deviceId.toString(), group: 'device' })
                      .checked(this.selectedDeviceId === device.deviceId)
                      .onChange((isChecked: boolean) => {
                        if (isChecked) {
                          this.selectDevice(device.deviceId);
                        }
                      })
                  }
                  .width('100%')
                  .padding(12)
                  .backgroundColor(this.selectedDeviceId === device.deviceId ? '#E6F4FF' : '#F5F5F5')
                  .borderRadius(8)
                  .margin({ bottom: 8 })
                }, (device: MidiDeviceInfo) => device.deviceId.toString())
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(16)
          }

          // 设备控制
          if (this.selectedDeviceId >= 0) {
            Column() {
              Text('Device Control')
                .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 12 })

              Row({ space: 12 }) {
                Button(this.isDeviceOpen ? 'Close Device' : 'Open Device')
                  .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                  .width('45%')
                  .backgroundColor(this.isDeviceOpen ? '#E84026' : '#007DFF')
                  .onClick(() => {
                    if (this.isDeviceOpen) {
                      this.closeDevice();
                    } else {
                      this.openDevice();
                    }
                  })
              }
              .width('100%')
              .justifyContent(FlexAlign.Center)
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(16)
          }

          // 端口管理
          if (this.isDeviceOpen) {
            Column() {
              Text('Port Management')
                .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 12 })

              // 输入端口
              if (this.inputPorts.length > 0) {
                Text('Input Ports (Receive MIDI)')
                  .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                  .fontColor('#666666')
                  .margin({ bottom: 8 })

                ForEach(this.inputPorts, (port: MidiPortInfo) => {
                  Row() {
                    Text(`Port ${port.portIndex}: ${port.name || 'Unnamed'}`)
                      .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                      .layoutWeight(1)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Button(this.openInputPorts.has(port.portIndex) ? 'Close' : 'Open')
                      .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                      .width(80)
                      .backgroundColor(this.openInputPorts.has(port.portIndex) ? '#E84026' : '#4CAF50')
                      .onClick(() => {
                        if (this.openInputPorts.has(port.portIndex)) {
                          this.closeInputPort(port.portIndex);
                        } else {
                          this.openInputPort(port.portIndex);
                        }
                      })
                  }
                  .width('100%')
                  .padding(8)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(8)
                  .margin({ bottom: 4 })
                }, (port: MidiPortInfo) => `in-${this.selectedDeviceId}-${port.portIndex}`)
              }

              // 输出端口
              if (this.outputPorts.length > 0) {
                Text('Output Ports (Send MIDI)')
                  .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                  .fontColor('#666666')
                  .margin({ top: 12, bottom: 8 })

                ForEach(this.outputPorts, (port: MidiPortInfo) => {
                  Row() {
                    Text(`Port ${port.portIndex}: ${port.name || 'Unnamed'}`)
                      .fontSize(getFontSize(FONT_SIZES, 'body', this.currentBreakpoint))
                      .layoutWeight(1)
                      .maxLines(1)
                      .textOverflow({ overflow: TextOverflow.Ellipsis })
                    Button(this.openOutputPorts.has(port.portIndex) ? 'Close' : 'Open')
                      .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                      .width(80)
                      .backgroundColor(this.openOutputPorts.has(port.portIndex) ? '#E84026' : '#4CAF50')
                      .onClick(() => {
                        if (this.openOutputPorts.has(port.portIndex)) {
                          this.closeOutputPort(port.portIndex);
                        } else {
                          this.openOutputPort(port.portIndex);
                        }
                      })
                  }
                  .width('100%')
                  .padding(8)
                  .backgroundColor('#F5F5F5')
                  .borderRadius(8)
                  .margin({ bottom: 4 })
                }, (port: MidiPortInfo) => `out-${this.selectedDeviceId}-${port.portIndex}`)
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(16)
          }

          // 虚拟钢琴键盘
          if (this.isDeviceOpen) {
            this.pianoKeyboard()
          }

          // MIDI输入显示
          if (this.openInputPorts.size > 0) {
            Column() {
              Row() {
                Text('MIDI Input Monitor')
                  .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
                  .fontWeight(FontWeight.Medium)
                  .layoutWeight(1)
                Button('Clear')
                  .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                  .height(28)
                  .width(100)
                  .backgroundColor('#E84026')
                  .enabled(this.receivedMessages.length > 0)
                  .opacity(this.receivedMessages.length > 0 ? 1 : 0.5)
                  .onClick(() => {
                    this.clearMidiInput();
                  })
              }
              .width('100%')
              .margin({ bottom: 8 })

              Scroll(this.midiInputScroller) {
                Text(this.receivedMessages.length > 0 ? this.receivedMessages.join('\n') : 'Waiting for MIDI input...')
                  .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                  .fontColor(this.receivedMessages.length > 0 ? '#333333' : '#999999')
                  .width('100%')
              }
              .width('100%')
              .height(100)
              .backgroundColor('#F5F5F5')
              .borderRadius(8)
              .padding(8)
              .scrollable(ScrollDirection.Vertical)
              .scrollBar(BarState.Auto)
              .align(Alignment.TopStart)
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(16)
            .alignItems(HorizontalAlign.Start)
          }

          // 日志面板
          Column() {
            Row() {
              Text('Event Log')
                .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
                .fontWeight(FontWeight.Medium)
                .layoutWeight(1)
              Button('Clear')
                .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                .height(28)
                .width(100)
                .backgroundColor('#E84026')
                .enabled(this.logMessages.length > 0)
                .opacity(this.logMessages.length > 0 ? 1 : 0.5)
                .onClick(() => {
                  this.clearLog();
                })
            }
            .width('100%')
            .margin({ bottom: 8 })

            Scroll(this.logScroller) {
              Text(this.logMessages.length > 0 ? this.logMessages.join('\n') : 'No events logged')
                .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                .fontColor(this.logMessages.length > 0 ? '#333333' : '#999999')
                .width('100%')
            }
            .width('100%')
            .height(120)
            .backgroundColor('#F5F5F5')
            .borderRadius(8)
            .padding(8)
            .scrollable(ScrollDirection.Vertical)
            .scrollBar(BarState.Auto)
            .align(Alignment.TopStart)
          }
          .width('100%')
          .padding(12)
          .backgroundColor(Color.White)
          .borderRadius(16)
          .alignItems(HorizontalAlign.Start)
        }
        .padding(12)
      }
      .width('100%')
      .layoutWeight(1)
      .backgroundColor('#F1F3F5')
    }
    .width('100%')
    .height('100%')
  }
}
