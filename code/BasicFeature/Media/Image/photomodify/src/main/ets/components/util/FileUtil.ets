/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import image from '@ohos.multimedia.image';
import fs from '@ohos.file.fs';
import fileIo from '@ohos.file.fs';
import { logger } from '../util/Logger';

const TAG: string = '[Sample_SavePixelMap]';
/**
 * 保存pixelMap，返回路径
 * @param pm
 * @returns
 */
export async function savePixelMap(context: Context, pm: PixelMap): Promise<string> {
  if (pm === null) {
    logger.error(TAG, '传入的pm为空');
    return '';
  }
  const imagePackerApi: image.ImagePacker = image.createImagePacker();
  let packOpts: image.PackingOption = { format: 'image/jpeg', quality: 30 };
  try {
    packToFile(context, pm);
    const data: ArrayBuffer = await imagePackerApi.packing(pm, packOpts);
    return await saveFile(context, data);
  } catch (err) {
    logger.error(TAG, '保存文件失败，err=' + JSON.stringify(err));
    return '';
  }
}

async function packToFile(context: Context, pixelMap: PixelMap) {
  let fPath: string = context.cacheDir + '/' + getTimeStr() + '.jpg';
  let writeFd: fs.File = await fs.open(fPath, fs.OpenMode.CREATE | fs.OpenMode.READ_WRITE);

  let opts : image.PackingOption = { format: "image/jpeg", quality: 100};
  const imagePacker = image.createImagePacker();
  await imagePacker.packToFile(pixelMap, writeFd.fd, opts);
  fs.closeSync(writeFd.fd);
}

async function saveFile(context: Context, data: ArrayBuffer): Promise<string> {
  let uri: string = context.filesDir + '/' + getTimeStr() + '.jpg';
  let file: fileIo.File = fs.openSync(uri, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
  fs.writeSync(file.fd, data);
  fs.closeSync(file);
  // /data/storage/....  加上file://前缀
  uri = 'file:/' + uri;
  // 打开媒体文件，存储图片
  setImageList(uri);
  return uri;
}

function setImageList(uri: string) {

  let imageList: Array<string> | undefined = AppStorage.Get('imageList');
  const index: number | undefined = AppStorage.Get('selectIndex');
  if (imageList !== undefined && index !== undefined) {
    imageList[index] = uri;
  }
  AppStorage.SetOrCreate<Array<string>>('imageList', imageList);


}

function getTimeStr() {
  const now: Date = new Date();
  const year: number = now.getFullYear();
  const month: number = now.getMonth() + 1;
  const day: number = now.getDate();
  const hours: number = now.getHours();
  const minutes: number = now.getMinutes();
  const seconds: number = now.getSeconds();
  return `${year}${month}${day}_${hours}${minutes}${seconds}`;
}