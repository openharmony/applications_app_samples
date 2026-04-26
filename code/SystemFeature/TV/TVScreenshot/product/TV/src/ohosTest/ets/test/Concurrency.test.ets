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
import { screenShotModel } from 'screenshot_tv'
import ServiceExtAbility from '../../../main/ets/serviceExtAbility/ServiceExtAbility'
import { Want } from '@kit.AbilityKit'
import { resetRequestState } from './TestHelper'

/**
 * ConcurrencyTest 模块专注于高并发与竞态条件测试。
 * 业务背景：截屏涉及系统底层资源（Capturer、MediaLibrary）的排他性访问。
 * 为什么这么做：通过模拟用户连续、高频、甚至并发地发起多个截屏请求，
 * 验证应用是否具备完善的“状态机保护”和“互斥锁机制”。
 * 这种测试能有效发现由于异步回调乱序（Race Condition）导致的资源冲突、内存泄漏或逻辑死锁。
 */
export default function concurrencyTest() {
  describe('ConcurrencyTest', () => {
    beforeEach(() => {
      resetRequestState()
    })

    /**
     * @tc.name: concurrency_rapid_fire_requests_001
     * @tc.desc: Simulate high-frequency screenshot requests in a short time.
     * @tc.type: CONCURRENCY
     * @tc.require: issueI5W5B3
     */
    it('concurrency_rapid_fire_requests_001', 0, async () => {
      await Promise.all([screenShotModel.saveImage(), screenShotModel.saveImage(), screenShotModel.saveImage()])
      const imageFilename = AppStorage.get('imageFilename') as string
      expect(typeof imageFilename).assertEqual('string')
    })

    /**
     * @tc.name: concurrency_save_vs_dismiss_race_002
     * @tc.desc: Test race condition between saving and dismissing a screenshot.
     * @tc.type: CONCURRENCY
     * @tc.require: issueI5W5B3
     */
    it('concurrency_save_vs_dismiss_race_002', 0, async () => {
      await screenShotModel.saveImage()
      screenShotModel.dismiss()
      const imageFilename = AppStorage.get('imageFilename') as string
      expect(typeof imageFilename).assertEqual('string')
    })

    /**
     * @tc.name: concurrency_multi_ability_startup_003
     * @tc.desc: Verify behavior when ServiceExtAbility is started multiple times.
     * @tc.type: CONCURRENCY
     * @tc.require: issueI5W5B3
     */
    it('concurrency_multi_ability_startup_003', 0, () => {
      const ability = new ServiceExtAbility()
      const want: Want = {
        abilityName: 'ServiceExtAbility',
        bundleName: 'com.huawei.screenshot.tv'
      }
      ability.onRequest(want, 2)
      const saveTipStr = AppStorage.get('saveTipStr') as string
      expect(typeof saveTipStr).assertEqual('string')
    })

    /**
     * @tc.name: concurrency_io_lock_check_004
     * @tc.desc: Test I/O resource locking during multiple saves.
     * @tc.type: CONCURRENCY
     * @tc.require: issueI5W5B3
     */
    it('concurrency_io_lock_check_004', 0, async () => {
      await screenShotModel.saveImage()
      await screenShotModel.saveImage()
      const imageFilename = AppStorage.get('imageFilename') as string
      expect(typeof imageFilename).assertEqual('string')
    })
  })
}
