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
struct TouchExample {
  @State text: string = ''
  @State Color1: string = '#7c2f2b2b'
  @State TouchType1: TouchType = TouchType.Up
  @StorageLink('zhenDong') zhenDong: any = [];
  @StorageLink('ciChu') ciChu: boolean = false;
  @State m2: string = 'm2';
  @State timer1: number = 1;

  private aboutToAppear(): void{
    setTimeout(() => {
      sendEventByKey("m2", 11, "")
    }, 1000)
  }

  private onPageShow(): void{
    if (this.ciChu) {
      this.timer1 = setTimeout(() => {
        router.push({ url: 'pages/index' })
      }, 4000)
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceBetween }) {
      Text('点击此处返回首页')
        .fontColor('#e84868')
        .fontSize(35)
        .margin({ bottom: 30 })
        .onClick(() => {
          clearTimeout(this.timer1)
          this.ciChu = false
          router.push({ url: 'pages/index' })
        })

      Text('Touch')
        .textAlign(TextAlign.Center)
          //        检测触摸状态的改变来，改变touch的背景颜色
        .backgroundColor(this.Color1)
        .height(90)
        .lineHeight(70)
        .width(180)
        .id(this.m2)
        .onTouch((event: TouchEvent) => {
          //            检测触摸状态是按下的状态
          if (event.type === TouchType.Down) {
            this.Color1 = '#7cfa0c0c'
            var xixi = {
              title: '触目功能状态',
              message: '按下状态'
            }
            AlertDialog.show(xixi)
            if (this.ciChu) {
              this.zhenDong.push(xixi)
            }
            console.info(this.Color1)
          }
          //          抬起状态
          if (event.type === TouchType.Up) {
            this.Color1 = '#7c2f2b2b'
            console.info(this.Color1)
            var haha = {
              title: '触摸功能状态',
              message: '抬起状态'
            }
            AlertDialog.show(haha)
            if (this.ciChu) {
              this.zhenDong.push(haha)
            }
          }
          //          移动状态
          if (event.type === TouchType.Move) {
            this.Color1 = '#7c7ff607'
            var yiyi = {
              title: '触摸功能状态',
              message: '移动状态'
            }
            AlertDialog.show(yiyi)
            if (this.ciChu) {
              this.zhenDong.push(yiyi)
            }
          }
          console.info(this.text = 'TouchType:' + event.type)
        })
      Text(this.text)
    }
    .height(200)
    .width(350)
    .padding({ left: 35, right: 35, top: 35 })
  }
}