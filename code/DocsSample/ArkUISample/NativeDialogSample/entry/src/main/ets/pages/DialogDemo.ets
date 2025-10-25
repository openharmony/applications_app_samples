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
      Button($r('app.string.return_dialog'))
        .height(25)
        .width('10%')
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({url: 'pages/Index'});
          testNapi2.disposeController();
          testNapi2.disposeOption();
          testNapi2.disposeLifecycle();
        })
      Button($r('app.string.dialog_controller_demo'))
        .height(50)
        .width('85%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          testNapi2.mainPageController(this.nodeContent);
        })
      Button($r('app.string.dialog_option_demo'))
        .height(50)
        .width('85%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          testNapi2.mainPageController(this.nodeContent);
        })
      Button($r('app.string.dialog_lifecycle_demo'))
        .height(50)
        .width('85%')
        .margin({ top: 20, bottom: 10 })
        .onClick(() => {
          testNapi2.mainPageController(this.nodeContent);
        })
      ContentSlot(this.nodeContent);
    }
    .width('100%')
  }
}