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

// [Start receiver_import]
import image from '@ohos.multimedia.image'
import { camera } from '@kit.CameraKit';
import { BusinessError } from '@ohos.base'
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End receiver_import]

const TAG: string = '[ImageCameraPage]';
const WIDTH: number = 480; // rk3568设备支持profile的size的宽。
const HEIGHT: number = 480; // rk3568设备支持profile的size的高。
const CAPACITY = 8;
const FORMAT_JPEG = image.ImageFormat.JPEG;
// [Start init_deviceWidth]
let imageWidth: number = 1920; // 请使用设备支持profile的size的宽。
let imageHeight: number = 1080; // 请使用设备支持profile的size的高。
// [End init_deviceWidth]

// [Start init_receiver]
async function initImageReceiver(): Promise<void> {
  // 创建ImageReceiver对象。createImageReceiver的参数不会对接收到的数据产生实际影响。
  let size: image.Size = { width: imageWidth, height: imageHeight };
  let imageReceiver = image.createImageReceiver(size, image.ImageFormat.JPEG, 8);
  // 获取预览流SurfaceId。
  let imageReceiverSurfaceId = await imageReceiver.getReceivingSurfaceId();
  console.info(`initImageReceiver imageReceiverSurfaceId:${imageReceiverSurfaceId}`);
}
// [End init_receiver]

// [Start On_imageArrival]
function onImageArrival(receiver: image.ImageReceiver) {
  // 注册imageArrival监听。
  receiver.on('imageArrival', () => {
    // 获取图像。
    receiver.readNextImage((err: BusinessError, nextImage: image.Image) => {
      if (err || nextImage === undefined) {
        console.error('readNextImage failed');
        return;
      }
      // 解析图像内容。
      nextImage.getComponent(image.ComponentType.JPEG, async (err: BusinessError,
        imgComponent: image.Component) => {
        if (err || imgComponent === undefined) {
          console.error('getComponent failed');
        }
        if (imgComponent.byteBuffer) {
          // 详情见下方解析图片buffer数据参考，本示例以方式一为例。
          let width = nextImage.size.width; // 获取图片的宽。
          let height = nextImage.size.height; // 获取图片的高。
          let stride = imgComponent.rowStride; // 获取图片的stride。
          console.debug(`getComponent with width:${width} height:${height} stride:${stride}`);
          // stride与width一致。
          if (stride == width) {
            let pixelMap = await image.createPixelMap(imgComponent.byteBuffer, {
              size: { height: height, width: width },
              srcPixelFormat: 8,
            })
          } else {
            // stride与width不一致。
            const dstBufferSize = width * height * 1.5;
            const dstArr = new Uint8Array(dstBufferSize);
            for (let j = 0; j < height * 1.5; j++) {
              // 不同设备内存不同，若内存太小，则无法全部写完。
              const srcBuf = new Uint8Array(imgComponent.byteBuffer, j * stride, width);
              dstArr.set(srcBuf, j * width);
            }
            let pixelMap = await image.createPixelMap(dstArr.buffer, {
              size: { height: height, width: width },
              srcPixelFormat: 8,
            })
          }
        } else {
          console.error('byteBuffer is null');
        }
        // 确保当前buffer没有在使用的情况下，可进行资源释放。
        // 如果对buffer进行异步操作，需要在异步操作结束后再释放该资源（nextImage.release()）。
        nextImage.release();
      })
    })
  })
}
// [End On_imageArrival]

async function firstAdjustBufferSize(imgComponent: image.Component, height: number, width: number, stride: number)
  : Promise<image.PixelMap> {
  // [Start adjust_bufferSize]
  // stride与width不一致。
  const dstBufferSize = width * height * 1.5
  const dstArr = new Uint8Array(dstBufferSize)
  for (let j = 0; j < height * 1.5; j++) {
    const srcBuf = new Uint8Array(imgComponent.byteBuffer, j * stride, width)
    dstArr.set(srcBuf, j * width)
  }
  let pixelMap = await image.createPixelMap(dstArr.buffer, {
    size: { height: height, width: width },
    srcPixelFormat: 8,
  })
  // [End adjust_bufferSize]
  return pixelMap;
}

async function secondAdjustBufferSize(imgComponent: image.Component, height: number, width: number, stride: number)
  : Promise<image.PixelMap> {
  // [Start adjust_width]
  // 创建pixelMap，width宽传行距stride的值。
  let pixelMap = await image.createPixelMap(imgComponent.byteBuffer, {
    size:{height: height, width: stride}, srcPixelFormat: 8});
  // 裁剪多余的像素。
  pixelMap.cropSync({size:{width:width, height:height}, x:0, y:0});
  // [End adjust_width]
  return pixelMap;
}

export class ReceiverUtility {
  // 获取支持的设备
  getSupportedCameras(cameraManager: camera.CameraManager): Array<camera.CameraDevice> {
    let cameras = cameraManager.getSupportedCameras();
    if (!cameras) {
      hilog.info(0x00000, TAG, `initCamera getSupportedCameras failed!`);
    } else {
      hilog.info(0x00000, TAG, `initCamera getSupportedCameras success! ` + cameras.length);
    }
    return cameras;
  }

  // 创建相机管理器
  async initCamera(cameraManager: camera.CameraManager): Promise<camera.Profile> {
    let cameras = cameraManager.getSupportedCameras();
    if (!cameras) {
      hilog.info(0x00000, TAG, `initCamera getSupportedCameras failed!`);
    } else {
      hilog.info(0x00000, TAG, `initCamera getSupportedCameras success! ` + cameras.length);
    }
    let cameraInput = cameraManager.createCameraInput(cameras[0]) as camera.CameraInput;
    if (!cameraInput) {
      hilog.info(0x00000, TAG, `initCamera createCameraInput failed!`);
    } else {
      hilog.info(0x00000, TAG, `initCamera createCameraInput success!`);
    }
    await cameraInput?.open();

    let capability: camera.CameraOutputCapability =
      cameraManager.getSupportedOutputCapability(cameras[0], camera.SceneMode.NORMAL_VIDEO);
    if (!capability) {
      hilog.info(0x00000, TAG, `initCamera getSupportedOutputCapability failed!`);
    }
    let previewProfile: camera.Profile = capability.previewProfiles[0];
    let imageWidth = previewProfile.size.width;
    let imageHeight = previewProfile.size.height;
    hilog.info(0x00000, TAG, `initCamera imageWidth:${imageWidth} imageHeight:${imageHeight}`);
    return previewProfile;
  }

  // 创建相机输入流
  async createCameraInput(cameraManager: camera.CameraManager, cameras: Array<camera.CameraDevice>)
    : Promise<camera.CameraInput> {
    let cameraInput = cameraManager.createCameraInput(cameras[0]) as camera.CameraInput;
    if (!cameraInput) {
      hilog.info(0x00000, TAG, `initCamera createCameraInput failed!`);
    } else {
      hilog.info(0x00000, TAG, `initCamera createCameraInput success!`);
    }
    await cameraInput?.open();
    return cameraInput;
  }

  // 创建预览输出流
  createPreviewOutput(cameraManager: camera.CameraManager, previewProfile: camera.Profile, receiverSurfaceId: string)
    : camera.PreviewOutput | undefined {
    let previewOutput = cameraManager.createPreviewOutput(previewProfile, receiverSurfaceId) as camera.PreviewOutput;
    if (!previewOutput) {
      hilog.info(0x00000, TAG, `Create previewOutput failed!`);
    }
    return previewOutput;
  }

  // 创建会话
  createSession(cameraManager: camera.CameraManager, cameraInput: camera.CameraInput,
    previewOutput1: camera.PreviewOutput, previewOutput2: camera.PreviewOutput): camera.VideoSession | undefined {
    let tmpSession = cameraManager.createSession<camera.VideoSession>(camera.SceneMode.NORMAL_VIDEO);
    let session = tmpSession as camera.VideoSession;
    if (!session) {
      hilog.info(0x00000, TAG, `initCamera createSession failed!`);
    }
    hilog.info(0x00000, TAG, `initCamera beginConfig!`);
    session?.beginConfig();
    session?.addInput(cameraInput as camera.CameraInput);
    session?.addOutput(previewOutput1 as camera.PreviewOutput);
    session?.addOutput(previewOutput2 as camera.PreviewOutput);
    session?.commitConfig();
    session?.start();
    hilog.info(0x00000, TAG, `initCamera initCamera Finished!`);
    return session;
  }

  // 创建receiver
  async initImageReceiver(): Promise<image.ImageReceiver | undefined> {
    let globalSize: image.Size = { height: HEIGHT, width: WIDTH };
    let receiver = image.createImageReceiver(globalSize, FORMAT_JPEG, CAPACITY) as image.ImageReceiver;
    if (receiver == undefined) {
      hilog.info(0x00000, TAG, `failed! this.receiver is undefined!`);
    }
    return receiver;
  }

  // 获取receiver的surfaceId
  async getReceiverSurfaceId(receiver: image.ImageReceiver | undefined): Promise<string | undefined> {
    let receiverSurfaceId: string | undefined = '';
    if (receiver) {
      receiverSurfaceId = await receiver.getReceivingSurfaceId();
    } else {
      hilog.error(0x00000, TAG, `Get surfaceId failed because of the receiver is undefined.`);
    }
    return receiverSurfaceId;
  }

  // 设置receiver的监听事件
  async onArrival(receiver: image.ImageReceiver) {
    onImageArrival(receiver);
  }

  // 开始相机会话
  async startCameraSession(cameraManager: camera.CameraManager,
    receiverSurfaceId: string, thisXComponentSurfaceId: string) {
    let profile = await this.initCamera(cameraManager);
    let imageHeight = profile.size.height;
    let imageWidth = profile.size.width;
    let previewOutput1 = this.createPreviewOutput(cameraManager, profile, receiverSurfaceId);
    let previewOutput2 = this.createPreviewOutput(cameraManager, profile, thisXComponentSurfaceId);
    let cameras = this.getSupportedCameras(cameraManager);
    let cameraInput = await this.createCameraInput(cameraManager, cameras);
    let session = this.createSession(cameraManager, cameraInput, previewOutput1 as camera.PreviewOutput,
      previewOutput2 as camera.PreviewOutput);
  }

  //释放相机会话
  async releaseCamera(receiver: image.ImageReceiver | undefined, session: camera.Session | undefined,
    cameraInput: camera.CameraInput | undefined, previewOutput1: camera.PreviewOutput | undefined,
    previewOutput2: camera.PreviewOutput | undefined){
    hilog.info(0x00000, TAG, `releaseCamera begin`);
    try {
      receiver?.off('imageArrival');
      // 停止当前会话。
      await session?.stop();
      // 释放相机输入流。
      await cameraInput?.close();
      // 释放预览输出流。
      await previewOutput1?.release();
      // 释放拍照输出流。
      await previewOutput2?.release();
      // 释放会话。
      await session?.release();
      hilog.info(0x00000, TAG, `releaseCamera end`);
    } catch (error) {
      hilog.error(0x00000, TAG, `release failed: ${error}`);
    }
  }
}
