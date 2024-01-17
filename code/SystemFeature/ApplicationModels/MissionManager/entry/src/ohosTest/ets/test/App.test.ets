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
import missionManager from '@ohos.app.ability.missionManager';
import { beforeAll, describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG = '[Sample_MissionManager]';
const BUNDLE = 'MissionManager_';

export default function appTest() {
  let driver = Driver.create();
  const delegator = AbilityDelegatorRegistry.getAbilityDelegator()

  // 资源本地化
  async function getResourceString(resource: Resource): Promise<string> {
    let manage = delegator.getAppContext().resourceManager
    let text = await manage.getStringValue(resource)
    return text
  }

  describe('appTest', function () {
    beforeAll(async function () {
      // 为避免任务列表太长影响自动化测试，在开始测试前，先clear掉除当前应用之外的任务
      let missions = await missionManager.getMissionInfos('', 20);
      missions.filter((item) => {
        if (item.want.bundleName !== 'ohos.samples.missionmanager') {
          missionManager.clearMission(item.missionId);
        }
      });
      await driver.delayMs(2000);
      // 为了任务列表不为空，需要先启动两个应用，保证任务列表>2
      let want = {
        bundleName: 'ohos.samples.etsclock',
        abilityName: 'MainAbility'
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      });
      await driver.delayMs(2000);
      await driver.pressHome();
      await driver.delayMs(1000);
      let want1 = {
        bundleName: 'com.ohos.note',
        abilityName: 'MainAbility'
      };
      delegator.startAbility(want1, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      });
      await driver.delayMs(2000);
      await driver.pressHome();
      await driver.delayMs(1000);
    })

    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}StartAbility_002 begin`);
      let want = {
        bundleName: "ohos.samples.missionmanager",
        abilityName: "MainAbility"
      };
      delegator.startAbility(want, (err) => {
        logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
      });
      await driver.delayMs(1000);
      await delegator.getCurrentTopAbility().then((Ability) => {
        logger.info(TAG, `${BUNDLE}get top ability, ${Ability.context.abilityInfo.name}`);
        expect(Ability.context.abilityInfo.name).assertEqual('MainAbility');
      })
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 下拉刷新应用
    it(BUNDLE + 'Refresh_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}Refresh_001 begin`);
      await driver.assertComponentExist(ON.type('Refresh'));
      await driver.swipe(200, 400, 200, 600);
      await driver.delayMs(1000);
      let missions: Component[] = await driver.findComponents(ON.type('ListItem'));
      expect(missions.length > 0).assertTrue();
      logger.info(TAG, `${BUNDLE}Refresh_001 end`);
      done();
    })

    // 左滑后锁定和解锁
    it(BUNDLE + 'LockAndUnlock_001', 0, async function (done) {
      logger.info(TAG, `${BUNDLE}LockAndUnlock_001 begin`);
      let missions: Component[] = await driver.findComponents(ON.type('ListItem'));
      await driver.delayMs(1000);
      if (missions.length > 0) {
        await driver.assertComponentExist(ON.id('lockState0'));
        await driver.delayMs(500);
        let lockState = await driver.findComponent(ON.id('lockState0'));
        await driver.delayMs(500);
        let isLock = await lockState.getText();
        logger.info(TAG, `${BUNDLE}LockAndUnlock_001 isLock=${isLock}`);
        await driver.delayMs(1000);
        let point = await missions[0].getBoundsCenter();
        await driver.swipe(point.x, point.y, point.x - 100, point.y);
        await driver.delayMs(1000);
        let rect = await missions[0].getBounds();
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.locked_mission'))));
        let lockButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.locked_mission'))));
        await lockButton.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('lockState0'));
        await driver.delayMs(500);
        let lockState1 = await driver.findComponent(ON.id('lockState0'));
        await driver.delayMs(500);
        let isLock1 = await lockState1.getText();
        expect(isLock === isLock1).assertFalse();

        await driver.swipe(point.x, point.y, point.x - 100, point.y);
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.unlocked_mission'))));
        let unlockButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.unlocked_mission'))));
        await unlockButton.click();
        await driver.delayMs(2000);
        await driver.assertComponentExist(ON.id('lockState0'));
        await driver.delayMs(500);
        let lockState2 = await driver.findComponent(ON.id('lockState0'));
        await driver.delayMs(500);
        let isLock2 = await lockState2.getText();
        expect(isLock2 === isLock1).assertFalse();
      }
      logger.info(TAG, `${BUNDLE}LockAndUnlock_001 end`);
      done();
    })

    // 左滑后删除功能
    it(BUNDLE + 'Delete_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'Delete_001 begin');
      let missions: Component[] = await driver.findComponents(ON.type('ListItem'));
      if (missions.length > 0) {
        let point = await missions[0].getBoundsCenter();
        await driver.swipe(point.x, point.y, point.x - 100, point.y);
        await driver.delayMs(1000);
        let rect = await missions[0].getBounds();
        await driver.click(rect.right + 410, rect.bottom - 140);
        await driver.delayMs(2000);
        let missions1: Component[] = await driver.findComponents(ON.type('ListItem'));
        expect(missions.length > missions1.length).assertTrue();
      }
      logger.info(TAG, BUNDLE + 'Delete_001 end');
      done();
    })

    // 左滑后，移动一个应用到前台
    it(BUNDLE + 'Move_001', 0, async function (done) {
      logger.info(TAG, BUNDLE + 'Move_001 begin');
      let missions: Component[] = await driver.findComponents(ON.type('ListItem'));
      if (missions.length > 0) {
        let point = await missions[0].getBoundsCenter();
        await driver.swipe(point.x, point.y, point.x - 100, point.y);
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.move_mission'))));
        let unlockButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.move_mission'))));
        await unlockButton.click();
        await driver.delayMs(2000);
        let window = await driver.findWindow({
          bundleName: 'ohos.samples.missionmanager'
        });
        expect(window == null).assertTrue();
      }
      logger.info(TAG, BUNDLE + 'Move_001 end');
      done();
    })
  })
}