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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@kit.TestKit';
import { abilityDelegatorRegistry } from '@kit.TestKit';

const DOMAIN = 0x0000;
const TAG = 'MovingPhotoViewTest';

export default function movingPhotoViewTest() {
  describe('MovingPhotoViewTest', () => {
    beforeAll(() => {
      hilog.info(DOMAIN, TAG, 'beforeAll called');
    });
    beforeEach(() => {
      hilog.info(DOMAIN, TAG, 'beforeEach called');
    });
    afterEach(() => {
      hilog.info(DOMAIN, TAG, 'afterEach called');
    });
    afterAll(() => {
      hilog.info(DOMAIN, TAG, 'afterAll called');
    });

    it('MovingPhotoViewAutoLoadTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'MovingPhotoViewAutoLoadTest_001 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(3000);
        await driver.assertComponentExist(ON.text('动态照片已加载，长按可播放'));
        hilog.info(DOMAIN, TAG, 'MovingPhoto loaded automatically');
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, 'MovingPhotoViewAutoLoadTest_001 test complete');
        done();
      }
    });

    it('MovingPhotoViewPlaybackTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'MovingPhotoViewPlaybackTest_002 begin');
      try {
        let driver: Driver = Driver.create();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('start'));
        let startButton = await driver.findComponent(ON.text('start'));
        await startButton.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.text('stop'));
        let stopButton = await driver.findComponent(ON.text('stop'));
        await stopButton.click();
        await driver.delayMs(1000);
      } catch (error) {
        hilog.error(DOMAIN, TAG, `Test failed: ${(error as Error).message}`);
        expect(false).assertFail();
      } finally {
        hilog.info(DOMAIN, TAG, 'MovingPhotoViewPlaybackTest_002 test complete');
        done();
      }
    });
  });
}