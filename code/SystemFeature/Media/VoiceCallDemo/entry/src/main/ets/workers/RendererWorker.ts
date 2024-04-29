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
import worker, { MessageEvents } from '@ohos.worker';
import AudioRendererHelper from '../audio/AudioRendererHelper';
import Constants from '../Constants';
import Logger from '../utils/Logger';

let parent = worker.workerPort;
let mRenderer: AudioRendererHelper = new AudioRendererHelper();

// 处理来自主线程的消息
parent.onmessage = (message:MessageEvents) => {
  Logger.info(`mAudioRenderer onmessage: ${message.data.code}`);
  let messageId: number = message.data.code;
  if (messageId === Constants.WORK_MESSAGE_RENDERER_START) {
    //开始录音
    start();
  } else if (messageId === Constants.WORK_MESSAGE_RENDERER_STOP) {
    //结束录音
    stop();
  } else if (messageId === Constants.WORK_MESSAGE_RENDERER_RECV) {
    //渲染
    let buffer: ArrayBuffer = message.data.buffer;
    mRenderer.write(buffer);
  }
};

async function start(): Promise<void> {
  await mRenderer.init();
  await mRenderer.start();
}

async function stop(): Promise<void> {
  await mRenderer.stop();
  await mRenderer.release();
}