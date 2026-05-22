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

import { Tools } from '../utils/Tools';
import { MLog } from '../utils/MLog';
import { SUFFIX_AUDIO, SUFFIX_IMAGE, SUFFIX_TEXT, SUFFIX_VIDEO } from '../ConstantsMedia';
import { FileInfo } from '../data/FileInfo';
import { fileExtensionInfo, fileAccess, trash, userFileManager, Filter } from '@kit.CoreFileKit';
import { Want, Context } from '@kit.AbilityKit';
import { UserFileManager } from './UserFileManager';
import { FileBean } from '../../component/bean/FileBean';
import { MediaType } from '../../model/MediaType';
import { BusinessError } from '@kit.BasicServicesKit';
import { FileIoManager } from './FileIoManager';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { dataSharePredicates } from '@kit.ArkData';

const TAG: string = 'FileAccessManager';

async function clearTrash(): Promise<void> {
  try {
    MLog.info(TAG, `clearTrash start`);
    for (let it of trash.listFile()) {
      if (it) {
        trash.completelyDelete(it.uri);
        MLog.info(TAG, `clearTrash completelyDelete uri:${it.uri}`);
      }
    }
    MLog.info(TAG, `clearTrash end`);
  } catch (e) {
    throw new Error(`clearTrash failed: ${JSON.stringify(e)}`);
  }
}

function completeDeleteOne(name: string): void {
  try {
    MLog.print(TAG, `completeDelete start`);
    if (name) {
      MLog.info(TAG, `completelyDelete bean name:${name}`);
      let find = trash.listFile().find(it => it.fileName === name);
      if (find) {
        trash.completelyDelete(find.uri);
        MLog.info(TAG, `clearTrash completelyDelete uri:${find.uri}`);
      }
    }
    MLog.print(TAG, `completeDelete end`);
  } catch (e) {
    throw new Error(`completeDeleteOne failed: ${JSON.stringify(e)}`);
  }
}

async function runTask<T>(taskArr: Promise<T>[]): Promise<Array<T>> {
  MLog.print(TAG, `runTask size:${taskArr.length}`);
  return Promise.allSettled(taskArr).then((results: PromiseSettledResult<T>[]) => {
    let resultArr: T[] = [];
    results.forEach((result: PromiseSettledResult<T>, index: number) => {
      if (result.status === 'fulfilled') {
        MLog.info(TAG, `runTask index:${index} result:${result.value}`);
        resultArr.push(result.value);
      } else {
        MLog.info(TAG, `runTask index:${index} failed with error: ${result.reason.message}`);
      }
    });
    return resultArr;
  });
}

interface RootIteratorResult {
  value: fileAccess.RootInfo;
  done: boolean;
}

interface FileIteratorResult {
  value: FileInfo;
  done: boolean;
}

export interface RootData {
  root: FileInfo | undefined;
  list: FileBean[];
}

class MediaFileInfoImpl implements FileInfo {
  uri: string;
  relativePath: string;
  fileName: string;
  size: number;
  mtime: number;
  mimeType: string;
  mode: number;

  constructor(fileAsset: userFileManager.FileAsset) {
    this.uri = fileAsset.uri;
    this.fileName = fileAsset.displayName;
    this.relativePath = '';
    this.size = fileAsset.get('size') as number;
    this.mtime = fileAsset.get('date_added') as number;
    this.mimeType = '';
    this.mode = fileExtensionInfo.DocumentFlag.REPRESENTS_FILE;
  }

  listFile(filter?: Filter): fileAccess.FileIterator {
    return new MediaFileIterator();
  }

  scanFile(filter?: Filter): fileAccess.FileIterator {
    return new MediaFileIterator();
  }
}

class RootFileInfoImpl implements FileInfo {
  uri: string;
  relativePath: string;
  fileName: string;
  size: number;
  mtime: number;
  mimeType: string;
  mode: number;
  isRoot: boolean;
  deviceType?: number;
  private root: fileAccess.RootInfo;

  constructor(root: fileAccess.RootInfo) {
    this.root = root;
    this.uri = root.uri;
    this.relativePath = root.relativePath;
    this.fileName = root.displayName;
    this.size = 0;
    this.mtime = 0;
    this.mimeType = 'Root';
    this.mode = fileExtensionInfo.DocumentFlag.REPRESENTS_DIR;
    this.deviceType = root.deviceType;
    this.isRoot = true;
  }

  listFile(filter?: Filter): fileAccess.FileIterator {
    return this.root.listFile(filter);
  }

  scanFile(filter?: Filter): fileAccess.FileIterator {
    return this.root.scanFile(filter);
  }
}

class EmptyFileInfo implements FileInfo {
  public uri: string = '';
  public relativePath: string = '';
  public fileName: string = '';
  public size: number = 0;
  public mtime: number = 0;
  public mimeType: string = '';
  public mode: number = 0;

  listFile(filter?: Filter): fileAccess.FileIterator {
    return new MediaFileIterator();
  }

  scanFile(filter?: Filter): fileAccess.FileIterator {
    return new MediaFileIterator();
  }
}

class MediaFileIterator implements fileAccess.FileIterator {
  next(): FileIteratorResult {
    let emptyResult: FileIteratorResult = { value: new EmptyFileInfo(), done: true };
    return emptyResult;
  }
}

interface FileInfoJsonData {
  uri: string;
  fileName: string;
  mode: number;
  modeStr: string;
  size: number;
  mtime: number;
  mimeType: string;
}

interface RootInfoJsonData {
  uri: string;
  deviceType: number;
  deviceTypeStr: string;
  displayName: string;
  deviceFlags: string;
}

export class FileAccessManager {
  private static ins: FileAccessManager = new FileAccessManager();
  private helper?: fileAccess.FileAccessHelper;
  private ctx?: Context;

  /**
   * 获取 manager 实例
   * @param context
   */
  public static getIns(context?: Context): FileAccessManager {
    FileAccessManager.ins.ctx = context;
    return FileAccessManager.ins;
  }

  public static async getFileAccessAbilityInfo(): Promise<Want[]> {
    let wantInfos: Want[] = await fileAccess.getFileAccessAbilityInfo();
    MLog.log(TAG, 'getFileAccessAbilityInfo data ' + JSON.stringify(wantInfos));
    return wantInfos;
  }

  private getHelper(): fileAccess.FileAccessHelper {
    if (this.ctx) {
      this.helper = fileAccess.createFileAccessHelper(this.ctx);
    }
    if (!this.helper) {
      throw new Error('FileAccessHelper is null! ');
    }
    return this.helper;
  }

  private async convertRootIterator(iterator: fileAccess.RootIterator): Promise<fileAccess.RootInfo[]> {
    if (!iterator) {
      throw new Error('RootIterator is null');
    }
    let arr: fileAccess.RootInfo[] = [];
    let info: RootIteratorResult;
    do {
      info = iterator.next();
      if (info && !info.done) {
        arr.push(info.value);
      }
    } while (info && !info.done);

    return arr;
  }

  private async convertIterator(iterator: fileAccess.FileIterator): Promise<Array<FileInfo>> {
    if (!iterator) {
      throw new Error('FileIterator is null');
    }
    let arr: FileInfo[] = [];
    let info: FileIteratorResult;
    do {
      info = iterator.next();
      if (info && !info.done) {
        arr.push(info.value);
      }
    } while (info && !info.done);

    return arr;
  }

  private async listIteratorRoot(): Promise<fileAccess.RootInfo[]> {
    let roots: fileAccess.RootIterator = await this.getHelper().getRoots();
    MLog.print(TAG, `getRoots:${roots}`);
    return this.convertRootIterator(roots);
  }

  private async listIterator(iterator: fileAccess.FileIterator): Promise<Array<FileInfo>> {
    return this.convertIterator(iterator);
  }

  /**
   * 获取根目录列表
   */
  public async getRoots(): Promise<fileAccess.RootInfo[]> {
    let list: fileAccess.RootInfo[] = await this.listIteratorRoot();
    return list;
  }

  public async getRootLocal(): Promise<fileAccess.RootInfo | undefined> {
    return this.getRoots().then((roots: Array<fileAccess.RootInfo>) => {
      return roots.find(it => FileAccessManager.isLocalDevice(it.deviceType));
    });
  }

  public async getUsbDataAsFile(): Promise<RootData> {
    return this.getRoots().then((roots: Array<fileAccess.RootInfo>) => {
      try {
        let list: fileAccess.RootInfo[] = roots.filter(it => FileAccessManager.isUsbDevice(it.deviceType));
        if (list && list.length > 0) {
          let beans: FileBean[] = list.map(it =>
          new FileBean(it.uri, FileAccessManager.convertRoot(it)).updateDirType());
          let result: RootData = { root: FileAccessManager.convertRoot(list[0]), list: beans };
          return result;
        }
      } catch (err) {
        MLog.error(TAG, 'getUsbDataAsFile error:' + err);
      }
      let emptyList: FileBean[] = [];
      let emptyResult: RootData = { root: undefined, list: emptyList };
      return emptyResult;
    });
  }

  public async getRootDataAsFile(): Promise<RootData> {
    return this.getRoots().then((roots: Array<fileAccess.RootInfo>) => {
      try {
        MLog.print(TAG, `roots:${roots.map(it => it.displayName).toString()}`);
        let localRoot: fileAccess.RootInfo | undefined = roots.find(it =>
        FileAccessManager.isLocalDevice(it.deviceType));
        if (localRoot) {
          const root: fileAccess.RootInfo = localRoot;
          return this.getList(root).then((list: Array<FileInfo>) => {
            let beans: FileBean[] = list.map((it: FileInfo) => {
              let bean: FileBean = new FileBean(it.uri, it).updateDirType();
              return bean;
            });
            let result: RootData = { root: FileAccessManager.convertRoot(root), list: beans };
            return result;
          });
        } else {
          MLog.warn(TAG, `not find local root! roots:${roots.map(it =>
          FileAccessManager.rootInfoToString(it))}`);
        }
      } catch (err) {
        MLog.error(TAG, 'getRootDataAsFile error:' + err);
      }
      let emptyList: FileBean[] = [];
      let emptyResult: RootData = { root: undefined, list: emptyList };
      return emptyResult;
    });
  }

  public async getListFormUri(uri: string): Promise<Array<FileInfo>> {
    return this.getFileInfoFromUri(uri).then(info => {
      MLog.print(TAG, `getListFormUri getFileInfoFromUri uri:${uri} info:${info.uri}`);
      return this.getList(info);
    });
  }

  /**
   * 获取某一个目录的文件（夹）列表
   */
  public async getList(rootInfo: fileAccess.RootInfo | FileInfo, searchText?: string): Promise<Array<FileInfo>> {
    if (searchText && !Tools.isEmpty(searchText)) {
      let filter: Filter = {
        displayName: [`*${searchText}*`]
      };
      return this.listIterator(rootInfo.scanFile(filter));
    } else {
      MLog.print(TAG, `rootInfo :${rootInfo.uri} --> ${rootInfo.relativePath}`);
      return this.listIterator(rootInfo.listFile());
    }
  }

  public async getDocs(rootInfo: fileAccess.RootInfo | FileInfo): Promise<Array<FileInfo>> {
    let filter: Filter = {
      suffix: SUFFIX_TEXT
    };
    return this.listIterator(rootInfo.scanFile(filter));
  }

  public async getVideos(rootInfo: fileAccess.RootInfo | FileInfo): Promise<Array<FileInfo>> {
    let filter: Filter = {
      suffix: SUFFIX_VIDEO
    };
    return this.listIterator(rootInfo.scanFile(filter));
  }

  public async getImages(rootInfo: fileAccess.RootInfo | FileInfo): Promise<Array<FileInfo>> {
    let filter: Filter = {
      suffix: SUFFIX_IMAGE
    };
    return this.listIterator(rootInfo.scanFile(filter));
  }

  public async getAudios(rootInfo: fileAccess.RootInfo | FileInfo): Promise<Array<FileInfo>> {
    let filter: Filter = {
      suffix: SUFFIX_AUDIO
    };
    return this.listIterator(rootInfo.scanFile(filter));
  }

  public async access(uri: string): Promise<boolean> {
    try {
      return this.getHelper().access(uri).then(assess => {
        MLog.print(TAG, `assess :${uri} --> ${assess}`);
        return assess;
      });
    } catch (err) {
      MLog.error(TAG, `asses ${uri} error:` + err);
      throw new Error(`access failed: ${JSON.stringify(err)}`);
    }
    return false;
  }

  public async move(sourceFile: FileBean[], destFile: string, callback?: Function): Promise<void> {
    try {
      for (let i: number = 0; i < sourceFile.length; i++) {
        let fileUri: string = await this.getHelper().move(sourceFile[i].getPath(), destFile);
      }
      if (callback) {
        callback();
      }
      MLog.info(TAG, 'move success !!!');
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      MLog.error(TAG, 'move failed, errCode:' + error.code + ', errMessage:' + error.message);
      throw new Error(`move failed: ${error.message}`);
    }
  }

  public async moveOne(srcUri: string, destFile: string): Promise<number> {
    try {
      return this.getHelper().move(srcUri, destFile).then((result: string): number => {
        MLog.info(TAG, `moveOne scuccess! result:${result} srcUri:${srcUri} destFile:${destFile}`);
        return 0;
      })
        .catch((err: BusinessError): number => {
          MLog.printError(TAG, `moveOne failed uri:${srcUri} destFile:${destFile}`, err);
          return err?.code ?? -1;
        });
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      MLog.error(TAG, 'move failed, errCode:' + error.code + ', errMessage:' + error.message);
      throw new Error(`moveOne failed: ${error.message}`);
    }
  }

  public async copy(sourceFile: FileBean[], destFile: string, force?: boolean): Promise<number[]> {
    MLog.info(TAG, 'copy start ');
    try {
      let taskArr: Promise<number>[] = sourceFile.map(it => this.copyOne(it.getPath(), destFile, force));
      return runTask(taskArr).then(results => {
        return results;
      });
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      MLog.error(TAG, 'copy failed, errCode:' + error.code + ', errMessage:' + error.message);
      throw new Error(`copy failed: ${error.message}`);
    }
  }

  public async copyOne(srcUri: string, destUri: string, force?: boolean): Promise<number> {
    try {
      MLog.info(TAG, `copyOne srcUri:${srcUri} destUri:${destUri} force:${force}`);
      return this.getHelper().copy(srcUri, destUri, force)
        .then((result: fileAccess.CopyResult[]) => {
          if (result.length === 0) {
            return 0;
          } else {
            for (let it of result) {
              MLog.warn(TAG,
                `sourceUri:${it.sourceUri} destUri:${it.destUri} errCode:${it.errCode} errMsg:${it.errMsg}`);
              if (it.errCode > 0) {
                return it.errCode;
              }
            }
          }
          return 0;
        });
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      MLog.error(TAG, 'copy failed, errCode:' + error.code + ', errMessage:' + error.message);
      throw new Error(`copyOne failed: ${error.message}`);
    }
  }

  public async createDir(parentUri: string, name: string): Promise<string> {
    let isAccess: boolean = await this.access(parentUri);
    if (isAccess) {
      return await this.getHelper().mkDir(parentUri, name);
    } else {
      return '';
    }
  }

  public async deleteOne(name: string, uri: string, isMediaFile: boolean = false): Promise<number> {
    MLog.info(TAG, `delete name:${name} uri:${uri} isMedia:${isMediaFile}`);
    if (isMediaFile) {
      return UserFileManager.getIns().delete(uri)
        .then(() => {
          completeDeleteOne(name);
          return 0;
        }).catch((err: BusinessError) => {
          MLog.printError(TAG, `delete error uri:${uri} `, err);
          throw new Error(`deleteOne media failed: ${err.message}`);
        });
    } else {
      return this.getHelper().delete(uri)
        .then((num: number) => {
          if (num === 0) {
            completeDeleteOne(name);
          }
          return num;
        }).catch((err: BusinessError) => {
          MLog.printError(TAG, `delete error uri:${uri} `, err);
          throw new Error(`deleteOne failed: ${err.message}`);
        });
    }
  }

  public async renameOne(uri: string, newName: string, isMediaFile: boolean = false): Promise<void> {
    MLog.info(TAG, `renameOne newName:${newName} uri:${uri}, isMediaFile${isMediaFile}`);
    if (isMediaFile) {
      if (!this.ctx) {
        MLog.error(TAG, 'renameOne failed: context is undefined');
        return;
      }
      const lastIndex: number = uri.lastIndexOf('/');
      const displayName: string = lastIndex > -1 && lastIndex < uri.length - 1 ? uri.slice(lastIndex + 1) : '';
      const accessHelper: photoAccessHelper.PhotoAccessHelper = photoAccessHelper.getPhotoAccessHelper(this.ctx);
      let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.DISPLAY_NAME, displayName);
      let fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [],
        predicates: predicates
      };
      let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> =
        await accessHelper.getAssets(fetchOptions);
      let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest =
        new photoAccessHelper.MediaAssetChangeRequest(photoAsset);
      assetChangeRequest.setTitle(newName);
      accessHelper.applyChanges(assetChangeRequest).then(() => {
        console.info('setTitle success');
      }).catch((error: BusinessError) => {
        console.error(`apply setTitle failed with error: ${error.code}, ${error.message}`);
      });
    } else {
      this.getHelper().rename(uri, newName);
    }
  }

  public async delete(sourceFile: FileBean[]): Promise<number> {
    try {
      MLog.info(TAG, `delete sourceFile length:${sourceFile.length}`);
      if (sourceFile.length === 0) {
        return 0;
      }
      let taskArr: Promise<number>[] = sourceFile.map(it =>
      this.deleteOne(it.name, it.getPath(), it.isMediaFile()));
      return runTask(taskArr).then((results: number[]) => {
        let delNum: number = 0;
        results.forEach((result: number, index: number) => {
          if (result === 0) {
            delNum += 1;
          }
        });
        return delNum;
      });
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      MLog.error(TAG, 'delete failed, errCode:' + error.code + ', errMessage:' + error.message);
      clearTrash();
      throw new Error(`delete failed: ${error.message}`);
    }
  }

  public async rename(sourceFile: FileBean[], newName: string): Promise<void> {
    try {
      let name: string = newName;
      let pot: string | undefined = undefined;
      if (newName.indexOf('.') > 0) {
        name = newName.substring(0, newName.lastIndexOf('.'));
        pot = newName.substring(newName.lastIndexOf('.') + 1);
      }
      let taskArr: Promise<void>[] = sourceFile.map((it: FileBean, index: number) => {
        return this.renameOne(it.getPath(), `${name}${index > 0 ? '-' + index : ''}${pot ? '.' + pot : ''}`,
          it.isMediaFile())
          .catch((err: BusinessError) => MLog.printError(TAG, `renameOne error uri:${it.getPath()} `, err));
      });
      return runTask(taskArr).then(results => {
        results.forEach((result, index) => {
          MLog.info(TAG, `index:${index} result:${result}`);
        });
      });
    } catch (err) {
      let error: BusinessError = err as BusinessError;
      MLog.error(TAG, 'delete failed, errCode:' + error.code + ', errMessage:' + error.message);
    }
  }

  public async createFile(parentUri: string, displayName: string): Promise<string> {
    MLog.log(TAG, 'createFile >>>>>>> ' + parentUri + ' >> ' + displayName);
    let fileUri: string = '';
    try {
      let isAccess: boolean = await this.access(parentUri);
      if (!isAccess) {
        throw new Error(`access uri:${parentUri} is false`);
      }

      fileUri = await this.getHelper().createFile(parentUri, displayName);
      if (!fileUri) {
        MLog.error(TAG, 'createFile return undefined object');
        return '';
      }
      MLog.log(TAG, 'createFile sucess， fileUri: ' + JSON.stringify(fileUri));
      return fileUri;
    } catch (error) {
      MLog.error(TAG, `createFile uri:${parentUri} name:${displayName} failed, error ` + error);
      return '';
    }
  }

  public async isDir(uri: string): Promise<boolean> {
    return this.openFile(uri).then((fd: number) => {
      return FileIoManager.isDir(fd).then((isDir: boolean) => {
        FileIoManager.close(fd);
        return isDir;
      });
    });
  }

  public async openFile(uri: string, flags: fileAccess.OPENFLAGS = fileAccess.OPENFLAGS.WRITE_READ): Promise<number> {
    try {
      MLog.print(TAG, `>>>>>> openFile:${uri} `);
      this.getHelper().openFile(uri, flags).then(fd => {
        MLog.print(TAG, `fd:${fd} `);
        return fd;
      });
    } catch (error) {
      MLog.error(TAG, 'openFile failed, error ' + error);
      return -1;
    }
    return -1;
  }

  public static fileInfoToString(info: FileInfo): string {
    let jsonData: FileInfoJsonData = {
      uri: info.uri,
      fileName: info.fileName,
      mode: info.mode,
      modeStr: FileAccessManager.fileModeToString(info.mode),
      size: info.size,
      mtime: info.mtime,
      mimeType: info.mimeType,
    };
    return JSON.stringify(jsonData);
  }

  public static convertRoot(root: fileAccess.RootInfo): FileInfo {
    return new RootFileInfoImpl(root);
  }

  public static rootInfoToString(info: fileAccess.RootInfo): string {
    let jsonData: RootInfoJsonData = {
      uri: info.uri,
      deviceType: info.deviceType,
      deviceTypeStr: FileAccessManager.deviceTypeToString(info.deviceType),
      displayName: info.displayName,
      deviceFlags: FileAccessManager.deviceFlagToString(info.deviceFlags)
    };
    return JSON.stringify(jsonData);
  }

  private static createMediaFileInfo(fileAsset: userFileManager.FileAsset): FileInfo {
    return new MediaFileInfoImpl(fileAsset);
  }

  public static fileModeToString(mod: number): string {
    let str: string = '';
    if (mod & fileExtensionInfo.DocumentFlag.REPRESENTS_FILE) {
      str = 'FILE';
    } else if (mod & fileExtensionInfo.DocumentFlag.REPRESENTS_DIR) {
      str = 'DIR';
    }
    if (mod & fileExtensionInfo.DocumentFlag.SUPPORTS_READ) {
      str += str ? '|' : '';
      str += 'READ';
    }
    if (mod & fileExtensionInfo.DocumentFlag.SUPPORTS_WRITE) {
      str += str ? '|' : '';
      str += 'WRITE';
    }

    if (!str) {
      return 'Unknown';
    }

    return str;
  }

  public static deviceFlagToString(flag: number): string {
    let str: string = '';
    if ((flag & fileExtensionInfo.DeviceFlag.SUPPORTS_READ) > 0) {
      str = 'READ';
    }
    if (flag & fileExtensionInfo.DeviceFlag.SUPPORTS_WRITE) {
      str += str ? '|' : '';
      str += 'WRITE';
    }
    if (!str) {
      return 'Unknown';
    }

    return str;
  }

  public static isLocalDevice(type: number): boolean {
    return type === fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK;
  }

  public static isUsbDevice(type: number): boolean {
    return type === fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB;
  }

  public static deviceTypeToString(type: number): string {
    switch (type) {
      case fileExtensionInfo.DeviceType.DEVICE_LOCAL_DISK:
        return 'Local';
      case fileExtensionInfo.DeviceType.DEVICE_SHARED_DISK:
        return 'SHARED_DISK';
      case fileExtensionInfo.DeviceType.DEVICE_SHARED_TERMINAL:
        return 'SHARED_TERMINAL';
      case fileExtensionInfo.DeviceType.DEVICE_NETWORK_NEIGHBORHOODS:
        return 'NETWORK_NEIGHBORHOODS';
      case fileExtensionInfo.DeviceType.DEVICE_EXTERNAL_USB:
        return 'DEVICE_EXTERNAL_USB';
      default:
        return 'Other';
    }
  }

  public async getFileInfoFromUri(uri: string): Promise<FileInfo> {
    return await this.getHelper().getFileInfoFromUri(uri);
  }

  public async getFileAsset(mediaType: MediaType): Promise<FileBean[]> {
    MLog.print(TAG, `FileAccessManager getFileAsset>>> ${mediaType}`);
    let root: fileAccess.RootInfo | undefined = await this.getRootLocal();
    if (!root) {
      MLog.error(TAG, 'getRootLocal returned undefined');
      return [];
    }
    let fileInfo: FileInfo[] = [];
    let fileBeans: FileBean[] = [];
    switch (mediaType) {
      case MediaType.VIDEO:
        fileInfo = await this.getVideos(root);
        break;
      case MediaType.IMAGE:
        fileInfo = await this.getImages(root);
        break;
      case MediaType.AUDIO:
        fileInfo = await this.getAudios(root);
        break;
      default:
        break;
    }
    for (let it of fileInfo) {
      let fileBean: FileBean = new FileBean(it.uri, it).updateDirType();
      fileBeans.push(fileBean);
    }
    return fileBeans;
  }

  public async getMediaFileAsset(mediaType: MediaType): Promise<FileBean[]> {
    MLog.print(TAG, `getMediaFileAsset mediaType:${mediaType}`);
    let fileAssets: userFileManager.FileAsset[] = [];
    switch (mediaType) {
      case MediaType.VIDEO:
        fileAssets = await UserFileManager.getIns(this.ctx).getVideoOrImage();
        fileAssets = fileAssets.filter(fileAsset => fileAsset.fileType === userFileManager.FileType.VIDEO);
        break;
      case MediaType.IMAGE:
        fileAssets = await UserFileManager.getIns(this.ctx).getVideoOrImage();
        fileAssets = fileAssets.filter(fileAsset => fileAsset.fileType === userFileManager.FileType.IMAGE);
        break;
      case MediaType.AUDIO:
        fileAssets = await UserFileManager.getIns(this.ctx).getAudio();
        break;
      default:
        break;
    }
    MLog.print(TAG, `getMediaFileAsset length:` + fileAssets.length);
    let fileBeans: FileBean[] = [];
    for (let fileAsset of fileAssets) {
      MLog.print(TAG, `media fileAssets uri:${fileAsset.uri} fileType:${fileAsset.fileType}`);
      let fileBean: FileBean = new FileBean(fileAsset.uri,
        FileAccessManager.createMediaFileInfo(fileAsset)
      ).setFileType(fileAsset.fileType);
      MLog.print(TAG, `fileAssetInfo fileBean: ${JSON.stringify(fileBean)}}`);
      fileBeans.push(fileBean);
    }
    return fileBeans;
  }
}
