/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { beforeAll, describe, expect, it, Level, TestType, Size } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import router from '@ohos.router';


const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let driver: Driver;
let want: Want;


export default function ComponentStateMigration() {
  describe('ComponentStateMigration', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      await driver.delayMs(1000);

      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info('get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    });

    /*
     * @tc.number     : StateEasyV1_001
     * @tc.name       : testStateEasyV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateEasyV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/StateEasyV1' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : StateEasyV2_002
     * @tc.name       : testStateEasyV2
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateEasyV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/StateEasyV2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : StateComplexV1_003
     * @tc.name       : testStateComplexV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateComplexV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/StateComplexV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('value+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : StateComplexV2_004
     * @tc.name       : testStateComplexV2
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateComplexV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/StateComplexV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('value+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : StateExternalInitializationV1_005
     * @tc.name       : testStateExternalInitializationV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateExternalInitializationV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/StateExternalInitializationV1' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : StateExternalInitializationV2_006
     * @tc.name       : testStateExternalInitializationV2
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testStateExternalInitializationV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/StateExternalInitializationV2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : LinkMiigrationV1_007
     * @tc.name       : testLinkMiigrationV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testLinkMiigrationV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/LinkMiigrationV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });

    /*
     * @tc.number     : StateLinkMiigrationV2_008
     * @tc.name       : testLinkMiigrationV2
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testLinkMiigrationV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/LinkMiigrationV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : PropEasyV1_009
     * @tc.name       : testPropEasyV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testPropEasyV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropEasyV1' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : PropEasyV2_010
      * @tc.name       : testPropEasyV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testPropEasyV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropEasyV2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : PropComplexV1_011
     * @tc.name       : testPropComplexV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testPropComplexV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropComplexV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('apple+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(1000);
        const title1 = await driver.findComponent(ON.text('orange+1'));
        expect(title1 === null).assertFalse();
        await title1.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : PropComplexV2_012
      * @tc.name       : testPropComplexV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testPropComplexV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropComplexV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('apple+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(1000);
        const title1 = await driver.findComponent(ON.text('orange+1'));
        expect(title1 === null).assertFalse();
        await title1.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : PropSubComponentUpdateVarV1_013
      * @tc.name       : testPropSubComponentUpdateVarV1
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testPropSubComponentUpdateVarV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropSubComponentUpdateVarV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : PropSubComponentUpdateVarV2_014
      * @tc.name       : testPropSubComponentUpdateVarV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testPropSubComponentUpdateVarV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropSubComponentUpdateVarV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('+1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : PropSubComponentUpdateVarLocalV1_015
     * @tc.name       : testPropSubComponentUpdateVarLocalV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testPropSubComponentUpdateVarLocalV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropSubComponentUpdateVarLocalV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('Parent +1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(1000);
        const title1 = await driver.findComponent(ON.text('Child +100'));
        expect(title1 === null).assertFalse();
        await title1.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : PropSubComponentUpdateVarLocalV2_016
      * @tc.name       : testPropSubComponentUpdateVarLocalV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testPropSubComponentUpdateVarLocalV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/PropSubComponentUpdateVarLocalV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('Parent +1'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(1000);
        const title1 = await driver.findComponent(ON.text('Child +100'));
        expect(title1 === null).assertFalse();
        await title1.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : ProvideAliasV1_017
     * @tc.name       : testProvideAliasV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testProvideAliasV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideAliasV1' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : ProvideAliasV2_018
      * @tc.name       : testProvideAliasV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testProvideAliasV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideAliasV2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : ProvideConsumeNoInitV1_019
      * @tc.name       : testProvideConsumeNoInitV1
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testProvideConsumeNoInitV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideConsumeNoInitV1' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : ProvideConsumeInitV2_020
      * @tc.name       : testProvideConsumeInitV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testProvideConsumeInitV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideConsumeInitV2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
    /*
     * @tc.number     : ProvideParentInitV1_021
     * @tc.name       : testProvideParentInitV1
     * @tc.desc       : 测试装饰器迁移
     * @tc.size       : MediumTest
     * @tc.type       : Function
     * @tc.level      : Level 1
     */
    it('testProvideParentInitV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideParentInitV1' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : ProvideParentNoInitV2_022
      * @tc.name       : testProvideParentNoInitV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testProvideParentNoInitV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideParentNoInitV2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
      /*
       * @tc.number     : ProvideNoAllowOverrideV1_023
       * @tc.name       : testProvideNoAllowOverrideV1
       * @tc.desc       : 测试装饰器迁移
       * @tc.size       : MediumTest
       * @tc.type       : Function
       * @tc.level      : Level 1
       */
    it('testProvideNoAllowOverrideV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideNoAllowOverrideV1' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : ProvideAllowOverrideV2_024
      * @tc.name       : testProvideAllowOverrideV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testProvideAllowOverrideV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ProvideAllowOverrideV2' })
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : WatchSingleVarV1_025
      * @tc.name       : testWatchSingleVarV1
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testWatchSingleVarV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/WatchSingleVarV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('add apple'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : WatchSingleVarV2_026
      * @tc.name       : testWatchSingleVarV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testWatchSingleVarV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/WatchSingleVarV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('add apple'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : WatchMoreVarV1_027
      * @tc.name       : testWatchMoreVarV1
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testWatchMoreVarV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/WatchMoreVarV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('add apple'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(1000);
        const title1 = await driver.findComponent(ON.text('add orange'));
        expect(title1 === null).assertFalse();
        await title1.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : WatchMoreVarV2_028
      * @tc.name       : testWatchMoreVarV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testWatchMoreVarV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/WatchMoreVarV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('add apple'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(1000);
        const title1 = await driver.findComponent(ON.text('add orange'));
        expect(title1 === null).assertFalse();
        await title1.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : ComputedV1_029
      * @tc.name       : testComputedV1
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testComputedV1', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ComputedV1' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('changed lastName'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
     /*
      * @tc.number     : ComputedV2_030
      * @tc.name       : testComputedV2
      * @tc.desc       : 测试装饰器迁移
      * @tc.size       : MediumTest
      * @tc.type       : Function
      * @tc.level      : Level 1
      */
    it('testComputedV2', TestType.FUNCTION | Size.MEDIUMTEST | Level.LEVEL1,
      async (done: Function) => {
        let driver = Driver.create();
        await driver.delayMs(1000);
        await router.pushUrl({ url: 'pages/componentstatemigration/ComputedV2' })
        await driver.delayMs(1000);
        const title = await driver.findComponent(ON.text('changed lastName'));
        expect(title === null).assertFalse();
        await driver.delayMs(1000);
        await title.click();
        await driver.delayMs(2000);
        await driver.pressBack();
        await driver.delayMs(1000);
        done();
      });
  });
}