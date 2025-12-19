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

import router from '@ohos.router';
import testNapi2 from 'libnativerender.so';
import { common } from '@kit.AbilityKit';
import { NodeContent } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  nodeContent: NodeContent = new NodeContent();

  build() {
    Column() {
      // 请将$r('app.string.return_dialog')替换为实际资源文件，在本示例中该资源文件的value值为"返回"
      Button($r('app.string.return_dialog'))
        .height(25)
        .width('10%')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({url: 'pages/Index'});
          testNapi2.disposeController();
          testNapi2.disposeOption();
          testNapi2.disposeOptionText();
          testNapi2.disposeLifecycle();
        })
      // 请将$r('app.string.close_app')替换为实际资源文件，在本示例中该资源文件的value值为"DialogController demo"
      Button($r('app.string.dialog_controller_demo'))
        .height(30)
        .width('85%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          testNapi2.mainPageController(this.nodeContent);
        })
      // 请将$r('app.string.dialog_option_demo')替换为实际资源文件，在本示例中该资源文件的value值为"DialogOption demo"
      Button($r('app.string.dialog_option_demo'))
        .height(30)
        .width('85%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          testNapi2.mainPageOption(this.nodeContent);
        })
      // 请将$r('app.string.dialog_optionText_demo')替换为实际资源文件，在本示例中该资源文件的value值为"Text Option demo"
      Button($r('app.string.dialog_optionText_demo'))
        .height(30)
        .width('85%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          testNapi2.mainPageOptionText(this.nodeContent);
        })
      // 请将$r('app.string.dialog_lifecycle_demo')替换为实际资源文件，在本示例中该资源文件的value值为"Dialog lifecycle demo"
      Button($r('app.string.dialog_lifecycle_demo'))
        .height(25)
        .width('85%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          testNapi2.mainPageLifecycle(this.nodeContent);
        })
      ContentSlot(this.nodeContent);
    }
    .width('100%')
  }
}