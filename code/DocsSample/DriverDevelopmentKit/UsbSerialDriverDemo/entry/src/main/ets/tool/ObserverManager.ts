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

// ObserverManager.ts
export class ObserverManager<T> {
  private observers: Array<(value: T) => void> = [];

  public subscribe(observer: (value: T) => void) {
    this.observers.push(observer);
  }

  public unsubscribe(observer: (value: T) => void) {
    const index = this.observers.indexOf(observer);
    if (index > -1) {
      this.observers.splice(index, 1);
    }
  }

  public notify(value: T) {
    this.observers.forEach((observer) => observer(value));
  }
}

// 创建一个具体的ObserverManager实例，用于管理boolean类型的状态
export const SerialPortStatusManager = new ObserverManager<boolean>();