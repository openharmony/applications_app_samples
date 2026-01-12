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

import { drawing } from '@kit.ArkGraphics2D';

// 图案锁验证结果
export enum CustomPatternLockChallengeResult {
  CORRECT = 1,
  WRONG = 2
}

// 圆点样式配置
export class CustomCircleStyleOptions {
  public color?: number | string;
  public radius?: number;
  public enableWaveEffect?: boolean;  // 波浪效果开关
  public enableForeground?: boolean;  // 背景圆环是否在前景显示

  constructor(
    color?: number | string,
    radius?: number,
    enableWaveEffect?: boolean,
    enableForeground?: boolean
  ) {
    this.color = color;
    this.radius = radius;
    this.enableWaveEffect = enableWaveEffect;
    this.enableForeground = enableForeground;
  }
}

// 颜色对象接口
interface DrawingColor {
  alpha: number;
  red: number;
  green: number;
  blue: number;
}

// 控制器
export class CustomPatternLockController {
  private resetCallback?: () => void;
  private setChallengeResultCallback?: (result: CustomPatternLockChallengeResult) => void;

  constructor() {}

  registerResetCallback(callback: () => void): void {
    this.resetCallback = callback;
  }

  registerSetChallengeResultCallback(callback: (result: CustomPatternLockChallengeResult) => void): void {
    this.setChallengeResultCallback = callback;
  }

  reset(): void {
    if (this.resetCallback) {
      this.resetCallback();
    }
  }

  setChallengeResult(result: CustomPatternLockChallengeResult): void {
    if (this.setChallengeResultCallback) {
      this.setChallengeResultCallback(result);
    }
  }
}

class CircleCenter {
  public centerX: number;
  public centerY: number;

  constructor(centerX: number, centerY: number) {
    this.centerX = centerX;
    this.centerY = centerY;
  }
}

// 激活圆点背景圆环半径动画状态
class BgCircleRadiusState {
  public dotIndex: number; // 圆点索引
  public startTime: number; // 动画开始时间（毫秒）
  public duration: number;  // 动画持续时间（毫秒）

  constructor(dotIndex: number, duration: number = 200) {
    this.dotIndex = dotIndex;
    this.startTime = Date.now();
    this.duration = duration;
  }

  // 获取当前动画进度 (0-1)
  getProgress(): number {
    const elapsed = Date.now() - this.startTime;
    return Math.min(elapsed / this.duration, 1);
  }

  // 动画是否已完成
  isFinished(): boolean {
    return this.getProgress() >= 1;
  }
}

// 波纹动画状态
class WaveState {
  public dotIndex: number; // 圆点索引
  public startTime: number; // 动画开始时间（毫秒）
  public duration: number;  // 波纹持续时间（毫秒）

  constructor(dotIndex: number, duration: number = 600) {
    this.dotIndex = dotIndex;
    this.startTime = Date.now();
    this.duration = duration;
  }

  // 获取当前动画进度 (0-1)
  getProgress(): number {
    const elapsed = Date.now() - this.startTime;
    return Math.min(elapsed / this.duration, 1);
  }

  // 动画是否已完成
  isFinished(): boolean {
    return this.getProgress() >= 1;
  }
}

// 密码错误透明度动画状态
class WrongResultAnimationState {
  public startTime: number; // 动画开始时间（毫秒）
  public duration: number;  // 动画持续时间（毫秒）

  constructor(duration: number = 1000) {
    this.startTime = Date.now();
    this.duration = duration;
  }

  // 获取当前动画进度 (0-1)
  getProgress(): number {
    const elapsed = Date.now() - this.startTime;
    return Math.min(elapsed / this.duration, 1);
  }

  // 获取透明度百分比
  getAlphaPercent(): number {
    const progress = this.getProgress();
    let alphaPercent = 1;
    if (progress < 0.25) {
      alphaPercent = 1 - progress * 2; // 透明度由100%->50%
    } else if (progress < 0.5) {
      alphaPercent = progress * 2; // 透明度由50%->100%
    } else if (progress < 0.75) {
      alphaPercent = (1 - progress) * 2; // 透明度由100%->50%
    } else if (progress < 1){
      alphaPercent = (progress - 0.5) * 2; // 透明度由50%->100%
    }
    return alphaPercent;
  }

  // 动画是否已完成
  isFinished(): boolean {
    return this.getProgress() >= 1;
  }
}

enum InternalStatus {
  NORMAL,
  CORRECT,
  WRONG
}

@Component
export struct CustomPatternLock {
  @Prop sideLength: number = 288;
  @Prop circleRadius: number = 6;
  @Prop regularColor: number | string = '#FF182431';
  @Prop selectedColor: number | string = '#FF182431';
  @Prop activeColor: number | string = '#FF182431';
  @Prop pathColor: number | string = '#33182431';
  @Prop pathStrokeWidth: number = 12;
  @Prop autoReset: boolean = true;
  @Prop skipUnselectedPoint: boolean = false;
  @Prop activateCircleStyle?: CustomCircleStyleOptions = new CustomCircleStyleOptions('#33182431', 11, true, false);
  @Prop selectedDot: number[] = [];
  onPatternComplete?: (input: number[]) => void;
  onDotConnect?: (index: number) => void;
  controller: CustomPatternLockController = new CustomPatternLockController();
  private context: DrawingRenderingContext = new DrawingRenderingContext();
  private selectedCircleRadius: number = 7; //
  private currentStatus: InternalStatus = InternalStatus.NORMAL;
  private isInputting: boolean = false;
  private backgroundCircleRadius: number = 11;  // 默认为激活圆点背景圆环半径，也是触摸判定距离，单位为vp
  private touchX:number = 0; // 触摸点x坐标，单位为px
  private touchY:number = 0; // 触摸点y坐标，单位为px

  private bgCircleRadiusStates: BgCircleRadiusState[] = [];  // 活动的激活圆点背景圆环半径动画状态
  private waveStates: WaveState[] = [];  // 活动的波纹动画状态
  private wrongAnimationState: WrongResultAnimationState = new WrongResultAnimationState();
  private bgCircleRadiusTimer: number = -1; // 激活圆点背景圆环半径动画定时器
  private waveTimer: number = -1;  // 波纹动画定时器
  private wrongResultTimer: number = -1; // 密码错误动画定时器

  aboutToAppear(): void {
    // 已选中圆点半径默认为未被选中圆点半径的7/6倍
    this.selectedCircleRadius = this.circleRadius * 7 / 6;

    // 设置激活圆点背景圆环半径（触摸判定范围）
    if (this.activateCircleStyle && this.activateCircleStyle.radius) {
      this.backgroundCircleRadius = this.activateCircleStyle.radius;
    } else {
      // 激活圆点背景圆环半径默认为圆点半径的11/6倍
      this.backgroundCircleRadius = this.circleRadius * 11 / 6;
    }

    // 注册控制器回调
    if (this.controller) {
      this.controller.registerResetCallback(() => {
        this.reset();
      });
      this.controller.registerSetChallengeResultCallback((result: CustomPatternLockChallengeResult) => {
        if (result === CustomPatternLockChallengeResult.CORRECT) {
          this.showCorrect();
        } else {
          this.showWrong();
        }
      });
    }
  }

  aboutToDisappear(): void {
    // 组件销毁时清理定时器
    this.stopBgCircleRadiusAnimation();
    this.stopWaveAnimation();
    this.stopWrongResultAnimation();
  }

  build() {
    Canvas(this.context)
      .width(this.sideLength)
      .height(this.sideLength)
      .onReady(() => {
        this.initCanvas();
      })
      .onTouch((event?: TouchEvent) => {
        if (event && event.sourceTool === SourceTool.Finger) {
          this.handleTouchEvent(event);
        }
      })
  }

  // 初始化画布
  initCanvas(): void {
    const clearColor: DrawingColor = {
      alpha: 0,
      red: 0,
      green: 0,
      blue: 0
    };
    this.context.canvas.clear(clearColor);
    this.redraw();
    this.context.invalidate();
  }

  // 响应触摸事件
  handleTouchEvent(event: TouchEvent): void {
    let x = event.touches[0].x;
    let y = event.touches[0].y;

    // 保证连线末端与边界相切而不会相交
    if (x < this.pathStrokeWidth / 2) {
      x = this.pathStrokeWidth / 2;
    } else if (x > this.sideLength - this.pathStrokeWidth / 2) {
      x = this.sideLength - this.pathStrokeWidth / 2;
    }
    // 保证连线末端与边界相切而不会相交
    if (y < this.pathStrokeWidth / 2) {
      y = this.pathStrokeWidth / 2;
    } else if (y > this.sideLength - this.pathStrokeWidth / 2) {
      y = this.sideLength - this.pathStrokeWidth / 2;
    }

    // 触摸事件的坐标是vp单位，使用vp2px转换为px
    this.touchX = this.getUIContext().vp2px(x);
    this.touchY = this.getUIContext().vp2px(y);

    if (event.type === TouchType.Down) {
      if (this.autoReset || this.selectedDot.length === 0) {
        this.selectedDot = [];
        this.isInputting = true;
        this.currentStatus = InternalStatus.NORMAL;
        this.checkAndAddDot();
        this.redraw();
      }
    } else if (event.type === TouchType.Move) {
      if (this.isInputting) {
        this.checkAndAddDot();
        this.redraw();
      }
    } else if (event.type === TouchType.Up || event.type === TouchType.Cancel) {
      if (this.isInputting) {
        this.isInputting = false;
        this.checkAndAddDot();
        this.redraw();
        this.triggerPatternComplete();
      }
    }
  }

  // 获取圆点圆心坐标
  getCircleCenter(index: number): CircleCenter {
    const columnNum = index % 3;
    const rowNum = Math.floor(index / 3);

    // 九宫格布局：3 行 × 3 列
    // 基于sideLength(vp)计算圆心位置
    const cellWidth = this.sideLength / 3;
    const cellHeight = this.sideLength / 3;
    const centerXVp = (columnNum + 0.5) * cellWidth;
    const centerYVp = (rowNum + 0.5) * cellHeight;

    // 转换为px
    const centerX = this.getUIContext().vp2px(centerXVp);
    const centerY = this.getUIContext().vp2px(centerYVp);

    return new CircleCenter(centerX, centerY);
  }

  // 判断圆点是否可以被选中并进行选中
  checkAndAddDot(): void {
    for (let i = 0; i < 9; i++) {
      const circleCenter = this.getCircleCenter(i);
      const offsetX = this.touchX - circleCenter.centerX;
      const offsetY = this.touchY - circleCenter.centerY;
      const distance = Math.sqrt(offsetX * offsetX + offsetY * offsetY);

      // 判定触摸点是否在圆点的激活范围内
      if (distance <= this.getUIContext().vp2px(this.backgroundCircleRadius)) {
        if (!this.selectedDot.includes(i)) {
          // 自动连接中间点
          if (!this.skipUnselectedPoint && this.selectedDot.length > 0) {
            const lastDot = this.selectedDot[this.selectedDot.length - 1];
            const middleDots = this.getMiddleDots(lastDot, i);
            middleDots.forEach((dotIndex: number) => {
              if (!this.selectedDot.includes(dotIndex)) {
                this.selectedDot.push(dotIndex);
                this.triggerDotConnect(dotIndex);
              }
            });
          }
          this.selectedDot.push(i);
          this.triggerDotConnect(i);
        }
        return; // 找到匹配的点后立即返回
      }
    }
  }

  // 获取两点之间的中间点
  getMiddleDots(from: number, to: number): number[] {
    const middleDots: number[] = [];
    const fromRow = Math.floor(from / 3);
    const fromCol = from % 3;
    const toRow = Math.floor(to / 3);
    const toCol = to % 3;
    const rowDiff = toRow - fromRow;
    const colDiff = toCol - fromCol;

    // 只有跨越两个格子时才有中间点
    if (Math.abs(rowDiff) === 2 || Math.abs(colDiff) === 2) {
      const middleRow = fromRow + rowDiff / 2;
      const middleCol = fromCol + colDiff / 2;
      const middleIndex = middleRow * 3 + middleCol;
      if (middleRow >= 0 && middleRow < 3 && Number.isInteger(middleRow) &&
        middleCol >= 0 && middleCol < 3 && Number.isInteger(middleCol)) {
        middleDots.push(middleIndex);
      }
    }
    return middleDots;
  }

 // 画布重绘
  redraw(): void {
    const clearColor: DrawingColor = {
      alpha: 0,
      red: 0,
      green: 0,
      blue: 0
    };
    this.context.canvas.clear(clearColor);

    // 根据 enableForeground 决定绘制顺序
    const enableForeground = this.activateCircleStyle?.enableForeground ?? false;

    if (enableForeground) {
      // 背景圆环显示在圆点上方，遮盖宫格圆点
      this.drawAllCircles();
      this.drawLine(); // 绘制连线
      this.drawBackgroundCircles(); // 绘制背景圆环
      this.drawWaveEffect(); // 绘制波纹效果
    } else {
      // 背景圆环显示在圆点下方，不遮盖宫格圆点
      this.drawLine(); // 绘制连线
      this.drawBackgroundCircles(); // 绘制背景圆环
      this.drawWaveEffect(); // 绘制波纹效果
      this.drawAllCircles();
    }

    this.context.invalidate();
  }

  // 绘制圆点
  drawAllCircles(): void {
    for (let i = 0; i < 9; i++) {
      const circleCenter = this.getCircleCenter(i);
      const isSelected = this.selectedDot.includes(i);
      let colorStr: string;

      let alphaPercent = 1;
      let circleRadius = this.circleRadius;
      if (isSelected) {
        circleRadius = this.selectedCircleRadius;
        if (this.currentStatus === InternalStatus.WRONG) {
          colorStr = '#FF0000';
          alphaPercent = this.wrongAnimationState.getAlphaPercent();
        } else if (this.currentStatus === InternalStatus.CORRECT) {
          colorStr = '#0000FF';
        } else if (i === this.selectedDot[this.selectedDot.length - 1] && this.isInputting) {
          colorStr = this.colorToString(this.activeColor);
        } else {
          colorStr = this.colorToString(this.selectedColor);
        }
      } else {
        colorStr = this.colorToString(this.regularColor);
      }

      const drawColor = this.parseColor(colorStr);
      drawColor.alpha = drawColor.alpha * alphaPercent;

      const brush = new drawing.Brush();
      brush.setColor(drawColor);
      brush.setAntiAlias(true);
      this.context.canvas.attachBrush(brush);
      // 绘制圆点，坐标和半径都转换为px
      this.context.canvas.drawCircle(circleCenter.centerX, circleCenter.centerY,
        this.getUIContext().vp2px(circleRadius));
      this.context.canvas.detachBrush();
    }
  }

  // 绘制背景圆环
  drawBackgroundCircles(): void {
    this.selectedDot.forEach((dotIndex: number) => {
      let animationProgress = 1; // 激活圆点背景半径动画进度
      this.bgCircleRadiusStates.forEach((bgCircleRadiusState: BgCircleRadiusState) => {
        if (dotIndex === bgCircleRadiusState.dotIndex) {
          animationProgress = bgCircleRadiusState.getProgress();
        }
      });
      // 激活圆点背景半径，大小由circleRadius -> backgroundCircleRadius
      let circleRadius = this.circleRadius + (this.backgroundCircleRadius - this.circleRadius) * animationProgress;
      const circleCenter = this.getCircleCenter(dotIndex);
      const backgroundColor = this.activateCircleStyle?.color || this.pathColor;
      let colorStr = this.colorToString(backgroundColor);
      const drawColor = this.parseColor(colorStr);
      if (this.currentStatus === InternalStatus.WRONG) {
        drawColor.alpha = drawColor.alpha * this.wrongAnimationState.getAlphaPercent();
      }
      const brush = new drawing.Brush();
      brush.setColor(drawColor);
      brush.setAntiAlias(true);
      this.context.canvas.attachBrush(brush);
      // 绘制激活圆点，坐标和半径都转换为px
      this.context.canvas.drawCircle(circleCenter.centerX, circleCenter.centerY,
        this.getUIContext().vp2px(circleRadius));
      this.context.canvas.detachBrush();
    });
  }

  // 绘制连线
  drawLine(): void {
    if (this.selectedDot.length === 0) {
      return;
    }
    let colorStr: string;
    colorStr = this.colorToString(this.pathColor);

    const drawColor = this.parseColor(colorStr);
    if (this.currentStatus === InternalStatus.WRONG) {
      drawColor.alpha = drawColor.alpha * this.wrongAnimationState.getAlphaPercent();
    }
    const pen = new drawing.Pen();
    pen.setStrokeWidth(this.getUIContext().vp2px(this.pathStrokeWidth));
    pen.setCapStyle(drawing.CapStyle.ROUND_CAP);
    pen.setColor(drawColor);
    pen.setAntiAlias(true);
    this.context.canvas.save();

    const linePath = new drawing.Path();
    let startCenter = this.getCircleCenter(this.selectedDot[0]);
    for (let i = 1; i < this.selectedDot.length; i++) {
      const endCenter = this.getCircleCenter(this.selectedDot[i]);
      // 点与点的连线路径
      linePath.moveTo(startCenter.centerX, startCenter.centerY);
      linePath.lineTo(endCenter.centerX, endCenter.centerY);
      startCenter = endCenter;
    }

    if (this.isInputting) {
      // 从最后一个点到触摸位置的连线路径
      linePath.moveTo(startCenter.centerX, startCenter.centerY);
      linePath.lineTo(this.touchX, this.touchY);
    }

    const circlePath = new drawing.Path();
    this.selectedDot.forEach((dotIndex: number) => {
      let animationProgress = 1; // 激活圆点背景半径动画进度
      this.bgCircleRadiusStates.forEach((bgCircleRadiusState: BgCircleRadiusState) => {
        if (dotIndex === bgCircleRadiusState.dotIndex) {
          animationProgress = bgCircleRadiusState.getProgress();
        }
      });
      // 激活圆点背景半径
      let circleRadius = this.circleRadius + (this.backgroundCircleRadius - this.circleRadius) * animationProgress;
      const circleEnter = this.getCircleCenter(dotIndex);
      circlePath.addCircle(circleEnter.centerX, circleEnter.centerY, this.getUIContext().vp2px(circleRadius));
    });
    this.context.canvas.clipPath(circlePath, drawing.ClipOp.DIFFERENCE, true); // 裁剪掉连线与圆点背景相交的区域

    this.context.canvas.attachPen(pen);
    this.context.canvas.drawPath(linePath);
    this.context.canvas.detachPen();
    this.context.canvas.restore();
  }

  // 绘制波纹效果
  drawWaveEffect(): void {
    // 检查是否启用波纹效果
    const enableWave = this.activateCircleStyle?.enableWaveEffect ?? false;
    if (!enableWave || this.waveStates.length === 0) {
      return;
    }

    // 获取波纹颜色
    let colorStr: string;
    colorStr = this.colorToString(this.activeColor);

    // 绘制每个活动的波纹
    this.waveStates.forEach((wave: WaveState) => {
      const animationProgress = wave.getProgress(); // 波纹动画进度
      const circleCenter = this.getCircleCenter(wave.dotIndex);

      // 计算波纹半径和透明度
      const baseRadius = this.getUIContext().vp2px(this.backgroundCircleRadius);
      const maxRadius = baseRadius * 5;  // 波纹最大扩散到5倍半径
      const currentRadius = baseRadius + (maxRadius - baseRadius) * animationProgress;

      // 透明度从 150 逐渐降到 0
      const alpha = Math.floor(150 * (1 - animationProgress));

      const drawColor = this.parseColor(colorStr);
      drawColor.alpha = alpha;

      // 绘制波纹圆环（使用空心圆）
      const pen = new drawing.Pen();
      pen.setStrokeWidth(this.getUIContext().vp2px(2));  // 波纹线宽2vp
      pen.setColor(drawColor);
      pen.setAntiAlias(true);
      let maskFilter = drawing.MaskFilter.createBlurMaskFilter(drawing.BlurType.NORMAL, vp2px(2));
      pen.setMaskFilter(maskFilter); // 添加蒙板滤镜

      this.context.canvas.attachPen(pen);
      const path = new drawing.Path();
      path.addCircle(circleCenter.centerX, circleCenter.centerY, currentRadius);
      this.context.canvas.drawPath(path);
      this.context.canvas.detachPen();
    });
  }

  // 添加激活圆点背景半径动画效果
  addBgCircleRadiusEffect(dotIndex: number): void {
    // 为当前圆点背景圆环半径添加动画状态
    this.bgCircleRadiusStates.push(new BgCircleRadiusState(dotIndex));

    // 启动背景圆环半径动画定时器
    this.startBgCircleRadiusAnimation();
  }

  // 启动激活圆点背景圆环半径动画
  startBgCircleRadiusAnimation(): void {
    // 如果定时器已经在运行，不重复启动
    if (this.bgCircleRadiusTimer !== -1) {
      return;
    }

    // 使用 setInterval 驱动激活圆点背景圆环半径动画，每 16ms 更新一次（约 60fps）
    this.bgCircleRadiusTimer = setInterval(() => {
      // 触发重绘
      this.redraw();

      // 移除已完成的激活圆点背景圆环半径动画
    this.bgCircleRadiusStates = this.bgCircleRadiusStates.filter(
        (bgCircleRadiusState : BgCircleRadiusState) => !bgCircleRadiusState.isFinished());

      // 如果没有活动的激活圆点背景圆环半径动画，停止动画
      if (this.bgCircleRadiusStates.length === 0) {
        this.stopBgCircleRadiusAnimation();
        return;
      }
    }, 16);
  }

  // 停止激活圆点背景圆环半径动画
  stopBgCircleRadiusAnimation(): void {
    if (this.bgCircleRadiusTimer !== -1) {
      clearInterval(this.bgCircleRadiusTimer);
      this.bgCircleRadiusTimer = -1;
    }
  }

  // 添加波纹效果
  addWaveEffect(dotIndex: number): void {
    const enableWave = this.activateCircleStyle?.enableWaveEffect ?? false;
    if (!enableWave) {
      return;
    }

    // 为当前点添加波纹状态
    this.waveStates.push(new WaveState(dotIndex));

    // 启动波纹动画定时器
    this.startWaveAnimation();
  }

  // 启动波纹动画
  startWaveAnimation(): void {
    // 如果定时器已经在运行，不重复启动
    if (this.waveTimer !== -1) {
      return;
    }

    // 使用 setInterval 驱动波纹动画，每 16ms 更新一次（约 60fps）
    this.waveTimer = setInterval(() => {
      // 触发重绘
      this.redraw();

      // 移除已完成的波纹
      this.waveStates = this.waveStates.filter((wave: WaveState) => !wave.isFinished());

      // 如果没有活动波纹，停止动画
      if (this.waveStates.length === 0) {
        this.stopWaveAnimation();
        return;
      }
    }, 16);
  }

  // 停止波纹动画
  stopWaveAnimation(): void {
    if (this.waveTimer !== -1) {
      clearInterval(this.waveTimer);
      this.waveTimer = -1;
    }
  }

  // 显示密码正确效果
  showCorrect(): void {
    this.currentStatus = InternalStatus.CORRECT;
    this.stopWrongResultAnimation();
    this.redraw();
  }

  // 显示密码错误效果
  showWrong(): void {
    this.currentStatus = InternalStatus.WRONG;
    this.startWrongResultAnimation();
  }

  // 启动密码错误动画
  startWrongResultAnimation(): void {
    // 如果定时器已经在运行，不重复启动
    if (this.wrongResultTimer !== -1) {
      return;
    }
    this.wrongAnimationState = new WrongResultAnimationState();
    // 使用 setInterval 驱动密码错误动画，每 16ms 更新一次（约 60fps）
    this.wrongResultTimer = setInterval(() => {
      // 触发重绘
      this.redraw();

      // 如果动画时间已到，停止动画
      if (this.wrongAnimationState.isFinished()) {
        this.stopWrongResultAnimation();
        return;
      }
    }, 16);
  }

  // 停止密码错误动画
  stopWrongResultAnimation(): void {
    if (this.wrongResultTimer !== -1) {
      clearInterval(this.wrongResultTimer);
      this.wrongResultTimer = -1;
    }
  }

  // 触发密码输入完成回调事件
  triggerPatternComplete(): void {
    if (this.onPatternComplete) {
      this.onPatternComplete(this.selectedDot.slice());
    }
  }

  // 触发圆点连接回调事件
  triggerDotConnect(index: number): void {
    if (this.onDotConnect) {
      this.onDotConnect(index);
    }

    // 触发激活圆点背景圆环半径动画效果
    this.addBgCircleRadiusEffect(index);
    // 触发波纹效果
    this.addWaveEffect(index);
  }

  // 重置
  reset(): void {
    this.selectedDot = [];
    this.isInputting = false;
    this.currentStatus = InternalStatus.NORMAL;
    this.waveStates = [];  // 清空波纹状态
    this.stopWaveAnimation();  // 停止波纹动画
    this.stopWrongResultAnimation();
    this.initCanvas();
  }

  toHex(n: number): string {
    const hex = n.toString(16);
    return hex.length === 1 ? '0' + hex : hex;
  }

  colorToString(color: number | string): string {
    if (typeof color === 'string') {
      return color;
    } else if (typeof color === 'number') {
      const r = (color >> 16) & 0xFF;
      const g = (color >> 8) & 0xFF;
      const b = color & 0xFF;
      return '#' + this.toHex(r) + this.toHex(g) + this.toHex(b);
    }
    return '#000000';
  }

  parseColor(colorStr: string): DrawingColor {
    if (colorStr.startsWith('#')) {
      const hex = colorStr.substring(1);
      if (hex.length === 6) {
        const color: DrawingColor = {
          alpha: 255,
          red: parseInt(hex.substring(0, 2), 16),
          green: parseInt(hex.substring(2, 4), 16),
          blue: parseInt(hex.substring(4, 6), 16)
        };
        return color;
      } else if (hex.length === 8) {
        const color: DrawingColor = {
          alpha: parseInt(hex.substring(0, 2), 16),
          red: parseInt(hex.substring(2, 4), 16),
          green: parseInt(hex.substring(4, 6), 16),
          blue: parseInt(hex.substring(6, 8), 16)
        };
        return color;
      }
    }
    const defaultColor: DrawingColor = { alpha: 255, red: 0, green: 0, blue: 0 };
    return defaultColor;
  }
}
