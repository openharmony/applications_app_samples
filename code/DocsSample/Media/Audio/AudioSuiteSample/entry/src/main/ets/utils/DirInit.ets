/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import { common } from '@kit.AbilityKit';
import { fileUri, picker } from '@kit.CoreFileKit';
import fs from '@ohos.file.fs';
import { BusinessError } from '@kit.BasicServicesKit';
const TAG: string = 'DirInit';

export const rootPath = `/storage/Users/currentUser/Download/com.example.audiosuitesample`;
// Directories to be checked and created.
const dirCheckList: string[] = ['printfile'];
/**
 * Directory initialization utility class.
 */
export class DirInitHelper {
  static async checkAndCreateDefaultDir(): Promise<boolean> {
    try {
      // Check if rootPath exists, create it if not.
      if (!DirInitHelper.checkDirExists(rootPath)) {
        if (!DirInitHelper.createDir(rootPath)) {
          return false;
        }
      }
      // Check each directory in dirCheckList.
      dirCheckList.forEach((check: string) => {
        let dirPath = `${rootPath}/${check}`;
        if (!DirInitHelper.isDirectory(dirPath)) {
          fs.mkdirSync(dirPath);
        }
      })
      return true;
    } catch (e) {
      return false;
    }
  }
  /**
   * Initialize the directory using DocumentViewPicker.
   */
  static async initDirWithPicker(): Promise<boolean> {
    return new Promise<boolean>((resolve) => {
      let documentSaveOptions = new picker.DocumentSaveOptions();
      documentSaveOptions.pickerMode = 1;
      let context = getContext() as common.Context;
      let documentPicker = new picker.DocumentViewPicker(context);
      documentPicker.save(documentSaveOptions, (err: BusinessError, documentSaveResult: Array<string>) => {
        if (err) {
          resolve(false);
          return;
        }
        let uri = documentSaveResult[0];
        let filePath = new fileUri.FileUri(uri + `/init.txt`).path;
        try {
          let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
          fs.writeSync(file.fd, new ArrayBuffer(0));
          fs.closeSync(file);
          dirCheckList.forEach((dir: string) => {
            let dirPath = new fileUri.FileUri(`${uri}/${dir}`).path;
            fs.mkdirSync(dirPath);
          })
          resolve(true);
        } catch (err) {
          resolve(false);
        }
      })
    });
  }
  /**
   * Ensure that the directory exists (intelligent mode).
   */
  static async ensureDirExists(): Promise<boolean> {
    let exists = await DirInitHelper.checkAndCreateDefaultDir();
    if (!exists) {
      exists = await DirInitHelper.initDirWithPicker();
    }
    return exists;
  }
  /**
   * Checking whether the specified directory exists.
   */
  static checkDirExists(dirPath: string): boolean {
    try {
      fs.accessSync(dirPath);
      return true;
    } catch (e) {
      return false;
    }
  }
  /**
   * Check if the path exists and is a directory.
   */
  static isDirectory(dirPath: string): boolean {
    try {
      let stat = fs.lstatSync(dirPath);
      return stat.isDirectory();
    } catch (e) {
      return false;
    }
  }
  /**
   * Create a directory (recursive creation supported).
   */
  static createDir(dirPath: string): boolean {
    try {
      fs.mkdirSync(dirPath, true);
      return true;
    } catch (err) {
      return false;
    }
  }
}