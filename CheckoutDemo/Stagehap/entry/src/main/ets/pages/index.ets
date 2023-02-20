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

import router from '@system.router';

const testItems = [
  { title: '蓝牙', uri: 'pages/Bluetooth', index: '1' },
  { title: '打电话', uri: 'pages/JuLiSensor', index: '2' },
  { title: '短信', uri: 'pages/LightSensor', index: '3' },
  { title: 'SIM卡', uri: 'pages/FlashLamp', index: '4' },
  { title: '5G网络', uri: 'pages/Earphone', index: '5' },
  { title: '音量键', uri: 'pages/Keyup', index: '7' },
  { title: '电量信息', uri: 'pages/Battery', index: '8' },
  { title: '视频', uri: 'pages/Video', index: '11' },
  { title: '相机', uri: 'pages/RearCamera', index: '12' },
  { title: '屏幕亮度', uri: 'pages/ScreenDisplay', index: '13' },
  { title: '指纹', uri: 'pages/FingerPrint', index: '14' },
  { title: '拖拽功能', uri: 'pages/Drag', index: '15' },
  { title: '触摸功能', uri: 'pages/Touch', index: '16' },
  { title: '倒计时', uri: 'pages/countDown', index: '17' },
  { title: '时钟2', uri: 'pages/shizhong', index: '19' },
  { title: '2048游戏', uri: 'pages/game2048', index: '20' },
]

@Entry
@Component
struct Index {
  @State message: string = 'API9-STAGE';
  @State dianji: string = 'dianji';
  @StorageLink('zhenDong') zhenDong: any = [];
  @StorageLink('ciChu') ciChu: boolean = false;

  build() {
    Row() {
      Column() {
        Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
          Text(this.message)
            .fontColor('#e84868')
            .fontSize(35)
            .margin({ top: 5 })

          Scroll() {
            List() {
              //遍历每一条数据
              ForEach(testItems, (item) => {
                ListItem() {
                  Row() {
                    Text(item.title)
                      .fontSize(16)
                      .fontColor('#e84868')
                      .textAlign(TextAlign.Center)
                      .width('100%')
                      .height(55)
                      .backgroundColor(0xfff5deb3)
                      .margin({ top: 5, bottom: 5 })
                      .borderRadius(12)
                      .onClick(() => {
                        router.replace({
                          uri: item.uri
                        })
                      })
                  }
                }
              }, item => item.title)
            }
          }.margin({ top: 20, bottom: 10 })

          Row() {
            Button('点击此处')
              .width('40%')
              .height(55)
              .backgroundColor('#ffef0404')
              .margin({ right: 10 })
              .id(this.dianji)
              .onClick(() => {
                this.zhenDong = []
                this.ciChu = true
                router.push({ uri: testItems[0].uri })
              })

            Button('查询报告')
              .width('40%')
              .height(55)
              .fontColor('#fff50808')
              .backgroundColor('#ffdff607')
              .onClick(() => {
                AlertDialog.show({
                  title: '最终报告显示',
                  message: '' + JSON.stringify(this.zhenDong)
                })
              })

          }
        }

      }
      .width('95%')
    }
    .width('100%')
    .height(650)
    .padding({ right: 15 })
    .flexGrow(1)
  }
}