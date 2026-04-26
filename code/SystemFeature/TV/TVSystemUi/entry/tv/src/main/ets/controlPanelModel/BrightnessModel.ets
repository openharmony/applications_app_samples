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
import Log from '@ohos/common/src/main/ets/default/Log';
import displaySetting from '@ohos.tvservice.displaySetting';

const TAG = 'ControlPanel_BrightnessModelChange2';

export class BrightnessModel {
  async getOutputBrightness(): Promise<number | undefined> {
    try {
      // 调用厂商api
      const value:number = await displaySetting.getBrightness()
      Log.showInfo(TAG, `getBrightness value=:${value}`);
      return value;
    } catch (error) {
      Log.showError(TAG, `getOutputBrightness error:${JSON.stringify(error)}`);
      return undefined;
    }
  }


  async setOutputBrightness(brightnessValue: number) {
    try {
      Log.showInfo(TAG, `setBrightness value=:${brightnessValue}`);
      let setBrightness:boolean=await displaySetting.setBrightness(brightnessValue); // 调用厂商api
      Log.showInfo(TAG, `setOutputBrightness SuccessBoolean:${JSON.stringify(setBrightness)}`);
      if(!setBrightness){
        promptAction.showToast({ message: '设置亮度失败' })
      }
    } catch (error) {
      Log.showError(TAG, `setOutputBrightness error:${JSON.stringify(error)}`);
      promptAction.showToast({ message: '设置亮度接口报错' })
    }
  }
}

let brightnessModel = new BrightnessModel();

export default brightnessModel as BrightnessModel;