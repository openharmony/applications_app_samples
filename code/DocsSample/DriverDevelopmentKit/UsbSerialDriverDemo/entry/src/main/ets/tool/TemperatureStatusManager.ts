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

// TemperatureStatusManager.ts
import { hilog } from '@kit.PerformanceAnalysisKit';

export class TemperatureStatusManager {
  private static temperatureStatus: boolean = false;
  private static listeners: Array<(status: boolean) => void> = [];

  public static subscribe(callback: (status: boolean) => void) {
    this.listeners.push(callback);
    callback(this.temperatureStatus);
  }

  public static unsubscribe(callback: (status: boolean) => void) {
    this.listeners = this.listeners.filter(listeners => listeners !== callback);
  }

  public static notify(status: boolean) {
    this.temperatureStatus = status;
    hilog.info(0, 'testTag ui', `notify  temperatureStatus status:${this.temperatureStatus}`);
    this.listeners.forEach(listener => listener(status));
  }

  public static getTemperatureStatus(): boolean {
    return this.temperatureStatus;
  }
}