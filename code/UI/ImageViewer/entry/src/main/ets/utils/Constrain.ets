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
import { windowSizeManager } from './Managers';
import { OffsetModel } from '../model/OffsetModel';
import { runWithAnimation } from './FuncUtils';
import { window } from '@kit.ArkUI';

/**
 * 图片适配类型
 */
export enum ImageFitType {
  TYPE_WIDTH = 'width',
  TYPE_HEIGHT = 'height',
  TYPE_DEFAULT = 'default'
}


/**
 * 计算图片的偏移结构
 */
export interface ConstrainOffsetAndAnimationType {
  // 此次计算的方向 宽或者高
  dimensionWH: ImageFitType,

  // 此次图片的默认尺寸
  imageDefaultSize: image.Size,

  // 此次图片相对应的偏移信息
  imageOffsetInfo: OffsetModel,

  // 此次图片的放大尺寸
  scaleValue: number,

  // 当前图片的旋转角度
  rotate: number,

  /**
   * 当超出限制多少时去判断
   * 取值：0 ~ 1
   * 当滑动在视图中，超过窗口多少距离时候才去触发切换返回值
   * 默认值：0.2
   */
  togglePercent: number
  //  List 偏移量
  imageListOffset: number
}


// 获取最大偏移量
export function getMaxAllowedOffset(winSize: number, imageSize: number, scale: number): number {
  const maxNum: number = Math.max(imageSize * scale, winSize);
  const minNum: number = Math.min(imageSize * scale, winSize);
  return (maxNum - minNum) / 2;
}

/**
 * 约束图片偏移，确保不超出视口边界
 * @param offset   -- 当前偏移量
 * @param winSize -- 视口大小
 * @param imageSize -- 图片大小
 * @param scale    -- 缩放
 */
function constrainOffset(offset: number, winSize: number, imageSize: number, scale: number): number {
  let maxAllowedOffset: number = getMaxAllowedOffset(winSize, imageSize, scale);
  return Math.min(Math.max(offset, -maxAllowedOffset), maxAllowedOffset);
}


/**
 * 查询图片是否需要切换图片
 * @param offset   -- 当前偏移量
 * @param winSize -- 视口大小
 * @param imageSize -- 图片大小
 * @param scale    -- 缩放
 * @param TogglePercent    -- 移动视口多少时候需要切换图片
 */
function isToggle(offset: number, winSize: number, imageSize: number, scale: number, togglePercent: number): boolean {
  let maxAllowedOffset: number = getMaxAllowedOffset(winSize, imageSize, scale);
  const deviation: number = Math.abs(offset) - maxAllowedOffset;
  const switchThreshold: number = winSize * togglePercent;

  if (deviation > switchThreshold) {
    return true;
  }
  return false;
}

// 查询当前是尺寸
export function getImgSize(imageSize: image.Size, rotate: number,
  dimensionWH: ImageFitType.TYPE_WIDTH | ImageFitType.TYPE_HEIGHT): number {
  const isStandardRotation: boolean = [90, 270].includes(Math.abs(rotate % 360));
  const key: ImageFitType.TYPE_WIDTH | ImageFitType.TYPE_HEIGHT =
    isStandardRotation ? (dimensionWH == ImageFitType.TYPE_WIDTH ? ImageFitType.TYPE_HEIGHT : ImageFitType.TYPE_WIDTH) :
      dimensionWH;
  return imageSize[key];
}


/**
 * 用来计算 图片所需要的偏移量
 * 防止 图片超出显示视图
 * @param { ConstrainOffsetAndAnimationType } info  -  所需要的数据
 * @return { [boolean, boolean] }  - 返回是否移动
 *    如果是 info.dimensionWH 是 "width" 返回值为 [ 左边超出， 右边超出]
 *    如果是 info.dimensionWH 是 "height" 返回值为 [ 上边超出， 下边超出]
 */
export function constrainOffsetAndAnimation(info: ConstrainOffsetAndAnimationType): [boolean, boolean] {
  if (info.dimensionWH === ImageFitType.TYPE_DEFAULT) {
    return [false, false];
  }
  const WIN_SIZE: window.Size = windowSizeManager.get();
  // 获取图片在指定轴上的原始尺寸
  const IMG_SIZE: number = getImgSize(info.imageDefaultSize, info.rotate, info.dimensionWH);
  // 获取窗口对应轴的尺寸
  const WIN_AXIS_SIZE: number = WIN_SIZE[info.dimensionWH];
  // 获取图片在该轴上的最后偏移量
  let currentOffset: number =
    (info.imageOffsetInfo as object)[`last${info.dimensionWH == ImageFitType.TYPE_WIDTH ? 'X' : 'Y'}`];
  // 最后的图片的偏移量需要加上list偏移量来计算
  currentOffset += info.imageListOffset;
  const CLAMPED_OFFSET: number = constrainOffset(currentOffset, WIN_AXIS_SIZE, IMG_SIZE, info.scaleValue);
  // 如果偏移量发生了变化（即需要修正）
  if (CLAMPED_OFFSET !== currentOffset) {
    let updateFn: () => void =
      () => {
        (info.imageOffsetInfo as object)[`current${info.dimensionWH == ImageFitType.TYPE_WIDTH ? 'X' : 'Y'}`] =
          CLAMPED_OFFSET;
        // 保存当前的偏移状态
        info.imageOffsetInfo.stash();
      }
    runWithAnimation(updateFn);
    let bol: boolean = isToggle(currentOffset, WIN_AXIS_SIZE, IMG_SIZE, info.scaleValue, info.togglePercent);
    if (bol) {
      const BOL: boolean = currentOffset >= 0 ? true : false;
      return [BOL, !BOL];
    }

  }
  return [false, false];
}