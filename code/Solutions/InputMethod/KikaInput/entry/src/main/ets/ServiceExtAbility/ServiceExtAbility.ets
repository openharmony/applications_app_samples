/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import InputMethodExtensionAbility from '@ohos.InputMethodExtensionAbility';
import Want from '@ohos.app.ability.Want';
import Log from '../model/Log';
import { KeyboardController } from '../model/KeyboardController';

const TAG: string = 'ServiceExtAbility->';

class ServiceExtAbility extends InputMethodExtensionAbility {
  private keyboardController: KeyboardController | undefined = undefined;

  onCreate(want: Want): void {
    this.addLog(`onCreate want: ${want.abilityName}`);
    this.keyboardController = new KeyboardController(this.context);
    this.keyboardController.onCreate();
  }

  onDestroy(): void {
    this.addLog('onDestroy');
    if (this.keyboardController) {
      this.keyboardController.onDestroy();
    }
  }

  addLog(message: string): void {
    Log.showInfo(TAG, `kikaInput-new: ${message}`);
  }
}

export default ServiceExtAbility;
