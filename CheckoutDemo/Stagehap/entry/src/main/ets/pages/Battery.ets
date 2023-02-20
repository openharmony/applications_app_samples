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

import battery from '@system.battery';
import router from '@ohos.router';

@Entry
@Component
struct Battery {
  @State message1: string = '返回首页'
  @State message2: string = 'getStatus'
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
        router.push({ url: 'pages/Video' })
      }, 5000)
    }
  }

  build() {
    Row() {
      Column() {
        Text('电池功能测试')
          .fontColor('#e84868')
          .fontSize(35)
          .margin({ top: 10, bottom: 30 })

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
          .id(this.m2)
          .onClick(() => {
            battery.getStatus({
              success: (data) => {
                console.log('success charing is:' + data.charging + 'success level is:' + data.level)
                this.backgroundColor2 = Color.Orange
                this.message2 = '显示正常充电'
                var xixi = {
                  title: data.charging ? this.message2 = '正在充电' : this.message2 = '没在充电',
                  message: JSON.stringify('电量值:' + data.level * 100)
                }
                AlertDialog.show(xixi)
                if (this.ciChu) {
                  this.zhenDong.push(xixi)
                }
              },
              fail: (data, code) => {
                this.backgroundColor2 = Color.Red
                this.message2 = '充电失败'
                var haha = {
                  title: '没有充电功能接口',
                  message: '不支持充电接口'
                }
                AlertDialog.show(haha)
                if (this.ciChu) {
                  this.zhenDong.push(haha)
                }
              }
            })
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}