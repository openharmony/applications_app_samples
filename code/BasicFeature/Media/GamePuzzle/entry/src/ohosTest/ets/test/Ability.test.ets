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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import missionManager from '@ohos.app.ability.missionManager';
import emitter from '@ohos.events.emitter';

const DRIVER = Driver.create();
const BUNDLE = 'gamePuzzle';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起应用
     */
    it(`${BUNDLE}_StartAbility_001`, 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0xF811, 'testTag', 'StartAbility_001 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.gamepuzzle',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0xF811, 'testTag', 'StartAbility_001 end');
    })

    /**
     * 授权
     */
    it(`${BUNDLE}_GetPermission_001`, 0, async (done) => {
      hilog.info(0xF811, 'testTag', 'GetPermission_001 begin');
      await DRIVER.delayMs(2000);
      let ability = abilityDelegatorRegistry.getAppContext();
      let manager = ability.resourceManager;
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.allow'))));
      let allowBtn = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.allow'))));
      await allowBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.allow'))));
      let allowBtnSecond = await DRIVER.findComponent(ON.text(await manager.getStringValue($r('app.string.allow'))));
      await allowBtnSecond.click();
      await DRIVER.delayMs(1000);
      done();
      hilog.info(0xF811, 'testTag', 'GetPermission_001 end');
    })

    /**
     * 决定是否调用相机拍照
     */
    it(`${BUNDLE}_IsTakePhoto_001`, 0, async (done) => {
      hilog.info(0xF811, 'testTag', 'IsTakePhoto_001 begin');
      let context = abilityDelegatorRegistry.getAppContext();
      let manager = mediaLibrary.getMediaLibrary(context);
      let albums = await manager.getFileAssets({
        selections: mediaLibrary.FileKey.MEDIA_TYPE + '= ?',
        selectionArgs: [mediaLibrary.MediaType.IMAGE.toString()]
      });
      // 小于两张，就拍照
      if (albums.getCount() < 2) {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'com.ohos.camera',
          abilityName: 'com.ohos.camera.MainAbility'
        });
        await DRIVER.delayMs(4000);
        await DRIVER.click(360, 1090);
        await DRIVER.delayMs(4000);
        await DRIVER.click(360, 1090);
        // 拍照结束后，重启应用
        let missions = await missionManager.getMissionInfos('', 20);
        let app = missions.filter(item => item.want.bundleName === 'ohos.samples.gamepuzzle');
        await missionManager.clearMission(app[0].missionId);
        await DRIVER.delayMs(1000);
      }
      done();
      hilog.info(0xF811, 'testTag', 'IsTakePhoto_001 end');
    })

    /**
     * 重新吊起应用
     */
    it(`${BUNDLE}_StartAbility_002`, 0, async (done) => {
      hilog.info(0xF811, 'testTag', 'StartAbility_002 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.gamepuzzle',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0xF811, 'testTag', 'StartAbility_002 end');
    })

    /**
     * 检查页面元素
     */
    it('CheckIndexPage_001', 0, async () => {
      hilog.info(0xF811, 'testTag', 'CheckIndexPage_001 begin');
      await DRIVER.delayMs(2000);
      await DRIVER.assertComponentExist(ON.id('time'));
      await DRIVER.assertComponentExist(ON.id('imageShow'));
      await DRIVER.assertComponentExist(ON.id('imageGrid'));
      await DRIVER.assertComponentExist(ON.id('start'));
      await DRIVER.assertComponentExist(ON.id('restart'));
      hilog.info(0xF811, 'testTag', 'CheckIndexPage_001 end');
    })

    /**
     * 开始游戏
     */
    it('StartGame_001', 0, async () => {
      hilog.info(0xF811, 'testTag', 'StartGame_001 begin');
      let startBtn = await DRIVER.findComponent(ON.id('start'));
      await startBtn.click();
      await DRIVER.delayMs(1000);
      let time = await DRIVER.findComponent(ON.id('time'));
      expect((await time.getText()).split(':')[1]).assertEqual('04');
      hilog.info(0xF811, 'testTag', 'StartGame_001 end');
    })

    /**
     * 更换图片后游戏停止
     */
    it('ChangePhoto_001', 0, async () => {
      hilog.info(0xF811, 'testTag', 'ChangePhoto_001 begin');
      let imageShow = await DRIVER.findComponent(ON.id('imageShow'));
      await imageShow.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('radio1_1'));
      await DRIVER.assertComponentExist(ON.id('radio1_2'));
      let radioBtn = await DRIVER.findComponent(ON.id('radio1_2'));
      await radioBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('radio2_2'));
      await DRIVER.assertComponentExist(ON.id('confirm'));
      let confirmBtn = await DRIVER.findComponent(ON.id('confirm'));
      await confirmBtn.click();
      await DRIVER.delayMs(1000);
      let time = await DRIVER.findComponent(ON.id('time'));
      expect((await time.getText()).split(':')[1]).assertEqual('05');
      hilog.info(0xF811, 'testTag', 'ChangePhoto_001 end');
    })

    /**
     * 开始游戏
     */
    it('StartGame_002', 0, async () => {
      hilog.info(0xF811, 'testTag', 'StartGame_002 begin');
      let startBtn = await DRIVER.findComponent(ON.id('start'));
      await startBtn.click();
      await DRIVER.delayMs(1000);
      let time = await DRIVER.findComponent(ON.id('time'));
      expect((await time.getText()).split(':')[1]).assertEqual('04');
      hilog.info(0xF811, 'testTag', 'StartGame_002 end');
    })

    /**
     * 跨ability分享数据，直接模拟出完成游戏后的数据，然后计算结果
     */
    it('GameOver_001', 0, async () => {
      hilog.info(0xF811, 'testTag', 'GameOver_001 begin');
      // 发送emitter，通知组件修改数据至完成状态，检测页面是否结束游戏
      emitter.emit({
        eventId: 0,
        priority: 0
      });
      await DRIVER.delayMs(1000);
      let ability = abilityDelegatorRegistry.getAppContext();
      let manager = ability.resourceManager;
      await DRIVER.assertComponentExist(ON.text(await manager.getStringValue($r('app.string.congratulations'))));
      await DRIVER.click(100, 100);
      let time = await DRIVER.findComponent(ON.id('time'));
      expect((await time.getText()).split(':')[1]).assertEqual('05');
      hilog.info(0xF811, 'testTag', 'GameOver_001 end');
    })

    /**
     * 开始游戏
     */
    it('StartGame_003', 0, async () => {
      hilog.info(0xF811, 'testTag', 'StartGame_003 begin');
      await DRIVER.delayMs(5000);
      let startBtn = await DRIVER.findComponent(ON.id('start'));
      await startBtn.click();
      await DRIVER.delayMs(1000);
      let time = await DRIVER.findComponent(ON.id('time'));
      expect((await time.getText()).split(':')[1]).assertEqual('04');
      hilog.info(0xF811, 'testTag', 'StartGame_003 end');
    })

    /**
     * 跨ability通信，修改剩余时间，让游戏失败
     */
    it('GameFailed_003', 0, async () => {
      hilog.info(0xF811, 'testTag', 'GameFailed_003 begin');
      emitter.emit({
        eventId: 1, priority: 0
      });
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text('TimeOver'));
      hilog.info(0xF811, 'testTag', 'GameFailed_003 end');
    })
  })
}