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

import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Hypium } from '@ohos/hypium';
import testsuite from '../test/List.test';

const DOMAIN = 0xF811;
const TAG = 'AppPage';

export default {
  onCreate() {
    hilog.info(DOMAIN, TAG, `TestApplication onCreate`);
    let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
    let abilityDelegatorArguments = AbilityDelegatorRegistry.getArguments()
    hilog.info(DOMAIN, TAG, `start run testcase!!!`);
    Hypium.hypiumTest(abilityDelegator, abilityDelegatorArguments, testsuite);
  },
  onDestroy() {
    hilog.info(DOMAIN, TAG, `TestApplication onDestroy`);
  }
};
