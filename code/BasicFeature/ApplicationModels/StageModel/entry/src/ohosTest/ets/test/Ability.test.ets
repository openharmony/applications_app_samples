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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';

const TAG = '[Sample_StageModel]';
const BUNDLE = 'StageModel_';

export default function abilityTest() {
  let driver = Driver.create();
  let delegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {
    // 启动应用
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001 begin`);
      await startMainAbility();
      logger.info(TAG, `${BUNDLE}StartAbility_001 end`);
      done();
    })

    // 进入DataShareExtAbility
    it(BUNDLE + 'DataShareExtAbility_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DataShareExtAbility_001 begin`);
      await driver.assertComponentExist(ON.text('DataShareExtAbility', MatchPattern.CONTAINS));
      let btnDataShare = await driver.findComponent(ON.text('DataShareExtAbility', MatchPattern.CONTAINS));
      await btnDataShare.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('btnAdd'));
      logger.info(TAG, `${BUNDLE}DataShareExtAbility_001 end`);
      done();
    })

    // DataShareExtAbility 添加、更新、删除功能
    it(BUNDLE + 'DataShareExtAbility_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DataShareExtAbility_002 begin`);
      // 添加功能
      await driver.assertComponentExist(ON.id('btnAdd'));
      let btn = await driver.findComponent(ON.id('btnAdd'));
      await btn.click();
      await driver.delayMs(500);
      await btn.click();
      await driver.delayMs(500);
      let listItems = await driver.findComponents(ON.type('ListItem'));
      expect(listItems.length > 0).assertTrue();

      if (listItems.length > 0) {
        // 编辑功能
        await listItems[0].click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.id('bookNameInput'));
        let bookNameInput = await driver.findComponent(ON.id('bookNameInput'));
        await bookNameInput.click();
        await driver.delayMs(500);
        await bookNameInput.inputText('Book update');
        await driver.assertComponentExist(ON.text(getString($r('app.string.ok')), MatchPattern.CONTAINS));
        let btnSure = await driver.findComponent(ON.text(getString($r('app.string.ok')), MatchPattern.CONTAINS));
        await btnSure.click();
        await driver.delayMs(500);
        await driver.assertComponentExist(ON.text('Book update', MatchPattern.CONTAINS));
      }

      let listItems1 = await driver.findComponents(ON.type('ListItem'));
      if (listItems1.length > 0) {
        // 删除功能
        let bundle = await listItems1[0].getBounds();
        await driver.click(bundle.right - 30, bundle.top + 30);
        await driver.delayMs(1000);
        let listItems2 = await driver.findComponents(ON.type('ListItem'));
        expect((listItems1.length - 1) === listItems2.length).assertTrue();
      }

      await driver.assertComponentExist(ON.id('btnBack'));
      let btnBack = await driver.findComponent(ON.id('btnBack'));
      await btnBack.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}DataShareExtAbility_002 end`);
      done();
    })

    // AbilityContext 相关功能
    it(BUNDLE + 'AbilityContext_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}AbilityContext_001 begin`);
      await driver.assertComponentExist(ON.text('AbilityContext', MatchPattern.CONTAINS));
      let btnAbilityContext = await driver.findComponent(ON.text('AbilityContext', MatchPattern.CONTAINS));
      await btnAbilityContext.click();
      await driver.delayMs(1000);
      await clickAndJump('startAbility');
      await clickAndJump('startAbilityForResult');
      await clickAndToast('startServiceExtAbility');
      await clickAndToast('stopServiceExtAbility');
      await clickAndToast('connectAbility');
      logger.info(TAG, `${BUNDLE}AbilityContext_001 end`);
      done();
    })

    // AbilityContext 相关功能
    it(BUNDLE + 'AbilityContext_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}AbilityContext_002 begin`);
      await clickAndToast('disconnectAbility');
      await clickAndJump('startAbilityWithAccount');
      await clickAndToast('requestPermissionsFromUser');
      await clickAndToast('resourceManager');
      logger.info(TAG, `${BUNDLE}AbilityContext_002 end`);
      done();
    })

    // AbilityContext 相关功能
    it(BUNDLE + 'AbilityContext_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}AbilityContext_003 begin`);
      await clickAndToast('applicationInfo');
      await clickAndToast('cacheDir');
      await clickAndToast('stageMode');
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}AbilityContext_003 end`);
      done();
    })

    // AbilityContext 相关功能
    it(BUNDLE + 'AbilityContext_004', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}AbilityContext_004 begin`);
      await driver.assertComponentExist(ON.type('Scroll'));
      let scroll = await driver.findComponent(ON.type('Scroll'));
      await scroll.scrollToBottom(2000);
      await clickAndToast('getApplicationContext');
      await clickAndToast('bundleName');
      await clickAndToast('name');
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}AbilityContext_004 end`);
      done();
    })

    // ServiceExtContext相关
    it(BUNDLE + 'ServiceExtContext_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}ServiceExtContext_001 begin`);
      await driver.assertComponentExist(ON.text('ServiceExtContext', MatchPattern.CONTAINS));
      let btnAbilityContext = await driver.findComponent(ON.text('ServiceExtContext', MatchPattern.CONTAINS));
      await btnAbilityContext.click();
      await driver.delayMs(1000);
      await clickAndToast('startServiceExtAbility');
      await clickAndToast('stopServiceExtAbility');
      await clickAndToast('connectAbility');
      await clickAndToast('disconnectAbility');
      await clickAndJump('startAbilityWithAccount');
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}ServiceExtContext_001 end`);
      done();
    })

    // Bundle相关
    it(BUNDLE + 'Bundle_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Bundle_001 begin`);
      await driver.assertComponentExist(ON.text('Bundle', MatchPattern.CONTAINS));
      let btnAbilityContext = await driver.findComponent(ON.text('Bundle', MatchPattern.CONTAINS));
      await btnAbilityContext.click();
      await driver.delayMs(1000);
      await clickAndToast('getApplicationInfo');
      await clickAndToast('process');
      await clickAndToast('getDispatcherVersion');
      await clickAndToast('getAbilityInfo');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Bundle_001 end`);
      done();
    })

    // AbilityAccessCtrl相关
    it(BUNDLE + 'AbilityAccessCtrl_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}AbilityAccessCtrl_001 begin`);
      await driver.assertComponentExist(ON.text('AbilityAccessCtrl', MatchPattern.CONTAINS));
      let btnAbilityContext = await driver.findComponent(ON.text('AbilityAccessCtrl', MatchPattern.CONTAINS));
      await btnAbilityContext.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('verifyAccessToken', MatchPattern.CONTAINS))
      let component = await driver.findComponent(ON.text('verifyAccessToken', MatchPattern.CONTAINS));
      await component.click();
      await driver.delayMs(1000);
      await driver.waitForComponent(ON.type('Toast'), 2000);
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}AbilityAccessCtrl_001 end`);
      done();
    })

    // DataShareHelper相关
    it(BUNDLE + 'DataShareHelper_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DataShareHelper_001 begin`);
      await driver.assertComponentExist(ON.text('DataShareHelper', MatchPattern.CONTAINS));
      let btnAbilityContext = await driver.findComponent(ON.text('DataShareHelper', MatchPattern.CONTAINS));
      await btnAbilityContext.click();
      await driver.delayMs(1000);
      await clickAndToast('normalizeUri');
      await clickAndToast('denormalizeUri');
      await clickAndToast('notifyChange');
      await clickAndToast('off');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}DataShareHelper_001 end`);
      done();
    })

    // Window相关
    it(BUNDLE + 'Window_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}Window_001 begin`);
      await driver.assertComponentExist(ON.text('Window', MatchPattern.CONTAINS));
      let btnAbilityContext = await driver.findComponent(ON.text('Window', MatchPattern.CONTAINS));
      await btnAbilityContext.click();
      await driver.delayMs(1000);
      await clickAndToast('setWakeUpScreen');
      await clickAndToast('setPreferredOrientation');
      await clickAndToast('getTopWindow');
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Window_001 end`);
      done();
    })
  })

  let clickAndJump = async (text: string) => {
    let component = await scrollToSearch(text);
    await component.click();
    await driver.delayMs(1000);
    await driver.assertComponentExist(ON.text('Pull up Success', MatchPattern.CONTAINS));
    await driver.pressBack();
    await driver.delayMs(1000);
  }

  let clickAndToast = async (text: string) => {
    let component = await scrollToSearch(text);
    await component.click();
    await driver.waitForComponent(ON.type('Toast'), 2000);
    await driver.delayMs(1000);
  }

  let scrollToSearch = async (find: string): Promise<Component> => {
    await driver.assertComponentExist(ON.type('Scroll'));
    let scroll = await driver.findComponent(ON.type('Scroll'));
    let findComponent = await scroll.scrollSearch(ON.text(find));
    return findComponent;
  }

  let startMainAbility = async (): Promise<void> => {
    delegator.startAbility({
      bundleName: 'ohos.samples.stagemodel',
      abilityName: 'MainAbility'
    }, (err) => {
      logger.info(TAG, `${BUNDLE}startAbility end err ${JSON.stringify(err)}`);
    });
    await driver.delayMs(2000);
    await delegator.getCurrentTopAbility().then((Ability) => {
      logger.info(TAG, `${BUNDLE}get top ability`);
      expect(Ability.context.abilityInfo.name).assertEqual('MainAbility');
    })
  }

  let getString = (res: Resource): string => {
    return delegator.getAppContext().resourceManager.getStringSync(res);
  }
}