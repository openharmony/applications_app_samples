/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import { describe, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import { getString } from '../utils/ResourceUtil';

const TAG: string = '[Sample_Image]';
const DOMAIN: number = 0xF811;
const BUNDLE: string = 'Image_';

export default function CropTest() {
  describe('CropTest', function () {
    /**
     * 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      await abilityDelegatorRegistry.executeShellCommand('aa start -a MainAbility -b ohos.samples.image');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver: Driver = await Driver.create();
      await driver.delayMs(1000);
      const tipAllow: string = await getString($r('app.string.allow'));
      await driver.assertComponentExist(ON.text(tipAllow));
      let stack = await driver.findComponent(ON.text(tipAllow));
      await stack.click();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * 选择图片
     */
    it(BUNDLE + 'ChoosePhoto_001', 0, async function (done) {
      // 从相册中选择
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChoosePhoto_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('add'));
      let stack = await driver.findComponent(ON.id('add'));
      await stack.click();
      await driver.delayMs(1000);
      // 选择图片,坐标选择,固定坐标只支持RK3568，其他设备需要调整
      await driver.click(335, 235);
      await driver.delayMs(1000);
      // 点击完成
      const tipCompleted: string = await getString($r('app.string.completed'));
      await driver.assertComponentExist(ON.text(tipCompleted));
      let finish = await driver.findComponent(ON.text(tipCompleted));
      await finish.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChoosePhoto_001 end');
    })

    /**
     * 点击界面一张图片进入编辑界面
     */
    it(BUNDLE + 'ClickPhoto_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickPhoto_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Photo'));
      let stack = await driver.findComponent(ON.id('Photo'));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickPhoto_001 end');
    })

    /**
     * 点击编辑
     */
    it(BUNDLE + 'EditPhoto_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditPhoto_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Edit'));
      let stack = await driver.findComponent(ON.id('Edit'));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickPhoto_001 end');
    })

    /**
     * 点击裁剪
     */
    it(BUNDLE + 'CropPhoto_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropPhoto_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      const tipCrop: string = await getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let stack = await driver.findComponent(ON.text(tipCrop));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropPhoto_001 end');
    })

    /**
     * 点击4:3
     */
    it(BUNDLE + 'Crop4:3_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop4:3_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      const tipPercent: string = await getString($r('app.string.percent43'));
      await driver.assertComponentExist(ON.text(tipPercent));
      let stack = await driver.findComponent(ON.text(tipPercent));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop4:3_001 end');
    })

    /**
     * 点击16:9
     */
    it(BUNDLE + 'Crop16:9_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop16:9 begin');
      let driver = await Driver.create();
      const tipCrop = await getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let crop = await driver.findComponent(ON.text(tipCrop));
      await crop.click();
      await driver.delayMs(1000);
      const tipPercent = await getString($r('app.string.percent169'));
      await driver.assertComponentExist(ON.text(tipPercent));
      let stack = await driver.findComponent(ON.text(tipPercent));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop16:9 end');
    })

    /**
     * 点击1:1
     */
    it(BUNDLE + 'Crop1:1_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop1:1 begin');
      let driver = await Driver.create();
      const tipCrop = await getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let crop = await driver.findComponent(ON.text(tipCrop));
      await crop.click();
      await driver.delayMs(1000);
      const tipPercent = await getString($r('app.string.percent11'));
      await driver.assertComponentExist(ON.text(tipPercent));
      let stack = await driver.findComponent(ON.text(tipPercent));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop1:1 end');
    })

    /**
     * 点击原图
     */
    it(BUNDLE + 'CropOrigin_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropOrigin begin');
      let driver = await Driver.create();
      const tipCrop = await getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let crop = await driver.findComponent(ON.text(tipCrop));
      await crop.click();
      await driver.delayMs(1000);
      await driver.delayMs(1000);
      const tipOrigin = await getString($r('app.string.origin'));
      await driver.assertComponentExist(ON.text(tipOrigin));
      let stack = await driver.findComponent(ON.text(tipOrigin));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropOrigin end');
    })

    /**
     * 点击保存
     */
    it(BUNDLE + 'Save_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Save_001 begin');
      let driver = await Driver.create();
      await driver.assertComponentExist(ON.id('Save'));
      let scale = await driver.findComponent(ON.id('Save'));
      await scale.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Save_001 end');
    })
  })
}