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

import { KeyEvent } from '@kit.InputKit';
import { SourcePlugStateEntity } from '../../../main/ets/entity/SourcePlugStateEntity';
import { TimingInfoEntity } from '../../../main/ets/entity/TimingInfoEntity';
import {
  AvCmdType,
  AvPlayStatus,
  DeliveryInfo,
  DtvAv,
  DtvCfg,
  DtvComm,
  DtvFrontend,
  FeAntennaType,
  FeConnectParam,
  FeScanCaType,
  FeScanProgType,
  PmChannel,
  PmChannelFilter,
  PmTableType,
  PmTransponder,
  ProgramManager,
  ServiceModeType
} from '../../../main/ets/sdk/DtvSdk';

export interface CallRecorder {
  entries: string[];
}

export interface AvStartCall {
  channelId: number;
  isShow: boolean;
}

export interface ChannelMoveCall {
  groupType: number;
  channelId: number;
  dstPos: number;
}

export interface SaveTableCall {
  tableType: PmTableType;
  arg: number;
}

export interface DtvManagerPatchTarget {
  getDtvComm?: () => DtvComm | null;
  getDtvCfg?: () => DtvCfg | null;
  getDtvFrontend?: () => DtvFrontend | null;
  getProgramManager?: () => ProgramManager | null;
  getDtvAv?: () => DtvAv | null;
  getChannelList?: () => PmChannel[] | null;
  dtvAvOpen?: () => number;
  dtvAvStart?: (channelId: number, isShow: boolean) => number;
  getCurrentChannelId?: () => number;
  dtvAvChannelChange?: (channelId: number, isShow: boolean) => void;
  saveChannel?: () => void;
  getChannelGroup?: (serviceMode: ServiceModeType) => number;
  getCurrentOpenChannel?: () => PmChannel | undefined;
  setProgramManagerProviderForTest?: (provider?: () => ProgramManager | null) => void;
  setChannelGroupResolverForTest?: (resolver?: (serviceMode: ServiceModeType) => number) => void;
  setChannelListBySplitResolverForTest?: (resolver?: (groupType: number, total: number) => PmChannel[]) => void;
}

export interface HilogPatchTarget {
  debug?: (domain: number, tag: string, msg: string) => void;
  info?: (domain: number, tag: string, msg: string) => void;
  warn?: (domain: number, tag: string, msg: string) => void;
  error?: (domain: number, tag: string, msg: string) => void;
}

export interface DisplayPatchTarget {
  getDefaultDisplay?: () => Promise<Object>;
  getDefaultDisplaySync?: () => Object;
}

export interface MultiPageListenerManagerPatchTarget {
  getInStance?: () => Object;
}

export interface SettingsPatchTarget {
  setValueSync?: (context: Object, key: string, value: string) => boolean;
  getValueSync?: (context: Object, key: string, defaultValue: string) => string;
}

export interface CommonEventManagerPatchTarget {
  publish?: (eventName: string, publishData: Object, callback: (err?: Error) => void) => void;
}

export interface DisplaySettingPatchTarget {
  GetSupportSourceList?: () => Promise<number[]>;
  GetAvailSourceList?: () => Promise<number[]>;
  GetDeviceList?: () => Promise<Object[]>;
  selectSource?: (sourceId: number, callback: (e: Error | undefined, ret: boolean) => void) => void;
  deselectSource?: (sourceId: number) => Promise<void>;
  getSignalStatus?: () => Promise<number>;
  on?: (eventName: string, callback?: Object) => void;
  off?: (eventName: string, callback?: Object) => void;
}

export interface GlobalPatchTarget {
  getContext?: () => Object;
  $r?: (resourceName: string) => Object;
}

export interface ImagePatchTarget {
  createImageSource?: (buffer: ArrayBuffer) => Object;
}

export interface WindowPatchTarget {
  getLastWindow?: (context: Object, callback: (err: Object | undefined, win: Object) => void) => void;
}

export interface PointerPatchTarget {
  getPointerStyleSync?: (windowId: number) => Object;
  setPointerStyle?: (windowId: number, style: Object) => void;
  setCustomCursorSync?: (windowId: number, pixelMap: Object, x: number, y: number) => void;
}

export interface PointerUtilPatchTarget {
  changePointStyle?: (isClick: boolean) => void;
}

export interface InputEventClientPatchTarget {
  injectEvent?: (payload: Object) => void;
}

export interface MockDtvCommOptions {
  prepare?: () => number;
  setSourceType?: (antennaType: FeAntennaType) => number;
}

export interface MockDtvCfgOptions {
  setStringValue?: (key: string, value: string) => number;
  setIntValue?: (key: string, value: number) => number;
}

export interface MockDtvFrontendOptions {
  autoScan?: () => number;
  manualScan?: () => number;
  abortScan?: () => number;
  setAntennaType?: (antennaType: FeAntennaType) => number;
  setScanAttr?: (scanCaType: FeScanCaType, scanProgType: FeScanProgType) => number;
  setConnectParam?: (freq: FeConnectParam) => number;
}

export interface MockDtvAvOptions {
  open?: () => number;
  close?: () => number;
  start?: (channelId: number, isShow: boolean) => number;
  getAvStatus?: (cmd: AvCmdType) => number | AvPlayStatus;
}

export interface MockProgramManagerOptions {
  getLastChannelID?: () => number | undefined;
  getChannelByID?: (channelId: number) => PmChannel | undefined;
  delChannelByID?: (channelId: number) => number;
  saveTable?: (tableType: PmTableType, arg: number) => number;
  setServiceMode?: (serviceMode: ServiceModeType) => number;
  getChannelGroup?: (filter: PmChannelFilter) => number;
  getChannelNum?: (groupType: number) => number;
  getChannelList?: (groupType: number, offset: number, count: number) => PmChannel[];
  delChannelBySignalType?: (signalType: FeAntennaType) => number;
  moveChannel?: (groupType: number, channelId: number, dstPos: number) => number;
  getPressFreqNum?: (signalType: FeAntennaType) => number;
  getPressFreList?: (signalType: FeAntennaType, offset: number, count: number) => FeConnectParam[];
  getDeliverSystemNum?: (signalType: FeAntennaType) => number;
  getDeliverSystemList?: (signalType: FeAntennaType, offset: number, count: number) => DeliveryInfo[];
  getStatelliteTpNum?: (deliveryId: number) => number;
  getStatelliteTpList?: (deliveryId: number, offset: number, count: number) => PmTransponder[];
}

export interface MissionWantFixture {
  abilityName: string;
  bundleName: string;
}

export interface MissionInfoFixture {
  missionId: number;
  want: MissionWantFixture;
}

/**
 * Replaces a mutable member on a module or class for the lifetime of a test.
 *
 * @param target Module object or constructor that owns the member.
 * @param key Member name to replace.
 * @param replacement Replacement implementation.
 * @returns A restore function that rolls the mutation back.
 */
export function patchMember(target: Object, key: string, replacement: Object): () => void {
  if (target === undefined || target === null) {
    return (): void => {
    };
  }
  const dtvManagerRestore = patchDtvManagerMember(target, key, replacement);
  if (dtvManagerRestore !== undefined) {
    return dtvManagerRestore;
  }
  const hilogRestore = patchHilogMember(target, key, replacement);
  if (hilogRestore !== undefined) {
    return hilogRestore;
  }
  const displayRestore = patchDisplayMember(target, key, replacement);
  if (displayRestore !== undefined) {
    return displayRestore;
  }
  const listenerManagerRestore = patchListenerManagerMember(target, key, replacement);
  if (listenerManagerRestore !== undefined) {
    return listenerManagerRestore;
  }
  const settingsRestore = patchSettingsMember(target, key, replacement);
  if (settingsRestore !== undefined) {
    return settingsRestore;
  }
  const commonEventRestore = patchCommonEventMember(target, key, replacement);
  if (commonEventRestore !== undefined) {
    return commonEventRestore;
  }
  const displaySettingRestore = patchDisplaySettingMember(target, key, replacement);
  if (displaySettingRestore !== undefined) {
    return displaySettingRestore;
  }
  const globalRestore = patchGlobalMember(target, key, replacement);
  if (globalRestore !== undefined) {
    return globalRestore;
  }
  const imageRestore = patchImageMember(target, key, replacement);
  if (imageRestore !== undefined) {
    return imageRestore;
  }
  const windowRestore = patchWindowMember(target, key, replacement);
  if (windowRestore !== undefined) {
    return windowRestore;
  }
  const pointerRestore = patchPointerMember(target, key, replacement);
  if (pointerRestore !== undefined) {
    return pointerRestore;
  }
  const pointerUtilRestore = patchPointerUtilMember(target, key, replacement);
  if (pointerUtilRestore !== undefined) {
    return pointerUtilRestore;
  }
  const inputEventRestore = patchInputEventClientMember(target, key, replacement);
  if (inputEventRestore !== undefined) {
    return inputEventRestore;
  }
  const genericRestore = patchGenericMember(target, key, replacement);
  if (genericRestore !== undefined) {
    return genericRestore;
  }
  return (): void => {
  };
}

/**
 * Applies a generic mutable member patch for helpers not covered by typed branches.
 *
 * This fallback is intentionally last so strongly typed patchers keep precedence.
 * It enables focused tests to patch plain static/module methods such as
 * `SourceManager.getSourceList` and ad-hoc instance methods.
 *
 * @param target Candidate object that may own the target member.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when patching is possible.
 */
function patchGenericMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  if (target === undefined || target === null) {
    return undefined;
  }
  const mutableTarget = target as Record<string, Object>;
  try {
    const original = mutableTarget[key];
    mutableTarget[key] = replacement;
    return (): void => {
      mutableTarget[key] = original;
    };
  } catch (_err) {
    return undefined;
  }
}

/**
 * Replaces one DTV manager member using explicit property access.
 *
 * @param target Candidate DTV manager holder.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchDtvManagerMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const dtvManagerTarget = target as DtvManagerPatchTarget;
  if (key === 'getDtvComm') {
    const original = dtvManagerTarget.getDtvComm;
    dtvManagerTarget.getDtvComm = replacement as () => DtvComm | null;
    return (): void => {
      dtvManagerTarget.getDtvComm = original;
    };
  }
  if (key === 'getDtvCfg') {
    const original = dtvManagerTarget.getDtvCfg;
    dtvManagerTarget.getDtvCfg = replacement as () => DtvCfg | null;
    return (): void => {
      dtvManagerTarget.getDtvCfg = original;
    };
  }
  if (key === 'getDtvFrontend') {
    const original = dtvManagerTarget.getDtvFrontend;
    dtvManagerTarget.getDtvFrontend = replacement as () => DtvFrontend | null;
    return (): void => {
      dtvManagerTarget.getDtvFrontend = original;
    };
  }
  if (key === 'getProgramManager') {
    try {
      const original = dtvManagerTarget.getProgramManager;
      dtvManagerTarget.getProgramManager = replacement as () => ProgramManager | null;
      return (): void => {
        dtvManagerTarget.getProgramManager = original;
      };
    } catch (_err) {
      if (dtvManagerTarget.setProgramManagerProviderForTest !== undefined) {
        dtvManagerTarget.setProgramManagerProviderForTest(replacement as () => ProgramManager | null);
        return (): void => {
          dtvManagerTarget.setProgramManagerProviderForTest?.(undefined);
        };
      }
      return undefined;
    }
  }
  if (key === 'getDtvAv') {
    const original = dtvManagerTarget.getDtvAv;
    dtvManagerTarget.getDtvAv = replacement as () => DtvAv | null;
    return (): void => {
      dtvManagerTarget.getDtvAv = original;
    };
  }
  if (key === 'getChannelList') {
    const original = dtvManagerTarget.getChannelList;
    dtvManagerTarget.getChannelList = replacement as () => PmChannel[] | null;
    return (): void => {
      dtvManagerTarget.getChannelList = original;
    };
  }
  if (key === 'dtvAvOpen') {
    const original = dtvManagerTarget.dtvAvOpen;
    dtvManagerTarget.dtvAvOpen = replacement as () => number;
    return (): void => {
      dtvManagerTarget.dtvAvOpen = original;
    };
  }
  if (key === 'dtvAvStart') {
    const original = dtvManagerTarget.dtvAvStart;
    dtvManagerTarget.dtvAvStart = replacement as (channelId: number, isShow: boolean) => number;
    return (): void => {
      dtvManagerTarget.dtvAvStart = original;
    };
  }
  if (key === 'getCurrentChannelId') {
    const original = dtvManagerTarget.getCurrentChannelId;
    dtvManagerTarget.getCurrentChannelId = replacement as () => number;
    return (): void => {
      dtvManagerTarget.getCurrentChannelId = original;
    };
  }
  if (key === 'dtvAvChannelChange') {
    const original = dtvManagerTarget.dtvAvChannelChange;
    dtvManagerTarget.dtvAvChannelChange = replacement as (channelId: number, isShow: boolean) => void;
    return (): void => {
      dtvManagerTarget.dtvAvChannelChange = original;
    };
  }
  if (key === 'saveChannel') {
    const original = dtvManagerTarget.saveChannel;
    dtvManagerTarget.saveChannel = replacement as () => void;
    return (): void => {
      dtvManagerTarget.saveChannel = original;
    };
  }
  if (key === 'getChannelGroup') {
    try {
      const original = dtvManagerTarget.getChannelGroup;
      dtvManagerTarget.getChannelGroup = replacement as (serviceMode: ServiceModeType) => number;
      return (): void => {
        dtvManagerTarget.getChannelGroup = original;
      };
    } catch (_err) {
      if (dtvManagerTarget.setChannelGroupResolverForTest !== undefined) {
        dtvManagerTarget.setChannelGroupResolverForTest(replacement as (serviceMode: ServiceModeType) => number);
        return (): void => {
          dtvManagerTarget.setChannelGroupResolverForTest?.(undefined);
        };
      }
      return undefined;
    }
  }
  if (key === 'getChannelListBySplit') {
    if (dtvManagerTarget.setChannelListBySplitResolverForTest !== undefined) {
      dtvManagerTarget.setChannelListBySplitResolverForTest(replacement as (groupType: number, total: number) => PmChannel[]);
      return (): void => {
        dtvManagerTarget.setChannelListBySplitResolverForTest?.(undefined);
      };
    }
    return undefined;
  }
  if (key === 'getCurrentOpenChannel') {
    const original = dtvManagerTarget.getCurrentOpenChannel;
    dtvManagerTarget.getCurrentOpenChannel = replacement as () => PmChannel | undefined;
    return (): void => {
      dtvManagerTarget.getCurrentOpenChannel = original;
    };
  }
  return undefined;
}

/**
 * Replaces one logging API member using explicit property access.
 *
 * @param target Candidate log module object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchHilogMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const hilogTarget = target as HilogPatchTarget;
  if (key === 'debug') {
    const original = hilogTarget.debug;
    hilogTarget.debug = replacement as (domain: number, tag: string, msg: string) => void;
    return (): void => {
      hilogTarget.debug = original;
    };
  }
  if (key === 'info') {
    const original = hilogTarget.info;
    hilogTarget.info = replacement as (domain: number, tag: string, msg: string) => void;
    return (): void => {
      hilogTarget.info = original;
    };
  }
  if (key === 'warn') {
    const original = hilogTarget.warn;
    hilogTarget.warn = replacement as (domain: number, tag: string, msg: string) => void;
    return (): void => {
      hilogTarget.warn = original;
    };
  }
  if (key === 'error') {
    const original = hilogTarget.error;
    hilogTarget.error = replacement as (domain: number, tag: string, msg: string) => void;
    return (): void => {
      hilogTarget.error = original;
    };
  }
  return undefined;
}

/**
 * Replaces one display API member using explicit property access.
 *
 * @param target Candidate display module object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchDisplayMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const displayTarget = target as DisplayPatchTarget;
  if (key === 'getDefaultDisplay') {
    const original = displayTarget.getDefaultDisplay;
    displayTarget.getDefaultDisplay = replacement as () => Promise<Object>;
    return (): void => {
      displayTarget.getDefaultDisplay = original;
    };
  }
  if (key === 'getDefaultDisplaySync') {
    const original = displayTarget.getDefaultDisplaySync;
    displayTarget.getDefaultDisplaySync = replacement as () => Object;
    return (): void => {
      displayTarget.getDefaultDisplaySync = original;
    };
  }
  return undefined;
}

/**
 * Replaces one singleton accessor on the multi-page listener manager.
 *
 * @param target Candidate listener manager object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchListenerManagerMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const managerTarget = target as MultiPageListenerManagerPatchTarget;
  if (key === 'getInStance') {
    const original = managerTarget.getInStance;
    managerTarget.getInStance = replacement as () => Object;
    return (): void => {
      managerTarget.getInStance = original;
    };
  }
  return undefined;
}

/**
 * Replaces one settings API member using explicit property access.
 *
 * @param target Candidate settings module object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchSettingsMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const settingsTarget = target as SettingsPatchTarget;
  if (key === 'setValueSync') {
    try {
      const original = settingsTarget.setValueSync;
      settingsTarget.setValueSync = replacement as (context: Object, key: string, value: string) => boolean;
      return (): void => {
        settingsTarget.setValueSync = original;
      };
    } catch (_err) {
      return undefined;
    }
  }
  if (key === 'getValueSync') {
    try {
      const original = settingsTarget.getValueSync;
      settingsTarget.getValueSync = replacement as (context: Object, key: string, defaultValue: string) => string;
      return (): void => {
        settingsTarget.getValueSync = original;
      };
    } catch (_err) {
      return undefined;
    }
  }
  return undefined;
}

/**
 * Replaces one common-event API member using explicit property access.
 *
 * @param target Candidate common event manager object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchCommonEventMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const commonEventTarget = target as CommonEventManagerPatchTarget;
  if (key === 'publish') {
    try {
      const original = commonEventTarget.publish;
      commonEventTarget.publish = replacement as (eventName: string, publishData: Object, callback: (err?: Error) => void) => void;
      return (): void => {
        commonEventTarget.publish = original;
      };
    } catch (_err) {
      return undefined;
    }
  }
  return undefined;
}

/**
 * Replaces one display-setting API member using explicit property access.
 *
 * @param target Candidate display-setting module object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchDisplaySettingMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const displaySettingTarget = target as DisplaySettingPatchTarget;
  if (key === 'GetSupportSourceList') {
    try {
      const original = displaySettingTarget.GetSupportSourceList;
      displaySettingTarget.GetSupportSourceList = replacement as () => Promise<number[]>;
      return (): void => {
        displaySettingTarget.GetSupportSourceList = original;
      };
    } catch (_err) {
      return undefined;
    }
  }
  if (key === 'GetAvailSourceList') {
    try {
      const original = displaySettingTarget.GetAvailSourceList;
      displaySettingTarget.GetAvailSourceList = replacement as () => Promise<number[]>;
      return (): void => {
        displaySettingTarget.GetAvailSourceList = original;
      };
    } catch (_err) {
      return undefined;
    }
  }
  if (key === 'GetDeviceList') {
    try {
      const original = displaySettingTarget.GetDeviceList;
      displaySettingTarget.GetDeviceList = replacement as () => Promise<Object[]>;
      return (): void => {
        displaySettingTarget.GetDeviceList = original;
      };
    } catch (_err) {
      return undefined;
    }
  }
  if (key === 'selectSource') {
    const original = displaySettingTarget.selectSource;
    displaySettingTarget.selectSource = replacement as (sourceId: number, callback: (e: Error | undefined, ret: boolean) => void) => void;
    return (): void => {
      displaySettingTarget.selectSource = original;
    };
  }
  if (key === 'deselectSource') {
    const original = displaySettingTarget.deselectSource;
    displaySettingTarget.deselectSource = replacement as (sourceId: number) => Promise<void>;
    return (): void => {
      displaySettingTarget.deselectSource = original;
    };
  }
  if (key === 'getSignalStatus') {
    const original = displaySettingTarget.getSignalStatus;
    displaySettingTarget.getSignalStatus = replacement as () => Promise<number>;
    return (): void => {
      displaySettingTarget.getSignalStatus = original;
    };
  }
  if (key === 'on') {
    const original = displaySettingTarget.on;
    displaySettingTarget.on = replacement as (eventName: string, callback?: Object) => void;
    return (): void => {
      displaySettingTarget.on = original;
    };
  }
  if (key === 'off') {
    const original = displaySettingTarget.off;
    displaySettingTarget.off = replacement as (eventName: string, callback?: Object) => void;
    return (): void => {
      displaySettingTarget.off = original;
    };
  }
  return undefined;
}

/**
 * Replaces one global helper member used by UI utility tests.
 *
 * @param target Candidate global object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchGlobalMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const globalTarget = target as GlobalPatchTarget;
  if (key === 'getContext') {
    const original = globalTarget.getContext;
    globalTarget.getContext = replacement as () => Object;
    return (): void => {
      globalTarget.getContext = original;
    };
  }
  if (key === '$r') {
    const original = globalTarget.$r;
    globalTarget.$r = replacement as (resourceName: string) => Object;
    return (): void => {
      globalTarget.$r = original;
    };
  }
  return undefined;
}

/**
 * Replaces one image helper member used by pointer-resource tests.
 *
 * @param target Candidate image module object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchImageMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const imageTarget = target as ImagePatchTarget;
  if (key === 'createImageSource') {
    const original = imageTarget.createImageSource;
    imageTarget.createImageSource = replacement as (buffer: ArrayBuffer) => Object;
    return (): void => {
      imageTarget.createImageSource = original;
    };
  }
  return undefined;
}

/**
 * Replaces one window API member used by pointer-style tests.
 *
 * @param target Candidate window module object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchWindowMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const windowTarget = target as WindowPatchTarget;
  if (key === 'getLastWindow') {
    const original = windowTarget.getLastWindow;
    windowTarget.getLastWindow = replacement as (context: Object, callback: (err: Object | undefined, win: Object) => void) => void;
    return (): void => {
      windowTarget.getLastWindow = original;
    };
  }
  return undefined;
}

/**
 * Replaces one pointer API member used by cursor-style tests.
 *
 * @param target Candidate pointer module object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchPointerMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const pointerTarget = target as PointerPatchTarget;
  if (key === 'getPointerStyleSync') {
    const original = pointerTarget.getPointerStyleSync;
    pointerTarget.getPointerStyleSync = replacement as (windowId: number) => Object;
    return (): void => {
      pointerTarget.getPointerStyleSync = original;
    };
  }
  if (key === 'setPointerStyle') {
    const original = pointerTarget.setPointerStyle;
    pointerTarget.setPointerStyle = replacement as (windowId: number, style: Object) => void;
    return (): void => {
      pointerTarget.setPointerStyle = original;
    };
  }
  if (key === 'setCustomCursorSync') {
    const original = pointerTarget.setCustomCursorSync;
    pointerTarget.setCustomCursorSync = replacement as (windowId: number, pixelMap: Object, x: number, y: number) => void;
    return (): void => {
      pointerTarget.setCustomCursorSync = original;
    };
  }
  return undefined;
}

/**
 * Replaces one PointerUtil member using explicit property access.
 *
 * @param target Candidate PointerUtil object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchPointerUtilMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const pointerUtilTarget = target as PointerUtilPatchTarget;
  if (key === 'changePointStyle') {
    const original = pointerUtilTarget.changePointStyle;
    pointerUtilTarget.changePointStyle = replacement as (isClick: boolean) => void;
    return (): void => {
      pointerUtilTarget.changePointStyle = original;
    };
  }
  return undefined;
}

/**
 * Replaces one input-event client member using explicit property access.
 *
 * @param target Candidate input event client object.
 * @param key Member name requested by the current test.
 * @param replacement Replacement implementation.
 * @returns (() => void) | undefined Restore callback when the key is supported.
 */
function patchInputEventClientMember(target: Object, key: string, replacement: Object): (() => void) | undefined {
  const inputEventTarget = target as InputEventClientPatchTarget;
  if (key === 'injectEvent') {
    const original = inputEventTarget.injectEvent;
    inputEventTarget.injectEvent = replacement as (payload: Object) => void;
    return (): void => {
      inputEventTarget.injectEvent = original;
    };
  }
  return undefined;
}

/**
 * Restores a batch of test patches in reverse order.
 *
 * @param restores Restore callbacks returned by `patchMember`.
 * @returns void.
 */
export function restoreAll(restores: Array<() => void>): void {
  for (let index = restores.length - 1; index >= 0; index--) {
    restores[index]();
  }
}

/**
 * Creates a structured recorder used to track business call order.
 *
 * @returns CallRecorder Shared recorder instance for the current test case.
 */
export function createCallRecorder(): CallRecorder {
  return {
    entries: []
  };
}

/**
 * Pushes a stable trace entry into the shared recorder.
 *
 * @param recorder Recorder shared by the current test.
 * @param entry Stable domain entry that represents one observable action.
 * @returns void.
 */
export function recordCall(recorder: CallRecorder, entry: string): void {
  recorder.entries.push(entry);
}

/**
 * Creates an input source entity with explicit defaults so test data stays readable.
 *
 * @param sourceId Input source identifier.
 * @param isPlugIn Whether the source is currently available.
 * @param displayOrder Visual ordering used by the page list.
 * @param sourceName Human readable source name.
 * @returns SourcePlugStateEntity Ready-to-use entity instance.
 */
export function createSourceEntity(
  sourceId: number,
  isPlugIn: boolean,
  displayOrder: number,
  sourceName: string
): SourcePlugStateEntity {
  return new SourcePlugStateEntity(sourceId, isPlugIn, displayOrder, sourceName);
}

/**
 * Creates a timing entity that mirrors the fields consumed by source info formatting.
 *
 * @param width Source timing width.
 * @param height Source timing height.
 * @param frameRate Source timing frame rate.
 * @param isInterlace Whether the timing is interlaced.
 * @returns TimingInfoEntity Initialized timing entity.
 */
export function createTimingEntity(
  width: number,
  height: number,
  frameRate: number,
  isInterlace: boolean = false
): TimingInfoEntity {
  const entity = new TimingInfoEntity();
  entity.setWidth(width);
  entity.setHeight(height);
  entity.setFrameRate(frameRate);
  entity.setIsInterlace(isInterlace);
  return entity;
}

/**
 * Extracts source names from a list to keep assertions focused on business order.
 *
 * @param sourceList Source entity list under verification.
 * @returns string[] Ordered source names.
 */
export function sourceNames(sourceList: SourcePlugStateEntity[]): string[] {
  const result: string[] = [];
  sourceList.forEach((item: SourcePlugStateEntity) => {
    result.push(item.getSourceName());
  });
  return result;
}

/**
 * Creates a minimal DTV channel fixture with explicit service typing.
 *
 * @param channelId Channel identifier consumed by playback and edit flows.
 * @param serviceType Service type consumed by radio and list filtering rules.
 * @returns PmChannel Readable DTV channel fixture.
 */
export function createDtvChannel(channelId: number, serviceType: number = 0): PmChannel {
  const channel: PmChannel = {
    channelID: channelId,
    serviceType
  };
  return channel;
}

/**
 * Creates a frequency fixture used by manual-scan and cleanup workflows.
 *
 * @param freq Frequency value under verification.
 * @returns FeConnectParam Frequency fixture.
 */
export function createDtvConnectParam(freq: number): FeConnectParam {
  const connectParam: FeConnectParam = {
    freq
  };
  return connectParam;
}

/**
 * Creates a transponder fixture that points to a target frequency.
 *
 * @param tpId Transponder identifier returned by the mock program manager.
 * @param freq Frequency owned by the transponder.
 * @returns PmTransponder Transponder fixture.
 */
export function createDtvTransponder(tpId: number, freq: number): PmTransponder {
  const transponder: PmTransponder = {
    tpID: tpId,
    connParam: createDtvConnectParam(freq)
  };
  return transponder;
}

/**
 * Provides a DTV communication mock through subclass overrides instead of reassignment.
 */
class MockDtvComm extends DtvComm {
  private readonly options: MockDtvCommOptions;

  /**
   * Stores the override set used by the current test case.
   *
   * @param options Optional business-facing overrides.
   */
  constructor(options: MockDtvCommOptions) {
    super();
    this.options = options;
  }

  /**
   * Executes the configured prepare override when present.
   *
   * @returns number SDK-style result code.
   */
  prepare(): number {
    if (this.options.prepare !== undefined) {
      return this.options.prepare();
    }
    return super.prepare();
  }

  /**
   * Executes the configured source-type override when present.
   *
   * @param antennaType Antenna type requested by the test branch.
   * @returns number SDK-style result code.
   */
  setSourceType(antennaType: FeAntennaType): number {
    if (this.options.setSourceType !== undefined) {
      return this.options.setSourceType(antennaType);
    }
    return super.setSourceType(antennaType);
  }
}

/**
 * Provides a DTV config mock through subclass overrides instead of reassignment.
 */
class MockDtvCfg extends DtvCfg {
  private readonly options: MockDtvCfgOptions;

  /**
   * Stores the override set used by the current test case.
   *
   * @param options Optional business-facing overrides.
   */
  constructor(options: MockDtvCfgOptions) {
    super();
    this.options = options;
  }

  /**
   * Executes the configured string-setting override when present.
   *
   * @param key Config key under verification.
   * @param value Config value under verification.
   * @returns number SDK-style result code.
   */
  setStringValue(key: string, value: string): number {
    if (this.options.setStringValue !== undefined) {
      return this.options.setStringValue(key, value);
    }
    return super.setStringValue(key, value);
  }

  /**
   * Executes the configured integer-setting override when present.
   *
   * @param key Config key under verification.
   * @param value Config value under verification.
   * @returns number SDK-style result code.
   */
  setIntValue(key: string, value: number): number {
    if (this.options.setIntValue !== undefined) {
      return this.options.setIntValue(key, value);
    }
    return super.setIntValue(key, value);
  }
}

/**
 * Provides a DTV frontend mock through subclass overrides instead of reassignment.
 */
class MockDtvFrontend extends DtvFrontend {
  private readonly options: MockDtvFrontendOptions;

  /**
   * Stores the override set used by the current test case.
   *
   * @param options Optional business-facing overrides.
   */
  constructor(options: MockDtvFrontendOptions) {
    super();
    this.options = options;
  }

  /**
   * Executes the configured auto-scan override when present.
   *
   * @returns number SDK-style result code.
   */
  autoScan(): number {
    if (this.options.autoScan !== undefined) {
      return this.options.autoScan();
    }
    return super.autoScan();
  }

  /**
   * Executes the configured manual-scan override when present.
   *
   * @returns number SDK-style result code.
   */
  manualScan(): number {
    if (this.options.manualScan !== undefined) {
      return this.options.manualScan();
    }
    return super.manualScan();
  }

  /**
   * Executes the configured abort-scan override when present.
   *
   * @returns number SDK-style result code.
   */
  abortScan(): number {
    if (this.options.abortScan !== undefined) {
      return this.options.abortScan();
    }
    return super.abortScan();
  }

  /**
   * Executes the configured antenna-type override when present.
   *
   * @param antennaType Antenna type requested by the test branch.
   * @returns number SDK-style result code.
   */
  setAntennaType(antennaType: FeAntennaType): number {
    if (this.options.setAntennaType !== undefined) {
      return this.options.setAntennaType(antennaType);
    }
    return super.setAntennaType(antennaType);
  }

  /**
   * Executes the configured scan-attribute override when present.
   *
   * @param scanCaType Scan CA mode requested by the test branch.
   * @param scanProgType Scan program mode requested by the test branch.
   * @returns number SDK-style result code.
   */
  setScanAttr(scanCaType: FeScanCaType, scanProgType: FeScanProgType): number {
    if (this.options.setScanAttr !== undefined) {
      return this.options.setScanAttr(scanCaType, scanProgType);
    }
    return super.setScanAttr(scanCaType, scanProgType);
  }

  /**
   * Executes the configured connect-parameter override when present.
   *
   * @param freq Connect parameters requested by the test branch.
   * @returns number SDK-style result code.
   */
  SetConnectParam(freq: FeConnectParam): number {
    if (this.options.setConnectParam !== undefined) {
      return this.options.setConnectParam(freq);
    }
    return super.SetConnectParam(freq);
  }
}

/**
 * Provides a DTV AV mock through subclass overrides instead of reassignment.
 */
class MockDtvAv extends DtvAv {
  private readonly options: MockDtvAvOptions;

  /**
   * Stores the override set used by the current test case.
   *
   * @param options Optional business-facing overrides.
   */
  constructor(options: MockDtvAvOptions) {
    super();
    this.options = options;
  }

  /**
   * Executes the configured open override when present.
   *
   * @returns number SDK-style result code.
   */
  open(): number {
    if (this.options.open !== undefined) {
      return this.options.open();
    }
    return super.open();
  }

  /**
   * Executes the configured close override when present.
   *
   * @returns number SDK-style result code.
   */
  close(): number {
    if (this.options.close !== undefined) {
      return this.options.close();
    }
    return super.close();
  }

  /**
   * Executes the configured start override when present.
   *
   * @param channelId Channel requested by the test branch.
   * @param isShow Whether playback should be visible.
   * @returns number SDK-style result code.
   */
  start(channelId: number, isShow: boolean): number {
    if (this.options.start !== undefined) {
      return this.options.start(channelId, isShow);
    }
    return super.start(channelId, isShow);
  }

  /**
   * Executes the configured AV-status override when present.
   *
   * @param cmd AV command requested by the test branch.
   * @returns number | AvPlayStatus SDK status payload.
   */
  getAvStatus(cmd: AvCmdType): number | AvPlayStatus {
    if (this.options.getAvStatus !== undefined) {
      return this.options.getAvStatus(cmd);
    }
    return super.getAvStatus(cmd);
  }
}

/**
 * Provides a program manager mock through subclass overrides instead of reassignment.
 */
class MockProgramManager extends ProgramManager {
  private readonly options: MockProgramManagerOptions;

  /**
   * Stores the override set used by the current test case.
   *
   * @param options Optional business-facing overrides.
   */
  constructor(options: MockProgramManagerOptions) {
    super();
    this.options = options;
  }

  /**
   * Executes the configured last-channel override when present.
   *
   * @returns number | undefined Last channel identifier.
   */
  getLastChannelID(): number | undefined {
    if (this.options.getLastChannelID !== undefined) {
      return this.options.getLastChannelID();
    }
    return super.getLastChannelID();
  }

  /**
   * Executes the configured channel-query override when present.
   *
   * @param channelId Channel identifier requested by the test branch.
   * @returns PmChannel | undefined Matching channel fixture.
   */
  getChannelByID(channelId: number): PmChannel | undefined {
    if (this.options.getChannelByID !== undefined) {
      return this.options.getChannelByID(channelId);
    }
    return super.getChannelByID(channelId);
  }

  /**
   * Executes the configured channel-delete override when present.
   *
   * @param channelId Channel identifier requested by the test branch.
   * @returns number SDK-style result code.
   */
  delChannelByID(channelId: number): number {
    if (this.options.delChannelByID !== undefined) {
      return this.options.delChannelByID(channelId);
    }
    return super.delChannelByID(channelId);
  }

  /**
   * Executes the configured save-table override when present.
   *
   * @param tableType Table type requested by the test branch.
   * @param arg Save argument requested by the test branch.
   * @returns number SDK-style result code.
   */
  saveTable(tableType: PmTableType, arg: number): number {
    if (this.options.saveTable !== undefined) {
      return this.options.saveTable(tableType, arg);
    }
    return super.saveTable(tableType, arg);
  }

  /**
   * Executes the configured service-mode override when present.
   *
   * @param serviceMode Service mode requested by the test branch.
   * @returns number SDK-style result code.
   */
  setServiceMode(serviceMode: ServiceModeType): number {
    if (this.options.setServiceMode !== undefined) {
      return this.options.setServiceMode(serviceMode);
    }
    return super.setServiceMode(serviceMode);
  }

  /**
   * Executes the configured channel-group override when present.
   *
   * @param filter Channel filter requested by the test branch.
   * @returns number Group identifier.
   */
  getChannelGroup(filter: PmChannelFilter): number {
    if (this.options.getChannelGroup !== undefined) {
      return this.options.getChannelGroup(filter);
    }
    return super.getChannelGroup(filter);
  }

  /**
   * Executes the configured channel-count override when present.
   *
   * @param groupType Group type requested by the test branch.
   * @returns number Channel count.
   */
  getChannelNum(groupType: number): number {
    if (this.options.getChannelNum !== undefined) {
      return this.options.getChannelNum(groupType);
    }
    return super.getChannelNum(groupType);
  }

  /**
   * Executes the configured channel-list override when present.
   *
   * @param groupType Group type requested by the test branch.
   * @param offset Paging offset requested by the test branch.
   * @param count Paging size requested by the test branch.
   * @returns PmChannel[] Channel list fixture.
   */
  getChannelList(groupType: number, offset: number, count: number): PmChannel[] {
    if (this.options.getChannelList !== undefined) {
      return this.options.getChannelList(groupType, offset, count);
    }
    return super.getChannelList(groupType, offset, count);
  }

  /**
   * Executes the configured signal-type delete override when present.
   *
   * @param signalType Signal type requested by the test branch.
   * @returns number SDK-style result code.
   */
  delChannelBySignalType(signalType: FeAntennaType): number {
    if (this.options.delChannelBySignalType !== undefined) {
      return this.options.delChannelBySignalType(signalType);
    }
    return super.delChannelBySignalType(signalType);
  }

  /**
   * Executes the configured channel-move override when present.
   *
   * @param groupType Group type requested by the test branch.
   * @param channelId Channel identifier requested by the test branch.
   * @param dstPos Destination position requested by the test branch.
   * @returns number SDK-style result code.
   */
  moveChannel(groupType: number, channelId: number, dstPos: number): number {
    if (this.options.moveChannel !== undefined) {
      return this.options.moveChannel(groupType, channelId, dstPos);
    }
    return super.moveChannel(groupType, channelId, dstPos);
  }

  /**
   * Executes the configured press-frequency-count override when present.
   *
   * @param signalType Signal type requested by the test branch.
   * @returns number Frequency count.
   */
  getPressFreqNum(signalType: FeAntennaType): number {
    if (this.options.getPressFreqNum !== undefined) {
      return this.options.getPressFreqNum(signalType);
    }
    return super.getPressFreqNum(signalType);
  }

  /**
   * Executes the configured press-frequency-list override when present.
   *
   * @param signalType Signal type requested by the test branch.
   * @param offset Paging offset requested by the test branch.
   * @param count Paging size requested by the test branch.
   * @returns FeConnectParam[] Frequency list fixture.
   */
  getPressFreList(signalType: FeAntennaType, offset: number, count: number): FeConnectParam[] {
    if (this.options.getPressFreList !== undefined) {
      return this.options.getPressFreList(signalType, offset, count);
    }
    return super.getPressFreList(signalType, offset, count);
  }

  /**
   * Executes the configured delivery-count override when present.
   *
   * @param signalType Signal type requested by the test branch.
   * @returns number Delivery count.
   */
  getDeliverSystemNum(signalType: FeAntennaType): number {
    if (this.options.getDeliverSystemNum !== undefined) {
      return this.options.getDeliverSystemNum(signalType);
    }
    return super.getDeliverSystemNum(signalType);
  }

  /**
   * Executes the configured delivery-list override when present.
   *
   * @param signalType Signal type requested by the test branch.
   * @param offset Paging offset requested by the test branch.
   * @param count Paging size requested by the test branch.
   * @returns DeliveryInfo[] Delivery list fixture.
   */
  getDeliverSystemList(signalType: FeAntennaType, offset: number, count: number): DeliveryInfo[] {
    if (this.options.getDeliverSystemList !== undefined) {
      return this.options.getDeliverSystemList(signalType, offset, count);
    }
    return super.getDeliverSystemList(signalType, offset, count);
  }

  /**
   * Executes the configured transponder-count override when present.
   *
   * @param deliveryId Delivery identifier requested by the test branch.
   * @returns number Transponder count.
   */
  getStatelliteTpNum(deliveryId: number): number {
    if (this.options.getStatelliteTpNum !== undefined) {
      return this.options.getStatelliteTpNum(deliveryId);
    }
    return super.getStatelliteTpNum(deliveryId);
  }

  /**
   * Executes the configured transponder-list override when present.
   *
   * @param deliveryId Delivery identifier requested by the test branch.
   * @param offset Paging offset requested by the test branch.
   * @param count Paging size requested by the test branch.
   * @returns PmTransponder[] Transponder list fixture.
   */
  getStatelliteTpList(deliveryId: number, offset: number, count: number): PmTransponder[] {
    if (this.options.getStatelliteTpList !== undefined) {
      return this.options.getStatelliteTpList(deliveryId, offset, count);
    }
    return super.getStatelliteTpList(deliveryId, offset, count);
  }
}

/**
 * Creates a mutable DTV common mock backed by the real SDK class.
 *
 * @param options Optional overrides for the methods used by the current test.
 * @returns DtvComm Concrete SDK instance with overridden behaviors.
 */
export function createMockDtvComm(options: MockDtvCommOptions): DtvComm {
  return new MockDtvComm(options);
}

/**
 * Creates a mutable DTV config mock backed by the real SDK class.
 *
 * @param options Optional overrides for config-writing methods.
 * @returns DtvCfg Concrete SDK instance with overridden behaviors.
 */
export function createMockDtvCfg(options: MockDtvCfgOptions): DtvCfg {
  return new MockDtvCfg(options);
}

/**
 * Creates a mutable DTV frontend mock backed by the real SDK class.
 *
 * @param options Optional overrides for scan and tuner methods.
 * @returns DtvFrontend Concrete SDK instance with overridden behaviors.
 */
export function createMockDtvFrontend(options: MockDtvFrontendOptions): DtvFrontend {
  return new MockDtvFrontend(options);
}

/**
 * Creates a mutable DTV AV mock backed by the real SDK class.
 *
 * @param options Optional overrides for playback methods.
 * @returns DtvAv Concrete SDK instance with overridden behaviors.
 */
export function createMockDtvAv(options: MockDtvAvOptions): DtvAv {
  return new MockDtvAv(options);
}

/**
 * Creates a mutable program manager mock backed by the real SDK class.
 *
 * @param options Optional overrides for data-query and persistence methods.
 * @returns ProgramManager Concrete SDK instance with overridden behaviors.
 */
export function createMockProgramManager(options: MockProgramManagerOptions): ProgramManager {
  return new MockProgramManager(options);
}

/**
 * Creates a lightweight key event fixture for remote-control driven tests.
 *
 * @param code Key code that drives the branch under verification.
 * @returns KeyEvent Cast test event accepted by business handlers.
 */
export function createKeyEventFixture(code: number): KeyEvent {
  return {
    key: {
      code
    }
  } as KeyEvent;
}

/**
 * Creates a compact AV start record for playback-related assertions.
 *
 * @param channelId Channel identifier targeted by playback.
 * @param isShow Whether the playback path should expose audio/video.
 * @returns AvStartCall Structured playback record.
 */
export function createAvStartCall(channelId: number, isShow: boolean): AvStartCall {
  return {
    channelId,
    isShow
  };
}

/**
 * Creates a compact channel-move record for edit-mode assertions.
 *
 * @param groupType Target group type used by the program manager.
 * @param channelId Channel being moved inside the current group.
 * @param dstPos Destination position requested by the editor.
 * @returns ChannelMoveCall Structured edit action record.
 */
export function createChannelMoveCall(groupType: number, channelId: number, dstPos: number): ChannelMoveCall {
  return {
    groupType,
    channelId,
    dstPos
  };
}

/**
 * Creates a save-table record so persistence assertions remain data-oriented.
 *
 * @param tableType Table type selected by the manager.
 * @param arg Additional persistence flag used by the underlying SDK.
 * @returns SaveTableCall Structured persistence record.
 */
export function createSaveTableCall(tableType: PmTableType, arg: number): SaveTableCall {
  const saveTableCall: SaveTableCall = {
    tableType,
    arg
  };
  return saveTableCall;
}

/**
 * Creates a mission fixture that mirrors the shape consumed by Recent-return logic.
 *
 * @param missionId Mission identifier reported by the ability framework.
 * @param bundleName Bundle name used to match the pull source.
 * @param abilityName Ability name stored in the mission want.
 * @returns MissionInfoFixture Readable mission fixture.
 */
export function createMissionInfo(
  missionId: number,
  bundleName: string,
  abilityName: string = 'EntryAbility'
): MissionInfoFixture {
  return {
    missionId,
    want: {
      abilityName,
      bundleName
    }
  };
}
