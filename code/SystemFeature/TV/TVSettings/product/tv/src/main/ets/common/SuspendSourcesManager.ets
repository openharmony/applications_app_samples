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

const TAG: string = 'SuspendSourcesManager';

export interface SuspendSource {
  action: number;
  delayMs: number;
}
// 方式2：使用内部接口
export interface PowerConfigJson {
  powerkey: SuspendSource;
  timeout: SuspendSource;
  lid: SuspendSource;
  switch: SuspendSource;
}



let defaultSuspendSource: SuspendSource = {
  action: 1,
  delayMs: 0
}

let mKeyArr: string[] = ['powerkey', 'timeout', 'lid', 'switch'];
let mSuspendSourceArr: SuspendSource[] = [];

export class SuspendSourcesManager {

  getKeys(): string[] {
    let arr: string[] = [];
    for (let i = 0; i < mKeyArr.length; i++) {
      arr[i] = mKeyArr[i];
    }
    return arr;
  }

  getSuspendSources(): SuspendSource[] {
    let arr: SuspendSource[] = [];
    for (let i = 0; i < mSuspendSourceArr.length; i++) {
      arr[i] = mSuspendSourceArr[i];
    }
    return arr;
  }

  parseConfig(powerConfigJson: string): SuspendSource[] {
    console.debug(TAG, 'parseConfig s powerConfigJson = ' + powerConfigJson);
    let configJson = JSON.parse(powerConfigJson) as PowerConfigJson;
    if (configJson) {
      console.debug(TAG, 'parseConfig 1-1');
      let powerkey: SuspendSource = configJson.powerkey;
      console.debug(TAG, 'parseConfig powerkey=' + JSON.stringify(powerkey));
      if (powerkey) {
        mSuspendSourceArr[0] = powerkey;
      } else {
        mSuspendSourceArr[0] = defaultSuspendSource;
      }

      let timeout: SuspendSource = configJson.timeout;
      console.debug(TAG, 'parseConfig timeout=' + JSON.stringify(timeout));
      if (timeout) {
        mSuspendSourceArr[1] = timeout;
      } else {
        mSuspendSourceArr[1] = defaultSuspendSource;
      }

      let lid: SuspendSource = configJson.lid;
      console.debug(TAG, 'parseConfig lid=' + JSON.stringify(lid));
      if (lid) {
        mSuspendSourceArr[2] = lid;
      } else {
        mSuspendSourceArr[2] = defaultSuspendSource;
      }

      let switchSuspendSource: SuspendSource = configJson.switch;
      console.debug(TAG, 'parseConfig switch=' + JSON.stringify(switchSuspendSource));
      if (switchSuspendSource) {
        mSuspendSourceArr[3] = switchSuspendSource;
      } else {
        mSuspendSourceArr[3] = defaultSuspendSource;
      }
    } else {
      console.error(TAG, 'parseConfig configJson is null!');
      for (let i = 0; i < mKeyArr.length; i++) {
        mSuspendSourceArr[i] = defaultSuspendSource;
      }
    }
    console.debug(TAG, 'parseConfig e');
    return this.getSuspendSources();
  }

  private switchToJsonStr(): string {
    let suspendSourcesJson: PowerConfigJson = {
      powerkey: mSuspendSourceArr[0],
      timeout: mSuspendSourceArr[1],
      lid: mSuspendSourceArr[2],
      switch: mSuspendSourceArr[3]
    };
    let suspendSourcesJsonStr = JSON.stringify(suspendSourcesJson);
    return suspendSourcesJsonStr;
  }

  updateSuspendSource(key: string, action: number, delayMs: number): string {
    console.debug(TAG, 'setSuspendSource key=' + key + ' action=' + action + ' delayMs=' + delayMs);
    for (let i = 0; i < mKeyArr.length; i++) {
      if (mKeyArr[i] == key) {
        mSuspendSourceArr[i].action = action;
        mSuspendSourceArr[i].delayMs = delayMs;
        let powerConfigJson = this.switchToJsonStr();
        return powerConfigJson;
      }
    }
    return '';
  }

  updateAllSuspendSources(action: number, delayMs: number): string {
    console.debug(TAG, 'updateAllSuspendSources action=' + action + ' delayMs=' + delayMs);
    for (let i = 0; i < mKeyArr.length; i++) {
      mSuspendSourceArr[i].action = action;
      mSuspendSourceArr[i].delayMs = delayMs;
    }
    let powerConfigJson = this.switchToJsonStr();
    return powerConfigJson;
  }
}
export const suspendSourcesManager = new SuspendSourcesManager();
