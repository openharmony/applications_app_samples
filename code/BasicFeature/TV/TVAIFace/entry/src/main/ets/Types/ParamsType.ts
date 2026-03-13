/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { mindSporeLite } from '@kit.MindSporeLiteKit';

export interface FaceObject {
  finalbox: finalboxModel,
  pts: Array<ptsModel>,
  score?: number
}

export interface finalboxModel {
  x: number,
  y: number,
  width: number,
  height: number,
  size: number,
  w: number,
  h: number
}

export interface ptsModel {
  x: number,
  y: number
}

export interface AcInfo {
  cls?: mindSporeLite.MSTensor,
  reg?: mindSporeLite.MSTensor,
  pts?: mindSporeLite.MSTensor
}

export interface AnchorCfg {
  SCALES: number[],
  RATIOS: number[],
  BASE_SIZE: number
}

export interface ImagePosition {
  x: number;
  y: number;
  width: number;
  height: number;
}

export interface WindowSizeInfo {
  width: number;
  height: number;
  pageW: number;
  pageH: number;
  dpi: number;
  lpi: number;
}
