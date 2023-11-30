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
import { BusinessError } from '@ohos.base';

const TAG: string = '[Sample_Image]';
const DOMAIN: number = 0xF811;
const BUNDLE: string = 'Image_';

async function enterEdit() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickPhoto_001 begin');
  let driver = Driver.create();
  await driver.delayMs(1000);
  await driver.assertComponentExist(ON.id('Photo'));
  let photo = await driver.findComponent(ON.id('Photo'));
  await photo.click();
  await driver.delayMs(1000);
  await driver.assertComponentExist(ON.id('Edit'));
  let stack = await driver.findComponent(ON.id('Edit'));
  await stack.click();
  await driver.delayMs(1000);
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickPhoto_001 end');
}

async function saveEdit() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'Save_001 begin');
  let driver = Driver.create();
  await driver.assertComponentExist(ON.id('Save'));
  let scale = await driver.findComponent(ON.id('Save'));
  await scale.click();
  await driver.delayMs(1000);
  hilog.info(DOMAIN, TAG, BUNDLE + 'Save_001 end');
}

async function showColorSpace() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'ShowColorSpace_001 begin');
  let driver = Driver.create();
  await driver.delayMs(1000);
  let tip: string = getString($r('app.string.toning'));
  await driver.assertComponentExist(ON.text(tip));
  let stack = await driver.findComponent(ON.text(tip));
  let point = await stack.getBoundsCenter();
  // 拖动滑动条，固定坐标只支持RK3568，其他设备需要调整
  await driver.drag(point.x + 200, point.y, point.x - 200, point.y, 800);
  await driver.delayMs(1000);
  hilog.info(DOMAIN, TAG, BUNDLE + 'ShowColorSpace_001 end');
}

export default function ActsAbilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * @tc.number  StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it('StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
      await abilityDelegatorRegistry.executeShellCommand('aa start -a MainAbility -b ohos.samples.image');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * @tc.number  RequestPermissionFunction_001
     * @tc.name RequestPermissionFunction_001
     * @tc.desc 获取权限
     */
    it('RequestPermissionFunction_001', 1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(4000);
      let tipAllow: string = getString($r('app.string.allow'));
      await driver.assertComponentExist(ON.text(tipAllow));
      let stack = await driver.findComponent(ON.text(tipAllow));
      await stack.click();
      await driver.delayMs(1000);
      await stack.click();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * @tc.number  ChoosePhoto_001
     * @tc.name ChoosePhoto_001
     * @tc.desc 选择图片
     */
    it('ChoosePhoto_001', 2, async (done: Function) => {
      // 从相册中选择
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChoosePhoto_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('add'));
      let stack = await driver.findComponent(ON.id('add'));
      await stack.click();
      await driver.delayMs(3000);
      // 拍照,坐标选择,固定坐标只支持RK3568，其他设备需要调整
      let takePhoto: string = getString($r('app.string.takePhoto'));
      await driver.assertComponentExist(ON.text(takePhoto));
      let take_photo = await driver.findComponent(ON.text(takePhoto));
      // 点击拍照唤起相机
      await take_photo.click();
      await driver.delayMs(2500);
      // 点击拍照按钮，拍下一张照片
      await driver.click(362, 1100);
      await driver.delayMs(3000);
      // 点击确定存储照片
      await driver.click(663, 83);
      await driver.delayMs(3000);
      // 点击照片，选中一张照片
      let gridItems = await driver.findComponents(ON.type('GridItem'));
      await gridItems[4].click();
      await driver.delayMs(3000);
      // 点击完成
      let tipCompleted: string = getString($r('app.string.completed'));
      await driver.assertComponentExist(ON.text(tipCompleted));
      let finish = await driver.findComponent(ON.text(tipCompleted));
      await driver.delayMs(3000);
      await finish.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChoosePhoto_001 end');
    })

    /**
     * @tc.number  CropPhoto_001
     * @tc.name CropPhoto_001
     * @tc.desc 点击裁剪
     */
    it('CropPhoto_001', 3, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropPhoto_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 进入编辑
      await enterEdit();
      let tipCrop: string = getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let stack = await driver.findComponent(ON.text(tipCrop));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropPhoto_001 end');
    })

    /**
     * @tc.number  Crop4_3_001
     * @tc.name Crop4_3_001
     * @tc.desc 点击4:3
     */
    it('Crop4_3_001', 4, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop4:3_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let tipPercent: string = getString($r('app.string.percent43'));
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
     * @tc.number  Crop16_9_001
     * @tc.name Crop16_9_001
     * @tc.desc 点击16:9
     */
    it('Crop16_9_001', 5, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop16:9 begin');
      let driver = Driver.create();
      let tipCrop = getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let crop = await driver.findComponent(ON.text(tipCrop));
      await crop.click();
      await driver.delayMs(1000);
      let tipPercent = getString($r('app.string.percent169'));
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
     * @tc.number  Crop1_1_001
     * @tc.name Crop1_1_001
     * @tc.desc 点击1:1
     */
    it('Crop1_1_001', 6, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Crop1:1 begin');
      let driver = Driver.create();
      let tipCrop = getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let crop = await driver.findComponent(ON.text(tipCrop));
      await crop.click();
      await driver.delayMs(1000);
      let tipPercent = getString($r('app.string.percent11'));
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
     * @tc.number  CropOrigin_001
     * @tc.name CropOrigin_001
     * @tc.desc 点击原图
     */
    it('CropOrigin_001', 7, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropOrigin begin');
      let driver = Driver.create();
      let tipCrop = getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let crop = await driver.findComponent(ON.text(tipCrop));
      await crop.click();
      await driver.delayMs(1000);
      await driver.delayMs(1000);
      let tipOrigin = getString($r('app.string.origin'));
      await driver.assertComponentExist(ON.text(tipOrigin));
      let stack = await driver.findComponent(ON.text(tipOrigin));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      // 保存当前操作
      await saveEdit();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropOrigin end');
    })

    /**
     * @tc.number  ScalePhoto_001
     * @tc.name ScalePhoto_001
     * @tc.desc 点击缩放
     */
    it('ScalePhoto_001', 8, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ScalePhoto_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入编辑
      await enterEdit();
      let tip: string = getString($r('app.string.scale'));
      await driver.assertComponentExist(ON.text(tip));
      let stack = await driver.findComponent(ON.text(tip));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ScalePhoto_001 end');
    })

    /**
     * @tc.number  Scale_001
     * @tc.name Scale_001
     * @tc.desc 点击缩小
     */
    it('Scale_001', 9, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Scale_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let zoomOut: string = getString($r('app.string.zoomOut'));
      await driver.assertComponentExist(ON.text(zoomOut));
      let stack = await driver.findComponent(ON.text(zoomOut));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Scale_001 end');
    })

    /**
     * @tc.number  Scale_002
     * @tc.name Scale_002
     * @tc.desc 点击放大
     */
    it('Scale_002', 10, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Scale_002 begin');
      let driver = Driver.create();
      let tip = getString($r('app.string.scale'));
      await driver.assertComponentExist(ON.text(tip));
      let scale = await driver.findComponent(ON.text(tip));
      await scale.click();
      await driver.delayMs(1000);
      let zoomIn = getString($r('app.string.zoomIn'));
      await driver.assertComponentExist(ON.text(zoomIn));
      let stack = await driver.findComponent(ON.text(zoomIn));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      // 保存当前编辑
      await saveEdit();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Scale_002 end');
    })

    /**
     * @tc.number  RotatePhoto_001
     * @tc.name RotatePhoto_001
     * @tc.desc 点击旋转
     */
    it('RotatePhoto_001', 11, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RotatePhoto_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入编辑
      await enterEdit();
      let tip: string = getString($r('app.string.rotate'));
      await driver.assertComponentExist(ON.text(tip));
      let stack = await driver.findComponent(ON.text(tip));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'RotatePhoto_001 end');
    })

    /**
     * @tc.number  Rotate_001
     * @tc.name Rotate_001
     * @tc.desc 旋转-90度
     */
    it('Rotate_001', 12, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Rotate_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('-90'));
      let rotate90 = await driver.findComponent(ON.id('-90'));
      await rotate90.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Rotate_001 end');
    })

    /**
     * @tc.number  Rotate_002
     * @tc.name Rotate_002
     * @tc.desc 旋转90度
     */
    it('Rotate_002', 13, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Rotate_002 begin');
      let driver = Driver.create();
      let tip = getString($r('app.string.rotate'));
      await driver.assertComponentExist(ON.text(tip));
      let scale = await driver.findComponent(ON.text(tip));
      await scale.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('90'));
      let rotate90 = await driver.findComponent(ON.id('90'));
      await rotate90.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      // 保存当前编辑
      await saveEdit();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Rotate_002 end');
    })

    /**
     * @tc.number  ToningPhoto_001
     * @tc.name ToningPhoto_001
     * @tc.desc 点击调色
     */
    it('ToningPhoto_001', 14, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ToningPhoto_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入编辑
      await enterEdit();
      let tip: string = getString($r('app.string.toning'));
      await driver.assertComponentExist(ON.text(tip));
      let stack = await driver.findComponent(ON.text(tip));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ToningPhoto_001 end');
    })

    /**
     * @tc.number  Toning_001
     * @tc.name Toning_001
     * @tc.desc 拖动滑动条
     */
    it('Toning_001', 15, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Toning_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Slider'));
      let slider = await driver.findComponent(ON.id('Slider'));
      let point = await slider.getBoundsCenter();
      // 拖动滑动条，固定坐标只支持RK3568，其他设备需要调整
      await driver.drag(point.x - 50, point.y, point.x + 50, point.y, 800);
      await slider.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      // 保存当前编辑
      await saveEdit();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Scale_001 end');
    })

    /**
     * @tc.number  Mark_001
     * @tc.name Mark_001
     * @tc.desc 点击标记
     */
    it('Mark_001', 16, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Mark_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入编辑
      await enterEdit();
      let mark: string = getString($r('app.string.mark'));
      await driver.assertComponentExist(ON.text(mark));
      let stack = await driver.findComponent(ON.text(mark));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Mark_001 end');
    })

    /**
     * @tc.number  Text_001
     * @tc.name Text_001
     * @tc.desc 点击文字
     */
    it('Text_001', 17, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Text_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let text: string = getString($r('app.string.text'));
      await driver.assertComponentExist(ON.text(text));
      let stack = await driver.findComponent(ON.text(text));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Text_001 end');
    })

    /**
     * @tc.number  TextInput_001
     * @tc.name TextInput_001
     * @tc.desc 输入文字
     */
    it('TextInput_001', 18, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TextInput_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('TextInput'));
      let input = await driver.findComponent(ON.id('TextInput'));
      await input.inputText('ttt');
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Sure'));
      let sure = await driver.findComponent(ON.id('Sure'));
      await sure.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TextInput_001 end');
    })

    /**
     * @tc.number  Repeal_001
     * @tc.name Repeal_001
     * @tc.desc 点击撤销
     */
    it('Repeal_001', 19, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Repeal_001 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.id('Repeal'));
      let scale = await driver.findComponent(ON.id('Repeal'));
      await scale.click();
      await driver.delayMs(1000);
      // 保存当前编辑
      await saveEdit();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Repeal_001 end');
    })

    /**
     * @tc.number  Mark_002
     * @tc.name Mark_002
     * @tc.desc 点击标记
     */
    it('Mark_002', 20, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'Mark_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入编辑
      await enterEdit();
      let mark: string = getString($r('app.string.mark'));
      await driver.assertComponentExist(ON.text(mark));
      let stack = await driver.findComponent(ON.text(mark));
      await stack.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'Mark_002 end');
    })

    /**
     * @tc.number  AddSticker_001
     * @tc.name AddSticker_001
     * @tc.desc 添加贴纸
     */
    it('AddSticker_001', 21, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSticker_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let sticker: string = getString($r('app.string.sticker'));
      await driver.assertComponentExist(ON.text(sticker));
      let stack = await driver.findComponent(ON.text(sticker));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      // 保存当前编辑
      await saveEdit();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddSticker_001 end');
    })

    /**
     * @tc.number  ColorSpace_001
     * @tc.name ColorSpace_001
     * @tc.desc 点击色域
     */
    it('ColorSpace_001', 22, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpace_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 进入编辑
      await enterEdit();
      await showColorSpace();
      let tip = getString($r('app.string.colorSpace'));
      await driver.assertComponentExist(ON.text(tip));
      let colorSpace = await driver.findComponent(ON.text(tip));
      await colorSpace.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpace_001 end');
    })

    /**
     * @tc.number  ColorSpacePhoto_001
     * @tc.name ColorSpacePhoto_001
     * @tc.desc 点击调整色域 SRGB
     */
    it('ColorSpacePhoto_001', 23, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_001 begin');
      let driver = Driver.create();
      let colorSpace = getString($r('app.string.colorSpaceSRGB'));
      await driver.assertComponentExist(ON.text(colorSpace));
      let stack = await driver.findComponent(ON.text(colorSpace));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_001 end');
    })

    /**
     * @tc.number  ColorSpacePhoto_002
     * @tc.name ColorSpacePhoto_002
     * @tc.desc 点击调整色域 AdobeRGB
     */
    it('ColorSpacePhoto_002', 24, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_002 begin');
      let driver = Driver.create();
      await showColorSpace();
      let tip = getString($r('app.string.colorSpace'));
      await driver.assertComponentExist(ON.text(tip));
      let colorSpaceBtn = await driver.findComponent(ON.text(tip));
      await colorSpaceBtn.click();
      await driver.delayMs(1000);
      let colorSpace = getString($r('app.string.colorSpaceAdobeRGB'));
      await driver.assertComponentExist(ON.text(colorSpace));
      let stack = await driver.findComponent(ON.text(colorSpace));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_002 end');
    })

    /**
     * @tc.number  ColorSpacePhoto_003
     * @tc.name ColorSpacePhoto_003
     * @tc.desc 点击调整色域 DCIP3
     */
    it('ColorSpacePhoto_003', 25, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_003 begin');
      let driver = Driver.create();
      await showColorSpace();
      let tip = getString($r('app.string.colorSpace'));
      await driver.assertComponentExist(ON.text(tip));
      let colorSpaceBtn = await driver.findComponent(ON.text(tip));
      await colorSpaceBtn.click();
      await driver.delayMs(1000);
      let colorSpace = getString($r('app.string.colorSpaceDCIP3'));
      await driver.assertComponentExist(ON.text(colorSpace));
      let stack = await driver.findComponent(ON.text(colorSpace));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_003 end');
    })

    /**
     * @tc.number  ColorSpacePhoto_004
     * @tc.name ColorSpacePhoto_004
     * @tc.desc 点击调整色域 DisplayP3
     */
    it('ColorSpacePhoto_004', 26, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_004 begin');
      let driver = Driver.create();
      await showColorSpace();
      let tip = getString($r('app.string.colorSpace'));
      await driver.assertComponentExist(ON.text(tip));
      let scale = await driver.findComponent(ON.text(tip));
      await scale.click();
      await driver.delayMs(1000);
      let colorSpace = getString($r('app.string.colorSpaceDisplayP3'));
      await driver.assertComponentExist(ON.text(colorSpace));
      let stack = await driver.findComponent(ON.text(colorSpace));
      await stack.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Ok'));
      let ok = await driver.findComponent(ON.id('Ok'));
      await ok.click();
      await driver.delayMs(1000);
      // 保存当前编辑
      await saveEdit();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ColorSpacePhoto_004 end');
    })

  })
}