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

import { taskpool } from '@kit.ArkTS';
import testNapi, { IHEIFInfo } from 'libdecodeheifimage.so';
import { WaterFlowDataSource, ImageInfo } from './WaterFlowData';

@Concurrent
export function decodeHeifImage(url: string): IHEIFInfo {
  const result = testNapi.decodeHeifImageFromInternet(url);
  return result;
}

/**
 * 获取taskpool异步任务列表
 * @param urls 图片资源链接数组
 * @returns taskpool.Task[]
 */
export function getTasks(urls: string[]): taskpool.Task[] {
  const tasks: taskpool.Task[] = [];
  for (let i = 0; i < urls.length; i++) {
    tasks.push(new taskpool.Task(decodeHeifImage, urls[i]));
  }
  return tasks;
}

/**
 * 执行taskpool异步任务列表中的每一个任务
 * @param urls 图片资源链接数组
 * @param dataSource 瀑布流数据操作实例
 */
export function executeTasks(urls: string[], dataSource: WaterFlowDataSource) {
  const tasks = getTasks(urls);
  for (let i = 0; i < tasks.length; i++) {
    taskpool.execute(tasks[i], taskpool.Priority.HIGH)
      .then(result => {
        const imageInfo = result as ImageInfo;
        if (result !== null) {
          dataSource.addData(i, new ImageInfo(imageInfo.data, imageInfo.width, imageInfo.height, `image${i + 1}.heic`));
        }
      })
      .catch((err: Error) => {
        console.error(JSON.stringify(err))
      })
  }
}