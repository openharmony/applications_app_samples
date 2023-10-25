/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, beforeAll, it } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import { logger } from '../util/Logger';
import { getString, getStringArray } from '../util/ResourceUtil';
import Want from '@ohos.app.ability.Want';

const TAG: string = '[Sample_DeviceManagementSys]';
const BUNDLE = 'DeviceManagementSys_';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
const manage = delegator.getAppContext().resourceManager;

/**
 * 根据资源获取文本内容
 * @param resource 资源
 */
async function getResourceString(resource: Resource): Promise<string> {
  let text = await manage.getStringValue(resource);
  return text;
}
export default function abilityTest() {
  /**
   * 启动测试app
   */
  beforeAll(async () => {
    logger.info(TAG, `${BUNDLE}StartAbility_001, begin`);
    let want: Want = {
      bundleName: "com.samples.devicemanagementcollectionsys",
      abilityName: "EntryAbility"
    };
    let driver: Driver = Driver.create();
    delegator.startAbility(want, (err) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001, success`);
    });
    await driver.delayMs(1000);
    logger.info(TAG, `${BUNDLE}StartAbility_001, end`);
  })
  describe('ActsAbilityTest', () => {
    /**
     * 耗电统计
     */
    it(BUNDLE + 'BatteryStats_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}BatteryStats_001, begin`);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      logger.info(TAG, `${BUNDLE}BatteryStats_001, find ${getString($r('app.string.battery_statistics'))}`);
      let button = await list.scrollSearch(ON.text(getString($r('app.string.battery_statistics'))));
      logger.info(TAG, `${BUNDLE}BatteryStats_001, click ${getString($r('app.string.battery_statistics'))}`);
      await button.click();
      await driver.delayMs(2000);
      logger.info(TAG, `${BUNDLE}BatteryStats_001, end`);

      logger.info(TAG, `${BUNDLE}BatteryStats_002, begin`);
      logger.info(TAG, `${BUNDLE}BatteryStats_002, find ${getString($r('app.string.battery_stats_hardware'))}`);
      await driver.assertComponentExist(ON.text(getString($r('app.string.battery_stats_hardware')), MatchPattern.CONTAINS));
      let hardBtn = await driver.findComponent(ON.text(getString($r('app.string.battery_stats_hardware')), MatchPattern.CONTAINS));
      logger.info(TAG, `${BUNDLE}BatteryStats_002, click ${getString($r('app.string.battery_stats_hardware'))}`);
      await hardBtn.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}BatteryStats_002, end`);

      logger.info(TAG, `${BUNDLE}BatteryStats_003, begin`);
      logger.info(TAG, `${BUNDLE}BatteryStats_003, find ${getString($r('app.string.battery_stats_software'))}`);
      await driver.assertComponentExist(ON.text(getString($r('app.string.battery_stats_software')), MatchPattern.CONTAINS));
      let softBtn = await driver.findComponent(ON.text(getString($r('app.string.battery_stats_software')), MatchPattern.CONTAINS));
      logger.info(TAG, `${BUNDLE}BatteryStats_003, click ${getString($r('app.string.battery_stats_software'))}`);
      await softBtn.click();
      await driver.delayMs(2000);
      logger.info(TAG, `${BUNDLE}BatteryStats_003, end`);

      await driver.pressBack();
      done();
    })

    /**
     * 屏幕亮度
     */
    it(BUNDLE + 'Brightness_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      logger.info(TAG, `${BUNDLE}Brightness_001, begin`);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      logger.info(TAG, `${BUNDLE}Brightness_001, find ${getString($r('app.string.brightness_manager'))}`);
      let button = await list.scrollSearch(ON.text(getString($r('app.string.brightness_manager'))));
      logger.info(TAG, `${BUNDLE}Brightness_001, click ${getString($r('app.string.brightness_manager'))}`);
      await button.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Brightness_001, end`);

      logger.info(TAG, `${BUNDLE}Brightness_002, begin`);
      logger.info(TAG, `${BUNDLE}Brightness_002, find slider`);
      await driver.assertComponentExist(ON.type('Slider'));
      let slider = await driver.findComponent(ON.type('Slider'));
      logger.info(TAG, `${BUNDLE}Brightness_002, scroll slider`);
      await slider.scrollSearch(ON.text('100%'));
      logger.info(TAG, `${BUNDLE}Brightness_002, end`);
      await driver.delayMs(1000);

      await driver.pressBack();
      done();
    })

    /**
     * 系统电源管理
     */
    it(BUNDLE + 'Power_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      logger.info(TAG, `${BUNDLE}Power_001, begin`);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      logger.info(TAG, `${BUNDLE}Power_001, find ${getString($r('app.string.power_manager'))}`);
      let button = await list.scrollSearch(ON.text(getString($r('app.string.power_manager'))));
      logger.info(TAG, `${BUNDLE}Power_001, click ${getString($r('app.string.power_manager'))}`);
      await button.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}Power_001, end`);

      let opts = await getStringArray($r('app.strarray.power_operations'));

      logger.info(TAG, `${BUNDLE}Power_002, begin`);
      // 休眠
      logger.info(TAG, `${BUNDLE}Power_002, find ${opts[0]}`);
      await driver.assertComponentExist(ON.text(opts[0]));
      let sleepBtn = await driver.findComponent(ON.text(opts[0]));
      logger.info(TAG, `${BUNDLE}Power_002, click ${opts[0]}`);
      await sleepBtn.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Power_002, wakeUpDisplay`);
      await driver.wakeUpDisplay();
      logger.info(TAG, `${BUNDLE}Power_002, swipe`);
      await driver.swipe(100, 500, 100, 100, 10);
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Power_002, end`);

      // 关机
      logger.info(TAG, `${BUNDLE}Power_003, begin`);
      logger.info(TAG, `${BUNDLE}Power_003, find ${opts[1]}`);
      await driver.assertComponentExist(ON.text(opts[1]));
      let shutBtn = await driver.findComponent(ON.text(opts[1]));
      logger.info(TAG, `${BUNDLE}Power_003, click ${opts[1]}`);
      await shutBtn.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Power_003, find ${getString($r('app.string.questionTurnOff'))}`);
      await driver.assertComponentExist(ON.text(getString($r('app.string.questionTurnOff')), MatchPattern.CONTAINS));
      let shutCancelBtn = await driver.findComponent(ON.text(getString($r('app.string.cancel'))));
      logger.info(TAG, `${BUNDLE}Power_003, click ${getString($r('app.string.cancel'))}`);
      await shutCancelBtn.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}Power_003, end`);

      // 重启
      logger.info(TAG, `${BUNDLE}Power_004, begin`);
      logger.info(TAG, `${BUNDLE}Power_004, find ${opts[2]}`);
      await driver.assertComponentExist(ON.text(opts[2]));
      let resetBtn = await driver.findComponent(ON.text(opts[2]));
      logger.info(TAG, `${BUNDLE}Power_004, click ${opts[2]}`);
      await resetBtn.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Power_004, find ${getString($r('app.string.questionRestart'))}`);
      await driver.assertComponentExist(ON.text(getString($r('app.string.questionRestart')), MatchPattern.CONTAINS));
      let resetCancelBtn = await driver.findComponent(ON.text(getString($r('app.string.cancel'))));
      logger.info(TAG, `${BUNDLE}Power_004, click ${getString($r('app.string.cancel'))}`);
      await resetCancelBtn.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}Power_004, end`);

      // 设置电源模式
      logger.info(TAG, `${BUNDLE}Power_005, begin`);
      logger.info(TAG, `${BUNDLE}Power_005, find ${opts[3]}`);
      await driver.assertComponentExist(ON.text(opts[3], MatchPattern.CONTAINS));
      let setBtn = await driver.findComponent(ON.text(opts[3], MatchPattern.CONTAINS));
      logger.info(TAG, `${BUNDLE}Power_005, click ${opts[3]}`);
      await setBtn.click();
      await driver.delayMs(200);
      let powerModes = await getStringArray($r('app.strarray.power_mode'))
      logger.info(TAG, `${BUNDLE}Power_005, find ${powerModes[2]}`);
      await driver.assertComponentExist(ON.text(powerModes[2], MatchPattern.CONTAINS));
      let performanceBtn = await driver.findComponent(ON.text(powerModes[2]));
      logger.info(TAG, `${BUNDLE}Power_005, click ${powerModes[2]}`);
      await performanceBtn.click();
      logger.info(TAG, `${BUNDLE}Power_005, find ${getString($r('app.string.power_mode'))}`);
      await driver.assertComponentExist(ON.text(getString($r('app.string.power_mode')), MatchPattern.CONTAINS));
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}Power_005, end`);

      await driver.pressBack();
      await driver.delayMs(500);
      done();
    })

    /**
     * 设置数据项名称
     */
    it(BUNDLE + 'Settings_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}Settings_001, begin`);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      logger.info(TAG, `${BUNDLE}Settings_001, find ${getString($r('app.string.settings'))}`);
      let button = await list.scrollSearch(ON.text(getString($r('app.string.settings'))));
      logger.info(TAG, `${BUNDLE}Settings_001, click ${getString($r('app.string.settings'))}`);
      await button.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}Settings_001, begin`);

      let opts = await getStringArray($r('app.strarray.settings_operations'))

      logger.info(TAG, `${BUNDLE}Settings_002, begin`);
      logger.info(TAG, `${BUNDLE}Settings_002, find ${opts[0]}`);
      await driver.assertComponentExist(ON.text(opts[0]));
      let btn1 = await driver.findComponent(ON.text(opts[0]));
      logger.info(TAG, `${BUNDLE}Settings_002, click ${opts[0]}`);
      await btn1.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}Settings_002, end`);

      await driver.pressBack();
      done();
    })

    /**
     * 系统能力
     */
    it(BUNDLE + 'SystemCapability_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      await driver.delayMs(200);

      logger.info(TAG, `${BUNDLE}SystemCapability_001, begin`);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      logger.info(TAG, `${BUNDLE}SystemCapability_001, find ${getString($r('app.string.system_capability'))}`);
      let button = await list.scrollSearch(ON.text(getString($r('app.string.system_capability'))));
      logger.info(TAG, `${BUNDLE}SystemCapability_001, click ${getString($r('app.string.system_capability'))}`);
      await button.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}SystemCapability_001, end`);

      let opts = await getStringArray($r('app.strarray.system_capability'))

      logger.info(TAG, `${BUNDLE}SystemCapability_002, begin`);
      logger.info(TAG, `${BUNDLE}SystemCapability_002, find ${opts[0]}`);
      await driver.assertComponentExist(ON.text(opts[0]));
      let btn1 = await driver.findComponent(ON.text(opts[0]));
      logger.info(TAG, `${BUNDLE}SystemCapability_002, click ${opts[0]}`);
      await btn1.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}SystemCapability_002, end`);

      await driver.pressBack();
      done();
    })

    /**
     * 系统参数
     */
    it(BUNDLE + 'SystemParameter_001', 0, async (done: Function) => {
      let driver: Driver = Driver.create();
      await driver.delayMs(200);

      logger.info(TAG, `${BUNDLE}SystemParameter_001, begin`);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      logger.info(TAG, `${BUNDLE}SystemParameter_001, find ${getString($r('app.string.system_parameter'))}`);
      let button = await list.scrollSearch(ON.text(getString($r('app.string.system_parameter'))));
      logger.info(TAG, `${BUNDLE}SystemParameter_001, click ${getString($r('app.string.system_parameter'))}`);
      await button.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}SystemParameter_001, end`);

      let opts = await getStringArray($r('app.strarray.system_parameter'));

      logger.info(TAG, `${BUNDLE}SystemParameter_002, begin`);
      logger.info(TAG, `${BUNDLE}SystemParameter_002, find ${opts[0]}`);
      await driver.assertComponentExist(ON.text(opts[0]));
      let btn1 = await driver.findComponent(ON.text(opts[0]));
      logger.info(TAG, `${BUNDLE}SystemParameter_002, click ${opts[0]}`);
      await btn1.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}SystemParameter_002, end`);

      logger.info(TAG, `${BUNDLE}SystemParameter_003, begin`);
      logger.info(TAG, `${BUNDLE}SystemParameter_003, find ${opts[1]}`);
      await driver.assertComponentExist(ON.text(opts[1]));
      let btn2 = await driver.findComponent(ON.text(opts[1]));
      logger.info(TAG, `${BUNDLE}SystemParameter_003, click ${opts[1]}`);
      await btn2.click();
      await driver.delayMs(1000);
      logger.info(TAG, `${BUNDLE}SystemParameter_003, end`);

      await driver.pressBack();
      done();
    })
    /**
     * 电量管理：无法获取电量信息
     */
    it(BUNDLE + 'BatteryManager_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}BatteryManager_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let resource: string = await getResourceString($r('app.string.battery_info'))
      logger.info(TAG, `${BUNDLE}BatteryManager_001 get Resource value: ${resource}`);
      let button = await list.scrollSearch(ON.text(resource));
      await button.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.id('batterySOC'));
      let batterySearchFail = await driver.findComponent(ON.id('batterySearchFail'));
      if (batterySearchFail) {
        await driver.assertComponentExist(ON.id('batteryFailIcon'));
        await driver.assertComponentExist(ON.id('batterySearchFail'));
      }
      logger.info(TAG, `${BUNDLE}BatteryManager_001 end`);
      done();
    })

    /**
     * 电量管理：获取电量信息：充电状态、充电类型、电池电压
     */
    it(BUNDLE + 'BatteryManager_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}BatteryManager_002 begin`);
      let driver: Driver = Driver.create();
      let batteryContext = await driver.findComponent(ON.id('batteryContext'));
      if (batteryContext) {
        await driver.assertComponentExist(ON.id('batteryChargingStatus'));
        await driver.assertComponentExist(ON.id('batteryPluggedType'));
        await driver.assertComponentExist(ON.id('batteryVoltage'));
      }
      logger.info(TAG, `${BUNDLE}BatteryManager_002 end`);
      done();
    })

    /**
     * 电量管理：获取电量信息：电池电量类型、温度、等级
     */
    it(BUNDLE + 'BatteryManager_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}BatteryManager_003 begin`);
      let driver: Driver = Driver.create();
      let batteryContext = await driver.findComponent(ON.id('batteryContext'));
      if (batteryContext) {
        await driver.assertComponentExist(ON.id('batteryTechnology'));
        await driver.assertComponentExist(ON.id('batteryTemperature'));
        await driver.assertComponentExist(ON.id('batteryCapacityLevel'));
      }
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}BatteryManager_003 end`);
      done();
    })

    /**
     * 设备信息：开启设备信息页面
     */
    it(BUNDLE + 'DeviceInfo_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let resource: string = await getResourceString($r('app.string.device_info'));
      logger.info(TAG, `${BUNDLE}DeviceInfo_001 get Resource value: ${resource}`);
      let button = await list.scrollSearch(ON.text(resource));
      await button.click();
      await driver.delayMs(100);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.device_type'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_001 end`);
      done();
    })

    /**
     * 设备信息：厂家、品牌、外部的产品系列
     */
    it(BUNDLE + 'DeviceInfo_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.manufacture'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.brand'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.marker_name'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_002 end`);
      done();
    })

    /**
     * 设备信息：产品系列、设备型号、软件型号
     */
    it(BUNDLE + 'DeviceInfo_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.product_series'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.product_model'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.software_model'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_003 end`);
      done();
    })

    /**
     * 设备信息：设备硬件配置、序列号
     */
    it(BUNDLE + 'DeviceInfo_004', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_004 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.hardware_profile'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.serial'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_004 end`);
      done();
    })

    /**
     * 设备信息：滑动页面到‘Bootloader版本号’选项
     */
    it(BUNDLE + 'DeviceInfo_005', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_005 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let infoList = await driver.findComponent(ON.type('List'));
      await infoList.scrollSearch(ON.text(await getResourceString($r('app.string.bootloader_version'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_005 end`);
      done();
    })

    /**
     * 设备信息：页面滑动到‘首个版本系统软件API版本’选项
     */
    it(BUNDLE + 'DeviceInfo_006', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_006 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let infoList = await driver.findComponent(ON.type('List'))
      await infoList.scrollSearch(ON.text(await getResourceString($r('app.string.first_api_version'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_006 end`);
      done();
    })

    /**
     * 设备信息：首个版本系统软件API版本、版本ID、构建类型
     */
    it(BUNDLE + 'DeviceInfo_007', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_007 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let infoList = await driver.findComponent(ON.type('List'));
      await infoList.scrollSearch(ON.text('UDID'));
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.first_api_version'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.version_id'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.build_type'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_007 end`);
      done();
    })

    /**
     * 设备信息：构建用户、构建主机、构建时间
     */
    it(BUNDLE + 'DeviceInfo_008', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_008 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.build_user'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.build_host'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.build_time'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_008 end`);
      done();
    })

    /**
     * 设备信息：页面滑动到‘UDID’选项
     */
    it(BUNDLE + 'DeviceInfo_009', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_009 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let infoList = await driver.findComponent(ON.type('List'));
      await infoList.scrollSearch(ON.text(await getResourceString($r('app.string.udid'))));
      logger.info(TAG, `${BUNDLE}DeviceInfo_009 end`);
      done();
    })

    /**
     * 设备信息：构建版本Hash、uuid
     */
    it(BUNDLE + 'DeviceInfo_010', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}DeviceInfo_010 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.build_root_hash'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.udid'))));
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}DeviceInfo_010 end`);
      done();
    })

    /**
     * 打开组合按键页面
     */
    it(BUNDLE + 'InputConsumer_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputConsumer_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let resource: string = await getResourceString($r('app.string.input_consumer'));
      logger.info(TAG, `${BUNDLE}InputConsumer_001 get Resource value: ${resource}`);
      let button = await list.scrollSearch(ON.text(resource));
      await button.click();
      await driver.delayMs(100);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.input_consumer_listener'))));
      logger.info(TAG, `${BUNDLE}InputConsumer_001 end`);
      done();
    })

    /**
     * 组合按键查找组合按键页面中关键组件
     */
    it(BUNDLE + 'InputConsumer_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputConsumer_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.input_consumer_hint'))));
      let inputConsumerToggle = await driver.findComponent(ON.id('inputConsumerToggle'));
      await inputConsumerToggle.click();
      await driver.assertComponentExist(ON.id('textInputConsumerInfo'));
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}InputConsumer_002 end`);
      done();
    })

    /**
     * 打开输入设备页面
     */
    it(BUNDLE + 'InputDeviceManager_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputDeviceManager_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let resource: string = await getResourceString($r('app.string.input_device'));
      logger.info(TAG, `${BUNDLE}InputDeviceManager_001 get Resource value: ${resource}`);
      let button = await list.scrollSearch(ON.text(resource));
      await button.click();
      await driver.delayMs(100);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.input_device_change_title'))));
      logger.info(TAG, `${BUNDLE}InputDeviceManager_001 end`);
      done();
    })

    /**
     * 输入设备：打开热插拔监听器
     */
    it(BUNDLE + 'InputDeviceManager_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputDeviceManager_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let toggleInputDevice = await driver.findComponent(ON.type('Toggle'));
      await toggleInputDevice.click();
      let scrollInputDevice = await driver.findComponent(ON.id('scrollInputDevice'));
      await scrollInputDevice.scrollSearch(ON.text(await getResourceString($r('app.string.input_device_status'))));
      await driver.findComponent(ON.text(await getResourceString($r('app.string.input_device_status'))));
      logger.info(TAG, `${BUNDLE}InputDeviceManager_002 end`);
      done();
    })
    /**
     * 输入设备：外设输入列表
     */
    it(BUNDLE + 'InputDeviceManager_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputDeviceManager_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scrollInputDevice = await driver.findComponent(ON.id('scrollInputDevice'));
      await scrollInputDevice.scrollSearch(ON.text(await getResourceString($r('app.string.input_device_list_title'))));
      await driver.findComponent(ON.text(await getResourceString($r('app.string.input_device_list_title'))));
      await driver.pressBack();
      await driver.delayMs(500);
      logger.info(TAG, `${BUNDLE}InputDeviceManager_003 end`);
      done();
    })


    /**
     * 打开输入事件页面
     */
    it(BUNDLE + 'InputEventManager_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputEventManager_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let resource: string = await getResourceString($r('app.string.input_event'))
      logger.info(TAG, `${BUNDLE}InputEventManager_001 get Resource value: ${resource}`);
      let button = await list.scrollSearch(ON.text(resource));
      await button.click();
      await driver.delayMs(100);
      await driver.assertComponentExist(ON.id('scrollInputEvent'));
      logger.info(TAG, `${BUNDLE}InputEventManager_001 end`);
      done();
    })

    /**
     * 输入事件：打开输入事件监听器，展示输入事件
     */
    it(BUNDLE + 'InputEventManager_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputEventManager_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scrollInputEvent = await driver.findComponent(ON.id('scrollInputEvent'));
      let columnInputListener = await scrollInputEvent.scrollSearch(ON.id('scrollInputEvent'));
      let toggleInputListener = await columnInputListener.scrollSearch(ON.type('Toggle'));
      await toggleInputListener.click();
      await scrollInputEvent.scrollSearch(ON.text(await getResourceString($r('app.string.input_touch_event_data_title'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.input_touch_event_data_title'))));
      logger.info(TAG, `${BUNDLE}InputEventManager_002 end`);
      done();
    })

    /**
     * 输入事件：模拟系统返回事件
     */
    it(BUNDLE + 'InputEventManager_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputEventManager_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scrollInputEvent = await driver.findComponent(ON.id('scrollInputEvent'));
      let columnBackEvent = await scrollInputEvent.scrollSearch(ON.id('columnBackEvent'));
      let columnBackBtn = await columnBackEvent.scrollSearch(ON.id('columnBackBtn'));
      await columnBackBtn.click();
      logger.info(TAG, `${BUNDLE}InputEventManager_003 end`);
      done();
    })

    /**
     * 打开鼠标指针设置页面
     */
    it(BUNDLE + 'MouseManager_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MouseManager_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let resource: string = await getResourceString($r('app.string.mouse_pointer'));
      logger.info(TAG, `${BUNDLE}MouseManager_001 get Resource value: ${resource}`);
      let button = await list.scrollSearch(ON.text(resource));
      await button.click();
      await driver.delayMs(100);
      logger.info(TAG, `${BUNDLE}MouseManager_001 end`);
      done();
    })

    /**
     * 鼠标指针：设置鼠标显示或隐藏
     */
    it(BUNDLE + 'MouseManager_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MouseManager_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('scrollMouse'));
      let scrollMouse = await driver.findComponent(ON.id('scrollMouse'));
      await scrollMouse.scrollSearch(ON.text(await getResourceString($r('app.string.mouse_setting'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_setting'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_setting_show'))));
      logger.info(TAG, `${BUNDLE}MouseManager_002 end`);
      done();
    })

    /**
     * 鼠标指针：设置鼠标样式
     */
    it(BUNDLE + 'MouseManager_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MouseManager_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_setting_speed_title'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_setting_style_title'))));
      let scrollMouse = await driver.findComponent(ON.id('scrollMouse'));
      await scrollMouse.scrollSearch(ON.text(await getResourceString($r('app.string.mouse_listener_title'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_listener_title'))));
      logger.info(TAG, `${BUNDLE}MouseManager_003 end`);
      done();
    })

    /**
     * 鼠标指针：监听鼠标
     */
    it(BUNDLE + 'MouseManager_004', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MouseManager_004 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scrollMouse = await driver.findComponent(ON.id('scrollMouse'));
      let columnMouseListener = await scrollMouse.scrollSearch(ON.id('columnMouseListener'));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_listener_open'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_listener_open_hint'))));
      logger.info(TAG, `${BUNDLE}MouseManager_004 end`);
      done();
    })

    /**
     * 鼠标指针：打开鼠标监听器
     */
    it(BUNDLE + 'MouseManager_005', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MouseManager_005 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scrollMouse = await driver.findComponent(ON.id('scrollMouse'));
      let toggleMouseListener = await driver.findComponent(ON.id('toggleMouseListener'));
      await toggleMouseListener.click();
      await scrollMouse.scrollSearch(ON.text(await getResourceString($r('app.string.mouse_event_info_title'))));
      logger.info(TAG, `${BUNDLE}MouseManager_005 end`);
      done();
    })


    /**
     * 鼠标指针：鼠标事件详细信息
     */
    it(BUNDLE + 'MouseManager_006', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}MouseManager_006 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      let scrollMouse = await driver.findComponent(ON.id('scrollMouse'));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.mouse_event_info_title'))));
      await scrollMouse.scrollSearch(ON.id('columnMouseEvent'));
      await driver.assertComponentExist(ON.id('columnMouseEvent'));
      await driver.pressBack();
      await driver.delayMs(500);
      logger.info(TAG, `${BUNDLE}MouseManager_006 end`);
      done();
    })

    /**
     * 打开输入按键事件页面
     */
    it(BUNDLE + 'InputKeyEventManager_001', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputKeyEventManager_001 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      let resource: string = await getResourceString($r('app.string.input_key_event'));
      logger.info(TAG, `${BUNDLE}InputKeyEventManager_001 get Resource value: ${resource}`);
      let button = await list.scrollSearch(ON.text(resource));
      await button.click();
      await driver.delayMs(100);
      logger.info(TAG, `${BUNDLE}InputKeyEventManager_001 end`);
      done();
    })

    /**
     * 监听输入按键事件
     */
    it(BUNDLE + 'InputKeyEventManager_002', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputKeyEventManager_002 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('scrollKeyEvent'));
      let scrollKeyEvent = await driver.findComponent(ON.id('scrollKeyEvent'));
      let columnKeyListener = await scrollKeyEvent.scrollSearch(ON.id('columnKeyListener'));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.input_key_event_listener'))));
      logger.info(TAG, `${BUNDLE}InputKeyEventManager_002 end`);
      done();
    })

    /**
     * 显示输入按键事件信息
     */
    it(BUNDLE + 'InputKeyEventManager_003', 0, async (done: Function) => {
      logger.info(TAG, `${BUNDLE}InputKeyEventManager_003 begin`);
      let driver: Driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.input_key_event_hint'))));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.input_key_event_data'))));
      await driver.assertComponentExist(ON.id('columnKeyEventData'));
      await driver.pressBack();
      logger.info(TAG, `${BUNDLE}InputKeyEventManager_003 end`);
      done();
    })
  })
}