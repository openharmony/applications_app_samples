/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import image from '@ohos.multimedia.image';
import taskpool from '@ohos.taskpool';
import { BusinessError, Callback } from '@ohos.base';
import util from '@ohos.util';
import Logger from './LoggerUtils';
import { execColorInfo } from './PixelUtil';

/**
 * 根据参数由TaskPool处理pixelMap
 * @param pixelMap 源数据
 * @param lastAdjustData 之前的饱和度值
 * @param currentAdjustData 将要调整到饱和度值
 * @param taskNum 开启的线程任务数
 * @param isParamsByTransfer 参数是否通过传递方式传参
 * @param callback 线程处理结束后的回调
 * @returns
 */
export async function pixelMapProcessByTaskPool(pixelMap: image.PixelMap, lastAdjustData: number, currentAdjustData: number, taskNum: number, isParamsByTransfer: boolean, callback?: Callback<ArrayBuffer>): Promise<void> {
  let arrayBuffer: ArrayBuffer = await convertPixelMapToArrayBuffer(pixelMap);
  let taskPoolGroup: taskpool.TaskGroup = new taskpool.TaskGroup();
  for (let i: number = 0; i < taskNum; i++) {
    let arrayBufferSlice: ArrayBuffer = arrayBuffer.slice(arrayBuffer.byteLength / taskNum * i, arrayBuffer.byteLength / taskNum * (i + 1));
    taskPoolGroup.addTask(createImageTask(arrayBufferSlice, lastAdjustData, currentAdjustData, isParamsByTransfer));
  }
  let start: number = new Date().getTime();
  taskpool.execute(taskPoolGroup).then((data: Object[]) => {
    if (callback !== undefined) {
      let end: number = new Date().getTime();
      AppStorage.set<String>('timeCost', util.format('%s s', ((end - start) / 1000).toFixed(2).toString()));
      callback(concatenateArrayBuffers(data as ArrayBuffer[]));
    }
  }).catch((e: BusinessError) => {
    Logger.error(e.message);
  })
}

async function convertPixelMapToArrayBuffer(pixelMap: image.PixelMap): Promise<ArrayBuffer> {
  let arrayBuffer: ArrayBuffer = new ArrayBuffer(pixelMap.getPixelBytesNumber());
  await pixelMap.readPixelsToBuffer(arrayBuffer);
  return arrayBuffer;
}

function createImageTask(arrayBuffer: ArrayBuffer, lastAdjustData: number, currentAdjustData: number, isParamsByTransfer: boolean): taskpool.Task {
  let task: taskpool.Task = new taskpool.Task(adjustImageValue, arrayBuffer, lastAdjustData, currentAdjustData);
  if (!isParamsByTransfer) {
    task.setTransferList([]);
  }
  return task;
}

@Concurrent
function adjustImageValue(arrayBuffer: ArrayBuffer, lastAdjustData: number, currentAdjustData: number): ArrayBuffer {
  return execColorInfo(arrayBuffer, lastAdjustData, currentAdjustData);
}

function concatenateArrayBuffers(arrayBuffers: ArrayBuffer[]): ArrayBuffer {
  let totalLen: number = 0;
  arrayBuffers.forEach((array: ArrayBuffer) => {
    totalLen += array.byteLength;
  })

  let res: Uint8Array = new Uint8Array(totalLen);
  let offset: number = 0;
  arrayBuffers.forEach((arrayBuffer: ArrayBuffer) => {
    let uint8Arr: Uint8Array = new Uint8Array(arrayBuffer);
    res.set(uint8Arr, offset);
    offset += arrayBuffer.byteLength;
  })
  return res.buffer;
}
