/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const DOMAIN = 0xF811;
const TAG = 'AppPage';

export default {
  onPrepare() {
    hilog.info(DOMAIN, TAG, 'OpenHarmonyTestRunner OnPrepare');
  },
  onRun() {
    hilog.info(DOMAIN, TAG, 'OpenHarmonyTestRunner onRun run');
    let abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments();
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
    let testAbilityName = `${abilityDelegatorArguments.parameters['-p']}.TestAbility`;
    let cmd = `aa start -d 0 -a ${testAbilityName} -b ${abilityDelegatorArguments.bundleName}`;
    let debug = abilityDelegatorArguments.parameters['-D'];
    if (debug === 'true') {
      cmd += ' -D';
    }
    hilog.info(DOMAIN, TAG, `cmd is ${cmd}`);
    abilityDelegator.executeShellCommand(cmd, (err) => {
      hilog.info(DOMAIN, TAG, `err is ${JSON.stringify(err)}`);
    })
  }
};