/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import worker, { MessageEvents } from '@ohos.worker';
import zlib from '@ohos.zlib';
import request from '@ohos.request';
import type common from '@ohos.app.ability.common';
import Logger from '../../utils/Logger';

let workerPort = worker.workerPort;

workerPort.onmessage = (e: MessageEvents): void => {
  Logger.info('workerPort onmessage start');
  // worker线程向主线程发送信息
  let context: common.UIAbilityContext = e.data.context;
  // 获取设备本地路径
  let filesDir: string = context.filesDir;
  // 获取当前时间戳
  let time: number = new Date().getTime();
  // 初始化压缩文件的文件路径
  let inFilePath: string = `${filesDir}/${time.toString()}.zip`;
  // 初始化媒体下载路径
  let mediaDataUrl: string = e.data.mediaData;
  // 截取主要片段
  let urlPart: string = mediaDataUrl.split('.')[1];
  // 以'/'分割
  let length: number = urlPart.split('/').length;
  // 获取文件名称
  let fileName: string = urlPart.split('/')[length - 1];
  Logger.info(`fileName:${JSON.stringify(fileName)}`);
  // 解压的配置参数
  let options: zlib.Options = {
    level: zlib.CompressLevel.COMPRESS_LEVEL_DEFAULT_COMPRESSION
  };
  // 对图片、视频的路径进行处理
  Logger.info(`workerPort media filePath ${inFilePath}`);
  // 执行下载操作
  request.downloadFile(context, {
    url: mediaDataUrl,
    filePath: inFilePath

  }).then((downloadTask) => {
    downloadTask.on('progress', (receivedSize: number, totalSize: number) => {
      Logger.info(`receivedSize:${receivedSize},totalSize:${totalSize}`);
    });
    downloadTask.on('complete', () => {
      // 下载完成之后执行解压操作
      zlib.decompressFile(inFilePath, filesDir, options).then(() => {
        let videoPath: string = `${filesDir}/${fileName}.mp4`;
        workerPort.postMessage({ isComplete: true, filePath: videoPath });
        Logger.info('complete end');
      });
    });
    downloadTask.on('fail', () => {
      Logger.info('download fail');
    });
  }).catch((err) => {
    Logger.info(`Invoke downloadTask failed, code is ${err.code}, message is ${err.message}`);
  });
};