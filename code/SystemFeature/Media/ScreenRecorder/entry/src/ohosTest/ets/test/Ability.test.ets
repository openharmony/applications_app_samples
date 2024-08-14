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

import { describe, expect, it } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { getString } from '../utils/ResourceUtil';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';

const TAG: string = 'abilityTest';
const DRIVER = Driver.create();
const DOMAIN = 0xF811;
const BUNDLE = 'ScreenRecorder_';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();
let mediaDataCount: number
let media: photoAccessHelper.PhotoAccessHelper

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done : () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.screenrecorder',
          abilityName: 'MainAbility'
        })
        done();
      } catch (err) {
        expect(0).assertEqual(err.code);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 授权
     */
    it('GetPermission_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetPermission_001 begin');
      await DRIVER.delayMs(3000);
      let tipAllow = getString($r('app.string.allow'));
      await DRIVER.assertComponentExist(ON.text(tipAllow));
      // 访问图片和视频
      let allowBtn1 = await DRIVER.findComponent(ON.text(tipAllow));
      await allowBtn1.click();
      await DRIVER.delayMs(1000);
      // 麦克风授权
      let allowBtn3 = await DRIVER.findComponent(ON.text(tipAllow));
      await allowBtn3.click();
      await DRIVER.delayMs(1000);
      // 获取当前应用的ability
      let currentAbility = await abilityDelegatorRegistry.getCurrentTopAbility();
      // 获取相册管理模块的实例，用于访问和修改相册中的媒体文件
      media = photoAccessHelper.getPhotoAccessHelper(currentAbility.context);
      // 读取相册的视频资源
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates
      };
      let fetchResultBefore = await media.getAssets(fetchOptions)
      // 媒体资源的数量
      mediaDataCount = fetchResultBefore.getCount();
      console.log("媒体资源的数量:"+mediaDataCount)
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetPermission_001 end');
    })

    /**
     * 开始录制视频
     */
    it('StartRecord_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecord_001 begin');
      await DRIVER.assertComponentExist(ON.id('startRecord'));
      let startRecordBtn = await DRIVER.findComponent(ON.id('startRecord'));
      await startRecordBtn.click();
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartRecord_001 end');
    })

    /**
     * 停止录制视频
     */
    it('StopRecord_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopRecord_001 begin; mediaDataCount = ' + mediaDataCount);
      await DRIVER.delayMs(3000);
      await DRIVER.assertComponentExist(ON.id('stopRecord'));
      let stopRecordBtn = await DRIVER.findComponent(ON.id('stopRecord'));
      await stopRecordBtn.click();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopRecord_001 click');
      await DRIVER.delayMs(1000);
      // 再次获取媒体库中的视频数量
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates
      };
      let fetchResultAfter = await media.getAssets(fetchOptions)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopRecord_001 end; mediaDataCountAfter = ' + fetchResultAfter.getCount());
      // 断言比录制视频之前多一个
      expect(fetchResultAfter.getCount()).assertEqual(mediaDataCount + 1)
      hilog.info(DOMAIN, TAG, BUNDLE + 'StopRecord_001 end');
    })
  })
}