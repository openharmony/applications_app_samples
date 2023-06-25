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

export default function StickerTest() {
  describe('StickerTest', function () {
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
      let driver = await Driver.create();
      await driver.delayMs(1000);
      const tip: string = await getString($r('app.string.allow'));
      await driver.assertComponentExist(ON.text(tip));
      let stack = await driver.findComponent(ON.text(tip));
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
      // 选择图片,坐标选择,固定坐标只支持RK3568，其他设备需要调整
      await driver.click(535, 235);
      await driver.delayMs(1000);
      // 点击完成
      const completed: string = await getString($r('app.string.completed'));
      await driver.assertComponentExist(ON.text(completed));
      let finish = await driver.findComponent(ON.text(completed));
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
     * 点击标记
     */
    it(BUNDLE + 'Mark_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Mark_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      const mark: string = await getString($r('app.string.mark'));
      await driver.assertComponentExist(ON.text(mark));
      let stack = await driver.findComponent(ON.text(mark));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Mark_001 end');
    })

    /**
     * 点击贴纸
     */
    it(BUNDLE + 'Sticker_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Text_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      const sticker: string = await getString($r('app.string.sticker'));
      await driver.assertComponentExist(ON.text(sticker));
      let stack = await driver.findComponent(ON.text(sticker));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Sticker_001 end');
    })

    /**
     * 添加贴纸
     */
    it(BUNDLE + 'AddSticker_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSticker_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Cancel'));
      let cancel = await driver.findComponent(ON.id('Cancel'));
      await cancel.click();
      await driver.delayMs(1000);
      const sticker: string = await getString($r('app.string.sticker'));
      await driver.assertComponentExist(ON.text(sticker));
      let stack = await driver.findComponent(ON.text(sticker));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSticker_001 end');
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