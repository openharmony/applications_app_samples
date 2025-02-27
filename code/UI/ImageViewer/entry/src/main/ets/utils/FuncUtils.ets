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

import { ImageViewerConstants } from '../constants/ImageViewerConstants';

/**
 * 给函数的执行加上动画
 * @param fn：要在动画内执行的回调函数，通常fn里面会改变状态变量
 * @param duration：动画持续时长
 * @param curve：动画区线
 */
export function runWithAnimation(
  fn: Function,
  duration: number = ImageViewerConstants.ANIMATE_DURATION,
  curve: Curve = Curve.Smooth): void {
  animateTo({ duration: duration, curve: curve }, () => {
    fn();
  })
}

/**
 * 计算旋转角度
 * @param angle {number} 旋转角度
 * @returns {number} 最终需要旋转的角度
 */
export function simplestRotationQuarter(angle: number): number {
  // 一个完整的圆的角度是360度
  const FULL_CIRCLE: number = 360;
  // 每个象限的角度是90度
  const QUADRANT_DEGREES: number = 90;
  // 为了正确处理角度在象限边界的情况，使用44.5作为偏移量。
  // 这个值是为了确保当角度正好处于两个象限的边界上时（如45, 135, 225, 315度），它会被归入正确的象限。
  const BOUNDARY_OFFSET: number = 44.5;

  // 将角度限制在360度内
  let normalizedAngle: number = angle % FULL_CIRCLE;

  // 确定象限
  const QUADRANT: number = Math.floor((Math.abs(normalizedAngle) + BOUNDARY_OFFSET) / QUADRANT_DEGREES) % 4;

  // 根据象限确定旋转角度
  const standardRotations: number[] = [0, 90, 180, 270];
  let rotation = standardRotations[QUADRANT];

  // 保持原始角度的方向
  let finalRotation = rotation * (angle >= 0 ? 1 : -1);

  // 返回最终的简化旋转角度
  return finalRotation || 0;
}