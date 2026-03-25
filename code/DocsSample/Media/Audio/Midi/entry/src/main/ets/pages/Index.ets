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

// Event IDs for async callback handling
const EVENT_DEVICE_CHANGE = 1001;
const EVENT_MIDI_RECEIVED = 1002;
const EVENT_BLE_OPENED = 1003;

// Event data interfaces
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

// Piano key interface
interface PianoKey {
  note: number;
  name: string;
  isBlack: boolean;
}

// Recent BLE device interface for local storage
interface RecentBleDevice {
  address: string;
  name: string;
  timestamp: number;
}

// Scanned BLE device interface
interface ScannedBleDevice {
  deviceId: string;
  rssi: number;
  name: string;
}

// Piano key dimensions interface
interface PianoKeyDimensions {
  whiteKeyWidth: number;
  whiteKeyHeight: number;
  blackKeyWidth: number;
  blackKeyHeight: number;
}

// Breakpoint type for responsive design
type BreakpointType = 'xs' | 'sm' | 'md' | 'lg';

// Breakpoint sizes interface - defines values for each breakpoint
interface BreakpointSizes {
  xs: number;
  sm: number;
  md: number;
  lg: number;
}

// Font sizes configuration interface
interface FontSizesConfig {
  title: BreakpointSizes;
  subtitle: BreakpointSizes;
  body: BreakpointSizes;
  caption: BreakpointSizes;
  small: BreakpointSizes;
  pianoKey: BreakpointSizes;
}

// Responsive font sizes configuration
const FONT_SIZES: FontSizesConfig = {
  title: { xs: 18, sm: 20, md: 24, lg: 28 },
  subtitle: { xs: 14, sm: 16, md: 16, lg: 18 },
  body: { xs: 12, sm: 14, md: 14, lg: 14 },
  caption: { xs: 12, sm: 12, md: 12, lg: 12 },
  small: { xs: 10, sm: 10, md: 10, lg: 10 },
  pianoKey: { xs: 6, sm: 7, md: 8, lg: 8 }
};

// Helper function to get font size (avoids dynamic index access)
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

// Piano keys configuration (C4 to C5, one octave)
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
  @State logMessages: string[] = []; // Changed to array for better performance
  @State isDeviceOpen: boolean = false;
  @State openInputPorts: Set<number> = new Set<number>();
  @State openOutputPorts: Set<number> = new Set<number>();
  @State receivedMessages: string[] = []; // Changed to array for better performance
  @State channelValue: number = 0;
  @State activeKeys: Set<number> = new Set<number>();
  @State keyDimensions: PianoKeyDimensions = {
    whiteKeyWidth: 40, whiteKeyHeight: 140, blackKeyWidth: 28, blackKeyHeight: 90
  };

  // BLE related states
  @State bleDeviceAddress: string = '';
  @State bleScanning: boolean = false;
  @State bleDeviceList: MidiDeviceInfo[] = [];
  @State bleConnecting: boolean = false;
  @State recentBleDevices: RecentBleDevice[] = []; // Recent BLE devices for quick access
  @State scannedBleDevices: ScannedBleDevice[] = []; // Scanned BLE MIDI devices
  @State bleScanError: string = ''; // BLE scan error message

  // Responsive design states
  @State currentBreakpoint: BreakpointType = 'md';

  // Media query listeners
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
    // Setup responsive design media query listeners
    this.setupMediaQueryListeners();
    // Register event listeners for async callback handling
    this.registerEventListeners();
    // Initialize preferences for recent devices
    this.initPreferences();
    this.log('MIDI Sample initialized');
    this.log('Tap "Create Client" to start');
    this.log('Use BLE section to connect Bluetooth MIDI devices');
    hilog.info(DOMAIN, TAG, '[aboutToAppear] --exit');
  }

  aboutToDisappear(): void {
    hilog.info(DOMAIN, TAG, '[aboutToDisappear] ++enter');
    // Teardown responsive design media query listeners
    this.teardownMediaQueryListeners();
    // Stop BLE scan if active
    if (this.bleScanning) {
      this.stopBleScan();
    }
    this.unregisterEventListeners();
    this.cleanup();
    hilog.info(DOMAIN, TAG, '[aboutToDisappear] --exit');
  }

  // Register event listeners to handle callbacks on main thread
  registerEventListeners(): void {
    hilog.info(DOMAIN, TAG, '[registerEventListeners] ++enter');

    // Device change event
    emitter.on({ eventId: EVENT_DEVICE_CHANGE }, (eventData: emitter.EventData) => {
      const data: DeviceChangeEventData = eventData.data as DeviceChangeEventData;
      hilog.info(DOMAIN, TAG,
        '[registerEventListeners] received EVENT_DEVICE_CHANGE, deviceId=%{public}d', data.deviceId);
      this.handleDeviceChange(data);
    });

    // MIDI received event
    emitter.on({ eventId: EVENT_MIDI_RECEIVED }, (eventData: emitter.EventData) => {
      const data: MidiReceivedEventData = eventData.data as MidiReceivedEventData;
      hilog.info(DOMAIN, TAG,
        '[registerEventListeners] received EVENT_MIDI_RECEIVED, dataCount=%{public}d', data.umpData.length);
      this.handleMidiReceived(data.umpData);
    });

    // BLE opened event
    emitter.on({ eventId: EVENT_BLE_OPENED }, (eventData: emitter.EventData) => {
      const data: BleOpenedEventData = eventData.data as BleOpenedEventData;
      hilog.info(DOMAIN, TAG,
        '[registerEventListeners] received EVENT_BLE_OPENED, opened=%{public}s', data.opened.toString());
      this.handleBleOpened(data);
    });

    hilog.info(DOMAIN, TAG, '[registerEventListeners] --exit, events registered: %{public}d, %{public}d, %{public}d',
      EVENT_DEVICE_CHANGE, EVENT_MIDI_RECEIVED, EVENT_BLE_OPENED);
  }

  unregisterEventListeners(): void {
    hilog.info(DOMAIN, TAG, '[unregisterEventListeners] ++enter');
    emitter.off(EVENT_DEVICE_CHANGE);
    emitter.off(EVENT_MIDI_RECEIVED);
    emitter.off(EVENT_BLE_OPENED);
    hilog.info(DOMAIN, TAG, '[unregisterEventListeners] --exit, all events unregistered');
  }

  // Initialize preferences for storing recent BLE devices
  async initPreferences(): Promise<void> {
    try {
      // Use getUIContext().getHostContext() instead of deprecated getContext
      const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
      this.preferencesStore = await preferences.getPreferences(context, 'midi_recent_devices');
      await this.loadRecentBleDevices();
      hilog.info(DOMAIN, TAG, '[initPreferences] preferences initialized');
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[initPreferences] failed: %{public}s', JSON.stringify(e));
    }
  }

  // Load recent BLE devices from preferences
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

  // Save recent BLE devices to preferences
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

  // Add device to recent list
  async addRecentBleDevice(address: string, name: string): Promise<void> {
    // Remove existing entry for same address
    this.recentBleDevices = this.recentBleDevices.filter(d => d.address !== address);
    // Add new entry at the beginning
    this.recentBleDevices.unshift({
      address: address,
      name: name || 'BLE MIDI Device',
      timestamp: Date.now()
    });
    // Keep only max devices
    if (this.recentBleDevices.length > this.MAX_RECENT_DEVICES) {
      this.recentBleDevices = this.recentBleDevices.slice(0, this.MAX_RECENT_DEVICES);
    }
    await this.saveRecentBleDevices();
  }

  // Remove device from recent list
  async removeRecentBleDevice(address: string): Promise<void> {
    this.recentBleDevices = this.recentBleDevices.filter(d => d.address !== address);
    await this.saveRecentBleDevices();
  }

  // BLE Scanner Methods
  private bleScanner: ble.BleScanner = ble.createBleScanner();
  private bleScanTimer: number = -1; // Timer for BLE scan timeout


  // BLE device found callback
  onBleDeviceFound = (scanReport: ble.ScanReport): void => {
    hilog.info(DOMAIN, TAG, '[onBleDeviceFound] received scan report');

    // scanResult is an array, iterate through each result
    if (!scanReport.scanResult || scanReport.scanResult.length === 0) {
      return;
    }

    for (const result of scanReport.scanResult) {
      const deviceId: string = result.deviceId;
      const rssi: number = result.rssi;
      // ScanResult may not have localName, use 'Unknown' as default
      // Device name can be parsed from advertisement data if needed
      const name: string = result.deviceName;

      // Check if already in list
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

  // Start BLE scan for MIDI devices
  async startBleScan(): Promise<void> {
    hilog.info(DOMAIN, TAG, '[startBleScan] ++enter');
    this.bleScanError = '';
    this.scannedBleDevices = [];

    try {
      // Request runtime permissions for Bluetooth scanning
      const permissions: Permissions[] = [
        'ohos.permission.ACCESS_BLUETOOTH',
        'ohos.permission.DISCOVER_BLUETOOTH'
      ];

      try {
        const atManager = abilityAccessCtrl.createAtManager();
        const context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        const grantResults = await atManager.requestPermissionsFromUser(context, permissions);
        hilog.info(DOMAIN, TAG, '[startBleScan] Permission request results: %{public}s', JSON.stringify(grantResults));

        // Check if all permissions are granted (authResults: 0 = granted)
        const allGranted = grantResults.authResults.every((result: number) => result === 0);
        if (!allGranted) {
          this.bleScanError = 'Required permissions not granted';
          this.log('Error: Required permissions not granted');
          return;
        }
      } catch (permErr) {
        hilog.error(DOMAIN, TAG, '[startBleScan] Permission request failed: %{public}s', JSON.stringify(permErr));
        this.bleScanError = 'Permission request failed';
        this.log('Error: Permission request failed');
        return;
      }

      // Check if Bluetooth is enabled
      // Note: We try to start scan directly, if Bluetooth is off it will fail with an error
      // This is a more reliable approach than checking state which may require additional APIs
      hilog.info(DOMAIN, TAG, '[startBleScan] Proceeding with BLE scan...');

      // Clear any existing scan timer
      if (this.bleScanTimer !== -1) {
        clearTimeout(this.bleScanTimer);
        this.bleScanTimer = -1;
      }

      // Set up scan callback
      this.bleScanner.on('BLEDeviceFind', this.onBleDeviceFound);

      // Start scanning with proper scan options
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

      // Auto-stop after 30 seconds
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

  // Stop BLE scan
  stopBleScan(): void {
    hilog.info(DOMAIN, TAG, '[stopBleScan] ++enter');
    try {
      // Clear scan timer
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

  // Connect to a scanned BLE device
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
    // Keep only max entries
    if (this.logMessages.length > this.MAX_LOG_ENTRIES) {
      this.logMessages = this.logMessages.slice(0, this.MAX_LOG_ENTRIES);
    }
    this.scrollToTopWithDebounce(this.logScroller);
  }

  logMidiInput(msg: string): void {
    hilog.info(DOMAIN, TAG, 'MIDI Input: %{public}s', msg);
    const timestamp = new Date().toLocaleTimeString();
    this.receivedMessages.unshift(`[${timestamp}] ${msg}`);
    // Keep only max entries
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

  // Scroll to top with debounce for performance
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
        // Close all ports
        this.openInputPorts.forEach((portIndex: number) => {
          hilog.info(DOMAIN, TAG, '[cleanup] closing input port %{public}d', portIndex);
          midi.closeInputPort(this.selectedDeviceId, portIndex);
        });
        this.openOutputPorts.forEach((portIndex: number) => {
          hilog.info(DOMAIN, TAG, '[cleanup] closing output port %{public}d', portIndex);
          midi.closeOutputPort(this.selectedDeviceId, portIndex);
        });
        // Close device
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

  createClient(): void {
    hilog.info(DOMAIN, TAG, '[createClient] ++enter');
    try {
      const status = midi.createMIDIClient((action: number, deviceInfo: MidiDeviceInfo) => {
        // In callback: only copy data and emit event, do not hold locks or execute heavy operations
        hilog.info(DOMAIN, TAG, '[createClient/callback] action=%{public}d, deviceId=%{public}d, deviceName=%{public}s',
          action, deviceInfo.deviceId, deviceInfo.deviceName);
        const eventData: DeviceChangeEventData = {
          action: action,
          deviceId: deviceInfo.deviceId,
          deviceName: deviceInfo.deviceName,
          deviceType: deviceInfo.deviceType,
          deviceAddress: deviceInfo.deviceAddress
        };
        emitter.emit({ eventId: EVENT_DEVICE_CHANGE }, { data: eventData });
        hilog.info(DOMAIN, TAG, '[createClient/callback] event emitted, eventId=%{public}d', EVENT_DEVICE_CHANGE);
      });

      hilog.info(DOMAIN, TAG, '[createClient] createMIDIClient returned status=%{public}d', status);
      if (status === MidiStatusCode.OK) {
        this.clientCreated = true;
        this.log('MIDI client created successfully');
        hilog.info(DOMAIN, TAG, '[createClient] clientCreated set to true');
        this.refreshDevices();
      } else {
        this.log(`Failed to create client: ${status}`);
        hilog.error(DOMAIN, TAG, '[createClient] failed with status=%{public}d', status);
      }
      hilog.info(DOMAIN, TAG, '[createClient] --exit, status=%{public}d', status);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[createClient] exception: %{public}s', JSON.stringify(e));
      this.log(`Error creating client: ${JSON.stringify(e)}`);
    }
  }

  destroyClient(): void {
    hilog.info(DOMAIN, TAG, '[destroyClient] ++enter, clientCreated=%{public}s', this.clientCreated.toString());
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
      hilog.info(DOMAIN, TAG, '[destroyClient] --exit, all states reset');
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[destroyClient] exception: %{public}s', JSON.stringify(e));
      this.log(`Error destroying client: ${JSON.stringify(e)}`);
    }
  }

  // Handle device change on main thread (called from event listener)
  handleDeviceChange(data: DeviceChangeEventData): void {
    hilog.info(DOMAIN, TAG,
      '[handleDeviceChange] ++enter, action=%{public}d, deviceId=%{public}d, ' +
      'deviceName=%{public}s, deviceType=%{public}d, deviceAddress=%{public}s',
      data.action, data.deviceId, data.deviceName, data.deviceType, data.deviceAddress);

    if (data.action === 0) { // CONNECTED
      this.log(`Device connected: ${data.deviceName} (ID: ${data.deviceId})`);
      // Add to BLE device list if it's a BLE device
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
    } else { // DISCONNECTED
      this.log(`Device disconnected: ${data.deviceName} (ID: ${data.deviceId})`);
      // Remove from BLE device list
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

  refreshDevices(): void {
    hilog.info(DOMAIN, TAG, '[refreshDevices] ++enter');
    try {
      const count = midi.getDeviceCount();
      hilog.info(DOMAIN, TAG, '[refreshDevices] deviceCount=%{public}d', count);
      if (count > 0) {
        this.deviceList = midi.getDeviceInfos();
        hilog.info(DOMAIN, TAG, '[refreshDevices] got %{public}d devices', this.deviceList.length);
        // Log each device info
        this.deviceList.forEach((device, index) => {
          hilog.info(DOMAIN, TAG,
            '[refreshDevices] device[%{public}d]: id=%{public}d, name=%{public}s, type=%{public}d',
            index, device.deviceId, device.deviceName, device.deviceType);
        });
      } else {
        this.deviceList = [];
        hilog.info(DOMAIN, TAG, '[refreshDevices] no devices found');
      }
      hilog.info(DOMAIN, TAG, '[refreshDevices] --exit, deviceList.length=%{public}d', this.deviceList.length);
    } catch (e) {
      hilog.error(DOMAIN, TAG, '[refreshDevices] exception: %{public}s', JSON.stringify(e));
      this.log(`Error refreshing devices: ${JSON.stringify(e)}`);
    }
  }

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

  loadPorts(deviceId: number): void {
    hilog.info(DOMAIN, TAG, '[loadPorts] ++enter, deviceId=%{public}d', deviceId);
    try {
      const count = midi.getPortCount(deviceId);
      hilog.info(DOMAIN, TAG, '[loadPorts] portCount=%{public}d', count);
      if (count > 0) {
        this.portList = midi.getPortInfos(deviceId);
        this.inputPorts = this.portList.filter(p => p.direction === MidiPortDirection.INPUT);
        this.outputPorts = this.portList.filter(p => p.direction === MidiPortDirection.OUTPUT);
        hilog.info(DOMAIN, TAG, '[loadPorts] totalPorts=%{public}d, inputPorts=%{public}d, outputPorts=%{public}d',
          this.portList.length, this.inputPorts.length, this.outputPorts.length);
        // Log each port info
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

  openDevice(): void {
    hilog.info(DOMAIN, TAG, '[openDevice] ++enter, selectedDeviceId=%{public}d', this.selectedDeviceId);

    if (this.selectedDeviceId < 0) {
      hilog.warn(DOMAIN, TAG, '[openDevice] no device selected');
      this.log('Please select a device first');
      return;
    }

    try {
      hilog.info(DOMAIN, TAG, '[openDevice] calling midi.openDevice(%{public}d)', this.selectedDeviceId);
      const status = midi.openDevice(this.selectedDeviceId);
      hilog.info(DOMAIN, TAG, '[openDevice] openDevice returned status=%{public}d', status);

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

  closeDevice(): void {
    hilog.info(DOMAIN, TAG, '[closeDevice] ++enter, selectedDeviceId=%{public}d', this.selectedDeviceId);

    if (this.selectedDeviceId < 0) {
      hilog.warn(DOMAIN, TAG, '[closeDevice] no device selected');
      return;
    }

    try {
      // Close all ports first
      hilog.info(DOMAIN, TAG, '[closeDevice] closing all ports, inputCount=%{public}d, outputCount=%{public}d',
        this.openInputPorts.size, this.openOutputPorts.size);
      this.openInputPorts.forEach((portIndex: number) => {
        hilog.info(DOMAIN, TAG, '[closeDevice] closing input port %{public}d', portIndex);
        midi.closeInputPort(this.selectedDeviceId, portIndex);
      });
      this.openOutputPorts.forEach((portIndex: number) => {
        hilog.info(DOMAIN, TAG, '[closeDevice] closing output port %{public}d', portIndex);
        midi.closeOutputPort(this.selectedDeviceId, portIndex);
      });
      this.openInputPorts.clear();
      this.openOutputPorts.clear();
      this.activeKeys.clear();

      hilog.info(DOMAIN, TAG, '[closeDevice] calling midi.closeDevice(%{public}d)', this.selectedDeviceId);
      const status = midi.closeDevice(this.selectedDeviceId);
      hilog.info(DOMAIN, TAG, '[closeDevice] closeDevice returned status=%{public}d', status);

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

  // Handle MIDI received on main thread (called from event listener)
  handleMidiReceived(umpData: number[]): void {
    hilog.info(DOMAIN, TAG, '[handleMidiReceived] ++enter, dataCount=%{public}d', umpData.length);

    for (const ump of umpData) {
      // Parse UMP message
      const messageType = (ump >> 28) & 0x0F;
      const status = (ump >> 20) & 0x0F;
      const channel = (ump >> 16) & 0x0F;

      hilog.debug(DOMAIN, TAG,
        '[handleMidiReceived] UMP=0x%{public}X, type=%{public}d, status=%{public}d, ch=%{public}d',
        ump, messageType, status, channel);

      if (messageType === 0x2) { // MIDI 1.0 Channel Voice
        switch (status) {
          case 0x8: // Note Off
            this.handleNoteOff(ump, channel);
            break;
          case 0x9: // Note On
            this.handleNoteOn(ump, channel);
            break;
          case 0xA: // Polyphonic Aftertouch
            this.handlePolyAftertouch(ump, channel);
            break;
          case 0xB: // Control Change
            this.handleControlChange(ump, channel);
            break;
          case 0xC: // Program Change
            this.handleProgramChange(ump, channel);
            break;
          case 0xD: // Channel Aftertouch
            this.handleChannelAftertouch(ump, channel);
            break;
          case 0xE: // Pitch Bend
            this.handlePitchBend(ump, channel);
            break;
          default:
            this.logMidiInput(`UMP: 0x${ump.toString(16).toUpperCase()}`);
            hilog.info(DOMAIN, TAG, '[handleMidiReceived] Unknown status: 0x%{public}X', status);
            break;
        }
      } else if (messageType === 0x0 || messageType === 0x1) {
        // System messages and utility messages - check for realtime filtering
        const statusByte = (ump >> 16) & 0xFF;
        if (!this.shouldFilterRealtimeMessage(statusByte)) {
          this.logMidiInput(`System: 0x${ump.toString(16).toUpperCase()}`);
          hilog.info(DOMAIN, TAG, '[handleMidiReceived] System message: 0x%{public}X', ump);
        }
      } else {
        // Other UMP types (MIDI 2.0, etc)
        this.logMidiInput(`UMP: 0x${ump.toString(16).toUpperCase()}`);
        hilog.info(DOMAIN, TAG, '[handleMidiReceived] Non-MIDI1.0 UMP: 0x%{public}X', ump);
      }
    }
    hilog.info(DOMAIN, TAG, '[handleMidiReceived] --exit, activeKeys.size=%{public}d', this.activeKeys.size);
  }

  // Handle Note On message
  handleNoteOn(ump: number, channel: number): void {
    const note = (ump >> 8) & 0x7F;
    const velocity = ump & 0x7F;
    if (velocity > 0) {
      const noteName = this.noteToName(note);
      this.logMidiInput(`Note On: ch${channel}, ${noteName}(note=${note}), vel=${velocity}`);
      this.activeKeys.add(note);
      hilog.info(DOMAIN, TAG, '[handleNoteOn] note=%{public}d, vel=%{public}d', note, velocity);
    } else {
      // Velocity 0 means Note Off
      this.handleNoteOff(ump, channel);
    }
  }

  // Handle Note Off message
  handleNoteOff(ump: number, channel: number): void {
    const note = (ump >> 8) & 0x7F;
    const velocity = ump & 0x7F;
    const noteName = this.noteToName(note);
    this.logMidiInput(`Note Off: ch${channel}, ${noteName}(note=${note}), vel=${velocity}`);
    this.activeKeys.delete(note);
    hilog.info(DOMAIN, TAG, '[handleNoteOff] note=%{public}d, vel=%{public}d', note, velocity);
  }

  // Handle Polyphonic Aftertouch message
  handlePolyAftertouch(ump: number, channel: number): void {
    const note = (ump >> 8) & 0x7F;
    const pressure = ump & 0x7F;
    const noteName = this.noteToName(note);
    this.logMidiInput(`Poly AT: ch${channel}, ${noteName}, pressure=${pressure}`);
    hilog.info(DOMAIN, TAG, '[handlePolyAftertouch] note=%{public}d, pressure=%{public}d', note, pressure);
  }

  // Handle Control Change message
  handleControlChange(ump: number, channel: number): void {
    const controller = (ump >> 8) & 0x7F;
    const value = ump & 0x7F;
    const controllerName = this.getControllerName(controller);
    this.logMidiInput(`CC: ch${channel}, ${controllerName}(cc=${controller}), val=${value}`);
    hilog.info(DOMAIN, TAG, '[handleControlChange] cc=%{public}d, val=%{public}d', controller, value);
  }

  // Handle Program Change message
  handleProgramChange(ump: number, channel: number): void {
    const program = (ump >> 8) & 0x7F;
    this.logMidiInput(`PC: ch${channel}, program=${program}`);
    hilog.info(DOMAIN, TAG, '[handleProgramChange] program=%{public}d', program);
  }

  // Handle Channel Aftertouch message
  handleChannelAftertouch(ump: number, channel: number): void {
    const pressure = (ump >> 8) & 0x7F;
    this.logMidiInput(`Ch AT: ch${channel}, pressure=${pressure}`);
    hilog.info(DOMAIN, TAG, '[handleChannelAftertouch] pressure=%{public}d', pressure);
  }

  // Handle Pitch Bend message
  handlePitchBend(ump: number, channel: number): void {
    const lsb = (ump >> 8) & 0x7F;
    const msb = ump & 0x7F;
    const bendValue = (msb << 7) | lsb;
    const bendRange = bendValue - 8192; // Center is 8192
    this.logMidiInput(`Pitch: ch${channel}, bend=${bendRange} (raw=${bendValue})`);
    hilog.info(DOMAIN, TAG, '[handlePitchBend] bend=%{public}d, raw=%{public}d', bendRange, bendValue);
  }

  // Check if message should be filtered (realtime messages)
  shouldFilterRealtimeMessage(statusByte: number): boolean {
    // Realtime messages: 0xF8 (Clock), 0xFA (Start), 0xFB (Continue), 0xFC (Stop), 0xFE (Active Sensing), 0xFF (Reset)
    return statusByte >= 0xF8;
  }

  // Convert MIDI note number to name
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

  // Get common controller name
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

  openInputPort(portIndex: number): void {
    hilog.info(DOMAIN, TAG, '[openInputPort] ++enter, deviceId=%{public}d, portIndex=%{public}d',
      this.selectedDeviceId, portIndex);

    try {
      const status = midi.openInputPort(
        this.selectedDeviceId,
        portIndex,
        1, // MIDI 1.0 protocol
        (events: MidiEvent[]) => {
          // In callback: only copy data and emit event, do not hold locks or execute heavy operations
          hilog.debug(DOMAIN, TAG, '[openInputPort/callback] received %{public}d events', events.length);
          const umpData: number[] = [];
          for (const event of events) {
            if (event.data && event.data.length > 0) {
              // Traverse all elements in event.data array
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

  closeInputPort(portIndex: number): void {
    hilog.info(DOMAIN, TAG, '[closeInputPort] ++enter, deviceId=%{public}d, portIndex=%{public}d',
      this.selectedDeviceId, portIndex);

    try {
      const status = midi.closeInputPort(this.selectedDeviceId, portIndex);
      hilog.info(DOMAIN, TAG, '[closeInputPort] closeInputPort returned status=%{public}d', status);

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

  openOutputPort(portIndex: number): void {
    hilog.info(DOMAIN, TAG, '[openOutputPort] ++enter, deviceId=%{public}d, portIndex=%{public}d',
      this.selectedDeviceId, portIndex);

    try {
      const status = midi.openOutputPort(this.selectedDeviceId, portIndex, 1);
      hilog.info(DOMAIN, TAG, '[openOutputPort] openOutputPort returned status=%{public}d', status);

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

  closeOutputPort(portIndex: number): void {
    hilog.info(DOMAIN, TAG, '[closeOutputPort] ++enter, deviceId=%{public}d, portIndex=%{public}d',
      this.selectedDeviceId, portIndex);

    try {
      const status = midi.closeOutputPort(this.selectedDeviceId, portIndex);
      hilog.info(DOMAIN, TAG, '[closeOutputPort] closeOutputPort returned status=%{public}d', status);

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

  // Piano key handlers
  onKeyPress(note: number): void {
    hilog.debug(DOMAIN, TAG, '[onKeyPress] ++enter, note=%{public}d, openOutputPorts.size=%{public}d',
      note, this.openOutputPorts.size);

    if (this.openOutputPorts.size === 0) {
      hilog.warn(DOMAIN, TAG, '[onKeyPress] no output port open');
      this.log('Please open an output port first');
      return;
    }

    const portIndex = Array.from(this.openOutputPorts)[0];
    this.activeKeys.add(note);

    try {
      hilog.debug(DOMAIN, TAG,
        '[onKeyPress] sending NoteOn, deviceId=%{public}d, portIndex=%{public}d, channel=%{public}d, note=%{public}d',
        this.selectedDeviceId, portIndex, this.channelValue, note);
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
    hilog.debug(DOMAIN, TAG, '[onKeyPress] --exit');
  }

  onKeyRelease(note: number): void {
    hilog.debug(DOMAIN, TAG, '[onKeyRelease] ++enter, note=%{public}d, openOutputPorts.size=%{public}d',
      note, this.openOutputPorts.size);

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

  // Handle BLE opened on main thread (called from event listener)
  handleBleOpened(data: BleOpenedEventData): void {
    hilog.info(DOMAIN, TAG, '[handleBleOpened] opened=%{public}s, devId=%{public}d, name=%{public}s, type=%{public}d',
      data.opened.toString(), data.deviceId, data.deviceName, data.deviceType);

    this.bleConnecting = false;
    if (data.opened) {
      this.log(`BLE device connected: ${data.deviceName}`);
      this.log(`Device ID: ${data.deviceId}`);
      // Add to recent BLE devices
      this.addRecentBleDevice(data.deviceAddress, data.deviceName);
      // Add to BLE device list
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

      // Auto-select and open the device
      this.selectedDeviceId = data.deviceId;

      // The device is already opened in C++ (stored in g_openedDevices)
      // So we need to update our state to reflect this
      this.isDeviceOpen = true;
      hilog.info(DOMAIN, TAG, '[handleBleOpened] device is already opened, isDeviceOpen set to true');

      // Load port information
      this.loadPorts(data.deviceId);

      // Refresh main device list
      this.refreshDevices();

      this.log(`Device opened automatically, you can now open ports`);
    } else {
      this.log(`Failed to connect to BLE device`);
      hilog.error(DOMAIN, TAG, '[handleBleOpened] BLE connection failed');
    }
    hilog.info(DOMAIN, TAG, '[handleBleOpened] --exit');
  }

  // BLE Device functions
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
      hilog.info(DOMAIN, TAG, '[openBLEDevice] calling midi.openBLEDevice(%{public}s)', deviceAddress);
      const status = midi.openBLEDevice(deviceAddress, (opened: boolean, deviceInfo: MidiDeviceInfo) => {
        // In callback: only copy data and emit event, do not hold locks or execute heavy operations
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

  getDeviceTypeName(type: MidiDeviceType): string {
    return type === MidiDeviceType.USB ? 'USB' : 'BLE';
  }

  getPortDirectionName(direction: MidiPortDirection): string {
    return direction === MidiPortDirection.INPUT ? 'IN' : 'OUT';
  }

  // Update responsive key dimensions based on breakpoint
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

  // Setup media query listeners for responsive design
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

    // Set initial breakpoint
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

  // Handle breakpoint change with debounce
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

  // Teardown media query listeners
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

  // Format timestamp for recent devices
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

      // Responsive piano keyboard container
      if (this.currentBreakpoint === 'xs') {
        // xs breakpoint: horizontal scrollable
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
        // Other breakpoints: fit within container
        Stack({ alignContent: Alignment.TopStart }) {
          this.pianoKeysBuilder()
        }
        .width('100%')
        .height(this.keyDimensions.whiteKeyHeight + 10)
      }

      // Channel selector
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
    // White keys row
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

    // Black keys row (overlayed)
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
      // Header
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
          // Client Controls
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

          // BLE MIDI Section
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

              // BLE Scan Section
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

              // BLE Scan Error
              if (this.bleScanError.length > 0) {
                Text(this.bleScanError)
                  .fontSize(getFontSize(FONT_SIZES, 'caption', this.currentBreakpoint))
                  .fontColor('#E84026')
                  .margin({ bottom: 8 })
              }

              // Scanned BLE MIDI Devices
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

              // Divider
              Divider()
                .margin({ top: 8, bottom: 8 })

              // Recent BLE devices for quick access
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

              // Discovered BLE devices
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

          // Device List
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

          // Device Controls
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

          // Port Management
          if (this.isDeviceOpen) {
            Column() {
              Text('Port Management')
                .fontSize(getFontSize(FONT_SIZES, 'subtitle', this.currentBreakpoint))
                .fontWeight(FontWeight.Medium)
                .margin({ bottom: 12 })

              // Input Ports
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
                }, (port: MidiPortInfo) => `in-${port.portIndex}`)
              }

              // Output Ports
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
                }, (port: MidiPortInfo) => `out-${port.portIndex}`)
              }
            }
            .width('100%')
            .padding(12)
            .backgroundColor(Color.White)
            .borderRadius(16)
          }

          // Virtual Piano Keyboard
          if (this.isDeviceOpen) {
            this.pianoKeyboard()
          }

          // MIDI Input Display
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

          // Log Panel
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
