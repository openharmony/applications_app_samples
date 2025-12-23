/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the License);
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

// [Start PickerMediaLibrary_import]
import { fileIo } from '@kit.CoreFileKit';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
// [End PickerMediaLibrary_import]
import { dataSharePredicates } from '@kit.ArkData';
import { common } from '@kit.AbilityKit';

/**
 * 照片信息接口
 */
export interface PhotoItem {
  uri: string;
  mimeType: string;
}

/**
 * 文件对象接口
 */
export interface FileObject {
  fd: number;
  file: fileIo.File;
}

/**
 * 文件读取结果接口
 */
export interface FileReadResult {
  data: ArrayBuffer;
  length: number;
}

/**
 * 媒体数据处理回调接口 - 修改为函数类型
 */
export type MediaDataHandlerCallback = (data: ArrayBuffer) => void;

/**
 * 媒体资源处理器实现
 */
 // [Start PickerMediaLibrary_handler]
export class MediaAssetDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
  private callback?: MediaDataHandlerCallback;
  
  constructor(callback?: MediaDataHandlerCallback) {
    this.callback = callback;
  }

  // 使用箭头函数确保this引用不会丢失
  onDataPrepared = (data: ArrayBuffer) => {
    if (data === undefined) {
      console.error('Error occurred when preparing data');
      return;
    }
    console.info('on image data prepared');
    // 现在this始终指向MediaAssetDataHandler实例
    if (this.callback) {
      this.callback(data);
    }
  };
}
// [End PickerMediaLibrary_handler]

/**
 * MediaLibraryPickerUtils工具类，用于处理媒体库选择相关功能
 */
export default class MediaLibraryPickerUtils {
  /**
   * 处理照片选择结果
   * @param result 选择结果数组
   * @returns 处理后的结果数组
   */
  static handleSelectResult(result: Array<string>): Array<PhotoItem> {
    const items: PhotoItem[] = [];
    if (result && result.length > 0) {
      for (let i = 0; i < result.length; i++) {
        items.push({
          uri: result[i],
          mimeType: '' // 默认空MIME类型，实际应用中可能需要从URI解析
        });
      }
    }
    return items;
  }

  /**
   * 通过URI打开文件并获取文件描述符
   * @param uri 文件URI
   * @returns 文件对象
   */
  static openFileByUri(uri: string): FileObject | null {
    // [Start PickerMediaLibrary_openFile]
    try {
      const file = fileIo.openSync(uri, fileIo.OpenMode.READ_ONLY);
      console.info('file fd: ' + file.fd);
      return { fd: file.fd, file: file };
    } catch (error) {
      console.error('openSync failed with err: ' + error);
      return null;
    }
    // [End PickerMediaLibrary_openFile]
  }
  
  /**
   * 读取文件数据
   * @param fileObj 文件对象
   * @param bufferSize 缓冲区大小
   * @returns 读取的数据和长度
   */
  static readFileData(fileObj: FileObject, bufferSize: number = 4096): FileReadResult | null {
    // [Start PickerMediaLibrary_readFileData]
    try {
      const buffer = new ArrayBuffer(bufferSize);
      const readLen = fileIo.readSync(fileObj.fd, buffer);
      console.info('readSync data to file succeed and buffer size is:' + readLen);
      return { data: buffer, length: readLen };
    } catch (error) {
      console.error('readSync failed with err: ' + error);
      return null;
    }
    // [End PickerMediaLibrary_readFileData]
  }

  /**
   * 关闭文件
   * @param fileObj 文件对象
   * @returns 是否成功关闭
   */
  static closeFile(fileObj: FileObject): boolean {
    try {
      fileIo.closeSync(fileObj.file);
      console.info('file closed successfully');
      return true;
    } catch (error) {
      console.error('closeSync failed with err: ' + error);
      return false;
    }
  }
  
  /**
   * 通过URI打开并读取文件数据
   * @param uri 文件URI
   * @returns 读取的数据和长度
   */
  static openAndReadFileData(uri: string): FileReadResult | null {
    // 打开文件
    const fileObj = MediaLibraryPickerUtils.openFileByUri(uri);
    if (!fileObj) {
      return null;
    }

    try {
      // 读取文件数据
      const result = MediaLibraryPickerUtils.readFileData(fileObj);
      return result;
    } finally {
      // 确保关闭文件
      MediaLibraryPickerUtils.closeFile(fileObj);
    }
  }
  
  /**
   * 通过URI获取媒体资源
   * @param uri 媒体文件URI
   * @param context 上下文
   * @param callback 数据准备完成回调函数
   */
   // [Start PickerMediaLibrary_getMediaResource]
  static async getMediaResourceByUri(uri: string, context: common.Context, callback?: MediaDataHandlerCallback)
  : Promise<void> {
    try {
      // 创建PhotoAccessHelper实例
      const phAccessHelper = photoAccessHelper.getPhotoAccessHelper(context);
      
      // 创建查询条件
      const predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
      predicates.equalTo(photoAccessHelper.PhotoKeys.URI, uri);
      
      // 设置查询选项
      const fetchOptions: photoAccessHelper.FetchOptions = {
        fetchColumns: [photoAccessHelper.PhotoKeys.TITLE],
        predicates: predicates
      };

      // 查询资产
      const fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = 
        await phAccessHelper.getAssets(fetchOptions);
      
      const photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
      if (photoAsset) {
        console.info('getAssets photoAsset.uri : ' + photoAsset.uri);
        // 获取标题属性
        console.info('title : ' + photoAsset.get(photoAccessHelper.PhotoKeys.TITLE));
        
        // 设置请求选项
        const requestOptions: photoAccessHelper.RequestOptions = {
          deliveryMode: photoAccessHelper.DeliveryMode.HIGH_QUALITY_MODE,
        };
        
        // 请求图片数据
        await photoAccessHelper.MediaAssetManager.requestImageData(
          context, photoAsset, requestOptions, new MediaAssetDataHandler(callback));
        
        console.info('requestImageData successfully');
      } else {
        console.error('No asset found for URI: ' + uri);
      }
      
      // 关闭查询结果
      fetchResult.close();
    } catch (err) {
      console.error('getMediaResourceByUri failed with err: ' + err);
    }
  }
  // [End PickerMediaLibrary_getMediaResource]
}