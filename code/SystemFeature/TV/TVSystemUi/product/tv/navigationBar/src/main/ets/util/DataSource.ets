/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import DeviceItem from '../viewmodel/DeviceItem';

import { Logger } from '@ohos/common';

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): DeviceItem | null {
    return null;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      Logger.info('add listener');
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      Logger.info('remove listener');
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach((listener) => {
      listener.onDataReloaded();
    });
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataAdd(index);
    });
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataChange(index);
    });
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataDelete(index);
    });
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach((listener) => {
      listener.onDataMove(from, to);
    });
  }
}

export class DeviceItemSource extends BasicDataSource {
  private deviceItemArray: Array<DeviceItem> = [];

  public totalCount(): number {
    return this.deviceItemArray.length;
  }

  public getData(index: number): DeviceItem {
    return this.deviceItemArray[index];
  }

  public findIndex(data: DeviceItem): number {
    let insertIndex = this.deviceItemArray.findIndex(device => data.signalStrength > device.signalStrength);
    return insertIndex;
  }

  public setData(deviceItemArray: Array<DeviceItem>): void {
    this.deviceItemArray = deviceItemArray;
    this.notifyDataReload();
  }

  public addData(index: number, data: DeviceItem): void {
    this.deviceItemArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: DeviceItem): void {
    this.deviceItemArray.push(data);
    this.notifyDataAdd(this.deviceItemArray.length - 1);
  }

  public clearData(){
    this.deviceItemArray = [];
    this.notifyDataReload();
    Logger.info(`clearData listener length = ${this.deviceItemArray.length}`);
  }

  public showData(tag: string){
    Logger.info(tag, `========== showData =============`);
    this.deviceItemArray.forEach(item=>{
      Logger.info(tag, `orderDeviceList device deviceName = ${item.name}, signalStrength = ${item.signalStrength}, priority = ${item.protocolType}`);
    })
  }
}
