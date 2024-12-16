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
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@kit.TestKit';
import { getString } from '../utils/ResourceUtil';

const TAG: string = '[Sample_NdkPixelMap]';
const DOMAIN = 0xF811;
const BUNDLE = 'NdkPixelMap_';
const DELAY_TIME = 1000;

export default function abilityTest() {
  let driver = Driver.create();
  let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.ndkpixelmap',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code);
        expect(0).assertEqual(err.code);
        done();
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
      }
    })
    /**
     * 进行图片解码
     */
    it(BUNDLE + 'ImageSourceC_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImageSourceC_001 begin');
      await driver.delayMs(DELAY_TIME);
      let tipDecode: string = getString($r('app.string.Decode_Image'));
      // 点击图片解码按钮
      await driver.assertComponentExist(ON.text(tipDecode));
      let btn = await driver.findComponent(ON.text(tipDecode));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImageSourceC_001 end');
      done();
    })

    /**
     * 进行位图操作
     */
    it(BUNDLE + 'ImagePixelmapC_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImagePixelmapC_001 begin');
      await driver.delayMs(DELAY_TIME);
      let tipPixelMap: string = getString($r('app.string.PixelMap_Operation'));
      // 点击位图操作按钮
      await driver.assertComponentExist(ON.text(tipPixelMap));
      let btn = await driver.findComponent(ON.text(tipPixelMap));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImagePixelmapC_001 end');
      done();
    })

    /**
     * 通过ImageSource进行图片编码
     */
    it(BUNDLE + 'ImagePackerC_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImagePackerC_001 begin');
      await driver.delayMs(DELAY_TIME);
      let tipEncode: string = getString($r('app.string.Encode_Image_ImageSource'));
      // 点击图片编码_ImageSource按钮
      await driver.assertComponentExist(ON.text(tipEncode));
      let btn = await driver.findComponent(ON.text(tipEncode));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImagePackerC_001 end');
      done();
    })
    /**
     * 通过Pixelmap进行图片编码
     */
    it(BUNDLE + 'ImagePackerC_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImagePackerC_002 begin');
      await driver.delayMs(DELAY_TIME);
      let tipEncode: string = getString($r('app.string.Encode_Image_PixelMap'));
      // 点击图片编码_PixelMap按钮
      await driver.assertComponentExist(ON.text(tipEncode));
      let btn = await driver.findComponent(ON.text(tipEncode));
      await btn.click();
      await driver.delayMs(DELAY_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ImagePackerC_002 end');
      done();
    })
  })
}