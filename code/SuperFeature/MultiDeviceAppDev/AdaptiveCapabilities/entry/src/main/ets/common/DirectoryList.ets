/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router'

class DirectoryItem {
  title: Resource | string = '';
  uri: string = '';
  id: string = '';
}

@Component
struct DirectoryList {
  private directory: DirectoryItem[]=[];
  private title?: Resource;

  build() {
    Scroll() {
      Column() {
        Text(this.title)
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .height(100);

        ForEach(this.directory, (item : DirectoryItem) => {
          Button(item.title)
          .id(item.id)
          .fontSize(20)
          .width('90%')
          .height(55)
          .margin(12)
          .backgroundColor('#007DFF')
          .onClick(() => {
            router.pushUrl({
              url: item.uri
            })
          });
        },(item:DirectoryItem)=>JSON.stringify(item));
      }
    }
    .width('100%')
    .padding({left: 10, right: 10, bottom: 100});
  }
}

export { DirectoryItem, DirectoryList }