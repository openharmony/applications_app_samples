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
import { IconItemSource } from './IconItemSource';
import { loadPicture } from './IndependentTask';

let iconItemSourceList: IconItemSource[][];

let taskGroup: taskpool.TaskGroup = new taskpool.TaskGroup();
taskGroup.addTask(new taskpool.Task(loadPicture, 30));
taskGroup.addTask(new taskpool.Task(loadPicture, 20));
taskGroup.addTask(new taskpool.Task(loadPicture, 10));
taskpool.execute(taskGroup).then((ret: object) => {
  let tmpLength = (ret as IconItemSource[][]).length
  for (let i = 0; i < tmpLength; i++) {
    for (let j = 0; j < ret[i].length; j++) {
      iconItemSourceList.push(ret[i][j]);
    }
  }
})
