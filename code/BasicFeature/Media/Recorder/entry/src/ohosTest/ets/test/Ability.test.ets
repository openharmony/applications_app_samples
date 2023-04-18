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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { logger } from '../util/Logger';

const TAG = '[Sample_Recorder]';
const BUNDLE = 'Recorder_';

export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver = Driver.create();
  describe('AbilityTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
      let want = {
        bundleName: "ohos.samples.recorder",
        abilityName: "EntryAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      })
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    /**
     * 获取权限，并判断是否正常进入主页
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      await driver.delayMs(1000);
      // 获取权限
      logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 requestPermission');
      await driver.assertComponentExist(ON.text('允许'))
      let btnStart = await driver.findComponent(ON.text('允许'));
      await btnStart.click();
      let i = 0;
      while (i < 3) {
        btnStart = await driver.findComponent(ON.text('允许'));
        if (btnStart != null) {
          await btnStart.click();
        }
        i++;
      }
      await delegator.getCurrentTopAbility().then((Ability) => {
        logger.info(TAG, `${BUNDLE}get top ability`);
        expect(Ability.context.abilityInfo.name).assertEqual('EntryAbility');
      })
      logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 end');
      done();
    })

    // 录音功能，进入录音界面开始录音
    it(BUNDLE + 'RecordePage_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RecordePage_001 begin');
      // 首页，非多选状态，点击录音按钮进入录音界面
      await driver.assertComponentExist(ON.id('btnRecord'));
      let btnRecord = await driver.findComponent(ON.id('btnRecord'));
      await btnRecord.click();
      await driver.assertComponentExist(ON.id('pauseOrRecord'));
      logger.info(TAG, BUNDLE + 'RecordePage_001 end');
      done();
    })

    // 录音功能,录音界面，暂停继续录制功能
    it(BUNDLE + 'RecordePage_002', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RecordePage_002 begin');
      // 录音界面 暂停录音功能
      await driver.delayMs(2000);
      let pauseOrRecord = await driver.findComponent(ON.id('pauseOrRecord'));
      await pauseOrRecord.click();
      await driver.assertComponentExist(ON.id('recordDuration'));
      let duration = await driver.findComponent(ON.id('recordDuration'));
      let durationStr0 = await duration.getText();
      await driver.delayMs(1000);
      let durationStr1 = await duration.getText();
      expect(durationStr0 === durationStr1).assertTrue();

      // 录音界面 继续录音功能
      await pauseOrRecord.click();
      await driver.delayMs(2000);
      let durationStr2 = await duration.getText();
      expect(durationStr1 === durationStr2).assertFalse();
      logger.info(TAG, BUNDLE + 'RecordePage_002 end');
      done();
    })

    // 录音功能,录音界面，停止录音功能
    it(BUNDLE + 'RecordePage_003', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RecordePage_003 begin');
      // 录音界面 停止录音
      await driver.assertComponentExist(ON.id('titleContent'));
      let title = await driver.findComponent(ON.id('titleContent'));
      await driver.assertComponentExist(ON.id('finishRecord'));
      let titleContent = await title.getText();
      let finishRecord = await driver.findComponent(ON.id('finishRecord'));
      await finishRecord.click();
      await driver.delayMs(200);
      let list = await driver.findComponent(ON.type('List'));
      await list.scrollSearch(ON.text(titleContent, MatchPattern.CONTAINS));
      await list.scrollToTop(500);
      await driver.delayMs(200);
      logger.info(TAG, BUNDLE + 'RecordePage_003 end');
      done();
    })


    // 首页，已有录音，播放功能测试
    it(BUNDLE + 'Play_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'Play_001 begin');
      // 如果有录音文件，点击第一个开始播放
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      if (audios.length > 0) {
        await audios[0].click();
        await driver.assertComponentExist(ON.id('pauseOrPlay'));
        let pauseOrPlay = await driver.findComponent(ON.id('pauseOrPlay'));
        await pauseOrPlay.click();
        await driver.assertComponentExist(ON.id('playTime'));
        let playTime = await driver.findComponent(ON.id('playTime'));
        let durationStr0 = await playTime.getText();
        await driver.delayMs(1000);
        let durationStr1 = await playTime.getText();
        expect(durationStr0 === durationStr1).assertTrue();
        await pauseOrPlay.click();
        await driver.delayMs(1000);
        let durationStr2 = await playTime.getText();
        expect(durationStr0 === durationStr2).assertFalse();
        await driver.pressBack();
      }
      logger.info(TAG, BUNDLE + 'Play_001 end');
      done();
    })

    // 首页，已有录音，左滑重命名和删除功能
    it(BUNDLE + 'SlideAudioItem_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'SlideAudioItem_001 begin');
      // 如果有录音文件，左滑第一个文件
      await driver.delayMs(1000);
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      if (audios.length > 0) {
        // 重命名
        let point = await audios[0].getBoundsCenter();
        await driver.swipe(point.x, point.y, point.x - 100, point.y);
        await driver.delayMs(1000);
        let rect = await audios[0].getBounds();
        await driver.click(rect.right + 110, rect.bottom - 60)
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.type('TextInput'));
        let renameInput = await driver.findComponent(ON.type('TextInput'));
        await renameInput.inputText('recorderRenamed');
        await driver.assertComponentExist(ON.text('确定', MatchPattern.CONTAINS));
        let sure = await driver.findComponent(ON.text('确定', MatchPattern.CONTAINS));
        await sure.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text('recorderRenamed', MatchPattern.CONTAINS));

        // 删除
        await driver.delayMs(500);
        await driver.swipe(point.x, point.y, point.x - 100, point.y);
        await driver.delayMs(1000);
        await driver.click(rect.right + 190, rect.bottom - 60);
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.type("AlertDialog"));
        // 无法获取到系统弹窗的确定按钮，当前只能先用坐标，此处使用的是rk设备弹窗中的坐标
        await driver.click(210, 658)
        await driver.delayMs(1000);
        let recorder = await driver.findComponent(ON.text('recorderRenamed', MatchPattern.CONTAINS));
        expect(recorder).assertNull();
      }
      logger.info(TAG, BUNDLE + 'SlideAudioItem_001 end');
      done();
    })

    // 因为上面的用例有删除音频，在测试多选前，需要再录制一条音频，确保可以进入多选状态
    it(BUNDLE + 'Recorde_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RecordePage_001 begin');
      // 首页，非多选状态，点击录音按钮进入录音界面
      await driver.assertComponentExist(ON.id('btnRecord'));
      let btnRecord = await driver.findComponent(ON.id('btnRecord'));
      await btnRecord.click();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.id('finishRecord'));
      let finishRecord = await driver.findComponent(ON.id('finishRecord'));
      await finishRecord.click();
      await driver.delayMs(500);
      logger.info(TAG, BUNDLE + 'Recorde_001 end');
      done();
    })

    // 首页，已有录音，多选状态和推出多选状态
    it(BUNDLE + 'CheckState_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'CheckState_001 begin');
      // 如果有录音文件，左滑第一个文件
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      if (audios.length > 0) {
        // 进入多选
        await audios[0].longClick();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('closeCheck'));
        await driver.assertComponentExist(ON.id('checkedRename'));
        await driver.assertComponentExist(ON.id('checkedDelete'));

        let checkedRename = await driver.findComponent(ON.id('checkedRename'));
        let checkedDelete = await driver.findComponent(ON.id('checkedDelete'));
        expect(await checkedRename.isEnabled()).assertFalse();
        expect(await checkedDelete.isEnabled()).assertFalse();
        // 点击选择一个音频
        await audios[0].click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('checkedNum'));
        let checked = await driver.findComponent(ON.id('checkedNum'));
        let checkedNum = await checked.getText();
        expect(checkedNum === '1').assertTrue();
        expect(await checkedRename.isEnabled()).assertTrue();
        expect(await checkedDelete.isEnabled()).assertTrue();

        // 退出多选状态
        let closeCheck = await driver.findComponent(ON.id('closeCheck'));
        await closeCheck.click();
        await driver.assertComponentExist(ON.id('btnRecord'));
      }
      done();
      logger.info(TAG, BUNDLE + 'CheckState_001 end');
    })
  })
}