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
import { UIAbility, Want } from '@kit.AbilityKit';
import { getString } from '../utils/ResourceUtil';

const TAG: string = '[Sample_NdkPixelMap_js]';
const DOMAIN: number = 0xF811;
const BUNDLE: string = 'NdkPixelMap_js_';
const DELAY_TIME_SHORT = 200;
const DELAY_TIME_lONG = 500;

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

async function enterDecode(){
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterDecode_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME_SHORT);
  let tipDecode: string = getString($r('app.string.Decode_Images'));
  await driver.assertComponentExist(ON.text(tipDecode));
  let enterDecode = await driver.findComponent(ON.text(tipDecode));
  await enterDecode.click();
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterDecode_001 end');
}

async function enterTransform(){
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterTransform_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME_SHORT);
  let tipTransform: string = getString($r('app.string.Transform_Images'));
  await driver.assertComponentExist(ON.text(tipTransform));
  let enterTransform = await driver.findComponent(ON.text(tipTransform));
  await enterTransform.click();
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterTransform_001 end');
}

async function enterPixelMap(){
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterPixelMap_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME_SHORT);
  let tipTransform: string = getString($r('app.string.Process_PixelMap_Data'));
  await driver.assertComponentExist(ON.text(tipTransform));
  let enterTransform = await driver.findComponent(ON.text(tipTransform));
  await enterTransform.click();
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterPixelMap_001 end');
}

async function enterEncode(){
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterEncode_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME_SHORT);
  let tipEncode: string = getString($r('app.string.Encode_Images'));
  await driver.assertComponentExist(ON.text(tipEncode));
  let enterEncode = await driver.findComponent(ON.text(tipEncode));
  await enterEncode.click();
  hilog.info(DOMAIN, TAG, BUNDLE + 'EnterEncode_001 end');
}

async function goBack(){
  hilog.info(DOMAIN, TAG, BUNDLE + 'GoBack_001 begin');
  let driver = Driver.create();
  await driver.delayMs(DELAY_TIME_SHORT);
  let tipBack: string = getString($r('app.string.Go_Back'));
  await driver.assertComponentExist(ON.text(tipBack));
  let Back = await driver.findComponent(ON.text(tipBack));
  await Back.click();
  hilog.info(DOMAIN, TAG, BUNDLE + 'GoBack_001 end');
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
      };
      await delegator.startAbility(want);
      await sleep(DELAY_TIME_SHORT);
      //check top display ability
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info("get top ability");
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      console.info("uitest: StartAbility_001 end");
    })

    /**
     * @tc.number  DecodeImages_001
     * @tc.name DecodeImages_001
     * @tc.desc 图片解码
     */
    it('DecodeImages_001', 1, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodeImages_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME_SHORT);
      await enterDecode();
      await driver.delayMs(DELAY_TIME_lONG);
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DecodeImages_001 end');
    })

    /**
     * @tc.number  TransformImages_001
     * @tc.name TransformImages_001
     * @tc.desc 图片变换
     */
    it('TransformImages_001', 2, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformImages_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME_SHORT);
      await enterTransform();
      let tipTransform: string = getString($r('app.string.IMAGE'));
      await driver.assertComponentExist(ON.text(tipTransform));
      let Transform = await driver.findComponent(ON.text(tipTransform));
      await Transform.click();
      await driver.delayMs(DELAY_TIME_SHORT);
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TransformImages_001 end');
    })

    /**
     * @tc.number  PixelMap_001
     * @tc.name PixelMap_001
     * @tc.desc 处理PixelMap数据
     */
    it('PixelMap_001', 3, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PixelMap_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME_SHORT);
      await enterPixelMap();
      let tipPixelMap: string = getString($r('app.string.PixelMap'));
      await driver.assertComponentExist(ON.text(tipPixelMap));
      let PixelMap = await driver.findComponent(ON.text(tipPixelMap));
      await PixelMap.click();
      await driver.delayMs(DELAY_TIME_SHORT);
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'PixelMap_001 end');
    })

    /**
     * @tc.number  EncodeImages_001
     * @tc.name EncodeImages_001
     * @tc.desc 图片编码
     */
    it('EncodeImages_001', 4, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodeImages_001 begin');
      let driver = Driver.create();
      await driver.delayMs(DELAY_TIME_SHORT);
      await enterEncode();
      let tipEncode: string = getString($r('app.string.Encode_Images'));
      await driver.assertComponentExist(ON.text(tipEncode));
      let Encode = await driver.findComponent(ON.text(tipEncode));
      await Encode.click();
      await driver.delayMs(DELAY_TIME_SHORT);
      await goBack();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EncodeImages_001 end');
    })
  })
}