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
export type LogFunc = (tag?: string | number, log?: string | number) => void;
export type InitLogFunc = (str?: string) => LogFunc;

export interface LoggerApi {
  log: LogFunc;
  err: LogFunc;
  info: LogFunc;
  warn: LogFunc;
  debug: LogFunc;
  initLog: InitLogFunc;
  initErr: InitLogFunc;
  initInfo: InitLogFunc;
  initWarn: InitLogFunc;
  initDebug: InitLogFunc;
  logTime: (str: string) => void;
}

export declare const Logger: LoggerApi;
export declare const logger: LoggerApi;
export declare const log: LogFunc;
export declare const err: LogFunc;
export declare const info: LogFunc;
export declare const warn: LogFunc;
export declare const debug: LogFunc;
export declare const initLog: InitLogFunc;
export declare const initErr: InitLogFunc;
export declare const initInfo: InitLogFunc;
export declare const initWarn: InitLogFunc;
export declare const initDebug: InitLogFunc;
export declare const logTime: (str: string) => void;

export declare const userGrantPermission: (
  context: {
    abilityInfo: { bundleName: string };
    requestPermissionsFromUser: (permissions: string[]) => Promise<{ authResults?: number[] }>;
  },
  opts: {
    permissions: Array<{ name: string }>;
    bundleName?: string;
    bundleFlag?: number;
    userID?: number;
  },
  call?: () => void
) => Promise<void>;

export declare const objType: (obj: Object | string | number | boolean | null | undefined) => string;
export declare const getScreenOrientation: () => Promise<number>;
export declare const util: {
  objType: typeof objType;
  getScreenOrientation: typeof getScreenOrientation;
  isVideoFile: (name: string) => boolean;
};

export interface AppWindowSizeResult {
  width: number;
  height: number;
  pageW: number;
  pageH: number;
  dpi: number;
  lpi: number;
}

export declare const getAppWindowSize: (win: {
  getProperties: () => Promise<{ windowRect: { width: number; height: number } }>;
}) => Promise<AppWindowSizeResult>;

export interface HttpResponseLike {
  responseCode: number;
  result: Object | string;
}

export declare const request: (option: {
  url: string;
  method?: number;
  extraData?: Object;
  expectDataType?: number;
}) => Promise<HttpResponseLike>;
export declare const httpGet: (option: { url: string }) => Promise<HttpResponseLike>;
export declare const httpPost: (option: { url: string; data?: Object; dataType?: number }) => Promise<HttpResponseLike>;

export enum DeviceType {
  UNKNOWN_TYPE = 0
}

export interface DistributedManagerDeviceInfo {
  deviceId: string;
  deviceName: string;
  deviceType: DeviceType;
  networkId: string;
  range: number;
  isTrust?: boolean;
  isInTransfer?: boolean;
  isInAuth?: boolean;
  transferLoading?: boolean;
  trustDeviceId?: string;
}

export interface DeviceInfo {
  deviceId: string;
  deviceName: string;
  deviceType: DeviceType;
  networkId: string;
  range: number;
}

export declare class DistributedManager {
  static getInstance(): DistributedManager;
  deviceList: DistributedManagerDeviceInfo[] | null;
  localDeviceInfo: DeviceInfo | null;
  startScan(): void;
  stopScan(): void;
  release(): void;
  onDeviceListChange(callback: (data: DistributedManagerDeviceInfo[]) => void): void;
  updateDeviceProp(deviceId: string, key: string, value: Object | string | number | boolean): void;
  authenticateDevice(deviceInfo: DeviceInfo, authParam: Object): void;
  getLocalDeviceInfo(): void;
}

export declare class ComEvent {
  constructor(events: string[], callback: (err: { code: number; message: string; name: string }, data: Record<string, string>) => void);
  unsubscribe(callback?: (err: { code: number; message: string; name: string }) => void): void;
}

export declare const bindKeyClick: (obj: Object) => void;
export declare const leftClick: () => void;
export declare const rightClick: () => void;
export declare const upClick: () => void;
export declare const downClick: () => void;
export declare const tabClick: () => void;
