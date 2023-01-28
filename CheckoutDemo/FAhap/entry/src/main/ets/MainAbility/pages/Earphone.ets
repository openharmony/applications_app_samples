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

import radio from '@ohos.telephony.radio';
import router from '@ohos.router';

@Entry
@Component
struct Earphone {
  @State message1: string = '返回首页'
  @State message2: string = '判断当前设备是否支持5G'
  @State backgroundColor1: Color = Color.Yellow;
  @State backgroundColor2: Color = Color.Yellow;
  @StorageLink('zhenDong') zhenDong: any = [];
  @StorageLink('ciChu') ciChu: boolean = false;
  @State m2: string = 'm2';
  @State timer1: number = 1;

  private aboutToAppear(): void{
    setTimeout(() => {
      sendEventByKey("m2", 10, "")
    }, 1000)
    setTimeout(() => {
      sendEventByKey("m2", 10, "")
    }, 3000)
  }

  private onPageShow(): void{
    if (this.ciChu) {
      this.timer1 = setTimeout(() => {
        router.replace({ url: 'pages/Keyup' })
      },)
    }
  }

  build() {
    Row() {
      Column() {
        Text('5G网络功能测试')
          .fontColor('#e84868')
          .fontSize(35)
          .margin({ top: 10, bottom: 30 })

        Text(this.message1)
          .textAlign(TextAlign.Center)
          .width(250)
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
          .width(250)
          .height(50)
          .backgroundColor(this.backgroundColor2)
          .fontSize(20)
          .margin({ top: 10 })
          .id(this.m2)
          .onClick(() => {
            let result = radio.isNrSupported()
            console.log('11111')
            console.log(JSON.stringify(result))
            if (result == 0) {
              this.backgroundColor2 = Color.Green;
              this.message2 = '蓝牙已关闭'
              var xixi = {
                title: '5G功能是否正常',
                message: 'pass'
              }
              AlertDialog.show(xixi)
              //              将信息Push到Index中
              if (this.ciChu) {
                this.zhenDong.push(xixi)
              }
            } else {
              this.backgroundColor2 = Color.Red
              this.message2 = '蓝牙已打开';
              var haha = {
                title: '5G功能是否正常',
                message: 'fail'
              }
              AlertDialog.show(haha)
              if (this.ciChu) {
                this.zhenDong.push(haha)
              }
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}