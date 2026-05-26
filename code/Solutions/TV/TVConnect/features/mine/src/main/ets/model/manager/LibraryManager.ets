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

import { BusinessError } from '@ohos.base';
import fs from '@ohos.file.fs';
import { UpdateLibraryCallback } from '../callback/UpdateLibraryCallback';
import zlib from '@ohos.zlib';

/*
 * 库管理
 * */
export class LibraryManager {
  public static readonly LIBRARY_PATH = '/library';
  public static readonly LIBRARY_DEVICE_PATH = LibraryManager.LIBRARY_PATH + '/device';
  public static readonly LIBRARY_SCENE_PATH = LibraryManager.LIBRARY_PATH + '/scene';
  public static readonly LIBRARY_TMP_PATH = '/libraryTmp';
  public static readonly LIBRARY_TMP_DEVICE_PATH = LibraryManager.LIBRARY_TMP_PATH + '/deviceTmp';
  public static readonly LIBRARY_TMP_SCENE_PATH = LibraryManager.LIBRARY_TMP_PATH + '/sceneTmp';
  public static readonly LIBRARY_TMP_PRE_PATH = LibraryManager.LIBRARY_TMP_PATH + '/preLibrary';
  public static readonly LIBRARY_TMP_PRE_DEVICE_PATH = LibraryManager.LIBRARY_TMP_PRE_PATH + '/devicelibrary';
  public static readonly LIBRARY_TMP_PRE_SCENE_PATH = LibraryManager.LIBRARY_TMP_PRE_PATH + '/scenelibrary';
  public static readonly LIBRARY_TMP_PRE_DEVICE_NAME = 'device_info_pre.zip';
  public static readonly LIBRARY_TMP_PRE_SCENE_NAME = 'scene_info_pre.zip';
  public static readonly LIBRARY_TMP_ZIP_PATH = LibraryManager.LIBRARY_TMP_PATH + '/zipTmp';
  public static readonly LIBRARY_TMP_ZIP_DEVICE_PATH = LibraryManager.LIBRARY_TMP_ZIP_PATH + '/devicelibrary';
  public static readonly LIBRARY_TMP_ZIP_SCENE_PATH = LibraryManager.LIBRARY_TMP_ZIP_PATH + '/scenelibrary';
  public static readonly LIBRARY_TMP_ZIP_DEVICE_NAME = 'device_info_tmp.zip';
  public static readonly LIBRARY_TMP_ZIP_SCENE_NAME = 'scene_info_tmp.zip';
  public static readonly LIBRARY_TMP_DOWNLOAD_PATH = LibraryManager.LIBRARY_TMP_PATH + '/downloadTmp';
  public static readonly LIBRARY_TMP_DOWNLOAD_DEVICE_PATH = LibraryManager.LIBRARY_TMP_DOWNLOAD_PATH + '/devicelibrary';
  public static readonly LIBRARY_TMP_DOWNLOAD_SCENE_PATH = LibraryManager.LIBRARY_TMP_DOWNLOAD_PATH + '/scenelibrary';
  public static readonly LIBRARY_TMP_DOWNLOAD_DEVICE_NAME = 'device_info_download.zip';
  public static readonly LIBRARY_TMP_DOWNLOAD_SCENE_NAME = 'scene_info_download.zip';
  public static readonly RESOURCE_DEVICE_PATH = '/devicelibrary';
  public static readonly RESOURCE_SCENE_PATH = '/scenelibrary';
  public static readonly RESOURCE_DEVICE_NAME = 'device_info.zip';
  public static readonly RESOURCE_SCENE_NAME = 'scene_info.zip';
  public static readonly VERSION_FILE_NAME = 'version.xml';
  public static readonly DEVICE_INFO_FILE_NAME = 'main_devices_information.json';
  public static readonly DEVICE_ASSETS_PATH = '/assets';
  public static readonly DEVICE_ASSETS_DEVICEICON_PATH = '/DeviceIcon';
  public static readonly SCENE_INFO_FILE_NAME = 'scenes_library.json';
  public static resourceRootPath: string = '';
  public static workspaceRootPath: string = '';
  public static readonly PRESET_DEVICE_LIBRARY_VERSION = '1.0.0.2';
  public static readonly PRESET_SCENE_LIBRARY_VERSION = '1.0.0.2';
  public currentVersionCode: string = '';
  private fileImportListener: Array<() => void> = [];

  constructor() {
    this.getLibraryVersion();
  }

  /**
   * 获取工作空间路径和资源路径,创建目录
   */
  public static init() {
    let context = getContext();
    LibraryManager.resourceRootPath = context.resourceDir;
    LibraryManager.workspaceRootPath = context.filesDir;
    LibraryManager.constructWorkDir();
  }

  /**
   * 创建目录
   */
  public static constructWorkDir() {
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_DEVICE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_SCENE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_DEVICE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_SCENE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_PATH);
    LibraryManager.mkLibraryDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_PATH);
  }

  private static mkLibraryDir(path: string) {
    try {
      fs.mkdirSync(path);
    } catch (errData) {
      let code = (errData as BusinessError).code;
      let message = (errData as BusinessError).message;
      console.error(`resetTmpPath errData is errCode:${code}  message:${message}}`);
    }
  }

  /**
   * 查询库当前版本号
   */
  public async getLibraryVersion() {
  }

  /**
   * 注册库文件更新回监听
   */
  registerUpdateLibraryListener(callback: () => void) {
    this.fileImportListener.push(callback);
  }

  /**
   * 库文件更新回调
   */
  onLibraryUpdate() {
    this.getLibraryVersion();
    this.fileImportListener.forEach((callback) => {
      callback();
    });
  }

  /**
   * 子类实现，库文件导入，调用copyLibraryToTmpDir
   */
  public importLibrary(path: string, callback?: UpdateLibraryCallback) {
  }

  /**
   * 向云同步库
   */
  public SyncLibrary(callback?: UpdateLibraryCallback) {
    this.checkLibraryVersion(callback);
  }

  /**
   * 子类实现，判断是否要加载预置库文件，调用initLibrary
   */
  public async loadPresetLibrary() {
  }

  /**
   * 子类实现，初始化库文件，判断是否导入过设备库/场景库，没有则导入预置库，有则读取数据
   */
  protected initLibrary() {
  }

  /**
   * 子类实现，如果获取成功且需要更新库，调用onCheckLibraryVersionEnd以及onCheckVersionEnd，获取失败也调用onCheckVersionEnd
   */
  protected async checkLibraryVersion(callback?: UpdateLibraryCallback) {
  }

  /**
   * 获取到了最新的库版本信息且需要更新，下载
   */
  protected onCheckLibraryVersionEnd(url: string, callback?: UpdateLibraryCallback) {
    this.downloadLibrary(url, callback);
  }

  /**
   * 子类实现，下载到/zipTmp/scenelibrary,下载过程中展示进度，如果下载失败调用onDownLoadEnd，如果下载成功调用onDownLoadEnd以及onDownloadLibraryEnd
   */
  protected downloadLibrary(url: string, callback?: UpdateLibraryCallback) {
  }

  /**
   * 子类实现，调用verifyLibrary
   */
  protected onDownloadLibraryEnd() {
  }

  /**
   * 将库压缩包拷贝到/libraryTmp/zipTmp/xxlibrary下
   * destPath=xxx/libraryTmp/zipTmp/xxlibrary/xx_info_tmp.zip
   */
  protected copyLibraryToTmpDir(resPath: string, destPath: string,
    callback?: UpdateLibraryCallback) {
    if (resPath != undefined) {
      try { //将压缩包拷贝到/libraryTmp/zipTmp/xxlibrary下
        let copyFile = fs.openSync(resPath, fs.OpenMode.READ_ONLY);
        fs.copyFileSync(copyFile.fd, destPath);
        fs.closeSync(copyFile);
        this.onCopyLibraryToTmpDirEnd(callback);
      } catch (errData) {
        this.printErrData(errData);
        callback?.onFailure(UpdateLibraryCode.FAIL);
      }
    }
  }

  /**
   * 子类实现该方法，内部调用unzipLibrary，传入需要解压的目的地址
   */
  protected onCopyLibraryToTmpDirEnd(callback?: UpdateLibraryCallback) {
  }

  /**
   * 校验md5:目前假实现，默认校验通过
   */
  protected verifyLibrary(zipFilePath: string, callback?: UpdateLibraryCallback) {
    let resTag: boolean = true;
    if (resTag) {
      callback?.onVerifyEnd(UpdateLibraryCode.VERIFY_END_SUCC);
      this.onVerifyLibraryEnd(zipFilePath, callback);
    } else {
      callback?.onVerifyEnd(UpdateLibraryCode.VERIFY_END_FAIL);
    }
  }

  /**
   * 子类实现该方法，内部调用unzipLibrary，传入需要解压的目的地址
   */
  protected onVerifyLibraryEnd(zipFilePath: string, callback?: UpdateLibraryCallback) {
  }

  /**
   * 将库压缩包解压到/libraryTmp/xxTmp下
   */
  protected unzipLibrary(resPath: string, destPath: string, callback?: UpdateLibraryCallback) {
    let _this = this;
    let options: zlib.Options = { level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION };
    try {
      zlib.decompressFile(resPath, destPath, options, (errData: BusinessError) => {
        if (errData !== null) {
          callback?.onParseEnd(UpdateLibraryCode.PARSE_END_CHECK_FAIL);
          console.error('unzipLibrary errData !== null');
          _this.printErrData(errData);
        } else {
          console.error('unzipLibrary else');
          _this.onUnzipLibraryEnd(callback);
        }
      });
    } catch (errData) {
      this.printErrData(errData);
      callback?.onParseEnd(UpdateLibraryCode.PARSE_END_CHECK_FAIL);
    }
  }

  /**
   * 库文件解压到了临时目录下，开始校验库文件格式是否合法
   */
  protected onUnzipLibraryEnd(callback?: UpdateLibraryCallback) {
    this.checkLibrary(callback);
  }

  /**
   * 子类实现检查库文件的规则：是否有xml文件，是否有json文件...,如果检查通过继续往下走，调用onCheckLibraryEnd
   */
  protected checkLibrary(callback?: UpdateLibraryCallback) {
  }

  /**
   * 检查结束，开始解析库文件
   */
  protected onCheckLibraryEnd(callback?: UpdateLibraryCallback) {
    this.parseLibrary(callback);
  }

  /**
   * 子类实现解析库文件（包括入库，将图片拷贝到正式目录下，更新库版本信息），如果解析通过 调用this.onLibraryUpdate(),继续往下走，onParseLibraryEnd
   * 如果解析不通过，且已经入了数据库等覆盖了当前数据库，应调用revertToPreVersion
   */
  protected parseLibrary(callback?: UpdateLibraryCallback) {

  }

  /**
   * 子类实现，解析结束，删除一些临时文件
   */
  protected onParseLibraryEnd(callback?: UpdateLibraryCallback) { //设备：this.handleTempFiles(callback)
  }

  /**
   * 将libraryTmp/deviceTmp下的内容拷贝到library/device下
   * 删除libraryTmp/deviceTmp下的内容
   * 将libraryTmp/zipTmp/devicelibrary下的压缩包拷贝到libraryTmp/preLibrary/devicelibrary并改名字
   * 删除libraryTmp/zipTmp/devicelibrary下的压缩包
   * 删除libraryTmp/downloadTmp/devicelibrary下的压缩包
   */
  protected handleTempFiles(libPath: string, libTmpPath: string, preLibPath: string, preLibName: string,
    zipTmpLibPath: string, zipTmpLibName: string, downloadTmpLibPath: string, downloadTmpLibName: string,
    callback?: UpdateLibraryCallback) {
    this.resetDir(libPath);
    this.resetDir(libTmpPath);
    try {
      fs.copyFileSync(zipTmpLibPath + '/' + zipTmpLibName, preLibPath + '/' + preLibName);
    } catch (errData) {
      this.printErrData(errData);
    }
    this.resetDir(zipTmpLibPath);
    this.resetDir(downloadTmpLibPath);
    this.onHandleTempFilesEnd(callback);
  }

  protected onHandleTempFilesEnd(callback?: UpdateLibraryCallback) {
    callback?.onSuccess();
  }

  /**
   * 回滚上一个版本的库(注意不能陷入死循环，一直回滚的同一个上一个版本)
   * resPath：/preLibrary//devicelibrary/device_info_pre.zip
   * destPath：/zipTmp/devicelibrary/device_info_tmp.zip
   */
  protected revertToPreVersion(resPath: string, destPath: string, callback?: UpdateLibraryCallback) {
    let _this = this;
    let revertCb: UpdateLibraryCallback = {
      onSuccess: () => {
        callback?.onRevertEnd(UpdateLibraryCode.REVERT_PRE_END_SUCC);
      },
      onFailure: () => {
        callback?.onRevertEnd(UpdateLibraryCode.REVERT_PRE_END_FAIL);
      },
      onStart: () => {
      },
      onCheckVersionEnd: (code?: number, data?: object, msg?: string) => {
      },
      onDownLoading: (receivedSize: number, totalSize: number) => {
      },
      onDownLoadEnd: (code?: number, data?: object, msg?: string) => {
      },
      onVerifyEnd: (code?: number, data?: object, msg?: string) => {
        if (code == UpdateLibraryCode.VERIFY_END_FAIL) {
          callback?.onRevertEnd(UpdateLibraryCode.REVERT_PRE_END_FAIL);
        }
      },
      onParseEnd: (code?: number, data?: object, msg?: string) => {
        if (code != UpdateLibraryCode.PARSE_END_SUCC) {
          callback?.onRevertEnd(UpdateLibraryCode.REVERT_PRE_END_FAIL);
        }
      },
      onRevertEnd: (code?: number, data?: object, msg?: string) => {
        if (code == UpdateLibraryCode.REVERT_PRE_END_FAIL) {
          callback?.onRevertEnd(UpdateLibraryCode.REVERT_PRE_END_FAIL);
        }
      }
    };
    this.copyLibraryToTmpDir(resPath, destPath, revertCb);
  }

  /*protected onRevertToPreVersionEnd(callback?: UpdateLibraryCallback) { }*/

  /**
   * 清空目录
   */
  protected resetDir(path: string) {
    try {
      fs.rmdirSync(path);
    } catch (errData) {
      this.printErrData(errData);
    }
    try {
      fs.mkdirSync(path);
    } catch (errData) {
      this.printErrData(errData);
    }
  }

  protected printErrData(errData: BusinessError) {
    let code = (errData as BusinessError).code;
    let message = (errData as BusinessError).message;
    console.error(`library errData is errCode:${code}  message:${message}}`);
  }

  /**
   * 比较版本字符串
   */
  protected isNeedUpdate(currentVersion: string, compareVersion: string): boolean {
    let currentRes = currentVersion.split('.');
    let compareRes = compareVersion.split('.');
    for (let i = 0; i < compareRes.length; i++) {
      if (currentRes[i] < compareRes[i]) {
        return true;
      }
    }
    return false;
  }
}


/**
 * 更新库流程状态码
 */
export enum UpdateLibraryCode {
  SUCCESS = 0, FAIL, CHECK_VERSION_END_FAIL, //获取最新版本信息失败
  CHECK_VERSION_END_SUCC_NO_UPDATE, //获取最新版本信息成功-不需要更新
  CHECK_VERSION_END_SUCC_NEED_UPDATE, //获取最新版本信息成功-需要更新，进入下载阶段
  DOWNLOAD_END_FAIL, //下载失败
  DOWNLOAD_END_SUCC, //下载成功，进入校验阶段
  VERIFY_END_FAIL, //md5校验失败
  VERIFY_END_SUCC, //md5校验成功，进入检查文件是否合法中
  PARSE_END_CHECK_FAIL,
  PARSE_END_XML_FAIL,
  PARSE_END_SUCC,
  PARSE_END_SAVE_FAIL,
  PARSE_END_HANDLE_TEMP_FAIL,
  REVERT_PRE_END_FAIL,
  REVERT_PRE_END_SUCC
}