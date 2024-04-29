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
import AudioCapturerHelper from '../audio/AudioCapturerHelper';
import Constants from '../Constants';
import Logger from '../utils/Logger';

let parent = worker.workerPort;
let mCapturer: AudioCapturerHelper = new AudioCapturerHelper();

// 处理来自主线程的消息
parent.onmessage = (message: MessageEvents) => {
  Logger.info(`mAudioCapturer message from worker: ${message.data.code}`);

  let messageId: number = message.data.code;
  if (messageId === Constants.WORK_MESSAGE_CAPTURER_START) {
    //开始录音
    start();
  } else if (messageId === Constants.WORK_MESSAGE_CAPTURER_STOP) {
    //结束录音
    stop();
  }
};

async function start(): Promise<void> {
  await mCapturer.init();
  await mCapturer.start((buffer: ArrayBuffer, size: number) => {
    parent.postMessage({
      'code': Constants.WORK_MESSAGE_CAPTURER_SEND,
      'buffer': buffer
    }, [buffer]);
  });
}

async function stop(): Promise<void> {
  await mCapturer.stop();
  await mCapturer.release();
}

