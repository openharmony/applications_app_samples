/*
* 版权所有 (C) 2026 华为终端有限公司
* 根据 Apache 许可证 2.0 版（“许可证”）授权；
* 除非遵守许可证，否则不得使用此文件。
* 您可以在以下网址获取许可证的副本：
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* 除非适用法律要求或书面同意，否则按照许可证分发的软件
* 是按“原样”分发的，不附带任何明示或暗示的担保或条件。
* 有关权限和限制的具体语言，请参阅许可证中的规定。
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