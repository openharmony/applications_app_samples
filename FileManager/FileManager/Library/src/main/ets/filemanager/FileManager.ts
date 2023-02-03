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

import mediaLibrary from '@ohos.multimedia.mediaLibrary'
import image from '@ohos.multimedia.image'
import MediaLibraryManager from './medialibrary/MediaLibraryManager'
import LocalMockData from '../mock/local/LocalMockData'

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
  async getPixelMapByFileAsset(fileAsset: mediaLibrary.FileAsset): Promise<image.PixelMap> {
    return await MediaLibraryManager.getPixelMapByFileAsset(fileAsset)
  }

  /**
   * 通过传入文件类型，获取到不同的文件列表信息
   * @param context 上下文对象
   * @param fileType 文件类型
   * @return Promise<mediaLibrary.FetchFileResult> 返回文件列表信息
   */
  async getFileAssets(context, fileType: mediaLibrary.MediaType): Promise<mediaLibrary.FetchFileResult> {
    return await MediaLibraryManager.getFileAssets(context, fileType)
  }

  /**
   * 通过文件名称获取文件对象
   * @param context 上下文对象
   * @param name 文件名称
   * @return Promise<mediaLibrary.FileAsset> 返回文件对象信息
   */
  async getFileAssetsByName(context, name: string): Promise<mediaLibrary.FileAsset> {
    return await MediaLibraryManager.getFileAssetsByName(context, name)
  }

  /**
   * 获取文件缩略图
   * @param fileAsset 文件对象
   * @return Promise<image.PixelMap> 返回缩略图信息
   */
  async getThumbnail(fileAsset: mediaLibrary.FileAsset): Promise<image.PixelMap> {
    return await MediaLibraryManager.getThumbnail(fileAsset)
  }

  /**
   * 创建文件
   * @param context 上下文对象
   * @param mediaType 文件类型
   * @param dir 文件路径
   * @param fileName 文件名称
   * @return Promise<mediaLibrary.FileAsset> 返回匹配的文件信息
   */
  async createFileAsset(context, mediaType: mediaLibrary.MediaType,
                        dir: mediaLibrary.DirectoryType, fileName: string): Promise<mediaLibrary.FileAsset> {
    return await MediaLibraryManager.createFileAsset(context, mediaType, dir, fileName)
  }

  /**
   * 删除文件
   * @param context 上下文对象
   * @param fileAsset 文件对象
   */
  async deleteFileAsset(context, fileAsset: mediaLibrary.FileAsset) {
    await MediaLibraryManager.deleteFileAsset(context, fileAsset)
  }

  /**
   * 创建模拟文件
   * @param context 上下文对象
   * @param mediaType 文件类型
   * @return Promise<mediaLibrary.FileAsset> 返回文件对象
   */
  async createTxtFileAsset(context): Promise<mediaLibrary.FileAsset> {
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
}

export default new FileManager()