/*
 * Copyright (c) 2022 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import UIAbility from '@ohos.app.ability.UIAbility'

const TAG = '[Sample_Photos]'
const BUNDLE = 'photos_'
const TIME_OUT = 10000
const DOMAIN = 0xF811
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    // 删除测试过程中创建的文件
    afterAll(async function () {
    })
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.photos',
          abilityName: 'EntryAbility'
        })
        done()
      } catch (exception) {
        HiLog.info(DOMAIN, TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail()
      }

      function onAbilityCreateCallback() {
        HiLog.info(DOMAIN, TAG, "onAbilityCreateCallback")
      }

      var monitor = {
        abilityName: "EntryAbility",
        onAbilityCreate: onAbilityCreateCallback
      }
      await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT)
      HiLog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })
    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      // 获取文件读写权限
      HiLog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction requestPermission')
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.permit'))))
      let btnStart = await driver.findComponent(ON.text(await getResourceString($r('app.string.permit'))))
      await btnStart.click()
      HiLog.info(DOMAIN, TAG, BUNDLE + 'RequestPermissionFunction end')
    })
    /**
     * 检查主页相册
     */
    it('ImageFunction_001', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 打开应用能够显示相册列表
      await driver.assertComponentExist(ON.type('Grid'))
      await driver.assertComponentExist(ON.type('GridItem'))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.album_camera')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_camera'))))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.album_video')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_video'))))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.album_all')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_all'))))
      await driver.swipe(100, 1000, 100, 100)
      await driver.delayMs(3000)
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.album_screen_shot')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_screen_shot'))))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.album_favor')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_favor'))))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.album_recycle')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.album_recycle'))))
      await driver.swipe(100, 100, 100, 1000)
      await driver.delayMs(3000)
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_001 end')
    })
    /**
     * 检查相册内容
     */
    it('ImageFunction_002', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_002 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击相机相册
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_camera'))))
      await btnAlbum.click()
      await driver.delayMs(1000)
      let btnItem = await driver.findComponents(ON.type('GridItem'))
      if (btnItem == null || btnItem.length == 0) {
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.no_photo'))))
      } else {
        await driver.assertComponentExist(ON.type('GridItem'))
        // 点击图片
        await driver.click(100, 100);
        await driver.delayMs(1000)
        HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.btn_favor')))
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_favor'))))
        HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.btn_rename')))
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_rename'))))
        HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.btn_delete')))
        await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_delete'))))
      }
    })
    /**
     * 收藏
     */
    it('ImageFunction_003', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_003 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      //点击收藏
      let btnFavor = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_favor'))))
      await btnFavor.click()
      await driver.delayMs(1000)
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.btn_not_favor')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.btn_not_favor'))))
      //回到主页
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.swipe(100, 1000, 100, 100)
      await driver.delayMs(3000)
      //点击收藏夹
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_favor'))))
      await btnAlbum.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.type('GridItem'))
      let btnItem = await driver.findComponents(ON.type('GridItem'))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'btnItem.length:'+btnItem.length)
      expect(btnItem.length).assertLarger(0)
    })
    /**
     * 取消收藏
     */
    it('ImageFunction_004', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_004 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      //点击图片
      await driver.click(100, 100);
      await driver.delayMs(1000)
      let btnFavor = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_not_favor'))))
      await btnFavor.click()
      await driver.delayMs(1000)
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text'+await getResourceString($r('app.string.no_photo')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.no_photo'))))
      //返回
      await driver.pressBack()
    })
    /**
     * 新建相册
     */
    it('ImageFunction_005', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_005 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      //点击’+‘
      let btnAdd = await driver.findComponent(ON.id('28'))
      await btnAdd.click()
      await driver.delayMs(1000)
      //点击确认
      let btnConfirm = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_confirm'))))
      await btnConfirm.click()
      await driver.delayMs(1000)
      let toast = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_toast'))))
      if (toast != null) {
        return
      }
      // 选择所有照片
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_all'))))
      await btnAlbum.click()
      await driver.delayMs(1000)
      // 点击图片
      await driver.click(100, 100);
      await driver.delayMs(1000)
      //点击确认
      let btnOK = await driver.findComponent(ON.id('1'))
      await btnOK.click()
      await driver.delayMs(1000)
      // 检查新建相册
      await driver.swipe(100, 1000, 100, 100, 100)
      await driver.delayMs(3000)
      let btnNewAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_new'))))
      await btnNewAlbum.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.type('GridItem'))
      let btnItem = await driver.findComponents(ON.type('GridItem'))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'btnItem.length:'+btnItem.length)
      expect(btnItem.length).assertLarger(0)
      //返回
      await driver.pressBack()
    })
    /**
     * 删除相册
     */
    it('ImageFunction_006', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_006 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      await driver.swipe(100, 1000, 100, 100, 100)
      await driver.delayMs(3000)
      //长按
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_new'))))
      await btnAlbum.longClick()
      await driver.delayMs(1000)
      //点击删除
      let btnDelete = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_delete'))))
      await btnDelete.click()
      await driver.delayMs(1000)
      //点击确认
      let btnDeleteConfirm = await driver.findComponent(ON.id('deleteConfirm'))
      await btnDeleteConfirm.click()
      await driver.delayMs(1000)
      //检查是否删除
      let btnAlbumAfterDelete = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_new'))))
      if (btnAlbumAfterDelete != null) {
        expect().assertFail()
      }
    })
    /**
     * 删除
     */
    it('ImageFunction_007', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_007 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      await driver.swipe(100, 100, 100, 1000)
      await driver.delayMs(3000)
      // 点击所有照片
      let btnAllAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_all'))))
      await btnAllAlbum.click()
      await driver.delayMs(1000)
      await driver.click(100, 100);
      await driver.delayMs(1000)
      //点击删除
      let btnDelete = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_delete'))))
      await btnDelete.click()
      await driver.delayMs(1000)
      //点击确认
      let btnDeleteConfirm = await driver.findComponent(ON.id('deleteConfirm'))
      await btnDeleteConfirm.click()
      await driver.delayMs(1000)
      if (await driver.findComponent(ON.text(await getResourceString($r('app.string.no_photo')))) == null) {
        //还有其他照片
        await driver.pressBack()
        await driver.delayMs(1000)
      }
      //回到主页
      await driver.pressBack()
      await driver.delayMs(1000)
      await driver.swipe(100, 1000, 100, 100)
      await driver.delayMs(3000)
      //点击最近删除
      let btnAlbum = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_recycle'))))
      await btnAlbum.click()
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.type('GridItem'))
      let btnItem = await driver.findComponents(ON.type('GridItem'))
      HiLog.info(DOMAIN, TAG, BUNDLE + 'btnItem.length:'+btnItem.length)
      expect(btnItem.length).assertLarger(0)
    })
    /**
     * 恢复
     */
    it('ImageFunction_008', 0, async function () {
      HiLog.info(DOMAIN, TAG, BUNDLE + 'ImageFunction_008 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      //点击图片
      await driver.click(100, 100);
      await driver.delayMs(1000)
      let btnFavor = await driver.findComponent(ON.text(await getResourceString($r('app.string.btn_recover'))))
      await btnFavor.click()
      await driver.delayMs(1000)
      HiLog.info(DOMAIN, TAG, BUNDLE + 'check text:'+await getResourceString($r('app.string.no_photo')))
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.no_photo'))))
      //返回
      await driver.pressBack()
    })
  })
}