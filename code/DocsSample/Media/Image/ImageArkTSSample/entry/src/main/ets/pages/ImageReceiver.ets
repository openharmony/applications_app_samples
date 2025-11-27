/*
* Copyright (C) 2025 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

import hilog from '@ohos.hilog'
import image from '@ohos.multimedia.image'
import camera from '@ohos.multimedia.camera'
import common from '@ohos.app.ability.common'
import { UIContext } from '@ohos.arkui.UIContext'
import { ReceiverUtility } from '../tools/ReceiverUtility'
import {Router} from '@ohos.arkui.UIContext';

const router = new Router();
const TAG: string = '[ImageCameraPage]';
const WIDTH: number = 480;
const HEIGHT: number = 480;

let xComponentSurfaceId: string = '';
class CameraController extends XComponentController {
  onSurfaceCreated(xComponentSurfaceId: string): void {
    hilog.info(0x00000, TAG, `CameraController id is ${xComponentSurfaceId}`);
  }
}

@Entry
@Component
struct ImageCreationPage {
  context: common.UIAbilityContext = this.getUIContext().getHostContext() as common.UIAbilityContext;
  private xComponentCtl: XComponentController = new CameraController();
  private uiContext: UIContext = this.getUIContext();
  private session: camera.VideoSession | undefined = undefined;
  private cameraInput: camera.CameraInput | undefined = undefined;
  private previewOutput1: camera.PreviewOutput | undefined = undefined;
  private previewOutput2: camera.PreviewOutput | undefined = undefined;
  private receiver: image.ImageReceiver | undefined = undefined;
  @State imageWidth: number = WIDTH;
  @State imageHeight: number = HEIGHT;
  @State receiverSurfaceId: string | undefined = '';
  @State thisXComponentSurfaceId: string = '';
  @State receiverUtility: ReceiverUtility = new ReceiverUtility();
  @State profile: camera.Profile | undefined = undefined;

  async onPageShow() {
    hilog.info(0x00000, TAG, `onPageShow`);
    this.receiver = await this.receiverUtility.initImageReceiver();
    this.receiverSurfaceId = await this.receiverUtility.getReceiverSurfaceId(this.receiver);
    await this.receiverUtility.onArrival(this.receiver as image.ImageReceiver);
  }

  onPageHide(): void {
    hilog.info(0x00000, TAG, `onPageHide`);
    this.receiverUtility.releaseCamera(this.receiver, this.session,
      this.cameraInput, this.previewOutput1, this.previewOutput2);
  }

  build() {
    Column(undefined) {
      // 返回
      Flex({ direction: FlexDirection.Row, justifyContent: FlexAlign.Center }) {
        Text('相机预览流')
      }.size({ width: '100%', height: '5%' })
      Button('触发相机').onClick(async() => {
        let cameraManager = camera.getCameraManager(this.context);
        hilog.info(0x00000, TAG, `receiverSurfaceId` + this.receiverSurfaceId?.toString());
        if (this.receiverSurfaceId) {
          this.thisXComponentSurfaceId = this.xComponentCtl.getXComponentSurfaceId();
          this.profile = await this.receiverUtility.initCamera(cameraManager);
          this.imageHeight = this.profile.size.height;
          this.imageWidth = this.profile.size.width;
          this.previewOutput1 = this.receiverUtility.createPreviewOutput(cameraManager, this.profile,
            this.receiverSurfaceId);
          this.previewOutput2 = this.receiverUtility.createPreviewOutput(cameraManager, this.profile,
            this.thisXComponentSurfaceId);
          let cameras = this.receiverUtility.getSupportedCameras(cameraManager);
          this.cameraInput = await this.receiverUtility.createCameraInput(cameraManager, cameras);
          this.session = this.receiverUtility.createSession(cameraManager, this.cameraInput,
            this.previewOutput1 as camera.PreviewOutput, this.previewOutput2 as camera.PreviewOutput);
        }
      })
        .width('50%')
        .margin(10)
      // 相机预览流输出
      Column() {
        XComponent({
          type: XComponentType.SURFACE,
          controller: this.xComponentCtl
        } as XComponentOptions)
          .width(this.uiContext.px2vp(this.imageHeight))
          .height(this.uiContext.px2vp(this.imageWidth))
      }.visibility(Visibility.Visible).margin(10)
      // receiverSurfaceId信息
      Text(`成功获取到receiver的id: ${this.receiverSurfaceId}`)
        .fontSize(20)
        .width('99%')
        .height('10%')
        .margin(10)
        .visibility(Visibility.Visible)
        .border({
          width: { left: '3lpx', right: '3lpx', top: '3lpx', bottom: '3lpx' },
          color: { left: Color.Red, right: Color.Red, top: Color.Red, bottom: Color.Red },
          radius: { topLeft: 10, topRight: 10, bottomLeft: 10, bottomRight: 10 },
          style: {
            left: BorderStyle.Solid,
            right: BorderStyle.Solid,
            top: BorderStyle.Solid,
            bottom: BorderStyle.Solid
          }
        }).textAlign(TextAlign.Center)
      Button('back')
        .width('50%')
        .margin(10)
        .onClick(() => {
          router.pushUrl({ url: 'pages/Index' });
        })
        .width('50%')
        .margin(10)
    }
  }
}
