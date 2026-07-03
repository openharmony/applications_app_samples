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

/**
 * 相对于控制图标的偏移量
 */
export default class Point {
  public x: number = 0;
  public y: number = 0;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }

  /**
   * 和中心点的角度
   */
  private angle?: number;
  //是否已经分配
  public hasAllotted: boolean = false;

  /**
   * 设置>0的角度，
   * @param angle
   */
  public setAngle(angle: number) {
    this.angle = angle;
  }

  //中间线附近的元素不要
  public readonly plusAngle: number = 20;

  /**
   * 是否是上半区的位置
   */
  public isTop() {
    if (this.angle && this.angle > 0) {
      const angleT: number = this.angle % 360;
      if (angleT < 90 - this.plusAngle || angleT > 270 + this.plusAngle) {
        return true;
      }
    }
    return false;
  }

  public isBottom() {
    if (this.angle && this.angle > 0) {
      const angleT: number = this.angle % 360;
      if (angleT > 90 + this.plusAngle && angleT < 270 - this.plusAngle) {
        return true;
      }
    }
    return false;
  }
};