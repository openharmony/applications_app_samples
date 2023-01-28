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

import sim from '@ohos.telephony.sim';
import router from '@ohos.router';

@Entry
@Component
struct FlashLamp {
  @State message1: string = '返回首页'
  @State message2: string = '卡槽1的SIM卡是否激活'
  @State message3: string = '卡槽2的SIM卡是否激活'
  @State message4: string = '卡槽1是否已被授予运营权限'
  @State message5: string = '卡槽2是否已被授予运营权限'
  @State backgroundColor1: Color = Color.Yellow;
  @State backgroundColor2: Color = Color.Yellow;
  @State backgroundColor3: Color = Color.Yellow;
  @State backgroundColor4: Color = Color.Yellow;
  @State backgroundColor5: Color = Color.Yellow;
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
    if (this.ciChu) {
      this.timer1 = setTimeout(() => {
        router.replace({ url: 'pages/Earphone' })
      }, 6000)
    }
  }

  private onPageShow(): void{
    setTimeout(() => {
      sendEventByKey("m3", 10, "")
    }, 3000)
    setTimeout(() => {
      sendEventByKey("m3", 10, "")
    }, 4000)
  }

  build() {
    Row() {
      Column() {
        Text('SIM卡功能测试')
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
            let promise = sim.isSimActive(0);
            promise.then(data => {
              this.backgroundColor2 = Color.Green
              this.message2 = '绿色返回的是成功的方法'
              console.log('data is:' + JSON.stringify(data))

              var xixi = {
                title: data === true ? '卡槽1已经被激活' : '卡槽1没有被激活',
                message: 'pass'
              }
              AlertDialog.show(xixi)
              //              将信息push到index中
              if (this.ciChu) {
                this.zhenDong.push(xixi)
              }
            }).catch(err => {
              this.backgroundColor2 = Color.Red
              console.log('err is:' + JSON.stringify(err))
              var haha = {
                title: '卡槽1没有被激活',
                message: 'fail'
              }
              AlertDialog.show(haha)
              if (this.ciChu) {
                this.zhenDong.push(haha)
              }
            })
          })

        Text(this.message3)
          .textAlign(TextAlign.Center)
          .width(250)
          .height(50)
          .backgroundColor(this.backgroundColor3)
          .fontSize(20)
          .id(this.m3)
          .onClick(() => {
            let promise = sim.isSimActive(1);
            promise.then(data => {
              this.backgroundColor3 = Color.Green
              this.message3 = '绿色返回的是成功的方法'
              console.log('data is:' + JSON.stringify(data))
              var xixi = {
                title: data === true ? '卡槽2已经被激活' : '卡槽2没有被激活',
                message: 'pass'
              }
              AlertDialog.show(xixi)
              // 将信息push到index中
              if (this.ciChu) {
                this.zhenDong.push(xixi)
              }
            }).catch(err => {
              this.backgroundColor3 = Color.Red
              console.log('err is:' + JSON.stringify(err))
              var haha = {
                title: '卡槽2没有被激活',
                message: 'fail'
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