/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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
import image from '@ohos.multimedia.image'
import prompt from '@ohos.promptAction'
import common from '@ohos.app.ability.common'
import { CameraService } from '../CameraService'
import { QRCodeScanConst } from '../QRCodeScanConst'
import { QRCodeParser } from '../QRCodeParser'

/**
 * 二维码扫描组件
 */
@Component
export default struct QRCodeScanComponent {
  private cameraService: CameraService = new CameraService()
  private qrCodeParser: QRCodeParser = new QRCodeParser()
  private xComponentController: XComponentController = new XComponentController()
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(new RenderingContextSettings(true))
  @StorageProp('qrCodeParseResult') @Watch('showQrCodeResult') qrCodeParseResult: string = ''
  @State qrCodeImage: image.PixelMap | undefined = undefined
  @State animationOrdinate: number = QRCodeScanConst.SCAN_TO_TOP_HEIGHT
  @State hasCameraPermission: boolean = false
  @State isQRCodeScanStopped: boolean = false
  // 每当应用切换回来都重新打开相机
  @StorageLink('cameraStatus') @Watch('reCreateCamera') isCameraOpened: boolean = false
  @State surFaceId: string = ''

  // 重新打开相机
  async reCreateCamera() {
    await this.cameraService.createCamera(this.surFaceId)
  }

  showQrCodeResult() {
    prompt.showDialog({
      title: $r('app.string.qrcodeResult'),
      message: this.qrCodeParseResult
    })
  }

  aboutToAppear() {
    // 监听相机权限
    this.watchCameraPermission()
    // 设置扫描动画
    this.setQRCodeScanAnimation()
    // 解析二维码图片信息
    this.qrCodeParser.parseQRCodeImageFromCamera(this.cameraService, this.canvasContext)
  }

  build() {
    Column() {
      Stack() {
        if (this.hasCameraPermission) {
          XComponent({
            id: 'componentId',
            type: 'surface',
            controller: this.xComponentController
          })
            .onLoad(() => {
              // 适配可能需要获取设备信息
              this.xComponentController.setXComponentSurfaceSize({
                surfaceWidth: QRCodeScanConst.IMG_DEFAULT_SIZE.WIDTH,
                surfaceHeight: QRCodeScanConst.IMG_DEFAULT_SIZE.HEIGHT
              })
              this.surFaceId = this.xComponentController.getXComponentSurfaceId()
              this.cameraService.createCamera(this.surFaceId)
            })
            .onDestroy(() => {
              this.cameraService.releaseCamera()
            })
            .height('100%')
            .width('100%')
        }
        Column() {
          Column() {
            Image($r('app.media.scan_border'))
              .width('100%')
              .height('100%')
              .margin({ top: QRCodeScanConst.SCAN_TO_TOP_HEIGHT })
              .onAreaChange((oldValue: Area, newValue: Area) => {
                this.animationOrdinate = (newValue.position.y as number) + 10
              })

            Divider()
              .strokeWidth(1)
              .height(4)
              .width('100%')
              .color(Color.White)
              .width('100%')
              .position({ x: 0, y: 0 })
              .translate({ x: 0, y: this.animationOrdinate })
          }
          .width(280)
          .height(280)

          Text($r('app.string.putTheQRCodeToScan'))
            .fontSize(18)
            .fontColor(Color.White)
            .margin({ top: 24 })

          Canvas(this.canvasContext)
            .width(QRCodeScanConst.QR_CODE_SIZE)
            .aspectRatio(1)
            .backgroundColor(Color.White)
            .position({ x: '100%' })
            .onReady(() => {
              this.canvasContext.imageSmoothingEnabled = false
              this.canvasContext.clearRect(0, 0, QRCodeScanConst.QR_CODE_SIZE, QRCodeScanConst.QR_CODE_SIZE)
              if (this.qrCodeImage === undefined) {
                return
              }
              this.canvasContext.drawImage(this.qrCodeImage, 0, 0,
              QRCodeScanConst.QR_CODE_SIZE, QRCodeScanConst.QR_CODE_SIZE)
            })
        }
        .width('100%')
        .height('100%')
        .margin({ right: 20, top: 20, left: 20 })
        .alignItems(HorizontalAlign.Center)
        .justifyContent(FlexAlign.Start)

        Row() {
          Image($r('app.media.scan_back'))
            .width(30)
            .height(30)
            .onClick(() => {
              router.back()
            })

          Row({ space: 16 }) {
            Image($r('app.media.scan_photo'))
              .width(30)
              .height(30)
              .onClick(async () => {
                // 打开相册获取图片
                this.isQRCodeScanStopped = true
                let context = AppStorage.Get('context') as common.UIAbilityContext
                let image = await this.qrCodeParser.getSingleImageFromAlbum(context)
                if (image === null) {
                  prompt.showToast({
                    message: $r('app.string.queryImageFailed'),
                    duration: 1000
                  })
                  return
                }
                let qrCodeParseRlt = this.qrCodeParser.parseImageQRCode(this.canvasContext, image)
                if (qrCodeParseRlt) {
                  prompt.showDialog({
                    title: $r('app.string.qrcodeResult'),
                    message: qrCodeParseRlt
                  })
                } else {
                  prompt.showToast({
                    message: $r('app.string.qrCodeNotRecognized')
                  })
                }
              })

            Image($r('app.media.scan_more'))
              .width(30)
              .height(30)
              .onClick(() => {
                prompt.showToast({
                  message: $r('app.string.notSupportCurrent'),
                  duration: 1000
                })
              })
          }
        }
        .width('100%')
        .height('100%')
        .margin({ top: 24 })
        .padding({ left: 24, right: 24 })
        .alignItems(VerticalAlign.Top)
        .justifyContent(FlexAlign.SpaceBetween)

        Column() {
          Image($r('app.media.scan_light'))
            .width(48)
            .height(48)

          Text($r('app.string.lightByTouch'))
            .fontSize(20)
            .fontColor(Color.White)
            .margin({ top: 4 })

          // 扫一扫 文本翻译 字体设置
          NotSupportComponent()
        }.margin({ top: 350 })
      }
      .width('100%')
      .height('100%')
      .layoutWeight(1)
      .backgroundColor(Color.Grey)
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
  }

  // 监听相机权限变化
  watchCameraPermission() {
    let interval = setInterval(() => {
      this.hasCameraPermission = AppStorage.Get(QRCodeScanConst.HAS_CAMERA_PERMISSION)
      if (this.hasCameraPermission) {
        let qrCodeScanInterval = setInterval(() => {
          if (this.qrCodeParseResult.length > 0 || this.isQRCodeScanStopped) {
            clearInterval(qrCodeScanInterval)
          }
          // 拍照
          this.cameraService.takePicture()
        }, 4000)
        clearInterval(interval)
      }
    }, 100)
  }

  // 扫描扫描动画
  setQRCodeScanAnimation() {
    setInterval(() => {
      animateTo({
        duration: 1000, // 动画时间
        tempo: 0.5, // 动画速率
        curve: Curve.EaseInOut,
        delay: 200, // 动画延迟时间
        iterations: -1, // 动画是否重复播放
        playMode: PlayMode.Normal,
      }, () => {
        this.animationOrdinate = 390 // 扫描动画结束Y坐标
      })
    }, 2000)
  }
}

@Component
struct NotSupportComponent {
  build() {
    Row({ space: 32 }) {
      Image($r('app.media.scan_trans'))
        .width(30)
        .height(30)
        .onClick(() => {
          prompt.showToast({ message: $r('app.string.notSupportCurrent'), duration: 1000 })
        })
      Image($r('app.media.scan_size'))
        .width(30)
        .height(30)
        .onClick(() => {
          prompt.showToast({ message: $r('app.string.notSupportCurrent'), duration: 1000 })
        })
    }
    .margin({ top: 30, left: 20 })
  }
}