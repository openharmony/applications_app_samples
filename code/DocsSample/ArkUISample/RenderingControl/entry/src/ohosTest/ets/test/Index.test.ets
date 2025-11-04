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
// 导入测试依赖kit
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';

const TAG = '[Sample_RenderingControl]'
const DOMAIN = 0xF811
const BUNDLE = 'RenderingControl_'
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
     * @tc.number RenderingRepeatTest_001
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('RenderingRepeat', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat1', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Refresh', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_001 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_002
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_002 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat2', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Delete No.1', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('Delete No.5', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_002 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_003
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_002 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat3', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_002 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_004
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_004 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat4', MatchPattern.CONTAINS));
      await button1.click();
      let repeatList = await driver.findComponent(ON.type('List'));
      await repeatList.scrollToBottom(10000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_004 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_005
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_005 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat5', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Click to change the value of the third array item', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_005 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_006
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_006 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat6', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('insert #5', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('delete #0', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_006 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_007
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_007 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat7', MatchPattern.CONTAINS));
      await button1.click();
      let repeatList = await driver.findComponent(ON.type('List'));
      await repeatList.scrollToBottom(30000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_007 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_008
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_008 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat8', MatchPattern.CONTAINS));
      await button1.click();
      let repeatList = await driver.findComponent(ON.type('List'));
      await repeatList.scrollToBottom(15000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_008 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_009
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_009 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat9', MatchPattern.CONTAINS));
      await button1.click();
      let repeatList = await driver.findComponent(ON.type('List'));
      await repeatList.scrollToBottom(15000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_009 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_010
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_010 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat10', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('ScrollToIndex 500', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_010 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_011
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_011 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat11', MatchPattern.CONTAINS));
      await button1.click();
      let repeatList = await driver.findComponent(ON.type('List'));
      await repeatList.scrollToBottom(30000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_011 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_012
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_012', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_012 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat12', MatchPattern.CONTAINS));
      await button1.click();
      let repeatList = await driver.findComponent(ON.type('List'));
      await repeatList.scrollToTop(1000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_012 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_013
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_013', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_013 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat13', MatchPattern.CONTAINS));
      await button1.click();
      let repeatList = await driver.findComponent(ON.type('List'));
      await repeatList.scrollToBottom(30000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_013 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_014
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_014', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_014 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat14', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('insert totalCount 100', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_014 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_015
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_015', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_015 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat15', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('insert totalCount 100', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_015 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_016
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_016', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_016 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat16', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Add No.0', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('Modify No.0', MatchPattern.CONTAINS));
      await button3.click();
      let button4 = await driver.findComponent(ON.text('Del No.0', MatchPattern.CONTAINS));
      await button4.click();
      let button5 = await driver.findComponent(ON.text('Update array length to 5', MatchPattern.CONTAINS));
      await button5.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_016 end');
      done();
    })

    /**
     * @tc.number RenderingRepeatTest_017
     * @tc.name testRenderingRepeat
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingRepeatTest_017', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_017 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingRepeat17', MatchPattern.CONTAINS));
      await button1.click();
      let text1 = await driver.findComponent(ON.text('1', MatchPattern.CONTAINS));
      let text2 = await driver.findComponent(ON.text('4', MatchPattern.CONTAINS));
      await text1.dragTo(text2);
      await driver.pressBack();
      let button2 = await driver.findComponent(ON.text('RenderingRepeat', MatchPattern.CONTAINS));
      await button2.click();
      hilog.info(DOMAIN, TAG, 'RenderingRepeatTest_017 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_001
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('RenderingForeach', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('RenderingForeach1', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Insert Item After First Item', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_001 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_002
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_002 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach2', MatchPattern.CONTAINS));
      await button1.click();
      let articleList = await driver.findComponent(ON.type('List'));
      await articleList.scrollToBottom(2400);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_002 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_003
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_003 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach3', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('100', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_003 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_004
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_004 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach4', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Like/Unlike first article', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_004 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_005
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_005 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach5', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_005 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_006
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_006 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach6', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Insert Item After First Item', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_006 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_007
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_007 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach7', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_007 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_008
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_008 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach8', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_008 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_009
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_009 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach9', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_009 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_010
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_010 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach10', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Click to change the value of the third array item', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_010 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_011
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_011 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach11', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Add one item', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_011 end');
      done();
    })

    /**
     * @tc.number ControlForEachTest_012
     * @tc.name ControlForEachTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('ControlForEachTest_012', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_012 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingForeach12', MatchPattern.CONTAINS));
      await button1.click();
      let articleList = await driver.findComponent(ON.type('List'));
      await articleList.scrollToTop(2400);
      await driver.pressBack();
      let button2 = await driver.findComponent(ON.text('RenderingForeach', MatchPattern.CONTAINS));
      await button2.click();
      hilog.info(DOMAIN, TAG, 'ControlForEachTest_012 end');
      done();
    })

    /**
     * @tc.number RenderingControlIfTest_001
     * @tc.name RenderingControlIfTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingControlIfTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('RenderingIf', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('RenderingIf1', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('counter 0 +1', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('toggle true', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_001 end');
      done();
    })

    /**
     * @tc.number RenderingControlIfTest_002
     * @tc.name RenderingControlIfTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingControlIfTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_002 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingIf4', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('Toggle Outer', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('Toggle Inner', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_002 end');
      done();
    })

    /**
     * @tc.number RenderingControlIfTest_003
     * @tc.name RenderingControlIfTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingControlIfTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_003 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingIf2', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('increase count', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('decrease count', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_003 end');
      done();
    })

    /**
     * @tc.number RenderingControlIfTest_004
     * @tc.name RenderingControlIfTest
     * @tc.desc 测试渲染是否显示正常
     */
    it('RenderingControlIfTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_004 begin');
      let driver = Driver.create();
      let button1 = await driver.findComponent(ON.text('RenderingIf3', MatchPattern.CONTAINS));
      await button1.click();
      let button2 = await driver.findComponent(ON.text('counter 0 +1', MatchPattern.CONTAINS));
      await button2.click();
      let button3 = await driver.findComponent(ON.text('toggle true', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingControlIfTest_001 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_001
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('RenderingLazyForeach', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('AddingData', MatchPattern.CONTAINS));
      await button1.click();
      let operation = await driver.findComponent(ON.type('List'));
      await operation.scrollToBottom(15000);
      let button2 = await driver.findComponent(ON.text('Hello 20', MatchPattern.CONTAINS));
      await button2.click();
      await operation.scrollToBottom(15000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_001 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_002
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_002 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ChangingDataSubproperties', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('Hello 4', MatchPattern.CONTAINS));
      await button1.doubleClick();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_002 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_003
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_003 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ComponentRerenderingFailure', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('update all', MatchPattern.CONTAINS));
      await button1.doubleClick();;
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_003 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_004
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_004 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('DataDeletion', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('Hello 4', MatchPattern.CONTAINS));
      await button1.click();;
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_004 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_005
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_005 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('DragandDropSorting', MatchPattern.CONTAINS));
      await button.click();
      let text1 = await driver.findComponent(ON.text('1', MatchPattern.CONTAINS));
      let text2 = await driver.findComponent(ON.text('4', MatchPattern.CONTAINS));
      await text1.dragTo(text2)
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_005 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_006
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_006 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ImageFlickeringDuringRerenders', MatchPattern.CONTAINS));
      await button.click();
      let text1 = await driver.findComponent(ON.text('Hello 1', MatchPattern.CONTAINS));
      await text1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_006 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_007
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_007 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('InitialRendering', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.type('List'));
      await button1.scrollToBottom(15000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_007 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_008
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_008 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('InitialRendering2', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.type('List'));
      await button1.scrollToBottom(15000);
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_008 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_009
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_009 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('LazyLoadingFailure', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_009 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_010
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_010 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ModifyingIndividualDataItems', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_010 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_011
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_011 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ModifyingMultipleDataItems', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_011 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_012
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_012', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_012 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ObservingComponentInternalState', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_012 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_013
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_013', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_013 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ObservingNestedClassProperties', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_013 end');
      done();
    })

    /**
     * @tc.number RenderingLazyForeachTest_014
     * @tc.name testRenderingLazyForeach
     * @tc.desc 测试lazyforeach渲染是否显示正常
     */
    it('RenderingLazyForeachTest_014', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_014 begin');
      let driver = Driver.create();
      let operation = await driver.findComponent(ON.type('List'));
      await operation.scrollToBottom(15000);
      let button = await driver.findComponent(ON.text('PreciselyModifyingData', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      let button1 = await driver.findComponent(ON.text('PreciselyModifyingData2', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      let button2 = await driver.findComponent(ON.text('ReceivingExternalInput', MatchPattern.CONTAINS));
      await button2.click();
      await driver.pressBack();
      let button3 = await driver.findComponent(ON.text('ScreenFlickeringInList', MatchPattern.CONTAINS));
      await button3.click();
      await driver.pressBack();
      let button4 = await driver.findComponent(ON.text('SwappingData', MatchPattern.CONTAINS));
      await button4.click();
      await driver.pressBack();
      let button5 = await driver.findComponent(ON.text('UINotRerenderedWhenObjectLinkIsChanged', MatchPattern.CONTAINS));
      await button5.click();
      await driver.pressBack();
      let button6 = await driver.findComponent(ON.text('UnexpectedRenderingResults', MatchPattern.CONTAINS));
      await button6.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, 'RenderingLazyForeachTest_014 end');
      done();
    })
  })
}