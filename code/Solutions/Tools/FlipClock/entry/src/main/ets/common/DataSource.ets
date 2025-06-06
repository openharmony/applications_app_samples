/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = [];

  public totalCount(): number {
    return 0;
  }

  public getData(index: number): void {
    return undefined;
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      this.listeners.push(listener);
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      this.listeners.splice(pos, 1);
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded();
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index);
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index);
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index);
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to);
    })
  }
}

export class TabType {
  icon: Resource;
  icon_after: Resource;
  text: Resource;
  num: number;

  constructor(icon: Resource, icon_after: Resource, text: Resource, num: number) {
    this.icon = icon;
    this.icon_after = icon_after;
    this.text = text;
    this.num = num;
  }
}

export class MyDataSource extends BasicDataSource {
  private dataArray: TabType[] = [];

  constructor(data: TabType[]) {
    super()
    this.dataArray = data;
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): TabType {
    return this.dataArray[index];
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataAdd(index);
  }

  public pushData(data: TabType): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public replaceData(result: TabType[]): void {
    this.dataArray = result;
    this.notifyDataReload();
  }
}

export class Contact {
  key: string;
  value: string;
  reminderId: number;

  constructor(key: string, value: string, reminderId: number) {
    this.key = key;
    this.value = value;
    this.reminderId = reminderId;
  }
}

export class ContactSource extends BasicDataSource {
  public dataArray: Contact[] = [];

  constructor(data: Array<Contact>) {
    super()
    this.dataArray = data;
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getData(index: number): Contact {
    return this.dataArray[index];
  }

  public deleteData(index: number): void {
    this.dataArray.splice(index, 1);
    this.notifyDataAdd(index);
  }

  public pushData(data: Contact): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public replaceData(result: Contact[]): void {
    this.dataArray = result;
    this.notifyDataReload();
  }
}
