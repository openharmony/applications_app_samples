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
import { HashSet, taskpool } from '@kit.ArkTS';
import { MLog } from '../utils/MLog';
import { common } from '@kit.AbilityKit';
import { FileAccessManager } from './FileAccessManager';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { FileBean } from '../../component/bean/FileBean';
import { FileIoManager } from './FileIoManager';
import fileUtil from '../utils/FileUtil';
import { media } from '@kit.MediaKit';
import { fileIo } from '@kit.CoreFileKit';
import { DEFAULT_TIME_US } from '../Constants';

const TAG = 'FileTaskPool';
const TAG_EXECUTE = 'TAG_EXECUTE';
const TAG_CANCEL = 'TAG_CANCEL';
const TAG_PROGRESS = 'TAG_PROGRESS';
const TAG_FINISH = 'TAG_FINISH';

export class FileTaskPool {
  private task: taskpool.LongTask;
  private progressCall?: (progress: number, progressOne?: string, result?: string) => void;
  private finishCall?: (result: Map<string, string>) => void;

  constructor(context: common.UIAbilityContext, src: FileBean[], dest: string, isMove: boolean = false) {
    let arr = src.map(it => new FileTaskBean(it, dest, isMove));

    this.task = new taskpool.LongTask(fileTaskRun, context, arr);
    emitter.on(TAG_EXECUTE, this.executeFun);
    emitter.on(TAG_FINISH, this.finishFun);
    emitter.on(TAG_PROGRESS, this.progressFun);

  }


  private executeFun = () => {
    MLog.print(TAG, `task executeFun:${this.task.arguments}`);
    taskpool.execute(this.task).then(() => {
      MLog.print(TAG, `task execute success!`);
      emitter.emit(TAG_FINISH);
    });
  };
  private finishFun = (data: emitter.EventData) => {
    MLog.print(TAG,
      `task finish totalDuration:${this.task.totalDuration} ioDuration:${this.task.ioDuration} cpuDuration:${this.task.cpuDuration}`);
    if (data.data?.listBean) {
      MLog.print(TAG, `task finish listBean:${JSON.stringify(data.data?.listBean)}`);
    }
    if (this.finishCall) {
      this.finishCall(data.data?.listBean);
    }
  };
  private progressFun = (data: emitter.EventData) => {
    MLog.print(TAG, `progressFun data:${JSON.stringify(data)}`);
    if (this.progressCall) {
      this.progressCall(data.data?.progress, data.data?.progressOne, data.data?.taskResult);
    }
  };

  setProgressFun(progressCall: (progress: number) => void) {
    this.progressCall = progressCall;
  }

  run() {
    emitter.emit(TAG_EXECUTE);
  }

  cancel() {
    taskpool.cancel(this.task);
    emitter.emit(TAG_FINISH);
  }

  setFinishCall(finishCall?: (result: Map<string, string>) => void) {
    this.finishCall = finishCall;
  }

  release() {
    emitter.off(TAG_EXECUTE);
    emitter.off(TAG_CANCEL);
    emitter.off(TAG_PROGRESS);
    emitter.off(TAG_FINISH);
    taskpool.terminateTask(this.task);
  }
}

@Concurrent
async function fileTaskRun(context: common.Context, taskBeanList: FileTaskBean[]): Promise<string> {
  let tag = 'FileTaskRun';
  try {
    MLog.print(tag, `task execute CopyFileTask! context:${context} taskBeanList:${taskBeanList.length}`);
    let num: number | string = -1;
    for (let k = 0; k < taskBeanList.length; k++) {
      if (taskpool.Task.isCanceled()) {
        MLog.print(tag, `task execute Canceled!`);
        return 'canceled';
      }
      let taskBean = taskBeanList[k];
      MLog.print(tag, `task execute k:${k} `);
      num = -1;
      MLog.print(tag, `start taskBean:${JSON.stringify(taskBean)}`);
      if (taskBean.srcUri === taskBean.destFolderUri) {
        continue;
      }
      MLog.print(tag,
        `copy srcName:${taskBean.srcName} srcUri:${taskBean.srcUri} destFolderUri:${taskBean.destFolderUri} srcRelativePath:${taskBean.srcRelativePath}`);
      num = await FileIoManager.copy(taskBean.srcUri, taskBean.destFolderUri, (progress) => {
        let p = ((progress.processedSize / progress.totalSize) * 100).toFixed(2);
        MLog.print(tag, `copy src:${taskBean.srcUri} progress:${p}=${progress.processedSize}/${progress.totalSize}`);
        emitter.emit('TAG_PROGRESS', { data: { progress: k, progressOne: p } });
      })
        .then(result => {
          MLog.print(tag, `copy src:${taskBean.srcUri} dest:${taskBean.destFolderUri} result:${result}`);
          return 0;
        })
        .catch((err: BusinessError) => {
          MLog.printError(tag, 'copyOne', err);
          return `[${err?.code}] ${err?.message}`;
        });
      if (num === 0 && taskBean.isMove) {
        num = await FileAccessManager.getIns(context)
          .deleteOne(taskBean.srcName, taskBean.srcUri, taskBean.isMedia)
          .then((result) => {
            MLog.print(tag,
              `is move del srcName:${taskBean.srcName} srcUri:${taskBean.srcUri} result:${result}`);
            return result;
          })
          .catch((err: BusinessError) => {
            MLog.printError(tag, 'is move del err', err);
            return `[${err?.code}] ${err?.message}`;
          });
      }
      if (num !== 0) {
        taskBean.taskResult = typeof num == 'number' ? `Code:${num}` : num;
      }
      emitter.emit('TAG_PROGRESS', { data: { progress: k + 1, taskResult: taskBean.taskResult } });
    }
  } catch (err) {
    MLog.printError(tag, `execute err!`, err);
  }
  return 'finish';
}

@Concurrent
export async function getVideoThumb(cacheDir: string, uri: string, thumbWidth: number,
  thumbHeight: number): Promise<string> {
  const tag = 'getVideoThumb';
  // 处理带中文路径的uri
  const decodedUri = decodeURIComponent(uri);
  MLog.log(tag, `Original uri: ${uri}, decoded uri: ${decodedUri}`);
  const videoPath = decodedUri.replace('file://', '');
  const imageName = `${fileUtil.getFileName(videoPath)}.thumb`;
  const newPath = cacheDir + imageName;
  MLog.log(tag, `Generated thumbnail path: ${newPath} for video: ${videoPath}`);
  let thumbExist = false;
  try {
    thumbExist = await fileIo.access(newPath);
    if (thumbExist) {
      const stat = await fileIo.stat(newPath);
      thumbExist = stat.size > 0;
      MLog.log(tag, `path = ${newPath}, exist = ${thumbExist}, size = ${stat.size}`);
    }
  } catch (e) {
    thumbExist = false;
  }
  if (thumbExist) {
    return newPath;
  }
  // 创建视频缩略图
  let avImageGenerator: media.AVImageGenerator | undefined = undefined;
  let videoFile: fileIo.File | undefined = undefined;
  let thumbnail: PixelMap | undefined = undefined;
  try {
    videoFile = fileIo.openSync(uri);
    avImageGenerator = await media.createAVImageGenerator();
    avImageGenerator.fdSrc = videoFile;
    // 缩略图在视频中的时间点(μs)
    let timeUs: number = DEFAULT_TIME_US;
    // 选取传入时间点或之后的关键帧
    let queryOption: media.AVImageQueryOptions = media.AVImageQueryOptions.AV_IMAGE_QUERY_NEXT_SYNC;
    let param: media.PixelMapParams = {
      width: thumbWidth,
      height: thumbHeight,
    };
    thumbnail = await avImageGenerator.fetchFrameByTime(timeUs, queryOption, param);
    if (!thumbnail) {
      throw new Error('AVImageGenerator returned empty thumbnail');
    }
    MLog.info(tag, `Thumbnail generated successfully, saving to: ${newPath}`);
    // 保存缩略图
    await fileUtil.savePixelMap(thumbnail, newPath);
  } catch (err) {
    MLog.error(tag, `createVideoThumbnail is failed, path = ${newPath} , err = ${JSON.stringify(err)}`);
  } finally {
    if (avImageGenerator) {
      avImageGenerator.release();
    }
    if (videoFile) {
      fileIo.closeSync(videoFile);
    }
  }
  return newPath;
}

class FileTaskBean {
  public srcUri: string;
  public srcName: string;
  public srcRelativePath: string;
  public destFolderUri: string;
  public isMove: boolean = false;
  public isMedia: boolean = false;
  public taskResult: string = '';

  constructor(src: FileBean, destUri: string, isMove?: boolean) {
    this.srcUri = src.getPath();
    this.srcName = src.name;
    this.srcRelativePath = src.relativePath;
    this.isMedia = src.isMediaFile();
    if (src.isDir()) {
      this.destFolderUri = destUri;
    } else {
      this.destFolderUri = `${destUri}/${this.srcUri.substring(this.srcUri.lastIndexOf('/') + 1)}`;
    }
    if (isMove && this.srcUri != this.destFolderUri) {
      this.isMove = isMove;
    }

  }
}
