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

import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import UIAbility from '@ohos.app.ability.UIAbility';
import mediaLibrary from '@ohos.multimedia.mediaLibrary';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import Logger from '../util/Logger';

const BUNDLE = 'MultiMedia_';
const TAG = 'MultiMediaAppTestPage';
const TIME_OUT = 1000;
let ability: UIAbility;
let driver: Driver = Driver.create();
let mediaTest: mediaLibrary.MediaLibrary = undefined;
let uiAbility: UIAbility;

async function getFileAssetsFromType(mediaType: number) {
  Logger.info(TAG, `getFileAssetsFromType,mediaType = ${mediaType}`);
  let fileKeyObj = mediaLibrary.FileKey;
  let fileAssets = [];
  let fetchOp = {
    selections: `${fileKeyObj.MEDIA_TYPE}=?`,
    selectionArgs: [`${mediaType}`],
  };
  let fetchFileResult = await mediaTest.getFileAssets(fetchOp);
  Logger.info(TAG, `getFileAssetsFromType,fetchFileResult.count = ${fetchFileResult.getCount()}`);
  if (fetchFileResult.getCount() > 0) {
    fileAssets = await fetchFileResult.getAllObject();
  }
  return fileAssets;
}

async function getAlbums() {
  Logger.info(TAG, `getAlbums start`);
  let albums = [];
  let [ files, images, videos, audios ] = await Promise.all([
  getFileAssetsFromType(mediaLibrary.MediaType.FILE),
  getFileAssetsFromType(mediaLibrary.MediaType.IMAGE),
  getFileAssetsFromType(mediaLibrary.MediaType.VIDEO),
  getFileAssetsFromType(mediaLibrary.MediaType.AUDIO)
  ]);

  albums.push({
    albumName: 'Documents', count: files.length, mediaType: mediaLibrary.MediaType.FILE
  });
  albums.push({
    albumName: 'Pictures', count: images.length, mediaType: mediaLibrary.MediaType.IMAGE
  });
  albums.push({
    albumName: 'Videos', count: videos.length, mediaType: mediaLibrary.MediaType.VIDEO
  });
  albums.push({
    albumName: 'Audios', count: audios.length, mediaType: mediaLibrary.MediaType.AUDIO
  });
  Logger.info(TAG, `getAlbums end`);
  return albums;
}

export default function appTest() {
  describe('appTest', function () {
    // 打开应用
    it(BUNDLE + 'StartAbility', 0, async function (done) {
      Logger.info(TAG, 'StartAbility start')
      let want = {
        bundleName: 'ohos.samples.multimedia',
        abilityName: 'MainAbility'
      };
      let abilityDelegator: AbilityDelegatorRegistry.AbilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      abilityDelegator.startAbility(want, (err) => {
        Logger.info(TAG, `_startAbility get err ${JSON.stringify(err)}`);
        done();
        Logger.info(TAG, '_startAbility end');
      });

      function onAbilityCreateCallback() {
        Logger.info(TAG, 'onAbilityCreateCallback');
      }

      let monitor: AbilityDelegatorRegistry.AbilityMonitor = {
        abilityName: 'MainAbility',
        onAbilityCreate: onAbilityCreateCallback
      }
      uiAbility = await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT);
      ability = await abilityDelegator.getCurrentTopAbility();
      mediaTest = mediaLibrary.getMediaLibrary(uiAbility.context);
      Logger.info(TAG, 'StartAbility end');
    });
    /**
     * 获取权限
     */
    it(`${BUNDLE}RequestEnableNotification`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification begin');
      await driver.delayMs(1000);
      let resourceManager = ability.context.resourceManager;
      for (let i = 0;i < 4; i++) {
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
        let agreeNotication: Component = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
        await agreeNotication.click();
        await driver.delayMs(1000);
      }
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification end');
    });
    /**
     * 显示相册、录音、文件入口
     */
    it(`${BUNDLE}PageEntry_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'PageEntry_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      // 点击加号按钮，弹出相机、录音、文档页面入口
      await driver.assertComponentExist(ON.id('addBtn'));
      let addBtn: Component = await driver.findComponent(ON.id('addBtn'));
      await addBtn.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'PageEntry_001 end');
    });
    /**
     * 照相功能
     */
    it(`${BUNDLE}Camera_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'Camera_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      // 点击进入相机页面
      await driver.assertComponentExist(ON.id('camera'));
      let camera: Component = await driver.findComponent(ON.id('camera'));
      await camera.click();
      await driver.delayMs(1000);
      // 启动照相按钮
      await driver.assertComponentExist(ON.id('cameraIcon'));
      let cameraIcon: Component = await driver.findComponent(ON.id('cameraIcon'));
      await cameraIcon.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'Camera_001 end');
    });
    /**
     * 录像功能
     */
    it(`${BUNDLE}Video_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'Video_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      // 点击切换录像功能
      await driver.assertComponentExist(ON.id('video'));
      let camera: Component = await driver.findComponent(ON.id('video'));
      await camera.click();
      await driver.delayMs(1000);
      // 点击进行录像
      await driver.assertComponentExist(ON.id('cameraIcon'));
      let cameraIcon: Component = await driver.findComponent(ON.id('cameraIcon'));
      await cameraIcon.click();
      // 5s之后再次点击保存录像
      await driver.delayMs(5000);
      await cameraIcon.click();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('mediaType2'));
      let mediaType: Component = await driver.findComponent(ON.id('mediaType2'));
      await mediaType.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('mediaId0'));
      let medieItem: Component = await driver.findComponent(ON.id('mediaId0'));
      await medieItem.click();
      await driver.delayMs(2000);
      let resourceManager = ability.context.resourceManager;
      for (let i = 0;i < 2; i++) {
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
        let agreeNotication: Component = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.allow'))));
        await agreeNotication.click();
        await driver.delayMs(1000);
      }
      await driver.delayMs(2000);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      Logger.info(TAG, BUNDLE + 'Video_001 end');
    });
    /**
     * 录音功能
     */
    it(`${BUNDLE}Record_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'Record_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('addBtn'));
      let addBtn: Component = await driver.findComponent(ON.id('addBtn'));
      await addBtn.click();
      await driver.delayMs(1000);
      // 进入录音页面
      await driver.assertComponentExist(ON.id('record'));
      let record: Component = await driver.findComponent(ON.id('record'));
      await record.click();
      await driver.delayMs(1000);
      // 开始录音
      await driver.assertComponentExist(ON.id('startBtn'));
      let startBtn: Component = await driver.findComponent(ON.id('startBtn'));
      await startBtn.click();
      // 启动3s之后结束
      await driver.delayMs(3000);
      await driver.assertComponentExist(ON.id('pauseBtn'));
      let pauseBtn: Component = await driver.findComponent(ON.id('pauseBtn'));
      await pauseBtn.click();
      await driver.delayMs(1000);
      // 返回主页
      await driver.assertComponentExist(ON.id('back'));
      let backIndex: Component = await driver.findComponent(ON.id('back'));
      await backIndex.click();
      Logger.info(TAG, BUNDLE + 'Record_001 end');
    });
    /**
     * 文本编辑功能
     */
    it(`${BUNDLE}TxtEdit_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'TxtEdit_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      // 添加五个文件
      for (let i = 0; i < 5; i++) {
        await driver.assertComponentExist(ON.id('addBtn'));
        let addBtn: Component = await driver.findComponent(ON.id('addBtn'));
        await addBtn.click();
        await driver.delayMs(1000);
        // 进入文本编辑页面
        await driver.assertComponentExist(ON.id('document'));
        let document: Component = await driver.findComponent(ON.id('document'));
        await document.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('textArea'));
        let textArea: Component = await driver.findComponent(ON.id('textArea'));
        await textArea.inputText(`mst`);
        // 保存文本
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('saveBtn'));
        let saveBtn: Component = await driver.findComponent(ON.id('saveBtn'));
        await saveBtn.click();
        await driver.delayMs(1000);
      }
      Logger.info(TAG, BUNDLE + 'TxtEdit_001 end');
    });
    /**
     * 执行数据重命名以及删除操作
     */
    it(`${BUNDLE}BaseFeature_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'BaseFeature_001 begin');
      await driver.delayMs(1000);
      // 校验数据是否添加成功，每次操作添加一次数据，成功数据为非空
      let mediaAlbums = await getAlbums();
      let resourceManager = ability.context.resourceManager;
      mediaAlbums.forEach((item) => {
        if (item.count === 0) {
          Logger.info(TAG, `${item.albumName} obtaining data error`);
          expect().assertFail();
        }
      });
      // 循环4次，分别对文档、图片、视频、音频进行重名和删除操作
      for (let i = 0;i < 4; i++) {
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id(`mediaType${i}`));
        let mediaType: Component = await driver.findComponent(ON.id(`mediaType${i}`));
        await mediaType.click();
        await driver.delayMs(1000);
        // 重命名
        await driver.assertComponentExist(ON.id('rename0'));
        let rename: Component = await driver.findComponent(ON.id('rename0'));
        await rename.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('inputRename'));
        let inputRename: Component = await driver.findComponent(ON.id('inputRename'));
        await inputRename.clearText();
        await driver.delayMs(1000);
        // 输入文本
        await inputRename.inputText('mst');
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.agree'))));
        let confirm: Component = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.agree'))));
        await driver.delayMs(1000);
        await confirm.click();
        await driver.delayMs(1000);
        // 校验文本
        await driver.assertComponentExist(ON.id('fileName'));
        let fileName: Component = await driver.findComponent(ON.id('fileName'));
        await driver.delayMs(1000);
        expect('mst').assertEqual(await fileName.getText());
        // 删除数据
        await driver.assertComponentExist(ON.id('delete0'));
        await driver.delayMs(1000);
        let deleteData: Component = await driver.findComponent(ON.id('delete0'));
        await driver.delayMs(1000);
        await deleteData.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.agree'))));
        let confirmBtn: Component = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.agree'))));
        await driver.delayMs(1000);
        await confirmBtn.click();
        await driver.delayMs(1000);
        // 校验是否删除成功
        let mediaAblumsDeleted = await getAlbums();
        if (mediaAblumsDeleted[i].count !== mediaAlbums[i].count - 1) {
          Logger.info(TAG, `Type ${i} deletion failed`)
          expect().assertFail();
        }
        await driver.assertComponentExist(ON.id('back'));
        let backIndex: Component = await driver.findComponent(ON.id('back'));
        await backIndex.click();
      }
      Logger.info(TAG, BUNDLE + 'BaseFeature_001 end');
    });
    /**
     * 删除多条数据操作
     */
    it(`${BUNDLE}DeleteMultipleData_001`, 0, async () => {
      Logger.info(TAG, BUNDLE + 'DeleteMultipleData_001 begin');
      await driver.delayMs(1000);
      // 校验数据是否添加成功，每次操作添加一次数据，成功数据为非空
      let mediaAlbums = await getAlbums();
      let resourceManager = ability.context.resourceManager;
      await driver.assertComponentExist(ON.id(`mediaType0`));
      let mediaType: Component = await driver.findComponent(ON.id(`mediaType0`));
      await mediaType.click();
      await driver.delayMs(1000);
      // 获取当前文件数据的个数，并依次删除
      for (let i = 0; i < mediaAlbums[0].count; i++) {
        let medias = await getAlbums();
        await driver.delayMs(1000);
        // 删除数据
        await driver.assertComponentExist(ON.id(`delete${i}`));
        let deleteData: Component = await driver.findComponent(ON.id(`delete${i}`));
        await deleteData.click();
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.text(await resourceManager.getStringValue($r('app.string.agree'))));
        let confirmBtn: Component = await driver.findComponent(ON.text(await resourceManager.getStringValue($r('app.string.agree'))));
        await confirmBtn.click();
        await driver.delayMs(1000);
        // 校验是否删除成功
        let mediaAblumsDeleted = await getAlbums();
        if (mediaAblumsDeleted[0].count !== medias[0].count - 1) {
          Logger.info(TAG, `Type deletion failed`)
          expect().assertFail();
        }
      }
      Logger.info(TAG, BUNDLE + 'DeleteMultipleData_001 end');
    });
  });
}