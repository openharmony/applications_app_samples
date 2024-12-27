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

import router from '@ohos.router';

interface Item {
  text: string;
}


const operationUrls: string[] = [
  'pixelmap/pages/DecodeImages',
  'pixelmap/pages/TransformImages',
  'pixelmap/pages/ProcessPixelMapData',
  'pixelmap/pages/EncodeImages'
];

@Entry
@Component
struct Index {
  ResourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  @State listItem: Item[] = [
    { text: this.ResourceToString($r('app.string.Decode_Images')) },
    { text: this.ResourceToString($r('app.string.Transform_Images')) },
    { text: this.ResourceToString($r('app.string.Process_PixelMap_Data')) },
    { text: this.ResourceToString($r('app.string.Encode_Images')) }
  ]

  build() {
    Column() {
      List() {
        ForEach(this.listItem, (item: Item, index) => {
          ListItem() {
            Row() {
              Blank().width('4%')
              Text(item.text)
                .fontSize(16)
                .fontColor('black')
                .width('90%')
              Image($r('app.media.right'))
                .height(12)
                .width(12)
            }
            .onClick(() => {
              router.pushUrl({
                url: operationUrls[index]
              });
            })
            .border({ radius: 20 })
            .width('90%')
            .height('8%')
            .backgroundColor(Color.White)
            .margin({ top: 12, left: 15, right: 8 })
          }
        })
      }
      .height('90%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}