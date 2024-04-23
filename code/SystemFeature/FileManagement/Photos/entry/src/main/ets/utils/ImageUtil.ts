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

import { Log } from './Log';

const TAG = 'ImageUtil';
const MAX_BIT = 30;
const BIT_SIXTEEN = 16;
const BIT_EIGHT = 8;
const BIT_FOUR = 4;
const BIT_TWO = 2;
const BIT_ONE = 1;

export function computeSampleSize(width: number, height: number, minSideLength: number, maxNumOfPixels: number): number {
  if (width === 0 || height === 0 || minSideLength === 0 || maxNumOfPixels === 0) {
    return 2;
  }
  let initialSize = computeInitialSampleSize(width, height, minSideLength, maxNumOfPixels);
  Log.info(TAG, 'initialSize:  ' + initialSize);
  return initialSize <= 8 ? nextPowerOf2(initialSize) : Math.floor((initialSize + 8 - 1) / 8) * 8;
}

function computeInitialSampleSize(width: number, height: number, minSideLength: number, maxNumOfPixels: number): number {
  if ((maxNumOfPixels === -1) && (minSideLength === -1)) {
    return 1;
  }
  let lowerBound: number = (maxNumOfPixels === -1) ? 1 : Math.ceil(Math.sqrt((width * height) / maxNumOfPixels));
  Log.info(TAG, 'lowerBound: ' + lowerBound);
  if (minSideLength === -1) {
    return lowerBound;
  } else {
    let sampleSize = Math.min(width / minSideLength, height / minSideLength);
    return Math.max(sampleSize, lowerBound);
  }
}

function nextPowerOf2(value: number): number {
  let useValue = value;
  if (useValue <= 0 || useValue > (1 << MAX_BIT)) {
  }
  useValue -= 1;
  useValue |= useValue >> BIT_SIXTEEN;
  useValue |= useValue >> BIT_EIGHT;
  useValue |= useValue >> BIT_FOUR;
  useValue |= useValue >> BIT_TWO;
  useValue |= useValue >> BIT_ONE;
  Log.info(TAG, 'nextPowerOf2:' + useValue);
  return useValue + 1;
}
