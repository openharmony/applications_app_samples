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

// [Start execute_task]
import { taskpool } from '@kit.ArkTS';
import { IconItemSource } from './IconItemSource';
import { loadPicture } from './IndependentTask';

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
            let iconItemSourceList: IconItemSource[] = [];
            // 创建Task
            let lodePictureTask: taskpool.Task = new taskpool.Task(loadPicture, 30);
            // 执行Task，并返回结果
            taskpool.execute(lodePictureTask).then((res: object) => {
              // loadPicture方法的执行结果
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
// [End execute_task]
