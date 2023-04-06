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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, Component, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import UIAbility from '@ohos.app.ability.UIAbility'
import { Logger, FileManager } from '@ohos/feature-file-manager'
import mediaLibrary from '@ohos.multimedia.mediaLibrary'

const TAG = '[Sample_FileManager]'
const BUNDLE = 'fileManagerTest_'
const TYPE: [mediaLibrary.MediaType, string, mediaLibrary.DirectoryType][] = [
  [mediaLibrary.MediaType.IMAGE, '.jpg', mediaLibrary.DirectoryType.DIR_IMAGE],
  [mediaLibrary.MediaType.VIDEO, '.mp4', mediaLibrary.DirectoryType.DIR_VIDEO],
  [mediaLibrary.MediaType.FILE, '.txt', mediaLibrary.DirectoryType.DIR_DOCUMENTS],
  [mediaLibrary.MediaType.AUDIO, '.mp3', mediaLibrary.DirectoryType.DIR_AUDIO]
]
const MOCK: string = 'mock_'
const TEST_NUM = 5
const TIME_OUT = 10000
let ability: UIAbility = undefined

// 判断文件是否相同
async function fileAssertEqual(firstFile: mediaLibrary.FileAsset, secondFile: mediaLibrary.FileAsset): Promise<boolean> {
  Logger.info(TAG, 'firstFile displayName = ' + firstFile.displayName + ' and secondFile displayName = ' + secondFile.displayName)
  let displayName = await firstFile.displayName === secondFile.displayName
  Logger.info(TAG, 'firstFile dateAdded = ' + firstFile.dateAdded + ' and secondFile dateAdded = ' + secondFile.dateAdded)
  let dateAdded = await firstFile.dateAdded === secondFile.dateAdded
  Logger.info(TAG, 'firstFile albumName = ' + firstFile.albumName + ' and secondFile albumName = ' + secondFile.albumName)
  let albumName = await firstFile.albumName === secondFile.albumName
  return displayName && dateAdded && albumName
}

export default function unitTest() {
  describe('unitTest', function () {
    it(BUNDLE + 'StartAbility_002', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_002 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.filemanager',
          abilityName: 'MainAbility'
        })
        done()
      } catch (exception) {
        Logger.info(TAG, `StartAbility end ${JSON.stringify(exception)}`)
        expect(0).assertEqual(exception.code)
        done()
      }

      function onAbilityCreateCallback() {
        Logger.info(TAG, "onAbilityCreateCallback")
      }

      var monitor = {
        abilityName: "MainAbility",
        onAbilityCreate: onAbilityCreateCallback
      }
      ability = await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT)
      Logger.info(TAG, BUNDLE + 'StartAbility_002 end')
    })

    /** 场景：检验FileManager获取权限功能
     *  输入：调用requestPermission
     *  预期输出：点击允许后能够成功调用createFileAsset，getFileAssets
     *  检验接口：FileManager.requestPermission
     */
    it(BUNDLE + 'RequestPermissionFunction_002', 0, async function () {
      Logger.info(TAG, BUNDLE + 'Function_requestPermission_002 begin')
      let driver = await Driver.create()
      // 获取文件读写权限
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction_002 requestPermission')
      await driver.assertComponentExist(ON.text('允许'))
      let btnStart = await driver.findComponent(ON.text('允许'))
      await btnStart.click()
      await driver.delayMs(1000)
      let name = 'image' + Date.now().toString() + '.jpg'
      try {
        let curFile = await FileManager.createFileAsset(ability.context, mediaLibrary.MediaType.IMAGE, mediaLibrary.DirectoryType.DIR_IMAGE, name)
        if (curFile === undefined) {
          Logger.error(TAG, 'RequestPermissionFunction_002:createFileAsset failed')
          expect().assertFail()
        }
      } catch (error) {
        Logger.error(TAG, 'RequestPermissionFunction_002:createFileAsset failed')
        expect().assertFail()
      }
      try {
        let curResult = await FileManager.getFileAssets(ability.context, mediaLibrary.MediaType.IMAGE)
        if (curResult === undefined) {
          Logger.error(TAG, 'RequestPermissionFunction_002:etFileAssets failed')
          expect().assertFail()
        }
      } catch (error) {
        Logger.error(TAG, 'RequestPermissionFunction_002:getFileAssets failed')
        expect().assertFail()
      }
      Logger.info(TAG, BUNDLE + 'Function_requestPermission_002 end')
    })

    /**
     *  场景：检验FileManager获取文件列表信息，创建文件能力
     *  输入：分四种文件类型,依次插入5个文件
     *  预期输出：检测所得结果数量正确，新增文件与创建文件一致
     *  检验接口：FileManager.getFileAssets，FileManager.createFileAsset
     */
    it(BUNDLE + 'GetFileAssetsFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'GetFileAssetsFunction_001 begin')
      let files = await FileManager.getFileAssets(ability.context, mediaLibrary.MediaType.IMAGE)
      // 删除原有文件
      for (let i = 0; i < files.getCount(); i++) {
        let fileAsset: mediaLibrary.FileAsset = await files.getNextObject()
        if (fileAsset == undefined) {
          Logger.error(TAG, 'fileAsset undefined')
          continue
        }
        Logger.info(TAG, 'getFileAssetsByType success, fileAsset.displayName ' + i + ': ' + fileAsset.displayName +
        ' data:' + fileAsset.dateAdded, +', ' + fileAsset.dateModified)
        await FileManager.deleteFileAsset(ability.context, fileAsset)
      }
      for (let i = 0;i < TYPE.length; i++) {
        let originalResult = await FileManager.getFileAssets(ability.context, TYPE[i][0])
        let originalNum: number = await originalResult.getCount()
        let addNum: number = 0
        // 依次插入5个文件
        for (let j = 0; j < TEST_NUM; j++) {
          let name = 'newFile' + Date.now().toString() + TYPE[i][1]
          let curFile = undefined
          try {
            curFile = await FileManager.createFileAsset(ability.context, TYPE[i][0], TYPE[i][2], name)
          } catch (error) {
            Logger.error(TAG, 'GetFileAssetsFunction_001:createFileAsset failed')
          }
          await addNum++
          let result = await FileManager.getFileAssets(ability.context, TYPE[i][0])
          let num = await result.getCount()
          Logger.info(TAG, 'GetFileAssetsFunction_001:expect num is ' + (originalNum + addNum) + 'and result is ' + num)
          expect(num).assertEqual(originalNum + addNum)
          let lastObject = await result.getLastObject()
          let isEqual = await fileAssertEqual(lastObject, curFile)
          expect(isEqual).assertTrue()
        }
      }
      Logger.info(TAG, BUNDLE + 'GetFileAssetsFunction_001 end')
    })

    /**
     *  场景：验证文件是否支持预览函数功能
     *  输入：分别输入未定义对象,mock对象，正常对象
     *  预期输出：检测所得结果数量正确，新增文件与创建文件一致
     *  检验接口：FileManager.isSupportPreview
     */
    it(BUNDLE + 'IsSupportPreviewFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'IsSupportPreviewFunction_001 begin')
      let name: string = undefined
      expect(FileManager.isSupportPreview(name)).assertFalse()
      name = MOCK + Date.now() + '.txt'
      expect(FileManager.isSupportPreview(name)).assertFalse()
      name = 'image.jpg'
      expect(FileManager.isSupportPreview(name)).assertTrue()
      Logger.info(TAG, BUNDLE + 'IsSupportPreviewFunction_001 end')
    })

    /**
     *  场景：验证通过文件名称获取文件对象功能
     *  输入：通过name创建四种类型文件
     *  预期输出：getFileAssetsByName获取文件与创建相同
     *  检验接口：FileManager.getFileAssetsByName
     */
    it(BUNDLE + 'GetFileAssetsByNameFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'GetFileAssetsByNameFunction_001 begin')
      for (let i = 0;i < TYPE.length; i++) {
        let name = 'newFile' + Date.now().toString() + TYPE[i][1]
        let createFile = await FileManager.createFileAsset(ability.context, TYPE[i][0], TYPE[i][2], name)
        let getFile = await FileManager.getFileAssetsByName(ability.context, name)
        fileAssertEqual(createFile, getFile)
      }
      Logger.info(TAG, BUNDLE + 'GetFileAssetsByNameFunction_001 end')
    })

    /**
     *  场景：验证创建模拟文件功能
     *  输入：调用5次FileManager.createTxtFileAsset
     *  预期输出：成功创建五个模拟文档对象
     *  检验接口：FileManager.createTxtFileAsset
     */
    it(BUNDLE + 'CreateTxtFileAssetFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'CreateTxtFileAssetFunction_001 begin')
      let result = await FileManager.getFileAssets(ability.context, TYPE[2][0])
      let num = await result.getCount()
      for (let i = 0;i < TEST_NUM; i++) {
        await FileManager.createTxtFileAsset(ability.context)
        let newResult = await FileManager.getFileAssets(ability.context, TYPE[2][0])
        let newNum = newResult.getCount()
        Logger.info(TAG, 'CreateTxtFileAssetFunction_001:expect num is ' + (num + i + 1) + ' and result is ' + newNum)
        expect(newNum).assertEqual(num + i + 1)
      }
      Logger.info(TAG, BUNDLE + 'CreateTxtFileAssetFunction_001 end')
    })

  })
}