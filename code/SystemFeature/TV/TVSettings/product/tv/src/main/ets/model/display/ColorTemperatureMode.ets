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

import BaseModel from '../../../../../../../common/utils/src/main/ets/default/model/BaseModel';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import dataShare from '@ohos.data.dataShare';
import settings from '@ohos.settings';
import displaySetting from '@ohos.tvservice.displaySetting';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
const TAG = 'ColorTemperatureModelIndex'
const pictureModeMap: Record<number, string> = {
  6000: '正白',
  3000: '暖黄',
  4500: '暖白',
};

export class ColorTemperatureModel extends BaseModel {
  private dataShareHelper: dataShare.DataShareHelper | null = null;
  private readonly listenUri = 'dataShare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=' + ConfigData.SETTINGSDATA_COLORTEMPERATURE;

  constructor() {
    super();
    dataShare.createDataShareHelper(globalThis.settingsAbilityContext as Context, this.listenUri)
      .then((dataHelper) => {
        this.dataShareHelper = dataHelper;
      })
  }

 async getColorTemperature(): Promise<string> {
      try {
        let mode = await displaySetting.getEyeProtectType();
        LogUtil.log(TAG + 'getEyeProtectTypeSuccess=' + JSON.stringify(mode));
        LogUtil.log(TAG + 'getEyeProtectTypeSuccess11=' + JSON.stringify(pictureModeMap[mode]));
        return pictureModeMap[mode]
      } catch (error) {
        LogUtil.log(TAG + 'getEyeProtectTypeSuccess=' + JSON.stringify(error));
        return '正白'
      }
  }

  setColorTemperature(value: string): void {
    settings.setValueSync(
      globalThis.settingsAbilityContext as Context,
      ConfigData.SETTINGSDATA_COLORTEMPERATURE,
      value,
      settings.domainName.DEVICE_SHARED
    )
  }
}

let colorTemperatureModel = new ColorTemperatureModel();

export default colorTemperatureModel as ColorTemperatureModel;
