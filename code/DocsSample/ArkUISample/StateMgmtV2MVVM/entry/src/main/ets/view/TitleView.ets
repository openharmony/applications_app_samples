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

// src/main/ets/view/TitleView.ets

@ComponentV2
export default struct TitleView {
  @Param tasksUnfinished: number = 0;

  build() {
    Column() {
      Text($r('app.string.TodoList_title'))
        .fontSize(40)
        .margin(10)
      Text(`${getContext(this).resourceManager.getStringSync($r('app.string.Unfinish_count').id)}：${this.tasksUnfinished}`)
        .margin({ left: 10, bottom: 10 })
    }
  }
}