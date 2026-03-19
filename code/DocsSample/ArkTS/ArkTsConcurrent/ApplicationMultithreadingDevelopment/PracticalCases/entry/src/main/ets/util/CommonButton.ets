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


@Component
export struct CommonButton {
  @State buttonName: string | ResourceStr = $r('app.string.uninitialized');
  @State buttonId: string = '';
  @State buttonUrl: string = '';
  @State data: string = '';

  build() {
    Text(this.buttonName)
      .id(this.buttonId)
      .padding(this.getUIContext().px2vp(5))
      .fontSize(this.getUIContext().px2fp(20))
      .width('45%')
      .height(36)
      .backgroundColor('#04a4fc')
      .fontColor(Color.White)
      .textAlign(TextAlign.Center)
      .borderRadius(15)
      .margin(this.getUIContext().px2vp(5))
      .onClick(() => {
        this.getUIContext().getRouter().pushUrl({
          url: this.buttonUrl,
          params: {
            text: this.data,
            buttonName: this.buttonName
          }
        });
      })
  }
}