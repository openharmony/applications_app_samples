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

import { Point } from '@kit.TestKit';
import { camera } from '@kit.CameraKit';
import { display } from '@kit.ArkUI';

export function limitNumberInRange(src: number, range: number[]) {
  if (range.length < 2) {
    return src;
  }
  if (src < range[0]) {
    return range[0];
  }
  if (src > range[1]) {
    return range[1];
  }
  return src;
}

// find start index the target in which range
// eg： target: 1.5   arr: [0, 1, 5, 10]  return 1
export function findRangeIndex(target: number, arr: number[]) {
  if (arr.length === 0) {
    return -1;
  }
  if (target >= arr[arr.length - 1]) {
    return arr.length - 1;
  }
  return [...arr].sort((a, b) => a - b).findIndex((n, i) => {
    return target >= n && target < arr[i + 1];
  });
}

// Math floor float by digit
// eg: toFixed(9.97, 1) -> 9.9
export function toFixed(num: number, digit: number): string {
  const scale = 10 ** digit;
  return (Math.floor(num * scale) / scale).toFixed(digit);
}

// [Start getClampedChildPosition]
// cal absolute position in parent area
export function getClampedChildPosition(childSize: Size, parentSize: Size, point: Point): Edges {
  // center point
  let left = point.x - childSize.width / 2;
  let top = point.y - childSize.height / 2;
  // limit in left
  if (left < 0) {
    left = 0;
  }
  // limit in right
  if (left + childSize.width > parentSize.width) {
    left = parentSize.width - childSize.width;
  }
  // limit in top
  if (top < 0) {
    top = 0;
  }
  // limit in bottom
  if (top + childSize.height > parentSize.height) {
    top = parentSize.height - childSize.height;
  }
  return { left, top };
}
// [End getClampedChildPosition]

export function showToast(
  uiContext: UIContext,
  message: ResourceStr = '',
  duration = 2000,
  alignment = Alignment.Top,
  offset: Offset = { dx: 0, dy: 300 }
) {
  uiContext.getPromptAction().openToast({
    message,
    duration,
    alignment,
    offset
  });
}

// [Start calCameraPoint]
export function calCameraPoint(eventX: number, eventY: number, width: number, height: number): camera.Point {
  const displayRotation = display.getDefaultDisplaySync().rotation * 90;
  if (displayRotation === 0) {
    return { x: eventY / height, y: 1 - eventX / width };
  }
  if (displayRotation === 90) {
    return { x: 1 - eventX / width, y: 1 - eventY / height };
  }
  if (displayRotation === 180) {
    return { x: 1 - eventY / height, y: eventX / width };
  }
  return { x: eventX / width, y: eventY / height };
}
// [End calCameraPoint]