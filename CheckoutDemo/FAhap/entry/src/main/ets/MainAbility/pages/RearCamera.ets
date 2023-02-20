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

import camera from '@ohos.multimedia.camera';
import router from '@ohos.router';

@Entry
@Component
struct RearCameraPage {
  @State message1: string = '返回首页'
  @State message2: string = '获取相机管理器实例'
  @State message3: string = '相机功能是否正常'
  @State backgroundColor1: Color = Color.Yellow;
  @State backgroundColor2: Color = Color.Yellow;
  @State backgroundColor3: Color = Color.Yellow;
  @State cameraInput: camera.CameraInput = {};
  @State cameraManager: camera.CameraManager = {};
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
    setTimeout(() => {
      sendEventByKey("m2", 10, "")
    }, 3000)
    setTimeout(() => {
      sendEventByKey("m2", 10, "")
    }, 4000)
  }

  private onPageShow(): void{
    if (this.ciChu) {
      this.timer1 = setTimeout(() => {
        router.push({ url: 'pages/ScreenDisplay' })
      }, 5000)
    }
  }

  build() {
    Row() {
      Column() {
        Text('相机功能测试')
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
          .width(200)
          .height(50)
          .backgroundColor(this.backgroundColor2)
          .fontSize(20)
          .margin({ top: 10 })
          .id(this.m2)
          .onClick(() => {
            camera.getCameraManager().then((cameraManager) => {
              this.message2 = '获取相机管理器'
              this.backgroundColor2 = Color.Green
              var xixi = {
                title: '已获取管理器',
                message: 'pass'
              }
              AlertDialog.show(xixi)
              if (this.ciChu) {
                this.zhenDong.push(xixi)
              }
            })
          })

        Text(this.message3)
          .textAlign(TextAlign.Center)
          .width(200)
          .height(50)
          .backgroundColor(this.backgroundColor3)
          .fontSize(20)
          .margin({ top: 10 })
          .id(this.m3)
          .onClick(() => {
            if (camera.CameraStatus && camera.CameraType && camera.ConnectionType) {
              this.backgroundColor3 = Color.Green;
              var xixi = {
                title: '相机功能是否正常',
                message: 'pass'
              }
              AlertDialog.show(xixi)
              if (this.ciChu) {
                this.zhenDong.push(xixi)
              }
            } else {
              var haha = {
                title: '相机功能是否正常',
                message: 'fail'
              }
              AlertDialog.show(haha)
              if (this.ciChu) {
                this.zhenDong.push(haha)
              }
              this.backgroundColor3 = Color.Red
              console.log('不存在')
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}