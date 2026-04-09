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
import settings from '@ohos.settings';
import displaySetting from '@ohos.tvservice.displaySetting';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { systemParameterEnhance } from '@kit.BasicServicesKit';

const TAG = '[watchTvSource] '

export class WatchTvKeyModel extends BaseModel {
  constructor() {
    super();
  }

  static getWatchTvSource(): displaySetting.SourceType {
    try {
      let stringIndex: string = settings.getValueSync(getContext(), ConfigData.SETTINGSDATA_WATCH_TV_SOURCE, '1',
        settings.domainName.DEVICE_SHARED);
      let index: number = Number.parseInt(stringIndex);
      LogUtil.log(TAG + 'getWatchTvSource index :' + index);
      if (index >= 0) {
        LogUtil.log(TAG + 'getWatchTvSource return:' + index);
        return index;
      }
    } catch (error) {
      LogUtil.log(TAG + 'getWatchTvSource error:' + JSON.stringify(error));
    }
    LogUtil.log(TAG + 'getWatchTvSource return: : 1');
    return 1;
  }

  static setWatchTvSource(stbSource: displaySetting.SourceType): void {
    let sourceIndex: string = stbSource.toString();
    LogUtil.log(TAG + 'setWatchTvSource sourcetype:' + sourceIndex);
    settings.setValueSync(getContext(), ConfigData.SETTINGSDATA_WATCH_TV_SOURCE, sourceIndex,
      settings.domainName.DEVICE_SHARED);
  }

  static isSupport3ModeRemote(): boolean {
    try {
      let btController: string = systemParameterEnhance.getSync('const.product.btcontroller', '')
      let isSupport3ModeRemote: boolean = btController.includes('3ModeRemote')
      LogUtil.log(TAG + 'btController:' + btController + ' isSupport3ModeRemote:' + isSupport3ModeRemote);
      return isSupport3ModeRemote
    } catch (error) {
      LogUtil.log(TAG + 'isSupport3ModeRemote error:' + JSON.stringify(error))
    }
    return false

  }

  static async isSourceListEmpty(): Promise<boolean> {
    try {
      let sourceArray: displaySetting.SourceType[] = await displaySetting.GetSupportSourceList()
      LogUtil.log(TAG + 'isSourceListEmpty length:' + sourceArray.length)
      if (sourceArray.length > 0) {
        return false
      } else {
        return true
      }
    } catch (error) {
      LogUtil.log(TAG + 'isSourceListEmpty error:' + JSON.stringify(error))
    }
    return true
  }
}


