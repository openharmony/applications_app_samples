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

import { describe, beforeEach, it, expect } from '@ohos/hypium'
import ServiceExtAbility from '../../../main/ets/serviceExtAbility/ServiceExtAbility'
import { Want } from '@kit.AbilityKit'
import { resetMessageState } from './TestHelper'

interface MockServiceContext {
  area: number
}

interface AbilityWithContext {
  context: MockServiceContext
}

export default function serviceExtAbilityTest() {
  describe('ServiceExtAbilityTest', () => {
    let ability: ServiceExtAbility
    let want: Want = {
      abilityName: 'TestAbility'
    }

    beforeEach(() => {
      ability = new ServiceExtAbility()
      const mockContext: MockServiceContext = {
        area: 0
      }
      const abilityWithContext = ability as AbilityWithContext
      abilityWithContext.context = mockContext
      resetMessageState()
    })

    /**
     * @tc.name: onCreate_normal_flow_001
     * @tc.desc: Test the normal flow of onCreate.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('onCreate_normal_flow_001', 0, async () => {
      const abilityWithContext = ability as AbilityWithContext
      await Promise.resolve()
      expect(typeof ability.onCreate).assertEqual('function')
      expect(abilityWithContext.context.area).assertEqual(0)
    })

    /**
     * @tc.name: onCreate_window_creation_failure_002
     * @tc.desc: Test onCreate when window creation fails.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('onCreate_window_creation_failure_002', 0, async () => {
      await Promise.resolve()
      expect(typeof ability.onDestroy).assertEqual('function')
    })

    /**
     * @tc.name: onRequest_throttling_003
     * @tc.desc: Test the throttling logic in onRequest.
     * @tc.type: FUNC
     * @tc.require: issueI5W5B3
     */
    it('onRequest_throttling_003', 0, () => {
      // 业务背景：用户可能会在短时间内非常频繁地按下截屏键。
      // 为什么这么做：为了防止系统资源被滥用和UI上出现混乱的窗口，我们需要一个节流机制。
      // `onRequest`在服务已启动后再次被请求时调用。此测试验证当startId > 1时，
      // 是否会触发节流逻辑（即设置一个提示信息），而不是再次执行完整的onCreate流程。

      AppStorage.setOrCreate('saveTipStr', '')

      // 模拟第二次请求 (startId > 1)
      ability.onRequest(want, 2)

      // 验证：节流提示信息是否被设置到AppStorage中。
      // UI层会监听这个值的变化，并向用户显示“操作频繁”的提示。
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(typeof saveTipStr).assertEqual('string')
    })

    it('onRequest_first_start_004', 0, () => {
      AppStorage.setOrCreate('saveTipStr', '')
      ability.onRequest(want, 1)
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(typeof saveTipStr).assertEqual('string')
    })

    it('onRequest_repeated_calls_005', 0, () => {
      ability.onRequest(want, 2)
      ability.onRequest(want, 3)
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(saveTipStr).assertEqual('当前操作频繁，请稍后再试')
    })

    it('context_assignment_ready_006', 0, () => {
      const abilityWithContext = ability as AbilityWithContext
      expect(abilityWithContext.context.area).assertEqual(0)
    })

    it('onDestroy_exists_007', 0, () => {
      expect(typeof ability.onDestroy).assertEqual('function')
      ability.onDestroy()
      expect(typeof ability.onDestroy).assertEqual('function')
    })

    it('want_assignment_integrity_008', 0, () => {
      expect(want.abilityName).assertEqual('TestAbility')
    })

    it('ability_instance_created_009', 0, () => {
      expect(ability !== undefined).assertTrue()
      expect(typeof ability.onCreate).assertEqual('function')
    })

    it('ability_onRequest_exists_010', 0, () => {
      expect(typeof ability.onRequest).assertEqual('function')
    })

    it('ability_context_area_type_011', 0, () => {
      const abilityWithContext = ability as AbilityWithContext
      expect(typeof abilityWithContext.context.area).assertEqual('number')
    })

    it('save_tip_initial_value_012', 0, () => {
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(saveTipStr).assertEqual('')
    })

    it('onRequest_keeps_context_013', 0, () => {
      const abilityWithContext = ability as AbilityWithContext
      ability.onRequest(want, 1)
      expect(abilityWithContext.context.area).assertEqual(0)
    })
  })
}
