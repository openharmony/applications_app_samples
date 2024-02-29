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
import worker, { MessageEvents } from '@ohos.worker';
import { IconItem } from './IconView';
import { IconItemSource } from './IconItemSource';

@Component
export struct WorkerUsage {
  @State iconItemSourceList: IconItemSource[] = [];
  private workerInstance: worker.ThreadWorker | undefined = undefined;

  aboutToAppear() {
    for (let index = 0; index < 20; index++) {
      const numStart: number = index * 6;
      // 此处循环使用6张图片资源
      this.iconItemSourceList.push(new IconItemSource($r('app.media.nearby'), `item${numStart + 1}`));
      this.iconItemSourceList.push(new IconItemSource($r('app.media.scan'), `item${numStart + 2}`));
      this.iconItemSourceList.push(new IconItemSource($r('app.media.shop'), `item${numStart + 3}`));
      this.iconItemSourceList.push(new IconItemSource($r('app.media.cards'), `item${numStart + 4}`));
      this.iconItemSourceList.push(new IconItemSource($r('app.media.album'), `item${numStart + 5}`));
      this.iconItemSourceList.push(new IconItemSource($r('app.media.applet'), `item${numStart + 6}`));
    }
    if (this.workerInstance !== undefined) {
      this.workerInstance.onmessage = (e: MessageEvents): void => {
        if (e.data instanceof Array) {
          this.iconItemSourceList = e.data;
        }
      }
    }

  }

  build() {
    Column() {
      // 顶部导航栏
      Row() {
        Image($r("app.media.back"))
          .height(24)
          .width(24)
          .onClick(() => {
            router.back();
          })

        Text($r('app.string.scenario_4'))
          .fontSize(24)
          .lineHeight(30)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Start)
          .margin({
            left: 16
          })
      }
      .width($r('app.string.percent_100'))
      .height(50)
      .justifyContent(FlexAlign.Start)
      .padding({
        left: 24
      })

      Button($r('app.string.change_image_number'), { type: ButtonType.Normal, stateEffect: true })
        .fontSize(14)
        .borderRadius(8)
        .backgroundColor(Color.Blue)
        .width(250)
        .height(60)
        .margin({
          top: 30
        })
        .onClick(() => {
          if (this.workerInstance !== undefined) {
            this.workerInstance.postMessage(this.iconItemSourceList);
          }
        })
      if (this.iconItemSourceList.length > 0) {
        List({ space: 20 }) {
          ForEach(this.iconItemSourceList, (item: IconItemSource) => {
            ListItem() {
              IconItem({ image: item.image, text: item.text });
            }
          }, (item: IconItemSource, index) => index.toString())
        }
        .divider({ strokeWidth: 2, startMargin: 20, endMargin: 20 }) // 每行之间的分界线
        .width($r('app.string.percent_100'))
        .height($r('app.string.percent_100'))
        .layoutWeight(1)
      }
    }
    .width($r('app.string.percent_100'))
    .height($r('app.string.percent_100'))
    .alignItems(HorizontalAlign.Center)
  }
}