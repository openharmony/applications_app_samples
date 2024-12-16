/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { getString } from '../utils/ResourceUtil';
import { UIAbility, Want } from '@kit.AbilityKit';

const TAG: string = '[Sample_PixelMap]';
const DOMAIN: number = 0xF811;
const BUNDLE: string = 'PixelMap_';
const DELAY_TIME = 300;

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

async function resetImage(){
  hilog.info(DOMAIN, TAG, BUNDLE + 'ResetImage_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME);
  let tipReset: string = getString($r('app.string.reset_image'));
  await driver.assertComponentExist(ON.text(tipReset));
  let cut = await driver.findComponent(ON.text(tipReset));
  await cut.click();
  await driver.delayMs(DELAY_TIME);
  hilog.info(DOMAIN, TAG, BUNDLE + 'ResetImage_001 end');
}

async function enterCut() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterCut_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME);
  let tipCut: string = getString($r('app.string.cut'));
  await driver.assertComponentExist(ON.text(tipCut));
  let cut = await driver.findComponent(ON.text(tipCut));
  await cut.click();
  await driver.delayMs(DELAY_TIME);
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterCut_001 end');
}

async function enterFlip() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFlip_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME);
  let tipFlip: string = getString($r('app.string.flip'));
  await driver.assertComponentExist(ON.text(tipFlip));
  let Flip = await driver.findComponent(ON.text(tipFlip));
  await Flip.click();
  await driver.delayMs(DELAY_TIME);
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFlip_001 end');
}

async function enterToning() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFlip_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME);
  let tipToning: string = getString($r('app.string.toning'));
  await driver.assertComponentExist(ON.text(tipToning));
  let Flip = await driver.findComponent(ON.text(tipToning));
  await Flip.click();
  await driver.delayMs(DELAY_TIME);
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFlip_001 end');
}

async function enterFileOperation() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFileOperation_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME);
  let tipFile: string = getString($r('app.string.file_operation'));
  await driver.assertComponentExist(ON.text(tipFile));
  let File = await driver.findComponent(ON.text(tipFile));
  await File.click();
  await driver.delayMs(DELAY_TIME);
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterFileOperation_001 end');
}


export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * @tc.number  StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it('StartAbility_001',0, async (done: Function) => {
      console.info("uitest: StartAbility_001 begin");
      //start tested ability
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      }
      await delegator.startAbility(want);
      await sleep(DELAY_TIME);
      //check top display ability
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      console.info("uitest: StartAbility_001 end");
    })


    /**
     * @tc.number  CropImage_001
     * @tc.name CropImage_001
     * @tc.desc 点击裁剪
     */
    it('CropImage_001', 1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      await enterCut();
      let tipCrop: string = getString($r('app.string.crop'));
      await driver.assertComponentExist(ON.text(tipCrop));
      let stack = await driver.findComponent(ON.text(tipCrop));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropImage_001 end');
    })

    /**
     * @tc.number  scaleImage_001
     * @tc.name scaleImage_001
     * @tc.desc 点击缩放
     */
    it('scaleImage_001', 2, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipScale: string = getString($r('app.string.scale'));
      await driver.assertComponentExist(ON.text(tipScale));
      let stack = await driver.findComponent(ON.text(tipScale));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CropImage_001 end');
    })

    /**
     * @tc.number  scaleImage_001
     * @tc.name scaleImage_001
     * @tc.desc 点击向右下移动
     */
    it('translateImage_001', 3, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'translateImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipTranslate: string = getString($r('app.string.translate'));
      await driver.assertComponentExist(ON.text(tipTranslate));
      let stack = await driver.findComponent(ON.text(tipTranslate));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'translateImage_001 end');
    })

    /**
     * @tc.number  clockwiseRotateImage_001
     * @tc.name clockwiseRotateImage_001
     * @tc.desc 点击顺时针旋转
     */
    it('clockwiseRotateImage_001', 4, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'clockwiseRotateImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      await enterFlip();
      let tipClockwiseRotate: string = getString($r('app.string.clockwise_rotate'));
      await driver.assertComponentExist(ON.text(tipClockwiseRotate));
      let stack = await driver.findComponent(ON.text(tipClockwiseRotate));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'clockwiseRotateImage_001 end');
    })

    /**
     * @tc.number  verticalFlipImage_001
     * @tc.name verticalFlipImage_001
     * @tc.desc 点击垂直翻转
     */
    it('verticalFlipImage_001', 5, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'verticalFlipImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipVerticalFlip: string = getString($r('app.string.vertical_flip'));
      await driver.assertComponentExist(ON.text(tipVerticalFlip));
      let stack = await driver.findComponent(ON.text(tipVerticalFlip));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'verticalFlipImage_001 end');
    })

    /**
     * @tc.number  horizontalFlipImage_001
     * @tc.name horizontalFlipImage_001
     * @tc.desc 点击水平翻转
     */
    it('horizontalFlipImage_001', 6, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'horizontalFlipImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipHorizontalFlip: string = getString($r('app.string.horizontal_flip'));
      await driver.assertComponentExist(ON.text(tipHorizontalFlip));
      let stack = await driver.findComponent(ON.text(tipHorizontalFlip));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'horizontalFlipImage_001 end');
    })

    /**
     * @tc.number  bitmapOperation_001
     * @tc.name bitmapOperation_001
     * @tc.desc 点击位图操作
     */
    it('bitmapOperation_001', 7, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'bitmapOperation_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      await enterToning();
      let tipBitmapOperation: string = getString($r('app.string.bitmap_operation'));
      await driver.assertComponentExist(ON.text(tipBitmapOperation));
      let stack = await driver.findComponent(ON.text(tipBitmapOperation));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'bitmapOperation_001 end');
    })

    /**
     * @tc.number  bitmapOperationAll_001
     * @tc.name bitmapOperationAll_001
     * @tc.desc 点击位图操作全部
     */
    it('bitmapOperationAll_001', 8, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'bitmapOperationAll_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipBitmapOperationAll: string = getString($r('app.string.bitmap_operation_all'));
      await driver.assertComponentExist(ON.text(tipBitmapOperationAll));
      let stack = await driver.findComponent(ON.text(tipBitmapOperationAll));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'bitmapOperationAll_001 end');
    })

    /**
     * @tc.number  changeOpacity_001
     * @tc.name changeOpacity_001
     * @tc.desc 点击设置透明度
     */
    it('changeOpacity_001', 9, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'changeOpacity_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipChangeOpacity: string = getString($r('app.string.change_opacity'));
      await driver.assertComponentExist(ON.text(tipChangeOpacity));
      let stack = await driver.findComponent(ON.text(tipChangeOpacity));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      await resetImage();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'changeOpacity_001 end');
    })

    /**
     * @tc.number  saveImage_001
     * @tc.name saveImage_001
     * @tc.desc 点击保存图片
     */
    it('saveImage_001', 10, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'saveImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      await enterFileOperation();
      let tipSaveImage: string = getString($r('app.string.save_image'));
      await driver.assertComponentExist(ON.text(tipSaveImage));
      let stack = await driver.findComponent(ON.text(tipSaveImage));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'saveImage_001 end');
    })

    /**
     * @tc.number  openImage_001
     * @tc.name openImage_001
     * @tc.desc 点击打开图片
     */
    it('openImage_001', 11, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'openImage_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipOpenImage: string = getString($r('app.string.open_image'));
      await driver.assertComponentExist(ON.text(tipOpenImage));
      let stack = await driver.findComponent(ON.text(tipOpenImage));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'openImage_001 end');
    })

    /**
     * @tc.number  editEXIF_001
     * @tc.name editEXIF_001
     * @tc.desc 点击编辑EXIF信息
     */
    it('editEXIF_001', 12, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'editEXIF_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      let tipEditEXIF: string = getString($r('app.string.edit_EXIF'));
      await driver.assertComponentExist(ON.text(tipEditEXIF));
      let stack = await driver.findComponent(ON.text(tipEditEXIF));
      await stack.click();
      await driver.delayMs(DELAY_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'editEXIF_001 end');
    })
  })
}