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

import resource from '../../common/resource';

@Entry
@Component
struct styled_string_demo1 {
  styledString1: StyledString = new StyledString(resource.resourceToString($r('app.string.CreateApply_Text_1')));
  mutableStyledString1: MutableStyledString = new MutableStyledString(resource.resourceToString($r('app.string.CreateApply_Text_2')));
  controller1: TextController = new TextController();
  controller2: TextController = new TextController();

  async onPageShow() {
    // 在生命周期onPageShow回调中绑定属性字符串
    this.controller1.setStyledString(this.styledString1);
  }

  build() {
    Column() {
      // 显示属性字符串
      Text(undefined, { controller: this.controller1 })
      Text(undefined, { controller: this.controller2 })
        .onAppear(() => {
          // 在组件onAppear回调中绑定属性字符串
          this.controller2.setStyledString(this.mutableStyledString1);
        })
    }
    .width('100%')
  }
}