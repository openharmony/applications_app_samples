/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * Supported DTV antenna types.
 */
export enum FeAntennaType {
  FE_ANTENNA_DTMB = 1
}

/**
 * Supported CA scan modes.
 */
export enum FeScanCaType {
  FE_SCAN_CA_ALL = 1
}

/**
 * Supported program scan modes.
 */
export enum FeScanProgType {
  FE_SCAN_PROG_ALL = 1
}

/**
 * Supported service modes.
 */
export enum ServiceModeType {
  PM_SERVICE_MODE_ALL = 1,
  PM_SERVICE_MODE_DATA = 2
}

/**
 * AV status query commands.
 */
export enum AvCmdType {
  AV_GET_CUR_PROGINFO = 0,
  AV_GET_PLAY_STATUS = 1
}

/**
 * AV play status values.
 */
export enum AvPlayStatus {
  AV_PLAY_STATUS_PLAYING = 0,
  AV_PLAY_STATUS_STOPPED = 1
}

/**
 * Supported program table types.
 */
export enum PmTableType {
  PM_TABLE_TYPE_ALL = 1
}

/**
 * Connection parameters for a tuner frequency.
 */
export interface FeConnectParam {
  freq: number;
}

/**
 * Minimal program channel structure used by the manager.
 */
export interface PmChannel {
  channelID: number;
  serviceType: number;
}

/**
 * Delivery system info used during frequency cleanup.
 */
export interface DeliveryInfo {
  deliverID: number;
}

/**
 * Transponder structure used by the manager.
 */
export interface PmTransponder {
  tpID: number;
  connParam: FeConnectParam;
}

/**
 * Channel filter structure required by program manager grouping.
 */
export interface PmChannelFilter {
  baseGroupType: number;
  tvRadioFilter: ServiceModeType;
  isSkipHideChannel: boolean;
  caFilter: number;
  favTag: number;
  signalType: FeAntennaType;
  deliverySystemRowID: number;
  firstChar: string;
  firstNumber: string;
  otherFirstChar: string;
  letters: string;
  tunerID: number;
  tpRowID: number;
  networkID: number;
  ciType: number;
  ciOpRowId: number;
}

/**
 * Provides common DTV stack operations.
 */
export class DtvComm {
  /**
   * Prepares the DTV stack.
   *
   * @returns Preparation result code.
   */
  prepare(): number {
    return 0;
  }

  /**
   * Sets the active antenna source.
   *
   * @param _antennaType Target antenna type.
   * @returns Operation result code.
   */
  setSourceType(_antennaType: FeAntennaType): number {
    return 0;
  }
}

/**
 * Provides DTV configuration operations.
 */
export class DtvCfg {
  /**
   * Sets a string configuration value.
   *
   * @param _key Configuration key.
   * @param _value Configuration value.
   * @returns Operation result code.
   */
  setStringValue(_key: string, _value: string): number {
    return 0;
  }

  /**
   * Sets an integer configuration value.
   *
   * @param _key Configuration key.
   * @param _value Configuration value.
   * @returns Operation result code.
   */
  setIntValue(_key: string, _value: number): number {
    return 0;
  }
}

/**
 * Provides frontend scan operations.
 */
export class DtvFrontend {
  /**
   * Starts automatic scanning.
   *
   * @returns Operation result code.
   */
  autoScan(): number {
    return 0;
  }

  /**
   * Starts manual scanning.
   *
   * @returns Operation result code.
   */
  manualScan(): number {
    return 0;
  }

  /**
   * Aborts the current scan.
   *
   * @returns Operation result code.
   */
  abortScan(): number {
    return 0;
  }

  /**
   * Sets the antenna type.
   *
   * @param _antennaType Target antenna type.
   * @returns Operation result code.
   */
  setAntennaType(_antennaType: FeAntennaType): number {
    return 0;
  }

  /**
   * Sets scan attributes.
   *
   * @param _scanCaType CA scan mode.
   * @param _scanProgType Program scan mode.
   * @returns Operation result code.
   */
  setScanAttr(_scanCaType: FeScanCaType, _scanProgType: FeScanProgType): number {
    return 0;
  }

  /**
   * Sets frontend connection parameters.
   *
   * @param _freq Target connection parameter.
   * @returns Operation result code.
   */
  SetConnectParam(_freq: FeConnectParam): number {
    return 0;
  }
}

/**
 * Provides AV playback operations.
 */
export class DtvAv {
  /**
   * Opens the AV pipeline.
   *
   * @returns Operation result code.
   */
  open(): number {
    return 0;
  }

  /**
   * Closes the AV pipeline.
   *
   * @returns Operation result code.
   */
  close(): number {
    return 0;
  }

  /**
   * Starts AV playback.
   *
   * @param _channelId Channel identifier.
   * @param _isShow Whether to show audio/video.
   * @returns Operation result code.
   */
  start(_channelId: number, _isShow: boolean): number {
    return 0;
  }

  /**
   * Reads the requested AV status value.
   *
   * @param cmd Status command.
   * @returns Current channel id or play status value.
   */
  getAvStatus(cmd: AvCmdType): number | AvPlayStatus {
    if (cmd === AvCmdType.AV_GET_PLAY_STATUS) {
      return AvPlayStatus.AV_PLAY_STATUS_STOPPED;
    }
    return 0;
  }
}

/**
 * Provides program data access helpers.
 */
export class ProgramManager {
  /**
   * Gets the last played channel id.
   *
   * @returns Channel id or undefined.
   */
  getLastChannelID(): number | undefined {
    return undefined;
  }

  /**
   * Gets a channel by id.
   *
   * @param channelId Channel identifier.
   * @returns Channel info when available.
   */
  getChannelByID(channelId: number): PmChannel | undefined {
    return {
      channelID: channelId,
      serviceType: 0
    };
  }

  /**
   * Deletes a channel by id.
   *
   * @param _channelId Channel identifier.
   * @returns Operation result code.
   */
  delChannelByID(_channelId: number): number {
    return 0;
  }

  /**
   * Saves the specified program table.
   *
   * @param _tableType Table type.
   * @param _arg Extra argument.
   * @returns Operation result code.
   */
  saveTable(_tableType: PmTableType, _arg: number): number {
    return 0;
  }

  /**
   * Sets the current service mode.
   *
   * @param _serviceMode Service mode.
   * @returns Operation result code.
   */
  setServiceMode(_serviceMode: ServiceModeType): number {
    return 0;
  }

  /**
   * Gets the channel count of a group.
   *
   * @param _groupType Group identifier.
   * @returns Channel count.
   */
  getChannelNum(_groupType: number): number {
    return 0;
  }

  /**
   * Gets a page of channels.
   *
   * @param _groupType Group identifier.
   * @param _offset Start offset.
   * @param _count Requested count.
   * @returns Channel list.
   */
  getChannelList(_groupType: number, _offset: number, _count: number): PmChannel[] {
    return [];
  }

  /**
   * Gets a grouped channel identifier from a filter.
   *
   * @param _filter Channel filter.
   * @returns Group id.
   */
  getChannelGroup(_filter: PmChannelFilter): number {
    return 0;
  }

  /**
   * Deletes channels by antenna type.
   *
   * @param _signalType Antenna type.
   * @returns Operation result code.
   */
  delChannelBySignalType(_signalType: FeAntennaType): number {
    return 0;
  }

  /**
   * Moves a channel within a group.
   *
   * @param _groupType Group identifier.
   * @param _channelId Channel identifier.
   * @param _dstPos Destination position.
   * @returns Operation result code.
   */
  moveChannel(_groupType: number, _channelId: number, _dstPos: number): number {
    return 0;
  }

  /**
   * Gets stored frequency count.
   *
   * @param _signalType Antenna type.
   * @returns Frequency count.
   */
  getPressFreqNum(_signalType: FeAntennaType): number {
    return 0;
  }

  /**
   * Gets stored frequency list.
   *
   * @param _signalType Antenna type.
   * @param _offset Start offset.
   * @param _count Requested count.
   * @returns Frequency list.
   */
  getPressFreList(_signalType: FeAntennaType, _offset: number, _count: number): FeConnectParam[] {
    return [];
  }

  /**
   * Gets delivery system count.
   *
   * @param _signalType Antenna type.
   * @returns Delivery system count.
   */
  getDeliverSystemNum(_signalType: FeAntennaType): number {
    return 0;
  }

  /**
   * Gets delivery system list.
   *
   * @param _signalType Antenna type.
   * @param _offset Start offset.
   * @param _count Requested count.
   * @returns Delivery system list.
   */
  getDeliverSystemList(_signalType: FeAntennaType, _offset: number, _count: number): DeliveryInfo[] {
    return [];
  }

  /**
   * Gets transponder count under a delivery system.
   *
   * @param _deliveryId Delivery system identifier.
   * @returns Transponder count.
   */
  getStatelliteTpNum(_deliveryId: number): number {
    return 0;
  }

  /**
   * Gets transponder list under a delivery system.
   *
   * @param _deliveryId Delivery system identifier.
   * @param _offset Start offset.
   * @param _count Requested count.
   * @returns Transponder list.
   */
  getStatelliteTpList(_deliveryId: number, _offset: number, _count: number): PmTransponder[] {
    return [];
  }
}

/**
 * Placeholder EPG implementation.
 */
export class DtvEpg {
}

/**
 * Creates a DTV common object.
 *
 * @returns DTV common instance.
 */
export function createDtvComm(): DtvComm {
  return new DtvComm();
}

/**
 * Creates a DTV config object.
 *
 * @returns DTV config instance.
 */
export function createDtvCfg(): DtvCfg {
  return new DtvCfg();
}

/**
 * Creates a DTV frontend object.
 *
 * @returns DTV frontend instance.
 */
export function createDtvFrontend(): DtvFrontend {
  return new DtvFrontend();
}

/**
 * Creates a DTV AV object.
 *
 * @returns DTV AV instance.
 */
export function createDtvAv(): DtvAv {
  return new DtvAv();
}

/**
 * Creates a DTV program manager object.
 *
 * @returns Program manager instance.
 */
export function createDtvProgramManager(): ProgramManager {
  return new ProgramManager();
}

/**
 * Creates a DTV EPG object.
 *
 * @returns DTV EPG instance.
 */
export function createDtvEpg(): DtvEpg {
  return new DtvEpg();
}
