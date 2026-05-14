/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
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

import { DeviceType, DistributedManagerDeviceInfo, DeviceStateChangeAction, DeviceInfo } from '../../../../main/ets/model/RemoteDeviceModel';
import { DeviceInfoType, AuthParam } from '../../../../main/ets/const/Type';
import { songItemType } from '../../../../main/ets/model/Music';

// ── Shared interfaces for typed object literals (ArkTS requires explicit class/interface) ──

/**
 * Generic string record - use when extraInfo or config objects need typed keys.
 */
export interface StringRecord extends Record<string, string> {}

/**
 * Generic object record - use for preference/test data with mixed value types.
 */
export interface ObjRecord extends Record<string, object> {}

/**
 * Typed extraInfo for auth scenarios with deviceId, deviceName, and optional token.
 */
export interface DeviceExtraInfo extends Record<string, string> {
  deviceId: string;
  deviceName: string;
}

/**
 * Extended extraInfo for auth scenarios with token field.
 */
export interface DeviceTokenExtraInfo extends Record<string, string> {
  deviceId: string;
  deviceName: string;
  token: string;
}

/**
 * ExtraInfo for duplicate auth requests with request sequence.
 */
export interface DuplicateAuthExtraInfo extends Record<string, string> {
  deviceId: string;
  requestSeq: string;
  timestamp: string;
}

/**
 * ExtraInfo with pinCode for PIN-based auth.
 */
export interface PinCodeExtraInfo extends Record<string, string> {
  deviceId: string;
  deviceName: string;
  pinCode: string;
}

/**
 * ExtraInfo with target device fields for cross-module auth.
 */
export interface TargetDeviceExtraInfo extends Record<string, string> {
  targetDeviceId: string;
  targetDeviceName: string;
  targetDeviceType: string;
}

/**
 * ExtraInfo with custom fields for serialization tests.
 */
export interface CustomExtraInfo extends Record<string, string> {
  customField: string;
  protocolVersion: string;
}

/**
 * Typed preference record for storing key-value test data.
 */
export interface PreferenceRecord {
  key: string;
  value: string;
}

/**
 * Device display record - used in ExtendedCoverage mock data arrays.
 */
export interface DeviceDisplayRecord {
  type: string;
  id: string;
  name: string;
  isTrust: boolean;
  isActive: boolean;
  range: number;
  status: string;
}

/**
 * Typed container for holding a string record value.
 */
export interface RecordHolder extends Record<string, object> {
  value: object;
}

/**
 * Typed container for child record with nullable next node.
 */
export interface NestedContainer extends Record<string, object> {
  value: object;
  child: object | null;
}

/**
 * Payload interface for transport events.
 */
export interface TransportEventPayload {
  type: string;
  device: DeviceInfoType;
  auth: AuthParam;
}

/**
 * Payload interface for auth events.
 */
export interface AuthEventPayload {
  type: string;
  data: AuthParam;
}

// ── Helper functions for creating typed objects ──

/**
 * Create a DeviceInfoType from individual fields.
 */
export function makeDeviceInfo(
  deviceId: string,
  deviceName: string,
  deviceType: DeviceType,
  networkId: string,
  range: number
): DeviceInfoType {
  const result: DeviceInfoType = {
    deviceId: deviceId,
    deviceName: deviceName,
    deviceType: deviceType,
    networkId: networkId,
    range: range
  };
  return result;
}

/**
 * Create a DistributedManagerDeviceInfo with all fields explicitly set.
 */
export function makeDistributedDeviceInfo(
  deviceId: string,
  deviceName: string,
  deviceType: DeviceType,
  networkId: string,
  range: number,
  isInAuth: boolean,
  isTrust: boolean,
  trustDeviceId: string,
  transferLoading: boolean,
  isInTransfer: boolean,
  action: DeviceStateChangeAction,
  updateTime: number,
  pinToken: number,
  isDelete: boolean
): DistributedManagerDeviceInfo {
  const result: DistributedManagerDeviceInfo = {
    deviceId: deviceId,
    deviceName: deviceName,
    deviceType: deviceType,
    networkId: networkId,
    range: range,
    isInAuth: isInAuth,
    isTrust: isTrust,
    trustDeviceId: trustDeviceId,
    transferLoading: transferLoading,
    isInTransfer: isInTransfer,
    action: action,
    updateTime: updateTime,
    pinToken: pinToken,
    isDelete: isDelete
  };
  return result;
}

/**
 * Create a Record<string, string> from a string-keyed object.
 * Use this to satisfy ArkTS strict mode for object literals used as records.
 */
export function makeStringRecord(entries: Record<string, string>): Record<string, string> {
  return entries;
}

/**
 * Create a Record<string, object> from an object-keyed record.
 * Use this to satisfy ArkTS strict mode for object literals used as record values.
 */
export function makeObjRecord(entries: Record<string, object>): Record<string, object> {
  return entries;
}

/**
 * Create a songItemType with all fields.
 */
export function makeSongItem(
  img: ResourceStr,
  name: string,
  author: string,
  url: string,
  time: number
): songItemType {
  const result: songItemType = {
    img: img,
    name: name,
    author: author,
    url: url,
    time: time
  };
  return result;
}

// ── Shared constants ──

/**
 * Empty string record for use as default extraInfo.
 */
export const EMPTY_STRING_RECORD: Record<string, string> = {};

/**
 * Empty object record for use as default object containers.
 */
export const EMPTY_OBJ_RECORD: Record<string, object> = {};

/**
 * String repeat helper - replaces String.prototype.repeat which may not be available.
 */
export function strRepeat(s: string, count: number): string {
  let result: string = '';
  for (let i: number = 0; i < count; i++) {
    result += s;
  }
  return result;
}
