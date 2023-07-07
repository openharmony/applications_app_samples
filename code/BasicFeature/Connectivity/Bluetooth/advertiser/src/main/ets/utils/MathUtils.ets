/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

const DEFAULT_PRECISION: number = 2;

export default class MathUtils {

  /**
   * 生成指定范围内的随机整数
   * @param min
   * @param max
   */
  static getRandomInt(min: number, max: number): number {
    return Math.floor(Math.random() * (max - min + 1) + min);
  }

  /**
   * 生成指定范围内的随机小数
   * @param min
   * @param max
   * @param precision
   */
  static getRandomFloat(min: number, max: number, precision: number = DEFAULT_PRECISION): number {
    let random = Math.random() * (max - min) + min;
    return parseFloat(random.toFixed(precision));
  }
}