/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
const LONG_WAITING_TIME = 3000

export default function uploadAbilityTest() {
  describe('uploadAbilityTest', function () {
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

      //获取manager
      const tipAllow = await getString($r('app.string.allow'))
      await driver.assertComponentExist(ON.text(tipAllow));
      let btnAccept = await driver.findComponent(ON.text(tipAllow));
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

      const tipNetwork = await getString($r('app.string.network_not_available'))
      let text = await driver.findComponent(ON.text(tipNetwork));
      if (text != null) {
        isNetAvailable = false;
        hilog.info(DOMAIN, TAG, BUNDLE + 'CheckNetworkAvailable_001 network not available');

        const tipConfirm = await getString($r('app.string.confirm'))
        let bt = ON.text(tipConfirm);
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
      let upload = ON.id("upload").type("Row");
      await driver.assertComponentExist(upload);
      let uploadRow = await driver.findComponent(upload);
      await uploadRow.click();
      await driver.delayMs(WAITING_TIME);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_002 end');
    })

    /**
     * 添加功能，从拍照添加
     */
    it(BUNDLE + 'AddFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 begin');
      let driver = await Driver.create();
      // 点击添加
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 addToPhoto');
      await driver.assertComponentExist(ON.id('add'));
      let addBtn = await driver.findComponent(ON.id('add'));
      await addBtn.click();
      await driver.delayMs(WAITING_TIME);
      // 点击拍照进入拍照页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 enterTakePhoto');
      await driver.assertComponentExist(ON.id('take_photo'));
      let takePhoto = await driver.findComponent(ON.id('take_photo'));
      await takePhoto.click();
      await driver.delayMs(WAITING_TIME);

      let button = await driver.findComponent(ON.type('Image'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 click take phone');
      await button.click();
      await driver.delayMs(WAITING_TIME);

      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 find imageShow');
      let imageList = await driver.findComponents(ON.id('imageShow'));
      if (imageList != null && imageList.length > 0) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 takePhotoSuccess');
        await driver.assertComponentExist(ON.id('imageShow'));
        await driver.delayMs(WAITING_TIME);
      } else {
        hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 takePhotoFail');
        hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 maybe the device does not have a camera.');
        //        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 end');
    })

    /**
     * 从相册添加
     */
    it(BUNDLE + 'AddFunction_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_002 begin');
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_002 addToAlbum');
      let driver = await Driver.create();
      await driver.assertComponentExist(ON.id('add'));
      let addBtn = await driver.findComponent(ON.id('add'));
      // 点击添加
      await addBtn.click();
      await driver.delayMs(WAITING_TIME);
      await driver.assertComponentExist(ON.id('take_photo'));

      // 点击从相册选择
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_002 clickFromAlbum');
      await driver.assertComponentExist(ON.id('pick_album'));
      let pickFromAlbum = await driver.findComponent(ON.id('pick_album'));
      await pickFromAlbum.click();
      await driver.delayMs(LONG_WAITING_TIME);

      const tipAll = await getString($r('app.string.all_photo'))
      await driver.assertComponentExist(ON.text(tipAll));
      // 选择图片,坐标选择
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_002 pick');

      let clickable = await driver.findComponents(ON.clickable(true).type("Column"))
      if (clickable != null && clickable.length > 2) {
        //第一个Column是拍照，后续的都是照片,请确保相册内有两张或以上的照片
        let component = clickable[1];
        await component.click();
        hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_002 pick first pic');

        let component2 = clickable[2];
        await component2.click();
        hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_002 pick second pic');
      }
      await driver.delayMs(WAITING_TIME);
      const tipProgress = await getString($r('app.string.progress_tip'))
      await driver.assertComponentExist(ON.text(tipProgress));
      // 点击完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 finish');

      const tipCompleted = await getString($r('app.string.complete'))
      await driver.assertComponentExist(ON.text(tipCompleted));
      let finish = await driver.findComponent(ON.text(tipCompleted));
      await finish.click();
      await driver.delayMs(WAITING_TIME);
      await driver.assertComponentExist(ON.id('finish'));

      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_002 end');
    })

    /**
     * 上传功能
     */
    it(BUNDLE + 'PublishFunction_001', 0, async (done) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(WAITING_TIME);
      // 检查图片
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 checkPicture');
      let imageList = await driver.findComponents(ON.id('imageShow'));
      await driver.delayMs(WAITING_TIME);
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 imageList.length=' + imageList.length);
      //只在网络可用的情况下测试发表
      if (isNetAvailable) {
        // 也许设备没有相机，只有2张图片
        if (imageList.length >= 2) {
          hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 checkPictureSuccess');
          try {
            // 点击发表
            hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 clickPublish');

            const tipPublish = await getString($r('app.string.publish'))

            await driver.assertComponentExist(ON.text(tipPublish));
            let publishBtn = await driver.findComponent(ON.text(tipPublish));
            await publishBtn.click();

            const tipSuccess = await getString($r('app.string.publish_success'))
            await driver.waitForComponent(ON.text(tipSuccess), 30000)
            // 检查上传是否成功
            hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 clickConfirm');

            const tipConfirm = await getString($r('app.string.confirm'))
            await driver.assertComponentExist(ON.text(tipConfirm));
            let confirm = await driver.findComponent(ON.text(tipConfirm));
            await confirm.click();
          } catch (err) {
            hilog.info(DOMAIN, TAG, 'PublishFunction_001 fail err:' + JSON.stringify(err));
          }
        } else {
          hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 checkPictureFail');
          expect().assertFail();
        }
      }
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 end');
    })
  })
}