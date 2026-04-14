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
 

import { promptAction } from '@kit.ArkUI';
import { displaySetting } from '@kit.TVMWKit';
import Log from '../../../../../../../common/src/main/ets/default/Log';

const TAG = 'ControlPanel_BrightnessModel';

// BrightnessModel 封装对 TV 厂商专有 displaySetting API 的调用，
// 之所以单独抽出 Model 层而非在组件里直接调用，是因为该 API 仅在特定硬件平台存在，
// 隔离后便于在标准设备上 Mock 替换，不影响 UI 层的开发和预览。
export class BrightnessModel {
  async getOutputBrightness(): Promise<number | undefined> {
    try {
      // 调用厂商api
      const value = await displaySetting.getOutputBrightness()
      return value;
    } catch (error) {
      Log.showError(TAG, `getOutputBrightness error:${JSON.stringify(error)}`);
      // 获取失败时返回 undefined 而非抛出，由上层决定是否使用默认亮度值展示，
      // 防止因厂商接口异常导致整个控制面板白屏。
      return undefined;
    }
  }


  setOutputBrightness(brightnessValue: number) {
    try {
      // 调用厂商api
      displaySetting.setOutputBrightness(brightnessValue);
    } catch (error) {
      Log.showError(TAG, `setOutputBrightness error:${JSON.stringify(error)}`);
      promptAction.showToast({ message: '该功能开发中，敬请期待' })
    }
  }
}

let brightnessModel = new BrightnessModel();

export default brightnessModel as BrightnessModel;