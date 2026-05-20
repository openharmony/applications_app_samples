/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { fileIo as FileIO } from '@kit.CoreFileKit';
import { MLog } from '../utils/MLog';
import { BusinessError } from '@kit.BasicServicesKit';

const TAG: string = 'FileIoManager';

export class FileIoManager {
  public static async mkDir(path: string): Promise<void> {
    try {
      await FileIO.mkdir(path);
    } catch (err) {
      MLog.error(TAG, `mkDir err:${err}`);
    }
  }

  public static async isDir(file: string | number): Promise<boolean> {
    return FileIO.stat(file).then(stat => {
      let ret: boolean = stat.isDirectory();
      return ret;
    }).catch((err: BusinessError) => {
      MLog.printError(TAG, `isDir error ! file:${file}`, err);
      return false;
    });
  }

  public static async copy(srcUri: string, destUri: string, progressFun?: (progress: FileIO.Progress) => void): Promise<string> {
    try {
      MLog.info(TAG, `copy srcUri:${srcUri} destUri:${destUri}`);
      let options: FileIO.CopyOptions = {
        progressListener: progressFun,
      };
      return FileIO.copy(srcUri, destUri, options)
        .then(() => {
          MLog.info(TAG, `copy finish srcUri:${srcUri} destUri:${destUri}`);
          return '';
        }).catch((err: BusinessError) => {
          MLog.printError(TAG, 'copy catch error', err);
          throw new Error(`copy failed: ${err.message}`);
        });
    } catch (err) {
      MLog.printError(TAG, 'copy error', err);
      throw new Error(`copy failed: ${JSON.stringify(err)}`);
    }
  }

  public static async copyFile(src: string | number, dest: string | number): Promise<void> {
    try {
      await FileIO.copyFile(src, dest);
    } catch (err) {
      MLog.error(TAG, `copyFile err:${err}`);
    }
  }

  public static async writeFile(rootPath: string, sourceBuf: string): Promise<number> {
    try {
      let filePath: string = rootPath + '/test.txt';
      let file: FileIO.File = FileIO.openSync(filePath, FileIO.OpenMode.CREATE | FileIO.OpenMode.READ_WRITE);
      let writeSize: number = await FileIO.write(file.fd, sourceBuf);
      MLog.info(TAG, 'write data to file succeed and size is:' + writeSize);
      FileIO.close(file);
      return writeSize;
    } catch (err) {
      MLog.error(TAG, `writeFile err:${err}`);
      return -1;
    }
  }

  public static close(fd: number): void {
    try {
      FileIO.close(fd);
    } catch (err) {
      MLog.error(TAG, `close err:${err}`);
    }
  }

  public static async writeFileFd(fd: number, buffer: ArrayBuffer | string): Promise<number> {
    try {
      let write: number = await FileIO.write(fd, buffer);
      return write;
    } catch (err) {
      MLog.error(TAG, 'writeFileFd failed, error ' + err);
      return -1;
    }
  }

  public static async readFileFd(fd: number): Promise<ArrayBuffer | undefined> {
    try {
      let stat: FileIO.Stat = await FileIO.stat(fd);
      MLog.print(TAG, `fd:${fd} stat.size:${stat.size}`);
      let readSize: number = 2 * 1024 * 1024;
      let arr: Uint8Array = new Uint8Array(readSize);
      let offset: number = 0;
      let readLen: number;
      let useTime: number = new Date().getTime();
      do {
        if (offset + readSize > stat.size) {
          readSize = stat.size - offset;
        }
        let buf: ArrayBuffer = new ArrayBuffer(readSize);
        readLen = await FileIO.read(fd, buf, { offset: offset });
        if (readLen <= 0) {
          break;
        }
        if (arr.length < offset + readLen) {
          let tmp: Uint8Array = new Uint8Array(offset + readLen);
          tmp.set(arr);
          arr = tmp;
        }
        arr.set(new Uint8Array(buf), offset);
        offset += readLen;
      } while (offset < stat.size);
      if (arr.length > offset) {
        arr = arr.slice(0, offset);
      }
      await FileIO.close(fd);
      MLog.print(TAG, ` finish buffer:${arr.length} useTime:${(new Date().getTime() - useTime)}`);
      return arr;
    } catch (error) {
      MLog.error(TAG, 'openFile failed, error ' + error);
      return undefined;
    }
  }

  public static async getDirFd(fd: number): Promise<void> {
    MLog.print(TAG, ` getDirFd >>>> `);
    let stat: FileIO.Stat = await FileIO.stat(fd);
    MLog.print(TAG, `getDirFd stat:${FileIoManager.statToStr(stat)}`);
  }

  public static async getDirStat(path: string): Promise<void> {
    MLog.print(TAG, ` getDirStat >>>> `);
    let stat: FileIO.Stat = await FileIO.lstat(path);
    MLog.print(TAG, ` getDirStat stat:${(stat)}`);
  }

  public static statToStr(stat: FileIO.Stat): string {
    return JSON.stringify({
      ino: stat.ino,
      mode: stat.mode,
      size: stat.size,
      mtime: stat.mtime,
    });
  }

  public static async getDir(path: string): Promise<SandboxFileInfo[]> {
    let names: string[] = await FileIO.listFile(path);
    let list: SandboxFileInfo[] = [];
    let prePath: string = path.endsWith('/') ? path : path + '/';
    for (let name of names) {
      let stat: FileIO.Stat = await FileIO.stat(prePath + name);
      let info: SandboxFileInfo = {
        name: name,
        path: path,
        isDir: stat.isDirectory()
      };
      list.push(info);
      if (stat.isDirectory()) {
        let dirlist: SandboxFileInfo[] = await FileIoManager.getDir(prePath + name);
        info.list = dirlist;
      }
    }
    list.sort((a: SandboxFileInfo, b: SandboxFileInfo) => {
      if (a.isDir && !b.isDir) {
        return -1;
      } else if (b.isDir && !a.isDir) {
        return 1;
      } else {
        return a.name > b.name ? 1 : 0;
      }
    });
    return list;
  }

  public static async listDir(path: string): Promise<SandboxFileInfo[]> {
    let names: string[] = await FileIO.listFile(path);
    let list: SandboxFileInfo[] = [];
    let prePath: string = path.endsWith('/') ? path : path + '/';
    for (let name of names) {
      let stat: FileIO.Stat = await FileIO.stat(prePath + name);
      let info: SandboxFileInfo = {
        name: name,
        path: path,
        isDir: stat.isDirectory()
      };
      list.push(info);
    }
    return list;
  }
}

export interface SandboxFileInfo {
  name: string;
  path: string;
  isDir: boolean;
  list?: SandboxFileInfo[];
}
