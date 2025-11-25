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

import { router } from '@kit.ArkUI';
import { ScrollModifier } from '@ohos.arkui.modifier';

class CustomModifier extends ScrollModifier {
}

@Entry
@Component
export struct ScrollModifierScroll {
  scroller: Scroller = new Scroller();
  private arr: number[] =
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25];
  customModifier: ScrollModifier = new CustomModifier()
    .scrollBar(BarState.On)
    .edgeEffect(EdgeEffect.Spring)
    .onWillStartDragging(() => {
      console.log('callback1 onWillStartDragging');
    })
    .onDidStopDragging((willFling: boolean) => {
      console.log('callback2 onDidStopDragging willFling = ' + willFling);
    })
    .onWillStopDragging((velocity: number) => {
      console.log('callback onWillStopDragging velocity = ' + velocity);
    })
    .onWillStartFling(() => {
      console.log('callback3 onWillStartFling');
    })
    .onDidStopFling(() => {
      console.log('callback4 onDidStopFling');
    })
    .backgroundColor(Color.Yellow)
    .height('90%')

  build() {
    NavDestination() {
      Column() {
        Row() {
          Scroll() {
            Column() {
              ForEach(this.arr, (item: number) => {
                Text(item.toString())
                  .width('90%')
                  .height(200)
                  .draggable(true)
                  .copyOption(CopyOptions.InApp)
                  .backgroundColor('#FFFFFF')
                  .borderWidth(1)
                  .borderColor(Color.Black)
                  .borderRadius(15)
                  .fontSize(16)
                  .textAlign(TextAlign.Center)
              }, (item: number) => item.toString())

            }.width('90%').backgroundColor('#DCDCDC')
          }.attributeModifier(this.customModifier)

          ScrollBar({ scroller: this.scroller, state: BarState.On }) {
            Text()
              .width(20)
              .height(100)
              .borderRadius(10)
              .backgroundColor('#C0C0C0')
          }
          .width(20)
        }
        .height('90%')

        Button('slide').onClick((event: ClickEvent) => {
          this.scroller.scrollTo({
            xOffset: this.scroller.currentOffset().xOffset,
            yOffset: this.scroller.currentOffset().yOffset + 100,
            animation: { duration: 500 }
          });
        })

        Button('flip').onClick(() => {
          router.pushUrl({
            url: 'pages/scroll/ScrollModifier/Scroll/ScrollIndex2',
            params: {
              data1: 'message'
            }
          });
        })
      }
    }
  }
}