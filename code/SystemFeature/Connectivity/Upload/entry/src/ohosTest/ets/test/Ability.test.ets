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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import hilog from '@ohos.hilog';
import UIAbility from '@ohos.app.ability.UIAbility';

const TAG: string = '[Sample_Upload]'
const DOMAIN = 0xF811
const BUNDLE = 'Upload_'
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let resMgr = abilityDelegator.getAppContext().resourceManager;
  let text = await resMgr.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
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
      // ability = await abilityDelegator.getCurrentTopAbility();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 获取访问权限
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 requestPermission');
      await driver.assertComponentExist(ON.text('允许'));
      let btnAccept = await driver.findComponent(ON.text('允许'));
      await btnAccept.click();
      await btnAccept.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction_001 end');
    })

    /**
     * 添加功能
     */
    it(BUNDLE + 'AddFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 点击添加
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 addToPhoto');
      await driver.assertComponentExist(ON.id('add'));
      let addBtn = await driver.findComponent(ON.id('add'));
      await addBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('take_photo'));
      // 点击拍照进入拍照页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 enterTakePhoto');
      await driver.assertComponentExist(ON.id('take_photo'));
      let takePhoto = await driver.findComponent(ON.id('take_photo'));
      await takePhoto.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('photo'));
      // 点击进行拍照
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 takePhoto');
      await driver.assertComponentExist(ON.id('click'));
      let clickBtn = await driver.findComponent(ON.id('click'));
      await clickBtn.click();
      await driver.delayMs(1000);
      let imageList = await driver.findComponents(ON.id('imageShow'));
      if (imageList.length > 0) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 takePhotoSuccess');
        await driver.assertComponentExist(ON.id('imageShow'));
        await driver.delayMs(1000);
      } else {
        hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 takePhotoFail');
        expect().assertFail();
      }
      // 点击添加
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 addToAlbum');
      await addBtn.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('take_photo'));
      // 点击从相册选择
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 clickFromAlbum');
      await driver.assertComponentExist(ON.id('pick_album'));
      let pickFromAlbum = await driver.findComponent(ON.id('pick_album'));
      await pickFromAlbum.click();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.text('所有照片'));
      // 选择图片,坐标选择
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 pick');
      await driver.click(335, 235);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('1/50'));
      // 点击完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 finish');
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.complete'))));
      let finish = await driver.findComponent(ON.text(await getResourceString($r('app.string.complete'))));
      await finish.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('publish'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 end');
    })

    /**
     * 上传功能
     */
    it(BUNDLE + 'PublishFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 检查图片
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 checkPicture');
      let imageList = await driver.findComponents(ON.id('imageShow'));
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 imageList.length=' + imageList.length);
      if (imageList.length === 2) {
        hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 checkPictureSuccess');
        try {
          // 点击发表
          hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 clickPublish');
          await driver.assertComponentExist(ON.id('publish'));
          let publishBtn = await driver.findComponent(ON.id('publish'));
          await publishBtn.click();
          await driver.delayMs(5000);
          await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.publish_success'))));
          // 点击确认
          hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 clickConfirm');
          await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm'))));
          let confirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm'))));
          await confirm.click();
          await driver.delayMs(1000);
          // 检查上传是否成功
          if (confirm.click()) {
            hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 publishPhotoSuccess');
            await driver.assertComponentExist(ON.id('publish'));
          } else {
            hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 publishPhotoFail');
            expect().assertFail();
          }
        } catch (err) {
          hilog.info(DOMAIN, TAG, 'PublishFunction_001 fail err:' + JSON.stringify(err));
        }
      } else {
        hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 checkPictureFail');
        expect().assertFail();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'PublishFunction_001 end');
    })
  })
}