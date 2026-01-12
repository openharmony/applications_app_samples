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

import { camera } from '@kit.CameraKit';
import { image } from '@kit.ImageKit';
import { curves } from '@kit.ArkUI';
import { Constants } from '../common/Constants';
import { BlurAnimateUtil } from '../common/utils/BlurAnimateUtil';
import { GlobalContext } from '../common/utils/GlobalContext';
import Logger from '../common/utils/Logger';
import CameraService from '../mode/CameraService';
import { ModeComponent } from '../views/ModeComponent';
import { SlideComponent } from '../views/SlideComponent';
import { FocusAreaComponent } from '../views/FocusAreaComponent';
import { FocusComponent } from '../views/FocusComponent';
import { FlashingLightComponent } from '../views/FlashingLightComponent';


const TAG = 'Index';

@Entry
@Component
struct Index {
  // 主页面是否显示
  @StorageLink('isShow') isShow: boolean = false;
  @StorageLink('isOpenEditPage') isOpenEditPage: boolean = false;
  // Flash Mode
  @State flashMode: camera.FlashMode = camera.FlashMode.FLASH_MODE_CLOSE;
  @State focusPointBol: boolean = false;
  // 曝光区域手指点击坐标
  @State focusPointVal: Array<number> = [0, 0];
  @State xComponentAspectRatio: number = 1;
  private mXComponentController: XComponentController = new XComponentController();
  private defaultCameraDeviceIndex = 0;
  private surfaceId = '';
  // 模糊动效
  @State isShowBlur: boolean = false;
  @State isShowBlack: boolean = false;
  @StorageLink('modeChange') @Watch('onModeChange') modeChangeFlag: number = 0;
  @StorageLink('switchCamera') @Watch('onSwitchCamera') switchCameraFlag: number = 0;
  @StorageLink('frameStart') @Watch('onFrameStart') frameStartFlag: number = 0;
  @StorageLink('captureClick') @Watch('onCaptureClick') captureClickFlag: number = 0;
  @StorageLink('surfaceShot') screenshotPixelMap: image.PixelMap | undefined = undefined; // 预览流截图
  @StorageLink('curPosition') curPosition: number = 0; // 当前镜头前后置状态
  @State shotImgBlur: number = 0;
  @State shotImgOpacity: number = 1;
  @State shotImgScale: ScaleOptions = { x: 1, y: 1 };
  @State shotImgRotation: RotateOptions = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_0 }
  @State flashBlackOpacity: number = 1;

  private context: Context | undefined = this.getUIContext().getHostContext();

  aboutToAppear(): void {
    Logger.info(TAG, 'aboutToAppear');
  }

  async aboutToDisAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToDisAppear');
    this.flashMode = camera.FlashMode.FLASH_MODE_CLOSE;
    await CameraService.releaseCamera();
  }

  async onPageShow(): Promise<void> {
    Logger.info(TAG, 'onPageShow');
    if (this.surfaceId !== '' && !this.isOpenEditPage) {
      await CameraService.initCamera(this.surfaceId, GlobalContext.get().getT<number>('cameraDeviceIndex'), this.context);
    }
    this.isOpenEditPage = false;
  }

  async onPageHide(): Promise<void> {
    Logger.info(TAG, 'onPageHide');
  }

  /**
   * 显示模糊动效，模式切换触发
   */
  private async showBlurAnim() {
    Logger.info(TAG, 'showBlurAnim E');
    // 获取已完成的surface截图
    let shotPixel = BlurAnimateUtil.getSurfaceShot();
    // 后置
    if (this.curPosition === 0) {
      Logger.info(TAG, 'showBlurAnim BACK');
      // 直板机后置截图旋转补偿90°
      await shotPixel.rotate(BlurAnimateUtil.IMG_ROTATE_ANGLE_90);
      // 直板机后置截图初始翻转0°
      this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_0 };
    } else {
      Logger.info(TAG, 'showBlurAnim FRONT');
      // 直板机前置截图旋转补偿270°
      await shotPixel.rotate(BlurAnimateUtil.IMG_ROTATE_ANGLE_270);
      // 直板机前置截图镜像补偿
      this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_180 };
    }
    this.screenshotPixelMap = shotPixel;
    // 初始化动效参数
    this.shotImgBlur = 0; // 无模糊
    this.shotImgOpacity = 1; // 不透明
    // 触发页面渲染
    this.isShowBlur = true;
    animateToImmediately(
      {
        duration: BlurAnimateUtil.SHOW_BLUR_DURATION,
        curve: Curve.Friction,
        onFinish: async () => {
          Logger.info(TAG, 'showBlurAnim X');
        }
      },
      () => {
        // 截图模糊度变化动效
        this.shotImgBlur = BlurAnimateUtil.ANIM_MODE_SWITCH_BLUR;
      }
    );
  }

  /**
   * 隐藏模糊动效，预览流首帧回调触发
   */
  private hideBlurAnim(): void {
    this.isShowBlack = false;
    Logger.info(TAG, 'hideBlurAnim E');
    animateToImmediately({
      duration: BlurAnimateUtil.HIDE_BLUR_DURATION,
      curve: Curve.FastOutSlowIn,
      onFinish: () => {
        // 模糊组件下树
        this.isShowBlur = false;
        this.shotImgBlur = 0;
        this.shotImgOpacity = 1;
        Logger.info(TAG, 'hideBlurAnim X');
      }
    }, () => {
      // 截图透明度变化动效
      this.shotImgOpacity = 0;
    });
  }

  /**
   * 先向外翻转90°，前后置切换触发
   */
  private async rotateFirstAnim() {
    Logger.info(TAG, 'rotateFirstAnim E');
    // 获取已完成的surface截图
    let shotPixel = BlurAnimateUtil.getSurfaceShot();
    // 后置切前置
    if (this.curPosition === 1) {
      Logger.info(TAG, 'rotateFirstAnim BACK');
      // 直板机后置切前置截图旋转补偿90°
      await shotPixel.rotate(BlurAnimateUtil.IMG_ROTATE_ANGLE_90); // Image Kit提供的旋转，用于处理图片本身的旋转
      // 直板机后置切前置截图初始翻转0°
      this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_0 };
    } else {
      Logger.info(TAG, 'rotateFirstAnim FRONT');
      // 直板机前置切后置截图旋转补偿270°
      await shotPixel.rotate(BlurAnimateUtil.IMG_ROTATE_ANGLE_270);
      // 直板机前置切后置截图初始翻转180°
      this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_180 };
    }
    this.screenshotPixelMap = shotPixel;
    // 触发页面渲染
    this.isShowBlack = true;
    this.isShowBlur = true;
    animateToImmediately(
      {
        duration: BlurAnimateUtil.ROTATION_DURATION,
        delay: BlurAnimateUtil.FLIP_DELAY, // 时延保证组件缩放模糊动效先行，再翻转后视觉效果更好
        curve: curves.cubicBezierCurve(0.20, 0.00, 0.83, 1.00),
        onFinish: () => {
          Logger.info(TAG, 'rotateFirstAnim X');
          // 在onFinish后触发二段旋转
          this.rotateSecondAnim();
        }
      },
      () => {
        // 截图向翻转动效
        if (this.curPosition === 1) {
          this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_90 };
        } else {
          this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_270 };
        }
      }
    )
  }

  /**
   * 再向内翻转90°
   */
  async rotateSecondAnim() {
    Logger.info(TAG, 'rotateSecondAnim E');
    // 获取已完成的surface截图
    let shotPixel = BlurAnimateUtil.getSurfaceShot();
    // 后置
    if (this.curPosition === 1) {
      // 直板机后置镜头旋转补偿90°
      await shotPixel.rotate(BlurAnimateUtil.IMG_ROTATE_ANGLE_90); // Image Kit提供的旋转，用于处理图片本身的旋转
      // 瞬时调整为-90°，保证二段旋转后，图片不是镜像的
      this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_MINUS_90 };
    } else { // 前置
      // 直板机前置截图旋转补偿270°
      await shotPixel.rotate(BlurAnimateUtil.IMG_ROTATE_ANGLE_270);
      // 直板机前置截图镜像补偿
      this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_180 };
    }
    this.screenshotPixelMap = shotPixel;

    animateToImmediately(
      {
        duration: BlurAnimateUtil.ROTATION_DURATION,
        curve: curves.cubicBezierCurve(0.17, 0.00, 0.20, 1.00),
        onFinish: () => {
          Logger.info(TAG, 'rotateSecondAnim X');
        }
      },
      () => {
        // 截图翻转为初始状态
        if (this.curPosition === 1) {
          this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_0 };
        } else {
          this.shotImgRotation = { y: BlurAnimateUtil.ROTATE_AXIS, angle: BlurAnimateUtil.IMG_FLIP_ANGLE_180 };
        }
      }
    )
  }

  /**
   * 向外翻转90°同时
   */
  blurFirstAnim() {
    Logger.info(TAG, 'blurFirstAnim E');
    // 初始化动效参数
    this.shotImgBlur = 0; //无模糊
    this.shotImgOpacity = 1; //不透明
    this.shotImgScale = { x: 1, y: 1 };
    animateToImmediately(
      {
        duration: BlurAnimateUtil.ROTATION_DURATION,
        curve: Curve.Sharp,
        onFinish: () => {
          Logger.info(TAG, 'blurFirstAnim X');
          this.blurSecondAnim();
        }
      },
      () => {
        // 截图模糊度变化动效
        this.shotImgBlur = BlurAnimateUtil.ANIM_MODE_SWITCH_BLUR;
        // 截图比例动效
        this.shotImgScale = { x: BlurAnimateUtil.IMG_SCALE, y: BlurAnimateUtil.IMG_SCALE };
      }
    );
  }

  /**
   * 向内翻转90°同时
   */
  blurSecondAnim() {
    Logger.info(TAG, 'blurSecondAnim E');
    animateToImmediately(
      {
        duration: BlurAnimateUtil.ROTATION_DURATION,
        curve: Curve.Sharp,
        onFinish: () => {
          Logger.info(TAG, 'blurSecondAnim X');
        }
      },
      () => {
        this.shotImgScale = { x: 1, y: 1 };
      }
    )
  }

  /**
   * 闪黑动效，拍照触发
   */
  private flashBlackAnim() {
    Logger.info(TAG, 'flashBlackAnim E');
    this.flashBlackOpacity = 1;
    this.isShowBlack = true;
    animateToImmediately({
      curve: curves.interpolatingSpring(1, 1, 410, 38),
      delay: 50,
      onFinish: () => {
        this.isShowBlack = false;
        this.flashBlackOpacity = 1;
        Logger.info(TAG, 'flashBlackAnim X');
      }
    }, () => {
      this.flashBlackOpacity = 0;
    })
  }

  onModeChange(): void {
    Logger.info(TAG, 'onModeChange');
    this.showBlurAnim();
  }

  onSwitchCamera(): void {
    Logger.info(TAG, 'onSwitchCamera');
    this.blurFirstAnim();
    this.rotateFirstAnim();
  }

  onFrameStart(): void {
    Logger.info(TAG, 'onFrameStart');
    this.hideBlurAnim();
  }

  onCaptureClick(): void {
    Logger.info(TAG, 'onCaptureClick');
    this.flashBlackAnim();
  }

  getXComponentOptions(): XComponentOptions {
    let options: XComponentOptions = {
      type: XComponentType.SURFACE,
      controller: this.mXComponentController
    };
    return options;
  }

  build() {
    Stack() {
      if (this.isShow) {
        XComponent(this.getXComponentOptions())
          .onLoad(async () => {
            Logger.info(TAG, 'onLoad is called');
            this.surfaceId = this.mXComponentController.getXComponentSurfaceId();
            GlobalContext.get().setObject('cameraDeviceIndex', this.defaultCameraDeviceIndex);
            GlobalContext.get().setObject('xComponentSurfaceId', this.surfaceId);
            let surfaceRect: SurfaceRect = {
              surfaceWidth: Constants.X_COMPONENT_SURFACE_HEIGHT,
              surfaceHeight: Constants.X_COMPONENT_SURFACE_WIDTH
            };
            this.mXComponentController.setXComponentSurfaceRect(surfaceRect);
            Logger.info(TAG, `onLoad surfaceId: ${this.surfaceId}`);
            await CameraService.initCamera(this.surfaceId, this.defaultCameraDeviceIndex, this.context);
          })// The width and height of the surface are opposite to those of the Xcomponent.
          .width(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_HEIGHT))
          .height(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_WIDTH))
      }

      // 拍照闪黑及前后置切换时显示，用来遮挡XComponent组件
      if (this.isShowBlack) {
        Column()
          .key('black')
          .width(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_HEIGHT))
          .height(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_WIDTH))
          .backgroundColor(Color.Black)
          .opacity(this.flashBlackOpacity)
      }


      if (this.isShowBlur) {
        Column() {
          Image(this.screenshotPixelMap)
            .blur(this.shotImgBlur)
            .opacity(this.shotImgOpacity)
            .rotate(this.shotImgRotation)// ArkUI提供的旋转，用于组件沿指定坐标系进行旋转
            .scale(this.shotImgScale)
            .width(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_HEIGHT))
            .height(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_WIDTH))
            .syncLoad(true)
        }
        .width(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_HEIGHT))
        .height(this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_WIDTH))
      }

      // 曝光框和对焦框
      FocusComponent({
        focusPointBol: $focusPointBol,
        focusPointVal: $focusPointVal
      })

      // 曝光对焦手指点击区域
      FocusAreaComponent({
        focusPointBol: $focusPointBol,
        focusPointVal: $focusPointVal,
        xComponentWidth: this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_HEIGHT),
        xComponentHeight: this.getUIContext().px2vp(Constants.X_COMPONENT_SURFACE_WIDTH)
      })

      SlideComponent()

      // 拍照
      ModeComponent()

      Row({ space: Constants.ROW_SPACE_24 }) {
        // 闪光灯
        FlashingLightComponent({
          flashMode: $flashMode
        })
      }
      .margin({ left: Constants.CAPTURE_BUTTON_COLUMN_MARGIN })
      .alignItems(VerticalAlign.Top)
      .justifyContent(FlexAlign.Start)
      .position({
        x: Constants.FLASH_POSITION_X,
        y: Constants.FLASH_POSITION_Y
      })
    }
    .size({
      width: Constants.FULL_PERCENT,
      height: Constants.FULL_PERCENT
    })
    .backgroundColor(Color.Black)
  }
}