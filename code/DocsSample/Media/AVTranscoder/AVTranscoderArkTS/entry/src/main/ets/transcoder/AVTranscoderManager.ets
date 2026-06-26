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
// [Start headerFile]
import { media } from '@kit.MediaKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { common } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
// [End headerFile]

// [Start AVTranscoderDemo]
export class AVTranscoderDemo {
  private avTranscoder: media.AVTranscoder | undefined = undefined;
  private context: Context | undefined;
  private currentProgress: number = 0;
  constructor(context: Context | undefined) {
    if (context != undefined) {
      this.context = context;
    }
  }
  // [StartExclude AVTranscoderDemo]
  // [Start createTranscoderConfig]
  private avConfig: media.AVTranscoderConfig = {
    audioBitrate: 100000, // 音频比特率。
    audioCodec: media.CodecMimeType.AUDIO_AAC, // 音频编码格式。
    fileFormat: media.ContainerFormatType.CFT_MPEG_4, // 封装格式。
    videoBitrate: 200000, // 视频比特率。
    videoCodec: media.CodecMimeType.VIDEO_AVC, // 视频编码格式。
  };
  // [End createTranscoderConfig]

  // [Start createCallback]
  // 注册avTranscoder回调函数。
  setAVTranscoderCallback() {
    if (canIUse('SystemCapability.Multimedia.Media.AVTranscoder')) {
      if (this.avTranscoder != undefined) {
        // 转码完成回调函数。
        this.avTranscoder.on('complete', async () => {
          console.log(`AVTranscoder is completed`);
          await this.releaseTranscoderingProcess();
        });
        // 错误上报回调函数。
        this.avTranscoder.on('error', (err: BusinessError) => {
          console.error(`AVTranscoder failed, code is ${err.code}, message is ${err.message}`);
        });
        // 进度上报回调函数
        this.avTranscoder.on('progressUpdate', (progress: number) => {
          console.info(`AVTranscoder progressUpdate = ${progress}`);
          this.currentProgress = progress;
        })
      }
    }
  }
  // [StartExclude createCallback]

  // 开始转码对应的流程。
  async startTranscoderingProcess() {
    if (canIUse('SystemCapability.Multimedia.Media.AVTranscoder')) {
      if (this.avTranscoder != undefined) {
        await this.avTranscoder.release();
        this.avTranscoder = undefined;
      }
      // [Start createInstance]
      // 1.创建转码实例。
      this.avTranscoder = await media.createAVTranscoder();
      // [End createInstance]
      this.setAVTranscoderCallback();
      // 2.获取转码源文件fd和目标文件fd赋予avTranscoder；参考FilePicker文档。
      if (this.context != undefined) {
        // [Start createFdsrc]
        try {
          // 获取输入文件fd，H264_AAC.mp4为rawfile目录下的预置资源，需要开发者根据实际情况进行替换。
          let fileDescriptor = await this.context.resourceManager.getRawFd('H264_AAC.mp4');
          this.avTranscoder.fdSrc = fileDescriptor;
        } catch (error) {
          console.error('Failed to get the file descriptor, please check the resource and path.');
        }
        // [End createFdsrc]
        // [Start createFddst]
        let outputFilePath = this.context.filesDir + '/output.mp4';
        let file = fs.openSync(outputFilePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
        this.avTranscoder.fdDst = file.fd;
        // [End createFddst]
        this.currentProgress = 0;
      }
      //[Start doPrepare]
      // 3.配置转码参数完成准备工作。
      await this.avTranscoder.prepare(this.avConfig);
      //[End doPrepare]
      //[Start doStart]
      // 4.开始转码。
      await this.avTranscoder.start();
      //[End doStart]
    }
  }

  //[Start doPause]
  // 暂停转码对应的流程。
  async pauseTranscoderingProcess() {
    if (canIUse('SystemCapability.Multimedia.Media.AVTranscoder')) {
      if (this.avTranscoder != undefined) { // 仅在调用start返回后调用pause为合理调用。
        await this.avTranscoder.pause();
      }
    }
  }
  //[End doPause]

  //[Start doResume]
  // 恢复对应的转码流程。
  async resumeTranscoderingProcess() {
    if (canIUse('SystemCapability.Multimedia.Media.AVTranscoder')) {
      if (this.avTranscoder != undefined) { // 仅在调用pause返回后调用resume为合理调用。
        await this.avTranscoder.resume();
      }
    }
  }
  //[End doResume]

  //[Start doRelease]
  // 释放转码流程。
  async releaseTranscoderingProcess() {
    if (canIUse('SystemCapability.Multimedia.Media.AVTranscoder')) {
      if (this.avTranscoder != undefined) {
        // 1.释放转码实例。
        await this.avTranscoder.release();
        let lastFdDst = this.avTranscoder.fdDst;
        let lastFdSrc = this.avTranscoder.fdSrc;
        this.avTranscoder = undefined;
        // 2.关闭转码目标文件fd。
        if (lastFdDst != undefined) {
          fs.closeSync(lastFdDst);
        }
        if (lastFdSrc != undefined) {
          fs.closeSync(lastFdSrc.fd);
        }
      }
    }
  }
  //[End doRelease]

  // [EndExclude createCallback]
  // 获取当前进度
  getCurrentProgress(): number {
    console.info(`getCurrentProgress = ${this.currentProgress}`);
    return this.currentProgress;
  }
  // [End createCallback]

  // [Start transcoderProcess]
  // 一个完整的【开始转码-暂停转码-恢复转码-转码完成】示例。
  async avTranscoderDemo() {
    await this.startTranscoderingProcess(); // 开始转码。
    await this.pauseTranscoderingProcess(); //暂停转码。
    await this.resumeTranscoderingProcess(); // 恢复转码。
  }
  // [End transcoderProcess]
  // [EndExclude AVTranscoderDemo]
}
// [End AVTranscoderDemo]
