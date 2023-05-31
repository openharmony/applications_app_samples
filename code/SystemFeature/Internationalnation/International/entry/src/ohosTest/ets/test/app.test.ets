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
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../Logger';
import ResourceUtil from '../../../main/ets/MainAbility/model/ResourceUtil';

const TAG: string = '[Sample_International]'
const BUNDLE = 'International_'

let driver: Driver = Driver.create();

//通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.id(atom));
  let button = await driver.findComponent(ON.id(atom));
  await button.click();
  await driver.delayMs(1000);
}

//通过text验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithText(text: string) {
  let atom = text;
  await driver.assertComponentExist(ON.text(atom));
  let button = await driver.findComponent(ON.text(atom));
  await button.click();
  await driver.delayMs(1000);
}

export default function appTest() {
  describe('appTest', function () {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.international',
          abilityName: 'ohos.samples.international.MainAbility'
        });
        done();
      } catch (error) {
        Logger.info(TAG, `StartAbility end ${JSON.stringify(error)}`);
        expect(0).assertEqual(error.code);
        done();
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 测试时区设置
     */
    it(BUNDLE + 'TimeZone_001', 0, async (done) => {
      Logger.info(TAG, BUNDLE + 'TimeZone_001 begin');
      //进入时间和日期页面
      await driver.delayMs(1000);
      await checkButtonAndClickWithText(await ResourceUtil.getString($r('app.string.date_and_time').id));
      //进入时区设置页面
      await driver.delayMs(1000);
      await checkButtonAndClickWithText(await ResourceUtil.getString($r('app.string.time_zone').id));
      //设置时区
      await checkButtonAndClickWithID('time_zone_item0');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await ResourceUtil.getString($r('app.string.time_zone').id)));
      done();
      Logger.info(TAG, BUNDLE + 'TimeZone_001 end');
    })

  })
}