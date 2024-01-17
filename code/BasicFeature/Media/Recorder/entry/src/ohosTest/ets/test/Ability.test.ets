/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, expect, it } from '@ohos/hypium';
import { Component, Driver, MatchPattern, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { logger } from '../util/Logger';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';

const TAG = '[Sample_Recorder]';
const BUNDLE = 'Recorder_';
const RENAMED = 'renamed' + new Date().getTime();
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
let ability;

async function getAudioNum(): Promise<number> {
  logger.info(TAG, `${BUNDLE}getAudioAssets start`);
  let fileKeyObj = mediaLibrary.FileKey;
  let fetchOp = {
    selections: `${fileKeyObj.MEDIA_TYPE}=?`,
    selectionArgs: [`${mediaLibrary.MediaType.AUDIO}`],
  };
  let library = await mediaLibrary.getMediaLibrary(getContext());
  let fetchFileResult: mediaLibrary.FetchFileResult = undefined;
  try {
    fetchFileResult = await library.getFileAssets(fetchOp);
  } catch (err) {
    expect().assertFail();
    logger.info(TAG, `${BUNDLE}getAudioAssets failed, message = ${JSON.stringify(err)}`);
  }
  if (fetchFileResult != undefined && fetchFileResult.getCount() > 0) {
    return fetchFileResult.getCount();
  } else {
    return 0;
  }
}

function componentNullAble(arr: Component[]): Component[] {
  if (arr === null || arr === undefined) {
    arr = [];
  }
  return arr;
}

export default function abilityTest() {
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  let driver: Driver = Driver.create();
  describe('ActsAbilityTest', function () {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let want = {
        bundleName: "ohos.samples.recorder",
        abilityName: "EntryAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`)
      });
      ability = await abilityDelegatorRegistry.getCurrentTopAbility();
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
      await driver.assertComponentExist(ON.text('允许'));
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
      });
      logger.info(TAG, BUNDLE + 'RequestPermissionFunction_001 end');
      done();
    })

    /**
     * 录音功能，进入录音界面开始录音
     */
    it(BUNDLE + 'RecordePage_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RecordePage_001 begin');
      // 初始化用户数据管理模块实例
      let currentAudioNum = await getAudioNum();
      logger.info(TAG, BUNDLE + 'RecordePage_001 start Audio Num = ' + currentAudioNum);
      // 首页，非多选状态，点击录音按钮进入录音界面
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btnRecord'));
      let btnRecord = await driver.findComponent(ON.id('btnRecord'));
      await btnRecord.click();
      await driver.assertComponentExist(ON.id('pauseOrRecord'));
      logger.info(TAG, BUNDLE + 'RecordePage_001 end');
      done();
    })

    /**
     * 录音功能，录音界面，暂停继续录制功能
     */
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
      expect(durationStr0).assertEqual(durationStr1);

      // 录音界面 继续录音功能
      await pauseOrRecord.click();
      await driver.delayMs(2000);
      let durationStr2 = await duration.getText();
      expect(durationStr1 === durationStr2).assertFalse();
      logger.info(TAG, BUNDLE + 'RecordePage_002 end');
      done();
    })

    /**
     * 录音功能，录音界面，停止录音功能
     */
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

    /**
     * 首页，已有录音，播放功能测试
     */
    it(BUNDLE + 'Play_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'Play_001 begin');
      // 如果有录音文件，点击第一个开始播放
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      audios = componentNullAble(audios);
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
        expect(durationStr0).assertEqual(durationStr1);
        await pauseOrPlay.click();
        await driver.delayMs(1000);
        let durationStr2 = await playTime.getText();
        expect(durationStr0 === durationStr2).assertFalse();
        await driver.pressBack();
      }
      logger.info(TAG, BUNDLE + 'Play_001 end');
      done();
    })

    /**
     * 录制多条音频
     */
    it(BUNDLE + 'RE_Recorde_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RE_Recorde_001 begin');
      let sAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      sAudios = componentNullAble(sAudios);
      let num = 3;
      let sAudioNum: number = await getAudioNum();
      logger.info(TAG, BUNDLE + 'RE_Recorde_001 start Audio Num = ' + sAudioNum);
      while (num > 0) {
        // 首页，非多选状态，点击录音按钮进入录音界面
        await driver.assertComponentExist(ON.id('btnRecord'));
        let btnRecord = await driver.findComponent(ON.id('btnRecord'));
        await btnRecord.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('finishRecord'));
        let finishRecord = await driver.findComponent(ON.id('finishRecord'));
        await finishRecord.click();
        await driver.delayMs(500);
        num--;
      }
      let eAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      eAudios = componentNullAble(eAudios);
      expect(sAudios.length + 3).assertEqual(eAudios.length);
      let eAudioNum: number = await getAudioNum();
      logger.info(TAG, BUNDLE + 'RE_Recorde_001 end Audio Num = ' + eAudioNum);
      expect(sAudioNum + 3).assertEqual(eAudioNum);
      logger.info(TAG, BUNDLE + 'RE_Recorde_001 end');
      done();
    })

    /**
     * 连续删除->数量0
     */
    it(BUNDLE + 'Del_Recorde_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'Del_Recorde_001 begin');
      await driver.delayMs(1000);
      let sAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      sAudios = componentNullAble(sAudios);
      logger.info(TAG, BUNDLE + 'sAudios.length = ' + sAudios.length);
      let totalNum = sAudios.length;
      let num = 0;
      while (num < totalNum) {
        logger.info(TAG, BUNDLE + 'num = ' + num + ' ,totalNum = ' + totalNum);
        await driver.delayMs(1000);
        // 坐标基于设备RK3568
        await driver.swipe(500, 230, 367, 230, 600);
        await driver.delayMs(2000);
        // 坐标基于设备RK3568
        await driver.click(670, 240);
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.type("AlertDialog"));
        let resourceManager = ability.context.resourceManager;
        let confirm = await resourceManager.getStringValue($r('app.string.dilog_confirm'));
        let btnInDailog = await driver.findComponent(ON.text(confirm, MatchPattern.CONTAINS));
        await btnInDailog.click();
        await driver.delayMs(1000);
        num++;
      }
      let eAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(eAudios).assertNull();
      let eAudioNum: Number = await getAudioNum();
      logger.info(TAG, BUNDLE + 'Del_Recorde_001 end Audio Num = ' + eAudioNum);
      expect(eAudioNum).assertEqual(0);
      logger.info(TAG, BUNDLE + 'Del_Recorde_001 end');
      done();
    })

    /**
     * 录制多条音频
     */
    it(BUNDLE + 'RE_Recorde_002', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RE_Recorde_001 begin');
      let num = 0;
      while (num < 3) {
        // 首页，非多选状态，点击录音按钮进入录音界面
        await driver.assertComponentExist(ON.id('btnRecord'));
        let btnRecord = await driver.findComponent(ON.id('btnRecord'));
        await btnRecord.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('finishRecord'));
        let finishRecord = await driver.findComponent(ON.id('finishRecord'));
        await finishRecord.click();
        await driver.delayMs(500);
        num++;
      }
      let eAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      eAudios = componentNullAble(eAudios);
      expect(eAudios.length).assertEqual(num);
      let eAudioNum: Number = await getAudioNum();
      logger.info(TAG, BUNDLE + 'RE_Recorde_002 end Audio Num = ' + eAudioNum);
      expect(eAudioNum).assertEqual(num);
      logger.info(TAG, BUNDLE + 'RE_Recorde_002 end');
      done();
    })

    /**
     * 首页，已有录音，左滑重命名
     */
    it(BUNDLE + 'SlideAudioItem_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'SlideAudioItem_001 begin');
      // 如果有录音文件，左滑第一个文件
      await driver.delayMs(1000);
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      audios = componentNullAble(audios);
      if (audios.length > 0) {
        // 坐标基于设备RK3568
        await driver.swipe(500, 248, 367, 248, 500);
        await driver.delayMs(1000);
        await audios[0].click();
        // 重命名
        await driver.delayMs(1000);
        await audios[0].longClick();
        await driver.delayMs(1000);
        await audios[0].click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('checkedRename'));
        let checkedRename = await driver.findComponent(ON.id('checkedRename'));
        await driver.delayMs(1000);
        await checkedRename.click();
        await driver.assertComponentExist(ON.type('TextInput'));
        let renameInput = await driver.findComponent(ON.type('TextInput'));
        await renameInput.inputText(RENAMED);
        await driver.assertComponentExist(ON.text('确定', MatchPattern.CONTAINS));
        let sure = await driver.findComponent(ON.text('确定', MatchPattern.CONTAINS));
        await sure.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text('renamed', MatchPattern.CONTAINS));
      }
      logger.info(TAG, BUNDLE + 'SlideAudioItem_001 end');
      done();
    })

    /**
     * 首页，重新录一条音频，并将其重命名为跟前面重命名文件同样名字
     */
    it(BUNDLE + 'RenameRepeat_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'RenameRepeat_001 begin');
      await driver.delayMs(1000);
      // 录制前的音频文件数量
      let sAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      sAudios = componentNullAble(sAudios);
      // 重新录一条音频
      await driver.assertComponentExist(ON.id('btnRecord'));
      let btnRecord = await driver.findComponent(ON.id('btnRecord'));
      await btnRecord.click();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.id('finishRecord'));
      let finishRecord = await driver.findComponent(ON.id('finishRecord'));
      await finishRecord.click();
      await driver.delayMs(500);
      // 录制后的音频文件数量
      let eAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      eAudios = componentNullAble(eAudios);
      expect(sAudios.length + 1).assertEqual(eAudios.length);
      // 如果有至少2个录音文件
      if (eAudios.length >= 2) {

        // 坐标基于设备RK3568，左滑第二个文件，点击一下退出左滑状态
        await driver.swipe(500, 400, 367, 400, 500);
        await driver.delayMs(1000);
        await eAudios[1].click();
        // 长按，勾选，并重命名第二个文件
        await driver.delayMs(1000);
        await eAudios[1].longClick();
        await driver.delayMs(1000);
        await eAudios[1].click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('checkedRename'));
        let checkedRename = await driver.findComponent(ON.id('checkedRename'));
        await driver.delayMs(1000);
        await checkedRename.click();
        await driver.assertComponentExist(ON.type('TextInput'));
        let renameInput = await driver.findComponent(ON.type('TextInput'));

        await renameInput.inputText(RENAMED);
        await driver.assertComponentExist(ON.text('确定', MatchPattern.CONTAINS));
        let sure = await driver.findComponent(ON.text('确定', MatchPattern.CONTAINS));
        await sure.click();
        // 同样名称RENAMED的音频文件应该只有一个
        await driver.assertComponentExist(ON.text(RENAMED));
        let renameAudios: Component[] = await driver.findComponents(ON.text(RENAMED));
        renameAudios = componentNullAble(renameAudios);
        expect(renameAudios.length).assertEqual(1);
      }
      logger.info(TAG, BUNDLE + 'RenameRepeat_001 end');
      done();
    })

    /**
     * 首页，已有录音，多选状态和退出多选状态
     */
    it(BUNDLE + 'CheckState_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'CheckState_001 begin');
      // 如果有录音文件，长按第一个文件
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      audios = componentNullAble(audios);
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
        expect(checkedNum).assertEqual('1');
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

    /**
     * 长按删除一条录音文件
     */
    it(BUNDLE + 'DeleteRecord_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'DeleteRecord_001 begin');
      await driver.delayMs(1000);
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      audios = componentNullAble(audios);
      if (audios.length > 0) {
        await audios[1].longClick();
        await driver.delayMs(1000);
        await audios[1].click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('checkedDelete'));
        let checkedDelete = await driver.findComponent(ON.id('checkedDelete'));
        await checkedDelete.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.type("AlertDialog"));
        let resourceManager = ability.context.resourceManager;
        let confirm = await resourceManager.getStringValue($r('app.string.dilog_confirm'));
        let btnInDailog = await driver.findComponent(ON.text(confirm, MatchPattern.CONTAINS));
        await btnInDailog.click();
        await driver.delayMs(1000);
      }
      logger.info(TAG, BUNDLE + 'DeleteRecord_001 end');
      done();
    })

    /**
     * 首页，全部删除
     */
    it(BUNDLE + 'Del_All_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'Del_All_001 begin');
      // 如果有录音文件，长按第一个文件
      let audios: Component[] = await driver.findComponents(ON.type('ListItem'));
      audios = componentNullAble(audios);
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
        // 点击选择所有音频
        for (let item of audios) {
          await item.click();
          await driver.delayMs(500);
        }
        await checkedDelete.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.type("AlertDialog"));
        let resourceManager = ability.context.resourceManager;
        let confirm = await resourceManager.getStringValue($r('app.string.dilog_confirm'));
        let btnInDailog = await driver.findComponent(ON.text(confirm, MatchPattern.CONTAINS));
        await btnInDailog.click();
        await driver.delayMs(1000);
      }
      let eAudios: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(eAudios).assertNull();
      let eAudioNum: Number = await getAudioNum();
      logger.info(TAG, BUNDLE + 'CheckState_001 end Audio Num = ' + eAudioNum);
      expect(eAudioNum).assertEqual(0);
      logger.info(TAG, BUNDLE + 'CheckState_001 end');
      done();
    })
  })
}