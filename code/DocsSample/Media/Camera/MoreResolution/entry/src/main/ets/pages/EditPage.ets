/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
// 提供拍照后图片预览和编辑页面
import { image } from '@kit.ImageKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { router } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { camera } from '@kit.CameraKit';
import { fileIo, ReadOptions, WriteOptions } from '@kit.CoreFileKit';
import Logger from '../common/utils/Logger';
import { GlobalContext } from '../common/utils/GlobalContext';
import { Constants } from '../common/Constants';
import CameraService from '../model/CameraService';


const TAG = 'EditPage';

class RequestImageParams {
  private context: Context | undefined = undefined;
  private photoAsset: photoAccessHelper.PhotoAsset | undefined = undefined;
  private callback: Function = () => {
  };
}

@Entry
@Component
export struct EditPage {
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
    if (imageSource == undefined) {
      return;
    }
    imageSource.createPixelMap((err: BusinessError, data: image.PixelMap) => {
      Logger.info(TAG, `createPixelMap err: ${err}`);
      Logger.info(TAG, 'createPixelMap is called');
      this.curPixelMap = data;
    })
  }
  private phAccessHelper = photoAccessHelper.getPhotoAccessHelper(getContext(this));

  requestImage(requestImageParams: RequestImageParams): void {
    try {
      class MediaDataHandler implements photoAccessHelper.MediaAssetDataHandler<ArrayBuffer> {
        onDataPrepared(data: ArrayBuffer, map: Map<string, string>) {
          Logger.info(TAG, 'onDataPrepared begin');
          Logger.info(TAG, `onDataPrepared quality: ${map['quality']}`);
          requestImageParams.callback(data);
          Logger.info(TAG, 'onDataPrepared end');
        }
      }

      let requestOptions: photoAccessHelper.RequestOptions = {
        deliveryMode: photoAccessHelper.DeliveryMode.BALANCE_MODE,
      }
      const handler = new MediaDataHandler();
      photoAccessHelper.MediaAssetManager.requestImageData(requestImageParams.context, requestImageParams.photoAsset,
        requestOptions, handler);
    } catch (error) {
      Logger.error(TAG, `Failed in requestImage, error code: ${error.code}`);
    }
  }

  async mediaLibSavePhoto(photoAsset: photoAccessHelper.PhotoAsset): Promise<number> {
    let errCode = -1;
    try {
      let assetChangeRequest: photoAccessHelper.MediaAssetChangeRequest = 
        new photoAccessHelper.MediaAssetChangeRequest(photoAsset);
      assetChangeRequest.saveCameraPhoto();
      await this.phAccessHelper.applyChanges(assetChangeRequest);
      console.info('apply saveCameraPhoto successfully');
      errCode = 0;
    } catch (err) {
      console.error(`apply saveCameraPhoto failed with error: ${err.code}, ${err.message}`);
    }
    return errCode;
}

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear begin');
    this.sceneMode = GlobalContext.get().getT<camera.SceneMode>('sceneMode');
    if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
      if (!CameraService.is2in1()) {
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
      } else {
        let photoArrayBuffer = GlobalContext.get().getT<ArrayBuffer>('photoArrayBuffer');
        this.photoBufferCallback(photoArrayBuffer);
      }
    }
    if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
      this.videoController = new VideoController();
      this.videoUri = `file://${getContext().filesDir}/${AppStorage.get('fileName')}`;
      Logger.info(TAG, `aboutToAppear videoUri: ${this.videoUri}`);
    }
  }

  aboutToDisappear(): void {
    CameraService.deleteVideoFile();
  }

  async readWriteFile(sourceUri: string, destUri: string): Promise<void> {
    // 打开文件
    let srcFile = fileIo.openSync(sourceUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    let destFile = fileIo.openSync(destUri, fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE);
    // 读取源文件内容并写入至目的文件
    let bufSize = 4096;
    let readSize = 0;
    let buf = new ArrayBuffer(bufSize);
    let readOptions: ReadOptions = {
      offset: readSize,
      length: bufSize
    };
    let readLen = fileIo.readSync(srcFile.fd, buf, readOptions);
    while (readLen > 0) {
      readSize += readLen;
      let writeOptions: WriteOptions = {
        length: readLen
      };
      fileIo.writeSync(destFile.fd, buf, writeOptions);
      readOptions.offset = readSize;
      readLen = fileIo.readSync(srcFile.fd, buf, readOptions);
    }
    // 关闭文件
    fileIo.closeSync(srcFile);
    fileIo.closeSync(destFile);
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .objectFit(ImageFit.Fill)
          .onClick(() => {
            Logger.info(TAG, 'back onClick');
            router.back();
          })
          .width(Constants.BACK_ICON_SIZE)
          .height(Constants.BACK_ICON_SIZE)
          .id('return')
        if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO && !CameraService.is2in1()) {
          Text($r('app.string.save'))
            .width(48)
            .height(Constants.BACK_ICON_SIZE)
            .onClick(async () => {
              let curPhotoAsset = GlobalContext.get().getT<photoAccessHelper.PhotoAsset>('photoAsset');
              let errCode = await this.mediaLibSavePhoto(curPhotoAsset);
              GlobalContext.get().getPromptAction()?.showToast({
                message: errCode == 0 ? "保存成功" : "保存失败",
                duration: 2000,
                bottom: '50%'
              });
            })
        }
        if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO && CameraService.is2in1()) {
          // 安全控件需要完全展示出来，不然result会返回TEMPORARY_AUTHORIZATION_FAILED
          SaveButton().onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
            Logger.info(TAG, `result == SaveButtonOnClickResult.SUCCESS ${result == SaveButtonOnClickResult.SUCCESS}`);
            if (result == SaveButtonOnClickResult.SUCCESS) {
              let fd = -1;
              let errCode = -1;
              try {
                // onClick触发后5秒内通过createAsset接口创建图片文件，5秒后createAsset权限收回。
                let filePath = await this.phAccessHelper.createAsset(photoAccessHelper.PhotoType.IMAGE, 'jpeg');
                const imagePacker = image.createImagePacker();
                if (this.curPixelMap === undefined) {
                  return;
                }
                const mode = fileIo.OpenMode.READ_WRITE | fileIo.OpenMode.CREATE;
                let buffer: ArrayBuffer = await imagePacker.packing(this.curPixelMap, {
                  format: 'image/jpeg',
                  quality: 100,
                });
                fileIo.open(filePath, mode).then((file) => {
                  fileIo.write(file.fd, buffer).then(() => {
                    fileIo.close(file.fd);
                  });
                })
                this.curPixelMap.release();
                imagePacker.release();
                errCode = 0;
                GlobalContext.get().getPromptAction()?.showToast({
                  message: errCode == 0 ? '保存成功' : '保存失败',
                  duration: 2000,
                  bottom: '50%'
                });
              } catch (err) {
              } finally {
                if (fd) {
                  fileIo.close(fd);
                }
              }
            }
          })
        }
      }
      .padding({ left: Constants.BACK_ICON_MARGIN, right: Constants.BACK_ICON_MARGIN})
      .width(Constants.FULL_PERCENT)
      .layoutWeight(this.backIconLayoutWeight)
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.SpaceBetween)

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
      Column() {
        if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
          // 安全控件需要完全展示出来，不然result会返回TEMPORARY_AUTHORIZATION_FAILED
          SaveButton().onClick(async (event: ClickEvent, result: SaveButtonOnClickResult) => {
            Logger.info(TAG, `result == SaveButtonOnClickResult.SUCCESS ${result == SaveButtonOnClickResult.SUCCESS}`);
            if (result == SaveButtonOnClickResult.SUCCESS) {
              let errCode = -1;
              try {
                // onClick触发后5秒内通过createAsset接口创建图片文件，5秒后createAsset权限收回。
                let uri = await this.phAccessHelper.createAsset(photoAccessHelper.PhotoType.VIDEO, 'mp4');
                if (this.videoUri !== undefined) {
                  await this.readWriteFile(this.videoUri, uri);
                  errCode = 0;
                }
              } catch (error) {
                Logger.error(TAG, 'SaveButton error is ' + JSON.stringify(error));
              }
              GlobalContext.get().getPromptAction()?.showToast({
                message: errCode == 0 ? '保存成功' : '保存失败',
                duration: 2000,
                bottom: '50%'
              });
            }
          })
        }
      }
      .margin({bottom: 24})
    }
    .width(Constants.FULL_PERCENT)
    .height(Constants.FULL_PERCENT)
    .backgroundColor($r('app.color.dialog_background_color'))
  }
}