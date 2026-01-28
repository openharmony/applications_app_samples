/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import { camera } from '@kit.CameraKit';
import { display } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { Logger } from 'commons';
import OutputManager, { CreateOutputConfig, OutputType } from './OutputManager';
import CameraConstant from '../constants/CameraConstants';

const TAG = 'ImageReceiverManager';

export class ImageReceiverManager implements OutputManager {
  public type: OutputType = OutputType.PREVIEW;
  public output?: camera.PreviewOutput;
  public isActive: boolean = true;
  public callback: (px: PixelMap) => void;
  private position: camera.CameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;

  constructor(cb: (px: PixelMap) => void) {
    this.callback = cb;
  }

  async createOutput(config: CreateOutputConfig) {
    const cameraOutputCap = config.cameraManager.getSupportedOutputCapability(config.device, config.sceneMode);
    const displayRatio = config.profile.size.width / config.profile.size.height;
    const profileWidth = config.profile.size.width;
    const previewProfile = cameraOutputCap.previewProfiles
      .sort((a, b) => Math.abs(a.size.width - profileWidth) - Math.abs(b.size.width - profileWidth))
      .find(pf => {
        const pfDisplayRatio = pf.size.width / pf.size.height;
        return pf.format === config.profile.format &&
          Math.abs(pfDisplayRatio - displayRatio) <= CameraConstant.PROFILE_DIFFERENCE;
      });
    if (!previewProfile) {
      Logger.error(TAG, 'Failed to get preview profile');
      return;
    }
    const surfaceId = await this.init(config.profile.size);
    this.output = config.cameraManager.createPreviewOutput(previewProfile, surfaceId);
    this.position = config.device.cameraPosition;
    return this.output;
  }

  async release() {
    await this.output?.release();
    this.output = undefined;
  }

  // [Start init]
  async init(size: Size, format = image.ImageFormat.JPEG, capacity = 8) {
    const receiver = image.createImageReceiver(size, format, capacity);
    const surfaceId = await receiver.getReceivingSurfaceId();
    this.onImageArrival(receiver);
    return surfaceId;
  }
  // [End init]

  // [Start getPixelMap]
  async getPixelMap(imgComponent: image.Component, width: number, height: number, stride: number) {
    if (stride === width) {
      return await image.createPixelMap(imgComponent.byteBuffer, {
        size: { height: height, width: width },
        srcPixelFormat: image.PixelMapFormat.NV21,
      });
    }
    const dstBufferSize = width * height * 1.5;
    const dstArr = new Uint8Array(dstBufferSize);
    for (let j = 0; j < height * 1.5; j++) {
      const srcBuf = new Uint8Array(imgComponent.byteBuffer, j * stride, width);
      dstArr.set(srcBuf, j * width);
    }
    return await image.createPixelMap(dstArr.buffer, {
      size: { height: height, width: width },
      srcPixelFormat: image.PixelMapFormat.NV21,
    });
  }
  // [End getPixelMap]

  // [Start onImageArrival]
  onImageArrival(receiver: image.ImageReceiver): void {
    receiver.on('imageArrival', () => {
      Logger.info(TAG, 'image arrival');
      receiver.readNextImage((err: BusinessError, nextImage: image.Image) => {
        if (err || nextImage === undefined) {
          Logger.error(TAG, 'readNextImage failed');
          return;
        }
        // [Start release]
        // [Start nextImage]
        nextImage.getComponent(image.ComponentType.JPEG, async (err: BusinessError, imgComponent: image.Component) => {
          // [StartExclude release]
          if (err || imgComponent === undefined) {
            Logger.error(TAG, 'getComponent failed');
          }
          if (imgComponent.byteBuffer) {
            // [StartExclude onImageArrival]
            const width = nextImage.size.width;
            const height = nextImage.size.height;
            const stride = imgComponent.rowStride;
            Logger.info(TAG, `getComponent with width:${width} height:${height} stride:${stride}`);
            const pixelMap = await this.getPixelMap(imgComponent, width, height, stride);
            const displayRotation = display.getDefaultDisplaySync().rotation * camera.ImageRotation.ROTATION_90;
            const rotation = this.output!.getPreviewRotation(displayRotation);
            if (this.position === camera.CameraPosition.CAMERA_POSITION_FRONT) {
              if (displayRotation === 90 || displayRotation === 270) {
                await pixelMap.rotate((rotation + 180) % 360);
              } else {
                await pixelMap.rotate(rotation);
              }
              await pixelMap.flip(true, false);
            } else {
              await pixelMap.rotate(rotation);
            }
            this.callback(pixelMap);
            // [EndExclude onImageArrival]
          } else {
            Logger.error(TAG, 'byteBuffer is null');
          }
          // [EndExclude release]
          // [StartExclude nextImage]
          // [StartExclude onImageArrival]
          nextImage.release().then(() => {Logger.info(TAG, 'image release done');}).catch((error: BusinessError) => {
            Logger.error(TAG, `Release failed! Code ${error.code},message is ${error.message}`);
          });
          Logger.info(TAG, 'image process done');
          // [EndExclude onImageArrival]
          // [EndExclude nextImage]
        });
        // [End release]
        // [End nextImage]
      });
    });
  }
  // [End onImageArrival]
}
