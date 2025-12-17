/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
// [Start transcoding_example]
import { BusinessError } from '@kit.BasicServicesKit';
import { fileIo as fs } from '@kit.CoreFileKit';
import { image } from '@kit.ImageKit';
import { promptAction } from '@kit.ArkUI';

export async function reEncoding(context : Context, fd : number) {
  // 首先获取图片文件的fd，创建ImageSource。
  const imageSource : image.ImageSource = image.createImageSource(fd);
  // 创建ImagePacker，以便调用图片编码接口。
  const imagePackerApi = image.createImagePacker();
  // 配置图片编码选项：
  // format应使用标准的mimetype格式，如："image/jpeg"、"image/png"、"image/heic"；
  // quality推荐设置为80，在保证较好的图片质量的同时，可以使编码后的图片文件体积更小；
  // needsPackProperties参数，用于控制编码时是否保存图片属性信息。默认值为false，即不保存。
  let packOpts : image.PackingOption = { format:'image/jpeg', quality:80, needsPackProperties:false };
  // 指定图片编码文件的存放路径。
  const filePath : string = context.cacheDir + '/result.jpg';
  let file = fs.openSync(filePath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);
  imagePackerApi.packToFile(imageSource, file.fd, packOpts).then(() => {
    promptAction.showToast({ message: `Succeed to pack the image.`});
    console.info('Succeed to pack the image.');
  }).catch((error : BusinessError) => {
    promptAction.showToast({ message: 'Failed to pack the image. And the error is: ' + error});
    console.error('Failed to pack the image. And the error is: ' + error);
  }).finally(()=>{
    fs.closeSync(file.fd);
  })
}
// [End transcoding_example]