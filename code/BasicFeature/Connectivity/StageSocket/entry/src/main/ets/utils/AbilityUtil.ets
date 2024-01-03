/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import Logger from './Logger';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';

const TAG = 'Socket AbilityUtil';

export default function startAbility(want: Want) {
  try {
    const abilityContext: common.UIAbilityContext = AppStorage.get('abilityContext')!
    abilityContext.startAbility(want, () => {
      Logger.info(TAG, 'startAbility callback ');
    });
  } catch (error) {
    Logger.info(TAG, `callback startAbility failed, error code: ${error.code}, message: ${error.message}.`);
  }
}