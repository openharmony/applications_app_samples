/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import camera from '@ohos.multimedia.camera';
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import { BusinessError } from'@kit.BasicServicesKit';
import abilityAccessCtrl, { Permissions } from '@ohos.abilityAccessCtrl';
const permissions: Array<Permissions> = ['ohos.permission.CAMERA'];

const componentType_Jpeg = image.ComponentType.JPEG

@Entry
@Component
export struct Index {
  @State message: string = 'Hello World';
  // XComponentController
  private mXComponentController: XComponentController = new XComponentController();
  public videoRecorder?: media.AVRecorder;
  // surfaceID value
  @State focusMode: number = 2;
  @State cameraDeviceIndex: number = 0;
  @State sceneMode: number = 2;
  @State previewId: string = '';
  @State photoId: string = '';
  @State videoId: string = '';
  @State xComponentWidth: number = 384;
  @State xComponentHeight: number = 450;

  build() {
      Column() {
        XComponent({
          id: 'componentId',
          type: XComponentType.SURFACE,
          controller: this.mXComponentController
        })
          .onLoad(async () => {
            this.previewId = this.mXComponentController.getXComponentSurfaceId();
            hilog.info(0x0000, 'testTag', 'previewId: %{public}s', this.previewId);

            hilog.info(0x0000, 'testTag', 'Prepare AVRecorder %{public}d', testNapi.prepareAVRecorder());

            hilog.info(0x0000, 'testTag', 'prepare Camera %{public}d', testNapi.prepareCamera(this.focusMode, this.cameraDeviceIndex,
              this.sceneMode, this.previewId, this.photoId, this.videoId));
          })
          .onDestroy(() => {
            // 组件销毁时释放录制资源
            hilog.info(0x0000, 'testTag', 'Application is closing, perform cleanup.');
            testNapi.releaseAVRecorder();
          })
          .backgroundColor(Color.Black)
          .width('100%')
          .height('70%')
        Flex({ direction: FlexDirection.Row, wrap:FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly,
          alignItems: ItemAlign.Center, alignContent:FlexAlign.Center }) {

          // ** 可选: 获取实时录制参数 **
          Button($r('app.string.GetConfig'), { type: ButtonType.Circle, stateEffect: true })
            .id("GetConfig")
            .backgroundColor(0xF55A42)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Get AVRecorder Config %{public}d', testNapi.getAVRecorderConfig());
            })

          // ** 可选: 获取编码信息 **
          Button($r('app.string.GetInfo'), { type: ButtonType.Circle, stateEffect: true })
            .id("GetInfo")
            .backgroundColor(0xF55A42)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Get AVRecorder EncoderInfo %{public}d', testNapi.getAvailableEncoder());
            })
        }
          Flex({ direction: FlexDirection.Row, wrap:FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly,
            alignItems: ItemAlign.Center, alignContent:FlexAlign.Center }){
          Button($r('app.string.Prepare'), { type: ButtonType.Circle, stateEffect: true })
            .id("Prepare")
            .backgroundColor(Color.Black)
            .width(65)
            .height(65)
            .onClick(() => {
              this.previewId = this.mXComponentController.getXComponentSurfaceId();
              hilog.info(0x0000, 'testTag', 'dztdztdzt previewId: %{public}s', this.previewId);
              hilog.info(0x0000, 'testTag', 'Prepare AVRecorder %{public}d', testNapi.prepareAVRecorder());
              hilog.info(0x0000, 'testTag', 'prepare Camera %{public}d', testNapi.prepareCamera(this.focusMode, this.cameraDeviceIndex,
                this.sceneMode, this.previewId, this.photoId, this.videoId));
              hilog.info(0x0000, 'testTag', 'Start AVRecorder %{public}d', testNapi.startAVRecorder());
            })
          Button($r('app.string.Start'), { type: ButtonType.Circle, stateEffect: true })
            .id("Start")
            .backgroundColor(0xF55A42)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'After prepare surfaceId: %{public}s', this.videoId);
              hilog.info(0x0000, 'testTag', 'Start AVRecorder %{public}d', testNapi.startAVRecorder());
            })
          Button($r('app.string.Pause'), { type: ButtonType.Normal, stateEffect: true })
            .id("Pause")
            .backgroundColor(0x4287F5)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Pause AVRecorder %{public}d', testNapi.pauseAVRecorder());
            })
          Button($r('app.string.Resume'), { type: ButtonType.Capsule, stateEffect: true })
            .id("Resume")
            .backgroundColor(0x4287F5)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Pause AVRecorder %{public}d', testNapi.resumeAVRecorder());
            })
        }
        Flex({ direction: FlexDirection.Row, wrap:FlexWrap.Wrap, justifyContent: FlexAlign.SpaceEvenly,
            alignItems: ItemAlign.Center, alignContent:FlexAlign.Center }){
          Button($r('app.string.Stop'), { type: ButtonType.Capsule, stateEffect: true })
            .id("Stop")
            .backgroundColor(0x4287F5)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Stop AVRecorder %{public}d', testNapi.stopAVRecorder());
            })
          Button($r('app.string.Reset'), { type: ButtonType.Capsule, stateEffect: true })
            .id("Reset")
            .backgroundColor(0x4287F5)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Reset AVRecorder %{public}d', testNapi.resetAVRecorder());
            })
          Button($r('app.string.Release'), { type: ButtonType.Capsule, stateEffect: true })
            .id("Release")
            .backgroundColor(0x4287F5)
            .width(65)
            .height(65)
            .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Release AVRecorder %{public}d', testNapi.releaseAVRecorder());
            })
        }
      }
      .width('100%')
    .height('100%')
  }
}
