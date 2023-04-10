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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import { Logger, FileManager, ThumbnailImage } from '@ohos/feature-file-manager'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'


const TAG = '[Sample_FileManager]'
const BUNDLE = 'fileManager_'
// 屏幕上最多显示11条记录
const MAX_NUM = 11

// 检查页面是否正常显示
async function checkPage(library: mediaLibrary.MediaLibrary, driver: Driver, type: mediaLibrary.MediaType) {
  Logger.info(TAG, 'checkPage begin ')
  let fileKeyObj = await mediaLibrary.FileKey
  let fileFetchOption = {
    selections: fileKeyObj.MEDIA_TYPE + '= ?',
    selectionArgs: [type.toString()],
  }
  let fetchFileResult: mediaLibrary.FetchFileResult = undefined
  try {
    fetchFileResult = await library.getFileAssets(fileFetchOption)
  } catch (error) {
    expect().assertFail()
  }
  if (fetchFileResult.getCount() === 0) {
    await driver.assertComponentExist(ON.id('no_file'))
    await driver.delayMs(1000)
  } else {
    await driver.assertComponentExist(ON.type('ListItem'))
    let btnItem = await driver.findComponents(ON.type('ListItem'))
    Logger.info(TAG, 'item length = ' + btnItem.length + ' and file count =' + fetchFileResult.getCount())
    if (fetchFileResult.getCount() <= MAX_NUM) {
      await expect(btnItem.length).assertEqual(fetchFileResult.getCount())
    } else {
      await expect(btnItem.length).assertEqual(MAX_NUM)
    }
  }
  Logger.info(TAG, 'checkPage end ')
}

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.filemanager',
          abilityName: 'MainAbility'
        })
        done()
      } catch (exception) {
        Logger.info(TAG, `StartAbility_001 exception = ${JSON.stringify(exception)}`)
        expect().assertFail()
      }
      Logger.info(TAG, BUNDLE + 'StartAbility_001 end')
    })

    /**
     * 获取权限
     */
    it(BUNDLE + 'RequestPermissionFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      // 获取文件读写权限
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction requestPermission')
      await driver.assertComponentExist(ON.text('允许'))
      let btnStart = await driver.findComponent(ON.text('允许'))
      await btnStart.click()
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction end')
    })

    /**
     * 点击主页中图片
     */
    it(BUNDLE + 'ImageFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'ImageFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 打开应用能够显示List中内容，点击图片
      await driver.assertComponentExist(ON.type('List'))
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem0'))
      let btnStart = await driver.findComponent(ON.type('ListItem').id('ListItem0'))
      await btnStart.click()
      await driver.delayMs(1000)
      // 跳转图片
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
        Logger.info(TAG, 'image item length = ' + btnItem.length + ' and image file count =' + fetchFileResult.getCount())
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
      Logger.info(TAG, BUNDLE + 'ImageFunction_001 end')
    })

    /**
     * 点击主页中视频
     */
    it(BUNDLE + 'VideoFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'VideoFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 打开应用能够显示List中内容，点击图片
      await driver.assertComponentExist(ON.type('List'))
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem1'))
      let btnStart = await driver.findComponent(ON.type('ListItem').id('ListItem1'))
      await btnStart.click()
      await driver.delayMs(1000)
      // 跳转视频文件管理页
      let library = await mediaLibrary.getMediaLibrary(getContext())
      let fileKeyObj = await mediaLibrary.FileKey
      let videoFetchOption = {
        selections: fileKeyObj.MEDIA_TYPE + '= ?',
        selectionArgs: [mediaLibrary.MediaType.VIDEO.toString()],
      }
      let fetchFileResult: mediaLibrary.FetchFileResult = undefined
      try {
        fetchFileResult = await library.getFileAssets(videoFetchOption)
      } catch (error) {
        expect().assertFail()
      }
      // 视频数量为0，则显示没有相关文件
      if (fetchFileResult.getCount() === 0) {
        await driver.assertComponentExist(ON.id('no_file'))
        await driver.delayMs(1000)
      } else {
        // 否则显示全部视频文件
        await driver.assertComponentExist(ON.type('ListItem'))
        let btnItem = await driver.findComponents(ON.type('ListItem'))
        Logger.info(TAG, 'video item length = ' + btnItem.length + ' and video file count =' + fetchFileResult.getCount())
        if (fetchFileResult.getCount() < MAX_NUM) {
          expect(btnItem.length).assertEqual(fetchFileResult.getCount())
        } else {
          expect(btnItem.length).assertEqual(MAX_NUM)
        }
        // 点击视频项（开发中）
        await btnItem[0].click()
        await driver.delayMs(1000)
        // 长按显示删除按钮
        await btnItem[0].longClick()
        await driver.assertComponentExist(ON.id('fileListDelete'))
        let btnDel = await driver.findComponents(ON.id('fileListDelete'))
        // 点击删除按钮后能正常显示
        await btnDel[0].click()
        await driver.delayMs(1000)
        await checkPage(library, driver, mediaLibrary.MediaType.VIDEO)
        await driver.delayMs(1000)
      }
      // 返回主页
      await driver.assertComponentExist(ON.type('Image'))
      let btnBack = await driver.findComponent(ON.id('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'VideoFunction_001 end')
    })

    /**
     * 点击主页中文档
     */
    it(BUNDLE + 'DocumentFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'DocumentFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 打开应用能够显示List中内容，点击文档
      await driver.assertComponentExist(ON.type('List'))
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem2'))
      let btnStart = await driver.findComponent(ON.type('ListItem').id('ListItem2'))
      await btnStart.click()
      await driver.delayMs(1000)
      // 跳转文档文件管理页
      let library = await mediaLibrary.getMediaLibrary(getContext())
      let fileKeyObj = await mediaLibrary.FileKey
      let fileFetchOption = {
        selections: fileKeyObj.MEDIA_TYPE + '= ?',
        selectionArgs: [mediaLibrary.MediaType.FILE.toString()],
      }
      let fetchFileResult: mediaLibrary.FetchFileResult = undefined
      try {
        fetchFileResult = await library.getFileAssets(fileFetchOption)
      } catch (error) {
        expect().assertFail()
      }
      // 文档数量为0，则显示没有相关文件
      if (fetchFileResult.getCount() === 0) {
        await driver.assertComponentExist(ON.id('no_file'))
        await driver.delayMs(1000)
      } else {
        // 否则显示全部文档文件
        await driver.assertComponentExist(ON.type('ListItem'))
        let btnItem = await driver.findComponents(ON.type('ListItem'))
        Logger.info(TAG, 'document item length = ' + btnItem.length + ' and document file count =' + fetchFileResult.getCount())
        if (fetchFileResult.getCount() < MAX_NUM) {
          expect(btnItem.length).assertEqual(fetchFileResult.getCount())
        } else {
          expect(btnItem.length).assertEqual(MAX_NUM)
        }
        // 点击文档项（开发中）
        await btnItem[0].click()
        await driver.delayMs(1000)
        // 长按显示删除按钮
        await btnItem[0].longClick()
        await driver.assertComponentExist(ON.id('fileListDelete'))
        let btnDel = await driver.findComponents(ON.id('fileListDelete'))
        // 点击删除按钮后能正常显示
        await btnDel[0].click()
        await driver.delayMs(1000)
        await checkPage(library, driver, mediaLibrary.MediaType.FILE)
        await driver.delayMs(1000)
      }
      // 存在添加按钮,点击后能够正常显示
      await driver.assertComponentExist(ON.id('fileAdd'))
      let btnAdd = await driver.findComponent(ON.id('fileAdd'))
      await btnAdd.click()
      await driver.delayMs(1000)
      await checkPage(library, driver, mediaLibrary.MediaType.FILE)
      await driver.delayMs(1000)
      // 返回主页
      await driver.assertComponentExist(ON.type('Image'))
      let btnBack = await driver.findComponent(ON.id('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'DocumentFunction_001 end')
    })

    /**
     * 点击主页中音频
     */
    it(BUNDLE + 'AudioFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'AudioFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 主页能够显示List中内容，点击文档
      await driver.assertComponentExist(ON.type('List'))
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem3'))
      let btnStart = await driver.findComponent(ON.type('ListItem').id('ListItem3'))
      await btnStart.click()
      await driver.delayMs(1000)
      // 跳转音频文件管理页
      let library = await mediaLibrary.getMediaLibrary(getContext())
      let fileKeyObj = await mediaLibrary.FileKey
      let audioFetchOption = {
        selections: fileKeyObj.MEDIA_TYPE + '= ?',
        selectionArgs: [mediaLibrary.MediaType.AUDIO.toString()],
      }
      let fetchFileResult: mediaLibrary.FetchFileResult = undefined
      try {
        fetchFileResult = await library.getFileAssets(audioFetchOption)
      } catch (error) {
        expect().assertFail()
      }
      // 音频数量为0，则显示没有相关文件
      if (fetchFileResult.getCount() === 0) {
        await driver.assertComponentExist(ON.id('no_file'))
        await driver.delayMs(1000)
      } else {
        // 否则显示全部音频文件
        await driver.assertComponentExist(ON.type('ListItem'))
        let btnItem = await driver.findComponents(ON.type('ListItem'))
        Logger.info(TAG, 'audio item length = ' + btnItem.length + ' and audio file count =' + fetchFileResult.getCount())
        if (fetchFileResult.getCount() < MAX_NUM) {
          expect(btnItem.length).assertEqual(fetchFileResult.getCount())
        } else {
          expect(btnItem.length).assertEqual(MAX_NUM)
        }
        // 点击音频项（开发中）
        await btnItem[0].click()
        await driver.delayMs(1000)
        // 长按显示删除按钮
        await btnItem[0].longClick()
        await driver.assertComponentExist(ON.id('fileListDelete'))
        let btnDel = await driver.findComponents(ON.id('fileListDelete'))
        await driver.delayMs(1000)
        // 点击删除按钮后能正常显示
        await btnDel[0].click()
        await driver.delayMs(1000)
        await checkPage(library, driver, mediaLibrary.MediaType.AUDIO)
        await driver.delayMs(1000)
      }
      // 返回主页
      await driver.assertComponentExist(ON.type('Image'))
      let btnBack = await driver.findComponent(ON.id('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'AudioFunction_001 end')
    })

    /**
     * 点击主页中压缩包
     */
    it(BUNDLE + 'ZipFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'ZipFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 主页能够显示List中内容，点击压缩包
      await driver.assertComponentExist(ON.type('List'))
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem4'))
      let btnStart = await driver.findComponent(ON.type('ListItem').id('ListItem4'))
      await btnStart.click()
      await driver.delayMs(1000)
      // 暂不支持，功能开发中
      Logger.info(TAG, BUNDLE + 'ZipFunction_001 end')
    })

    /**
     * 点击主页中我的手机
     */
    it(BUNDLE + 'MobileFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'MobileFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(500)
      // 主页能够显示List中内容，点击手机
      await driver.assertComponentExist(ON.type('List'))
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem5'))
      let btnStart = await driver.findComponent(ON.type('ListItem').id('ListItem5'))
      await btnStart.click()
      await driver.delayMs(500)
      // 跳转我的手机界面
      await driver.assertComponentExist(ON.type('Text').id('makeFile'))
      await driver.assertComponentExist(ON.type('Text').id('makeDirectory'))
      await driver.assertComponentExist(ON.type('Text').id('sort'))
      await driver.assertComponentExist(ON.type('Text').id('clean'))
      // 测试新建文件功能
      let btnFile = await driver.findComponent(ON.type('Text').id('makeFile'))
      await btnFile.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('cancel'))
      let btnCancel = await driver.findComponent(ON.id('cancel'))
      await btnCancel.click()
      await driver.delayMs(500)
      await btnFile.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('input'))
      let input = await driver.findComponent(ON.id('input'))
      await input.inputText('testFile')
      await driver.assertComponentExist(ON.id('promise'))
      let btnPromise = await driver.findComponent(ON.id('promise'))
      await btnPromise.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.text('testFile'))
      let testFile = await driver.findComponent(ON.text('testFile'))
      // 测试新建文件夹功能
      let btnDirectory = await driver.findComponent(ON.type('Text').id('makeDirectory'))
      await btnDirectory.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('cancel'))
      let directoryCancel = await driver.findComponent(ON.id('cancel'))
      await directoryCancel.click()
      await driver.delayMs(500)
      await btnDirectory.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('input'))
      let inputDirectory = await driver.findComponent(ON.id('input'))
      await inputDirectory.inputText('testDirectory')
      await driver.assertComponentExist(ON.id('promise'))
      let directoryPromise = await driver.findComponent(ON.id('promise'))
      await directoryPromise.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.text('testDirectory'))
      let testDirectory = await driver.findComponent(ON.text('testDirectory'))
      // 点击select图片
      await driver.assertComponentExist(ON.id('select'))
      let selectImage = await driver.findComponent(ON.id('select'))
      await selectImage.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.type('Text').id('copy'))
      let btnCopy = await driver.findComponent(ON.type('Text').id('copy'))
      await driver.assertComponentExist(ON.type('Text').id('rename'))
      let btnRename = await driver.findComponent(ON.type('Text').id('rename'))
      await driver.assertComponentExist(ON.type('Text').id('share'))
      await driver.assertComponentExist(ON.type('Text').id('delete'))
      let btnDelete = await driver.findComponent(ON.type('Text').id('delete'))
      // 测试复制
      await testFile.click()
      await btnCopy.click()
      await testDirectory.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('move'))
      let btnMove = await driver.findComponent(ON.id('move'))
      await btnMove.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.text('testFile'))
      let copyFile = await driver.findComponent(ON.text('testFile'))
      // 测试删除
      await driver.assertComponentExist(ON.id('secondarySelect'))
      let btnSecondarySelect = await driver.findComponent(ON.id('secondarySelect'))
      await btnSecondarySelect.click()
      await driver.delayMs(500)
      await copyFile.click()
      await driver.assertComponentExist(ON.type('Text').id('delete'))
      let newDelete = await driver.findComponent(ON.type('Text').id('delete'))
      await newDelete.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('checkDelete'))
      let btnCheckDelete = await driver.findComponent(ON.id('checkDelete'))
      await btnCheckDelete.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.id('blank'))
      // 测试重命名
      await driver.assertComponentExist(ON.id('left'))
      let btnLeft = await driver.findComponent(ON.id('left'))
      await btnLeft.click()
      await driver.delayMs(500)
      let btnSelect = await driver.findComponent(ON.id('select'))
      await btnSelect.click()
      await testFile.click()
      let btnRenameNew = await driver.findComponent(ON.type('Text').id('rename'))
      await btnRenameNew.click()
      await driver.delayMs(500)
      let inputDirectoryNew = await driver.findComponent(ON.id('input'))
      await inputDirectoryNew.inputText('testFileNew')
      let btnPromiseNew = await driver.findComponent(ON.id('promise'))
      await btnPromiseNew.click()
      await driver.delayMs(500)
      await driver.assertComponentExist(ON.text('testFileNew'))
      Logger.info(TAG, BUNDLE + 'MobileFunction_001 end')
    })
  })
}