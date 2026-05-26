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
import Point from '../viewmodel/Point';

/**
 * 三角函数工具类
 */
export default class TrigonometricFunctionUtil {
  /**
   * 已知角度angle，取值0~360，已知距离length，求偏移量point(x,y)
   * @param angle
   * @param length
   */
  static computePoint(angle: number, length: number): Point {
    const rad = angle * Math.PI / 180;
    let x: number = length * Math.sin(rad);
    let y: number = length * Math.cos(rad);
    //在以上为小，下为大的坐标系，y需要置负, 全部转为默认单位vp
    return new Point(px2vp(x), px2vp(-y));
  }
};