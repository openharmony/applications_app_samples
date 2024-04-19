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

// 反转摄像头_多机位_拍照_摄像

import { RecodeStopDialog } from '../Dialog/RecodeStopDialog';
import DateTimeUtil from '../model/DateTimeUtil';
import Logger from '../model/Logger';
import CameraService from '../model/CameraService';
import image from '@ohos.multimedia.image';
import { BusinessError } from '@ohos.base';
import { Constants } from '../common/Constants';
import { GlobalContext } from '../common/GlobalContext';
import camera from '@ohos.multimedia.camera';
import { PromptAction } from '@ohos.arkui.UIContext';
import photoAccessHelper from '@ohos.file.photoAccessHelper';
import dataSharePredicates from '@ohos.data.dataSharePredicates';

const TAG: string = 'ModeSwitchPage';
let globalContext: GlobalContext = GlobalContext.get();

@Component
export struct ModeSwitchPage {
  // 相机摄像头
  @Link cameraDeviceIndex: number;
  // surfaceID值
  @Prop surfaceId: string;
  // 倒计时值
  @Link countdownNum: number;
  // 倒计时定时器
  @State countTimerInt: number = -1;
  @State countTimerOut: number = -1;
  // 拍照缩略图
  @StorageLink('proxyThumbnail') imgThumbnail: string = '';
  // 录制时间
  @State videoRecodeTime: number = 0;
  // 录制时间定时器
  @State timer: number = 0;
  // 时间管理器
  @State dateTimeUtil: DateTimeUtil = new DateTimeUtil();
  // 选择模式
  @State modelBagCol: string = 'photo';
  // 选择相机或者拍照
  @State @Watch('onChangeIsModeBol') isModeBol: boolean = true;
  // 录像开始暂停
  @State isRecording: boolean = false;
  // 视频缩略图
  @State videoThumbnail: image.PixelMap | undefined = undefined;
  private videoUri: string = '';
  private deviceType: string | undefined = '';

  // 确定是否停止录制的弹框
  private recodeStopDialogController: CustomDialogController = new CustomDialogController({
    builder: RecodeStopDialog({
      isModeBol: $isModeBol,
      videoRecodeTime: $videoRecodeTime,
      isRecording: $isRecording
    }),
    autoCancel: false,
    customStyle: true
  });

  /**
   * 暂停后点击停止 需要将暂停回复默认
   */
  onChangeIsModeBol(): void {
    this.isRecording = false;
  }

  /**
   * 恢复视频录制
   */
  async resumeVideo(): Promise<void> {
    await CameraService.resumeVideo();
    this.timer = setInterval(() => {
      this.videoRecodeTime += 1000;
    }, 1000);
  }

  /**
   * 录制 暂停/开始
   */
  async onChangeRecord(): Promise<void> {
    Logger.info(TAG, `onChangeRecord isRecording: ${this.isRecording}`);
    if (this.isRecording) {
      // 开始
      await this.resumeVideo();
    } else {
      // 暂停
      if (this.timer !== undefined) {
        clearInterval(this.timer);
        Logger.debug(TAG, `onChangeRecord clear timer success`);
      }
      await CameraService.pauseVideo();
    }
    this.isRecording = !this.isRecording;
  }

  /**
   * 倒计时拍照和录像
   */
  countTakeVideoFn(): void {
    if (this.countdownNum) {
      // 清除定时器
      if (this.countTimerOut) {
        clearTimeout(this.countTimerOut);
      }
      if (this.countTimerInt) {
        clearInterval(this.countTimerInt);
      }
      // 开启定时器
      this.countTimerOut = setTimeout(() => {
        // 判断是录像还是拍照模式
        this.isVideoPhotoFn();
      }, this.countdownNum * 1000);
      // 开启计时器
      this.countTimerInt = setInterval(() => {
        this.countdownNum--;
        if (this.countdownNum === 0) {
          clearInterval(this.countTimerInt);
        }
      }, 1000);
    } else {
      this.isVideoPhotoFn();
    }
  }

  /**
   * 判断录像或者照片模式
   */
  isVideoPhotoFn(): void {
    if (this.modelBagCol == 'photo' || this.modelBagCol == 'portrait' || this.modelBagCol == 'night') {
      CameraService.takePicture();
    } else if (this.modelBagCol == 'video' || this.modelBagCol == 'superStab') {
      this.isModeBol = false;
      if (this.timer !== undefined) {
        clearInterval(this.timer);
      }
      // 开始录制
      CameraService.startVideo().then((): void => {
        // 计时器
        this.timer = setInterval(() => {
          this.videoRecodeTime += 1000;
        }, 1000);
      });
    }
  }

  stopVideo(): void {
    if (this.timer !== undefined) {
      clearInterval(this.timer);
      Logger.debug(TAG, `onChangeRecord clear timer success`);
    }
    this.isModeBol = true;
    this.videoRecodeTime = 0;
  }

  async initPhotoThumbnail() {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, photoAccessHelper.PhotoType.IMAGE)
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates
    };
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(GlobalContext.get().getCameraSettingContext());
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await phAccessHelper.getAssets(fetchOptions);
    let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
    this.imgThumbnail = await photoAsset.uri;
  }

  async initVideoThumbnail() {
    let predicates: dataSharePredicates.DataSharePredicates = new dataSharePredicates.DataSharePredicates();
    predicates.equalTo(photoAccessHelper.PhotoKeys.PHOTO_TYPE, photoAccessHelper.PhotoType.VIDEO)
    let fetchOptions: photoAccessHelper.FetchOptions = {
      fetchColumns: [],
      predicates: predicates
    };
    let phAccessHelper = photoAccessHelper.getPhotoAccessHelper(GlobalContext.get().getCameraSettingContext());
    let fetchResult: photoAccessHelper.FetchResult<photoAccessHelper.PhotoAsset> = await phAccessHelper.getAssets(fetchOptions);
    let photoAsset: photoAccessHelper.PhotoAsset = await fetchResult.getFirstObject();
    this.videoThumbnail = await photoAsset.getThumbnail();
    this.videoUri = photoAsset.uri;
  }

  aboutToAppear() {
    Logger.info(TAG, 'aboutToAppear');
    GlobalContext.get().setObject('stopVideoFun', this.stopVideo);
    this.deviceType = AppStorage.get<string>('deviceType');
    CameraService.setTakePictureCallback(this.handleTakePicture);
    this.initPhotoThumbnail();
    this.initVideoThumbnail();
  }

  handleTakePicture = (thumbnail: string) => {
    this.imgThumbnail = thumbnail;
    Logger.info(TAG, `takePicture end, thumbnail: ${this.imgThumbnail}`);
  }

  build() {
    Column() {
      if (this.isModeBol) {
        Stack({ alignContent: Alignment.Bottom }) {
          Column({ space: 24 }) {
            Row() {
              // 超级防抖
              Column() {
                Text($r('app.string.super_steady'))
                  .fontSize(14)
                  .fontColor(Color.White)
              }
              .width(70)
              .backgroundColor(this.modelBagCol === 'superStab' ? $r('app.color.theme_color') : '')
              .borderRadius(14)
              .onClick(async () => {
                this.modelBagCol = 'superStab';
                AppStorage.setOrCreate('isHiddenSlide', true);
                CameraService.setCameraMode(3);
                await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
                let isSupported = CameraService.isVideoStabilizationModeSupportedFn(camera.VideoStabilizationMode.HIGH);
                if (!isSupported) {
                  (GlobalContext.get().getPromptAction() as PromptAction).showToast({
                    message: $r('app.string.not_support_super_steady'),
                    duration: 2000,
                    bottom: '50%'
                  })
                }
              })
              .visibility(this.deviceType === Constants.DEFAULT ? Visibility.Hidden : Visibility.Visible)

              // 人像
              Column() {
                Text($r('app.string.portrait'))
                  .fontSize(14)
                  .fontColor(Color.White)
              }
              .width(50)
              .backgroundColor(this.modelBagCol === 'portrait' ? $r('app.color.theme_color') : '')
              .borderRadius(14)
              .onClick(async () => {
                this.modelBagCol = 'portrait';
                AppStorage.setOrCreate('isHiddenSlide', false);
                CameraService.setCameraMode(2);
                await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
                let isSupported = CameraService.isPortraitModeSupportedFn();
                if (!isSupported) {
                  (GlobalContext.get().getPromptAction() as PromptAction).showToast({
                    message: $r('app.string.not_support_portrait'),
                    duration: 2000,
                    bottom: '50%'
                  })
                }
              })
              .visibility(this.deviceType === Constants.DEFAULT ? Visibility.Hidden : Visibility.Visible)

              // 夜景
              Column() {
                Text($r('app.string.night_view'))
                  .fontSize(14)
                  .fontColor(Color.White)
              }
              .width(50)
              .backgroundColor(this.modelBagCol === 'night' ? $r('app.color.theme_color') : '')
              .borderRadius(14)
              .onClick(async () => {
                this.modelBagCol = 'night';
                AppStorage.setOrCreate('isHiddenSlide', true);
                CameraService.setCameraMode(4);
                await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
                let isSupported = CameraService.isNightModeSupportedFn();
                if (!isSupported) {
                  (GlobalContext.get().getPromptAction() as PromptAction).showToast({
                    message: $r('app.string.not_support_night_view'),
                    duration: 2000,
                    bottom: '50%'
                  })
                }
              })
              .visibility(this.deviceType === Constants.DEFAULT ? Visibility.Hidden : Visibility.Visible)

              // 拍照
              Column() {
                Text($r('app.string.photo'))
                  .fontSize(14)
                  .fontColor(Color.White)
              }
              .width(50)
              .backgroundColor(this.modelBagCol === 'photo' ? $r('app.color.theme_color') : '')
              .borderRadius(14)
              .onClick(async () => {
                this.modelBagCol = 'photo';
                AppStorage.setOrCreate('isHiddenSlide', false);
                CameraService.setCameraMode(0);
                await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
              })

              // 录像
              Column() {
                Text($r('app.string.video'))
                  .fontSize(14)
                  .fontColor(Color.White)
              }
              .width(50)
              .backgroundColor(this.modelBagCol === 'video' ? $r('app.color.theme_color') : '')
              .borderRadius(14)
              .onClick(async () => {
                this.modelBagCol = 'video';
                AppStorage.setOrCreate('isHiddenSlide', false);
                CameraService.setCameraMode(1);
                await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
              })
            }
            .height(28)
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)

            Row() {
              // 图库
              Column() {
                Row() {
                  if (this.modelBagCol === 'video') {
                    Image(this.videoThumbnail || $r('app.media.pic_avatar_radio02'))
                      .aspectRatio(1)
                      .objectFit(ImageFit.Fill)
                      .border({ width: 2, color: 0xFFFFFF, radius: 40 })
                      .width('200px')
                      .height('200px')
                  } else {
                    Image(this.imgThumbnail || $r('app.media.pic_avatar_radio02'))
                      .aspectRatio(1)
                      .objectFit(ImageFit.Fill)
                      .border({ width: 2, color: 0xFFFFFF, radius: 40 })
                      .width('200px')
                      .height('200px')
                  }
                }.onClick(() => {
                  let uri: string | PixelMap;
                  if (this.modelBagCol === 'video') {
                    uri = this.videoUri;
                  } else {
                    uri = this.imgThumbnail;
                  }
                  GlobalContext.get().getCameraSettingContext().startAbility({
                    parameters: { uri: uri },
                    action: 'ohos.want.action.viewData',
                    bundleName: 'com.ohos.photos',
                    abilityName: 'com.ohos.photos.MainAbility'
                  });
                })
              }

              // 拍照录像按键
              Column() {
                Row() {
                  Button() {
                    Text()
                      .width('120px')
                      .height('120px')
                      .borderRadius('40px')
                      .backgroundColor(this.modelBagCol == 'video' || this.modelBagCol === 'superStab' ?
                      $r('app.color.theme_color') : Color.White)
                  }
                  .border({ width: 3, color: 0xFFFFFF, radius: 70 })
                  .width('200px')
                  .height('200px')
                  .backgroundColor('rgba(255,255,255,0.20)')
                  .onClick(() => {
                    // 倒计时拍照录像—默认拍照录像
                    this.countTakeVideoFn();
                  })
                }
              }
              // 前后置摄像头切换
              Column() {
                Row() {
                  Button() {
                    Image($r('app.media.switch_camera'))
                      .width('120px').height('120px')
                  }
                  .width('200px')
                  .height('200px')
                  .backgroundColor('rgba(255,255,255,0.20)')
                  .borderRadius('40px')
                  .onClick(async () => {
                    if (CameraService.isCameraSwitchSupportedFn()) {
                      // 切换摄像头
                      this.cameraDeviceIndex ? this.cameraDeviceIndex = 0 : this.cameraDeviceIndex = 1;
                      GlobalContext.get().setObject('cameraDeviceIndex', this.cameraDeviceIndex);
                      // 开始预览
                      await CameraService.initCamera(this.surfaceId, this.cameraDeviceIndex);
                    } else {
                      (globalContext.getPromptAction() as PromptAction).showToast({
                        message: $r('app.string.not_support_switch_camera'),
                        duration: 2000,
                        bottom: '50%'
                      });
                    }
                  })
                }
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height('20%')
          .padding({ left: 24, right: 24 })
          .margin({ bottom: 24 })
        }
      } else {
        Stack({ alignContent: Alignment.Bottom }) {
          Column({ space: 24 }) {
            Column() {
              Row() {
                Text().size({ width: 12, height: 12 }).backgroundColor($r('app.color.theme_color')).borderRadius(6)
                Text(this.dateTimeUtil.getVideoTime(this.videoRecodeTime))
                  .fontSize(30)
                  .fontColor(Color.White)
                  .margin({ left: 8 })
              }
            }
            .width('50%')

            Row() {
              Column() {
                // 录像抓拍键
                Button() {
                  Text().width('120px').height('120px').borderRadius('35px').backgroundColor(Color.White)
                }
                .border({ width: 2, color: 0xFFFFFF, radius: 45 })
                .width('200px')
                .height('200px')
                .backgroundColor('rgba(255,255,255,0.20)')
                .onClick(() => {
                  CameraService.takePicture();
                })
              }

              Column() {
                Row() {
                  Column() {
                    // 录像停止键
                    Button() {
                      Image($r('app.media.ic_camera_video_close')).size({ width: 25, height: 25 })
                    }
                    .width('120px')
                    .height('120px')
                    .backgroundColor($r('app.color.theme_color'))
                    .onClick(() => {
                      if (this.timer !== undefined) {
                        clearInterval(this.timer);
                        Logger.debug(TAG, `onChangeRecord clear timer success`);
                      }
                      this.isRecording = !this.isRecording;
                      CameraService.stopVideo().then(async (fileAsset: photoAccessHelper.PhotoAsset): Promise<void> => {
                        try {
                          // 获取录制缩略图
                          this.videoThumbnail = await fileAsset.getThumbnail();
                          this.videoUri = fileAsset.uri;
                        } catch (error) {
                          let err = error as BusinessError;
                          Logger.error(TAG, `videoThumbnail err: ${JSON.stringify(err)}`);
                        }
                      })
                      // 打开停止弹框
                      this.recodeStopDialogController.open();
                    })
                  }
                  .width('180px')
                  .height('180px')
                  .borderRadius('60px')
                  .backgroundColor($r('app.color.theme_color'))
                  .justifyContent(FlexAlign.SpaceAround)
                }
                .justifyContent(FlexAlign.Center)
                .border({ width: 3, color: 0xFFFFFF, radius: 70 })
                .width('200px')
                .height('200px')
                .backgroundColor('rgba(255,255,255,0.20)')
              }

              Column() {
                Row() {
                  Column() {
                    // 录像暂停-播放键
                    Button() {
                      Image(!this.isRecording ? $r('app.media.ic_camera_video_on') : $r('app.media.ic_camera_video_off'))
                        .size({
                          width: 25,
                          height: 25
                        })
                    }
                    .width('120px')
                    .height('120px')
                    .backgroundColor($r('app.color.theme_color'))
                    .onClick(async () => {
                      await this.onChangeRecord();
                    })
                  }
                  .width('180px')
                  .height('180px')
                  .borderRadius('60px')
                  .backgroundColor($r('app.color.theme_color'))
                  .justifyContent(FlexAlign.SpaceAround)
                }
                .justifyContent(FlexAlign.Center)
                .border({ width: 3, color: 0xFFFFFF, radius: 70 })
                .width('200px')
                .height('200px')
                .backgroundColor('rgba(255,255,255,0.20)')
              }
            }
            .width('100%')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
          }
          .justifyContent(FlexAlign.SpaceBetween)
          .height('20%')
          .padding({ left: 24, right: 24 })
          .margin({ bottom: 24 })
        }
      }
    }
    .position({ x: '0%', y: '75%' })
  }
}
