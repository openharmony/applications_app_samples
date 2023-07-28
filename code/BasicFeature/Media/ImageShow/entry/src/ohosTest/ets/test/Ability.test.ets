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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';

const DRIVER = Driver.create();

export default function abilityTest() {
  describe('ActsAbilityTest', function () {

    /**
     * 拉起相机拍三张照片
     */
    it('StartAbility_001', 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'com.ohos.camera',
          abilityName: 'com.ohos.camera.MainAbility'
        });
        await DRIVER.delayMs(4000);
        await DRIVER.click(360, 1090);
        await DRIVER.delayMs(1000);
        await DRIVER.click(360, 1090);
        await DRIVER.delayMs(1000);
        await DRIVER.click(360, 1090);
        await DRIVER.delayMs(1000);
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0x0000, 'testTag', 'StartAbility_001 end');
    })

    /**
     * 拉起应用
     */
    it('StartAbility_002', 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'StartAbility_002 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.imageshow',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(0x0000, 'testTag', 'StartAbility_002 end');
    })

    /**
     * 授权
     */
    it('GetPermission_001', 0, async function (done) {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'GetPermission_001 begin');
      await DRIVER.delayMs(2000);
      await DRIVER.assertComponentExist(ON.text('允许'));
      let allowBtn = await DRIVER.findComponent(ON.text('允许'));
      await allowBtn.click();
      await DRIVER.delayMs(1000);
      await allowBtn.click();
      await DRIVER.delayMs(1000);
      done();
      hilog.info(0x0000, 'testTag', 'GetPermission_001 end');
    })

    /**
     * 输入评价
     */
    it('EditComment_001', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'EditComment_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('comment'));
      let textArea = await DRIVER.findComponent(ON.id('comment'));
      await textArea.inputText('this is a comment');
      await DRIVER.delayMs(1000);
      expect(await textArea.getText()).assertEqual('this is a comment');
      hilog.info(0x0000, 'testTag', 'EditComment_001 end');
    })

    /**
     * 跳转到选择图片页面
     */
    it('JumpToChoicePage_001', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'JumpToChoicePage_001 begin');
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text('添加图片/照片'));
      let choicePhotoBtn = await DRIVER.findComponent(ON.text('添加图片/照片'));
      await choicePhotoBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('nextStep'));
      hilog.info(0x0000, 'testTag', 'JumpToChoicePage_001 end');
    })

    /**
     * 选择图片
     */
    it('ChoicePhoto_001', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'ChoicePhoto_001 begin');
      await DRIVER.assertComponentExist(ON.id('image1'));
      let image1 = await DRIVER.findComponent(ON.id('image1'));
      await image1.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('select1'));
      await DRIVER.assertComponentExist(ON.id('selected1'));
      await DRIVER.assertComponentExist(ON.id('image2'));
      let image2 = await DRIVER.findComponent(ON.id('image2'));
      await image2.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('select2'));
      await DRIVER.assertComponentExist(ON.id('selected2'));
      await DRIVER.assertComponentExist(ON.id('image3'));
      let image3 = await DRIVER.findComponent(ON.id('image3'));
      await image3.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('select3'));
      await DRIVER.assertComponentExist(ON.id('selected3'));
      hilog.info(0x0000, 'testTag', 'ChoicePhoto_001 end');
    })

    /**
     * 删除图片---sample有bug，已告知，待修复
     */
    it('DeleteImage_001', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'DeleteImage_001 begin');
      await DRIVER.assertComponentExist(ON.id('deleteImage3'));
      let deleteImageBtn = await DRIVER.findComponent(ON.id('deleteImage3'));
      await deleteImageBtn.click();
      await DRIVER.delayMs(1000);
      let select3 = await DRIVER.findComponents(ON.id('select3'));
      expect(select3).assertNull();
      hilog.info(0x0000, 'testTag', 'DeleteImage_001 end');
    })

    /**
     * 切换到选视频再切回选照片
     */
    it('ChangeImage_001', 0, async function () {
      hilog.info(0x0000, 'testTag', 'ChangeImage_001 begin');
      // 切换到选视频
      await DRIVER.assertComponentExist(ON.id('type1'));
      let changeVideoBtn = await DRIVER.findComponent(ON.id('type1'));
      await changeVideoBtn.click();
      await DRIVER.delayMs(1000);
      // 关闭弹窗
      await DRIVER.assertComponentExist(ON.id('type0'));
      let changeImageBtn = await DRIVER.findComponent(ON.id('type0'));
      await changeImageBtn.click();
      await DRIVER.delayMs(1000);
      // 切回到选照片
      await DRIVER.assertComponentExist(ON.id('type0'));
      let changeImageBtn1 = await DRIVER.findComponent(ON.id('type0'));
      await changeImageBtn1.click();
      await DRIVER.delayMs(1000);
      hilog.info(0x0000, 'testTag', 'ChangeImage_001 end');
    })

    /**
     * 再次选择图片
     */
    it('ChoicePhotoAgain_001', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'ChoicePhotoAgain_001 begin');
      await DRIVER.assertComponentExist(ON.id('image1'));
      let image1 = await DRIVER.findComponent(ON.id('image1'));
      await image1.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('select1'));
      await DRIVER.assertComponentExist(ON.id('selected1'));
      await DRIVER.assertComponentExist(ON.id('image2'));
      let image2 = await DRIVER.findComponent(ON.id('image2'));
      await image2.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('select2'));
      await DRIVER.assertComponentExist(ON.id('selected2'));
      hilog.info(0x0000, 'testTag', 'ChoicePhotoAgain_001 end');
    })

    /**
     * 返回主页
     */
    it('BackToIndex_001', 0, async function () {
      // Defines a test case. This API supports three parameters: test case name, filter parameter, and test case function.
      hilog.info(0x0000, 'testTag', 'BackToIndex_001 begin');
      await DRIVER.assertComponentExist(ON.id('nextStep'));
      let nextStepBtn = await DRIVER.findComponent(ON.id('nextStep'));
      await nextStepBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('image'));
      let imageArray = await DRIVER.findComponents(ON.id('image'));
      expect(imageArray.length).assertEqual(2);
      hilog.info(0x0000, 'testTag', 'BackToIndex_001 end');
    })
  })
}