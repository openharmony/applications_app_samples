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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Want from '@ohos.app.ability.Want';
import Base from '@ohos.base';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const BUNDLE = 'StageProcessThread_';
const TAG = 'abilityTest';
const DOMAIN_NUMBER: number = 0xFF00;
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function abilityTest() {
  let driver: Driver = Driver.create();
  describe('StageProcessThreadTest', () => {
    /**
     * @tc.number:StageProcessThreadTest_001
     * @tc.name: StageProcessThread_StartAbility_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试Ability是否被成功拉起
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'StartAbility_001, begin');
      // 启动时钟应用
      let want: Want = {
        bundleName: 'ohos.samples.etsclock',
        abilityName: 'MainAbility'
      };

      abilityDelegator.startAbility(want, (err: Base.BusinessError) => {
        hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'StartAbility_001 get err ' + JSON.stringify(err));
        expect(err).assertNull();
      });
      await sleep(2000);

      // 启动需要测试的应用
      let stageWant: Want = {
        bundleName: 'com.samples.stageprocessthread',
        abilityName: 'EntryAbility'
      };
      abilityDelegator.startAbility(stageWant, (err: Base.BusinessError) => {
        hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'StartAbility_001 get err ' + JSON.stringify(err));
        expect(err).assertNull();
      })
      await sleep(2000);
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'StartAbility_001 end');
      done();
    })

    /**
     * @tc.number:StageProcessThreadTest_002
     * @tc.name: StageProcessThread_ProcessModelTest_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试进程模型开发指导相关功能
     */
    it(BUNDLE + 'ProcessModelTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'ProcessModelTest_001, begin');
      // 跳转至‘进程模型开发指导界面’
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.process_button'))));
      let button = await driver.findComponent(ON.text(await getResourceString($r('app.string.process_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }

      // 测试订阅灭屏公共事件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.subscribe_button'))));
      let subscribeBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.subscribe_button'))));
      if (button !== null) {
        await subscribeBtn.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.subscribe_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);
      
      // 测试发布灭屏公共事件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.publish_noinfo_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.publish_noinfo_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.public_event_null'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.publish_haveinfo_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.publish_haveinfo_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.public_event_initial'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      // 测试取消订阅灭屏公共事件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.unsubscribe_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.unsubscribe_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.unsubscribe_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      // 测试发布粘性灭屏公共事件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.publish_sticky_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.publish_sticky_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.publish_sticky_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      // 测试接收粘性灭屏公共事件
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.subscribe_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.public_event_sticky'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      // 测试移除粘性灭屏公共事件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.remove_sticky_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.remove_sticky_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.remove_sticky_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.unsubscribe_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.unsubscribe_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.subscribe_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.subscribe_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1500);

      // 通过滑动事件进入控制中心
      await driver.fling({
        x: 400, y: 0
      }, {
        x: 400, y: 200
      }, 100, 200);
      await sleep(500);
      // 获取'飞行模式'文字位置
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.airplane_mode'))));
      let text = await driver.findComponent(ON.text(await getResourceString($r('app.string.airplane_mode'))));
      let rect = await text.getBounds();
      // 根据'飞行模式'文字位置计算飞行模式图标位置并点击
      let x = rect.left + 40;
      let y = rect.top - 40;
      await driver.click(x, y);
      await sleep(1500);
      // 退出控制中心
      await driver.fling({
        x: 400, y: 200
      }, {
        x: 400, y: 0
      }, 100, 200);
      await sleep(500);

      // 返回至主页
      await driver.pressBack();
      await sleep(500);
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'ProcessModelTest_001, end');
      done();
    })

    /**
     * @tc.number:StageProcessThreadTest_003
     * @tc.name: StageProcessThread_ThreadModelTest_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试线程模型开发指导相关功能
     */
    it(BUNDLE + 'ThreadModelTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'ThreadModelTest_001, begin');

      // 跳转至‘线程模型开发指导界面’
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.thread_button'))));
      let button = await driver.findComponent(ON.text(await getResourceString($r('app.string.thread_button'))));
      if (button !== null) {
        await button.click();
        await sleep(1000);
      }

      // 测试使用Emitter订阅事件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.emitter_subscribe_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.emitter_subscribe_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.emitter_subscribe_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试使用Emitter发送事件
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.emitter_sending_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.emitter_sending_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.data_emitter'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试使用worker进行线程间通信
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.worker_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.worker_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.data_worker'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 返回至主页
      await driver.pressBack();
      await sleep(500);
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'ThreadModelTest_001, end');
      done();
    })

    /**
     * @tc.number:StageProcessThreadTest_004
     * @tc.name: StageProcessThread_TaskManagerTest_001
     * @tc.size: MediumTest
     * @tc.type: Function
     * @tc.level Level 1
     * @tc.desc: 测试任务管理开发指导相关功能
     */
    it(BUNDLE + 'TaskManagerTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'TaskManagerTest_001, begin');

      // 跳转至‘任务管理开发指导界面’
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.taskmanager_button'))));
      let button = await driver.findComponent(ON.text(await getResourceString($r('app.string.taskmanager_button'))));
      if (button !== null) {
        await button.click();
        await sleep(1000);
      }

      // 测试注册任务变化通知
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.register_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.register_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.register_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试获取系统最近任务
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.obtain_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.obtain_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.obtain_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试获取单个任务的详细信息
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.obtain_one_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.obtain_one_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.detail_info'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试获取单个任务的任务快照
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.obtain_snapshot_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.obtain_snapshot_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.obtain_snapshot_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.obtain_low_snapshot_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.obtain_low_snapshot_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.obtain_low_snapshot_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试单个任务加锁
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.lock_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.lock_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.lock_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试单个任务解锁
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.unlock_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.unlock_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.unlock_success_toast'))))
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 测试单个任务切到前台
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.front_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.front_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
      }
      await sleep(1000);

      // 回到桌面
      await driver.pressHome();
      await sleep(2500);

      // 点击测试应用图标回到测试应用
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.EntryAbility_label'))));
      let app = await driver.findComponent(ON.text(await getResourceString($r('app.string.EntryAbility_label'))));
      if (app !== null) {
        await app.click();
        await sleep(500);
      }
      await sleep(1000);

      // 测试删除单个任务
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.delete_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.delete_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.delete_success_toast'))));
        expect(result != null).assertTrue();
      }
      await sleep(1000);

      // 向上滑动屏幕
      await driver.fling({
        x: 400, y: 500
      }, {
        x: 400, y: 300
      }, 100, 200);

      // 测试解注册任务变化通知
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.unregister_button'))));
      button = await driver.findComponent(ON.text(await getResourceString($r('app.string.unregister_button'))));
      if (button !== null) {
        await button.click();
        await sleep(500);
        let result = await driver.findComponent(ON.text(await getResourceString($r('app.string.unregister_success_toast'))));
        expect(result != null).assertTrue();
      }
      hilog.info(DOMAIN_NUMBER, TAG, BUNDLE + 'TaskManagerTest_001, end');
      done();
    })
  })
}