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
import { CommonConstants } from '../common/constant/CommonConstants';

/**
 * Exec color transform.
 *
 * @param bufferArray.
 * @param last.
 * @param cur.
 * @param hsvIndex.
 * @return arrayBuffer.
 */
export function execColorInfo(bufferArray: ArrayBuffer, last: number, cur: number): ArrayBuffer {
  if (!bufferArray) {
    return new ArrayBuffer(0);
  }
  const newBufferArr = bufferArray;
  let colorInfo: Uint8Array = new Uint8Array(newBufferArr);
  for (let i: number = 0; i < colorInfo?.length; i += CommonConstants.PIXEL_STEP) {
    const hsv: HSV = rgb2hsv(colorInfo[i + RGBIndex.RED], colorInfo[i + RGBIndex.GREEN], colorInfo[i + RGBIndex.BLUE]);
    let rate = cur / last;
    hsv.hsvS *= rate;
    const rgb: RGB = hsv2rgb(hsv.hsvH, hsv.hsvS, hsv.hsvV);
    colorInfo[i + RGBIndex.RED] = rgb.rgbR;
    colorInfo[i + RGBIndex.GREEN] = rgb.rgbG;
    colorInfo[i + RGBIndex.BLUE] = rgb.rgbB;
  }
  return newBufferArr;
}

/**
 * RGB transform to HSV.
 *
 * @param red 0- 255.
 * @param green 0- 255.
 * @param blue 0- 255.
 * @return h (0 - 360) s(0 - 100) v (0 - 100).
 */
function rgb2hsv(red: number, green: number, blue: number): HSV {
  let hsvH: number = 0, hsvS: number = 0, hsvV: number = 0;
  const rgbR: number = colorTransform(red);
  const rgbG: number = colorTransform(green);
  const rgbB: number = colorTransform(blue);
  const maxValue: number = Math.max(rgbR, Math.max(rgbG, rgbB));
  const minValue: number = Math.min(rgbR, Math.min(rgbG, rgbB));
  hsvV = maxValue * CommonConstants.CONVERT_INT;
  if (maxValue === 0) {
    hsvS = 0;
  } else {
    hsvS = Number((1 - minValue / maxValue).toFixed(CommonConstants.DECIMAL_TWO)) * CommonConstants.CONVERT_INT;
  }
  if (maxValue === minValue) {
    hsvH = 0;
  }
  if (maxValue === rgbR && rgbG >= rgbB) {
    hsvH = Math.floor(CommonConstants.ANGLE_60 * ((rgbG - rgbB) / (maxValue - minValue)));
  }
  if (maxValue === rgbR && rgbG < rgbB) {
    hsvH = Math.floor(CommonConstants.ANGLE_60 * ((rgbG - rgbB) / (maxValue - minValue)) + CommonConstants.ANGLE_360);
  }
  if (maxValue === rgbG) {
    hsvH = Math.floor(CommonConstants.ANGLE_60 * ((rgbB - rgbR) / (maxValue - minValue)) + CommonConstants.ANGLE_120);
  }
  if (maxValue === rgbB) {
    hsvH = Math.floor(CommonConstants.ANGLE_60 * ((rgbR - rgbG) / (maxValue - minValue)) + CommonConstants.ANGLE_240);
  }
  return new HSV(hsvH, hsvS, hsvV);
}

class RGB {
  rgbR: number = 0;
  rgbG: number = 0;
  rgbB: number = 0;

  constructor(r: number, g: number, b: number) {
    this.rgbR = r;
    this.rgbG = g;
    this.rgbB = b;
  }
}

class HSV {
  hsvH: number = 0;
  hsvS: number = 0;
  hsvV: number = 0;

  constructor(h: number, s: number, v: number) {
    this.hsvH = h;
    this.hsvS = s;
    this.hsvV = v;
  }
}

/**
 *  HSV to RGB conversion formula:
 *  When 0 <= H <= 360, 0 <= S <= 1 and 0 <= V <= 1:
 *  C = V * S
 *  X = C * (1 - Math.abs((H / 60) mod 2 - 1))
 *  m = V - C
 *                   | (C, X ,0),  0 <= H < 60
 *                   | (X, C, 0),  60 <= H < 120
 *                   | (0, C, X),  120 <= H < 180
 *  (R', G', B') =   | (0, X, C),  180 <= H < 240
 *                   | (X, 0, C),  240 <= H < 300
 *                   | (C, 0, X),  300 <= H < 360
 *
 *  (R, G, B) = ((R' + m) * 255, (G' + m) * 255, (B' + m) * 255)
 *
 * @param h hue 0 ~ 360.
 * @param s saturation 0 ~ 100.
 * @param v value 0 ~ 100.
 * @return rgb value.
 */
function hsv2rgb(hue: number, saturation: number, value: number): RGB {
  let rgbR: number = 0, rgbG: number = 0, rgbB: number = 0;
  if (saturation === 0) {
    rgbR = rgbG = rgbB = Math.round((value * CommonConstants.COLOR_LEVEL_MAX) / CommonConstants.CONVERT_INT);
    return new RGB(rgbR, rgbG, rgbB);
  }
  const cxmC = (value * saturation) / (CommonConstants.CONVERT_INT * CommonConstants.CONVERT_INT);
  const cxmX = cxmC * (1 - Math.abs((hue / CommonConstants.ANGLE_60) % CommonConstants.MOD_2 - 1));
  const cxmM = (value - cxmC * CommonConstants.CONVERT_INT) / CommonConstants.CONVERT_INT;
  const hsvHRange = Math.floor(hue / CommonConstants.ANGLE_60);
  switch (hsvHRange) {
    case AngelRange.ANGEL_0_60:
      rgbR = (cxmC + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbG = (cxmX + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbB = (0 + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      break;
    case AngelRange.ANGEL_60_120:
      rgbR = (cxmX + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbG = (cxmC + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbB = (0 + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      break;
    case AngelRange.ANGEL_120_180:
      rgbR = (0 + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbG = (cxmC + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbB = (cxmX + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      break;
    case AngelRange.ANGEL_180_240:
      rgbR = (0 + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbG = (cxmX + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbB = (cxmC + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      break;
    case AngelRange.ANGEL_240_300:
      rgbR = (cxmX + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbG = (0 + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbB = (cxmC + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      break;
    case AngelRange.ANGEL_300_360:
      rgbR = (cxmC + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbG = (0 + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      rgbB = (cxmX + cxmM) * CommonConstants.COLOR_LEVEL_MAX;
      break;
    default:
      break;
  }
  return new RGB(Math.round(rgbR),
    Math.round(rgbG),
    Math.round(rgbB));
}

/**
 * Color transform.
 *
 * @param rgbValue 0 - 255.
 * @return 0 - 1.
 */
function colorTransform(rgbValue: number) : number{
  return Number((rgbValue / CommonConstants.COLOR_LEVEL_MAX).toFixed(CommonConstants.DECIMAL_TWO));
}

/**
 * HSV type.
 */
export enum HSVIndex {
  HUE,
  SATURATION,
  VALUE
}

/**
 * Angel range.
 */
export enum AngelRange {
  ANGEL_0_60,
  ANGEL_60_120,
  ANGEL_120_180,
  ANGEL_180_240,
  ANGEL_240_300,
  ANGEL_300_360
}

/**
 * RGB color, red,green and blue.
 */
export enum RGBIndex {
  RED,
  GREEN,
  BLUE
}