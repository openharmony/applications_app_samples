/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { Good } from '../model/Good'

class BasicDataSource implements IDataSource {
  private listeners: DataChangeListener[] = []

  public totalCount(): number {
    return 0
  }

  public getData(index: number): any {
    return undefined
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

export class EmitterSource extends BasicDataSource {
  public productData: Array<unknown>

  constructor(productData: Array<unknown>) {
    super()
    this.productData = productData
  }

  public totalCount(): number {
    return this.productData.length
  }

  public getData(index: number): any {
    return this.productData[index]
  }

  public addData(index: number, data: any): void {
    this.productData.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: any): void {
    this.productData.push(data)
    this.notifyDataAdd(this.productData.length - 1)
  }
}

export class ArrIfoSource extends BasicDataSource {
  public ArrIfoData: Array<Good>

  constructor(ArrIfoData: Array<Good>) {
    super()
    this.ArrIfoData = ArrIfoData
  }

  public totalCount(): number {
    return this.ArrIfoData.length
  }

  public getData(index: number): any {
    return this.ArrIfoData[index]
  }

  public addData(index: number, data: any): void {
    this.ArrIfoData.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: any): void {
    this.ArrIfoData.push(data)
    this.notifyDataAdd(this.ArrIfoData.length - 1)
  }
}
