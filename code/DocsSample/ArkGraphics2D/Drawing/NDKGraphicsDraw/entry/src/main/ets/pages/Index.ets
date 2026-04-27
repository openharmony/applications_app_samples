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

interface Item {
  text: string;
}


const operationUrls: string[] = [
  'drawing/pages/CanvasGetResult',
  'drawing/pages/CanvasOperationState',
  'drawing/pages/BasicEffect',
  'drawing/pages/ComplexEffect',
  'drawing/pages/ShapeDrawing',
  'drawing/pages/PixelMapDrawing',
  'drawing/pages/TextBlockDrawing'
];

@Entry
@Component
struct Index {
  ResourceToString(resId: number): string {
    return this.getUIContext().getHostContext()!.resourceManager.getStringSync(resId);
  }

  async routePage(index: number) {
    let options: router.RouterOptions = {
      url: operationUrls[index]
    }
    this.getUIContext()
      .getRouter()
      .pushUrl(options)
      .then(() => {
        console.error(`pushUrl finish`);
      })
      .catch((err: ESObject) => {
        console.error(`pushUrl failed`);
      })
  }

  @State listItem: Item[] = [
    { text: this.ResourceToString($r('app.string.CanvasGetResult').id) },
    { text: this.ResourceToString($r('app.string.CanvasOperationState').id) },
    { text: this.ResourceToString($r("app.string.BasicEffect").id) },
    { text: this.ResourceToString($r('app.string.ComplexEffect').id) },
    { text: this.ResourceToString($r('app.string.Shape_Drawing').id) },
    { text: this.ResourceToString($r("app.string.PixelMap_Drawing").id) },
    { text: this.ResourceToString($r("app.string.TextBlock_Drawing").id) }
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
              this.routePage(index)
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
