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

import { LibraryManager, UpdateLibraryCode } from './LibraryManager';
import fs, { ReadTextOptions } from '@ohos.file.fs';
import { ConnectDatabaseHelperImpl, Logger, PreferencesHelper, SceneLibraryDao } from '@ohos/common';
import { StatusCode, SyncCloudApi } from '../cloud/SyncCloudApi';
import { UpgradeSceneLibraryRequest } from '../cloud/Request';
import { BaseCallback } from '../callback/BaseCallback';
import { CommonResponse, UpgradeSceneLibrarySuccData } from '../cloud/Response';
import bundleManager from '@ohos.bundle.bundleManager';
import { DownloadCallback } from '../callback/DownloadCallback';
import { UpdateLibraryCallback } from '../callback/UpdateLibraryCallback';

/*
 * 场景库管理
 * */
export class SceneLibraryManager extends LibraryManager {
  public static readonly SCENE_LIBRARY_VERSION_KEY = 'scene_library_version';
  public static readonly SCENE_LIBRARY_DESCRIPTION_KEY = 'scene_library_description';

  public async getLibraryVersion() {
    this.currentVersionCode =
      (await PreferencesHelper.get(SceneLibraryManager.SCENE_LIBRARY_VERSION_KEY, '')) as string;
  }

  public importLibrary(path: string, callback?: UpdateLibraryCallback) {
    this.copyLibraryToTmpDir(path, LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH + '/' +
    LibraryManager.LIBRARY_TMP_ZIP_SCENE_NAME, callback);
  }

  public async loadPresetLibrary() {
    let version: string = (await PreferencesHelper.get(SceneLibraryManager.SCENE_LIBRARY_VERSION_KEY, '')) as string;
    if (version == '' || this.isNeedUpdate(version, LibraryManager.PRESET_SCENE_LIBRARY_VERSION)) {
      this.initLibrary();
    }
  }

  protected initLibrary() {
    this.copyLibraryToTmpDir(LibraryManager.resourceRootPath + LibraryManager.RESOURCE_SCENE_PATH + '/' +
    LibraryManager.RESOURCE_SCENE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH + '/' +
      LibraryManager.LIBRARY_TMP_ZIP_SCENE_NAME);
  }

  protected async checkLibraryVersion(callback?: UpdateLibraryCallback) { //调用云api
    let request: UpgradeSceneLibraryRequest = new UpgradeSceneLibraryRequest();
    request.scenelibVersion = '';
    request.appVersion = '';
    request.description = '';
    let version: string = (await PreferencesHelper.get(SceneLibraryManager.SCENE_LIBRARY_VERSION_KEY, '')) as string;
    let cloudCallback: BaseCallback = {
      onResult: (code: number, data: Object, msg?: string) => {
        if (code == StatusCode.SUCCESS) {
          let response: CommonResponse = data as CommonResponse; // 检查版本号是否需要更新
          if (response.code == 200) {
            let rspData = response.data as UpgradeSceneLibrarySuccData;
            callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_SUCC_NEED_UPDATE, rspData);
            this.onCheckLibraryVersionEnd(rspData.url, callback);
          } else if (response.code == 1001) {
            callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_SUCC_NO_UPDATE);
          } else {
            callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_FAIL);
          }
        } else {
          callback?.onCheckVersionEnd(UpdateLibraryCode.CHECK_VERSION_END_FAIL);
        }
      }
    };
    request.scenelibVersion = version;
    let desc: string = (await PreferencesHelper.get(SceneLibraryManager.SCENE_LIBRARY_DESCRIPTION_KEY, '')) as string;
    request.description = desc;
    let bundleFlags = bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION |
    bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_METADATA;
    bundleManager.getBundleInfoForSelf(bundleFlags).then((data) => {
      request.appVersion = data.versionName;
      SyncCloudApi.checkSceneLibraryVersionInfo(request, cloudCallback);
    });
  }

  protected downloadLibrary(url: string, callback?: UpdateLibraryCallback) {
    let downloadCallback: DownloadCallback = {
      onSuccess: () => {
        Logger.info('sceneLibraryManager downloadLibrary success');
        callback?.onDownLoadEnd(UpdateLibraryCode.DOWNLOAD_END_SUCC);
        this.onDownloadLibraryEnd(callback);
        this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_PATH);
      },
      onFailure: () => {
        Logger.info('sceneLibraryManager downloadLibrary fail');
        this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_PATH);
        callback?.onDownLoadEnd(UpdateLibraryCode.DOWNLOAD_END_FAIL);
      },
      onDownLoading: (receivedSize: number, totalSize: number) => {
        callback?.onDownLoading(receivedSize, totalSize);
      }
    };
    SyncCloudApi.downloadFile(url,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_PATH + '/' +
      LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_NAME, downloadCallback);
  }

  protected onDownloadLibraryEnd(callback?: UpdateLibraryCallback) {
    this.copyLibraryToTmpDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_PATH + '/' +
    LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH + '/' +
      LibraryManager.LIBRARY_TMP_ZIP_SCENE_NAME, callback);
  }

  protected onCopyLibraryToTmpDirEnd(callback?: UpdateLibraryCallback) {
    this.verifyLibrary(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH + '/' +
    LibraryManager.LIBRARY_TMP_ZIP_SCENE_NAME, callback);
  }

  protected onVerifyLibraryEnd(zipFilePath: string, callback?: UpdateLibraryCallback) {
    this.unzipLibrary(zipFilePath, LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH, callback);
  }

  protected checkLibrary(callback?: UpdateLibraryCallback) {
    let checkTag: boolean = true;
    let xmlFilePath =
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH + '/' + LibraryManager.VERSION_FILE_NAME;
    let xmlIsAccess = fs.accessSync(xmlFilePath);
    let jsonFilePath = LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH + '/' +
    LibraryManager.SCENE_INFO_FILE_NAME;
    let jsonIsAccess = fs.accessSync(jsonFilePath);
    Logger.info('sceneLibraryManager xmlIsAccess ' + xmlIsAccess);
    Logger.info('sceneLibraryManager jsonIsAccess ' + jsonIsAccess);
    checkTag = xmlIsAccess && jsonIsAccess;
    if (checkTag) {
      Logger.info('sceneLibraryManager checkLibrary succ');
      this.onCheckLibraryEnd(callback);
    } else {
      Logger.info('sceneLibraryManager checkLibrary fail');
      callback?.onParseEnd(UpdateLibraryCode.PARSE_END_CHECK_FAIL);
      this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH);
      this.resetDir(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH);
    }
  }

  protected parseLibrary(callback?: UpdateLibraryCallback) {
    try {
      let xmlFilePath = LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH + '/' +
      LibraryManager.VERSION_FILE_NAME;
      let xmlRreadTextOptions: ReadTextOptions = { offset: 0, length: 0, encoding: 'utf-8' };
      let xmlStat = fs.statSync(xmlFilePath);
      xmlRreadTextOptions.length = xmlStat.size;
      let xmlString = fs.readTextSync(xmlFilePath, xmlRreadTextOptions);
      this.parseVersionXmlFile(xmlString).then((parseXmlTag) => {
        if (parseXmlTag) {
          this.parseSceneLibraryJsonFiles().then((data) => {
            this.saveLibraryInfo(data).then((isSaveSucc: boolean) => {
              if (isSaveSucc) {
                Logger.info('sceneLibraryManager saveLibraryInfo succ');
                callback?.onParseEnd(UpdateLibraryCode.PARSE_END_SUCC);
                this.onLibraryUpdate();
                this.onParseLibraryEnd(callback);
              } else {
                Logger.info('sceneLibraryManager saveLibraryInfo fail');
                callback?.onParseEnd(UpdateLibraryCode.PARSE_END_SAVE_FAIL);
                this.revertToPreVersion(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_DEVICE_PATH,
                  LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_DEVICE_PATH, callback);
              }
            });
          });
        } else {
          Logger.info('sceneLibraryManager parseVersionXmlFile fail');
          callback?.onParseEnd(UpdateLibraryCode.PARSE_END_XML_FAIL);
          this.revertToPreVersion(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_SCENE_PATH,
            LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH, callback);
        }
      });
    } catch (errData) {
      Logger.info('sceneLibraryManager parseVersionXmlFile error');
      callback?.onParseEnd(UpdateLibraryCode.FAIL);
      this.printErrData(errData);
    }
  }

  protected onParseLibraryEnd(callback?: UpdateLibraryCallback) {
    this.handleTempFiles(LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_SCENE_PATH,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_PRE_SCENE_PATH,
      LibraryManager.LIBRARY_TMP_PRE_SCENE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_ZIP_SCENE_PATH,
      LibraryManager.LIBRARY_TMP_ZIP_SCENE_NAME,
      LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_PATH,
      LibraryManager.LIBRARY_TMP_DOWNLOAD_SCENE_NAME, callback);
  }

  private async parseSceneLibraryJsonFiles(): Promise<Map<string, Array<string>>> {
    let resMap: Map<string, Array<string>> = new Map();
    let jsonFilePath = LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH + '/' +
    LibraryManager.SCENE_INFO_FILE_NAME;
    let readTextOptions: ReadTextOptions = { offset: 0, length: 0, encoding: 'utf-8' };
    let stat = fs.statSync(jsonFilePath);
    readTextOptions.length = stat.size;
    let sceneDescContentJson = fs.readTextSync(jsonFilePath, readTextOptions);
    let sceneDescContentStr: ScenesLibraryDesc[] = JSON.parse(sceneDescContentJson);
    for (let i of sceneDescContentStr) {
      let langScenes: string[] = [];
      for (let s of i.fileName) {
        try {
          let sceneFilePath: string =
            LibraryManager.workspaceRootPath + LibraryManager.LIBRARY_TMP_SCENE_PATH + i.path.substring(1) + s;
          Logger.error('parseSceneLibraryJsonFiles file path:', sceneFilePath);
          let sceneReadTextOptions: ReadTextOptions = { offset: 0, length: 0, encoding: 'utf-8' };
          let sceneStat = fs.statSync(sceneFilePath);
          sceneReadTextOptions.length = sceneStat.size;
          let sceneFileJson = fs.readTextSync(sceneFilePath, sceneReadTextOptions);
          langScenes.push(sceneFileJson);
        } catch (e) {
          this.printErrData(e);
        }
      }
      resMap.set(i.language, langScenes);
    }
    return resMap;
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
      res = await PreferencesHelper.put(SceneLibraryManager.SCENE_LIBRARY_VERSION_KEY, devlibVersion);
      res = await PreferencesHelper.put(SceneLibraryManager.SCENE_LIBRARY_DESCRIPTION_KEY, description) && res;
    }
    return res;
  }

  private async saveLibraryInfo(scenes: Map<string, Array<string>>): Promise<boolean> {
    let resTag = false;
    try {
      let databaseHelper = await ConnectDatabaseHelperImpl.getInstance();
      let dao = new SceneLibraryDao(databaseHelper);
      await dao.deleteAllScene();
      await dao.addSceneList(scenes);
      resTag = true;
    } catch (errData) {
      resTag = false;
      this.printErrData(errData);
    }
    return resTag;
  }
}

interface ScenesLibraryDesc {
  language: string;
  path: string;
  fileName: string[];
}