/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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
import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import { getString } from '../util/ResourceUtil';

const DRIVER = Driver.create();
const TAG = '[Sample_Camera]';
const DOMAIN = 0x0000;
const BUNDLE = 'Camera_';
const WAITING_TIME = 1000;

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'com.samples.camera',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        hilog.info(DOMAIN, TAG, 'StartAbility err:' + JSON.stringify(err));
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it('RequestPermission_001', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermission_001 begin');
      await DRIVER.delayMs(WAITING_TIME);
      // 获取访问权限
      let tipAllow = getString($r('app.string.allow'));
      await DRIVER.assertComponentExist(ON.text(tipAllow));
      let btnAccept = await DRIVER.findComponent(ON.text(tipAllow));
      // 相机权限
      await btnAccept.click();
      await DRIVER.delayMs(WAITING_TIME);
      // 图片视频权限
      await btnAccept.click();
      await DRIVER.delayMs(WAITING_TIME);
      // 麦克风权限
      await btnAccept.click();
      await DRIVER.delayMs(WAITING_TIME);
      // 文件权限
      await btnAccept.click();
      await DRIVER.delayMs(WAITING_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * 属性设置
     */
    it('CameraSetting_001', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CameraSetting_001 begin');
      // 进入设置界面
      let image = await DRIVER.findComponents(ON.type('Image'))
      await image[5].click()
      await DRIVER.delayMs(WAITING_TIME)
      // 进入旋转角度设置
      await DRIVER.assertComponentExist(ON.id('rotation'));
      let displayData = await DRIVER.findComponent(ON.id('rotation'));
      await displayData.click();
      await DRIVER.delayMs(WAITING_TIME);
      // 设置90旋转
      let set_90_rotate = getString($r('app.string.support_90_rotate'));
      await DRIVER.assertComponentExist(ON.text(set_90_rotate));
      let rotateSetting = await DRIVER.findComponent(ON.text(set_90_rotate));
      await rotateSetting.click();
      await DRIVER.delayMs(WAITING_TIME);
      // 确认选择
      let confirm = getString($r('app.string.confirm'));
      await DRIVER.assertComponentExist(ON.text(confirm));
      let confirmSetting = await DRIVER.findComponent(ON.text(confirm));
      await confirmSetting.click();
      await DRIVER.delayMs(WAITING_TIME);
      // 确定完成设置
      await DRIVER.assertComponentExist(ON.text(set_90_rotate));
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CameraSetting_001 end');
    })
  })
}