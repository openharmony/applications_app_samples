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

import {
  CustomPatternLock,
  CustomPatternLockController,
  CustomPatternLockChallengeResult,
  CustomCircleStyleOptions
} from './CustomPatternLock';

@Entry
@Component
struct Index {
  @State statusMessage: string = '请绘制图案（至少5个点）';
  // 波纹效果和前景显示开关
  @State enableWaveEffect: boolean = true;  // 默认启用波纹效果
  @State enableForeground: boolean = false;  // 默认不遮盖宫格圆点

  // 控制器
  private patternLockController: CustomPatternLockController = new CustomPatternLockController();
  // 演示用：存储的正确密码
  private correctPassword: number[] = [0, 1, 2, 5, 8];

  build() {
    Column() {
      Text(this.statusMessage)
        .fontSize(24)
        .fontWeight(FontWeight.Bold)
        .margin({ top: 20, bottom: 10 })

      // Canvas 图案锁组件（使用类似原生 PatternLock 的属性）
      CustomPatternLock({
        controller: this.patternLockController,
        sideLength: 288,
        circleRadius: 6,  // 圆点半径
        regularColor: '#FF182431',
        selectedColor: '#FF182431',
        activeColor: '#FF182431',
        pathColor: '#33182431',
        pathStrokeWidth: 12,
        autoReset: true,
        skipUnselectedPoint: false,  // 不跳过未选中的连接的中间点
        activateCircleStyle: new CustomCircleStyleOptions(
          '#33182431',  // 激活圆点背景颜色
          11,  // 激活圆点背景圆环半径
          this.enableWaveEffect,  // 波纹效果开关
          this.enableForeground  // 前景显示开关
        ),
        selectedDot: [], // 默认选中圆点
        onPatternComplete: (input: number[]) => {
          this.handlePatternComplete(input);
        },
        onDotConnect: (index: number) => {
          this.handleDotConnect(index);
        }
      })
      .margin({ bottom: 20 })
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F5F5F5')
  }

  // 处理图案完成事件
  handlePatternComplete(input: number[]) {
    // 验证密码
    if (input.length < 5) {
      this.statusMessage = '至少需要连接5个点！';
      this.patternLockController.setChallengeResult(CustomPatternLockChallengeResult.WRONG);
      return;
    }

    const isCorrect = this.verifyPassword(input);
    if (isCorrect) {
      this.statusMessage = '密码正确！';
      this.patternLockController.setChallengeResult(CustomPatternLockChallengeResult.CORRECT);
    } else {
      this.statusMessage = '密码错误！输入：' + input.join(' → ');
      this.patternLockController.setChallengeResult(CustomPatternLockChallengeResult.WRONG);
    }

    // 延迟重置状态文字
    setTimeout(() => {
      this.resetStatus();
    }, 2000);
  }

  // 处理圆点连接事件
  handleDotConnect(index: number) {
    console.log('连接圆点：' + index);
  }

  // 验证密码
  verifyPassword(input: number[]): boolean {
    if (input.length !== this.correctPassword.length) {
      return false;
    }
    for (let i = 0; i < input.length; i++) {
      if (input[i] !== this.correctPassword[i]) {
        return false;
      }
    }
    return true;
  }

  // 重置状态
  resetStatus() {
    this.statusMessage = '请绘制图案（至少5个点）';
    this.patternLockController.reset();
  }
}