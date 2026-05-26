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

import { UpdateLibraryCallback } from '../callback/UpdateLibraryCallback';
import { LibraryManager, UpdateLibraryCode } from './LibraryManager';
import fs, { ReadTextOptions } from '@ohos.file.fs';
import { ConnectDatabaseHelperImpl, DeviceLibraryDao, LibraryDevice, PreferencesHelper } from '@ohos/common';
import { StatusCode, SyncCloudApi } from '../cloud/SyncCloudApi';
import { UpgradeDeviceLibraryRequest } from '../cloud/Request';
import { BaseCallback } from '../callback/BaseCallback';
import { CommonResponse, UpgradeDeviceLibrarySuccData } from '../cloud/Response';
import bundleManager from '@ohos.bundle.bundleManager';
import { DownloadCallback } from '../callback/DownloadCallback';
import prompt from '@ohos.prompt';

/*
 * 设备库管理
 * */
export class DeviceLibraryManager extends LibraryManager {
  public static readonly DEVICE_LIBRARY_VERSION_KEY = 'device_library_version';
  public static readonly DEVICE_LIBRARY_DESCRIPTION_KEY = 'device_library_description';

  public async getLibraryVersion() {
    this.currentVersionCode =
      (await PreferencesHelper.get(DeviceLibraryManager.DEVICE_LIBRARY_VERSION_KEY, '')) as string;
  }

  public importLibrary(path: string, callback?: UpdateLibraryCallback) {
    this.copyLibraryToTmpDir(path, LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH + '/' +
    LibraryManager.LIBRARY_TMP_ZIP_DEVICE_NAME, callback);
  }

  public async loadPresetLibrary() {
    let version: string = (await PreferencesHelper.get(DeviceLibraryManager.DEVICE_LIBRARY_VERSION_KEY, '')) as string;
    if (version == '' || this.isNeedUpdate(version, LibraryManager.PRESET_DEVICE_LIBRARY_VERSION)) {
      this.initLibrary();
      prompt.showToast({
        message: getContext().resourceManager.getStringSync($r('app.string.init_preset_device_library')),
        duration: 2000
      });
    }
  }

  protected initLibrary() {
    this.copyLibraryToTmpDir(LibraryManager.resourceRootPath + LibraryManager.RESOURCE_DEVICE_PATH + '/' +
    LibraryManager.RESOURCE_DEVICE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH + '/' +
      LibraryManager.LIBRARY_TMP_ZIP_DEVICE_NAME);
  }

  protected async checkLibraryVersion(callback?: UpdateLibraryCallback) { //调用云api
    let request: UpgradeDeviceLibraryRequest = new UpgradeDeviceLibraryRequest();
    request.devlibVersion = '';
    request.appVersion = '';
    request.description = '';
    let version: string = (await PreferencesHelper.get(DeviceLibraryManager.DEVICE_LIBRARY_VERSION_KEY, '')) as string;
    let cloudCallback: BaseCallback = {
      onResult: (code: number, data: Object, msg?: string) => {
        if (code == StatusCode.SUCCESS) {
          let response: CommonResponse = data as CommonResponse; // 检查版本号是否需要更新
          if (response.code == 200) {
            console.info('deviceLibraryManager get version succ');
            let rspData = response.data as UpgradeDeviceLibrarySuccData;
            callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_SUCC_NEED_UPDATE, rspData);
            this.onCheckLibraryVersionEnd(rspData.url, callback);
          } else if (response.code == 1001) {
            console.info('deviceLibraryManager get version succ no update');
            callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_SUCC_NO_UPDATE);
          } else {
            console.info('deviceLibraryManager get version fail other code');
            callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_FAIL);
          }
        } else {
          console.info('deviceLibraryManager get version fail request fail');
          callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_FAIL);
        }
      }
    };
    request.devlibVersion = version;
    let desc: string = (await PreferencesHelper.get(DeviceLibraryManager.DEVICE_LIBRARY_DESCRIPTION_KEY, '')) as string;
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
      request.appVersion = data.versionName;
      SyncCloudApi.checkDeviceLibraryVersionInfo(request, cloudCallback);
    });
  }

  protected downloadLibrary(url: string, callback?: UpdateLibraryCallback) {
    let downloadCallback: DownloadCallback = {
      onSuccess: () => {
        console.info('deviceLibraryManager downloadLibrary success');
        callback?.onDownLoadEnd(UpdateLibraryCode.DOWNLOAD_END_SUCC);
        this.onDownloadLibraryEnd(callback);
        this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_PATH);
      },
      onFailure: () => {
        console.info('deviceLibraryManager downloadLibrary fail');
        this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_PATH);
        callback?.onDownLoadEnd(UpdateLibraryCode.DOWNLOAD_END_FAIL);
      },
      onDownLoading: (receivedSize: number, totalSize: number) => {
        callback?.onDownLoading(receivedSize, totalSize);
      }
    };
    SyncCloudApi.downloadFile(url,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_PATH + '/' +
      LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_NAME, downloadCallback);
  }

  protected onDownloadLibraryEnd(callback?: UpdateLibraryCallback) {
    this.copyLibraryToTmpDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_PATH + '/' +
    LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH + '/' +
      LibraryManager.LIBRARY_TMP_ZIP_DEVICE_NAME, callback);
  }

  protected onCopyLibraryToTmpDirEnd(callback?: UpdateLibraryCallback) {
    this.verifyLibrary(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH + '/' +
    LibraryManager.LIBRARY_TMP_ZIP_DEVICE_NAME, callback);
  }

  protected onVerifyLibraryEnd(zipFilePath: string, callback?: UpdateLibraryCallback) {
    this.unzipLibrary(zipFilePath, LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH, callback);
  }

  protected checkLibrary(callback?: UpdateLibraryCallback) {
    let checkTag: boolean = true;
    let xmlFilePath =
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH + '/' + LibraryManager.VERSION_FILE_NAME;
    let xmlIsAccess = fs.accessSync(xmlFilePath);
    let jsonFilePath = LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH + '/' +
    LibraryManager.DEVICE_INFO_FILE_NAME;
    let jsonIsAccess = fs.accessSync(jsonFilePath);
    checkTag = xmlIsAccess && jsonIsAccess;
    if (checkTag) {
      console.info('deviceLibraryManager checkLibrary succ');
      this.onCheckLibraryEnd(callback);
    } else {
      console.info('deviceLibraryManager checkLibrary fail');
      callback?.onParseEnd(UpdateLibraryCode.PARSE_END_CHECK_FAIL);
      this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH);
      this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH);
    }
  }

  protected parseLibrary(callback?: UpdateLibraryCallback) {
    try {
      let xmlFilePath = LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH + '/' +
      LibraryManager.VERSION_FILE_NAME;
      let xmlRreadTextOptions: ReadTextOptions = { offset: 0, length: 0, encoding: 'utf-8' };
      let xmlStat = fs.statSync(xmlFilePath);
      xmlRreadTextOptions.length = xmlStat.size;
      let xmlString = fs.readTextSync(xmlFilePath, xmlRreadTextOptions);
      this.parseVersionXmlFile(xmlString).then((parseXmlTag) => {
        if (parseXmlTag) {
          let jsonFilePath = LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH + '/' +
          LibraryManager.DEVICE_INFO_FILE_NAME;
          let readTextOptions: ReadTextOptions = { offset: 0, length: 0, encoding: 'utf-8' };
          let stat = fs.statSync(jsonFilePath);
          readTextOptions.length = stat.size;
          let devicedescContentJson = fs.readTextSync(jsonFilePath, readTextOptions);
          this.saveLibraryInfo(devicedescContentJson).then((isSaveSucc: boolean) => {
            if (isSaveSucc) {
              console.info('deviceLibraryManager saveLibraryInfo succ');
              callback?.onParseEnd(UpdateLibraryCode.PARSE_END_SUCC);
              this.onParseLibraryEnd(callback);
              this.onLibraryUpdate();
            } else {
              console.info('deviceLibraryManager saveLibraryInfo fail');
              callback?.onParseEnd(UpdateLibraryCode.PARSE_END_SAVE_FAIL);
              this.revertToPreVersion(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_DEVICE_PATH,
                LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH, callback);
            }
          });
        } else {
          console.info('deviceLibraryManager parseVersionXmlFile fail');
          callback?.onParseEnd(UpdateLibraryCode.PARSE_END_XML_FAIL);
          this.revertToPreVersion(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_DEVICE_PATH,
            LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH, callback);
        }
      });
    } catch (errData) {
      console.info('deviceLibraryManager parseVersionXmlFile error');
      callback?.onParseEnd(UpdateLibraryCode.FAIL);
      this.printErrData(errData);
    }
  }

  protected onParseLibraryEnd(callback?: UpdateLibraryCallback) {
    this.handleTempFiles(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_DEVICE_PATH,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DEVICE_PATH,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_DEVICE_PATH,
      LibraryManager.LIBRARY_TMP_PRE_DEVICE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH,
      LibraryManager.LIBRARY_TMP_ZIP_DEVICE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_PATH,
      LibraryManager.LIBRARY_TMP_DOWNLOAD_DEVICE_NAME, callback);
  }

  protected handleTempFiles(libPath: string, libTmpPath: string, preLibPath: string, preLibName: string,
    zipTmpLibPath: string, zipTmpLibName: string, downloadTmpLibPath: string, downloadTmpLibName: string,
    callback?: UpdateLibraryCallback) {
    this.resetDir(libPath);
    try {
      fs.copyDirSync(libTmpPath + LibraryManager.DEVICE_ASSETS_PATH, libPath);
    } catch (errData) {
      this.printErrData(errData);
    }
    this.resetDir(libTmpPath);
    try {
      fs.copyFileSync(zipTmpLibPath + '/' + zipTmpLibName, preLibPath + '/' + preLibName);
    } catch (errData) {
      this.printErrData(errData);
    }
    this.resetDir(zipTmpLibPath);
    this.onHandleTempFilesEnd(callback);
  }

  private async parseVersionXmlFile(xmlString: string): Promise<boolean> {
    let res = false;
    const devlibVersionRegex = '\<devlibVersion\>\(\.\*\?\)\<\/devlibVersion\>';
    const descriptionRegex = '\<description\>\(\.\*\?\)\<\/description\>';
    let devlibVersionMatch = xmlString.match(devlibVersionRegex);
    let descriptionMatch = xmlString.match(descriptionRegex);
    let devlibVersion = '';
    let description = '';
    if (devlibVersionMatch && descriptionMatch) {
      devlibVersion = devlibVersionMatch[1];
      description = descriptionMatch[1];
    }
    if (devlibVersion.length > 0) {
      res = await PreferencesHelper.put(DeviceLibraryManager.DEVICE_LIBRARY_VERSION_KEY, devlibVersion);
      res = await PreferencesHelper.put(DeviceLibraryManager.DEVICE_LIBRARY_DESCRIPTION_KEY, description) && res;
    }
    return res;
  }

  private async saveLibraryInfo(devicedescContentJson: string): Promise<boolean> {
    let resTag = false;
    try {
      let databaseHelper = await ConnectDatabaseHelperImpl.getInstance();
      let deviceList: LibraryDevice[] = JSON.parse(devicedescContentJson);
      let dao = new DeviceLibraryDao(databaseHelper);
      await dao.deleteAllDevice();
      let iconRootPath: string =
        LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_DEVICE_PATH + LibraryManager.DEVICE_ASSETS_PATH +
        LibraryManager.DEVICE_ASSETS_DEVICEICON_PATH + '/';
      await dao.addDeviceList(deviceList, iconRootPath);
      resTag = true;
    } catch (errData) {
      console.info('deviceLibraryManager saveLibraryInfo error');
      resTag = false;
      this.printErrData(errData);
    }
    return resTag;
  }
}