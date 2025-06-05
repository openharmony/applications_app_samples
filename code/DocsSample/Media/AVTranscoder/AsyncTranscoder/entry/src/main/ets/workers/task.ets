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
import { ErrorEvent, MessageEvents, ThreadWorkerGlobalScope, worker } from '@kit.ArkTS';
import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import fs from '@ohos.file.fs';
import { SendableObject } from '../util/SendableObject';
import { common, sendableContextManager } from '@kit.AbilityKit';

const workerPort: ThreadWorkerGlobalScope = worker.workerPort;

workerPort.onmessage = async (event: MessageEvents) => {
  console.info(`onmessage in`);
  //worker线程接收参数
  const sendableObject: SendableObject = event.data;
  const sendableContext: sendableContextManager.SendableContext =
    sendableObject.getSendableContext() as sendableContextManager.SendableContext;
  const context: common.Context =
    sendableContextManager.convertToContext(sendableContext) as common.Context;
  //执行转码逻辑
  await doSome(context);
  // 向主线程发送消息
  workerPort.postMessage('start end');
};

workerPort.onmessageerror = (event: MessageEvents) => {
  console.info('workerPort onmessageerror');
};

workerPort.onerror = (event: ErrorEvent) => {
  console.info('workerPort onerror err is: ', event.message);
};

async function doSome(context: common.Context) {
  console.info(`doSome in`);
  try {
    let transcoder = await media.createAVTranscoder();
    // 转码完成回调函数
    transcoder.on('complete', async () => {
      console.info(`transcode complete`);
      fs.closeSync(transcoder.fdDst);
      await transcoder?.release()
      // 向主线程发送转码结束的消息
      workerPort.postMessage('complete');
    })
    // 转码错误回调函数
    transcoder.on('error', async (err: BusinessError) => {
      fs.closeSync(transcoder.fdDst);
      await transcoder?.release();
    })
    // 转码进度更新
    transcoder.on('progressUpdate', (progress: number) => {
      console.info(`AVTranscoder progressUpdate = ${progress}`);
      workerPort.postMessage(progress);
    })
    try {
      // 获取输入文件fd，3.mkv为rawfile目录下的预置资源，需要开发者根据实际情况进行替换。
      let fileDescriptor = await context.resourceManager.getRawFd('H264_AAC.mp4');
      transcoder.fdSrc = fileDescriptor;
    } catch (error) {
      console.error('Failed to get the file descriptor, please check the resource and path.');
    }
    let fdPath = context.filesDir + '/' + 'VID_' + Date.parse(new Date().toString()) + '.mp4';
    let file = fs.openSync(fdPath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
    let fd = file.fd;
    console.info(`file fd ${fd}`);
    transcoder.fdDst = file.fd;

    let config: media.AVTranscoderConfig = {
      fileFormat: media.ContainerFormatType.CFT_MPEG_4,
      audioCodec: media.CodecMimeType.AUDIO_AAC,
      videoCodec: media.CodecMimeType.VIDEO_AVC,
      videoBitrate: 200000,
    }
    await transcoder?.prepare(config);
    await transcoder?.start();
  } catch (e) {
    console.error(`transcode error: code = ` + e.code.toString() + `, message = ${JSON.stringify(e.message)}`);
  }
}
