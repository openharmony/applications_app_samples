/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { common, InsightIntentExecutor, UIAbility, Want } from '@kit.AbilityKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

const DOMAIN = 0x0003;
// 获取当前Ability上下文
const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;

let want: Want = {
  bundleName: 'com.samples.insightintentuiability', // 如com.example.targetapp
  abilityName: 'MusicPlayerAbility', // 如MainAbility
  parameters: {
    intentName: 'PlayMusic', // 关键：指定意图名称，系统匹配执行器
    executeMode: 'foreground', // 匹配前台模式
    songId: 'test_song_001'
  }
};

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    it('insightintentuiability_StartAbility_001', 0, async (done: Function) => {
      try {
        let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
        await abilityDelegatorRegistry.startAbility(want);
        await sleep(1000);
        done();
      } catch (error) {
        hilog.error(DOMAIN, 'testTag', 'error：', error);
        expect(0).assertEqual(1);
        done();
      }
    })
  })
}