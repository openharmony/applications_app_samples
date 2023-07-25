/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import Matrix4 from '@ohos.matrix4';
import { UserFileDataItem } from '../base/UserFileDataItem';
import { Log } from '../utils/Log';
import { Broadcast } from './Broadcast';
import { MathUtils } from '../utils/MathUtils';
import { Constants } from '../constants/BrowserConstants';
import { screenManager } from './ScreenManager';
import { MediaConstants } from '../constants/MediaConstants';

const TAG = 'EventPipeline'

export interface Matrix4TransitWithMatrix4x4 extends Matrix4.Matrix4Transit {
  matrix4x4: number[];
}

export interface AnimationOption {
  duration: number,
  curve: Curve
}

export class EventPipeline {

  // last offset
  private lastOffset: number[] = [0, 0];

  // offset
  private offset: number[] = [0, 0];

  // default scale
  private defaultScale = 1.0;

  // last scale
  private lastScale = 1.0;

  // scale
  private scale = 1.0;

  // the zoom center point is a percentage position relative to the control, not an absolute position
  private center: number[] = [Constants.CENTER_DEFAULT, Constants.CENTER_DEFAULT];

  // leftmost zoom Center，(1 - leftMost)is rightmost zoom Center
  private leftMost = 0.0;

  // top zoom center，(1 - topMost)is bottom zoom center
  private topMost = 0.0;

  // double tap scale
  private doubleTapScale = 1.0;

  // max scale
  private maxScale = 1.0;

  // has reached the far left
  private hasReachLeft = true;

  // has reached the far right
  private hasReachRight = true;

  // has reached the far top
  private hasReachTop = true;

  // has reached the far bottom
  private hasReachBottom = true;

  // Broadcast
  private broadCast: Broadcast;

  // item
  private item: UserFileDataItem;

  // timeStamp
  private timeStamp: string;

  // width
  private width: number;

  // height
  private height: number;

  // Large display control width
  private componentWidth: number = vp2px(screenManager.getWinWidth());

  // Large display control height
  private componentHeight = vp2px(screenManager.getWinHeight());

  // is now in animation
  private isInAnimation = false;

  // pull down to return flag to prevent multiple triggers
  private isExiting = false;

  private updateMatrix: Function;

  constructor(broadCastParam: Broadcast, item: UserFileDataItem, timeStamp: string, updateMatrix: Function) {
    this.broadCast = broadCastParam;
    this.item = item;
    this.timeStamp = timeStamp;
    this.updateMatrix = updateMatrix;
    this.width = this.item.imgWidth === 0 ? MediaConstants.DEFAULT_SIZE : this.item.imgWidth;
    this.height = this.item.imgHeight === 0 ? MediaConstants.DEFAULT_SIZE : this.item.imgHeight;
    this.evaluateScales();
  }

  onDataChanged(item: UserFileDataItem): void {
    this.item = item;
    this.width = this.item.imgWidth === 0 ? MediaConstants.DEFAULT_SIZE : this.item.imgWidth;
    this.height = this.item.imgHeight === 0 ? MediaConstants.DEFAULT_SIZE : this.item.imgHeight;
    this.evaluateScales();
  }

  setDefaultScale(scale): void {
    this.defaultScale = scale;
    this.lastScale = scale;
  }

  onComponentSizeChanged(): void {
    this.evaluateScales();
  }

  onTouch(event: TouchEvent): void {
    Log.debug(TAG, 'onTouch trigger: ' + event.type + ', ' + this.isInAnimation + ', ' + this.isExiting);
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    if (event.type === TouchType.Down || event.type === TouchType.Up) {
      this.emitDirectionChange();
    }

    if (event.type === TouchType.Up) {
      this.lastOffset = this.evaluateOffset();
      this.lastScale = this.lastScale * this.scale;
      this.scale = 1;
      this.offset = [0, 0];
    }
  }

  private emitDirectionChange(): void {

    /**
     * reachLeft reachRight scale>1，only five possible situations（when scale<=1,reachLeft、reachRight is true）：
     * T T T：Vertical
     * T T F：Vertical（initial state）
     * T F T：Vertical | Left
     * F T T：Vertical | Right
     * F F T：All
     */
    let direction;
    let scale = this.lastScale * this.scale;
    let isEnlarged = Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS));
    if (!this.hasReachLeft && !this.hasReachRight && isEnlarged) {
      direction = PanDirection.All;
    } else if (!this.hasReachLeft && this.hasReachRight && isEnlarged) {
      direction = (PanDirection.Vertical as number) | (PanDirection.Right as number);
    } else if (this.hasReachLeft && !this.hasReachRight && isEnlarged) {
      direction = (PanDirection.Vertical as number) | (PanDirection.Left as number);
    } else {
      direction = PanDirection.Vertical;
    }

    Log.info(TAG, 'emitDirectionChange reaches: ' + this.hasReachLeft + ', ' + this.hasReachRight + ', ' + this.hasReachTop + ', ' + this.hasReachBottom +
    ', scale ' + scale + ', direction: ' + direction);
    if (this.isExiting) {
      return;
    }

    if (direction === (PanDirection.Vertical as number) || direction === ((PanDirection.Vertical as number) | (PanDirection.Left as number)) ||
    direction === ((PanDirection.Vertical as number) | (PanDirection.Right as number))) {
      this.broadCast.emit(Constants.SET_DISABLE_SWIPE, [false]);
    } else {
      this.broadCast.emit(Constants.SET_DISABLE_SWIPE, [true]);
    }
    this.broadCast.emit(Constants.DIRECTION_CHANGE + this.item.uri + this.timeStamp, [direction]);
  }

  private evaluateOffset(): number[] {
    Log.info(TAG, 'evaluateOffset lastOffset: ' + this.lastOffset + ', offset: ' + this.offset);
    let centerX = (this.center[0] - Constants.CENTER_DEFAULT) * this.componentWidth * (this.defaultScale - this.scale) * this.lastScale;
    let centerY = (this.center[1] - Constants.CENTER_DEFAULT) * this.componentHeight * (this.defaultScale - this.scale) * this.lastScale;
    let offsetX = this.lastOffset[0] + this.offset[0] + centerX;
    let offsetY = this.lastOffset[1] + this.offset[1] + centerY;
    Log.debug(TAG, 'evaluateOffset offsetX: ' + offsetX + ', offsetY: ' + offsetY);
    return [offsetX, offsetY];
  }

  private emitTouchEvent(): void {
    let offset: number[];
    let scale = this.lastScale * this.scale;
    if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
      let limits = this.evaluateOffsetRange(scale);
      offset = this.evaluateOffset();
      // the offset in the X direction is always limited for non shrinking scenes
      offset[0] = MathUtils.clamp(offset[0], limits[0], limits[1]);
      if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
        // cannot pull down to return, limit y
        offset[1] = MathUtils.clamp(offset[1], limits[2], limits[3]);
      } else {
        // can pull down to return to the scene, and only limit y to drag upward, limit the lower bound
        offset[1] = Math.max(limits[2], offset[1]);
      }
    } else {
      // When zooming in, adjust the zoom center to the display center point
      offset = [0, 0];
    }
    let moveX = offset[0];
    let moveY = offset[1];
    Log.debug(TAG, 'emitTouchEvent moveX: ' + moveX + ', moveY: ' + moveY);
    let scaleOption: Matrix4.ScaleOption = {
      x: scale,
      y: scale,
    };
    let translateOption: Matrix4.TranslateOption = {
      x: moveX,
      y: moveY
    };
    let matrix = Matrix4.identity()
      .scale(scaleOption)
      .translate(translateOption)
      .copy();
    Log.debug(TAG, 'emitTouchEvent lastOffset: ' + this.lastOffset + ', offset: ' + this.offset +
    ',center: ' + this.center + ', scale: ' + this.lastScale + ', ' + this.scale);
    this.updateMatrix(matrix);
    this.evaluateBounds();
  }

  private evaluateScales(): void {
    if (this.width * this.componentHeight < this.componentWidth * this.height) {
      // The aspect ratio is less than the display aspect ratio of the control
      // the height of the control is equal to the height of the picture
      this.maxScale = this.height / this.componentHeight;
      // Double click the enlarged scale to ensure that the left and right boundaries are filled
      this.doubleTapScale = this.componentWidth * this.height / this.width / this.componentHeight;
      // leftMost = (1 - dspW / compW) / 2 = (1 - compH * imgW / imgH / compW) / 2
      this.leftMost = (1 - this.componentHeight * this.width / this.height / this.componentWidth) / Constants.NUMBER_2;
      this.topMost = 0.0;
    } else if (this.width * this.componentHeight === this.componentWidth * this.height) {
      // The aspect ratio is equal to the display aspect ratio of the control
      this.doubleTapScale = Constants.SAME_RATIO_SCALE_FACTOR;
      this.maxScale = this.doubleTapScale * Constants.MAX_SCALE_EXTRA_FACTOR;
      this.leftMost = 0;
      this.topMost = 0;
    } else {
      // The aspect ratio is greater than the display aspect ratio of the control
      // the width of the control is equal to the width of the picture
      this.maxScale = this.width / this.componentWidth;
      // Double click the enlarged scale to ensure that the top and bottom fill the boundary
      this.doubleTapScale = this.componentHeight * this.width / this.height / this.componentWidth;
      this.leftMost = 0.0;
      this.topMost = (1 - this.componentWidth * this.height / this.width / this.componentHeight) / Constants.NUMBER_2;
    }

    this.maxScale = Math.max(this.maxScale, Constants.COMPONENT_SCALE_CEIL);
    if (this.doubleTapScale > this.maxScale) {
      this.maxScale = this.doubleTapScale * Constants.MAX_SCALE_EXTRA_FACTOR;
    }
    Log.debug(TAG, 'evaluateScales: ' + this.width + '*' + this.height + ' &' +
    this.componentWidth + '*' + this.componentHeight +
    ',max: ' + this.maxScale + ', most: [' + this.leftMost + ',' + this.topMost + '], double: ' + this.doubleTapScale);
  }

  private evaluateCompBounds(): number[] {
    let scale = this.lastScale * this.scale;
    let offset = this.evaluateOffset();
    let result: number[] = [
      offset[0] - this.componentWidth * (Number(scale.toFixed(Constants.RESERVED_DIGITS)) - Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) / Constants.NUMBER_2,
      offset[1] - this.componentHeight * (Number(scale.toFixed(Constants.RESERVED_DIGITS)) - Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) / Constants.NUMBER_2
    ];
    Log.debug(TAG, 'evaluateCompBounds: ' + result);
    return result;
  }

  private evaluateImgDisplaySize(): number[] {
    let screenScale = 1;
    let widthScale = this.componentWidth / this.item.imgWidth;
    let heightScale = this.componentHeight / this.item.imgHeight;
    screenScale = widthScale > heightScale ? heightScale : widthScale;
    let scale = this.lastScale * this.scale * screenScale;
    let imgDisplayWidth = 0;
    let imgDisplayHeight = 0;
    imgDisplayWidth = this.width * scale;
    imgDisplayHeight = this.height * scale;
    return [imgDisplayWidth, imgDisplayHeight];
  }

  private evaluateImgDisplayBounds(): number[] {
    // For the left boundary of the component,
    // the offset caused by amplification is - compw * (scale-1) / 2,
    // plus the offset of the gesture to obtain the left boundary of the control.
    // The same is true for the upper boundary
    let scale = this.lastScale * this.scale;
    let leftTop = this.evaluateCompBounds();
    let imgDisplaySize: number[] = this.evaluateImgDisplaySize();
    let imgDisplayWidth = imgDisplaySize[0];
    let imgDisplayHeight = imgDisplaySize[1];
    let imgLeftBound = 0;
    let imgTopBound = 0;
    if (this.width / this.height > this.componentWidth / this.componentHeight) {
      imgLeftBound = leftTop[0];
      imgTopBound = leftTop[1] + (this.componentHeight * scale - imgDisplayHeight) / Constants.NUMBER_2;
    } else {
      // Control width minus the picture width, divided by 2,
      // you can get the distance from the left of the picture to the left of the control.
      // Plus offsetX is the left boundary of the picture currently displayed
      imgLeftBound = (this.componentWidth * scale - imgDisplayWidth) / Constants.NUMBER_2 + leftTop[0];
      imgTopBound = leftTop[1];
    }
    return [imgLeftBound, imgTopBound];
  }

  // Calculate picture display boundary
  private evaluateBounds(): void {
    let imgDisplaySize: number[] = this.evaluateImgDisplaySize();
    let imgDisplayWidth = imgDisplaySize[0];

    let imgDisplayBounds = this.evaluateImgDisplayBounds();
    let imgLeftBound = imgDisplayBounds[0];
    this.hasReachLeft = imgLeftBound > -1;
    this.hasReachRight = imgLeftBound + imgDisplayWidth < this.componentWidth + 1;
  }

  /**
   * Calculate the upper and lower bounds of offset in X and Y directions under the current scale
   *
   * @param scale The display magnification of the current control, usually this.lastScale * this.scale
   * @returns 0&1 X-direction offset lower & upper bound, 2&3 Y-direction offset lower & upper bound
   */
  private evaluateOffsetRange(scale: number): number[] {
    let result: number[] = [0, 0, 0, 0];
    let screenScale = 1;
    let widthScale = this.componentWidth / this.item.imgWidth;
    let heightScale = this.componentHeight / this.item.imgHeight;
    screenScale = widthScale > heightScale ? heightScale : widthScale;
    let left = (screenScale * scale * this.width - this.componentWidth) / Constants.NUMBER_2;
    let top = (screenScale * scale * this.height - this.componentHeight) / Constants.NUMBER_2;
    top = Math.max(top, 0);
    left = Math.max(left, 0);
    result = [-left, left, -top, top];
    Log.debug(TAG, 'evaluateOffsetRange scale: ' + scale + ', defaultScale: ' + this.defaultScale + ', result: ' + result);
    return result;
  }

  private emitPullDownToBackEvent(): void {
    Log.debug(TAG, 'emitPullDownToBackEvent');
    if (this.isExiting) {
      Log.info(TAG, 'emitPullDownToBack isExiting: ' + this.isExiting);
      return;
    }
    this.broadCast.emit(Constants.PULL_DOWN_END, []);
    this.isExiting = true;
  }

  private emitPullDownCancelEvent(): void {
    Log.debug(TAG, 'emitPullDownCancelEvent');
    this.broadCast.emit(Constants.PULL_DOWN_CANCEL, []);
  }

  onMoveStart(offsetX: number, offsetY: number): void {
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    // Reset offset at the beginning of dragging to prevent jumping
    this.offset = [0, 0];
    this.evaluateBounds();
    let scale = this.lastScale * this.scale;
    if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
      // Hide bars with zoom drag
      this.broadCast.emit(Constants.HIDE_BARS, []);
    }
    if (scale.toFixed(Constants.RESERVED_DIGITS) === this.defaultScale.toFixed(Constants.RESERVED_DIGITS) && offsetY > 0) {
      // Drop down return to hide details first
      this.broadCast.emit(Constants.PULL_DOWN_START, []);
    }
  }

  /**
   * Each callback returns the displacement relative to the start point of the gesture
   *
   * @param offsetX offsetX
   * @param offsetY offsetY
   */
  onMove(offsetX: number, offsetY: number): void {
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    let scale = this.lastScale * this.scale;
    let limits = this.evaluateOffsetRange(scale);
    let measureX = this.lastOffset[0] + (this.center[0] - Constants.CENTER_DEFAULT) * this.componentWidth
    * (this.defaultScale - this.scale) * this.lastScale;
    let measureY = this.lastOffset[1] + (this.center[1] - Constants.CENTER_DEFAULT) * this.componentHeight
    * (this.defaultScale - this.scale) * this.lastScale;
    let moveX = offsetX;
    let moveY = offsetY;
    let offX = measureX + moveX;
    let offY = measureY + moveY;
    if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
      // The offset in the X direction is always limited for non shrinking scenes
      offX = MathUtils.clamp(offX, limits[0], limits[1]);
      if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
        // cannot drop down to return to the scene, limit y
        offY = MathUtils.clamp(offY, limits[Constants.NUMBER_2], limits[Constants.NUMBER_3]);
      } else {
        // pull down to return to the scene, and only limit y to drag upward, that is, limit the lower bound
        offY = Math.max(limits[Constants.NUMBER_2], offY);
      }
    }
    let tmpX = offX - measureX;
    let tmpY = offY - measureY;
    this.offset = [tmpX, tmpY];
    this.emitTouchEvent();
  }

  onMoveEnd(offsetX, offsetY): void {
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    let scale = this.lastScale * this.scale;
    Log.debug(TAG, 'onMoveEnd: scale is ' + scale + ' offsetY is ' + offsetY);
    if (scale.toFixed(Constants.RESERVED_DIGITS) === this.defaultScale.toFixed(Constants.RESERVED_DIGITS) && offsetY > Constants.PULL_DOWN_THRESHOLD) {
      this.emitPullDownToBackEvent();
    } else if (scale.toFixed(Constants.RESERVED_DIGITS) === this.defaultScale.toFixed(Constants.RESERVED_DIGITS)) {
      // The reset animation is triggered when the threshold is not reached
      let scaleOption: Matrix4.ScaleOption = {
        x: this.defaultScale,
        y: this.defaultScale
      };
      this.startAnimation(Matrix4.identity().scale(scaleOption).copy() as Matrix4TransitWithMatrix4x4);
      this.emitPullDownCancelEvent();
    } else {
      this.emitDirectionChange();
    }
  }

  onScaleStart(scale: number, centerX: number, centerY: number): void {
    Log.info(TAG, 'onScaleStart: ' + this.isInAnimation + ', ' + this.isExiting);
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    this.scale = 1;
    this.evaluateBounds();
    // Adjust action bar status
    this.broadCast.emit(Constants.HIDE_BARS, []);
    this.center = this.evaluateCenter(centerX, centerY);
  }

  /**
   * Calculates the percentage position of the current zoom center relative to the control
   *
   * @param centerX The absolute position of the touch point on the screen
   * @param centerY The absolute position of the touch point on the screen
   * @returns The percentage position of the current zoom center relative to the control
   */
  private evaluateCenter(centerX: number, centerY: number): number[] {
    // Calculate the coordinates of the upper left corner of the control relative to
    // the upper left corner of the current display
    let scale = this.lastScale * this.scale;
    let leftTop = this.evaluateCompBounds();

    // Get the touch coordinates relative to the control
    let cxRelativeToComp = MathUtils.clamp((centerX - leftTop[0])
    / (this.componentWidth * scale), this.leftMost, 1 - this.leftMost);
    let cyRelativeToComp = MathUtils.clamp((centerY - leftTop[1])
    / (this.componentHeight * scale), this.topMost, 1 - this.topMost);

    let imgDisplaySize: number[] = this.evaluateImgDisplaySize();
    let imgDisplayWidth = imgDisplaySize[0];
    let imgDisplayHeight = imgDisplaySize[1];

    let imgDisplayBounds = this.evaluateImgDisplayBounds();
    let imgLeftBound = imgDisplayBounds[0];
    let imgTopBound = imgDisplayBounds[1];

    // When the touch center point is outside the picture display area, take the midpoint
    if (this.width / this.height > this.componentWidth / this.componentHeight) {
      if (centerY < imgTopBound || centerY > imgTopBound + imgDisplayHeight) {
        cyRelativeToComp = Constants.CENTER_DEFAULT;
      }
    } else {
      if (centerX < imgLeftBound || centerX > imgLeftBound + imgDisplayWidth) {
        cxRelativeToComp = Constants.CENTER_DEFAULT;
      }
    }

    // Calculate the percentage of the center point of the touch
    let center: number[] = [cxRelativeToComp, cyRelativeToComp];
    Log.debug(TAG, 'evaluateCenter center: ' + center + ', ' + centerX + ',' + centerY +
    ',size: ' + imgDisplaySize + ', bounds: ' + imgDisplayBounds + ', leftTop: ' + leftTop +
    ',compSize: ' + this.componentWidth * scale + ',' + this.componentHeight * scale);
    return center;
  }

  onScale(scale: number): void {
    Log.debug(TAG, 'onScale: ' + this.isInAnimation + ', ' + this.isExiting + ', scale: ' + scale);
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    this.evaluateBounds();
    this.scale = scale;
    if (this.lastScale * scale <= Constants.COMPONENT_SCALE_FLOOR) {
      this.scale = Constants.COMPONENT_SCALE_FLOOR / this.lastScale;
    }
    if (this.lastScale * scale >= this.maxScale * Constants.OVER_SCALE_EXTRA_FACTOR) {
      this.scale = this.maxScale * Constants.OVER_SCALE_EXTRA_FACTOR / this.lastScale;
    }
    this.emitTouchEvent();
  }

  onScaleEnd(): void {
    Log.info(TAG, 'onScaleEnd: ' + this.isInAnimation + ', ' + this.isExiting);
    if (this.isInAnimation || this.isExiting) {
      return;
    }
    this.evaluateBounds();
    let scale = this.lastScale * this.scale;
    if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) >= Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS)) && scale <= this.maxScale) {
      Log.info(TAG, 'does not need to do animation: ' + scale);
      this.emitDirectionChange();
      return;
    }
    let animationEndMatrix: Matrix4.Matrix4Transit = null;
    if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) <= Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
      // Zoom out too small to trigger the restored animation
      let scaleOption: Matrix4.ScaleOption = {
        x: this.defaultScale,
        y: this.defaultScale
      };
      animationEndMatrix = Matrix4.identity().scale(scaleOption).copy();
    } else {
      // Do the animation of retracting maxScale when zooming in
      animationEndMatrix = this.evaluateAnimeMatrix(this.maxScale, this.center);
    }
    this.startAnimation(animationEndMatrix as Matrix4TransitWithMatrix4x4);
  }

  private evaluateAnimeMatrix(scale: number, center: number[]): Matrix4.Matrix4Transit {
    let offset: number[] = [
      this.lastOffset[0] + this.offset[0] + (center[0] - Constants.CENTER_DEFAULT) * this.componentWidth
      * (this.defaultScale - scale / this.lastScale) * this.lastScale,
      this.lastOffset[1] + this.offset[1] + (center[1] - Constants.CENTER_DEFAULT) * this.componentHeight
      * (this.defaultScale - scale / this.lastScale) * this.lastScale
    ];
    if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
      let limits = this.evaluateOffsetRange(scale);
      // The offset in the X direction is always limited for non shrinking scenes
      offset[0] = MathUtils.clamp(offset[0], limits[0], limits[1]);
      if (Number(scale.toFixed(Constants.RESERVED_DIGITS)) > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
        // Cannot drop down to return to the scene, limit y
        offset[1] = MathUtils.clamp(offset[1], limits[Constants.NUMBER_2], limits[Constants.NUMBER_3]);
      } else {
        // You can pull down to return to the scene, and only limit y to drag upward,
        // that is, limit the lower bound
        offset[1] = Math.max(limits[Constants.NUMBER_2], offset[1]);
      }
    } else {
      // When zooming in, adjust the zoom center to the display center point
      offset = [0, 0];
    }
    let scaleOption: Matrix4.ScaleOption = {
      x: scale,
      y: scale,
    };
    let translateOption: Matrix4.TranslateOption = {
      x: offset[0],
      y: offset[1]
    };
    let animationEndMatrix = Matrix4.identity()
      .copy()
      .scale(scaleOption)
      .translate(translateOption)
      .copy();
    Log.debug(TAG, 'evaluateAnimeMatrix scale:' + scale + ', center:' + center);
    return animationEndMatrix;
  }

  /**
   * Double click to trigger zoom.
   * If the current scale is less than or equal to 1, zoom to doubleTapScale;
   * If the current scale is greater than 1, scale to 1;
   *
   * @param centerX the location of double click
   * @param centerY the location of double click
   */
  onDoubleTap(centerX: number, centerY: number): void {
    if (this.isInAnimation || this.isExiting) {
      Log.debug(TAG, 'onDoubleTap not avaliable: ' + this.isInAnimation + ', ' + this.isExiting);
      return;
    }
    // Adjust action bar status
    this.broadCast.emit(Constants.HIDE_BARS, []);
    let matrix: Matrix4TransitWithMatrix4x4;
    Log.debug(TAG, 'onDoubleTap lastScale: ' + this.lastScale + ', scale: ' + this.scale + ', defaultScale: ' + this.defaultScale);
    if (Number(this.lastScale.toFixed(Constants.RESERVED_DIGITS)) * this.scale > Number(this.defaultScale.toFixed(Constants.RESERVED_DIGITS))) {
      // Scale to original state when scale is greater than 1
      let scaleOption: Matrix4.ScaleOption = {
        x: this.defaultScale,
        y: this.defaultScale
      };
      matrix = Matrix4.identity().scale(scaleOption).copy() as Matrix4TransitWithMatrix4x4;
    } else {
      // The zoom in status calculates the zoom in center according to the click position
      let center = this.evaluateCenter(centerX, centerY);
      // When the picture aspect ratio is less than the control aspect ratio,
      // centerX is set to 0.5,
      // whereas centerY is set to 0.5 to ensure that
      // the short side is close to the side after double clicking and enlarging
      if (this.width / this.height < this.componentWidth / this.componentHeight) {
        center = [Constants.CENTER_DEFAULT, center[1]];
      } else {
        center = [center[0], Constants.CENTER_DEFAULT];
      }
      matrix = this.evaluateAnimeMatrix(this.doubleTapScale * this.defaultScale, center) as Matrix4TransitWithMatrix4x4;
    }
    Log.debug(TAG, 'onDoubleTap matrix: ' + matrix.matrix4x4);
    this.startAnimation(matrix);
  }

  reset(): void {
    this.lastOffset = [0, 0];
    this.offset = [0, 0];
    this.lastScale = 1.0;
    this.scale = 1;
    this.hasReachLeft = true;
    this.hasReachRight = true;
    this.hasReachTop = true;
    this.hasReachBottom = true;
    this.isInAnimation = false;
    this.isExiting = false;
    this.emitDirectionChange();
  }

  onDisAppear(): void {
    Log.info(TAG, 'onDisAppear');
  }

  private startAnimation(animationEndMatrix: Matrix4TransitWithMatrix4x4): void {
    this.isInAnimation = true;
    let animationOption: AnimationOption = {
      duration: Constants.OVER_SCALE_ANIME_DURATION,
      curve: Curve.Ease
    };
    Log.debug(TAG, 'animationEndMatrix: ' + animationEndMatrix.matrix4x4);
    this.broadCast.emit(Constants.ANIMATION_EVENT + this.item.uri + this.timeStamp, [animationOption, animationEndMatrix]);
  }

  /**
   * At the end of the animation,
   * refresh the current parameter values according to the end transformation matrix to ensure continuity and
   * prevent jumping during the next gesture operation
   *
   * @param animationEndMatrix Transformation matrix at end
   */
  onAnimationEnd(animationEndMatrix: Matrix4TransitWithMatrix4x4): void {
    if (animationEndMatrix != null) {
      Log.info(TAG, 'onAnimationEnd: ' + animationEndMatrix.matrix4x4);
      this.lastScale = animationEndMatrix.matrix4x4[0];
      this.scale = 1;
      this.lastOffset = [animationEndMatrix.matrix4x4[Constants.NUMBER_12], animationEndMatrix.matrix4x4[Constants.NUMBER_13]];
      this.offset = [0, 0];
      this.evaluateBounds();
      this.isInAnimation = false;
      this.emitDirectionChange();
    }
  }
}
