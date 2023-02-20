/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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


// @ts-nocheck

import router from '@ohos.router';

@Entry
@Component
struct DragExample {
  @State numbers: string[] = ['one', 'two', 'three']
  @State text: string = ''
  @State bool: boolean = false
  @State bool1: boolean = false
  @State size: string = ''
  @State appleVisible: Visibility = Visibility.Visible
  @State orangeVisible: Visibility = Visibility.Visible
  @State bananaVisible: Visibility = Visibility.Visible
  @State select: number = 0
  @State currentIndex: number = 0
  @StorageLink('zhenDong') zhenDong: any = [];
  @StorageLink('ciChu') ciChu: boolean = false;
  @State m2: string = 'm2';
  @State timer1: number = 1;

  private onPageShow(): void{
    if (this.ciChu) {
      this.timer1 = setTimeout(() => {
        router.push({ url: 'pages/Touch' })
      }, 10000)
    }
  }

  @Builder pixelMapBuilder() {
    Column() {
      //         拖拽时候的 Text展示效果
      Text(this.text)
        .width('50%')
        .height(60)
        .fontSize(16)
        .borderRadius(10)
        .textAlign(TextAlign.Center)
        .backgroundColor(Color.Yellow)
    }
  }

  build() {
    Column() {

      Text('点击此处返回首页')
        .fontColor('#e84868')
        .fontSize(35)
        .margin({ bottom: 30 })
        .onClick(() => {
          router.push({ url: 'pages/index' })
        })

      //      最上面的 There are three Text elements here 的样式
      Text('There are three Text elements here')
        .fontSize(16)
        .fontColor(0xCCCC)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin(5)

      Flex({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround }) {
        //       上面的 apple orange banban 三个样式
        Text('apple')
          .fontSize(16)
          .width('25%')
          .height(35)
          .textAlign(TextAlign.Center)
          .backgroundColor(0xAFEEEE)
          .visibility(this.appleVisible)
          .onDragStart(() => {
            var xixi = {
              title: '拖拽功能检测',
              message: '功能正常'
            }
            AlertDialog.show(xixi)
            //           将信息push到index
            if (this.ciChu) {
              this.zhenDong.push(xixi)
            }
            this.bool = true
            this.text = 'apple'
            this.appleVisible = Visibility.Hidden
            //           将拖拽时写的样式 展示出来
            return this.pixelMapBuilder
          })
        Text('Orange')
          .fontSize(16)
          .width('25%')
          .height(35)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .backgroundColor(0xAFEEEE)
          .visibility(this.orangeVisible)
          .onDragStart(() => {
            this.bool = true
            this.text = 'orange'
            //          拖拽开始的时候直接消失
            this.orangeVisible = Visibility.None
            return this.pixelMapBuilder
          })
        Text('banana')
          .fontSize(16)
          .width('25%')
          .height(35)
          .fontSize(16)
          .textAlign(TextAlign.Center)
          .backgroundColor(0xAFEEEE)
          .visibility(this.orangeVisible)
          .onDragStart(() => {
            this.bool = true
            this.text = 'banana'
            //          拖拽开始的时候直接消失
            this.orangeVisible = Visibility.None
            return this.pixelMapBuilder
          })
      }
      .border({ width: 1 })
      .width('90%')
      .padding({ top: 10, bottom: 10 })
      .margin(10)

      Text('This is a List element')
        .fontSize(16)
        .fontColor(0xCCCCC)
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin(15)

      List({ space: 20, initialIndex: 0 }) {

        ForEach(this.numbers, (item) => {
          ListItem() {
            Text('' + item)
              .margin({ top: 5 })
              .width('100%')
              .height(80)
              .fontSize(16)
              .borderRadius(10)
              .textAlign(TextAlign.Center)
              .backgroundColor('#ff06eecb')
          }
          .onDragStart((event: DragEvent, extraParams: string) => {
            console.log('ListItem onDragStarts,' + extraParams)
            var jsonString = JSON.stringify(extraParams)
            this.bool1 = true

            this.text = this.numbers[jsonString.selectedIndex]
            this.select = jsonString.selectedIndex
            return this.pixelMapBuilder
          })
        }, item => item)
      }
      .editMode(true)
      .height('50%')
      .width('90%')
      .border({ width: 1 })
      .divider({ strokeWidth: 2, color: 0xFFFF, startMargin: 20, endMargin: 20 })
      .onDragEnter((event: DragEvent, extraParams: string) => {
        console.log('List onDragEnter,' + extraParams)
      })
      .onDragMove((event: DragEvent, extraParams: string) => {
        console.log('List onDragMove,' + extraParams)
      })
      .onDragLeave((event: DragLeave, extraParams: string) => {
        console.log('List onDragLeave,' + extraParams)
      })
      .onDrop((event: DragEvent, extraParams: string) => {
        var jsonString = JSON.parse(extraParams)
        if (this.bool) {
          this.numbers.splice(jsonString.insertIndex, 0, this.text)
          this.bool = false
        } else if (this.bool1) {
          this.numbers.splice(jsonString.selectedIndex, 1)
          this.numbers.splice(jsonString.insertIndex, 0, this.text)
          this.bool = false
          this.bool1 = false
        }
      })
    }
    .width('100%')
    .height('100%')
    .padding({ top: 20 })
    .margin({ top: 20 })
  }
}