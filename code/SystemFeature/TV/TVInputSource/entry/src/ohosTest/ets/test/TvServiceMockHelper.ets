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

import displaySetting from '@ohos.tvservice.displaySetting';
import { BusinessError } from '@kit.BasicServicesKit';
import * as TvSdkDtv from '../../../main/ets/sdk/DtvSdk';

export type DisplaySettingSourceEventStore = Map<string, (sourceBit: number[]) => void>;

export interface DisplaySettingSignalListenerBox {
  listener?: (sourceSignal: displaySetting.SourceSignal) => void;
}

export interface DisplaySettingMockOverrides {
  GetSupportSourceList?: () => Promise<number[]>;
  GetAvailSourceList?: () => Promise<number[]>;
  GetDeviceList?: () => Promise<displaySetting.CecDeviceInfo[]>;
  selectSource?: (sourceId: number, callback: (e: Error | undefined, ret: boolean) => void) => void;
  deselectSource?: (sourceId: number) => Promise<void>;
  getSignalStatus?: () => Promise<displaySetting.SignalStatus>;
  on?: (eventName: string, callback?: Object) => void;
  off?: (eventName: string, callback?: Object) => void;
  sourceEventStore?: DisplaySettingSourceEventStore;
  signalListenerBox?: DisplaySettingSignalListenerBox;
  offCalls?: string[];
}

class MockDisplaySettingError {
  public code: number = 0;
  public name: string = 'MockDisplaySettingError';
  public message: string = '';
}

export interface DtvCommMockShape {
  prepare?(): number;
  setSourceType?(antennaType: TvSdkDtv.FeAntennaType): number;
}

export interface DtvFrontendMockShape {
  setAntennaType?(antennaType: TvSdkDtv.FeAntennaType): number;
  setScanAttr?(scanCaType: TvSdkDtv.FeScanCaType, scanProgType: TvSdkDtv.FeScanProgType): number;
  autoScan?(): number;
  manualScan(freq: number, symbol: number): number;
}

export interface ProgramManagerMockShape {
  getLastChannelID?(): number | undefined;
  getChannelByID?(channelId: number): TvSdkDtv.PmChannel | undefined;
  getChannelNumByGroupType?(groupType: number): number;
  getChannelListByGroupType?(groupType: number, offset: number, count: number): TvSdkDtv.PmChannel[];
  getStatelliteTpList?(deliveryId: number, offset: number, count: number): TvSdkDtv.PmTransponder[];
  getStatelliteTpNum?(deliveryId: number): number;
  getDeliverSystemNum?(antennaType: TvSdkDtv.FeAntennaType): number;
  getDeliverSystemList?(antennaType: TvSdkDtv.FeAntennaType, offset: number, count: number): TvSdkDtv.DeliveryInfo[];
  delChannelByID?(channelId: number): number;
  moveChannel?(groupType: number, channelId: number, dstPos: number): number;
  saveTable?(tableType: TvSdkDtv.PmTableType, arg: number): number;
}

export interface DtvAvMockShape {
  getCurPlayProgramInfo?(): TvSdkDtv.PmChannel | undefined;
  stop?(): number;
  close?(): number;
}

/**
 * Creates a source-event store so multiple tests can inspect display callbacks consistently.
 *
 * @returns DisplaySettingSourceEventStore Mutable callback store keyed by event name.
 */
export function createDisplaySettingSourceEventStore(): DisplaySettingSourceEventStore {
  return new Map<string, (sourceBit: number[]) => void>();
}

/**
 * Creates a box that captures the latest signal listener registration.
 *
 * @returns DisplaySettingSignalListenerBox Mutable listener holder for signal tests.
 */
export function createDisplaySettingSignalListenerBox(): DisplaySettingSignalListenerBox {
  return {};
}

/**
 * Applies a full displaySetting mock surface with sensible defaults.
 *
 * @param restores Restore list owned by the current test case.
 * @param overrides Per-test behavior overrides for source, signal and event APIs.
 * @returns void.
 */
export function applyDisplaySettingMock(
  restores: Array<() => void>,
  overrides: DisplaySettingMockOverrides = {}
): void {
  const sourceEventStore = overrides.sourceEventStore;
  const signalListenerBox = overrides.signalListenerBox;
  const onPatch = createDisplaySettingEventPatch(overrides.on, sourceEventStore, signalListenerBox);
  const offPatch = createDisplaySettingOffPatch(overrides.off, overrides.offCalls, sourceEventStore, signalListenerBox);
  try {
    const originalGetSupportSourceList = displaySetting.GetSupportSourceList;
    displaySetting.GetSupportSourceList = overrides.GetSupportSourceList ?? (async (): Promise<number[]> => []);
    restores.push((): void => {
      displaySetting.GetSupportSourceList = originalGetSupportSourceList;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }

  try {
    const originalGetAvailSourceList = displaySetting.GetAvailSourceList;
    displaySetting.GetAvailSourceList = overrides.GetAvailSourceList ?? (async (): Promise<number[]> => []);
    restores.push((): void => {
      displaySetting.GetAvailSourceList = originalGetAvailSourceList;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }

  try {
    const originalGetDeviceList = displaySetting.GetDeviceList;
    displaySetting.GetDeviceList = overrides.GetDeviceList ?? (async (): Promise<displaySetting.CecDeviceInfo[]> => []);
    restores.push((): void => {
      displaySetting.GetDeviceList = originalGetDeviceList;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }

  try {
    const originalSelectSource = displaySetting.selectSource;
    displaySetting.selectSource = createSelectSourcePatch(overrides.selectSource);
    restores.push((): void => {
      displaySetting.selectSource = originalSelectSource;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }

  try {
    const originalDeselectSource = displaySetting.deselectSource;
    displaySetting.deselectSource = createDeselectSourcePatch(overrides.deselectSource);
    restores.push((): void => {
      displaySetting.deselectSource = originalDeselectSource;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }

  try {
    const originalGetSignalStatus = displaySetting.getSignalStatus;
    displaySetting.getSignalStatus = overrides.getSignalStatus ??
      (async (): Promise<displaySetting.SignalStatus> => displaySetting.SignalStatus.SIGNAL_SUPPORT);
    restores.push((): void => {
      displaySetting.getSignalStatus = originalGetSignalStatus;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }

  try {
    const originalOn = displaySetting.on;
    displaySetting.on = onPatch;
    restores.push((): void => {
      displaySetting.on = originalOn;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }

  try {
    const originalOff = displaySetting.off;
    displaySetting.off = offPatch;
    restores.push((): void => {
      displaySetting.off = originalOff;
    });
  } catch (_err) {
    restores.push((): void => {
    });
  }
}

/**
 * Builds one overloaded `selectSource` patch compatible with ArkTS declarations.
 *
 * @param override Optional callback-style override supplied by the current test.
 * @returns DisplaySettingSelectSourceFunction Overloaded select-source mock.
 */
function createSelectSourcePatch(
  override?: (sourceId: number, callback: (e: Error | undefined, ret: boolean) => void) => void
): (sourceId: displaySetting.SourceType, callback?: (error: BusinessError<void>, ret: boolean) => void) => Promise<boolean> {
  return (
    sourceId: displaySetting.SourceType,
    callback?: (error: BusinessError<void>, ret: boolean) => void
  ): Promise<boolean> => {
    if (callback !== undefined) {
      return new Promise<boolean>((resolve: (value: boolean) => void): void => {
        if (override !== undefined) {
          override(sourceId as number, (_error: Error | undefined, ret: boolean): void => {
            callback(new MockDisplaySettingError() as BusinessError<void>, ret);
            resolve(ret);
          });
          return;
        }
        callback(new MockDisplaySettingError() as BusinessError<void>, true);
        resolve(true);
      });
    }
    if (override !== undefined) {
      return new Promise<boolean>((resolve: (value: boolean) => void): void => {
        override(sourceId as number, (_error: Error | undefined, ret: boolean): void => {
          resolve(ret);
        });
      });
    }
    return Promise.resolve(true);
  };
}

/**
 * Builds one overloaded `deselectSource` patch compatible with ArkTS declarations.
 *
 * @param override Optional promise-style override supplied by the current test.
 * @returns DisplaySettingDeselectSourceFunction Overloaded deselect-source mock.
 */
function createDeselectSourcePatch(
  override?: (sourceId: number) => Promise<void>
): (sourceId: displaySetting.SourceType, callback?: (error: BusinessError<void>, ret: boolean) => void) => Promise<boolean> {
  return (
    sourceId: displaySetting.SourceType,
    callback?: (error: BusinessError<void>, ret: boolean) => void
  ): Promise<boolean> => {
    if (callback !== undefined) {
      return new Promise<boolean>((resolve: (value: boolean) => void): void => {
        if (override !== undefined) {
          void override(sourceId as number).then((): void => {
            callback(new MockDisplaySettingError() as BusinessError<void>, true);
            resolve(true);
          });
          return;
        }
        callback(new MockDisplaySettingError() as BusinessError<void>, true);
        resolve(true);
      });
    }
    if (override !== undefined) {
      return override(sourceId as number).then((): boolean => {
        return true;
      });
    }
    return Promise.resolve(true);
  };
}

/**
 * Builds one `displaySetting.on` patch without using type queries.
 *
 * @param override Optional per-test override.
 * @param sourceEventStore Mutable store used by source listener tests.
 * @param signalListenerBox Mutable holder used by signal listener tests.
 * @returns DisplaySettingEventFunction Event registration patch.
 */
function createDisplaySettingEventPatch(
  override: ((eventName: string, callback?: Object) => void) | undefined,
  sourceEventStore: DisplaySettingSourceEventStore | undefined,
  signalListenerBox: DisplaySettingSignalListenerBox | undefined
): (eventName: string, callback?: Object) => void {
  if (override !== undefined) {
    return override;
  }
  return ((eventName: string, callback?: Object): void => {
    if (eventName === 'signalStatusChange') {
      if (signalListenerBox) {
        signalListenerBox.listener = callback as (sourceSignal: displaySetting.SourceSignal) => void;
      }
      return;
    }
    if (sourceEventStore) {
      sourceEventStore.set(eventName, callback as (sourceBit: number[]) => void);
    }
  });
}

/**
 * Builds one `displaySetting.off` patch without using type queries.
 *
 * @param override Optional per-test override.
 * @param offCalls Optional event log sink.
 * @param sourceEventStore Mutable store used by source listener tests.
 * @param signalListenerBox Mutable holder used by signal listener tests.
 * @returns DisplaySettingEventFunction Event unregistration patch.
 */
function createDisplaySettingOffPatch(
  override: ((eventName: string, callback?: Object) => void) | undefined,
  offCalls: string[] | undefined,
  sourceEventStore: DisplaySettingSourceEventStore | undefined,
  signalListenerBox: DisplaySettingSignalListenerBox | undefined
): (eventName: string, callback?: Object) => void {
  if (override !== undefined) {
    return override;
  }
  return ((eventName: string, _callback?: Object): void => {
    offCalls?.push(eventName);
    if (eventName === 'signalStatusChange') {
      if (signalListenerBox) {
        signalListenerBox.listener = undefined;
      }
      return;
    }
    if (sourceEventStore) {
      sourceEventStore.delete(eventName);
    }
  });
}

/**
 * Creates a DTV communication mock from a partial business-facing contract.
 *
 * @param overrides Only the methods relevant to the current test branch.
 * @returns TvSdkDtv.DtvComm SDK-compatible communication mock.
 */
export function createDtvCommMock(overrides: DtvCommMockShape): TvSdkDtv.DtvComm {
  return overrides as TvSdkDtv.DtvComm;
}

/**
 * Creates a DTV frontend mock from a partial scan contract.
 *
 * @param overrides Only the scan-related methods needed by the current test.
 * @returns TvSdkDtv.DtvFrontend SDK-compatible frontend mock.
 */
export function createDtvFrontendMock(overrides: DtvFrontendMockShape): TvSdkDtv.DtvFrontend {
  return overrides as TvSdkDtv.DtvFrontend;
}

/**
 * Creates a program manager mock from the subset of methods under verification.
 *
 * @param overrides Only the program-manager methods needed by the current scenario.
 * @returns TvSdkDtv.ProgramManager SDK-compatible program manager mock.
 */
export function createProgramManagerMock(overrides: ProgramManagerMockShape): TvSdkDtv.ProgramManager {
  return overrides as TvSdkDtv.ProgramManager;
}

/**
 * Creates a DTV AV mock from the playback subset required by the current test.
 *
 * @param overrides Only the AV methods needed by the current playback scenario.
 * @returns TvSdkDtv.DtvAv SDK-compatible AV mock.
 */
export function createDtvAvMock(overrides: DtvAvMockShape): TvSdkDtv.DtvAv {
  return overrides as TvSdkDtv.DtvAv;
}
