/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required ON applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

export default {
  onPrepare() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner OnPrepare');
  },
  onRun() {
    hilog.info(0x0000, 'testTag', '%{public}s', 'OpenHarmonyTestRunner onRun run');
    var abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    var abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()

    var testAbilityName = abilityDelegatorArguments.parameters['-p'] + '.TestAbility'
    var cmd = 'aa start -d 0 -a ' + testAbilityName + ' -b ' + abilityDelegatorArguments.bundleName
    var debug = abilityDelegatorArguments.parameters["-D"]
    if (debug == 'true') {
      cmd += ' -D'
    }
    hilog.info(0x0000, 'testTag', 'cmd : %{public}s', cmd);
    abilityDelegator.executeShellCommand(cmd, (err, data) => {
      hilog.info(0x0000, 'testTag', 'executeShellCommand : err : %{public}s', JSON.stringify(err) ?? '');
      hilog.info(0x0000, 'testTag', 'executeShellCommand : data : %{public}s', data.stdResult ?? '');
      hilog.info(0x0000, 'testTag', 'executeShellCommand : data : %{public}s', data.exitCode ?? '');
    })
  }
};