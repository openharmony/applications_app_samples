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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, it } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@kit.TestKit';
import { inputMethod } from '@kit.IMEKit';

const TAG = '[Sample_IPC]';
const BUNDLE = 'IPC_';
const DOMAIN = 0x0000;

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbilityFunction_001', 0, async (done:Function) => {
      hilog.info(DOMAIN, TAG, 'StartAbilityFunction_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.ipc_client',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (expection) {
        hilog.info(DOMAIN, TAG, `StartAbility end ${JSON.stringify(expection)}`);
        done();
      }
      hilog.info(DOMAIN, TAG, 'StartAbility_001 end');
    });

    /**
     * 检查页面
     */
    it(BUNDLE + 'CheckIndexPageFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'CheckIndexPage_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(10);

      await driver.assertComponentExist(ON.id('IPCproxy'));
      await driver.assertComponentExist(ON.id('SendParcelable'));
      await driver.assertComponentExist(ON.id('Parcelable'));
      await driver.assertComponentExist(ON.id('SendArrayBuffer'));
      await driver.assertComponentExist(ON.id('ArrayBuffer'));
      await driver.assertComponentExist(ON.id('Disconnect'));
      hilog.info(DOMAIN, TAG, 'CheckIndexPage_001 end');
    })

    /**
     * 连接服务端
     */
    it(BUNDLE + 'ProxyServiceFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'ProxyServiceFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'ProxyServiceFunction_001 clickProxy');
      // 点击发起连接
      await driver.assertComponentExist(ON.id('IPCproxy'));
      let btnConfirm = await driver.findComponent(ON.id('IPCproxy'));
      await btnConfirm.click();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, 'ProxyServiceFunction_001 end');
    })

    /**
     * 输入并发送Parcelable对象
     */
    it(BUNDLE + 'SendParcelableDataFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'SendParcelableDataFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);

      let ipAddress1 = await driver.findComponent(ON.id('Parcelable'));
      await ipAddress1.inputText('ipc');
      await driver.delayMs(1000);

      let inputMethodController1 = inputMethod.getController();
      inputMethodController1.stopInputSession();
      await driver.delayMs(1000);
      let SendParcelable = await driver.findComponent(ON.id('SendParcelable'));
      await SendParcelable.click();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, 'SendParcelableDataFunction_001 begin end');
    })

    /**
     * 输入并发送ArrayBuffer对象
     */
    it(BUNDLE + 'SendArrayBufferDataFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'SendArrayBufferDataFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);

      let ipAddress2 = await driver.findComponent(ON.id('ArrayBuffer'));
      await ipAddress2.inputText('ipc');
      await driver.delayMs(1000);
      // 停止会话,关闭键盘
      let inputMethodController2 = inputMethod.getController();
      inputMethodController2.stopInputSession();
      await driver.delayMs(1000);
      let SendArrayBuffer = await driver.findComponent(ON.id('SendArrayBuffer'));

      await SendArrayBuffer.click();
      await driver.delayMs(1000);

      hilog.info(DOMAIN, TAG, 'SendArrayBufferDataFunction_001 begin end');
    })

    /**
     * 断开连接
     */

    it(BUNDLE + 'DisconnectFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, 'DisconnectFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'DisconnectFunction_001 clickProxy');
      // 点击断开连接
      await driver.assertComponentExist(ON.id('Disconnect'));
      let btnConfirm = await driver.findComponent(ON.id('Disconnect'));
      await btnConfirm.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, 'ProxyServiceFunction_001 end');
    })

  })
}