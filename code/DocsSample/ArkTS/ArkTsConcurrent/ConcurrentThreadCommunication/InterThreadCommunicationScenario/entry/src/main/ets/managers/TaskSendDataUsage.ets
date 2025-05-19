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

// [Start implement_child_thread_task]
// [Start receive_task_message]
import { taskpool } from '@kit.ArkTS';
import { IconItemSource } from './IconItemSource';
import resource from '../util/resource';

function notice(data: number): void {
  console.info(resource.resourceToString($r('app.string.Loading_pictures')), data);
}
// [End receive_task_message]

// 通过Task的sendData方法，即时通知宿主线程信息
@Concurrent
export function loadPictureSendData(count: number): IconItemSource[] {
  let iconItemSourceList: IconItemSource[] = [];
  // 遍历添加6*count个IconItem的数据
  for (let index = 0; index < count; index++) {
    const numStart: number = index * 6;
    // 此处循环使用6张图片资源
    iconItemSourceList.push(new IconItemSource('$media:startIcon', `item${numStart + 1}`));
    iconItemSourceList.push(new IconItemSource('$media:background', `item${numStart + 2}`));
    iconItemSourceList.push(new IconItemSource('$media:foreground', `item${numStart + 3}`));
    iconItemSourceList.push(new IconItemSource('$media:startIcon', `item${numStart + 4}`));
    iconItemSourceList.push(new IconItemSource('$media:background', `item${numStart + 5}`));
    iconItemSourceList.push(new IconItemSource('$media:foreground', `item${numStart + 6}`));

    taskpool.Task.sendData(iconItemSourceList.length);
  }
  return iconItemSourceList;
}

// [Start host_receive_task_data]
@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            let iconItemSourceList: IconItemSource[];
            let lodePictureTask: taskpool.Task = new taskpool.Task(loadPictureSendData, 30);
            // 设置notice方法接收Task发送的消息
            lodePictureTask.onReceiveData(notice);
            taskpool.execute(lodePictureTask).then((res: object) => {
              iconItemSourceList = res as IconItemSource[];
            })
            this.message = 'success';
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End host_receive_task_data]
// [End implement_child_thread_task]