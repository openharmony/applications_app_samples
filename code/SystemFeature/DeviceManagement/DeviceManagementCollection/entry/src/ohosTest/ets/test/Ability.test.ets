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

const TAG: string = 'Sample_DeviceManagementSys';
const BUNDLE = 'DeviceManagementSys_';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();

export default function abilityTest() {
  /**
   * 启动测试app
   */
  beforeAll(async function () {
    logger.info(TAG, `${BUNDLE}StartAbility_001, begin`);
    let want = {
      bundleName: "com.samples.devicemanagementcollectionsys",
      abilityName: "EntryAbility"
    };
    let driver: Driver = Driver.create();
    delegator.startAbility(want, (err) => {
      logger.info(TAG, `${BUNDLE}StartAbility_001, success`);
    })
    await driver.delayMs(1000);
    logger.info(TAG, `${BUNDLE}StartAbility_001, end`);
  })
  describe('ActsAbilityTest', function () {

    /**
     * 耗电统计
     */
    it(BUNDLE + 'BatteryStats_001', 0, async function (done) {
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
    it(BUNDLE + 'Brightness_001', 0, async function (done) {
      let driver: Driver = Driver.create();
      await driver.delayMs(200);
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
    it(BUNDLE + 'Power_001', 0, async function (done) {
      let driver: Driver = await Driver.create();
      logger.info(TAG, `${BUNDLE}Power_001, begin`);
      await driver.assertComponentExist(ON.type('List'));
      let list = await driver.findComponent(ON.type('List'));
      logger.info(TAG, `${BUNDLE}Power_001, find ${getString($r('app.string.power_manager'))}`);
      let button = await list.scrollSearch(ON.text(getString($r('app.string.power_manager'))));
      logger.info(TAG, `${BUNDLE}Power_001, click ${getString($r('app.string.power_manager'))}`);
      await button.click();
      await driver.delayMs(200);
      logger.info(TAG, `${BUNDLE}Power_001, end`);

      let opts = await getStringArray($r('app.strarray.power_operations'))

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
      done();
    })

    /**
     * 设置数据项名称
     */
    it(BUNDLE + 'Settings_001', 0, async function (done) {
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
    it(BUNDLE + 'SystemCapability_001', 0, async function (done) {
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

      let opts = await getStringArray($r('app.strarray.settings_operations'))

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
    it(BUNDLE + 'SystemParameter_001', 0, async function (done) {
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

      let opts = await getStringArray($r('app.strarray.system_parameter'))

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
  })
}