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

import ConfigurationConstant from '@ohos.app.ability.ConfigurationConstant';
import fs from '@ohos.file.fs';
import prompt from '@ohos.promptAction';
import { logger } from '../util/Logger';

const TAG: string = 'EntryAbility';
const TIME: number = 3000;

export default class CharacterOperation {
  private context: Context;

  constructor(context: Context) {
    this.context = context;
  }
  // 设置中文
  setZHCNLanguage = () => {
    let applicationContext = this.context.getApplicationContext();
    applicationContext.setLanguage('zh-cn');
    logger.info(`${TAG} Chinese success`);
  }
  // 设置英文
  setENUSLanguage = () => {
    let applicationContext = this.context.getApplicationContext();
    applicationContext.setLanguage('en-us');
    logger.info(`${TAG} English success`);
  }
  // 设置深色模式
  setDarKColorMode = () => {
    let applicationContext = this.context.getApplicationContext();
    applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    prompt.showToast({
      message: $r('app.string.switchDarkSuccess'), duration: TIME
    });
  }
  // 设置浅色模式
  setLightColorMode = () => {
    let applicationContext = this.context.getApplicationContext();
    applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_LIGHT);
    prompt.showToast({
      message: $r('app.string.switchLightSuccess'), duration: TIME
    });
  }
  // 获取缓存路径
  generateStorageFiles = () => {
    let context = this.context;
    let filePathName = '/test.txt';
    let cacheDirPath = context.cacheDir + filePathName;
    let filesDirPath = context.filesDir + filePathName;
    let preferencesDirPath = context.preferencesDir + filePathName;
    let tempDirPath = context.tempDir + filePathName;
    let databaseDirPath = context.databaseDir + filePathName;

    return [cacheDirPath, filesDirPath, preferencesDirPath, tempDirPath, databaseDirPath];
  }
  // 创建存储数据
  createStorageData = () => {
    let context = this.context;
    let filePathName = '/test.txt';
    let cacheDirPath = context.cacheDir + filePathName;
    let filesDirPath = context.filesDir + filePathName;
    let preferencesDirPath = context.preferencesDir + filePathName;
    let tempDirPath = context.tempDir + filePathName;
    let databaseDirPath = context.databaseDir + filePathName;
    try {
      let file1 = fs.openSync(cacheDirPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let file2 = fs.openSync(filesDirPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let file3 = fs.openSync(preferencesDirPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let file4 = fs.openSync(tempDirPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      let file5 = fs.openSync(databaseDirPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);

      fs.closeSync(file1);
      fs.closeSync(file2);
      fs.closeSync(file3);
      fs.closeSync(file4);
      fs.closeSync(file5);

      if (fs.accessSync(cacheDirPath) && fs.accessSync(filesDirPath)
      && fs.accessSync(preferencesDirPath) && fs.accessSync(tempDirPath)
      && fs.accessSync(databaseDirPath)) {
        prompt.showToast({
          message: $r('app.string.create_File_Success'), duration: TIME
        });
      }
    } catch (error) {
    }
  }
  // 检查文件
  checkStorageData = () => {
    let context = this.context;
    let filePathName = '/test.txt';
    let cacheDirPath = context.cacheDir + filePathName;
    let filesDirPath = context.filesDir + filePathName;
    let preferencesDirPath = context.preferencesDir + filePathName;
    let tempDirPath = context.tempDir + filePathName;
    let databaseDirPath = context.databaseDir + filePathName;
    if (fs.accessSync(cacheDirPath) && fs.accessSync(filesDirPath)
    && fs.accessSync(preferencesDirPath) && fs.accessSync(tempDirPath) && fs.accessSync(databaseDirPath)) {
      prompt.showToast({
        message: $r('app.string.search_File_Success'), duration: TIME
      });
    } else {
      prompt.showToast({
        message: $r('app.string.search_File_Failed'), duration: TIME
      });
    }
  }
  // 清理存储数据
  clearStorageData = () => {
    let context = this.context;
    let filePathName = '/test.txt';
    let cacheDirPath = context.cacheDir + filePathName;
    let filesDirPath = context.filesDir + filePathName;
    let preferencesDirPath = context.preferencesDir + filePathName;
    let tempDirPath = context.tempDir + filePathName;
    let databaseDirPath = context.databaseDir + filePathName;
    if (fs.accessSync(cacheDirPath) && fs.accessSync(filesDirPath) && fs.accessSync(preferencesDirPath)
    && fs.accessSync(tempDirPath) && fs.accessSync(databaseDirPath)) {
      context.getApplicationContext().clearUpApplicationData((err) => {
        logger.info(`clearUpApplicationData err:${JSON.stringify(err)}}`);
        prompt.showToast({
          message: $r('app.string.clean_Data_Success'), duration: TIME
        });
      });
    } else {
      // 清理存储数据失败
      prompt.showToast({
        message: $r('app.string.clean_Data_Failed'), duration: TIME
      });
    }
  }
}
