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
import UIAbility from '@ohos.app.ability.UIAbility'


const TAG = '[Sample_FileManager]'
const BUNDLE = 'fileManager_'
// 屏幕上最多显示11条记录
const MAX_NUM = 11

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
let file: mediaLibrary.FileAsset[] = [];

// 判断文件是否相同
async function fileAssertEqual(firstFile: mediaLibrary.FileAsset, secondFile: mediaLibrary.FileAsset): Promise<boolean> {
  Logger.info(TAG, 'firstFile uri = ' + firstFile.uri + ' and secondFile uri = ' + secondFile.uri);
  let uri = await firstFile.uri === secondFile.uri;
  return uri;
}
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

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  // 删除测试过程中创建的文件
  afterAll(async function () {
    for (let i = 0; i < file.length; i++) {
      await FileManager.deleteFileAsset(file[i]);
    }
  })

  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      Logger.info(TAG, BUNDLE + 'StartAbility_001 begin')
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
      function onAbilityCreateCallback() {
        Logger.info(TAG, "onAbilityCreateCallback")
      }
      var monitor = {
        abilityName: "MainAbility",
        onAbilityCreate: onAbilityCreateCallback
      }
      ability = await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT)
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
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.permit'))))
      let btnStart = await driver.findComponent(ON.text(await getResourceString($r('app.string.permit'))))
      await btnStart.click()
      Logger.info(TAG, BUNDLE + 'RequestPermissionFunction end')
    })

    /**
     * 点击主页中监听文件
     */
    it(BUNDLE + 'WatcherCopyFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'WatcherCopyFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 打开应用能够显示List中内容，点击图片
      await driver.assertComponentExist(ON.type('List'))
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem6'))
      let btnStart = await driver.findComponent(ON.type('ListItem').id('ListItem6'))
      await btnStart.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'WatcherCopyFunction_001 end')
    })

    /**
     * 添加监听之前添加文件
     */
    it('File_Fs_addFile_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_addFile_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('addFile'));
      let addFile = await driver.findComponent(ON.id('addFile'));
      await addFile.click();
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.assertComponentExist(ON.text('event: unknown'));
      await driver.assertComponentExist(ON.text('fileName: unknown'));
      await driver.assertComponentExist(ON.text('cookie: unknown'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_addFile_001 end');
    })

    /**
     * 添加监听之前修改文件
     */
    it('File_Fs_modifyFile_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_modifyFile_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.swipe(600, 837, 300, 837, 600);
      await driver.assertComponentExist(ON.id('editFile'));
      let editFile = await driver.findComponent(ON.id('editFile'));
      await editFile.click();
      await driver.assertComponentExist(ON.text('TestFile10'));
      await driver.assertComponentExist(ON.text('size: 12B'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_modifyFile_001 end');
    })

    /**
     * 修改文件名
     */
    it('File_Fs_modifyFileName_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_modifyFileName_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileName'));
      let fileName = await driver.findComponent(ON.id('fileName'));
      await fileName.clearText();
      await fileName.inputText('newFileName');
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backWatcherFile'));
      let back = await driver.findComponent(ON.id('backWatcherFile'));
      await back.click();
      Logger.info(TAG, 'File_Fs_modifyFileName_001 end');
    })

    /**
     * 查看已修改文件名
     */
    it('File_Fs_modifyFile_002', 1, async function () {
      Logger.info(TAG, 'File_Fs_modifyFile_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('event: unknown'));
      await driver.assertComponentExist(ON.text('fileName: unknown'));
      await driver.assertComponentExist(ON.text('cookie: unknown'));
      await driver.delayMs(1000);
      await driver.swipe(600, 837, 300, 837, 600);
      await driver.assertComponentExist(ON.id('editFile'));
      let editFile = await driver.findComponent(ON.id('editFile'));
      await editFile.click();
      await driver.assertComponentExist(ON.text('newFileName'));
      await driver.assertComponentExist(ON.text('size: 12B'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_modifyFile_002 end');
    })

    /**
     * 修改文件内容
     */
    it('File_Fs_modifyFileContent_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_modifyFileContent_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileContent'));
      let fileContent = await driver.findComponent(ON.id('fileContent'));
      await fileContent.clearText();
      await fileContent.inputText('newFileContent');
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.assertComponentExist(ON.id('backWatcherFile'));
      let back = await driver.findComponent(ON.id('backWatcherFile'));
      await back.click();
      Logger.info(TAG, 'File_Fs_modifyFileContent_001 end');
    })

    /**
     * 添加监听之前删除文件
     */
    it('File_Fs_deleteFile_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_deleteFile_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('event: unknown'));
      await driver.assertComponentExist(ON.text('fileName: unknown'));
      await driver.assertComponentExist(ON.text('cookie: unknown'));
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('deleteFile'));
      let deleteFile = await driver.findComponent(ON.id('deleteFile'));
      await deleteFile.click();
      await driver.assertComponentExist(ON.id('deleteWatcher'));
      let deleteWatcher = await driver.findComponent(ON.id('deleteWatcher'));
      await deleteWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_deleteFile_001 end');
    })

    /**
     * 准备待修改的文件
     */
    it('backward_001', 1, async function () {
      Logger.info(TAG, 'backward_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('event: unknown'));
      await driver.assertComponentExist(ON.text('fileName: unknown'));
      await driver.assertComponentExist(ON.text('cookie: unknown'));
      await driver.assertComponentExist(ON.id('addFile'));
      let addFile = await driver.findComponent(ON.id('addFile'));
      await addFile.click();
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.delayMs(1000);
      Logger.info(TAG, 'backward_001 end');
    })

    /**
     * 修改文件后撤销
     */
    it('File_Fs_backward_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_backward_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.swipe(600, 837, 300, 837, 600);
      await driver.assertComponentExist(ON.id('editFile'));
      let editFile = await driver.findComponent(ON.id('editFile'));
      await editFile.click();
      await driver.assertComponentExist(ON.text('TestFile11'));
      await driver.assertComponentExist(ON.text('size: 12B'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_backward_001 end');
    })

    /**
     * 修改文件名后撤销
     */
    it('File_Fs_backward_002', 1, async function () {
      Logger.info(TAG, 'File_Fs_backward_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileName'));
      let fileName = await driver.findComponent(ON.id('fileName'));
      await fileName.clearText();
      await fileName.inputText('newFileName');
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.assertComponentExist(ON.id('backward'));
      let backward = await driver.findComponent(ON.id('backward'));
      await backward.click();
      await driver.assertComponentExist(ON.text('TestFile11'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_backward_002 end');
    })

    /**
     * 修改文件内容后撤销
     */
    it('File_Fs_backward_003', 1, async function () {
      Logger.info(TAG, 'File_Fs_backward_003 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileContent'));
      let fileContent = await driver.findComponent(ON.id('fileContent'));
      await fileContent.clearText();
      await fileContent.inputText('newFileContent');
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_backward_003 end');
    })

    /**
     * 修改文件内容后撤销
     */
    it('File_Fs_backward_004', 1, async function () {
      Logger.info(TAG, 'File_Fs_backward_004 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backward'));
      let backward = await driver.findComponent(ON.id('backward'));
      await backward.click();
      await driver.assertComponentExist(ON.text('size: 12B'));
      await driver.assertComponentExist(ON.id('backWatcherFile'));
      let back = await driver.findComponent(ON.id('backWatcherFile'));
      await back.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_backward_004 end');
    })

    /**
     * 点击添加监听后停止监听,测试停止监听页面是否出现弹窗白屏
     */
    it(BUNDLE + 'StopWatcherFunction_001', 0, async function () {
      Logger.info(TAG, BUNDLE + 'StopWatcherFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击停止监听按钮
      await driver.assertComponentExist(ON.id('stopWatcher'));
      let stopWatcher = await driver.findComponent(ON.id('stopWatcher'));
      await stopWatcher.click();
      await driver.delayMs(1000);
      // 点击添加监听按钮
      await driver.assertComponentExist(ON.id('addWatcher'));
      let addWatcher = await driver.findComponent(ON.id('addWatcher'));
      await addWatcher.click();
      await addWatcher.click();
      await driver.delayMs(1000);
      // 点击确定
      let confirmText = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmText));
      let sureWatcher = await driver.findComponent(ON.text(confirmText));
      await sureWatcher.click();
      await driver.delayMs(1000);
      // 点击停止监听按钮
      await driver.assertComponentExist(ON.id('stopWatcher'));
      let stopWatcherTwo = await driver.findComponent(ON.id('stopWatcher'));
      await stopWatcherTwo.click();
      await driver.delayMs(1000);
      // 点击确定按钮
      let confirmTextTwo = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmTextTwo));
      let sureWatcherTwo = await driver.findComponent(ON.text(confirmTextTwo));
      await sureWatcherTwo.click();
      await driver.delayMs(1000);
      // 点击停止监听按钮
      await driver.assertComponentExist(ON.id('stopWatcher'));
      let stopWatcherThree = await driver.findComponent(ON.id('stopWatcher'));
      await stopWatcherThree.click();
      await stopWatcherThree.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'StopWatcherFunction_001 end')
    })

    /**
     * 添加IN_CREATE监听
     */
    it('File_Fs_addCreateWatcher_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_addCreateWatcher_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('addWatcher'));
      let addWatcher = await driver.findComponent(ON.id('addWatcher'));
      await addWatcher.click();
      await driver.assertComponentExist(ON.text('IN_MOVE_SELF'));
      let moveSelfWatcher = await driver.findComponent(ON.text('IN_MOVE_SELF'));
      await moveSelfWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_addCreateWatcher_001 end');
    })

    /**
     * 添加IN_CREATE监听
     */
    it('File_Fs_addCreateWatcher_002', 1, async function () {
      Logger.info(TAG, 'File_Fs_addCreateWatcher_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text('IN_DELETE'));
      let deleteWatcher = await driver.findComponent(ON.text('IN_DELETE'));
      await deleteWatcher.click();
      await driver.assertComponentExist(ON.text('IN_CREATE'));
      let createWatcher = await driver.findComponent(ON.text('IN_CREATE'));
      await createWatcher.click();
      let confirmText = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmText));
      let sureWatcher = await driver.findComponent(ON.text(confirmText));
      await sureWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_addCreateWatcher_002 end');
    })

    /**
     * 添加IN_CREATE监听之后添加文件
     */
    it('File_Fs_afterAddCreateWatcher_addFile_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterAddCreateWatcher_addFile_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('addFile'));
      let addFile = await driver.findComponent(ON.id('addFile'));
      await addFile.click();
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.assertComponentExist(ON.text('event: 256'));
      await driver.assertComponentExist(ON.text('cookie: 0'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterAddCreateWatcher_addFile_001 end');
    })

    /**
     * 添加IN_DELETE监听
     */
    it('File_Fs_addDelWatcher_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_addDelWatcher_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('addWatcher'));
      let addWatcher = await driver.findComponent(ON.id('addWatcher'));
      await addWatcher.click();
      await driver.assertComponentExist(ON.text('IN_DELETE'));
      let deleteWatcher = await driver.findComponent(ON.text('IN_DELETE'));
      await deleteWatcher.click();
      let confirmText = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmText));
      let sureWatcher = await driver.findComponent(ON.text(confirmText));
      await sureWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_addDelWatcher_001 end');
    })

    /**
     * 添加监听之后删除文件
     */
    it('File_Fs_afterAddDelWatcher_delFile_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterAddDelWatcher_delFile_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.swipe(600, 837, 300, 837, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('deleteFile'));
      let deleteFile = await driver.findComponent(ON.id('deleteFile'));
      await deleteFile.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterAddDelWatcher_delFile_001 end');
    })

    /**
     * 添加监听之后删除文件
     */
    it('File_Fs_afterAddDelWatcher_delFile_002', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterAddDelWatcher_delFile_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('deleteWatcher'));
      let deleteWatcher = await driver.findComponent(ON.id('deleteWatcher'));
      await deleteWatcher.click();
      await driver.assertComponentExist(ON.text('event: 512'));
      await driver.assertComponentExist(ON.text('cookie: 0'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterAddDelWatcher_delFile_002 end');
    })

    /**
     * 停止IN_CREATE监听
     */
    it('File_Fs_stopCreateWatcher_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_stopCreateWatcher_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('stopWatcher'));
      let stopWatcher = await driver.findComponent(ON.id('stopWatcher'));
      await stopWatcher.click();
      await driver.assertComponentExist(ON.text('IN_CREATE'));
      let createWatcher = await driver.findComponent(ON.text('IN_CREATE'));
      await createWatcher.click();
      let confirmText = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmText));
      let sureWatcher = await driver.findComponent(ON.text(confirmText));
      await sureWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_stopCreateWatcher_001 end');
    })

    /**
     * 停止监听之后添加文件
     */
    it('File_Fs_afterStopCreateWatcher_addFile001', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterStopCreateWatcher_addFile001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('addFile'));
      let addFile = await driver.findComponent(ON.id('addFile'));
      await addFile.click();
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterStopCreateWatcher_addFile001 end');
    })

    /**
     * 停止IN_DELETE监听
     */
    it('File_Fs_stopDelWatcher_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_stopDelWatcher_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('stopWatcher'));
      let stopWatcher = await driver.findComponent(ON.id('stopWatcher'));
      await stopWatcher.click();
      await driver.assertComponentExist(ON.text('IN_DELETE'));
      let deleteWatcher = await driver.findComponent(ON.text('IN_DELETE'));
      await deleteWatcher.click();
      let confirmText = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmText));
      let sureWatcher = await driver.findComponent(ON.text(confirmText));
      await sureWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_stopDelWatcher_001 end');
    })

    /**
     * 停止监听之后删除文件
     */
    it('File_Fs_afterStopDelWatcher_delFile002', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterStopDelWatcher_delFile002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.delayMs(1000);
      await driver.swipe(600, 837, 300, 837, 600);
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterStopDelWatcher_delFile002 end');
    })

    /**
     * 停止监听之后删除文件
     */
    it('File_Fs_afterStopDelWatcher_delFile001', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterStopDelWatcher_delFile001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('deleteFile'));
      let deleteFile = await driver.findComponent(ON.id('deleteFile'));
      await deleteFile.click();
      await driver.assertComponentExist(ON.id('deleteWatcher'));
      let deleteWatcher = await driver.findComponent(ON.id('deleteWatcher'));
      await deleteWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterStopDelWatcher_delFile001 end');
    })

    /**
     * 添加IN_MODIFY监听
     */
    it('File_Fs_addModifyWatcher_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_addModifyWatcher_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('addWatcher'));
      let addWatcher = await driver.findComponent(ON.id('addWatcher'));
      await addWatcher.click();
      await driver.assertComponentExist(ON.text('IN_MOVE_SELF'));
      let moveSelfWatcher = await driver.findComponent(ON.text('IN_MOVE_SELF'));
      await moveSelfWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_addModifyWatcher_001 end');
    })

    /**
     * 添加IN_MODIFY监听
     */
    it('File_Fs_addModifyWatcher_002', 1, async function () {
      Logger.info(TAG, 'File_Fs_addModifyWatcher_002 begin');
      let driver = Driver.create();
      await driver.assertComponentExist(ON.text('IN_MODIFY'));
      let modifyWatcher = await driver.findComponent(ON.text('IN_MODIFY'));
      await modifyWatcher.click();
      let confirmText = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmText));
      let sureWatcher = await driver.findComponent(ON.text(confirmText));
      await sureWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_addModifyWatcher_002 end');
    })

    /**
     * 添加监听后修改文件
     */
    it('File_Fs_afterAddModifyWatcher_editFile001', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterAddModifyWatcher_editFile001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.swipe(600, 837, 300, 837, 600);
      await driver.assertComponentExist(ON.id('editFile'));
      let editFile = await driver.findComponent(ON.id('editFile'));
      await editFile.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterAddModifyWatcher_editFile001 end');
    })

    /**
     * 添加监听后修改文件内容
     */
    it('File_Fs_afterAddModifyWatcher_editFile002', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterAddModifyWatcher_editFile002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileContent'));
      let fileContent = await driver.findComponent(ON.id('fileContent'));
      await fileContent.clearText();
      await fileContent.inputText('new FileContent');
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.assertComponentExist(ON.id('backWatcherFile'));
      let back = await driver.findComponent(ON.id('backWatcherFile'));
      await back.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterAddModifyWatcher_editFile002 end');
    })

    /**
     * 查看修改文件后监听日志
     */
    it('File_Fs_afterAddModifyWatcher_editFile003', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterAddModifyWatcher_editFile003 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.assertComponentExist(ON.text('event: 2'));
      await driver.assertComponentExist(ON.text('cookie: 0'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterAddModifyWatcher_editFile003 end');
    })

    /**
     * 停止IN_MODIFY监听
     */
    it('File_Fs_stopModifyWatcher_001', 1, async function () {
      Logger.info(TAG, 'File_Fs_stopModifyWatcher_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 检查是否有按键
      await driver.assertComponentExist(ON.id('stopWatcher'));
      let stopWatcher = await driver.findComponent(ON.id('stopWatcher'));
      await stopWatcher.click();
      await driver.assertComponentExist(ON.text('IN_MODIFY'));
      let modifyWatcher = await driver.findComponent(ON.text('IN_MODIFY'));
      await modifyWatcher.click();
      let confirmText = await getResourceString($r('app.string.label_confirm'));
      await driver.assertComponentExist(ON.text(confirmText));
      let sureWatcher = await driver.findComponent(ON.text(confirmText));
      await sureWatcher.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_stopModifyWatcher_001 end');
    })

    /**
     * 停止监听后修改文件
     */
    it('afterStopModifyWatcher_editFile001', 1, async function () {
      Logger.info(TAG, 'afterStopModifyWatcher_editFile001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('list'));
      let scroller = await driver.findComponent(ON.id('list'));
      await scroller.scrollToBottom();
      await driver.swipe(600, 837, 300, 837, 600);
      await driver.assertComponentExist(ON.id('editFile'));
      let editFile = await driver.findComponent(ON.id('editFile'));
      await editFile.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'afterStopModifyWatcher_editFile001 end');
    })

    /**
     * 停止监听后修改文件内容
     */
    it('File_Fs_afterStopModifyWatcher_editFile002', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterStopModifyWatcher_editFile002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('fileContent'));
      let fileContent = await driver.findComponent(ON.id('fileContent'));
      await fileContent.clearText();
      await fileContent.inputText('content');
      await driver.assertComponentExist(ON.id('save'));
      let save = await driver.findComponent(ON.id('save'));
      await save.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterStopModifyWatcher_editFile002 end');
    })

    /**
     * 停止监听后修改文件内容
     */
    it('File_Fs_afterStopModifyWatcher_editFile003', 1, async function () {
      Logger.info(TAG, 'File_Fs_afterStopModifyWatcher_editFile003 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backWatcherFile'));
      let back = await driver.findComponent(ON.id('backWatcherFile'));
      await back.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('list'));
      await driver.delayMs(1000);
      Logger.info(TAG, 'File_Fs_afterStopModifyWatcher_editFile003 end');
    })

    /**
     * 返回首页
     */
    it('backIndex_001', 1, async function () {
      Logger.info(TAG, 'backIndex_001 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('backIndex'));
      let backIndex = await driver.findComponent(ON.id('backIndex'));
      await backIndex.click();
      await driver.delayMs(1000);
      Logger.info(TAG, 'backIndex_001 end');
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
      // 返回
      await driver.pressBack()
      await driver.delayMs(500)
      Logger.info(TAG, BUNDLE + 'MobileFunction_001 end')
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
      let name = 'image' + Date.now().toString() + '.jpg'
      try {
        let curFile = await FileManager.createFileAsset(ability.context, mediaLibrary.MediaType.IMAGE, mediaLibrary.DirectoryType.DIR_IMAGE, name)
        if (curFile === undefined) {
          Logger.error(TAG, 'RequestPermissionFunction_002:createFileAsset failed')
          expect().assertFail()
        }
        file.push(curFile);
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
        await FileManager.deleteFileAsset(fileAsset)
      }
      for (let i = 0; i < TYPE.length; i++) {
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
          file.push(curFile);
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
      for (let i = 0; i < TYPE.length; i++) {
        let name = 'newFile' + Date.now().toString() + TYPE[i][1]
        let createFile = await FileManager.createFileAsset(ability.context, TYPE[i][0], TYPE[i][2], name)
        file.push(createFile);
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
      for (let i = 0; i < TEST_NUM; i++) {
        let curFile = await FileManager.createTxtFileAsset(ability.context);
        file.push(curFile);
        let newResult = await FileManager.getFileAssets(ability.context, TYPE[2][0])
        let newNum = newResult.getCount()
        Logger.info(TAG, 'CreateTxtFileAssetFunction_001:expect num is ' + (num + i + 1) + ' and result is ' + newNum)
        expect(newNum).assertEqual(num + i + 1)
      }
      Logger.info(TAG, BUNDLE + 'CreateTxtFileAssetFunction_001 end')
    })
  })
}