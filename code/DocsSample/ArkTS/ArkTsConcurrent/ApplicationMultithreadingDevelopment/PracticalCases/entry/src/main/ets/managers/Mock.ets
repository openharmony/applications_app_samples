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

// [Start query_database_return_main_thread]
import { taskpool } from '@kit.ArkTS';
import { fillImg } from './WaterfallRendering';

@Concurrent
function query() {
  console.info('TaskPoolTest-this is query');
  let result = new Array<string>(33);
  for (let i = 0; i < 33; i++) {
    result[i] = 'Image' + i;
  }
  taskpool.Task.sendData(result);
}

export function getImgFromDB() {
  //此处模拟查询数据库，并返回数据
  let task = new taskpool.Task(query);
  task.onReceiveData(fillImg);
  taskpool.execute(task);
}
// [End query_database_return_main_thread]