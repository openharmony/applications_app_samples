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

import { describe, it, expect } from '@ohos/hypium';
import { BusinessError } from '@kit.BasicServicesKit';
import { Want } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[Sample_BundleManager]';
const DOMAIN_NUMBER: number = 0xFF00;
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
let resourceManager = abilityDelegator.getAppContext().resourceManager;

async function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

function startAbility() {
  hilog.info(DOMAIN_NUMBER, TAG, 'StartAbility start');
  let want: Want = {
    bundleName: 'com.samples.bundlemanagement',
    abilityName: 'EntryAbility'
  };
  hilog.info(DOMAIN_NUMBER, TAG, 'getAbilityDelegator end');
  abilityDelegator.startAbility(want, (err: BusinessError) => {
    hilog.info(DOMAIN_NUMBER, TAG, 'StartAbility get err ' + JSON.stringify(err));
  });
}

export default function abilityTest() {
  describe('AutoFillSampleTest', () => {
    /*
    * @tc.number: BundleManager_GetBundleInfoForSelf_001
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the GetProfileByExtensionAbility API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('BundleManager_GetBundleInfoForSelf_001', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'BundleManager_GetBundleInfoForSelfSync_001 start');
      await sleep(1000);
      let driver = Driver.create();
      await sleep(1000);
      hilog.info(DOMAIN_NUMBER, TAG, 'driver err ' + JSON.stringify(driver));
      startAbility();
      await sleep(2000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.GetBundleInfoTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: BundleManager_GetBundleInfoForSelfSync_002
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the GetBundleInfoForSelfSync API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('BundleManager_GetBundleInfoForSelfSync_002', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'BundleManager_GetBundleInfoForSelfSync_002 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.GetBundleInfoSyncTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: BundleManager_GetProfileByAbility_004
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the GetProfileByAbility API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('BundleManager_GetProfileByAbility_004', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'BundleManager_GetProfileByAbility_004 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.GetConfigurationJsonTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: BundleManager_GetProfileByExtensionAbility_005
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the GetProfileByExtensionAbility API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('BundleManager_GetProfileByExtensionAbility_005', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'BundleManager_GetProfileByExtensionAbility_005 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.GetConfigurationArrayTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(2000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: BundleManager_GetProfileByExtensionAbilitySync_006
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the GetProfileByExtensionAbilitySync API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('BundleManager_GetProfileByExtensionAbilitySync_006', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'BundleManager_GetProfileByExtensionAbilitySync_006 start');
      let driver = Driver.create();
      await sleep(2000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.GetConfigurationJsonSyncTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: BundleManager_CanOpenLink_007
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the CanOpenLink API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('BundleManager_CanOpenLink_007', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'BundleManager_CanOpenLink_007 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.VerifyLinkOpenedTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: DefaultAppMgr_IsDefaultApplication_008
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the IsDefaultApplication API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('DefaultAppMgr_IsDefaultApplication_008', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'DefaultAppMgr_IsDefaultApplication_008 start');
      let driver = Driver.create();
      await sleep(1000);
      await driver.swipe(360, 1070, 360, 600);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.DetermineDefaultApplicationTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: DefaultAppMgr_IsDefaultApplicationSync_009
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the IsDefaultApplicationSync API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('DefaultAppMgr_IsDefaultApplicationSync_009', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'DefaultAppMgr_IsDefaultApplicationSync_009 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.DetermineDefaultApplicationSyncTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: Overlay_SetOverlayEnabled_010
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the SetOverlayEnabled API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('Overlay_SetOverlayEnabled_010', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Overlay_SetOverlayEnabled_010 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.SetDisableEnableStatusTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: Overlay_GetOverlayModuleInfo_011
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the GetOverlayModuleInfo API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('Overlay_GetOverlayModuleInfo_011', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Overlay_GetOverlayModuleInfo_011 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.ObtainOverlayModuleInfoInformationTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })

    /*
    * @tc.number: Overlay_GetTargetOverlayModuleInfos_012
    * @tc.name: By providing the sample code call interface
    * @tc.desc: Call the GetTargetOverlayModuleInfos API successfully
    * @tc.size: MediumTest
    * @tc.type: Function
    * @tc.level Level 1
    */
    it('Overlay_GetTargetOverlayModuleInfos_012', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, 'Overlay_GetTargetOverlayModuleInfos_012 start');
      let driver = Driver.create();
      await sleep(1000);
      let registerBtn = await driver.findComponent(ON.text(
        await resourceManager.getStringValue($r('app.string.ObtainMultipleOverlayModuleInfoInformationTest'))));
      await sleep(1000);
      await registerBtn.click();
      await sleep(1000);
      expect(registerBtn != null).assertTrue();
      done();
    })
  })
}