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

import brightness from '@ohos.brightness';
//import brightness from '@system.brightness';
import router from '@ohos.router';

@Entry
@Component
struct WiFi {
  @State message1: string = '返回首页'
  @State message2: string = '点击这'
  @State num1: number = 50
  @State backgroundColor1: Color = Color.Yellow;
  @State backgroundColor2: Color = Color.Yellow;
  @StorageLink('zhenDong') zhenDong: any = [];
  @StorageLink('ciChu') ciChu: boolean = false;
  @State m1: string = 'm1';
  @State m2: string = 'm2';
  @State timer1: number = 1;

  //  private aboutToAppear():void{
  //    setTimeout(() => {
  //      sendEventByKey("m2",10,"")
  //    },1000)
  //    setTimeout(() => {
  //      sendEventByKey("m2",10,"")
  //    },3000)
  //  }

  private onPageShow(): void{
    if (this.ciChu) {
      this.timer1 = setTimeout(() => {
        router.push({ url: 'pages/FingerPrint' })
      }, 6000)
    }
  }

  build() {
    Row() {
      Column() {
        Text('屏幕亮度功能测试')
          .fontColor('#e84868')
          .fontSize(35)
          .margin({ bottom: 30 })

        Text(this.message1)
          .textAlign(TextAlign.Center)
          .width(150)
          .height(50)
          .backgroundColor(this.backgroundColor1)
          .fontSize(20)
          .margin({ top: 10 })
          .onClick(() => {
            clearTimeout(this.timer1)
            this.ciChu = false
            router.push({ url: 'pages/index' })
          })

        Text(this.message2)
          .textAlign(TextAlign.Center)
          .width(150)
          .height(50)
          .backgroundColor(this.backgroundColor2)
          .fontSize(20)
          .margin({ top: 10 })
          .onClick(() => {
            AlertDialog.show({ message: '当前屏幕亮度:' + this.num1.toFixed(0) })
          })
        //        Slider调整屏幕亮度大小
        Row() {
          Text('屏幕亮度大小:')
            .fontSize(18)
            .fontColor('#6ec947')
          Slider({
            value: this.num1,
            min: 0,
            max: 100,
            step: 1,
            style: SliderStyle.InSet
          })
            .width(200)
            .blockColor(Color.White)
            .trackColor('#eee')
            .selectedColor('#b20670f1')
            .showSteps(true)
            .showTips(true)
            .onChange((value: number, mode: SliderChangeMode) => {
              this.num1 = value
              //              设置屏幕亮度值
              brightness.setValue(value)
            })
            .margin({ right: 20, left: 15 })
          Text(this.num1.toFixed(0)).fontSize(18)
        }.margin({ top: 30 })
      }
      .width('100%')
    }
    .height('100%')
  }
}