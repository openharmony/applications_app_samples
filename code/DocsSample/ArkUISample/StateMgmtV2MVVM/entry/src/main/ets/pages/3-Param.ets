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
 *
*/

// src/main/ets/pages/3-Param.ets

@ComponentV2
struct TaskItem {
  @Param taskName: string = '';
  @Param @Once isFinish: boolean = false;

  build() {
    Row() {
      Image(this.isFinish ? $r('app.media.finished') : $r('app.media.unfinished'))
        .width(28)
        .height(28)
      Text(this.taskName)
        .decoration({ type: this.isFinish ? TextDecorationType.LineThrough : TextDecorationType.None })
    }
    .onClick(() => this.isFinish = !this.isFinish)
  }
}

@Entry
@ComponentV2
struct TodoList {
  build() {
    Column() {
      Text($r('app.string.TodoList_title'))
        .fontSize(40)
        .margin({ bottom: 10 })
      TaskItem({ taskName: 'Task 1', isFinish: false })
      TaskItem({ taskName: 'Task 2', isFinish: false })
      TaskItem({ taskName: 'Task 3', isFinish: false })
    }
  }
}