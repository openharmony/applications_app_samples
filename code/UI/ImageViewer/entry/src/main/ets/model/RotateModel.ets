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

// 旋转信息
@Observed
export class RotateModel {
  // 当前旋转角度
  public currentRotate: number;
  // 最后的角度
  public lastRotate: number = 0;
  // 起步触发旋转的角度
  public startAngle:number = 20;

  constructor(currentX: number = 0) {
    this.currentRotate = currentX;
  }

  // 重置
  reset(): void {
    this.currentRotate = 0;
    this.lastRotate = 0;
  }

  // 保存最后的数据
  stash(): void {
    // 一个完整的圆的角度是360度
    let angle = 360;
    this.lastRotate = this.currentRotate % angle;
  }

}