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

import router from '@ohos.router'
import Logger from '../util/Logger'
import CameraService from '../feature/CameraService'

const TAG: string = '[CameraPage]'

@Entry
@Component
struct CameraPage {
  private xComponentController: XComponentController = new XComponentController()
  private surfaceId: string = '-1'
  private cameraService: CameraService = new CameraService(getContext(this))
  @StorageLink('cameraStatus') @Watch('cameraChange') cameraStatus: boolean = false

  async cameraChange(callback: void): Promise<void> {
    await this.cameraService.createCamera(this.surfaceId)
  }

  build() {
    Column() {
      Stack({ alignContent: Alignment.Bottom }) {
        XComponent({
          id: 'componentId',
          type: 'surface',
          controller: this.xComponentController
        })
          .onLoad(() => {
            Logger.info(TAG, 'onLoad is called')
            // 设置XComponent创建的曲面宽为640vp，高为480vp
            this.xComponentController.setXComponentSurfaceSize({ surfaceWidth: 640, surfaceHeight: 480 })
            this.surfaceId = this.xComponentController.getXComponentSurfaceId()
            Logger.info(TAG, `onLoad surfaceId: ${this.surfaceId}`)
            this.cameraService.createCamera(this.surfaceId)
          })
          .height('100%')
          .width('100%')
          .margin({ bottom: 130 })
        Column() {
          Text($r('app.string.photo'))
            .fontColor(Color.White)
            .fontSize(18)
            .margin({ bottom: 20 })
          Image($r('app.media.take_photo_normal'))
            .size({ width: 70, height: 70 })
            .onClick(() => {
              this.cameraService.takePicture()
              router.back()
            })
        }
        .size({ height: 140, width: '100%' })
        .padding({ bottom: 10 })
        .backgroundColor(Color.Black)
        .justifyContent(FlexAlign.Center)
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }
}