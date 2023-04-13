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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';

const TAG = '[Sample_Process]';
const DOMAIN = 0xF811;
const BUNDLE = 'Process_';
const DRIVER = Driver.create();

export default function appTest() {
  describe('abilityTest', function () {

    /**
     * StartAbility
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: "ohos.samples.process",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      }
    })

    /**
     * GetUptime
     */
    it(BUNDLE + 'GetUptimeFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 begin');
      await DRIVER.delayMs(1000);
      // 获取当前系统运行时间
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 getUptime');
      await DRIVER.assertComponentExist(ON.id('getUptime'));
      let getUptime = await DRIVER.findComponent(ON.id('getUptime'));
      await getUptime.click();
      await DRIVER.delayMs(1000);
      let result = await DRIVER.findComponent(ON.id('result'));
      let resultText = await result.getText();
      expect(resultText).assertContain('s');
      hilog.info(DOMAIN, TAG, BUNDLE + 'ProcessFunction_001 end');
    })

    /**
     * GetDirectory
     */
    it(BUNDLE + 'GetDirectoryFunction_001', 0, async function () {
      // 获取进程当前工作目录
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetDirectoryFunction_001');
      await DRIVER.assertComponentExist(ON.id('getDirectory'));
      let getDirectory = await DRIVER.findComponent(ON.id('getDirectory'));
      await getDirectory.click();
      await DRIVER.delayMs(1000);
      let result = await DRIVER.findComponent(ON.id('result'));
      let resultText = await result.getText();
      expect(resultText).assertEqual('/');
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetDirectoryFunction_001 end');
    })

    /**
     * ChangeDirectory
     */
    it(BUNDLE + 'ChangeDirectoryFunction_001', 0, async function () {
      // 更改进程当前工作目录
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChangeDirectoryFunction_001');
      await DRIVER.assertComponentExist(ON.id('changeDirectory'));
      let changeDirectory = await DRIVER.findComponent(ON.id('changeDirectory'));
      await changeDirectory.click();
      await DRIVER.delayMs(1000);
      let result = await DRIVER.findComponent(ON.id('result'));
      let resultText = await result.getText();
      expect(resultText).assertEqual('/system');
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChangeDirectoryFunction_001 end');
    })

    /**
     * GetDirectory
     */
    it(BUNDLE + 'GetDirectoryFunction_002', 0, async function () {
      // 获取进程当前工作目录
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetDirectoryFunction_002');
      await DRIVER.assertComponentExist(ON.id('getDirectory'));
      let getDirectory = await DRIVER.findComponent(ON.id('getDirectory'));
      await getDirectory.click();
      await DRIVER.delayMs(1000);
      let result = await DRIVER.findComponent(ON.id('result'));
      let resultText = await result.getText();
      expect(resultText).assertEqual('/system');
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetDirectoryFunction_002 end');
    })

    /**
     * SendSignal
     */
    it(BUNDLE + 'SendSignalFunction_001', 0, async function () {
      // 发送signal到指定的进程
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendSignalFunction_001');
      await DRIVER.assertComponentExist(ON.id('sendSignal'));
      let sendSignal = await DRIVER.findComponent(ON.id('sendSignal'));
      await sendSignal.click();
      await DRIVER.delayMs(1000);
      let result = await DRIVER.findComponent(ON.id('result'));
      let resultText = await result.getText();
      expect(resultText).assertEqual('succeed');
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendSignalFunction_001 end');
    })

    /**
     * StartProcess
     */
    it(BUNDLE + 'StartProcessFunction_001', 0, async function () {
      // 启动一个子进程
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartProcessFunction_001');
      await DRIVER.assertComponentExist(ON.id('startProcess'));
      let startProcess = await DRIVER.findComponent(ON.id('startProcess'));
      await startProcess.click();
      await DRIVER.delayMs(1000);
      let result = await DRIVER.findComponent(ON.id('result'));
      let resultText = await result.getText();
      expect(resultText).assertEqual('child process run finish0');
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartProcessFunction_001 end');
    })

    /**
     * CloseProcess
     */
    it(BUNDLE + 'CloseProcessFunction_001', 0, async function () {
      // 关闭一个子进程
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseProcessFunction_001');
      await DRIVER.assertComponentExist(ON.id('closeProcess'));
      let startProcess = await DRIVER.findComponent(ON.id('closeProcess'));
      await startProcess.click();
      await DRIVER.delayMs(1000);
      let result = await DRIVER.findComponent(ON.id('result'));
      let resultText = await result.getText();
      expect(resultText).assertEqual('close succeed');
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseProcessFunction_001 end');
    })

    /**
     * CloseApp
     */
    it(BUNDLE + 'CloseAppFunction_001', 0, async function () {
      // 退出当前系统
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseAppFunction_001');
      await DRIVER.assertComponentExist(ON.id('exitProcess'));
      let startProcess = await DRIVER.findComponent(ON.id('exitProcess'));
      await startProcess.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text('相机'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'CloseAppFunction_001 end');
    })
  })
}