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

// Device types
export const enum MidiDeviceType {
  USB = 0,
  BLE = 1
}

// Protocol types
export const enum MidiProtocol {
  MIDI_1_0 = 1,
  MIDI_2_0 = 2
}

// Port direction
export const enum MidiPortDirection {
  INPUT = 0,
  OUTPUT = 1
}

// Device change action
export const enum MidiDeviceChangeAction {
  CONNECTED = 0,
  DISCONNECTED = 1
}

// Status codes
export const enum MidiStatusCode {
  OK = 0,
  INVALID_ARGUMENT = 35500001,
  IPC_FAILURE = 35500002,
  INVALID_CLIENT = 35500003,
  INVALID_DEVICE_HANDLE = 35500004,
  INVALID_PORT = 35500005,
  WOULD_BLOCK = 35500006,
  TIMEOUT = 35500007,
  TOO_MANY_OPEN_DEVICES = 35500008,
  TOO_MANY_OPEN_PORTS = 35500009,
  DEVICE_ALREADY_OPEN = 35500010,
  PORT_ALREADY_OPEN = 35500011,
  TOO_MANY_CLIENTS = 35500012,
  PERMISSION_DENIED = 35500013,
  SERVICE_DIED = 35500014,
  SYSTEM_ERROR = 35500100
}

// Device information interface
export interface MidiDeviceInfo {
  deviceId: number;
  deviceType: MidiDeviceType;
  nativeProtocol: MidiProtocol;
  deviceName: string;
  vendorId: bigint;
  productId: bigint;
  deviceAddress: string;
}

// Port information interface
export interface MidiPortInfo {
  portIndex: number;
  deviceId: number;
  direction: MidiPortDirection;
  name: string;
}

// MIDI event interface
export interface MidiEvent {
  timestamp: bigint;
  length: number;
  data: number[];
}

// Device change callback
export type DeviceChangeCallback = (action: MidiDeviceChangeAction, deviceInfo: MidiDeviceInfo) => void;

// MIDI received callback - called when MIDI data is received on an input port
export type MidiReceivedCallback = (events: MidiEvent[]) => void;

/**
 * Create MIDI client
 * @param callback - Optional device change callback
 * @returns Status code
 */
export const createMIDIClient: (callback?: DeviceChangeCallback) => MidiStatusCode;

/**
 * Destroy MIDI client
 */
export const destroyMIDIClient: () => void;

/**
 * Get connected MIDI device count
 * @returns Device count, -1 on error
 */
export const getDeviceCount: () => number;

/**
 * Get connected MIDI device list
 * @returns Array of device information
 */
export const getDeviceInfos: () => MidiDeviceInfo[];

/**
 * Get port count for a device
 * @param deviceId - Device ID
 * @returns Port count, -1 on error
 */
export const getPortCount: (deviceId: number) => number;

/**
 * Get port information for a device
 * @param deviceId - Device ID
 * @returns Array of port information
 */
export const getPortInfos: (deviceId: number) => MidiPortInfo[];

/**
 * Open a MIDI device
 * @param deviceId - Device ID
 * @returns Status code
 */
export const openDevice: (deviceId: number) => MidiStatusCode;

/**
 * Close a MIDI device
 * @param deviceId - Device ID
 * @returns Status code
 */
export const closeDevice: (deviceId: number) => MidiStatusCode;

/**
 * Open input port for receiving MIDI data
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @param protocol - MIDI protocol (default: MIDI 1.0)
 * @param callback - Callback function to receive MIDI events
 * @returns Status code
 */
export const openInputPort: (deviceId: number, portIndex: number, protocol?: MidiProtocol, callback?: MidiReceivedCallback) => MidiStatusCode;

/**
 * Close input port
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @returns Status code
 */
export const closeInputPort: (deviceId: number, portIndex: number) => MidiStatusCode;

/**
 * Open output port for sending MIDI data
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @param protocol - MIDI protocol (default: MIDI 1.0)
 * @returns Status code
 */
export const openOutputPort: (deviceId: number, portIndex: number, protocol?: MidiProtocol) => MidiStatusCode;

/**
 * Close output port
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @returns Status code
 */
export const closeOutputPort: (deviceId: number, portIndex: number) => MidiStatusCode;

/**
 * Send MIDI events
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @param events - Array of MIDI events
 * @returns Object with status and eventsWritten count
 */
export const sendMIDI: (deviceId: number, portIndex: number, events: MidiEvent[]) => { status: MidiStatusCode, eventsWritten: number };

/**
 * Send Note On message (helper)
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @param channel - MIDI channel (0-15)
 * @param note - Note number (0-127)
 * @param velocity - Velocity (0-127)
 * @returns Status code
 */
export const sendNoteOn: (deviceId: number, portIndex: number, channel: number, note: number, velocity: number) => MidiStatusCode;

/**
 * Send Note Off message (helper)
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @param channel - MIDI channel (0-15)
 * @param note - Note number (0-127)
 * @param velocity - Velocity (0-127)
 * @returns Status code
 */
export const sendNoteOff: (deviceId: number, portIndex: number, channel: number, note: number, velocity: number) => MidiStatusCode;

/**
 * Flush output port buffer
 * @param deviceId - Device ID
 * @param portIndex - Port index
 * @returns Status code
 */
export const flushOutputPort: (deviceId: number, portIndex: number) => MidiStatusCode;

// BLE device open callback - called when BLE device open completes
export type BLEDeviceOpenedCallback = (opened: boolean, deviceInfo: MidiDeviceInfo) => void;

/**
 * Open BLE MIDI device asynchronously
 * Requires ohos.permission.ACCESS_BLUETOOTH permission
 * @param deviceAddress - BLE device MAC address (e.g., "AA:BB:CC:DD:EE:FF")
 * @param callback - Callback invoked when open completes (success or failure)
 * @returns Status code (OH_MIDI_STATUS_OK means request was dispatched, actual result via callback)
 */
export const openBLEDevice: (deviceAddress: string, callback?: BLEDeviceOpenedCallback) => MidiStatusCode;
