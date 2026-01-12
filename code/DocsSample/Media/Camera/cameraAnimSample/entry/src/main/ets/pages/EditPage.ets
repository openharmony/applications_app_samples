/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 ("the License");
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

import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { camera } from '@kit.CameraKit';
import { fileIo } from '@kit.CoreFileKit';
import Logger from '../common/utils/Logger';
import { GlobalContext } from '../common/utils/GlobalContext';
import { Constants } from '../common/Constants';

const TAG: string = 'EditPage';

class RequestImageParams {
  context: Context | undefined = undefined;
  photoAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  callback: Function = () => {
  };
}

@Entry
@Component
struct EditPage {
  @State createPixelMapState: boolean = false;
  @State curPixelMap: image.PixelMap | undefined = undefined;
  @State photoUri: string = '';
  private sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  private backIconLayoutWeight = 1;
  private textLayoutWeight = 8;
  private videoController: VideoController | undefined = undefined;
  private controls: boolean = true;
  private videoUri: string | undefined = '';
  photoBufferCallback: (arrayBuffer: ArrayBuffer) => void = (arrayBuffer: ArrayBuffer) => {
    Logger.info(TAG, 'photoBufferCallback is called');
    let imageSource = image.createImageSource(arrayBuffer);
    imageSource.createPixelMap((err: BusinessError, data: image.PixelMap) => {
      Logger.info(TAG, 'createPixelMap is called');
      this.curPixelMap = data;
    });
  };

  requestImage(requestImageParams: RequestImageParams): void {
    try {
      class MediaDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
        onDataPrepared(data: ArrayBuffer, map: Map<string, string>): void {
          Logger.info(TAG, 'onDataPrepared begin');
          Logger.info(TAG, `onDataPrepared quality: ${map['quality']}`);
          requestImageParams.callback(data);
          Logger.info(TAG, 'onDataPrepared end');
        }
      };
      let requestOptions: photoAccessHelper.RequestOptions = {
        deliveryMode: photoAccessHelper.DeliveryMode.BALANCE_MODE,
      };
      const handler = new MediaDataHandler();
      photoAccessHelper.MediaAssetManager.requestImageData(requestImageParams.context, requestImageParams.photoAsset,
        requestOptions, handler);
    } catch (error) {
      Logger.error(TAG, `Failed in requestImage, error code: ${error.code}`);
    }
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear begin');
    this.sceneMode = GlobalContext.get().getT<camera.SceneMode>('sceneMode');
    if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
      let curPhotoAsset = GlobalContext.get().getT<photoAccessHelper.PhotoAsset>('photoAsset');
      this.photoUri = curPhotoAsset.uri;
      let requestImageParams: RequestImageParams = {
        context: getContext(),
        photoAsset: curPhotoAsset,
        callback: this.photoBufferCallback
      };
      setTimeout(() => {
        this.requestImage(requestImageParams);
      }, 500);
      Logger.info(TAG, `aboutToAppear photoUri: ${this.photoUri}`);
    } else if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
      this.videoController = new VideoController();
      this.videoUri = 'file://' + AppStorage.get<string>('filePath');
      Logger.info(TAG, `aboutToAppear videoUri: ${this.videoUri}`);
    }
  }

  build() {
    Column() {
      Column() {
        Image($r('app.media.ic_public_back'))
          .objectFit(ImageFit.Fill)
          .onClick(() => {
            Logger.info(TAG, 'back onClick');
            // delete video file when router back
            fileIo.unlink(this.videoUri);
            router.back();
          })
          .width(Constants.BACK_ICON_SIZE)
          .height(Constants.BACK_ICON_SIZE)
      }
      .padding({ left: Constants.BACK_ICON_MARGIN })
      .width(Constants.FULL_PERCENT)
      .layoutWeight(this.backIconLayoutWeight)
      .alignItems(HorizontalAlign.Start)
      .justifyContent(FlexAlign.Center)

      Column() {
        if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
          Image(this.curPixelMap)
            .objectFit(ImageFit.Contain)
            .width(Constants.FULL_PERCENT)
            .height(Constants.EIGHTY_PERCENT)
        } else if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
          Video({
            src: this.videoUri,
            controller: this.videoController
          })
            .width(Constants.FULL_PERCENT)
            .height(Constants.EIGHTY_PERCENT)
            .controls(this.controls)
            .objectFit(ImageFit.Contain)
            .onClick(() => {
              if (this.controls) {
                this.videoController?.start();
              } else {
                this.videoController?.stop();
              }
              this.controls = !this.controls;
            })
            .onFinish(() => {
              this.controls = true;
            })
        }
      }
      .width(Constants.FULL_PERCENT)
      .layoutWeight(this.textLayoutWeight)
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
    .backgroundColor($r('app.color.dialog_background_color'))
  }
}