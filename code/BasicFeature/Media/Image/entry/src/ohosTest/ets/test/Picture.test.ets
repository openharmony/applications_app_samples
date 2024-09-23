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
import { describe, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import { getString } from '../utils/ResourceUtil';
import { BusinessError } from '@ohos.base';

const TAG: string = '[Sample_Image]';
const DOMAIN: number = 0xF811;
const BUNDLE: string = 'Image_';

async function enterPicture() {
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickPicture_001 begin');
  let driver = Driver.create();
  await driver.delayMs(1000);
  await driver.assertComponentExist(ON.id('picture_operate'));
  let photo = await driver.findComponent(ON.id('picture_operate'));
  await photo.click();
  await driver.delayMs(1000);
  hilog.info(DOMAIN, TAG, BUNDLE + 'ClickPicture_001 end');
}

export default function PictureAbilityTest() {
  describe('PictureAbilityTest', () => {
    /**
     * @tc.number  StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it('StartPictureAbility_001', 0, async (done: Function) => {
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
    it('PictureRequestPermissionFunction_001', 1, async (done: Function) => {
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
     * @tc.number  DecodingPicture_001
     * @tc.name DecodingPicture_001
     * @tc.desc 点击修改js接口选择解码类型
     */
    it('DecodingPicture_001', 31, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_001 begin');
      let driver = Driver.create() ;
      // 进入多图编辑
      await enterPicture();
      //点击js接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('external'));
      let external = await driver.findComponent(ON.id('external'));
      await external.click();
      // 点击解码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('decodingJs'));
      let decodingJs = await driver.findComponent(ON.id('decodingJs'));
      await decodingJs.click();
      // 点击JPEG
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('jpegJs'));
      let jpegJs = await driver.findComponent(ON.id('jpegJs'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_001 end');
    })

    /**
     * @tc.number  DecodingPicture_002
     * @tc.name DecodingPicture_002
     * @tc.desc 点击修改js接口选择解码类型
     */
    it('DecodingPicture_002', 32, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_002 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击js接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('external'));
      let external = await driver.findComponent(ON.id('external'));
      await external.click();
      // 点击解码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('decodingJs'));
      let decodingJs = await driver.findComponent(ON.id('decodingJs'));
      await decodingJs.click();
      // 点击HEIF
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('heifJs'));
      let jpegJs = await driver.findComponent(ON.id('heifJs'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_002 end');
    })

    /**
     * @tc.number  DecodingPicture_003
     * @tc.name DecodingPicture_003
     * @tc.desc 点击修改native接口选择解码类型
     */
    it('DecodingPicture_003', 33, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_003 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击Native接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inner'));
      let external = await driver.findComponent(ON.id('inner'));
      await external.click();
      // 点击解码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('decodingNdk'));
      let decodingJs = await driver.findComponent(ON.id('decodingNdk'));
      await decodingJs.click();
      // 点击JPEG
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('jpegNdk'));
      let jpegJs = await driver.findComponent(ON.id('jpegNdk'));
      await jpegJs.click();
      //back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_003 end');
    })

    /**
     * @tc.number  DecodingPicture_004
     * @tc.name DecodingPicture_004
     * @tc.desc 点击修改native接口选择解码类型
     */
    it('DecodingPicture_004', 34, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_004 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击Native接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inner'));
      let external = await driver.findComponent(ON.id('inner'));
      await external.click();
      // 点击解码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('decodingNdk'));
      let decodingJs = await driver.findComponent(ON.id('decodingNdk'));
      await decodingJs.click();
      // 点击HEIF
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('heifNdk'));
      let jpegJs = await driver.findComponent(ON.id('heifNdk'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodingPicture_004 end');
    })

    /**
     * @tc.number  EncodingPicture_001
     * @tc.name EncodingPicture_001
     * @tc.desc 点击修改js接口选择编码方式
     */
    it('EncodingPicture_001', 35, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_001 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击js接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('external'));
      let external = await driver.findComponent(ON.id('external'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingJs'));
      let decodingJs = await driver.findComponent(ON.id('encodingJs'));
      await decodingJs.click();
      // 点击sourceToBuffer
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('sourceToDataJs'));
      let jpegJs = await driver.findComponent(ON.id('sourceToDataJs'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_001 end');
    })

    /**
     * @tc.number  EncodingPicture_002
     * @tc.name EncodingPicture_002
     * @tc.desc 点击修改js接口选择编码方式
     */
    it('EncodingPicture_002', 36, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_002 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击js接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('external'));
      let external = await driver.findComponent(ON.id('external'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingJs'));
      let decodingJs = await driver.findComponent(ON.id('encodingJs'));
      await decodingJs.click();
      // 点击sourceToFile
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('sourceToFileJs'));
      let jpegJs = await driver.findComponent(ON.id('sourceToFileJs'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_002 end');
    })

    /**
     * @tc.number  EncodingPicture_003
     * @tc.name EncodingPicture_003
     * @tc.desc 点击修改js接口选择编码方式
     */
    it('EncodingPicture_003', 37, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_003 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击js接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('external'));
      let external = await driver.findComponent(ON.id('external'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingJs'));
      let decodingJs = await driver.findComponent(ON.id('encodingJs'));
      await decodingJs.click();
      // 点击pictureToBuffer
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('pictureToDataJs'));
      let jpegJs = await driver.findComponent(ON.id('pictureToDataJs'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_003 end');
    })

    /**
     * @tc.number  EncodingPicture_004
     * @tc.name EncodingPicture_004
     * @tc.desc 点击修改js接口选择编码方式
     */
    it('EncodingPicture_004', 38, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_004 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击js接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('external'));
      let external = await driver.findComponent(ON.id('external'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingJs'));
      let decodingJs = await driver.findComponent(ON.id('encodingJs'));
      await decodingJs.click();
      // 点击pictureToFile
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('pictureToFileJs'));
      let jpegJs = await driver.findComponent(ON.id('pictureToFileJs'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_004 end');
    })

    /**
     * @tc.number  EncodingPicture_005
     * @tc.name EncodingPicture_005
     * @tc.desc 点击修改native接口选择编码方式
     */
    it('EncodingPicture_005', 39, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_005 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击Native接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inner'));
      let external = await driver.findComponent(ON.id('inner'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingNdk'));
      let decodingJs = await driver.findComponent(ON.id('encodingNdk'));
      await decodingJs.click();
      // 点击sourceToBuffer
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('sourceToDataNdk'));
      let jpegJs = await driver.findComponent(ON.id('sourceToDataNdk'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_005 end');
    })

    /**
     * @tc.number  EncodingPicture_006
     * @tc.name EncodingPicture_006
     * @tc.desc 点击修改native接口选择编码方式
     */
    it('EncodingPicture_006', 40, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_006 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击Native接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inner'));
      let external = await driver.findComponent(ON.id('inner'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingNdk'));
      let decodingJs = await driver.findComponent(ON.id('encodingNdk'));
      await decodingJs.click();
      //点击sourceToFile
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('sourceToFileNdk'));
      let jpegJs = await driver.findComponent(ON.id('sourceToFileNdk'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_006 end');
    })

    /**
     * @tc.number  EncodingPicture_007
     * @tc.name EncodingPicture_007
     * @tc.desc 点击修改native接口选择编码方式
     */
    it('EncodingPicture_007', 41, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_007 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击Native接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inner'));
      let external = await driver.findComponent(ON.id('inner'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingNdk'));
      let decodingJs = await driver.findComponent(ON.id('encodingNdk'));
      await decodingJs.click();
      // 点击pictureToData
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('pictureToDataNdk'));
      let jpegJs = await driver.findComponent(ON.id('pictureToDataNdk'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_007 end');
    })

    /**
     * @tc.number  EncodingPicture_008
     * @tc.name EncodingPicture_008
     * @tc.desc 点击修改native接口选择编码方式
     */
    it('EncodingPicture_008', 42, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_008 begin');
      let driver = Driver.create() ;
      // 点击图片处理
      await driver.delayMs(1000);
      await enterPicture();
      // 点击Native接口
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inner'));
      let external = await driver.findComponent(ON.id('inner'));
      await external.click();
      // 点击编码
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encodingNdk'));
      let decodingJs = await driver.findComponent(ON.id('encodingNdk'));
      await decodingJs.click();
      // 点击pictureToFile
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('pictureToFileNdk'));
      let jpegJs = await driver.findComponent(ON.id('pictureToFileNdk'));
      await jpegJs.click();
      // back
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('back'));
      let back = await driver.findComponent(ON.id('back'));
      await back.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodingPicture_008 end');
    })
  })
}