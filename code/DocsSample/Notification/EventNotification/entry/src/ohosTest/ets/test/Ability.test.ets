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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, Level } from '@ohos/hypium';
import { Driver, ON, Component, Point, MatchPattern } from '@kit.TestKit';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Want } from '@kit.AbilityKit';

function sleep(time: number) {
  return new Promise<void>((resolve) => setTimeout(resolve, time));
}

async function getCenterPoint(comp: Component, offset: number): Promise<Point> {
  // 获取文件控件边框
  let rect = await comp.getBounds();
  // 计算文字控件高度
  let height = rect.bottom - rect.top;
  // 获取文字控件中心点
  let point: Point = await comp.getBoundsCenter();
  point = { x: point.x, y: point.y - height * offset };
  return point;
}

let driver = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // Defines a test suite. Two parameters are supported: test suite name and test suite function.
    beforeAll(async () => {
      const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
      let want: Want = {
        bundleName: 'com.sample.eventnotification',
        abilityName: 'EntryAbility',
        moduleName: 'entry'
      };
      delegator.startAbility(want);
      await sleep(1000);
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    })
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    })
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    })
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0100
     * @tc.name SUB_SAMPLE_NOTIFICATION_0100
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0100', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('请求通知授权'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('请求通知授权'));
        await box2.click();
        await sleep(1000);
        let box3: Component = await driver.findComponent(ON.text('允许'));
        await box3.click();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0200
     * @tc.name SUB_SAMPLE_NOTIFICATION_0200
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0200', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('取消通知授权'));
        await box1.click();
        await sleep(3000);
        let box3: Component = await driver.findComponent(ON.text('允许通知'));
        let point: Point = await getCenterPoint(box3, 0);
        await driver.click((await box3.getBounds()).right + 20, point.y);
        await sleep(3000);
        let box2: Component = await driver.findComponent(ON.text('确定'));
        await box2.click();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0300
     * @tc.name SUB_SAMPLE_NOTIFICATION_0300
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0300', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('再次申请通知授权'));
        await box1.click();
        await sleep(3000);
        let box3: Component = await driver.findComponent(ON.text('允许通知'));
        let point: Point = await getCenterPoint(box3, 0);
        await driver.click((await box3.getBounds()).right + 20, point.y);
        let box2: Component = await driver.findComponent(ON.text('确定'));
        await box2.click();
        await sleep(1000);
        await driver.pressBack();
        await sleep(3000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0400
     * @tc.name SUB_SAMPLE_NOTIFICATION_0400
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0400', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('管理通知角标'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('增加角标个数'));
        await box2.click();
        await sleep(1000);
        driver.pressHome(1);
        await sleep(3000);
        let box3: Component = await driver.findComponent(ON.text('Notification'));
        let point: Point = await getCenterPoint(box3, 2);
        driver.click(point.x, point.y);
        await sleep(3000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0500
     * @tc.name SUB_SAMPLE_NOTIFICATION_0500
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0500', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('减少角标个数'));
        await box1.click();
        await sleep(1000);
        driver.pressHome(1);
        await sleep(3000);
        let box3: Component = await driver.findComponent(ON.text('Notification'));
        let point: Point = await getCenterPoint(box3, 2);
        driver.click(point.x, point.y);
        await sleep(3000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0600
     * @tc.name SUB_SAMPLE_NOTIFICATION_0600
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0600', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('角标设置个数反例'));
        await box1.click();
        await sleep(1000);
        driver.pressHome(1);
        await sleep(3000);
        let box3: Component = await driver.findComponent(ON.text('Notification'));
        let point: Point = await getCenterPoint(box3, 2);
        driver.click(point.x, point.y);
        await sleep(3000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0700
     * @tc.name SUB_SAMPLE_NOTIFICATION_0700
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0700', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('角标设置个数正例'));
        await box1.click();
        await sleep(1000);
        driver.pressHome(1);
        await sleep(3000);
        let box3: Component = await driver.findComponent(ON.text('Notification'));
        let point: Point = await getCenterPoint(box3, 2);
        driver.click(point.x, point.y);
        await sleep(3000);
        driver.pressBack();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0800
     * @tc.name SUB_SAMPLE_NOTIFICATION_0800
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0800', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('管理通知渠道'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('创建指定类型的通知渠道'));
        await box2.click();
        await sleep(1000);
        let box3: Component = await driver.findComponent(ON.text('查询指定类型的通知渠道'));
        await box3.click();
        await sleep(1000);
        let box4: Component = await driver.findComponent(ON.text('删除指定类型的通知渠道'));
        await box4.click();
        await sleep(1000);
        driver.pressBack();
        await sleep(2000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_0900
     * @tc.name SUB_SAMPLE_NOTIFICATION_0900
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_0900', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('发布通知'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('发布普通文本类型通知'));
        await box2.click();
        await sleep(1000);
        driver.swipe(1, 1, 1, 500);
        await sleep(3000);
        driver.swipe(1, 500, 1, 1);
        await sleep(3000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1000
     * @tc.name SUB_SAMPLE_NOTIFICATION_1000
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1000', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('发布多行文本类型通知'));
        await box1.click();
        await sleep(1000);
        driver.swipe(1, 1, 1, 500);
        await sleep(5000);
        let box2: Component = await driver.findComponent(ON.text('test_title', MatchPattern.CONTAINS));
        await box2.click();
        await sleep(1000);
        driver.swipe(1, 500, 1, 1);
        await sleep(3000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1100
     * @tc.name SUB_SAMPLE_NOTIFICATION_1100
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1100', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('查询系统是否支持进度条模板'));
        await box1.click();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1200
     * @tc.name SUB_SAMPLE_NOTIFICATION_1200
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1200', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('发布进度条类型通知'));
        await box1.click();
        await sleep(1000);
        driver.swipe(1, 1, 1, 500);
        await sleep(3000);
        driver.swipe(1, 500, 1, 1);
        await sleep(3000);
        driver.pressBack();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1300
     * @tc.name SUB_SAMPLE_NOTIFICATION_1300
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1300', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('为通知添加行为意图'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('创建拉起UIAbility的WantAgent的WantAgentInfo信息'));
        await box2.click();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1400
     * @tc.name SUB_SAMPLE_NOTIFICATION_1400
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1400', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('创建发布公共事件的WantAgent的WantAgentInfo信息'));
        await box1.click();
        await sleep(1000);
        driver.pressBack();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1500
     * @tc.name SUB_SAMPLE_NOTIFICATION_1500
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1500', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('更新通知'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('发布进度条类型通知'));
        await box2.click();
        await sleep(1000);
        driver.swipe(1, 1, 1, 500);
        await sleep(2000);
        driver.swipe(1, 500, 1, 1);
        await sleep(2000);
        let box3: Component = await driver.findComponent(ON.text('更新通知'));
        await box3.click();
        await sleep(1000);
        driver.swipe(1, 1, 1, 500);
        await sleep(2000);
        driver.swipe(1, 500, 1, 1);
        await sleep(2000);
        driver.pressBack();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1600
     * @tc.name SUB_SAMPLE_NOTIFICATION_1600
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1600', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('取消通知'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('发布普通文本类型通知'));
        await box2.click();
        await sleep(1000);
        driver.swipe(1, 1, 1, 500);
        await sleep(2000);
        driver.swipe(1, 500, 1, 1);
        await sleep(2000);
        let box3: Component = await driver.findComponent(ON.text('取消通知'));
        await box3.click();
        await sleep(1000);
        driver.swipe(1, 1, 1, 500);
        await sleep(2000);
        driver.swipe(1, 500, 1, 1);
        await sleep(2000);
        driver.pressBack();
        await sleep(1000);
        done();
      })

    /**
     * @tc.number SUB_SAMPLE_NOTIFICATION_1700
     * @tc.name SUB_SAMPLE_NOTIFICATION_1700
     * @tc.desc Event notification sample warehouse and shared source document warehouse
     * @tc.size MediumTest
     * @tc.type Function
     * @tc.level Level 1
     */
    it('SUB_SAMPLE_NOTIFICATION_1700', Level.LEVEL1,
      async (done: Function) => {
        let box1: Component = await driver.findComponent(ON.text('清除跨设备场景下的重复通知'));
        await box1.click();
        await sleep(1000);
        let box2: Component = await driver.findComponent(ON.text('发布通知消息，通知消息中包含appMessageId字段'));
        await box2.click();
        await sleep(1000);
        driver.pressBack();
        await sleep(1000);
        done();
      })

  })
}