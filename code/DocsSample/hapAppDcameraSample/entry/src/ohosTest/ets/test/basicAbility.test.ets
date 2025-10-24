/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { describe, it, expect, TestType, beforeAll, afterAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, Component } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = "com.ohos.HapAppDcameraSample";
const TAG = "DCameraNewTest";
const PERMISSION_DIALOG_COUNT = 5;

let countBefore = 0;
let driver: Driver;
let context: Context;
// -----------------

function sleep(time: number) {
  return new Promise<void>((resolve: (value: void) => void) => setTimeout(resolve, time));
}

/**
 * 辅助函数：处理权限弹窗 (保持不变)
 */
async function handlePermissionDialogs(driver: Driver, count: number) {
  console.info(`${TAG}: 正在等待 ${count} 个权限弹窗...`);
  await sleep(2000); // 等待第一个弹窗

  for (let i = 1; i <= count; i++) {
    console.info(`${TAG}: 正在处理第 ${i}/${count} 个弹窗...`);
    let allowButton: Component | null = null;
    try {
      console.info(`${TAG}: ...正在查找 "允许" ...`);
      allowButton = await driver.findComponent(ON.text("允许"));
    } catch (err) {
      console.warn(`${TAG}: ...未找到 "允许", 尝试 "Allow"...`);
      try {
        allowButton = await driver.findComponent(ON.text("Allow"));
      } catch (err2) {
        console.error(`${TAG}: 既未找到 "允许" 也未找到 "Allow". 测试失败。`);
        throw new Error(`找不到第 ${i} 个权限弹窗的 '允许'/'Allow' 按钮。`);
      }
    }

    expect(allowButton).not().assertNull();
    await allowButton.click();
    console.info(`${TAG}: ...已点击第 ${i}/${count} 个按钮。`);
    await sleep(1000); // 等待下一个
  }
  console.info(`${TAG}: 所有 ${count} 个弹窗处理完毕。`);
}

export default function DCameraNewTest() {
  describe('DCameraNewTest', () => {

    // 1. 使用 beforeAll 在所有测试前启动一次应用
    beforeAll(async () => {
      console.info(`${TAG}: beforeAll: 启动应用...`);
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      driver = Driver.create();
      context = delegator.getAppContext();
      console.info(`${TAG}: beforeAll: 应用已启动，等待弹窗...`);
    });

    // 2. 使用 afterAll 在所有测试后清理一次
    afterAll(async () => {
      console.info(`${TAG}: afterAll: 按返回键退出应用。`);
      await driver.pressBack();
      console.info(`${TAG}: afterAll: 清理完毕。`);
    });

    /**
     * @tc.number: DCameraNewTest_001
     * @tc.name: test01_HandlePermissions
     * @tc.desc: 步骤 1: 处理所有 5 个权限弹窗
     * @tc.type: TestType.FUNCTION
     */
    it('test01_HandlePermissions', TestType.FUNCTION, async (done: () => void) => {
      console.info(`${TAG}: test01: 开始处理权限...`);
      await handlePermissionDialogs(driver, PERMISSION_DIALOG_COUNT);
      console.info(`${TAG}: test01: 权限处理完毕。`);
      done();
    });

    /**
     * @tc.number: DCameraNewTest_002
     * @tc.name: test02_ClickConnectRemote
     * @tc.desc: 步骤 2: 查找并点击 "Connect Remote" 按钮
     * @tc.type: TestType.FUNCTION
     */
    it('test02_ClickConnectRemote', TestType.FUNCTION, async (done: () => void) => {
      const buttonText = "Connect Remote";
      console.info(`${TAG}: test02: 正在查找 '${buttonText}'...`);

      // 等待权限弹窗完全消失，页面渲染出来
      await sleep(5000);
      const connectBtn = await driver.findComponent(ON.text(buttonText));
      expect(connectBtn).not().assertNull();

      await connectBtn.click();
      console.info(`${TAG}: test02: 已点击 '${buttonText}' (相机开始异步初始化)。`);
      await sleep(5000);
      done();
    });
  });
}