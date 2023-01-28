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

import call from '@ohos.telephony.call';
import router from '@ohos.router';

@Entry
@Component
struct JuLiSensor {
  @State message1: string = '返回首页'
  @State message2: string = '是否具有通话功能'
  @State message3: string = '是否具有语音功能'
  @State backgroundColor1: Color = Color.Yellow;
  @State backgroundColor2: Color = Color.Yellow;
  @State backgroundColor3: Color = Color.Yellow;
  @StorageLink('zhenDong') zhenDong: any = [];
  @StorageLink('ciChu') ciChu: boolean = false;
  @State m2: string = 'm2';
  @State m3: string = 'm3';
  @State timer1: number = 1;

  private aboutToAppear(): void{
    setTimeout(() => {
      sendEventByKey("m2", 10, "")
    }, 1000)
    setTimeout(() => {
      sendEventByKey("m2", 10, "")
    }, 2000)
  }

  private onPageShow(): void{
    setTimeout(() => {
      sendEventByKey("m3", 10, "")
    }, 1000)
    setTimeout(() => {
      sendEventByKey("m3", 11, "")
    }, 3000)
    if (this.ciChu) {
      this.timer1 = setTimeout(() => {
        router.push({ url: 'pages/LightSensor' })
      }, 5000)
    }
    this.timer1 = setTimeout(() => {
      router.replace({ url: 'pages/LightSensor' })
    }, 5000)
  }

  build() {
    Row() {
      Column() {
        Text('电话功能测试')
          .fontColor('#e84868')
          .fontSize(35)
          .margin({ top: 10, bottom: 30 })

        Text(this.message1)
          .textAlign(TextAlign.Center)
          .width(180)
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
          .width(180)
          .height(50)
          .backgroundColor(this.backgroundColor2)
          .fontSize(20)
          .margin({ top: 10 })
          .id(this.m2)
          .onClick(() => {
            let promise = call.hasCall();
            promise.then(data => {
              if (data) {
                this.backgroundColor2 = Color.Green
              } else {
                this.backgroundColor2 = Color.Red
              }
              var xixi = {
                title: data ? "电话功能显示正常" : "您没有插入SIM卡",
                message: data ? 'pass' : 'fail'
              }
              AlertDialog.show(xixi)
              //              将信息push到index中
              if (this.ciChu) {
                this.zhenDong.push(xixi)
              }
            }).catch(err => {
              this.zhenDong.push(xixi)
            }).catch(err => {
              this.backgroundColor2 = Color.Red;
              console.log('err is:' + JSON.stringify(err))
              var haha = {
                title: '电话功能不正常',
                message: JSON.stringify(err)
              }
              AlertDialog.show(haha)
              if (this.ciChu) {
                this.zhenDong.push(haha)
              }
            })

          })


      }
      .width('100%')
    }
    .height('100%')
  }
}