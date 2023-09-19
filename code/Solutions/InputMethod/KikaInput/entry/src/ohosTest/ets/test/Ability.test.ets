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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import inputMethod from '@ohos.inputMethod';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import { describe, it, expect } from '@ohos/hypium';
import { logger } from '../util/Logger';

const TAG = '[Sample_UploadAndDownload]';
const BUNDLE = 'UploadAndDownload_';

// 此应用为预置输入法应用，这部分在code/Solutions/InputMethod/CustomInputText中已验证，不需要写测试用例
// 此处添加拉起测试demo的用例即可
export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();

  describe('ActsAbilityTest', () => {
    // 拉起测试demo界面
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`)
      await delegator.executeShellCommand('aa start -b com.example.kikakeyboard -a TestAbility').then(result => {
        logger.info(TAG, `${BUNDLE}start ability finished, result = ${JSON.stringify(result)}`);
      }).catch((err: Error) => {
        logger.info(TAG, `${BUNDLE}start ability failed, err = ${JSON.stringify(err)}`);
      })
      await delegator.getCurrentTopAbility().then((ability: UIAbility) => {
        logger.info(TAG, `${BUNDLE}get top ability`);
        expect(ability.context.abilityInfo.bundleName).assertEqual('com.example.kikakeyboard');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })
  })
}
