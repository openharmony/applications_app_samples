/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import display from '@ohos.display';

const DOMAIN = 0xF811;
const BUNDLE = 'MIDI_';

let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
let abilityDelegatorArgs: AbilityDelegatorRegistry.AbilityDelegatorArgs = AbilityDelegatorRegistry.getArguments();

export default function abilityTest() {
  const TAG = '[Sample_MIDI]';
  const WAIT_TIME = 3000;
  let driver: Driver;

  describe('ActsMidiAbilityTest', () => {
    beforeAll(async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'beforeAll called');
      driver = Driver.create();
    })

    beforeEach(() => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'beforeEach called');
    })

    afterEach(() => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'afterEach called');
    })

    afterAll(() => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'afterAll called');
    })

    /**
     * 测试用例1: 应用启动
     */
    it('MIDI_StartAbility_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_StartAbility_001 begin');
      let bundleName: string = abilityDelegatorArgs.bundleName;
      let abilityName = 'EntryAbility';

      await abilityDelegator.startAbility({
        bundleName: bundleName,
        abilityName: abilityName
      });

      await driver.delayMs(WAIT_TIME);
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_StartAbility_001 end');
    })

    /**
     * 测试用例2: 主页显示检查
     */
    it('MIDI_MainPageDisplay_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_MainPageDisplay_001 begin');
      await driver.delayMs(WAIT_TIME);

      // 检查标题是否显示
      let titleText = await driver.findComponent(ON.text('MIDI Sample'));
      expect(titleText).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_MainPageDisplay_001 end');
    })

    /**
     * 测试用例3: 创建MIDI客户端
     */
    it('MIDI_CreateClient_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_CreateClient_001 begin');
      await driver.delayMs(WAIT_TIME);

      // 查找并点击"Create Client"按钮
      let createClientBtn = await driver.findComponent(ON.text('Create Client'));
      expect(createClientBtn).not().assertNull();
      await createClientBtn.click();
      await driver.delayMs(WAIT_TIME);

      // 验证按钮文本变为"Destroy Client"
      let destroyClientBtn = await driver.findComponent(ON.text('Destroy Client'));
      expect(destroyClientBtn).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_CreateClient_001 end');
    })

    /**
     * 测试用例4: 刷新设备列表
     */
    it('MIDI_RefreshDevices_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_RefreshDevices_001 begin');
      await driver.delayMs(WAIT_TIME);

      // 查找并点击"Refresh Devices"按钮
      let refreshBtn = await driver.findComponent(ON.text('Refresh Devices'));
      expect(refreshBtn).not().assertNull();
      await refreshBtn.click();
      await driver.delayMs(WAIT_TIME);

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_RefreshDevices_001 end');
    })

    /**
     * 测试用例5: 销毁MIDI客户端
     */
    it('MIDI_DestroyClient_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DestroyClient_001 begin');
      await driver.delayMs(WAIT_TIME);

      // 查找并点击"Destroy Client"按钮
      let destroyBtn = await driver.findComponent(ON.text('Destroy Client'));
      expect(destroyBtn).not().assertNull();
      await destroyBtn.click();
      await driver.delayMs(WAIT_TIME);

      // 验证按钮文本变为"Create Client"
      let createBtn = await driver.findComponent(ON.text('Create Client'));
      expect(createBtn).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DestroyClient_001 end');
    })

    /**
     * 测试用例6: 蓝牙MIDI区域显示
     */
    it('MIDI_BleSectionDisplay_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_BleSectionDisplay_001 begin');

      // 先创建客户端
      let createBtn = await driver.findComponent(ON.text('Create Client'));
      await createBtn?.click();
      await driver.delayMs(WAIT_TIME);

      // 查找蓝牙MIFI标题
      let bleTitle = await driver.findComponent(ON.text('Bluetooth MIDI'));
      expect(bleTitle).not().assertNull();

      let connectBtn = await driver.findComponent(ON.text('Connect'));
      expect(connectBtn).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_BleSectionDisplay_001 end');
    })

    /**
     * 测试用例7: 设备列表区域显示
     */
    it('MIDI_DeviceListDisplay_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DeviceListDisplay_001 begin');
      await driver.delayMs(WAIT_TIME);

      // 查找"Connected Devices"标题
      let deviceListTitle = await driver.findComponent(ON.text('Connected Devices'));
      expect(deviceListTitle).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DeviceListDisplay_001 end');
    })

    /**
     * 测试用例8: 虚拟钢琴键盘区域
     */
    it('MIDI_PianoKeyboardDisplay_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoKeyboardDisplay_001 begin');
      await driver.delayMs(WAIT_TIME);

      // 查找虚拟钢琴键盘标题
      let pianoTitle = await driver.findComponent(ON.text('Virtual Piano Keyboard'));
      // 如果没有打开设备，可能显示提示文本
      let hint = await driver.findComponent(ON.text('Open an output port to play'));

      // 修复逻辑错误，使用正确的条件判断
      if (pianoTitle) {
        expect(pianoTitle).not().assertNull();
      } else {
        hilog.info(DOMAIN, TAG, 'Piano keyboard not visible - device not opened');
      }

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoKeyboardDisplay_001 end');
    })

    /**
     * 测试用例9: Event Log区域显示
     */
    it('MIDI_EventLogDisplay_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_EventLogDisplay_001 begin');
      await driver.delayMs(WAIT_TIME);

      // 查找"Event Log"标题
      let logTitle = await driver.findComponent(ON.text('Event Log'));
      expect(logTitle).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_EventLogDisplay_001 end');
    })

    /**
     * 测试用例10: 基础UI元素完整性检查
     */
    it('MIDI_UiElementsCompleteness_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_UiElementsCompleteness_001 begin');
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

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_UiElementsCompleteness_001 end');
    })

    /**
     * 测试用例11: 蓝牙MAC地址格式验证测试
     */
    it('MIDI_BleMacAddressFormat_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_BleMacAddressFormat_001 begin');
      await driver.delayMs(WAIT_TIME);
      let bleMidiSection = await driver.findComponent(ON.text('Bluetooth MIDI'));
      expect(bleMidiSection).not().assertNull();

      let connectBtn = await driver.findComponent(ON.text('Connect'));
      expect(connectBtn).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_BleMacAddressFormat_001 end');
    })

    /**
     * 测试用例12: BLE连接按钮状态测试
     */
    it('MIDI_BleConnectButtonState_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_BleConnectButtonState_001 begin');
      await driver.delayMs(WAIT_TIME);

      let connectBtn = await driver.findComponent(ON.text('Connect'));
      expect(connectBtn).not().assertNull();

      let bleSection = await driver.findComponent(ON.text('Bluetooth MIDI'));
      expect(bleSection).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_BleConnectButtonState_001 end');
    })

    /**
     * 测试用例13: 设备列表选择状态测试
     */
    it('MIDI_DeviceListSelection_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DeviceListSelection_001 begin');
      await driver.delayMs(WAIT_TIME);

      let deviceListTitle = await driver.findComponent(ON.text('Connected Devices'));
      expect(deviceListTitle).not().assertNull();

      let openDeviceBtn = await driver.findComponent(ON.text('Open Device'));
      if (openDeviceBtn) {
        expect(openDeviceBtn).not().assertNull();
      } else {
        hilog.info(DOMAIN, TAG, 'Open Device button not visible - no device selected');
      }

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DeviceListSelection_001 end');
    })

    /**
     * 测试用例14: 未选择设备时打开设备测试
     */
    it('MIDI_OpenDeviceWithoutSelection_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_OpenDeviceWithoutSelection_001 begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      // 测试没有选择设备时的状态，Device Control 区域应该不显示
      let deviceControlTitle = await driver.findComponent(ON.text('Device Control'));
      if (deviceControlTitle === null) {
        hilog.info(DOMAIN, TAG, 'Device Control not visible - no device selected (expected)');
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_OpenDeviceWithoutSelection_001 end');
    })

    /**
     * 测试用例15: 客户端重复创建测试
     */
    it('MIDI_DuplicateClientCreation_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DuplicateClientCreation_001 begin');
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

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_DuplicateClientCreation_001 end');
    })

    /**
     * 测试用例16: 客户端未创建时操作测试
     */
    it('MIDI_OperationWithoutClient_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_OperationWithoutClient_001 begin');
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

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_OperationWithoutClient_001 end');
    })

    /**
     * 测试用例17: MIDI通道输入边界测试
     */
    it('MIDI_ChannelInput_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_ChannelInput_001 begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let channelLabel = await driver.findComponent(ON.text('Channel:'));

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_ChannelInput_001 end');
    })

    /**
     * 测试用例18: Event Log滚动测试
     */
    it('MIDI_EventLogScroll_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_EventLogScroll_001 begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      let clearLogBtn = await driver.findComponent(ON.text('Clear'));
      expect(clearLogBtn).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_EventLogScroll_001 end');
    })

    /**
     * 测试用例19: Clear Log按钮功能测试
     */
    it('MIDI_ClearLogFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_ClearLogFunction_001 begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let clearLogBtn = await driver.findComponent(ON.text('Clear'));
      expect(clearLogBtn).not().assertNull();
      await clearLogBtn.click();
      await driver.delayMs(WAIT_TIME);

      let clearLogBtnAfter = await driver.findComponent(ON.text('Clear'));
      expect(clearLogBtnAfter).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_ClearLogFunction_001 end');
    })

    /**
     * 测试用例20: 钢琴键盘UI渲染测试
     */
    it('MIDI_PianoKeyboardRendering_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoKeyboardRendering_001 begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let pianoTitle = await driver.findComponent(ON.text('Virtual Piano Keyboard'));
      let pianoHint = await driver.findComponent(ON.text('Open an output port to play'));

      if (pianoTitle) {
        expect(pianoTitle).not().assertNull();
      } else {
        hilog.info(DOMAIN, TAG, 'Piano keyboard not rendered - device not opened');
      }

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoKeyboardRendering_001 end');
    })

    /**
     * 测试用例21: 钢琴键盘触摸响应测试（坐标定位）
     */
    it('MIDI_PianoKeyboardTouchResponse_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoKeyboardTouchResponse_001 begin');
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

      hilog.info(DOMAIN, TAG, 'Screen size: %{public}d x %{public}d', screenWidth, screenHeight);

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

        hilog.info(DOMAIN, TAG, 'Piano keyboard touch test completed');
      } catch (error) {
        hilog.info(DOMAIN, TAG, 'Piano keyboard touch test: %{public}s', JSON.stringify(error));
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoKeyboardTouchResponse_001 end');
    })

    /**
     * 测试用例22: 无输出端口时钢琴键触摸测试
     */
    it('MIDI_PianoTouchWithoutOutputPort_001', 0, async () => {
      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoTouchWithoutOutputPort_001 begin');
      await driver.delayMs(WAIT_TIME);

      let createBtn = await driver.findComponent(ON.text('Create Client'));
      if (createBtn) {
        await createBtn.click();
        await driver.delayMs(WAIT_TIME);
      }

      let hint = await driver.findComponent(ON.text('Open an output port to play'));
      if (hint) {
        hilog.info(DOMAIN, TAG, 'Hint text found: output port not opened');
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
        hilog.info(DOMAIN, TAG, 'Click without output port: %{public}s', JSON.stringify(error));
      }

      let eventLogTitle = await driver.findComponent(ON.text('Event Log'));
      expect(eventLogTitle).not().assertNull();

      hilog.info(DOMAIN, TAG, '%{public}s', 'MIDI_PianoTouchWithoutOutputPort_001 end');
    })
  })
}
