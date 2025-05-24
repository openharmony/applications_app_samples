/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { image } from '@kit.ImageKit';
import { matrix4, window } from '@kit.ArkUI';
import { OffsetModel } from '../model/OffsetModel';
import { ScaleModel } from '../model/ScaleModel';
import { runWithAnimation, simplestRotationQuarter } from '../utils/FuncUtils';
import { windowSizeManager } from '../utils/Managers';
import { RotateModel } from '../model/RotateModel';
import { constrainOffsetAndAnimation, getImgSize, getMaxAllowedOffset, ImageFitType } from '../utils/Constrain';


/**
 * PicturePreviewImage
 * 图片绘制组件
 *
 *
 * 实现步骤:
 * - 1. 使用matrix实现图片的缩放
 * - 2. 使用offset实现组件的偏移
 * - 3. 提前计算图片属性以便对组件属性进行设置
 * - 4. Image.objectFile使用Cover以便图片能够超出其父组件显示（而不撑大父组件）
 *
 *
 * @param { Color } listBGColor - 图片背景色
 * @param { string } imageUrl   - 图片预览地址
 * @param { Axis } listDirection - 图片预览的主轴方向
 * @param { number } [TogglePercent] - 图片滑动多大距离需要切换图片，默认 0.2
 * @param { number } [imageIndex] - 当前图片下标，默认 0
 * @param { number } imageMaxLength - 最多几张图片， 默认 0
 * @param { (offset: number, animationDuration?: number) => void  } [setListOffset] - 设置偏移尺寸
 * @param { (index: number) => void } [setListToIndex] - 切换图片
 *
 */
@Reusable
@Component
export struct PicturePreviewImage {
  // 当前背景色
  @Link listBGColor: Color;
  // 图片显示的地址
  @Require @Prop imageUrl: string = '';
  // 图片滑动方向
  @Require @Prop listDirection: Axis;
  // 图片滑动多大距离需要切换图片
  @Prop togglePercent: number = 0.2;
  // 当前图片下标
  @Prop imageIndex: number = 0;
  // 最多几张图片
  @Prop imageMaxLength: number = 0;
  // 设置偏移尺寸
  setListOffset: (offset: number, animationDuration?: number) => void =
    (offset: number, animationDuration?: number) => {
    };
  // 切换图片
  setListToIndex: (index: number) => void = (index: number) => {
  };
  // 图片旋转信息
  @State imageRotateInfo: RotateModel = new RotateModel();
  // 图片缩放信息
  @State imageScaleInfo: ScaleModel = new ScaleModel(1.0, 1.0, 1.5, 0.3);
  // 图片默认大小 -- 是转化后的大小
  @State imageDefaultSize: image.Size = { width: 0, height: 0 }; // 图片默认大小，即，与屏幕大小最适配的显示大小
  // 表示当前图片是根据宽度适配还是高度适配
  @State imageWH: ImageFitType = ImageFitType.TYPE_DEFAULT;
  // 本模块提供矩阵变换功能，可对图形进行平移、旋转和缩放等。
  @State matrix: matrix4.Matrix4Transit = matrix4.identity().copy();
  // 图片偏移信息
  @State imageOffsetInfo: OffsetModel = new OffsetModel(0, 0);
  // 记录偏移时控制list的偏移量
  @State imageListOffset: number = 0;
  // 图片原始宽高比
  private imageWHRatio: number = 0;
  // 保存手指移动位置 -- 减少重复触发计算
  private eventOffsetX: number = 0;
  private eventOffsetY: number = 0;
  // 图片恢复的动画时长
  private restImageAnimation: number = 300;
  /**
   * 当前是否移动交叉轴
   * - 正常拖动可以移动
   * - 当拖动时候展示出了下一张 且 展示具体 大于 isMoveMaxOffset 时固定 交叉轴，等到下次释放后再次移动
   */
  private isMoveCrossAxis: boolean = true;
  /**
   * 最大展示下一张图片的距离
   * - 为了控制交叉轴的移动
   * - 添加这个数值是为了防止在移动 且 图片抵达边缘时 滑动展示下一张图片会立即固定交叉轴无法移动
   * - - 有时候移动虽然抵达边缘后会不小心移动到一点点数据但是实际行为不是为了切换照片，但此时交叉轴固定 且 视角中看不到下一个图片被误以为卡住
   * - - 添加 30 则为了让抵达边缘后 向next 拓展距离让用户感知到已经在切换图片行为了然后固定交叉轴
   * - 30 为可看到 next 图片，良好的距离
   */
  private moveMaxOffset: 30 = 30;

  /**
   * 根据图片宽高比及窗口大小计算图片的默认宽高，即，图片最适配屏幕的大小
   * @param imageWHRatio：图片原始宽高比
   * @param size：窗口大小{with:number,height:number}
   * @returns image.Size
   */
  calcImageDefaultSize(imageWHRatio: number, windowSize: window.Size): image.Size {
    let width: number = 0;
    let height: number = 0;
    if (imageWHRatio > windowSize.width / windowSize.height) {
      // 图片宽高比大于屏幕宽高比，图片默认以屏幕宽度进行显示
      width = windowSize.width;
      height = windowSize.width / imageWHRatio;
    } else {
      height = windowSize.height;
      width = windowSize.height * imageWHRatio;
    }
    return { width: width, height: height };
  }

  /**
   * TODO：知识点：根据图片大小（宽高<=屏幕宽高）和屏幕大小计算图片放大适配屏幕进行显示的缩放倍率
   * @param imageSize：图片当前大小
   * @param windowSize：窗口大小
   * @returns：缩放倍率
   */
  calcFitScaleRatio(imageSize: image.Size, windowSize: window.Size): number {
    let ratio: number = 1.0;
    if (windowSize.width > imageSize.width) {
      ratio = windowSize.width / imageSize.width;
    } else {
      ratio = windowSize.height / imageSize.height;
    }
    return ratio;
  }

  /**
   * 设置当前图片的相关信息：uri、whRatio、pixelMap、fitWH、defaultSize、maxScaleValue
   * TODO：知识点：提前获取图片的信息，以进行Image组件的尺寸设置及后续的相关计算
   */
  initCurrentImageInfo(event: ImageLoadResult): void {
    let imageW = event.width;
    let imageH = event.height;
    let windowSize = windowSizeManager.get();
    // 图片宽高比
    this.imageWHRatio = imageW / imageH;
    // 图片默认大小
    this.imageDefaultSize = this.calcImageDefaultSize(this.imageWHRatio, windowSize);
    // 图片宽度 等于 视口宽度 则图片使用宽度适配 否则 使用 高度适配
    if (this.imageDefaultSize.width === windowSize.width) {
      this.imageWH = ImageFitType.TYPE_WIDTH;
    } else {
      this.imageWH = ImageFitType.TYPE_HEIGHT;
    }
    /**
     * 1.5 的基本倍数上添加 撑满全屏需要多少倍数
     * 1.5 是初始化时候给的值
     *      在1.5上面加是为了让图片可以放的更大
     */
    this.imageScaleInfo.maxScaleValue += this.imageWH === ImageFitType.TYPE_WIDTH ?
      (windowSize.height / this.imageDefaultSize.height) :
      (windowSize.width / this.imageDefaultSize.width);
  }

  /**
   * 在图片消失时，将当前图片的信息设置为默认值
   */
  resetCurrentImageInfo(): void {
    animateTo({
      duration: this.restImageAnimation
    }, () => {
      this.imageScaleInfo.reset();
      this.imageOffsetInfo.reset();
      this.imageRotateInfo.reset();
      this.matrix = matrix4.identity().copy();
    })
  }

  /**
   * TODO：需求：在偏移时评估是否到达边界，以便进行位移限制与图片的切换
   */
  evaluateBound(): void {
    const xBol = constrainOffsetAndAnimation({
      dimensionWH: ImageFitType.TYPE_WIDTH,
      imageDefaultSize: this.imageDefaultSize,
      imageOffsetInfo: this.imageOffsetInfo,
      scaleValue: this.imageScaleInfo.scaleValue,
      rotate: this.imageRotateInfo.lastRotate,
      togglePercent: this.togglePercent,
      imageListOffset: this.imageListOffset
    });

    const yBol = constrainOffsetAndAnimation({
      dimensionWH: ImageFitType.TYPE_HEIGHT,
      imageDefaultSize: this.imageDefaultSize,
      imageOffsetInfo: this.imageOffsetInfo,
      scaleValue: this.imageScaleInfo.scaleValue,
      rotate: this.imageRotateInfo.lastRotate,
      togglePercent: this.togglePercent,
      imageListOffset: this.imageListOffset
    });
    if (this.listDirection === Axis.Horizontal) {
      if (xBol[0] || xBol[1]) {
        if (xBol[0]) {
          this.setListToIndex(this.imageIndex - 1);
          if (this.imageIndex !== 0) {
            this.resetCurrentImageInfo();
          }
        }
        if (xBol[1]) {
          this.setListToIndex(this.imageIndex + 1);
          if (this.imageIndex < this.imageMaxLength - 1) {
            this.resetCurrentImageInfo();
          }
        }
      } else {
        this.setListToIndex(this.imageIndex);
      }
    } else if (this.listDirection === Axis.Vertical) {
      if (yBol[0] || yBol[1]) {
        if (yBol[0]) {
          this.setListToIndex(this.imageIndex - 1);
          if (this.imageIndex !== 0) {
            this.resetCurrentImageInfo();
          }
        }
        if (yBol[1]) {
          this.setListToIndex(this.imageIndex + 1);
          if (this.imageIndex < this.imageMaxLength - 1) {
            this.resetCurrentImageInfo();
          }
        }
      } else {
        this.setListToIndex(this.imageIndex);
      }
    }
    this.imageListOffset = 0;
    this.isMoveCrossAxis = true;
  }

  // 设置交叉轴位置
  setCrossAxis(event: GestureEvent) {
    // list当前没有在移动 &&  交叉轴时候如果没有放大也不移动
    let isScale: boolean = this.imageScaleInfo.scaleValue !== this.imageScaleInfo.defaultScaleValue;
    let listOffset: number = Math.abs(this.imageListOffset);
    if (listOffset > this.moveMaxOffset) {
      this.isMoveCrossAxis = false;
    }
    if (this.isMoveCrossAxis && isScale) {
      // 获取交叉轴方向
      let direction: 'X' | 'Y' = this.listDirection === Axis.Horizontal ? 'Y' : 'X';
      // 获取交叉轴中对应的是 width 还是 height
      let imageWH = this.listDirection === Axis.Horizontal ? ImageFitType.TYPE_HEIGHT : ImageFitType.TYPE_WIDTH;
      // 获取手指在主轴移动偏移量
      let offset = event[`offset${direction}`];
      // 获取图片最后一次在主轴移动的数据
      let lastOffset = imageWH === ImageFitType.TYPE_WIDTH ? this.imageOffsetInfo.lastX : this.imageOffsetInfo.lastY;
      // 计算当前移动后偏移量结果
      let calculatedOffset = lastOffset + offset;
      // 设置交叉轴数据
      this.setCurrentOffsetXY(imageWH, calculatedOffset);
    }
  }

  // 设置主轴位置
  setPrincipalAxis(event: GestureEvent) {
    // 获取主轴方向
    let direction: 'X' | 'Y' = this.listDirection === Axis.Horizontal ? 'X' : 'Y';
    // 获取主轴中对应的是 width 还是 height
    let imageWH: ImageFitType =
      this.listDirection === Axis.Horizontal ? ImageFitType.TYPE_WIDTH : ImageFitType.TYPE_HEIGHT;
    // 获取手指在主轴移动偏移量
    let offset: number = event[`offset${direction}`];
    // 获取图片最后一次在主轴移动的数据
    let lastOffset: number =
      imageWH === ImageFitType.TYPE_WIDTH ? this.imageOffsetInfo.lastX : this.imageOffsetInfo.lastY;
    // 获取主轴上图片的尺寸
    const IMG_SIZE: number = getImgSize(this.imageDefaultSize, this.imageRotateInfo.lastRotate, imageWH);
    const WIN_SIZE: window.Size = windowSizeManager.get();
    // 获取窗口对应轴的尺寸
    const WIN_AXIS_SIZE: number = WIN_SIZE[imageWH];
    // 当前最大移动距离
    let maxAllowedOffset: number = getMaxAllowedOffset(WIN_AXIS_SIZE, IMG_SIZE, this.imageScaleInfo.scaleValue);
    // 计算当前移动后偏移量结果
    let calculatedOffset: number = lastOffset + offset;
    if (offset < 0) {
      // 左滑
      if ((this.imageIndex >= this.imageMaxLength - 1) || (calculatedOffset >= -maxAllowedOffset)) {
        // 当是最后一个元素 或者 当前移动没有抵达边缘时候触发
        this.setCurrentOffsetXY(imageWH, calculatedOffset);
      }
    } else if (offset > 0) {
      // 右滑
      if ((this.imageIndex === 0) || (calculatedOffset <= maxAllowedOffset)) {
        // 当是第一个元素 或者 当前移动没有抵达边缘时候触发
        this.setCurrentOffsetXY(imageWH, calculatedOffset);
      }
    }


    if ((calculatedOffset > maxAllowedOffset) && (this.imageIndex !== 0)) {
      // 右滑 -- 当前滑动超过最大值时 并且 不是第一个元素去设置list偏移量显“下一张”图片
      let listOffset: number = calculatedOffset - maxAllowedOffset;
      this.setListOffset(-listOffset)
      this.imageListOffset = listOffset;
    } else if ((calculatedOffset < -maxAllowedOffset) && (this.imageIndex < this.imageMaxLength - 1)) {
      // 左滑 -- 当前滑动超过最大值时 并且 不是最后一个元素去设置list偏移量显“下一张”图片
      let listOffset = calculatedOffset + maxAllowedOffset;
      this.setListOffset(Math.abs(listOffset));
      this.imageListOffset = listOffset;
    }

  }

  // 设置对应轴方向的数据
  setCurrentOffsetXY(direction: ImageFitType.TYPE_WIDTH | ImageFitType.TYPE_HEIGHT, offset: number) {
    if (direction === ImageFitType.TYPE_WIDTH) {
      this.imageOffsetInfo.currentX = offset;
    } else {
      this.imageOffsetInfo.currentY = offset;
    }
  }

  build() {
    Stack() {
      Image(this.imageUrl)// TODO：知识点：宽高只根据其尺寸设置一个，通过保持宽高比来设置另一个属性
        .id('scale_image')
        .width(this.imageWH === ImageFitType.TYPE_WIDTH ? $r('app.string.imageviewer_image_default_width') : undefined)
        .height(this.imageWH === ImageFitType.TYPE_HEIGHT ? $r('app.string.imageviewer_image_default_height') :
          undefined)
        .aspectRatio(this.imageWHRatio)
        .objectFit(ImageFit.Cover)// TODO：知识点：保持宽高比进行缩放，可以超出父组件，以便实现多图切换的增强功能
        .autoResize(false)
        .transform(this.matrix)// TODO：知识点：通过matrix控制图片的缩放
        .defaultFocus(true)
        .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
        .offset({
          // TODO：知识点：通过offset控制图片的偏移
          x: this.imageOffsetInfo.currentX,
          y: this.imageOffsetInfo.currentY
        })
        .onComplete((event: ImageLoadResult) => {
          if (event) {
            this.initCurrentImageInfo(event);
          }
        })
    }
    .alignContent(Alignment.Center)
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
    .width($r('app.string.imageviewer_image_item_stack_width'))
    .height($r('app.string.imageviewer_image_item_stack_height'))
    .gesture(
      GestureGroup(
        GestureMode.Parallel,
        // 双击切换图片大小
        TapGesture({ count: 2 })
          .onAction(() => {
            let fn: Function;
            // 当前大小倍数 大于 默认的倍数，则是放大状态需要缩小
            if (this.imageScaleInfo.scaleValue > this.imageScaleInfo.defaultScaleValue) {
              fn = () => {
                // 恢复默认大小
                this.imageScaleInfo.reset();
                // 重置偏移量
                this.imageOffsetInfo.reset();
                // 设置一个新的矩阵
                this.matrix = matrix4.identity().copy().rotate({
                  z: 1,
                  angle: this.imageRotateInfo.lastRotate
                });
              }
            } else {
              fn = () => {
                // 这里是正常状态 -- 需要放大
                // 获取放大倍数
                const ratio: number = this.calcFitScaleRatio(this.imageDefaultSize, windowSizeManager.get());
                // 设置当前放大倍数
                this.imageScaleInfo.scaleValue = ratio;
                // 重置偏移量
                this.imageOffsetInfo.reset();
                // 设置矩阵元素
                this.matrix = matrix4.identity().scale({
                  x: ratio,
                  y: ratio,
                }).rotate({
                  z: 1,
                  angle: this.imageRotateInfo.lastRotate
                }).copy();
                // 设置最后放大倍数设置为当前的倍数
                this.imageScaleInfo.stash();
              }
            }
            runWithAnimation(fn);
          }),
        // 拖动图片
        PanGesture({ fingers: 1 })
          .onActionUpdate((event: GestureEvent) => {
            if (this.imageWH != ImageFitType.TYPE_DEFAULT) {
              if (this.eventOffsetX != event.offsetX || event.offsetY != this.eventOffsetY) {
                this.eventOffsetX = event.offsetX;
                this.eventOffsetY = event.offsetY;
                this.setCrossAxis(event);
                this.setPrincipalAxis(event);
              }
            }
          })
          .onActionEnd((event: GestureEvent) => {
            this.imageOffsetInfo.stash();
            this.evaluateBound();
          }),
        // 两根手指操作
        // 双指旋转图片
        RotationGesture({ angle: this.imageRotateInfo.startAngle })
          .onActionUpdate((event: GestureEvent) => {
            let angle: number = this.imageRotateInfo.lastRotate + event.angle;
            if (event.angle > 0) {
              angle -= this.imageRotateInfo.startAngle;
            } else {
              angle += this.imageRotateInfo.startAngle;
            }
            this.matrix = matrix4.identity()
              .scale({
                x: this.imageScaleInfo.scaleValue,
                y: this.imageScaleInfo.scaleValue
              })
              .rotate({
                x: 0,
                y: 0,
                z: 1,
                angle: angle,
              }).copy();
            this.imageRotateInfo.currentRotate = angle;
          })
          .onActionEnd((event: GestureEvent) => {
            let rotate = simplestRotationQuarter(this.imageRotateInfo.currentRotate);
            runWithAnimation(() => {
              this.imageRotateInfo.currentRotate = rotate;
              this.matrix = matrix4.identity()
                .rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  angle: this.imageRotateInfo.currentRotate,
                }).copy();
              this.imageRotateInfo.stash();
              this.imageScaleInfo.reset();
              this.imageOffsetInfo.reset();
            })
          }),
        // TODO：知识点：双指捏合缩放图片
        PinchGesture({ fingers: 2, distance: 1 })
          .onActionUpdate((event: GestureEvent) => {
            let scale: number = this.imageScaleInfo.lastValue * event.scale;
            // TODO：知识点：缩放时不允许大于最大缩放因子+额外缩放因子，不允许小于默认大小-额外缩放因子，额外缩放因子用于提升用户体验4
            if (scale > this.imageScaleInfo.maxScaleValue *
              (1 + this.imageScaleInfo.extraScaleValue)
            ) {
              scale = this.imageScaleInfo.maxScaleValue *
                (1 + this.imageScaleInfo.extraScaleValue);
            }
            if (scale < this.imageScaleInfo.defaultScaleValue *
              (1 - this.imageScaleInfo.extraScaleValue)) {
              scale = this.imageScaleInfo.defaultScaleValue *
                (1 - this.imageScaleInfo.extraScaleValue);
            }
            // 当前最终的缩放比例 * 当前手指缩放比例 = 当前图片的缩放比例
            this.imageScaleInfo.scaleValue = scale;
            // TODO：知识点：matrix默认缩放中心为组件中心
            this.matrix = matrix4.identity().scale({
              x: this.imageScaleInfo.scaleValue,
              y: this.imageScaleInfo.scaleValue,
            }).rotate({
              x: 0,
              y: 0,
              z: 1,
              angle: this.imageRotateInfo.currentRotate,
            }).copy();

          })
          .onActionEnd((event: GestureEvent) => {
            // TODO：知识点：当小于默认大小时，恢复为默认大小4
            if (this.imageScaleInfo.scaleValue < this.imageScaleInfo.defaultScaleValue) {
              runWithAnimation(() => {
                this.imageScaleInfo.reset();
                this.imageOffsetInfo.reset();
                this.matrix = matrix4.identity().rotate({
                  x: 0,
                  y: 0,
                  z: 1,
                  angle: this.imageRotateInfo.currentRotate,
                }).copy();
              })
            }
            // TODO：知识点：当大于最大缩放因子时，恢复到最大
            if (this.imageScaleInfo.scaleValue > this.imageScaleInfo.maxScaleValue) {
              runWithAnimation(() => {
                this.imageScaleInfo.scaleValue = this.imageScaleInfo.maxScaleValue;
                this.matrix = matrix4.identity()
                  .scale({
                    x: this.imageScaleInfo.maxScaleValue,
                    y: this.imageScaleInfo.maxScaleValue
                  }).rotate({
                    x: 0,
                    y: 0,
                    z: 1,
                    angle: this.imageRotateInfo.currentRotate,
                  });
              })
            }
            this.imageScaleInfo.stash();
          })
      )
    )
  }
}