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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import hilog from '@ohos.hilog';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_ComponentStateManagement]';
const DOMAIN = 0xF811;
const BUNDLE = 'ComponentStateManagement_';
const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

export default function IndexTest() {
  describe('IndexTest', () => {
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      let driver = Driver.create();
      await driver.delayMs(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * @tc.number ComponentStateManagement_001
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('LinkDecorator', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('AddProxyToRerendertheUI', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('changeScore1', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_001 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_002
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_002 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('DecoratingVariablesDateType', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('child increase the year by 1', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_002 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_003
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_003 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('DecoratingVariablesMapType', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('child set new one', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_003 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_004
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_004 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('DecoratingVariablesSetType', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('set new one', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_004 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_005
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_005 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('LinkUsage', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_005 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_006
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_006 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('LinkUsage2', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_006 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_007
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_007 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('UseWatchToChangeLocalVariables', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('Change sourceNumber in Parent Component', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_007 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_008
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_008 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('UsingLinkwithArrayTypes', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('Button2: replace whole item', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_008 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_009
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_009 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('UsingLinkwithPrimitiveandClassTypes', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('Green Button', MatchPattern.CONTAINS));
      await button1.doubleClick();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_009 end');
      done();
    })

    /**
     * @tc.number ComponentStateManagement_010
     * @tc.name testComponentStateManagement
     * @tc.desc 测试装饰器显示是否正常
     */
    it('ComponentStateManagement_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_010 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('UsingUnionTypes', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('Parents change name to Peter', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ComponentStateManagement_010 end');
      done();
    })
  })
}