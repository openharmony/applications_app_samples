/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import Want from '@ohos.application.Want';
import common from '@ohos.app.ability.common';
import { Log } from './Log';
import { GlobalContext } from '../common/GlobalContext';

const TAG = 'AbilityUtils';

export async function startAbility(want: Want): Promise<void> {
  try {
    let appContext: common.UIAbilityContext = GlobalContext.getContext().getObject('appContext') as common.UIAbilityContext;
    await appContext.startAbility(want);
    Log.debug(TAG, 'raul startAbility complete');
  } catch (error) {
    Log.error(TAG, 'raul startAbility failed, error: ' + JSON.stringify(error));
  }
}

export async function terminateSelf(): Promise<void> {
  let appContext: common.UIAbilityContext = GlobalContext.getContext().getObject('appContext') as common.UIAbilityContext;
  await appContext.terminateSelf();
}

export async function terminateSelfWithResult(parameter): Promise<void> {
  let appContext: common.UIAbilityContext = GlobalContext.getContext().getObject('appContext') as common.UIAbilityContext;
  await appContext.terminateSelfWithResult(parameter);
}
