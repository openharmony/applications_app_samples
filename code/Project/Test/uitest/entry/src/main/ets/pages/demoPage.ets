/**
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
import router from '@system.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct ScrollExample {
  scroller: Scroller = new Scroller()
  private arr: number[] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]
  @State hoverText : string = 'jump'
  @State pressure : number = 0.0
  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text('MainPage')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
      Stack({ alignContent: Alignment.TopStart }) {
        Scroll(this.scroller) {
          Column() {
            Button('toast').fontSize(25).fontWeight(FontWeight.Bold)
              .onClick(() => {
                try {
                  promptAction.showToast({
                    message: 'toastShow',
                    duration: 60000
                  });
                } catch (error) {
                };
              })
            Button('dialog').fontSize(25).fontWeight(FontWeight.Bold)
              .onClick(() => {
                AlertDialog.show(
                  {
                    title: '',
                    message: 'dialogShow',
                    alignment: DialogAlignment.Bottom,
                    confirm: {
                      value: 'close',
                      action: () => {
                      }
                    }
                  }
                )
              })
            Button() {
              Text('next page')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .key('my-key')
            .type(ButtonType.Capsule)
            .margin({ top: 20 })
            .onClick(() => {
              router.push({ uri: 'pages/second' })
            })
            .gesture(
              LongPressGesture({ repeat: false })
                .onAction((event: GestureEvent) => {
                  router.push({ uri: 'pages/Fourth' })
                })
            )
            .gesture(
              LongPressGesture({ repeat: false, duration: 1800 })
                .onAction((event: GestureEvent) => {
                  router.push({ uri: 'pages/fourth' })
                })
            )
            Button() {
              Text('Click twice')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin({ top: 20 })
            .gesture(
              TapGesture({ count: 1 })
                .onAction(() => {
                  router.push({ uri: 'pages/Third' })
                })
            )
            .gesture(
              LongPressGesture({ repeat: false })
                .onAction((event: GestureEvent) => {
                  router.push({ uri: 'pages/wearList' })
                })
            )
            Button() {
              Text(this.hoverText)
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .key('jump')
            .margin({ top: 20 })
            .onHover((isHover: boolean) => {
              if (isHover) {
                this.hoverText = 'hover'
              }
            })
            .onMouse((event: MouseEvent) => {
              switch (event.button) {
                case MouseButton.Left :
                  this.hoverText = 'left'
                  break
                case MouseButton.Right :
                  this.hoverText = 'right'
                  break
                case MouseButton.Middle :
                  this.hoverText = 'middle'
                  break
              }
            })
            .onClick(() => {
              router.push({ uri: 'pages/Pinch' })
            })
            .gesture(
              LongPressGesture({ repeat: false })
                .onAction((event: GestureEvent) => {
                  router.push({ uri: 'pages/Drag' })
                })
            )
            Button() {
              Text('scroll')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }
            .type(ButtonType.Capsule)
            .margin({ top: 20 })
            .onClick(() => {
              router.push({ uri: 'pages/scroll' })
            })
            Checkbox({ name: 'hi' })
              .size({ width: 30, height: 30 })
            TextInput({ placeholder: 'welcome', text: 'Hello World' })
              .type(InputType.Normal)
              .width(300)
              .height(50)
              .fontSize(40)
              .enabled(true)
              .margin({ top: 20 })
            ForEach(this.arr, (item:number) => {
              Text(item.toString())
                .width('100%')
                .height('30%')
                .backgroundColor(0xFFFFFF)
                .borderRadius(75)
                .fontSize(80)
                .textAlign(TextAlign.Center)
                .margin({ top: 10 })
            }, (item:string) => item)
            Button() {
              Text('bottom')
                .fontSize(25)
                .fontWeight(FontWeight.Bold)
            }.type(ButtonType.Capsule)
            .margin({
              top: 20, left: 150
            })
            .onClick(() => {
              router.push({ uri: 'pages/second' })
            })
          }.width('100%')
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.On)
        .scrollBarColor(Color.Gray)
        .scrollBarWidth(30)
        .onScroll((xOffset: number, yOffset: number) => {
        })
      }.width('100%').height('100%').backgroundColor(0xDCDCDC)
      .onTouch((event) => {
        this.pressure = event.pressure;
      })
      Text(this.pressure.toFixed(1))
        .id('pressure')
        .fontSize(20)
      Text('MainPage_End')
        .fontSize(50)
        .fontWeight(FontWeight.Bold)
    }
  }
}

