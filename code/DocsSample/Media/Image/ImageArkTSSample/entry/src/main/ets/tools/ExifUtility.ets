/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
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

// [Start editExif_import]
// 导入相关模块包。
import { image } from '@kit.ImageKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End editExif_import]

export class ExifUtility {
  // [Start get_exif]
  // 获取指定key的Exif信息接口示例
  async getExif(imageSourceApi: image.ImageSource | undefined, key: image.PropertyKey): Promise<string> {
    let info: string = '';
    if (imageSourceApi) {
      console.info('getExif: The imageSourceApi is not undefined.');
      // 根据传入的key获取其Exif信息
      let options: image.ImagePropertyOptions = { index: 0, defaultValue: 'This key has no value!' };
      try {
        let data = await imageSourceApi.getImageProperty(key, options);
        info = `Succeeded in getting the ${key}'s value: ${data}.`;
        console.info(info);
        return info; // 获取key值成功时返回获取到的key值
      } catch (error) {
        info =
          `Failed to get the value of the ${key} with error: ${error}.`;
        console.error(info);
        return info; // 获取key值失败时返回错误信息
      }
    } else {
      info = 'getExif: The imageSourceApi is undefined.';
      console.info(info);
      return info; // 如果 imageSourceApi 是 undefined，则直接返回信息
    }
  }
  // [End get_exif]

  // [Start modify_exif]
  // 修改指定key的Exif信息的接口示例
  async modifyExif(imageSourceApi: image.ImageSource | undefined, key: image.PropertyKey, value: string)
    : Promise<string> {
    let info: string = '';
    if (imageSourceApi) {
      // 编辑EXIF信息
      try {
        await imageSourceApi.modifyImageProperty(key, value);
        try {
          let modifyValue = await imageSourceApi.getImageProperty(key)
          info = `The ${key}'s value is modified to ${modifyValue}.`
          console.info(info);
          return info; // 获取key值成功时返回修改成功信息
        } catch (error) {
          console.error(`Failed to get the the ${key}'s value with ${error}`);
          console.error(info);
          return info; // 获取key值失败时返回错误信息
        }
      } catch (error) {
        info = `Failed to modify the ${key}'s value with ${error}`;
        console.error(info);
        return info; // 修改key值失败时返回错误信息
      }
    } else {
      info = 'modifyExif: The imageSourceApi is undefined.';
      console.info(info);
      return info; // 如果 imageSourceApi 是 undefined，直接返回信息
    }
  }
  // [End modify_exif]
}
