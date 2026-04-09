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

export class DnsModel extends BaseModel {
  private dataShareHelper: dataShare.DataShareHelper | null = null;
  private readonly listenUri = 'dataShare:///com.ohos.settingsdata/entry/settingsdata/SETTINGSDATA?Proxy=true&key=' + ConfigData.SETTINGSDATA_DNS;

  constructor() {
    super();
    dataShare.createDataShareHelper(globalThis.settingsAbilityContext as Context, this.listenUri)
      .then((dataHelper) => {
        this.dataShareHelper = dataHelper;
      })
  }

  getDns(): string {
    let adaptiveInfo: string = settings.getValueSync(globalThis.settingsAbilityContext as Context, ConfigData.SETTINGSDATA_DNS, '', settings.domainName.DEVICE_SHARED);
    if (adaptiveInfo !== '') {
      return adaptiveInfo
    } else {
      return '198.168.1.1';
    }
  }

  setDns(value: string): void {
    settings.setValueSync(globalThis.settingsAbilityContext as Context, ConfigData.SETTINGSDATA_DNS, value, settings.domainName.DEVICE_SHARED)
  }
}

let dnsModel = new DnsModel();

export default dnsModel as DnsModel;
