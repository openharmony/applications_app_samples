/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { sendableModuleTest } from '../../../main/ets/managers/arkts-sendable-module';
import { asyncConcurrencyTest } from '../../../main/ets/managers/async-concurrency-overview';
import { imagePreprocessing } from '../../../main/ets/managers/cpu-intensive-task';
import { ioTaskTest } from '../../../main/ets/managers/io-intensive-task';
import { singleIoTest } from '../../../main/ets/managers/single-io-development';
import { syncTaskTest } from '../../../main/ets/managers/sync-task-development';

const TAG = '[Sample_ArkTSUtils]';
const DOMAIN = 0xF811;
const BUNDLE = 'ArkTsUtils_';

export default function abilityTest() {
  describe('abilityTest', () => {
    /**
     * @tc.number    : ArkTS_UtilsTest_001
     * @tc.name      : Start ability
     * @tc.desc      : Start an application
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('ArkTS_UtilsTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.arktsutilsdocmodule",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_001 end');
    })

    /**
     * @tc.number    : ArkTS_UtilsTest_002
     * @tc.name      : Execute SendableTest
     * @tc.desc      : execute SendableTest
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('ArkTS_UtilsTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_002 begin');
      let str = await sendableModuleTest();
      expect(str).assertEqual("SendableModuleTest Succeed");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_002 end');
    })

    /**
     * @tc.number    : ArkTS_UtilsTest_003
     * @tc.name      : Execute AsyncConcurrencyTest
     * @tc.desc      : execute AsyncConcurrencyTest
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('ArkTS_UtilsTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_003 begin');
      let str = await asyncConcurrencyTest();
      expect(str).assertEqual("AsyncConcurrencyTest Succeed");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_003 end');
    })

    /**
     * @tc.number    : ArkTS_UtilsTest_004
     * @tc.name      : Execute imagePreprocessingTest
     * @tc.desc      : execute imagePreprocessingTest
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('ArkTS_UtilsTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_004 begin');
      let str = await imagePreprocessing();
      expect(str).assertEqual("imagePreprocessing success");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_004 end');
    })

    /**
     * @tc.number    : ArkTS_UtilsTest_005
     * @tc.name      : Execute IoTaskTest
     * @tc.desc      : execute IoTaskTest
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('ArkTS_UtilsTest_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_005 begin');
      let str = await ioTaskTest();
      expect(str).assertEqual("IoTaskTest Succeed");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_005 end');
    })

    /**
     * @tc.number    : ArkTS_UtilsTest_006
     * @tc.name      : Execute SingleIoTest
     * @tc.desc      : execute SingleIoTest
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('ArkTS_UtilsTest_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_006 begin');
      let str = await singleIoTest();
      expect(str).assertEqual("SingleIoTest Succeed");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_006 end');
    })

    /**
     * @tc.number    : ArkTS_UtilsTest_007
     * @tc.name      : Execute syncTaskTest
     * @tc.desc      : execute syncTaskTest
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('ArkTS_UtilsTest_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_007 begin');
      let str = await syncTaskTest();
      expect(str).assertEqual("syncTaskTest Succeed");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ArkTS_UtilsTest_007 end');
    })
  })
}