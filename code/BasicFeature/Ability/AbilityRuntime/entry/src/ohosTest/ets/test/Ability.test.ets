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
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { describe, beforeAll, it, expect } from '@ohos/hypium';

const TAG = '[Sample_AbilityRuntime]';
const DOMAIN = 0xFF00;
const BUNDLE = 'AbilityRuntime_';
const TIME = 500;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.abilityruntime',
          abilityName: 'EntryAbility'
        });
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'error: ' + err.message);
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })

    /**
     * @tc.number     : PublicAbility_AppManager_001
     * @tc.name       : PublicAbility_AppManager_001
     * @tc.desc       : test onclick appManager
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_AppManager_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AppManager_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      // //进入appManager开发示例页面
      let appManager = await driver.findComponent(ON.id('AppManager'));
      await appManager.click();
      await driver.delayMs(TIME);
      //点击isRunningInStabilityTestCallback
      await driver.assertComponentExist(ON.id('isRunningInStabilityTestCallback'));
      let isRunningInStabilityTestCallback = await driver.findComponent(ON.id('isRunningInStabilityTestCallback'));
      await isRunningInStabilityTestCallback.click();
      await driver.delayMs(TIME);
      //点击isRunningInStabilityTestPromise
      await driver.assertComponentExist(ON.id('isRunningInStabilityTestPromise'));
      let isRunningInStabilityTestPromise = await driver.findComponent(ON.id('isRunningInStabilityTestPromise'));
      await isRunningInStabilityTestPromise.click();
      await driver.delayMs(TIME);
      //点击isRamConstrainedDeviceCallback
      await driver.assertComponentExist(ON.id('isRamConstrainedDeviceCallback'));
      let isRamConstrainedDeviceCallback = await driver.findComponent(ON.id('isRamConstrainedDeviceCallback'));
      await isRamConstrainedDeviceCallback.click();
      await driver.delayMs(TIME);
      //点击isRamConstrainedDevicePromise
      await driver.assertComponentExist(ON.id('isRamConstrainedDevicePromise'));
      let isRamConstrainedDevicePromise = await driver.findComponent(ON.id('isRamConstrainedDevicePromise'));
      await isRamConstrainedDevicePromise.click();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'AppManager_001 end');
      done();
    })

    /**
     * @tc.number     : PublicAbility_AppManager_002
     * @tc.name       : PublicAbility_AppManager_002
     * @tc.desc       : test onclick appManager
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_AppManager_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AppManager_002 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      //点击getAppMemorySizeCallback
      await driver.assertComponentExist(ON.id('getAppMemorySizeCallback'));
      let getAppMemorySizeCallback = await driver.findComponent(ON.id('getAppMemorySizeCallback'));
      await getAppMemorySizeCallback.click();
      await driver.delayMs(TIME);
      //点击getAppMemorySizePromise
      await driver.assertComponentExist(ON.id('getAppMemorySizePromise'));
      let getAppMemorySizePromise = await driver.findComponent(ON.id('getAppMemorySizePromise'));
      await getAppMemorySizePromise.click();
      await driver.delayMs(TIME);
      //点击getRunningProcessInformationCallback
      await driver.assertComponentExist(ON.id('getRunningProcessInformationCallback'));
      let getRunningProcessInformationCallback =
        await driver.findComponent(ON.id('getRunningProcessInformationCallback'));
      await getRunningProcessInformationCallback.click();
      await driver.delayMs(TIME);
      //点击getRunningProcessInformationPromise
      await driver.assertComponentExist(ON.id('getRunningProcessInformationPromise'));
      let getRunningProcessInformationPromise =
        await driver.findComponent(ON.id('getRunningProcessInformationPromise'));
      await getRunningProcessInformationPromise.click();
      await driver.delayMs(TIME);

      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'AppManager_002 end');
      done();
    })

    /**
     * @tc.number     : PublicAbility_DataUriUtils_001
     * @tc.name       : PublicAbility_DataUriUtils_001
     * @tc.desc       : test onclick DataUriUtils
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_DataUriUtils_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataUriUtils_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);

      // //进入DataUriUtils开发示例页面
      let dataUriUtils = await driver.findComponent(ON.id('DataUriUtils'));
      await dataUriUtils.click();
      await driver.delayMs(TIME);
      //点击GetId
      await driver.assertComponentExist(ON.id('getId'));
      let getId = await driver.findComponent(ON.id('getId'));
      await getId.click();
      await driver.delayMs(TIME);
      //点击AttachId
      await driver.assertComponentExist(ON.id('attachId'));
      let attachId = await driver.findComponent(ON.id('attachId'));
      await attachId.click();
      await driver.delayMs(TIME);
      //点击DeleteId
      await driver.assertComponentExist(ON.id('deleteId'));
      let deleteId = await driver.findComponent(ON.id('deleteId'));
      await deleteId.click();
      await driver.delayMs(TIME);
      //点击UpdateId
      await driver.assertComponentExist(ON.id('updateId'));
      let updateId = await driver.findComponent(ON.id('updateId'));
      await updateId.click();
      await driver.delayMs(TIME);

      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'DataUriUtils_001 end');
      done();
    })

    /**
     * @tc.number     : PublicAbility_WantAgent_001
     * @tc.name       : PublicAbility_WantAgent_001
     * @tc.desc       : test onclick WantAgent
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_WantAgent_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WantAgent_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      // //进入WantAgent开发示例页面
      let wantAgent = await driver.findComponent(ON.id('WantAgent'));
      await wantAgent.click();
      await driver.delayMs(TIME);
      //点击getBundleNameCallback
      await driver.assertComponentExist(ON.id('getBundleNameCallback'));
      let getBundleNameCallback = await driver.findComponent(ON.id('getBundleNameCallback'));
      await getBundleNameCallback.click();
      await driver.delayMs(TIME);
      //点击getBundleNamePromise
      await driver.assertComponentExist(ON.id('getBundleNamePromise'));
      let getBundleNamePromise = await driver.findComponent(ON.id('getBundleNamePromise'));
      await getBundleNamePromise.click();
      await driver.delayMs(TIME);
      //点击getUidCallback
      await driver.assertComponentExist(ON.id('getUidCallback'));
      let getUidCallback = await driver.findComponent(ON.id('getUidCallback'));
      await getUidCallback.click();
      await driver.delayMs(TIME);
      //点击getUidPromise
      await driver.assertComponentExist(ON.id('getUidPromise'));
      let getUidPromise = await driver.findComponent(ON.id('getUidPromise'));
      await getUidPromise.click();
      await driver.delayMs(TIME);
      //点击cancelCallback
      await driver.assertComponentExist(ON.id('cancelCallback'));
      let cancelCallback = await driver.findComponent(ON.id('cancelCallback'));
      await cancelCallback.click();
      await driver.delayMs(TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'WantAgent_001 end');
      done();
    })

    /**
     * @tc.number     : PublicAbility_WantAgent_002
     * @tc.name       : PublicAbility_WantAgent_002
     * @tc.desc       : test onclick WantAgent
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_WantAgent_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WantAgent_002 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      //点击cancelPromise
      await driver.assertComponentExist(ON.id('cancelPromise'));
      let cancelPromise = await driver.findComponent(ON.id('cancelPromise'));
      await cancelPromise.click();
      await driver.delayMs(TIME);
      //点击equalCallback
      await driver.assertComponentExist(ON.id('equalCallback'));
      let equalCallback = await driver.findComponent(ON.id('equalCallback'));
      await equalCallback.click();
      await driver.delayMs(TIME);
      //点击equalPromise
      await driver.assertComponentExist(ON.id('equalPromise'));
      let equalPromise = await driver.findComponent(ON.id('equalPromise'));
      await equalPromise.click();
      await driver.delayMs(TIME);
      //点击getOperationTypeCallback
      await driver.assertComponentExist(ON.id('getOperationTypeCallback'));
      let getOperationTypeCallback = await driver.findComponent(ON.id('getOperationTypeCallback'));
      await getOperationTypeCallback.click();
      await driver.delayMs(TIME);
      //点击getOperationTypePromise
      await driver.swipe(100, 400, 100, 100, 600);
      await driver.delayMs(TIME);
      await driver.assertComponentExist(ON.id('getOperationTypePromise'));
      let getOperationTypePromise = await driver.findComponent(ON.id('getOperationTypePromise'));
      await getOperationTypePromise.click();
      await driver.delayMs(TIME);
      //点击trigger
      await driver.assertComponentExist(ON.id('trigger'));
      let trigger = await driver.findComponent(ON.id('trigger'));
      await trigger.click();
      await driver.delayMs(TIME);

      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'WantAgent_002 end');
      done();
    })

    /**
     * @tc.number     : PublicAbility_ApplicationContext_001
     * @tc.name       : PublicAbility_ApplicationContext_001
     * @tc.desc       : test onclick ApplicationContext
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_ApplicationContext_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ApplicationContext_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      // //进入ApplicationContext开发示例页面
      let applicationContext = await driver.findComponent(ON.id('ApplicationContext'));
      await applicationContext.click();
      await driver.delayMs(TIME);
      //点击getCurrentAppCloneIndex
      await driver.assertComponentExist(ON.id('getCurrentAppCloneIndex'));
      let getCurrentAppCloneIndex = await driver.findComponent(ON.id('getCurrentAppCloneIndex'));
      await getCurrentAppCloneIndex.click();
      await driver.delayMs(TIME);
      //点击getRunningProcessInformationCallback
      await driver.assertComponentExist(ON.id('getRunningProcessInformationCallback'));
      let getRunningProcessInformationCallback =
        await driver.findComponent(ON.id('getRunningProcessInformationCallback'));
      await getRunningProcessInformationCallback.click();
      await driver.delayMs(TIME);
      //点击getRunningProcessInformationPromise
      await driver.assertComponentExist(ON.id('getRunningProcessInformationPromise'));
      let getRunningProcessInformationPromise =
        await driver.findComponent(ON.id('getRunningProcessInformationPromise'));
      await getRunningProcessInformationPromise.click();
      await driver.delayMs(TIME);
      //点击setFont
      await driver.assertComponentExist(ON.id('setFont'));
      let setFont = await driver.findComponent(ON.id('setFont'));
      await setFont.click();
      await driver.delayMs(TIME);
      //点击restartApp
      // await driver.assertComponentExist(ON.id('restartApp'));
      // let restartApp = await driver.findComponent(ON.id('restartApp'));
      // await restartApp.click();
      // await driver.delayMs(TIME);

      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ApplicationContext_001 end');
      done();
    })

    /**
     * @tc.number     : PublicAbility_ErrorManager_001
     * @tc.name       : PublicAbility_ErrorManager_001
     * @tc.desc       : test onclick ErrorManager
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_ErrorManager_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ErrorManager_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      // //进入ErrorManager开发示例页面
      let errorManager = await driver.findComponent(ON.id('ErrorManager'));
      await errorManager.click();
      await driver.delayMs(TIME);
      //点击registerLoopObserver
      await driver.assertComponentExist(ON.id('registerLoopObserver'));
      let registerLoopObserver = await driver.findComponent(ON.id('registerLoopObserver'));
      await registerLoopObserver.click();
      await driver.delayMs(TIME);
      //点击registerUnhandledRejection
      await driver.assertComponentExist(ON.id('registerUnhandledRejection'));
      let registerUnhandledRejection = await driver.findComponent(ON.id('registerUnhandledRejection'));
      await registerUnhandledRejection.click();
      await driver.delayMs(TIME);
      //点击simulateUnhandledRejection
      await driver.assertComponentExist(ON.id('simulateUnhandledRejection'));
      let simulateUnhandledRejection = await driver.findComponent(ON.id('simulateUnhandledRejection'));
      await simulateUnhandledRejection.click();
      await driver.delayMs(TIME);
      //点击unregisterUnhandledRejection
      await driver.assertComponentExist(ON.id('unregisterUnhandledRejection'));
      let unregisterUnhandledRejection = await driver.findComponent(ON.id('unregisterUnhandledRejection'));
      await unregisterUnhandledRejection.click();
      await driver.delayMs(TIME);

      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ErrorManager_001 end');
      done();
    })

    /**
     * @tc.number     : PublicAbility_UIAbilityContext_001
     * @tc.name       : PublicAbility_UIAbilityContext_001
     * @tc.desc       : test onclick UIAbilityContext
     * @tc.size       : MEDIUM
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('PublicAbility_UIAbilityContext_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UIAbilityContext_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(TIME);

      //进入UIAbilityContext开发示例页面
      let uiAbilityContext = await driver.findComponent(ON.id('UIAbilityContext'));
      await uiAbilityContext.click();
      await driver.delayMs(TIME);
      //点击moveAbilityToBackground
      await driver.assertComponentExist(ON.id('moveAbilityToBackground'));
      let moveAbilityToBackground = await driver.findComponent(ON.id('moveAbilityToBackground'));
      await moveAbilityToBackground.click();
      await driver.delayMs(TIME);
      //再次点击UIAbilityContext,进入UIAbilityContext开发示例页面
      await uiAbilityContext.click();
      await driver.delayMs(TIME);
      //点击terminateSelf
      await driver.assertComponentExist(ON.id('terminateSelf'));
      let terminateSelf = await driver.findComponent(ON.id('terminateSelf'));
      await terminateSelf.click();
      await driver.delayMs(TIME);

      await driver.delayMs(TIME);
      await driver.pressBack();
      await driver.delayMs(TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'UIAbilityContext_001 end');
      done();
    })
  })
}