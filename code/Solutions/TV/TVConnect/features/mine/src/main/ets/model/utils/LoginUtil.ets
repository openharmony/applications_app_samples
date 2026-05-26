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

/*
 * 注册登录工具类
 * */
import { CountryCodeConfig, Logger, UserLibraryDao } from '@ohos/common/';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import fs from '@ohos.file.fs';
import { buffer, util } from '@kit.ArkTS';
import { image } from '@kit.ImageKit';
import { LoginCloud } from '../cloud/LoginCloud';
import { common } from '@kit.AbilityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import fileIo from '@ohos.file.fs';

let context = getContext(this);

export class LoginUtil {
  private static readonly LOGIN_NUMBER_RIGHT = /^[0-9a-zA-Z]{6,16}$/;
  private static readonly LOGIN_CODE_RIGHT = /^\d{6}$/;
  private static readonly MAX_AVATAR_SIZE = 100 * 1024;

  /*
   * 账号密码正则判断
   * */
  public static isNumberRight(number: string): boolean {
    return LoginUtil.LOGIN_NUMBER_RIGHT.test(number);
  }

  /*
   * 验证码正则判断
   * */
  public static isCodeRight(number: string): boolean {
    return LoginUtil.LOGIN_CODE_RIGHT.test(number);
  }

  /*
   * 手机号正则判断，输出地区码
   * */
  public static getCountryCodeByPhoneNumber(phoneNumber: string): string {
    for (let i = 0; i < CountryCodeConfig.countryCodeConfig.length; i++) {
      if (CountryCodeConfig.countryCodeConfig[i].pattern.test(phoneNumber)) {
        return '  ' + CountryCodeConfig.countryCodeConfig[i].code;
      }
    }
    return ''; // 如果没有匹配到任何国家，则返回null
  }

  /*
   * 手机号正则判断
   * */
  public static isCountryCodeByPhoneNumber(phoneNumber: string): boolean {
    for (let i = 0; i < CountryCodeConfig.countryCodeConfig.length; i++) {
      if (CountryCodeConfig.countryCodeConfig[i].pattern.test(phoneNumber)) {
        return true;
      }
    }
    return false; // 如果没有匹配到任何国家，则返回null
  }

  public static getFirstValidCharacter(str: string): string {
    // 正则表达式匹配汉字、字母和数字，忽略其他字符（包括标点符号）
    const regex = /[\u4e00-\u9fa5a-zA-Z0-9]/;

    // 使用正则表达式的 exec 方法在字符串中查找匹配项
    const match = regex.exec(str);

    // 如果找到匹配项，则返回第一个匹配字符，否则返回空字符串
    return match ? match[0] : '';
  }

  public static getAvatarFileType(str: string): string {
    let fileSuffix = str.match(/\.(\w+)$/);
    let fileType: string = '';
    if (fileSuffix) {
      if (fileSuffix[1] == 'jpg' || fileSuffix[1] == 'jpeg') {
        fileType = 'jpeg';
      } else if (fileSuffix[1] == 'png') {
        fileType = 'png';
      } else if (fileSuffix[1] == 'webp') {
        fileType = 'webp';
      }
    }
    return fileType;
  }

  public static async avatarModification() {
    Logger.debug(`avatarModification start`);
    try {
      const photoViewPicker = new photoAccessHelper.PhotoViewPicker();
      let selectUris: string[];
      let baseStr: string;
      // 调用select()接口拉起图库界面进行文件选择,文件选择成功后，返回PhotoSelectResult结果集
      selectUris = (await photoViewPicker.select({
        maxSelectNumber: 1,
        MIMEType: photoAccessHelper.PhotoViewMIMETypes.IMAGE_TYPE
      })).photoUris;
      if (selectUris) {
        let fileSuffix = selectUris[0].match(/\.(\w+)$/);
        let fileType = LoginUtil.getAvatarFileType(selectUris[0]);
        if (fileType != '') {
          let file = fs.openSync(selectUris[0], fs.OpenMode.READ_ONLY);
          // 根据文件fd创建imagSource
          const imageSource: image.ImageSource = image.createImageSource(file.fd);
          let imagePixelMap = await imageSource.createPixelMap();
          // 完成后关闭fd
          fs.closeSync(file);
          const imagePackerApi: image.ImagePacker = image.createImagePacker();
          let packOpts: image.PackingOption = { format: 'image/' + fileType, quality: 98 };
          let data = await imagePackerApi.packing(imagePixelMap, packOpts);
          // 如果数据过大，进行压缩，直到大小小于想要的大小
          while (data.byteLength > LoginUtil.MAX_AVATAR_SIZE) {
            await imagePixelMap.scale(0.5, 0.5);
            data = await imagePackerApi.packing(imagePixelMap, packOpts);
          }
          // data 为打包获取到的文件流，写入文件保存即可得到一张图片
          if (data) {
            let buf: buffer.Buffer = buffer.from(data);
            baseStr = buf.toString('base64', 0, buf.length);
            let imgStr = fileSuffix![1] + ',' + baseStr;
            await LoginCloud.setUserData({ avatar: imgStr });
            LoginUtil.base64ToApplicationSandbox(imgStr);
          }
        }
      }
    } catch (e) {
      Logger.error(`avatarModification failed, error code: ${e}.`);
    }
  }

  public static async base64ToApplicationSandbox(base64: string) {
    try {
      let filesDir = context.filesDir;
      // base64转换成arrayBuffer
      const base64Str = base64.split(/\s*,\s*/);
      let base64Helper = new util.Base64Helper();
      let uint8Array = base64Helper.decodeSync(base64Str[1]);
      let arrayBuffer = uint8Array.buffer;
      // 将arrayBuffer以图片存在沙箱
      let uriName = `/userAvatar${LoginUtil.getTimeStamp()}.${base64Str[0]}`;
      let uri = filesDir + uriName;
      let file = fileIo.openSync(uri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE | fileIo.OpenMode.TRUNC);
      await fileIo.write(file.fd, arrayBuffer);
      await fileIo.close(file.fd);
      await UserLibraryDao.setUserData({ userAvatar: uriName });
    } catch (e) {
      Logger.error(`base64ToApplicationSandbox failed, error code: ${JSON.stringify(e)}.`);
    }
  }

  public static getTimeStamp(): number {
    const timeStamp = (new Date()).getTime();
    return timeStamp;
  }
}