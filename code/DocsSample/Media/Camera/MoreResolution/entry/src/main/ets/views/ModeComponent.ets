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
// 相机模式切换子组件（如拍照 / 录像模式切换）
import CameraService from '../model/CameraService';
import Logger from '../common/utils/Logger';
import { GlobalContext } from '../common/utils/GlobalContext';
import { Constants } from '../common/Constants';
import { router } from '@kit.ArkUI';
import { camera } from '@kit.CameraKit';
import { photoAccessHelper } from '@kit.MediaLibraryKit';
import { image } from '@kit.ImageKit';

const TAG = 'ModeComponent';

@Component
export struct ModeComponent {
  @StorageLink('isOpenEditPage') @Watch('changePageState') isOpenEditPage: boolean = false;
  // camera.SceneMode：相机场景模式枚举（NORMAL_PHOTO= 拍照模式，NORMAL_VIDEO= 录像模式）；
  @State sceneMode: camera.SceneMode = camera.SceneMode.NORMAL_PHOTO;
  // 是否正在录像，通过@StorageLink关联全局存储，控制录制按钮样式（开始 / 停止）
  @StorageLink('isRecording') isRecording: boolean = false;
  @Link screenshotPixel: image.PixelMap | undefined;
  // 是否显示模式切换图片，通过@Link与父组件共享，控制切换过渡效果
  @Link isShowModeSwitchImg: boolean;
  @Link resolution: camera.Size;

  changePageState() {
    // 通过@Watch('changePageState')监听isOpenEditPage变化：
    // 当isOpenEditPage为true时，调用onJumpClick()跳转到编辑页面。
    if (this.isOpenEditPage) {
      this.onJumpClick();
    }
  }

  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear');
    if (!CameraService.is2in1()) {
      CameraService.setSavePictureCallback(this.handleSavePicture);
    } else {
      CameraService.setSaveSinglePhotoCallback(this.photoBufferCallback);
    }
  }

  photoBufferCallback = (arrayBuffer: ArrayBuffer): void => {
    Logger.info(TAG, `photoBufferCallback is called arrayBuffer.byteLength: ${arrayBuffer.byteLength}`);
    GlobalContext.get().setObject('photoArrayBuffer', arrayBuffer);
    AppStorage.set<boolean>('isOpenEditPage', true);
  }

  handleResetDisplay = () => {
    this.isShowModeSwitchImg = false;
  }

  handleSavePicture = (photoAsset: photoAccessHelper.PhotoAsset) => {
    Logger.info(TAG, 'handleSavePicture');
    this.setImageInfo(photoAsset);
    AppStorage.set<boolean>('isOpenEditPage', true);
    Logger.info(TAG, 'setImageInfo end');
  }

  setImageInfo(photoAsset: photoAccessHelper.PhotoAsset) {
    Logger.info(TAG, 'setImageInfo');
    GlobalContext.get().setObject('photoAsset', photoAsset);
  }

  onJumpClick(): void {
    // 将当前相机模式sceneMode存入全局上下文,供编辑页面使用；
    GlobalContext.get().setObject('sceneMode', this.sceneMode);
    router.pushUrl({
      url: 'pages/EditPage'
    }, router.RouterMode.Single, (err) => {
      if (err) {
        Logger.error(TAG, `Invoke pushUrl failed, code is ${err.code}, message is ${err.message}`);
        return;
      }
      Logger.info(TAG, 'Invoke pushUrl succeeded.');
    });
  }

  build() {
    Column() {
      Row({ space: Constants.COLUMN_SPACE_24 }) {
        Column() {
          Text($r('app.string.photo'))
            .fontSize(Constants.FONT_SIZE_14)
            .fontColor(Color.White)
        }
        .width(Constants.CAPTURE_COLUMN_WIDTH)
        .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_PHOTO ? $r('app.color.theme_color') : '')
        .borderRadius(Constants.BORDER_RADIUS_14)
        .onTouch(async (event: TouchEvent) => {
          // 阶段1：TouchType.Down（手指按下时）
          if (event.type == TouchType.Down) {
            Logger.info(TAG, `TouchType.Down`);
            this.screenshotPixel = CameraService.generateSnapshotImg();
            Logger.info(TAG, `TouchType.Down screenshotPixel: ${this.screenshotPixel === undefined}`);
          }
          // TouchType.Up（抬起时）：
          if (event.type == TouchType.Up) {
            // 若当前已是拍照模式，直接返回（避免重复切换）
            if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
              return;
            }
            // 1. 更新组件内的模式状态（@State 修饰，自动同步UI高亮）
            this.sceneMode = camera.SceneMode.NORMAL_PHOTO;
            // 2. 通知相机服务切换模式（底层硬件层面切换工作模式）
            CameraService.setSceneMode(this.sceneMode);
            // 3. 从全局上下文获取重新初始化相机所需的核心参数
            let curCameraPosition = GlobalContext.get().getT<camera.CameraPosition>('curCameraPosition');
            let surfaceId = GlobalContext.get().getT<string>('xComponentSurfaceId');
            // 4. 开启模式切换过渡效果（让截图显示，提升交互体验）
            this.isShowModeSwitchImg = true;
            let mConfigRatio = GlobalContext.get().getT<number>('configRatio');
            // 5. 重新初始化相机，应用新模式（拍照模式）
            await CameraService.initCamera2(surfaceId, curCameraPosition, this.resolution.width, this.resolution.height);
          }
        })
        // 录像模式选项的 onTouch 事件（逻辑与拍照模式完全对称）
        Column() {
          Text($r('app.string.video'))// 显示“录像”文本
            .fontSize(Constants.FONT_SIZE_14)
            .fontColor(Color.White)
        }
        .width(Constants.CAPTURE_COLUMN_WIDTH)
        .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_VIDEO ? $r('app.color.theme_color') : '')
        .borderRadius(Constants.BORDER_RADIUS_14)
        .onTouch(async (event: TouchEvent) => {
          if (event.type == TouchType.Down) {
            // 按下时生成预览截图，用于过渡动画
            this.screenshotPixel = CameraService.generateSnapshotImg();
          }
          if (event.type == TouchType.Up) {
            // 若当前已是录像模式，直接返回
            if (this.sceneMode === camera.SceneMode.NORMAL_VIDEO) {
              return;
            }
            this.sceneMode = camera.SceneMode.NORMAL_VIDEO;
            CameraService.setSceneMode(this.sceneMode);
            let curCameraPosition = GlobalContext.get().getT<camera.CameraPosition>('curCameraPosition');
            let surfaceId = GlobalContext.get().getT<string>('xComponentSurfaceId');
            this.isShowModeSwitchImg = true;
            let mConfigRatio = GlobalContext.get().getT<number>('configRatio');
            // 5. 重新初始化相机，应用录像模式
            await CameraService.initCamera2(surfaceId, curCameraPosition, this.resolution.width, this.resolution.height);
          }
        })
      }
      .height(Constants.CAPTURE_ROW_HEIGHT)
      .width(Constants.FULL_PERCENT)
      .justifyContent(FlexAlign.Center)
      .alignItems(VerticalAlign.Center)

      Row() {
        Column() {}
        .width($r('app.float.size_200'))

        // Camera/Video button
        Column() {
          if (!this.isRecording) {
            Row() {
              Button() {
                Text()
                  .width($r('app.float.size_120'))
                  .height($r('app.float.size_120'))
                  .borderRadius($r('app.float.size_40'))
                  .backgroundColor(this.sceneMode === camera.SceneMode.NORMAL_VIDEO ?
                  $r('app.color.theme_color') : Color.White)
              }
              .border({
                width: Constants.CAPTURE_BUTTON_BORDER_WIDTH,
                color: $r('app.color.border_color'),
                radius: Constants.CAPTURE_BUTTON_BORDER_RADIUS
              })
              .width($r('app.float.size_200'))
              .height($r('app.float.size_200'))
              .backgroundColor(Color.Black)
              .onClick(async () => {
                // 触发拍照
                if (this.sceneMode === camera.SceneMode.NORMAL_PHOTO) {
                  await CameraService.takePicture();
                } else { //开始录像
                  await CameraService.startVideo();
                  this.isRecording = true;
                }
              })
            }.id('CaptureOrVideoButton')
          } else {
            Row() {
              // Recording stop button
              Button() {
                Image($r('app.media.ic_camera_video_close'))
                  .size({ width: Constants.IMAGE_SIZE, height: Constants.IMAGE_SIZE })
              }
              .width($r('app.float.size_120'))
              .height($r('app.float.size_120'))
              .backgroundColor($r('app.color.theme_color'))
              .onClick(() => {
                this.isRecording = !this.isRecording;
                CameraService.stopVideo().then(() => {
                  this.isOpenEditPage = true;
                  Logger.info(TAG, 'stopVideo success');
                })
              })
            }
            .id('StopVideo')
            .width($r('app.float.size_200'))
            .height($r('app.float.size_200'))
            .borderRadius($r('app.float.size_60'))
            .backgroundColor($r('app.color.theme_color'))
            .justifyContent(FlexAlign.SpaceAround)
          }
        }

        // Switching between the front and rear cameras 摄像头切换逻辑
        Column() {
          Row() {
            Button() {
              Image($r('app.media.switch_camera'))    // 显示摄像头切换图标
                .width($r('app.float.size_120'))
                .height($r('app.float.size_120'))
            }
            .width($r('app.float.size_200'))
            .height($r('app.float.size_200'))
            .backgroundColor('rgba(255,255,255,0.20)')
            .borderRadius($r('app.float.size_40'))
            .onTouch(async (event: TouchEvent) => {
              // 阶段1：TouchType.Down（手指按下时）
              if (event.type == TouchType.Down) {
                Logger.info(TAG, `TouchType.Down`);
                // 生成当前预览截图，用于切换过渡动画
                this.screenshotPixel = CameraService.generateSnapshotImg();
                // 开启过渡效果（显示截图）
                this.isShowModeSwitchImg = true;
                Logger.info(TAG, `zc TouchType.Down screenshotPixel: ${this.screenshotPixel === undefined}`);
              }
              // 阶段2：TouchType.Up（手指抬起时）
              if (event.type == TouchType.Up) {
                // 1. 从全局上下文获取当前摄像头位置
                let curCameraPosition = GlobalContext.get().getT<camera.CameraPosition>('curCameraPosition');
                let surfaceId = GlobalContext.get().getT<string>('xComponentSurfaceId');// 预览SurfaceID
                // 2. 反转摄像头位置（后置↔前置）
                if(curCameraPosition === camera.CameraPosition.CAMERA_POSITION_BACK) {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_FRONT;// 后置→前置
                } else if(curCameraPosition === camera.CameraPosition.CAMERA_POSITION_FRONT) {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;// 前置→后置
                } else {
                  curCameraPosition = camera.CameraPosition.CAMERA_POSITION_BACK;// 异常情况默认后置
                }
                // 3. 将新摄像头位置存入全局上下文（供其他组件共享）
                GlobalContext.get().setObject('curCameraPosition', curCameraPosition);
                let mConfigRatio = GlobalContext.get().getT<number>('configRatio');// 预览比例
                // 5. 重新初始化相机，应用新摄像头
                await CameraService.initCamera2(surfaceId, curCameraPosition, this.resolution.width, this.resolution.height);
              }
            })
          }
        }
        .visibility(this.isRecording ? Visibility.Hidden : Visibility.Visible)// 录像时隐藏，避免误操作
      }
      .padding({ left: Constants.CAPTURE_BUTTON_COLUMN_PADDING, right: Constants.CAPTURE_BUTTON_COLUMN_PADDING })
      .width(Constants.FULL_PERCENT)
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
    }
    .justifyContent(FlexAlign.End)
    .height(Constants.TEN_PERCENT)
    .padding({ left: Constants.CAPTURE_BUTTON_COLUMN_PADDING, right: Constants.CAPTURE_BUTTON_COLUMN_PADDING })
    .margin({ bottom: Constants.CAPTURE_BUTTON_COLUMN_MARGIN })
    .position({ x: Constants.ZERO_PERCENT, y: Constants.EIGHTY_FIVE_PERCENT })
  }
}
