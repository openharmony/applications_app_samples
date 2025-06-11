/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { Router } from '@ohos.arkui.UIContext';

export class HeadComponentController {
  public title?: Resource | string;
  public needBack: boolean = true;
}

@Component
export struct HeadComponent {
  @State controller: HeadComponentController = {
    title: '',
    needBack: true
  }
  private router = this.getUIContext().getRouter() as Router;

  build() {
    Row() {
      Column() {
        Flex({ alignItems: ItemAlign.Center }) {
          Image($r('app.media.ic_back'))
            .objectFit(ImageFit.Contain)
            .visibility(this.controller.needBack ? Visibility.Visible : Visibility.None)
            .width(21.8)
            .height(19.6)
            .onClick(() => {
              this.router.back()
            })
          Text(this.controller.title)
            .fontSize(20)
            .fontWeight(FontWeight.Bold)
            .margin({ left: 17.4 })

        }
        .height(60)
        .backgroundColor($r('sys.color.white'))
        .padding({ top: 13, bottom: 15, left: 28.3 })
      }
    }
    .height(60)
  }
}