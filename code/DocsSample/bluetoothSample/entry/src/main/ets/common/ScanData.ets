/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

export class ScanData {
  private deviceId: string = '';
  private deviceName: string = '';
  private rssi: number = 0;
  private connectable: boolean = false;
  private data: Uint8Array = new Uint8Array([0xFF, 0xFF, 0xFF, 0xFF]);

  constructor(deviceId: string = '', deviceName: string = 'null', rssi: number = 0, connectable: boolean = false,
    data: Uint8Array = new Uint8Array([0xFF, 0xFF, 0xFF, 0xFF])) {
    this.deviceId = deviceId;
    this.deviceName = deviceName;
    this.rssi = rssi;
    this.connectable = connectable;
    this.data = data;
  }

  public setDeviceId(deviceId: string) {
    this.deviceId = deviceId;
  }

  public setData(data: Uint8Array) {
    this.data = data;
  }

  public getDeviceId(): string {
    return this.deviceId;
  }

  public getData(): Uint8Array {
    return this.data;
  }

  public setDeviceName(deviceName: string) {
    this.deviceName = deviceName;
  }

  public getDeviceName(): string {
    return this.deviceName;
  }

  public setRssi(rssi: number) {
    this.rssi = rssi;
  }

  public getRssi(): number {
    return this.rssi;
  }

  public setConnectable(connectable: boolean) {
    this.connectable = connectable;
  }

  public getConnectable(): boolean {
    return this.connectable;
  }
}

let scanData = new ScanData();

export default scanData as ScanData;

