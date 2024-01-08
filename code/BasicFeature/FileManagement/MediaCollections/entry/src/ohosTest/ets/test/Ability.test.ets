/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import { describe, it, expect } from '@ohos/hypium'
import { Driver, ON } from '@ohos.UiTest'
import Logger from '../utils/Logger'

const BUNDLE = 'MediaCollectionTest_'
const TAG = '[Sample_MediaCollection_Test]'
let resourceManager = AbilityDelegatorRegistry.getAbilityDelegator().getAppContext().resourceManager;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起一个ability
     */
    it('MediaCollectionTest_startAbility_001', 0, async (done: () => void) => {
      Logger.info(TAG, 'StartAbility start')

      interface wantType {
        bundleName: string,
        abilityName: string
      }

      let driver = Driver.create()
      let want: wantType = {
        bundleName: 'com.example.sampledemo',
        abilityName: 'MainAbility'
      }
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await driver.delayMs(1000)
      abilityDelegator.startAbility(want, (err) => {
        expect(err).assertNull()
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
      })
      await driver.delayMs(1000)
      Logger.info(TAG, 'StartAbility end')
      done()
    })

    /**
     * 获取权限
     */
    it('MediaCollectionTest_getPermission_001', 1, async (done: () => void) => {
      Logger.info(TAG, 'getPermission_001 start')
      let driver = Driver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))))
      let agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))))
      await agree.click()
      await driver.delayMs(1000)
      agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))))
      expect(agree).assertNull()
      Logger.info(TAG, 'getPermission_001 end')
      done()
    })

    /**
     * 选择离线播放
     */
    it('MediaCollectionTest_selectOfflinePlay_001', 0, async (done: () => void) => {
      Logger.info(TAG, 'selectOfflinePlay_001 start')
      let driver = Driver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.homePage_offline'))))
      let agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.homePage_offline'))))
      await agree.click()
      await driver.delayMs(1000)
      agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.homePage_offline'))))
      expect(agree).assertNull()
      Logger.info(TAG, 'selectOfflinePlay_001 end')
      done()
    })

    /**
     * 检查界面是否正常显示
     */
    it('MediaCollectionTest_getPermission_002', 2, async (done: () => void) => {
      Logger.info(TAG, 'getPermission_002 start')
      let driver = Driver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('search'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('music'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('video'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('favorite'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('me'))
      await driver.delayMs(200)
      await driver.assertComponentExist(ON.id('search'))
      await driver.delayMs(1000)
      Logger.info(TAG, 'getPermission_002 end')
      done()
    })

    /**
     * 点击音频进行重命名操作
     */
    it(`MediaCollectionTest_audioRename_001`, 0, async (done: () => void) => {
      Logger.info(TAG, `${BUNDLE} audioRename_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('music'));
      let audio = await driver.findComponent(ON.id('music'));
      await audio.click();
      await driver.delayMs(1000);
      // 左滑音频，坐标基于rk3568
      await driver.swipe(665, 915, 220, 915);
      let rename = await driver.findComponent(ON.id('rename'));
      // 判断系统中有无音频文件，如果没有就结束，跳过重命名操作
      if (rename === null) {
        done();
      }
      // 点击重命名按钮
      await rename.click();
      await driver.delayMs(1000);
      // 判断重命名弹窗是否显示正常
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.phoneMain_audioTitle'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_cel'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      await driver.assertComponentExist(ON.id('inputNewName'));
      let renameInput = await driver.findComponent(ON.id('inputNewName'));
      // 输入新的音频名
      await renameInput.inputText('newAudioName');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('newAudioName'));
      let confirm = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      // 点击确定
      await confirm.click();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE} audioRename_001 end`);
    })

    /**
     * 点击音频进行删除操作
     */
    it('MediaCollectionTest_audioDelete_001', 0, async (done: () => void) => {
      Logger.info(TAG, `${BUNDLE} audioDelete_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 左滑音频，坐标基于rk3568
      await driver.swipe(665, 915, 220, 915);
      let delAudio = await driver.findComponent(ON.id('delete'));
      // 判断系统中有无音频文件，如果没有就结束，跳过删除操作
      if (delAudio === null) {
        done();
      }
      // 点击删除按钮
      await delAudio.click();
      await driver.delayMs(1000);
      // 判断删除弹窗是否显示正常
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_del_audio'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_cel'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      let confirm = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      // 点击确定
      await confirm.click();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE} audioDelete_001 end`);
    })

    /**
     * 点击视频进行重命名操作
     */
    it('MediaCollectionTest_videoRename_001', 0, async (done: () => void) => {
      Logger.info(TAG, `${BUNDLE} videoRename_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('video'));
      let video = await driver.findComponent(ON.id('video'));
      await video.click();
      await driver.delayMs(1000);
      // 左滑视频，坐标基于rk3568
      await driver.swipe(665, 915, 220, 915);
      let rename = await driver.findComponent(ON.id('rename'));
      // 判断系统中有无视频文件，如果没有就结束，跳过重命名操作
      if (rename === null) {
        done();
      }
      // 点击重命名按钮
      await rename.click();
      await driver.delayMs(1000);
      // 判断重命名弹窗是否显示正常
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.phoneMain_videoTitle'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_cel'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      await driver.assertComponentExist(ON.id('inputNewName'));
      let renameInput = await driver.findComponent(ON.id('inputNewName'));
      // 输入新的视频名
      await renameInput.inputText('newVideoName');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('newVideoName'));
      let confirm = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      // 点击确定
      await confirm.click();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE} videoRename_001 end`);
    })

    /**
     * 点击视频进行删除操作
     */
    it('MediaCollectionTest_videoDelete_001', 0, async (done: () => void) => {
      Logger.info(TAG, `${BUNDLE} videoDelete_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 左滑视频，坐标基于rk3568
      await driver.swipe(665, 915, 220, 915);
      let delAudio = await driver.findComponent(ON.id('delete'));
      // 判断系统中有无视频文件，如果没有就结束，跳过删除操作
      if (delAudio === null) {
        done();
      }
      // 点击删除按钮
      await delAudio.click();
      await driver.delayMs(1000);
      // 判断删除弹窗是否显示正常
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_del'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_cel'))));
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      let confirm = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.index_sure'))));
      // 点击确定
      await confirm.click();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE} videoDelete_001 end`);
    })

    /**
     * 返回首页选择drm在线播放
     */
    it('MediaCollectionTest_selectOnlinePlay_001', 0, async (done: () => void) => {
      Logger.info(TAG, 'selectOnlinePlay_001 start')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 返回
      await driver.assertComponentExist(ON.id('icon_back'));
      let iconBack = await driver.findComponent(ON.id('icon_back'));
      await iconBack.click();
      // drm在线播放
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.homePage_online'))))
      let agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.homePage_online'))))
      await agree.click()
      await driver.delayMs(1000)
      agree = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.homePage_online'))))
      expect(agree).assertNull()
      Logger.info(TAG, 'selectOnlinePlay_001 end')
      done()
    })

    /**
     * 播放列表中选择加密片进行播放
     */
    it('MediaCollectionTest_choosePlayerList_001', 0, async (done: () => void) => {
      Logger.info(TAG, 'choosePlayerList_001 start')
      let driver = Driver.create()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.id('firstLevelBar0'));
      let firstLevelBar0 = await driver.findComponent(ON.id('firstLevelBar0'));
      await firstLevelBar0.click();
      await driver.assertComponentExist(ON.id('secondLevelBar0'));
      let secondLevelBar0 = await driver.findComponent(ON.id('secondLevelBar0'));
      await secondLevelBar0.click();
      await driver.delayMs(10000)
      Logger.info(TAG, 'choosePlayerList_001 end')
      done()
    })
  })
}