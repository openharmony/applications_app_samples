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
import hilog from '@ohos.hilog';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG = '[Sample_ShapeDrawing]';
const DOMAIN = 0xF811;
const BUNDLE = 'ShapeDrawing_';
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
     * @tc.number ShapeDrawingTest_001
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_001 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('AntiAlias', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_001 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_002
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_002 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('CircleExample', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_002 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_003
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_003 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('Fill', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_003 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_004
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_004 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('Mesh', MatchPattern.CONTAINS));
      await button.click();
      let button1 = await driver.findComponent(ON.text('Show Shape', MatchPattern.CONTAINS));
      await button1.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_004 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_005
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_005 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('Shape', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_005 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_006
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_006 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ShapeExample', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_006 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_007
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_007 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('Stroke', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_007 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_008
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_008 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('StrokeLineJoin', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_008 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_009
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_009 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('StrokeMiterLimit', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_009 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_010
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_010 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('StrokeOpacity', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_010 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_011
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_011', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_011 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ViewPort1', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_011 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_012
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_012', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_012 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ViewPort2', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_012 end');
      done();
    })

    /**
     * @tc.number ShapeDrawingTest_013
     * @tc.name testShapeDrawing
     * @tc.desc 测试图形绘制是否显示正常
     */
    it('ShapeDrawingTest_013', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_013 begin');
      let driver = Driver.create();
      let button = await driver.findComponent(ON.text('ViewPort3', MatchPattern.CONTAINS));
      await button.click();
      await driver.pressBack();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ShapeDrawingTest_013 end');
      done();
    })
  })
}