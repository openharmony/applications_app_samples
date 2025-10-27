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

// SerialPortStatusManager.ts
import { hilog } from '@kit.PerformanceAnalysisKit';

export class SerialPortStatusManager {
  private static isSerialPortOpen: boolean = false;
  private static listeners: Array<(status: boolean) => void> = [];

  public static subscribe(callback: (status: boolean) => void) {
    this.listeners.push(callback);
    callback(this.isSerialPortOpen); // 初始化时立即调用一次
  }

  public static unsubscribe(callback: (status: boolean) => void) {
    this.listeners = this.listeners.filter(listener => listener !== callback);
  }

  public static notify(status: boolean) {
    this.isSerialPortOpen = status;
    hilog.info(0, 'testTag ui', `notify  isSerialPortOpen status:${this.isSerialPortOpen}`);
    this.listeners.forEach(listener => listener(status));
  }

  public static getSerialPortStatus(): boolean {
    return this.isSerialPortOpen;
  }
}