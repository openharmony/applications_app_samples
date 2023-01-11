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

import Contact from './Contact'
import Message from './Message'

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
    const pos = this.listeners.indexOf(listener)
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

export class ContactSource extends BasicDataSource {
  public contactData: Array<Contact>

  constructor(contactData: Array<Contact>) {
    super()
    this.contactData = contactData
  }

  public totalCount(): number {
    return this.contactData.length
  }

  public getData(index: number): any {
    return this.contactData[index]
  }

  public addData(index: number, data: any): void {
    this.contactData.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: any): void {
    this.contactData.push(data)
    this.notifyDataAdd(this.contactData.length - 1)
  }
}

export class MessageSource extends BasicDataSource {
  public MessageData: Array<Message>

  constructor(MessageData: Array<Message>) {
    super()
    this.MessageData = MessageData
  }

  public totalCount(): number {
    return this.MessageData.length
  }

  public getData(index: number): any {
    return this.MessageData[index]
  }

  public addData(index: number, data: any): void {
    this.MessageData.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: any): void {
    this.MessageData.push(data)
    this.notifyDataAdd(this.MessageData.length - 1)
  }
}
