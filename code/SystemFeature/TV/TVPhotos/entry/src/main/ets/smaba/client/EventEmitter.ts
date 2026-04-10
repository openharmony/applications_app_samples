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
 
export default class EventEmitter {
  actionRecord: Map<string, Function[]> = new Map()
  onceActionRecord: Map<string, Function[]> = new Map()

  constructor() {
  }

  on(action: string, callback: Function) {
    let callbacks = this.actionRecord.get(action)
    if (callbacks === undefined) {
      callbacks = []
    }
    callbacks.push(callback)
    this.actionRecord.set(action, callbacks)
  }

  once(action: string, callback: Function) {
    let callbacks = this.onceActionRecord.get(action)
    if (callbacks === undefined) {
      callbacks = []
    }
    callbacks.push(callback)
    this.actionRecord.set(action, callbacks)
  }

  emit(action: string, object: object) {
    this.actionRecord.get(action)?.forEach((callback) => {
      callback(object)
    })

    this.onceActionRecord.get(action)?.forEach((callback) => {
      callback(object)
    })
    this.onceActionRecord.delete(action)
  }

  off(action: string, callback: Function) {
    this.deleteFromMap(action, callback, this.actionRecord)
    this.deleteFromMap(action, callback, this.onceActionRecord)
  }

  private deleteFromMap(action: string, callback: Function, callbackMap: Map<string, Function[]>) {
    let index = callbackMap.get(action)?.findIndex((cb) => {
      return cb === callback
    })
    if (index !== undefined) {
      callbackMap.get(action)?.splice(index, 1)
    }
  }
}