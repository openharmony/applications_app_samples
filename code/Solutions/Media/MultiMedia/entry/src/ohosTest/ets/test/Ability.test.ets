/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import { describe, expect, it } from '@ohos/hypium';
import { Driver, ON, Component } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import Logger from '../utils/Logger';
import userFileManager from '@ohos.filemanagement.userFileManager';
import { getString } from '../utils/ResourceUtil';
import fileAccess from '@ohos.file.fileAccess';
import common from '@ohos.app.ability.common';

const TAG: string = 'abilityTest';
const driver = Driver.create();
const DOMAIN = 0xF811;
const BUNDLE = 'MultiMedia_';
let abilityDelegatorRegistry = AbilityDelegatorRegistry.getAbilityDelegator();

enum FileType {
  IMAGE = 1,
  VIDEO = 2,
  AUDIO = 3,
  FILE= 4
}

interface FileDetail {
  albumName : string;
  count : number,
  mediaType : number;
}

async function getFileAssetsFromType(mediaTest: userFileManager.UserFileManager, mediaType: number): Promise<userFileManager.FileAsset[]> {
  Logger.info(TAG, `getFileAssetsFromType,mediaType = ${mediaType}`);
  let fileAssets: Array<userFileManager.FileAsset> = [];

  try {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: ['duration', 'date_added'],
      predicates: predicates
    }
    let fetchFileResult: userFileManager.FetchResult<userFileManager.FileAsset> | undefined = undefined;
    // 获取音频资源
    if (mediaType === FileType.AUDIO) {
      fetchFileResult = await mediaTest.getAudioAssets(fetchOptions);
      fileAssets = await fetchFileResult.getAllObject();
    } else {
      // 获取图片/视频资源
      fetchFileResult = await mediaTest.getPhotoAssets(fetchOptions);
      fileAssets = await fetchFileResult.getAllObject();
      // 过滤资源
      fileAssets = fileAssets.filter(item => item.fileType === mediaType)
    }
  } catch (err) {
    Logger.info(TAG, `err ${JSON.stringify(err)}`);
  }
  Logger.info(TAG, `getFileAssetsFromType = ${mediaType},fileAssets.count = ${fileAssets.length}`);
  return fileAssets
}

async function getFileAssets(context: common.UIAbilityContext): Promise<fileAccess.FileInfo[]> {
  let isDone: boolean = false;
  let fileInfos: Array<fileAccess.FileInfo> = [];
  try {
    let fileAccessHelper = fileAccess.createFileAccessHelper(context);
    let rootIterator: fileAccess.RootIterator = await fileAccessHelper.getRoots();
    // 获取目录url
    let catalogueUrl: string = rootIterator.next().value.uri;
    let fileInfo: fileAccess.FileInfo = await fileAccessHelper.getFileInfoFromUri(catalogueUrl);
    let fileIterator = fileInfo.scanFile();
    while (!isDone) {
      let result = fileIterator.next();
      isDone = result.done;
      if (!isDone) {
        fileInfos.push(result.value);
      }
    }
  } catch (error) {
    Logger.info(TAG, "getRoots failed, errCode:" + error.code + ", errMessage:" + error.message);
  }
  return fileInfos;
}

async function getAlbums() {
  Logger.info(TAG, `getAlbums start`);

  // 获取当前应用的ability
  let currentAbility = await abilityDelegatorRegistry.getCurrentTopAbility();
  let mediaTest: userFileManager.UserFileManager = userFileManager.getUserFileMgr(currentAbility.context);

  const files = await getFileAssets(currentAbility.context);
  const images = await getFileAssetsFromType(mediaTest, FileType.IMAGE);
  const videos = await getFileAssetsFromType(mediaTest, FileType.VIDEO);
  const audios = await getFileAssetsFromType(mediaTest, FileType.AUDIO);

  let albums: FileDetail[] = [];

  const document: FileDetail = { albumName: 'Documents', count: files.length, mediaType: FileType.FILE };
  albums.push(document);

  const Pictures: FileDetail = { albumName: 'Pictures', count: images.length, mediaType: FileType.IMAGE };
  albums.push(Pictures);

  const Videos: FileDetail = { albumName: 'Videos', count: videos.length, mediaType: FileType.VIDEO };
  albums.push(Videos)

  const Audios: FileDetail = { albumName: 'Audios', count: audios.length, mediaType: FileType.AUDIO };
  albums.push(Audios);

  Logger.info(TAG, `getAlbums end`);
  return albums;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done : () => void) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      try {
        await abilityDelegatorRegistry.startAbility({
          bundleName: 'ohos.samples.multimedia',
          abilityName: 'MainAbility'
        })
      } catch (err) {
        expect(0).assertEqual(err.code);
      }
      await driver.delayMs(3000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it('RequestEnableNotification', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification begin');
      for (let i = 0;i < 4; i++) {
        await driver.assertComponentExist(ON.text(getString($r('app.string.allow'))));
        let agreeNotication: Component = await driver.findComponent(ON.text(getString($r('app.string.allow'))));
        await agreeNotication.click();
        await driver.delayMs(1000);
      }
      done();
      Logger.info(TAG, BUNDLE + 'RequestEnableNotification end');
    });

    /**
     * 显示相册、录音、文件入口
     */
    it('PageEntry_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'PageEntry_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      // 点击加号按钮，弹出相机、录音、文档页面入口
      await driver.assertComponentExist(ON.id('addBtn'));
      let addBtn: Component = await driver.findComponent(ON.id('addBtn'));
      await addBtn.click();
      await driver.delayMs(1000);
      done()
      Logger.info(TAG, BUNDLE + 'PageEntry_001 end');
    });

    /**
     * 照相功能
     */
    it('Camera_001', 0, async (done: Function) => {
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
      done()
      Logger.info(TAG, BUNDLE + 'Camera_001 end');
    });

    /**
     * 录像功能
     */
    it('Video_001', 0, async (done: Function) => {
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
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.pressBack();
      await driver.delayMs(1000);
      done()
      Logger.info(TAG, BUNDLE + 'Video_001 end');
    });

    /**
     * 录音功能
     */
    it('Record_001', 0, async (done: Function) => {
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
      await driver.delayMs(1000);
      done()
      Logger.info(TAG, BUNDLE + 'Record_001 end');
    });

    /**
     * 文本编辑功能
     */
    it('TxtEdit_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'TxtEdit_001 begin');
      let driver: Driver = Driver.create();
      await driver.delayMs(1000);
      // 添加文件
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
      await driver.delayMs(1000);
      done()
      Logger.info(TAG, BUNDLE + 'TxtEdit_001 end');
    });

    /**
     * 执行数据重命名以及删除操作
     */
    it('BaseFeature_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'BaseFeature_001 begin');
      // 校验数据是否添加成功，每次操作添加一次数据，成功数据为非空
      let mediaAlbums = await getAlbums();
      mediaAlbums.forEach((item) => {
        if (item.count === 0) {
          Logger.info(TAG, `${item.albumName} obtaining data error, item.albumName: ${item.count}`);
          expect().assertFail();
        }
      });
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('mediaType0'));
      let mediaType: Component = await driver.findComponent(ON.id('mediaType0'));
      await mediaType.click();
      await driver.delayMs(1000);
      // 点击重命名
      await driver.assertComponentExist(ON.id('rename0'));
      let rename: Component = await driver.findComponent(ON.id('rename0'));
      await rename.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('inputRename'));
      let inputRename: Component = await driver.findComponent(ON.id('inputRename'));
      await inputRename.clearText();
      // 输入文本
      await inputRename.inputText('mst');
      await driver.delayMs(1000);
      // 点击收起软键盘
      await driver.click(670, 700);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(getString($r('app.string.agree'))));
      let confirm: Component = await driver.findComponent(ON.text(getString($r('app.string.agree'))));
      await confirm.click();
      await driver.delayMs(1000);
      // 校验文本
      await driver.assertComponentExist(ON.id('fileName0'));
      await driver.assertComponentExist(ON.text('mst'));
      await driver.delayMs(1000);
      // 删除数据
      await driver.assertComponentExist(ON.id('delete0'));
      await driver.delayMs(1000);
      let deleteData: Component = await driver.findComponent(ON.id('delete0'));
      await deleteData.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(getString($r('app.string.agree'))));
      let confirmBtn: Component = await driver.findComponent(ON.text(getString($r('app.string.agree'))));
      await confirmBtn.click();
      await driver.delayMs(1000);
      // 校验是否删除成功
      let mediaAblumsDeleted = await getAlbums();
      if (mediaAblumsDeleted[0].count !== mediaAlbums[0].count - 1) {
        Logger.info(TAG, `fileType deletion failed`)
        expect().assertFail();
      }
      await driver.assertComponentExist(ON.id('back'));
      let backIndex: Component = await driver.findComponent(ON.id('back'));
      await backIndex.click();

      await driver.delayMs(1000);
      done()
      Logger.info(TAG, BUNDLE + 'BaseFeature_001 end');
    });

    /**
     * 删除多条数据操作
     */
    it('DeleteMultipleData_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'DeleteMultipleData_001 begin');
      await driver.delayMs(1000);
      // 校验数据是否添加成功，每次操作添加一次数据，成功数据为非空
      let mediaAlbums = await getAlbums();
      await driver.assertComponentExist(ON.id('mediaType0'));
      let mediaType: Component = await driver.findComponent(ON.id('mediaType0'));
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
        await driver.assertComponentExist(ON.text(getString($r('app.string.agree'))));
        let confirmBtn: Component = await driver.findComponent(ON.text(getString($r('app.string.agree'))));
        await confirmBtn.click();
        await driver.delayMs(1000);
        // 校验是否删除成功
        let mediaAblumsDeleted = await getAlbums();
        if (mediaAblumsDeleted[0].count !== medias[0].count - 1) {
          Logger.info(TAG, `Type deletion failed`)
          expect().assertFail();
        }
      }
      done()
      Logger.info(TAG, BUNDLE + 'DeleteMultipleData_001 end');
    });
  })
}