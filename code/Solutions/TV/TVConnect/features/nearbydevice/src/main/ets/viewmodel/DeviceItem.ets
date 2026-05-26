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
import { ConnectState } from './DevicesManager';
import Point from './Point';
import { ProtocolType } from '@ohos/common';

/**
 * 单个设备的数据
 */
@Observed
export default class DeviceItem {
  public index: number = 0;
  public image: Resource | string = $r('app.media.ic_device');
  public name: Resource | string = $r('app.string.device_unknown');
  public point: Point = new Point(0, 0);
  public connectState: ConnectState = ConnectState.NOT_START;
  public isVirtual: boolean = false;
  public signalStrength: number = 0;
  public protocolType: ProtocolType = ProtocolType.VIRTUAL;

  constructor(index: number, image: Resource | string, name: Resource | string, isVirtual: boolean = false,
    signalStrength: number = 0, protocolType: ProtocolType) {
    this.index = index;
    this.image = image;
    this.name = name;
    this.isVirtual = isVirtual;
    this.signalStrength = signalStrength;
    this.protocolType = protocolType;
  }
}