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

import hilog from '@ohos.hilog';
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import UIAbility from '@ohos.app.ability.UIAbility'
import { Log } from '../../../main/ets/utils/Log';

const TAG = '[Sample_Photos]'
const BUNDLE = 'photos_'
const TIME_OUT = 10000
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
let ability: UIAbility = undefined
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
      Log.info(TAG, BUNDLE + 'StartAbility_001 begin')
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.photos',
          abilityName: 'EntryAbility'
        })
        done()
      } catch (exception) {
        Log.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail()
      }
      function onAbilityCreateCallback() {
        Log.info(TAG, "onAbilityCreateCallback")
      }
      var monitor = {
        abilityName: "EntryAbility",
        onAbilityCreate: onAbilityCreateCallback
      }
      ability = await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT)
      Log.info(TAG, BUNDLE + 'StartAbility_001 end')
    })
    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async function () {
      Log.info(TAG, BUNDLE + 'RequestPermissionFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      // 获取文件读写权限
      Log.info(TAG, BUNDLE + 'RequestPermissionFunction requestPermission')
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.permit'))))
      let btnStart1 = await driver.findComponent(ON.text(await getResourceString($r('app.string.permit'))))
      await btnStart1.click()
      let btnStart2 = await driver.findComponent(ON.text(await getResourceString($r('app.string.permit'))))
      await btnStart2.click()
      let btnStart3 = await driver.findComponent(ON.text(await getResourceString($r('app.string.permit'))))
      await btnStart3.click()
      Log.info(TAG, BUNDLE + 'RequestPermissionFunction end')
    })
    /**
     * 检查主页相册
     */
    it(BUNDLE + 'ImageFunction_001', 0, async function () {
      Log.info(TAG, BUNDLE + 'ImageFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 打开应用能够显示相册列表，点击相册
      await driver.assertComponentExist(ON.type('Grid'))
      await driver.assertComponentExist(ON.type('GridItem'))
      // 点击相机相册
      let btnStartCamera = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_camera'))))
      await btnStartCamera.click()
      await driver.delayMs(1000)
      // 查看图片 ，有或者没有
      let btnBack = await driver.findComponent(ON.id('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      // 点击视频相册
      let btnStartVideo = await driver.findComponent(ON.text(await getResourceString($r('app.string.album_video'))))
      await btnStartVideo.click()
      await driver.delayMs(1000)
      await btnBack.click()
      await driver.delayMs(1000)
      // 跳转图片
      /***
      let library = await mediaLibrary.getMediaLibrary(getContext())
      let fileKeyObj = await mediaLibrary.FileKey
      let imagesFetchOption = {
        selections: fileKeyObj.MEDIA_TYPE + '= ?',
        selectionArgs: [mediaLibrary.MediaType.IMAGE.toString()],
      }
      let fetchFileResult: mediaLibrary.FetchFileResult = undefined
      try {
        fetchFileResult = await library.getFileAssets(imagesFetchOption)
      } catch (error) {
        expect().assertFail()
      }
      // 图片数量为0，则显示没有相关文件
      if (fetchFileResult.getCount() === 0) {
        await driver.assertComponentExist(ON.id('no_file'))
        await driver.delayMs(1000)
      } else {
        // 否则显示图片文件
        await driver.assertComponentExist(ON.type('ListItem'))
        let btnItem = await driver.findComponents(ON.type('ListItem'))
        Log.info(TAG, 'image item length = ' + btnItem.length + ' and image file count =' + fetchFileResult.getCount())
        if (fetchFileResult.getCount() < MAX_NUM) {
          expect(btnItem.length).assertEqual(fetchFileResult.getCount())
        } else {
          expect(btnItem.length).assertEqual(MAX_NUM)
        }
        // 点击图片项跳转图片详情页，图片页包含返回按钮、图片和标题,点击返回
        await btnItem[0].click()
        await driver.assertComponentExist(ON.type('Text'))
        await driver.assertComponentExist(ON.type('Image'))
        let btnImage = await driver.findComponent(ON.id('imageBack'))
        await btnImage.click()
        await driver.delayMs(1000)
        // 长按显示删除按钮
        await btnItem[0].longClick()
        await driver.assertComponentExist(ON.id('fileListDelete'))
        let btnDel = await driver.findComponents(ON.id('fileListDelete'))
        await driver.delayMs(1000)
        // 点击删除按钮后能正常显示
        await btnDel[0].click()
        await driver.delayMs(1000)
        await checkPage(library, driver, mediaLibrary.MediaType.IMAGE)
      }
      // 返回主页
      await driver.assertComponentExist(ON.type('Image'))
      let btnBack = await driver.findComponent(ON.id('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      Log.info(TAG, BUNDLE + 'ImageFunction_001 end')
       */
    })

  })
}