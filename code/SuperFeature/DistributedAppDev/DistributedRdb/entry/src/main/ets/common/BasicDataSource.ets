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

import Contact from '../model/Contact'

export default class ContactDataSource implements IDataSource {
  public dataArray: Array<Contact> = new Array<Contact>();
  private listeners: Array<DataChangeListener> = [];

  constructor(dataArray: Array<Contact>) {
    this.dataArray = dataArray;
  }

  public replaceDataArray(dataArray: Array<Contact>): number {
    if (this.dataArray.length < dataArray.length) {
      // 新增联系人
      dataArray.forEach(item => {
        let contact = this.dataArray.find(obj => obj.id === item.id);
        if (!contact) {
          this.dataArray.push(item);
        }
      });
    } else if (this.dataArray.length === dataArray.length) {
      // 编辑联系人
      dataArray.forEach((item, index) => {
        this.dataArray.forEach((obj, i) => {
          if (item.id === obj.id && index === i) {
            if (item.name !== obj.name) {
               obj.name = item.name;
            } else if (item.phone !== obj.phone) {
               obj.phone = item.phone.replace(item.phone.substring(3,7), '****');
            } else if (item.remark !== obj.remark) {
               obj.remark = item.remark;
            } else if (item.age !== obj.age) {
               obj.age = item.age;
            }
          }
        });
      });
    } else {
      // 删除联系人
      this.dataArray = this.dataArray.filter(item => dataArray.some(obj => obj.id === item.id));
    }
    this.notifyDataReload();
    return this.totalCount()
  }

  public totalCount(): number {
    return this.dataArray.length;
  }

  public getDataArray(): Array<Contact> {
    return this.dataArray;
  }


  public getData(index: number): Contact {
    return this.dataArray[index];
  }

  public addData(index: number, data: Contact): void {
    this.dataArray.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: Contact): void {
    this.dataArray.push(data);
    this.notifyDataAdd(this.dataArray.length - 1);
  }

  public clear(): void {
    this.dataArray = [];
    this.notifyDataReload();
  }

  registerDataChangeListener(listener: DataChangeListener): void {
    if (this.listeners.indexOf(listener) < 0) {
      console.info('add listener')
      this.listeners.push(listener)
    }
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
    const pos = this.listeners.indexOf(listener);
    if (pos >= 0) {
      console.info('remove listener')
      this.listeners.splice(pos, 1)
    }
  }

  notifyDataReload(): void {
    this.listeners.forEach(listener => {
      listener.onDataReloaded()
    })
  }

  notifyDataAdd(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataAdd(index)
    })
  }

  notifyDataChange(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataChange(index)
    })
  }

  notifyDataDelete(index: number): void {
    this.listeners.forEach(listener => {
      listener.onDataDelete(index)
    })
  }

  notifyDataMove(from: number, to: number): void {
    this.listeners.forEach(listener => {
      listener.onDataMove(from, to)
    })
  }
}