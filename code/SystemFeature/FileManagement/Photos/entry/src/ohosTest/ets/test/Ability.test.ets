/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import HiLog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { Driver, ON, MatchPattern } from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import UIAbility from '@ohos.app.ability.UIAbility';
import systemDateTime from '@ohos.systemDateTime';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const TAG = '[Sample_PhotosTest]';
const BUNDLE = 'photos_';
const TIME_OUT = 10000;
const DOMAIN = 0xF811;
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();

// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    // 删除测试过程中创建的文件
    afterAll(async () => {
    })
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.photos',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (exception) {
        HiLog.info(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }

      let onAbilityCreateCallback = () => {
        HiLog.info(DOMAIN, TAG, "onAbilityCreateCallback");
      }

      let monitor: abilityDelegatorRegistry.AbilityMonitor = {
        abilityName: "EntryAbility",
        onAbilityCreate: onAbilityCreateCallback
      }
      await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })
    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction begin');
      let driver = Driver.create();
      await driver.delayMs(2000);
      // 获取文件读写权限
      HiLog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction requestPermission');
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.permit'))));
      let btnStart = await driver.findComponent(ON.text(await getResourceString($r('app.string.permit'))));
      await btnStart.click();
      HiLog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction end');
    })
    /**
     * 检查主页相册
     */
    it('PhotosFunction_001', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(2000);
      await driver.pressBack();
      await driver.delayMs(2000);
      // 打开相机拍5张照
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.camera'))));
      let iconCamera = await driver.findComponent(ON.text(await getResourceString($r('app.string.camera'))));
      await iconCamera.click();
      await driver.delayMs(2000);
      for (let i = 0; i < 5; i++) {
        await driver.click(360, 1102);
        await driver.delayMs(2000);
      }
      await driver.pressBack();
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.Sample_photo_album'))));
      let iconPhoto = await driver.findComponent(ON.text(await getResourceString($r('app.string.Sample_photo_album'))));
      await iconPhoto.click();
      await driver.delayMs(2000);
      // 打开应用能够显示相册列表
      await driver.assertComponentExist(ON.type('Grid'));
      await driver.assertComponentExist(ON.type('GridItem'));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.album_camera')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_camera'))));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.album_video')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_video'))));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.album_all')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_all'))));
      await driver.swipe(100, 1000, 100, 200);
      await driver.delayMs(3000);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.album_screen_shot')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_screen_shot'))));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.album_moving_photo')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_moving_photo'))));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.album_favor')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_favor'))));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.album_recycle')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_recycle'))));
      await driver.swipe(100, 200, 100, 1000);
      await driver.delayMs(3000);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_001 end');
    })
    /**
     * 检查相册内容
     */
    it('PhotosFunction_002', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_002 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      // 点击相机相册
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_camera'))));
      await btnAlbum.click();
      await driver.delayMs(3000);
      let btnItem = await driver.findComponents(ON.type('GridItem'));
      if (btnItem == null || btnItem.length == 0 || btnItem == undefined) {
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.no_photo'))));
      } else {
        await driver.assertComponentExist(ON.type('GridItem'));
        // 点击图片
        await driver.click(100, 200);
        await driver.delayMs(1000);
        HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.btn_favor')));
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_favor'))));
        HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.btn_rename')));
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_rename'))));
        HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.btn_delete')));
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_delete'))));
      }
    })
    /**
     * 重命名文件
     */
    it('PhotosFunction_003', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_003 begin');
      let driver = await Driver.create();
      await driver.delayMs(2000);
      let time: number = await systemDateTime.getCurrentTime();
      let newName = time.toString();
      //点击重命名
      let btnRename = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_rename'))));
      await btnRename.click();
      await driver.delayMs(2000);
      let text = await driver.findComponent(ON.type('TextInput'));
      await text.inputText(newName);
      await driver.delayMs(2000);
      //点击确认
      let btnOK = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_confirm'))));
      await btnOK.click();
      await driver.delayMs(2000);
      //返回
      await driver.pressBack();
      await driver.delayMs(2000);
      //点击被重命名的图片
      await driver.assertComponentExist(ON.type('GridItem'));
      await driver.click(100, 200);
      await driver.delayMs(2000);
      //点击详情，检查名称
      let btnInfo = await driver.findComponent(ON.id('5'));
      await btnInfo.click();
      await driver.delayMs(2000);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text:' + newName);
      await driver.assertComponentExist(ON.text(newName));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_003 end');
    })
    /**
     * 收藏
     */
    it('PhotosFunction_004', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_004 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      //返回
      await driver.pressBack();
      await driver.delayMs(1000);
      //点击收藏
      let btnFavor = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_favor'))));
      await btnFavor.click();
      await driver.delayMs(1000);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.btn_not_favor')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_not_favor'))));
      //回到主页
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.swipe(100, 1000, 100, 200);
      await driver.delayMs(3000);
      //点击收藏夹
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_favor'))));
      await btnAlbum.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.type('GridItem'));
      let btnItem = await driver.findComponents(ON.type('GridItem'));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'btnItem.length:' + btnItem.length);
      expect(btnItem.length).assertLarger(0);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_004 end');
    })
    /**
     * 取消收藏
     */
    it('PhotosFunction_005', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_005 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      //点击图片
      await driver.click(100, 200);
      await driver.delayMs(1000);
      let btnFavor = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_not_favor'))));
      await btnFavor.click();
      await driver.delayMs(1000);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text' + await getResourceString($r('app.string.no_photo')));
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.no_photo'))));
      //返回
      await driver.pressBack();
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_005 end');
    })
    /**
     * 新建相册
     */
    it('PhotosFunction_006', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_006 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      //点击’+‘
      let btnAdd = await driver.findComponent(ON.id('28'));
      await btnAdd.click();
      await driver.delayMs(1000);
      let text = await driver.findComponent(ON.type('TextInput'));
      await text.inputText(await getResourceString($r('app.string.album_new')));
      await driver.delayMs(3000);
      //点击确认
      let btnConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_confirm'))));
      await btnConfirm.click();
      await driver.delayMs(1000);
      let toast = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_toast'))));
      if (toast != null) {
        return;
      }
      // 选择所有照片
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_all'))));
      await btnAlbum.click();
      await driver.delayMs(1000);
      // 点击图片
      await driver.click(100, 200);
      await driver.delayMs(1000);
      //点击确认
      let btnOK = await driver.findComponent(ON.id('1'));
      await btnOK.click();
      await driver.delayMs(1000);
      // 检查新建相册
      await driver.swipe(100, 1000, 100, 100, 100);
      await driver.delayMs(3000);
      let btnNewAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_new'))));
      await btnNewAlbum.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.type('GridItem'));
      let btnItem = await driver.findComponents(ON.type('GridItem'));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'btnItem.length:' + btnItem.length);
      expect(btnItem.length).assertLarger(0);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_006 end');
    })
    /**
     * 从用户相册移除图片
     */
    it('PhotosFunction_007', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_007 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponents(ON.type('GridItem'));
      await driver.longClick(100, 200);
      //点击更多
      let btnMore = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_more'))));
      await btnMore.click();
      await driver.delayMs(1000);
      //点击从相册移除
      let btnRemove = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_remove_form_album'))));
      await btnRemove.click();
      await driver.delayMs(1000);
      //确认从相册移除
      let btnRemoveConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_remove'))));
      await btnRemoveConfirm.click();
      await driver.delayMs(1000);
      let btnItemNew = await driver.findComponents(ON.type('GridItem'));
      //检查
      HiLog.info(DOMAIN, TAG, BUNDLE + 'Count:' + btnItem.length + ',new Count:' + btnItemNew.length);
      expect(btnItem.length).assertEqual(btnItemNew.length + 1);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_007 end');
    })
    /**
     * 从用户相册添加图片
     */
    it('PhotosFunction_008', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_008 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponents(ON.type('GridItem'));
      //点击’+‘
      let btnAdd = await driver.findComponent(ON.id('28'));
      await btnAdd.click();
      await driver.delayMs(1000);
      // 选择所有照片
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_all'))));
      await btnAlbum.click();
      await driver.delayMs(1000);
      // 点击图片
      await driver.click(100, 200);
      await driver.delayMs(1000);
      //点击确认
      let btnOK = await driver.findComponent(ON.id('1'));
      await btnOK.click();
      await driver.delayMs(1000);
      let btnItemNew = await driver.findComponents(ON.type('GridItem'));
      //检查
      HiLog.info(DOMAIN, TAG, BUNDLE + 'Count:' + btnItem.length + ',new Count:' + btnItemNew.length);
      expect(btnItem.length + 1).assertEqual(btnItemNew.length);
      //返回
      await driver.pressBack();
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_008 end');
    })
    /**
     * 删除相册
     */
    it('PhotosFunction_009', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_009 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 1000, 100, 100, 100);
      await driver.delayMs(3000);
      //长按
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_new'))));
      await btnAlbum.longClick();
      await driver.delayMs(1000);
      //点击删除
      let btnDelete = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_delete'))));
      await btnDelete.click();
      await driver.delayMs(1000);
      //点击确认
      let btnDeleteConfirm = await driver.findComponent(ON.id('deleteConfirm'));
      await btnDeleteConfirm.click();
      await driver.delayMs(1000);
      //检查是否删除
      let btnAlbumAfterDelete = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_new'))));
      if (btnAlbumAfterDelete != null) {
        expect().assertFail();
      }
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_009 end');
    })
    /**
     * 删除
     */
    it('PhotosFunction_010', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_010 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(100, 200, 100, 1000);
      await driver.delayMs(3000);
      // 点击所有照片
      let btnAllAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_all'))));
      await btnAllAlbum.click();
      await driver.delayMs(1000);
      await driver.click(100, 200);
      await driver.delayMs(1000);
      //点击删除
      let btnDelete = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_delete'))));
      await btnDelete.click();
      await driver.delayMs(1000);
      //点击确认
      let btnDeleteConfirm = await driver.findComponent(ON.id('deleteConfirm'));
      await btnDeleteConfirm.click();
      await driver.delayMs(1000);
      if (await driver.findComponent(ON.text(await getResourceString($r('app.string.no_photo')))) == null) {
        //还有其他照片
        await driver.pressBack();
        await driver.delayMs(1000);
      }
      //回到主页
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.swipe(100, 1000, 100, 200);
      await driver.delayMs(3000);
      //点击最近删除
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_recycle'))));
      await btnAlbum.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.type('GridItem'));
      let btnItem = await driver.findComponents(ON.type('GridItem'));
      HiLog.info(DOMAIN, TAG, BUNDLE + 'btnItem.length:' + btnItem.length);
      expect(btnItem.length).assertLarger(0);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_010 end');
    })
    /**
     * 恢复，最近删除相册里图片不能超过一屏
     */
    it('PhotosFunction_011', 0, async () => {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_011 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      let btnItem = await driver.findComponents(ON.type('GridItem'));
      //点击图片
      await driver.click(100, 200);
      await driver.delayMs(1000);
      let btnRecover = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_recover'))));
      await btnRecover.click();
      await driver.delayMs(1000);
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text:' + await getResourceString($r('app.string.no_photo')));
      if (await driver.findComponent(ON.text(await getResourceString($r('app.string.no_photo')))) == null) {
        //还有其他照片
        await driver.pressBack();
        await driver.delayMs(1000);
        let btnItemNew = await driver.findComponents(ON.type('GridItem'));
        HiLog.info(DOMAIN, TAG, BUNDLE + 'Count:' + btnItem.length + ',new Count:' + btnItemNew.length);
        expect(btnItem.length - 1).assertEqual(btnItemNew.length);
      }
      //返回
      await driver.pressBack();
      HiLog.info(DOMAIN, TAG, BUNDLE + 'PhotosFunction_011 end');
    })
  })
}
