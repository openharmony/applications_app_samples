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

//用于存储蓝牙的名称可id
import BaseModel from '../../../../../../../common/utils/src/main/ets/default/model/BaseModel';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import dataShare from '@ohos.data.dataShare';
import settings from '@ohos.settings';

export class HueModel extends BaseModel {
  private dataShareHelper: dataShare.DataShareHelper | null = null;
  private readonly listenUri =
    'dataShare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=' + ConfigData.SETTINGSDATA_HUE;

  constructor() {
    super();
    dataShare.createDataShareHelper(globalThis.settingsAbilityContext as Context, this.listenUri)
      .then((dataHelper) => {
        this.dataShareHelper = dataHelper;
      })
  }

  getHue(): string {
    let hueInfo: string =
      settings.getValueSync(globalThis.settingsAbilityContext as Context, ConfigData.SETTINGSDATA_HUE, '',
        settings.domainName.DEVICE_SHARED);
    if (hueInfo !== '') {
      return hueInfo;
    } else {
      return '';
    }
  }

  setHue(value: string): void {
    settings.setValueSync(globalThis.settingsAbilityContext as Context, ConfigData.SETTINGSDATA_HUE, value,
      settings.domainName.DEVICE_SHARED)
  }
}

let hueModel = new HueModel();

export default hueModel as HueModel;
