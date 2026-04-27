//@ts-nocheck
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
 

import { settings } from '@kit.BasicServicesKit';
import { DataAbilityHelper } from 'ability/dataAbilityHelper';
import { featureAbility } from '@kit.AbilityKit';
import Log from './Log';
import Constants from './Constants';
import createOrGet from './SingleInstanceHelper';
import AbilityManager from './abilitymanager/AbilityManager';

const TAG = 'SettingsUtil';

export class SettingsUtil {
  private helper: DataAbilityHelper;

  constructor() {
    Log.showDebug(TAG, 'constructor');
    try {
      let contextName = AbilityManager.getContextName(AbilityManager.ABILITY_NAME_CONTROL_PANEL);
      this.helper = featureAbility.acquireDataAbilityHelper(Constants.URI_VAR);
    } catch (e) {
      Log.showError(TAG, `constructor, acquire helper error: ${JSON.stringify(e)}`);
    }
  }

  getValue(name: string, defValue?: string): string {
    Log.showDebug(TAG, `getValue, name: ${name} defValue: ${defValue}`);
    let value: string = null;
    try {
      value = settings.getValueSync(this.helper, name, defValue ? defValue : '');
    } catch (e) {
      Log.showError(TAG, `getValue e: ${JSON.stringify(e)}`);
    }
    Log.showDebug(TAG, `getValue, value: ${value}`);
    return value;
  }

  setValue(name: string, value: string): boolean {
    Log.showDebug(TAG, `setValue, name: ${name} value: ${value}`);
    let result = false;
    try {
      result = settings.setValueSync(this.helper, name, value);
    } catch (e) {
      Log.showError(TAG, `setValue e: ${JSON.stringify(e)}`);
    }
    Log.showDebug(TAG, `setValue, result: ${result}`);
    return result;
  }
}

let sSettingsUtil = createOrGet(() => new SettingsUtil(), TAG);

export default sSettingsUtil;