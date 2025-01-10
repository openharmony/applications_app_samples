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

@Entry
@Component
struct Index {
  private pageName: string [] = ['Location', 'Paste', 'Save'];
  @State text: string = '';

  openPage(pageName: string) {
    router.pushUrl({
      url: 'securitycomponent/pages/' + pageName,
    });
  }

  build() {
    Column() {
      ForEach(this.pageName, (item: string) => {
        Button() {
          Text(item + this.text)
            .fontSize(19)
            .fontColor(Color.White)
            .fontWeight(FontWeight.Bold)
            .padding({ left: 10, right: 10 })
            .width('80%')
            .textAlign(TextAlign.Center)
        }
        .id(item)
        .height(40)
        .type(ButtonType.Capsule)
        .backgroundColor('#0D9FFB')
        .margin({ top: 20 })
        .onClick(() => {
          this.openPage(item);
        })
      }, (item: string) => JSON.stringify(item))
    }
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .width('100%')
    .height('100%')
  }
}