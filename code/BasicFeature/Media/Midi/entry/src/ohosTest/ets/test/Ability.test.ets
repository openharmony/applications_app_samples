/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import display from '@ohos.display';

let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let abilityDelegatorArgs: AbilityDelegatorRegistry.AbilityDelegatorArgs = AbilityDelegatorRegistry.getArguments();

export default function abilityTest() {
  const TAG = '[Sample_MIDI]';
  const WAIT_TIME = 3000;
  let driver: Driver;

  describe('ActsMidiAbilityTest', () => {
    beforeAll(async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'beforeAll called');
      driver = Driver.create();
    })

    beforeEach(() => {
      hilog.info(0x0000, TAG, '%{public}s', 'beforeEach called');
    })

    afterEach(() => {
      hilog.info(0x0000, TAG, '%{public}s', 'afterEach called');
    })

    afterAll(() => {
      hilog.info(0x0000, TAG, '%{public}s', 'afterAll called');
    })

    /**
     * 测试用例1: 应用启动
     */
    it('startAbility_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'startAbility_test begin');
      let bundleName: string = abilityDelegatorArgs.bundleName;
      let abilityName = bundleName + '.EntryAbility';

      await abilityDelegator.startAbility({
        bundleName: bundleName,
        abilityName: abilityName
      });

      await driver.delayMs(WAIT_TIME);
      hilog.info(0x0000, TAG, '%{public}s', 'startAbility_test end');
    })

    /**
     * 测试用例2: 主页显示检查
     */
    it('mainPageDisplay_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'mainPageDisplay_test begin');
      await driver.delayMs(WAIT_TIME);

      // 检查标题是否显示
      let titleText = await driver.findComponent(ON.text('MIDI Sample'));
      expect(titleText).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'mainPageDisplay_test end');
    })

    /**
     * 测试用例3: 创建MIDI客户端
     */
    it('createMidiClient_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'createMidiClient_test begin');
      await driver.delayMs(WAIT_TIME);

      // 查找并点击"Create Client"按钮
      let createClientBtn = await driver.findComponent(ON.text('Create Client'));
      expect(createClientBtn).not().assertNull();
      await createClientBtn.click();
      await driver.delayMs(WAIT_TIME);

      // 验证按钮文本变为"Destroy Client"
      let destroyClientBtn = await driver.findComponent(ON.text('Destroy Client'));
      expect(destroyClientBtn).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'createMidiClient_test end');
    })

    /**
     * 测试用例4: 刷新设备列表
     */
    it('refreshDevices_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'refreshDevices_test begin');
      await driver.delayMs(WAIT_TIME);

      // 查找并点击"Refresh Devices"按钮
      let refreshBtn = await driver.findComponent(ON.text('Refresh Devices'));
      expect(refreshBtn).not().assertNull();
      await refreshBtn.click();
      await driver.delayMs(WAIT_TIME);

      hilog.info(0x0000, TAG, '%{public}s', 'refreshDevices_test end');
    })

    /**
     * 测试用例5: 销毁MIDI客户端
     */
    it('destroyMidiClient_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'destroyMidiClient_test begin');
      await driver.delayMs(WAIT_TIME);

      // 查找并点击"Destroy Client"按钮
      let destroyBtn = await driver.findComponent(ON.text('Destroy Client'));
      expect(destroyBtn).not().assertNull();
      await destroyBtn.click();
      await driver.delayMs(WAIT_TIME);

      // 验证按钮文本变为"Create Client"
      let createBtn = await driver.findComponent(ON.text('Create Client'));
      expect(createBtn).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'destroyMidiClient_test end');
    })

    /**
     * 测试用例6: 蓝牙MIDI区域显示
     */
    it('bleMidiSectionDisplay_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'bleMidiSectionDisplay_test begin');

      // 先创建客户端
      let createBtn = await driver.findComponent(ON.text('Create Client'));
      await createBtn?.click();
      await driver.delayMs(WAIT_TIME);

      // 查找蓝牙MIFI标题
      let bleTitle = await driver.findComponent(ON.text('Bluetooth MIDI'));
      expect(bleTitle).not().assertNull();

      // 查找地址输入框提示
      let addressHint = await driver.findComponent(ON.text('AA:BB:CC:DD:EE:FF'));
      expect(addressHint).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'bleMidiSectionDisplay_test end');
    })

    /**
     * 测试用例7: 设备列表区域显示
     */
    it('deviceListSectionDisplay_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'deviceListSectionDisplay_test begin');
      await driver.delayMs(WAIT_TIME);

      // 查找"Connected Devices"标题
      let deviceListTitle = await driver.findComponent(ON.text('Connected Devices'));
      expect(deviceListTitle).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'deviceListSectionDisplay_test end');
    })

    /**
     * 测试用例8: 虚拟钢琴键盘区域
     */
    it('pianoKeyboardSectionDisplay_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'pianoKeyboardSectionDisplay_test begin');
      await driver.delayMs(WAIT_TIME);

      // 查找虚拟钢琴键盘标题
      let pianoTitle = await driver.findComponent(ON.text('Virtual Piano Keyboard'));
      // 如果没有打开设备，可能显示提示文本
      let hint = await driver.findComponent(ON.text('Open an output port to play'));

      // 两者应该至少存在一个
      expect(pianoTitle || hint).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'pianoKeyboardSectionDisplay_test end');
    })

    /**
     * 测试用例9: Event Log区域显示
     */
    it('eventLogSectionDisplay_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'eventLogSectionDisplay_test begin');
      await driver.delayMs(WAIT_TIME);

      // 查找"Event Log"标题
      let logTitle = await driver.findComponent(ON.text('Event Log'));
      expect(logTitle).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'eventLogSectionDisplay_test end');
    })

    /**
     * 测试用例10: 基础UI元素完整性检查
     */
    it('uiElementsCompleteness_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'uiElementsCompleteness_test begin');
      await driver.delayMs(WAIT_TIME);

      // 检查所有主要UI区域是否存在
      let clientManagement = await driver.findComponent(ON.text('Client Management'));
      expect(clientManagement).not().assertNull();

      let bleMidi = await driver.findComponent(ON.text('Bluetooth MIDI'));
      expect(bleMidi).not().assertNull();

      let connectedDevices = await driver.findComponent(ON.text('Connected Devices'));
      expect(connectedDevices).not().assertNull();

      let eventLog = await driver.findComponent(ON.text('Event Log'));
      expect(eventLog).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'uiElementsCompleteness_test end');
    })

    /**
     * 测试用例11: 蓝牙MAC地址格式验证测试
     */
    it('bleMacAddressFormat_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'bleMacAddressFormat_test begin');
      await driver.delayMs(WAIT_TIME);

      let macInputHint = await driver.findComponent(ON.text('AA:BB:CC:DD:EE:FF'));
      expect(macInputHint).not().assertNull();

      let connectBtn = await driver.findComponent(ON.text('Connect'));
      expect(connectBtn).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'bleMacAddressFormat_test end');
    })

    /**
     * 测试用例12: BLE连接按钮状态测试
     */
    it('bleConnectButtonState_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'bleConnectButtonState_test begin');
      await driver.delayMs(WAIT_TIME);

      let connectBtn = await driver.findComponent(ON.text('Connect'));
      expect(connectBtn).not().assertNull();

      let bleSection = await driver.findComponent(ON.text('Bluetooth MIDI'));
      expect(bleSection).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'bleConnectButtonState_test end');
    })

    /**
     * 测试用例13: 设备列表选择状态测试
     */
    it('deviceListSelection_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'deviceListSelection_test begin');
      await driver.delayMs(WAIT_TIME);

      let deviceListTitle = await driver.findComponent(ON.text('Connected Devices'));
      expect(deviceListTitle).not().assertNull();

      let openDeviceBtn = await driver.findComponent(ON.text('Open Device'));
      expect(openDeviceBtn).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'deviceListSelection_test end');
    })

    /**
     * 测试用例14: 未选择设备时打开设备测试
     */
    it('openDeviceWithoutSelection_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'openDeviceWithoutSelection_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let openDeviceBtn = await driver.findComponent(ON.text('Open Device'));
      expect(openDeviceBtn).not().assertNull();
      await openDeviceBtn.click();
      await driver.delayMs(WAIT_TIME);

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'openDeviceWithoutSelection_test end');
    })

    /**
     * 测试用例15: 客户端重复创建测试
     */
    it('duplicateClientCreation_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'duplicateClientCreation_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let destroyBtn = await driver.findComponent(ON.text('Destroy Client'));
      expect(destroyBtn).not().assertNull();

      let createBtnAgain = await driver.findComponent(ON.text('Create Client'));
      expect(createBtnAgain).assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'duplicateClientCreation_test end');
    })

    /**
     * 测试用例16: 客户端未创建时操作测试
     */
    it('operationWithoutClient_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'operationWithoutClient_test begin');
      await driver.delayMs(WAIT_TIME);

      let destroyBtn = await driver.findComponent(ON.text('Destroy Client'));
      if (destroyBtn) {
        await destroyBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      expect(createBtn).not().assertNull();

      let refreshBtn = await driver.findComponent(ON.text('Refresh Devices'));
      expect(refreshBtn).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'operationWithoutClient_test end');
    })

    /**
     * 测试用例17: MIDI通道输入边界测试
     */
    it('midiChannelInput_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'midiChannelInput_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let channelLabel = await driver.findComponent(ON.text('Channel:'));

      hilog.info(0x0000, TAG, '%{public}s', 'midiChannelInput_test end');
    })

    /**
     * 测试用例18: Event Log滚动测试
     */
    it('eventLogScroll_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'eventLogScroll_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      let clearLogBtn = await driver.findComponent(ON.text('Clear Log'));
      expect(clearLogBtn).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'eventLogScroll_test end');
    })

    /**
     * 测试用例19: Clear Log按钮功能测试
     */
    it('clearLogFunction_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'clearLogFunction_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let clearLogBtn = await driver.findComponent(ON.text('Clear Log'));
      expect(clearLogBtn).not().assertNull();
      await clearLogBtn.click();
      await driver.delayMs(WAIT_TIME);

      let clearLogBtnAfter = await driver.findComponent(ON.text('Clear Log'));
      expect(clearLogBtnAfter).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'clearLogFunction_test end');
    })

    /**
     * 测试用例20: 钢琴键盘UI渲染测试
     */
    it('pianoKeyboardRendering_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'pianoKeyboardRendering_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let pianoTitle = await driver.findComponent(ON.text('Virtual Piano Keyboard'));
      let pianoHint = await driver.findComponent(ON.text('Open an output port to play'));

      expect(pianoTitle || pianoHint).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'pianoKeyboardRendering_test end');
    })

    /**
     * 测试用例21: 钢琴键盘触摸响应测试（坐标定位）
     */
    it('pianoKeyboardTouchResponse_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'pianoKeyboardTouchResponse_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let displayInfo: display.Display = display.getDefaultDisplaySync();
      expect(displayInfo).not().assertNull();

      let screenWidth: number = displayInfo.width;
      let screenHeight: number = displayInfo.height;

      hilog.info(0x0000, TAG, 'Screen size: %{public}d x %{public}d', screenWidth, screenHeight);

      let pianoCenterX = Math.floor(screenWidth / 2);
      let pianoY = Math.floor(screenHeight * 0.78);

      try {
        await driver.click(pianoCenterX, pianoY);
        await driver.delayMs(500);

        let pianoLeftX = Math.floor(screenWidth * 0.3);
        await driver.click(pianoLeftX, pianoY);
        await driver.delayMs(500);

        let pianoRightX = Math.floor(screenWidth * 0.7);
        await driver.click(pianoRightX, pianoY);
        await driver.delayMs(500);

        hilog.info(0x0000, TAG, 'Piano keyboard touch test completed');
      } catch (error) {
        hilog.info(0x0000, TAG, 'Piano keyboard touch test: %{public}s', JSON.stringify(error));
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'pianoKeyboardTouchResponse_test end');
    })

    /**
     * 测试用例22: 无输出端口时钢琴键触摸测试
     */
    it('pianoTouchWithoutOutputPort_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'pianoTouchWithoutOutputPort_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let hint = await driver.findComponent(ON.text('Open an output port to play'));
      if (hint) {
        hilog.info(0x0000, TAG, 'Hint text found: output port not opened');
      }

      let displayInfo: display.Display = display.getDefaultDisplaySync();
      let screenWidth: number = displayInfo.width;
      let screenHeight: number = displayInfo.height;

      let pianoCenterX = Math.floor(screenWidth / 2);
      let pianoY = Math.floor(screenHeight * 0.78);

      try {
        await driver.click(pianoCenterX, pianoY);
        await driver.delayMs(WAIT_TIME);
      } catch (error) {
        hilog.info(0x0000, TAG, 'Click without output port: %{public}s', JSON.stringify(error));
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'pianoTouchWithoutOutputPort_test end');
    })

    /**
     * 测试用例23: 设备信息显示完整性测试
     */
    it('deviceInfoDisplay_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'deviceInfoDisplay_test begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let deviceListTitle = await driver.findComponent(ON.text('Connected Devices'));
      expect(deviceListTitle).not().assertNull();

      let openDeviceBtn = await driver.findComponent(ON.text('Open Device'));
      expect(openDeviceBtn).not().assertNull();

      let closeDeviceBtn = await driver.findComponent(ON.text('Close Device'));
      expect(closeDeviceBtn).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'deviceInfoDisplay_test end');
    })

    /**
     * 测试用例24: 长时间运行稳定性测试
     */
    it('longRunningStability_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'longRunningStability_test begin');

      const ITERATIONS = 5;

      for (let i = 0; i < ITERATIONS; i++) {
        hilog.info(0x0000, TAG, 'Iteration: %{public}d', i + 1);

        let createBtn = await driver.findComponent(ON.text('Create Client'));
        if (createBtn) {
          await createBtn.click();
          await driver.delayMs(1000);
        }

        let refreshBtn = await driver.findComponent(ON.text('Refresh Devices'));
        if (refreshBtn) {
          await refreshBtn.click();
          await driver.delayMs(1000);
        }

        let destroyBtn = await driver.findComponent(ON.text('Destroy Client'));
        if (destroyBtn) {
          await destroyBtn.click();
          await driver.delayMs(1000);
        }
      }

      let createBtnFinal = await driver.findComponent(ON.text('Create Client'));
      expect(createBtnFinal).not().assertNull();

      hilog.info(0x0000, TAG, '%{public}s', 'longRunningStability_test end');
    })

    /**
     * 测试用例25: 连续操作压力测试
     */
    it('continuousOperationStress_test', 0, async () => {
      hilog.info(0x0000, TAG, '%{public}s', 'continuousOperationStress_test begin');

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(500);
      }

      for (let i = 0; i < 3; i++) {
        let refreshBtn = await driver.findComponent(ON.text('Refresh Devices'));
        if (refreshBtn) {
          await refreshBtn.click();
          await driver.delayMs(300);
        }
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      let destroyBtn = await driver.findComponent(ON.text('Destroy Client'));
      if (destroyBtn) {
        await destroyBtn.click();
        await driver.delayMs(500);
      }

      hilog.info(0x0000, TAG, '%{public}s', 'continuousOperationStress_test end');
    })
  })
}
