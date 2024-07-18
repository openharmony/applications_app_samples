/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import LocalMockData from '../mock/local/LocalMockData';
import dataSharePredicates from '@ohos.data.dataSharePredicates';
import userFileManager from '@ohos.filemanagement.userFileManager';
import MediaLibraryManager from './medialibrary/MediaLibraryManager';

class StateInfo {
  crtime: number;
  size: number
}

/**
 * 文件管理接口，统一封装了各模块对外提供的功能接口
 */
class FileManager {
  /**
   * 申请文件管理权限
   * @param context 上下文对象
   */
  requestPermission(context): void {
    MediaLibraryManager.requestPermission(context)
  }

  /**
   * 通过传入文件对象FileAsset，获取到文件中的图片PixelMap对象
   * @param fileAsset 文件对象
   * @return Promise<image.PixelMap> 返回PixelMap对象
   */
  async getPixelMapByFileAsset(fileAsset: userFileManager.FileAsset): Promise<image.PixelMap> {
    return await MediaLibraryManager.getPixelMapByFileAsset(fileAsset)
  }

  /**
   * 通过传入文件类型，获取到不同的文件列表信息
   * @param context 上下文对象
   * @param fileType 文件类型
   * @return Promise<userFileManager.FetchResult<userFileManager.FileAsset>> 返回文件列表信息
   */
  async getFileAssets(context, fileType: userFileManager.FileType): Promise<userFileManager.FetchResult<userFileManager.FileAsset>> {
    let mgr = userFileManager.getUserFileMgr(context);
    let fileKeyObj = userFileManager.ImageVideoKey;
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    let fetchOptions: userFileManager.FetchOptions = {
      fetchColumns: [],
      predicates: predicates.equalTo(fileKeyObj.FILE_TYPE.toString(), fileType)
    };
    let fetchResult: userFileManager.FetchResult<userFileManager.FileAsset>;
    if (fileType === userFileManager.FileType.IMAGE || fileType === userFileManager.FileType.VIDEO) {
      fetchResult = await mgr.getPhotoAssets(fetchOptions);
    } else if (fileType === userFileManager.FileType.AUDIO) {
      fetchResult = await mgr.getAudioAssets(fetchOptions);
    }
    return fetchResult;
  }

  /**
   * 通过文件名称获取文件对象
   * @param context 上下文对象
   * @param name 文件名称
   * @return Promise<userFileManager.FileAsset> 返回文件对象信息
   */
  async getFileAssetsByName(context, name: string): Promise<userFileManager.FileAsset> {
    return await MediaLibraryManager.getFileAssetsByName(context, name)
  }

  /**
   * 获取文件缩略图
   * @param fileAsset 文件对象
   * @return Promise<image.PixelMap> 返回缩略图信息
   */
  async getThumbnail(fileAsset: userFileManager.FileAsset): Promise<image.PixelMap> {
    return await MediaLibraryManager.getThumbnail(fileAsset)
  }

  /**
   * 创建文件
   * @param context 上下文对象
   * @param mediaType 文件类型
   * @param fileName 文件名称
   * @return Promise<userFileManager.FileAsset> 返回匹配的文件信息
   */
  async createFileAsset(context, mediaType: userFileManager.FileType,
                        fileName: string): Promise<userFileManager.FileAsset> {
    return await MediaLibraryManager.createFileAsset(context, mediaType, fileName)
  }

  /**
   * 删除文件
   * @param fileAsset 文件对象
   */
  async deleteFileAsset(context, fileAsset: userFileManager.FileAsset): Promise<void> {
    await MediaLibraryManager.deleteFileAsset(context, fileAsset);
  }

  /**
   * 创建模拟文件
   * @param context 上下文对象
   * @param mediaType 文件类型
   * @return Promise<userFileManager.FileAsset> 返回文件对象
   */
  async createTxtFileAsset(context): Promise<userFileManager.FileAsset> {
    return await LocalMockData.createFileAsset(context)
  }

  /**
   * 该文件是否支持预览
   * @param fileName 文件名
   * @return boolean ture表示支持，false表示不支持
   */
  isSupportPreview(fileName: string): boolean {
    return LocalMockData.isSupportPreview(fileName)
  }

  /**
   * 获取文件创建时间和大小
   * @param tempDir 沙箱路径
   * @return StateInfo 文件状态信息
   */
  getFileState(tempDir: string): StateInfo {
    let state = fs.statSync(tempDir);
    let stateInfo: StateInfo = {
      crtime: 0,
      size: 0
    }
    stateInfo.crtime = state.ctime;
    stateInfo.size = state.size;
    return stateInfo;
  }
}

export default new FileManager()