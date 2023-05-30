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
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import { getString } from '../util/ResourceUtil'

const TAG: string = '[Sample_Upload]'
const DOMAIN = 0xF811
const BUNDLE = 'Upload_'
const WAITING_TIME = 1000

export default function downloadAbilityTest() {

  describe('downloadAbilityTest', function () {
    //默认网络可用
    let isNetAvailable = true;
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.upload',
          abilityName: 'MainAbility'
        });
        done();
      } catch (expection) {
        expect(0).assertEqual(expection.code);
        hilog.info(DOMAIN, TAG, 'StartAbility end err:' + JSON.stringify(expection));
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(WAITING_TIME);
      // 获取访问权限
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 requestPermission');
      const str = await getString($r('app.string.allow'))
      await driver.assertComponentExist(ON.text(str));
      let btnAccept = await driver.findComponent(ON.text(str));
      await btnAccept.click();
      await driver.delayMs(WAITING_TIME);
      await btnAccept.click();
      await driver.delayMs(WAITING_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * 网络检查弹窗
     */
    it(BUNDLE + 'CheckNetworkAvailable_001', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckNetworkAvailable_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(WAITING_TIME);

      const tip0 = await getString($r('app.string.network_not_available'))
      let text = await driver.findComponent(ON.text(tip0));
      if (text != null) {
        isNetAvailable = false;
        hilog.info(DOMAIN, TAG, BUNDLE + 'CheckNetworkAvailable_001 network not available');
        const str = await getString($r('app.string.confirm'));
        let bt = ON.text(str);
        await driver.assertComponentExist(bt);
        let btnAccept = await driver.findComponent(bt);
        await btnAccept.click();
        await driver.delayMs(WAITING_TIME);
        hilog.info(DOMAIN, TAG, BUNDLE + 'CheckNetworkAvailable_001 network not available button confirm');
      }
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'CheckNetworkAvailable_001 end');
    });

    /**
     * 进入上传页面
     */
    it(BUNDLE + 'StartAbility_002', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002 begin');
      let driver = await Driver.create();
      let upload = ON.id("download").type("Row");
      await driver.assertComponentExist(upload);
      let uploadRow = await driver.findComponent(upload);
      await uploadRow.click();
      await driver.delayMs(WAITING_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002 end');
    })

    /**
     * 点击全部下载按钮
     */
    it(BUNDLE + 'StartDownload_001', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartDownload_001 begin');
      let driver = await Driver.create();
      let download = ON.id("finish").type("Button");
      await driver.assertComponentExist(download);
      let downloadButton = await driver.findComponent(download);
      await downloadButton.click();
      await driver.delayMs(WAITING_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartDownload_001 end');
    })

    /**
     * 等待全部下载完成提示
     */
    it(BUNDLE + 'DownloadFinish_001', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'DownloadFinish_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(WAITING_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'DownloadFinish_001 end');
    })
  })
}