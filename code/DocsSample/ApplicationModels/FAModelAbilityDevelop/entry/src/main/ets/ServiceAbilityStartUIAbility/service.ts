/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import particleAbility from '@ohos.ability.particleAbility';
import type Want from '@ohos.app.ability.Want';
import type { BusinessError } from '@ohos.base';
import hilog from '@ohos.hilog';

const TAG: string = '[Sample_FAModelAbilityDevelop]';
const domain: number = 0xFF00;

class ServiceAbilityStartUiAbility {
  onStart(): void {
    let want: Want = {
      bundleName: 'ohos.samples.etsclock',
      abilityName: 'MainAbility'
    };
    particleAbility.startAbility({ want }).then(() => {
      hilog.info(domain, TAG, 'ServiceAbilityStartUIAbility Start Ability successfully.');
    }).catch((error: BusinessError) => {
      hilog.info(domain, TAG, 'ServiceAbilityStartUIAbility Ability failed: ' + JSON.stringify(error));
    });
    hilog.info(domain, TAG, 'ServiceAbilityStartUIAbility ServiceAbility onStart');
  }
};

export default new ServiceAbilityStartUiAbility();