/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import Want from '@ohos.app.ability.Want';
import featureAbility from '@ohos.ability.featureAbility'
import Base from '@ohos.base';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const BUNDLE = 'FAModelAbilityDevelop_';
const TAG = 'abilityTest';
const domain: number = 0xF811;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function abilityTest() {
  let driver = Driver.create();
  describe('FAModelAbilityDevelopTest', () => {
    /**
     * @tc.number:FAModelAbilityDevelopTest_001
     * @tc.name: FAModelAbilityDevelop_StartAbility_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试Ability是否被成功拉起
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'StartAbility_001, begin');
      // 启动需要测试的应用
      let want: Want = {
        bundleName: 'com.samples.famodelabilitydevelop',
        abilityName: 'com.samples.famodelabilitydevelop.MainAbility'
      };
      featureAbility.startAbility({
        want: want
      }, (err: Base.BusinessError) => {
        hilog.info(domain, TAG, BUNDLE + 'StartAbility_001 get err ' + JSON.stringify(err));
        expect(0).assertEqual(err.code);
      })
      await sleep(1000);
      hilog.info(domain, TAG, BUNDLE + 'StartAbility_001 end');
      done();
    })

    /**
     * @tc.number:FAModelAbilityDevelopTest_002
     * @tc.name: FAModelAbilityDevelop_PageAbility_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试PageAbility相关功能
     */
    it(BUNDLE + 'PageAbility_001', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'PageAbility_001, begin');

      // 跳转至'PageAbility组件开发指导-单设备'界面, fa模型不支持资源本地化，故用中文
      let button = await driver.findComponent(ON.text('单设备'));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }

      // 测试获取分布式目录
      button = await driver.findComponent(ON.text('获取分布式目录'));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text('/data/storage/el2/distributedfiles'));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试启动单例PageAbility
      button = await driver.findComponent(ON.text('启动单例PageAbility'));
      if (button !== null) {
        await button.click();
        await sleep(2000);
        await driver.assertComponentExist(ON.text('PageAbilitySingleton页面一'));
      }
      await sleep(2000);

      // 回到桌面
      await driver.pressHome();
      await sleep(2000);
      // 点击测试应用图标回到测试应用
      let app = await driver.findComponent(ON.text('FAModel'));
      if (app !== null) {
        await app.click();
        await sleep(500);
      }
      await sleep(2000)

      // 测试再启动单例PageAbility
      button = await driver.findComponent(ON.text('再启动单例PageAbility'));
      if (button !== null) {
        await button.click();
        await sleep(2000);
        await driver.assertComponentExist(ON.text('PageAbilitySingleton页面二'));
      }
      await sleep(2000);

      // 回到桌面
      await driver.pressHome();
      await sleep(2000);
      // 点击测试应用图标回到测试应用
      app = await driver.findComponent(ON.text('FAModel'));
      if (app !== null) {
        await app.click();
        await sleep(500);
      }
      await sleep(1000)

      // 测试启动多例PageAbility页面一
      button = await driver.findComponent(ON.text('启动多例PageAbility页面一'));
      if (button !== null) {
        await button.click();
        await sleep(1000);
        await driver.assertComponentExist(ON.text('PageAbilityStandard页面一'));
      }
      await sleep(1000);

      // 回到桌面
      await driver.pressHome();
      await sleep(2000);
      // 点击测试应用图标回到测试应用
      app = await driver.findComponent(ON.text('FAModel'));
      if (app !== null) {
        await app.click();
        await sleep(500);
      }
      await sleep(2000)

      // 测试启动多例PageAbility页面二
      button = await driver.findComponent(ON.text('启动多例PageAbility页面二'));
      if (button !== null) {
        await button.click();
        await sleep(1000);
        await driver.assertComponentExist(ON.text('PageAbilityStandard页面二'));
      }
      await sleep(500);

      // 回到桌面
      await driver.pressHome();
      await sleep(2000);

      // 点击测试应用图标回到测试应用
      app = await driver.findComponent(ON.text('FAModel'));
      if (app !== null) {
        await app.click();
        await sleep(500);
      }
      await sleep(2000)

      // 测试使用worker进行线程间通信
      button = await driver.findComponent(ON.text('使用Worker进行线程间通信'));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text('{"data":"message from worker thread."}'));
        expect(result != null).assertTrue();
      }
      await sleep(2000);

      // 测试停止PageAbility
      button = await driver.findComponent(ON.text('停止PageAbility'));
      if (button !== null) {
        await button.click();
        await sleep(1000);
      }
      await sleep(500);

      // 点击测试应用图标回到测试应用
      app = await driver.findComponent(ON.text('FAModel'));

      if (app !== null) {
        await app.click();
        await sleep(500);
      }
      await sleep(1000)

      hilog.info(domain, TAG, BUNDLE + 'PageAbility_001 end');
      done();
    })

    /**
     * @tc.number:FAModelAbilityDevelopTest_003
     * @tc.name: FAModelAbilityDevelop_ServiceAbility_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试ServiceAbility组件开发指导相关功能
     */
    it(BUNDLE + 'ServiceAbility_001', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'ServiceAbility_001, begin');

      // 跳转至'ServiceAbility组件开发指导'
      let button = await driver.findComponent(ON.text('ServiceAbility组件开发指导'));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }

      // 测试启动ServiceAbility
      button = await driver.findComponent(ON.text('启动ServiceAbility'));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text('启动serviceAbility成功'));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试连接ServiceAbility
      button = await driver.findComponent(ON.text('连接ServiceAbility'));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text('连接serviceAbility成功'));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试连接错误的ServiceAbility
      button = await driver.findComponent(ON.text('连接错误的ServiceAbility'));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text('连接serviceAbility失败'));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 返回至主页
      await driver.pressBack();
      await sleep(500);
      hilog.info(domain, TAG, BUNDLE + 'ServiceAbility_001, end');
      done();
    })

    /**
     * @tc.number:FAModelAbilityDevelopTest_004
     * @tc.name: FAModelAbilityDevelop_DataAbility_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试DataAbility组件开发指导相关功能
     */
    it(BUNDLE + 'DataAbility_001', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'DataAbility_001, begin');

      // 跳转至'DataAbility组件开发指导'
      let button = await driver.findComponent(ON.text('DataAbility组件开发指导'));
      if (button !== null) {
        await button.click();
        await sleep(1500);
      }

      button = await driver.findComponent(ON.text('允许'));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }

      // 测试插入数据
      await driver.click(300.000000, 306.000000);
      let insertCallResult = await driver.findComponent(ON.text('插入数据成功'));
      expect(insertCallResult != null).assertTrue();
      await sleep(2000);
      await driver.click(300.000000, 400.000000);
      let insertPromiseResult = await driver.findComponent(ON.text('插入数据成功'));
      expect(insertPromiseResult != null).assertTrue();
      await sleep(2000);

      // 测试删除数据
      await driver.click(300.000000, 550.000000);
      let deleteCallResult = await driver.findComponent(ON.text('删除数据成功'));
      expect(deleteCallResult != null).assertTrue();
      await sleep(2000);
      await driver.click(300.000000, 632.000000);
      let deletePromiseResult = await driver.findComponent(ON.text('删除数据成功'));
      expect(deletePromiseResult != null).assertTrue();
      await sleep(2000);

      // 测试更新数据
      await driver.click(300.000000, 800.000000);
      let updateCallResult = await driver.findComponent(ON.text('更新数据成功'));
      expect(updateCallResult != null).assertTrue();
      await sleep(2000);
      await driver.click(300.000000, 900.000000);
      let updatePromiseResult = await driver.findComponent(ON.text('更新数据成功'));
      expect(updatePromiseResult != null).assertTrue();
      await sleep(2000);


      // 测试查找数据
      await driver.click(300.000000, 1053.000000);
      let searchCallResult = await driver.findComponent(ON.text('查找数据成功'));
      expect(searchCallResult != null).assertTrue();
      await sleep(2000);
      await driver.click(300.000000, 1163.000000);
      let searchPromiseResult = await driver.findComponent(ON.text('查找数据成功'));
      expect(searchPromiseResult != null).assertTrue();
      await sleep(3000);

      //滑动屏幕
      await driver.swipe(400, 900, 400, 500);
      await sleep(3000);

      // 测试批量插入数据
      await driver.click(300.000000, 838.000000);
      let allInsertCallResult = await driver.findComponent(ON.text('批量插入数据成功'));
      expect(allInsertCallResult != null).assertTrue();
      await sleep(2000);
      await driver.click(300.000000, 922.000000);
      let allInsertPromiseResult = await driver.findComponent(ON.text('批量插入数据成功'));
      expect(allInsertPromiseResult != null).assertTrue();
      await sleep(2000);

      // 测试批量处理数据
      await driver.click(300.000000, 1104.000000);
      let allUpdateCallResult = await driver.findComponent(ON.text('批量处理数据成功'));
      expect(allUpdateCallResult != null).assertTrue();
      await sleep(2000);
      await driver.click(300.000000, 1183.000000);
      let allUpdatePromiseResult = await driver.findComponent(ON.text('批量处理数据成功'));
      expect(allUpdatePromiseResult != null).assertTrue();
      await sleep(2000);

      // 返回至主页
      await driver.pressBack();
      await sleep(500);
      hilog.info(domain, TAG, BUNDLE + 'DataAbility_001, end');
      done();
    })

    /**
     * @tc.number:FAModelAbilityDevelopTest_005
     * @tc.name: FAModelAbilityDevelop_InterflowFaAndStage_001
     * @tc.type: 0 || TestType.FUNCTION || Size.SMALLTEST || Level.LEVEL0
     * @tc.desc: 测试FA模型与Stage模型应用组件互通指导相关功能
     */
    it(BUNDLE + 'InterflowFaAndStage_001', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'InterflowFaAndStage_001, begin');
      // 跳转至'FA模型与Stage模型应用组件互通指导'
      let button = await driver.findComponent(ON.text('FA模型与Stage模型应用组件互通指导'));
      if (button !== null) {
        await button.click();
        await sleep(1000);
      }

      // 测试通过PageAbility启动UIAbility-无需返回结果
      button = await driver.findComponent(ON.text('通过PageAbility与Stage模型互通-无需返回结果'));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }
      await sleep(1000);

      // 返回至FA模型与Stage模型应用组件互通指导页面
      await driver.pressBack();
      await sleep(1000);

      // 测试通过PageAbility启动UIAbility-返回执行结果
      button = await driver.findComponent(ON.text('通过PageAbility与Stage模型互通-返回执行结果'));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }
      await sleep(1000);

      // 返回至FA模型与Stage模型应用组件互通指导页面
      await driver.pressBack();
      await sleep(1000);

      // 测试通过ServiceAbility启动UIAbility
      button = await driver.findComponent(ON.text('通过ServiceAbility与Stage模型互通'));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }
      await sleep(1000);

      hilog.info(domain, TAG, BUNDLE + 'InterflowFaAndStage_001, end');
      done();
    })

    /**
     * @tc.number:FAModelAbilityDevelopTest_006
     * @tc.name: FAModelAbilityDevelop_FAServiceCard_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试FA模型服务卡片相关功能
     */
    it(BUNDLE + 'FAServiceCard_001', 0, async (done: Function) => {
      hilog.info(domain, TAG, BUNDLE + 'FAServiceCard_001, begin');
      // 回到桌面
      await driver.pressHome();
      await sleep(1000);

      // 添加服务卡片
      let app = await driver.findComponent(ON.text('FAModel'))
      if (app !== null) {
        // 获取应用图标位置并长按
        let rect = await app.getBounds();
        let height = rect.bottom - rect.top;
        let point = await app.getBoundsCenter();
        await driver.longClick(point.x, point.y - height);
        hilog.info(domain, TAG, BUNDLE + `FAServiceCard_001 long click app, coordinate:(${point.x},` + `${point.y - height})`);
        await sleep(500);
      }
      let service_card = await driver.findComponent(ON.text('服务卡片'));
      await service_card.click();
      await sleep(1000);
      let addForm = await driver.findComponent(ON.text('添加到桌面'));
      await addForm.click();
      await sleep(1000);

      // 获取卡片位置
      let apps = await driver.findComponents(ON.text('FAModel'));
      let rect = await apps[apps.length - 1].getBounds();
      let point = await apps[apps.length - 1].getBoundsCenter();
      hilog.info(domain, TAG, BUNDLE + `FAServiceCard_001 card rect:` + JSON.stringify(rect));

      // 点击title跳转至应用界面
      await driver.click(point.x, point.y - 80);
      hilog.info(domain, TAG, BUNDLE + `FAServiceCard_001 click:${point.x} : ${point.y - 80}`);
      await sleep(2000);
      await driver.assertComponentExist(ON.text('FA模型与Stage模型应用组件互通指导'));

      // 返回至桌面
      await driver.pressHome();
      await sleep(500);

      // 点击detail更新服务卡片
      await driver.click(point.x, point.y - 40);
      hilog.info(domain, TAG, BUNDLE + `FAServiceCard_001 click:${point.x} : ${point.y - 40}`);

      hilog.info(domain, TAG, BUNDLE + 'FAServiceCard_001, end');
      done();
    })
  })
}