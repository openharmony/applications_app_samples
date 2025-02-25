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

import { AnimatorResult, curves, Animator } from '@kit.ArkUI';
import { logger } from '../common/util/Logger';
import { BreakpointConstants } from '../common/constants/BreakpointConstants';

/**
 * 扫描线动画参数
 */
@Extend(Image)
function imageAnimation(speed: number, linePosition: number, allAngle: number) {
  .position({ x: 0, y: -0.5 })
  .width('100%')
  .height(130)
  .scale({ y: Math.max(speed, 0.007) })
  .position({
    x: 0,
    y: linePosition + '%'
  })
  .rotate({
    x: 1,
    angle: allAngle,
    centerX: 0,
    centerY: 0
  })
}

/**
 * 二维码扫描线动画
 */
@Component
export struct ScanLine {
  @StorageLink('currentBreakpoint') currentBreakpoint: string = BreakpointConstants.BREAKPOINT_SM;
  @State linePosition: number = 0;
  @State allAngle: number = 180;
  @State lightFactor: number = 0.075;
  @State factor: number = 0.025;
  @State reverse: boolean = false;
  @State speed: number = 0.0;
  @State mNowMaxLight: number = 0.0;
  @State matrix: number[] =
    [1.0, this.lightFactor, this.lightFactor, this.lightFactor, 0.0, this.lightFactor, this.lightFactor + 1.0,
      this.lightFactor, this.lightFactor, 0.0, this.lightFactor, this.lightFactor, this.lightFactor + 1.0,
      this.lightFactor, 0.0, 0.0, 0.0, 0.0, 1.0, 0.0];
  /**
   * 是否展示动画
   */
  @State isScanMotion: boolean = true;
  private particlePropertyAnimationDown: ParticlePropertyAnimation<number> = {
    from: 0,
    to: 0.5,
    startMillis: 0,
    endMillis: 200,
    curve: Curve.Smooth
  }
  private particlePropertyAnimationUp: ParticlePropertyAnimation<number> = {
    from: 0.5,
    to: 0,
    startMillis: 300,
    endMillis: 500,
    curve: Curve.Smooth
  }
  private emitterOptions: EmitterOptions<ParticleType.POINT> = {
    particle: {
      type: ParticleType.POINT,
      config: {
        radius: 2
      },
      count: -1,
      lifetime: 500
    },
    size: ['100%', '100%'],
    emitRate: 60,
    shape: ParticleEmitterShape.RECTANGLE
  }
  private backAnimator: AnimatorResult | undefined = Animator.create({
    duration: 2000,
    easing: 'smooth',
    delay: 0,
    fill: 'none',
    direction: 'alternate',
    iterations: -1,
    begin: 0,
    end: 100
  }); // 扫描动画

  async backAnimatorCreate(): Promise<void> {
    if (this.backAnimator) {
      this.backAnimator.onRepeat = () => {
        this.reverse = !this.reverse;
        if (this.reverse) {
          this.allAngle = 0;
        } else {
          this.allAngle = 180;
        }
      }
      this.backAnimator.onCancel = () => {
        this.isScanMotion = false;
      }
      this.backAnimator.onFrame = (value) => {

        if (!this.isScanMotion) {
          this.isScanMotion = true;
        }
        value = value / 100;

        if (value < 0.389) {
          this.speed = curves.cubicBezierCurve(0.4, 0.0, 0.7, 1.0).interpolate(value / 0.389);
        } else {
          this.speed = 1.0 - curves.cubicBezierCurve(0.25, 0.0, 0.4, 1.0).interpolate((value - 0.389) / 0.611);
        }
        this.linePosition = 100 * value;
      }
    }
  }

  async aboutToAppear() {
    try {
      await this.backAnimatorCreate();
      if (this.backAnimator) {
        this.backAnimator.play();
      }
    } catch (error) {
      logger.error( `Failed to play backAnimator. Code: ${error.code}`);
    }
  }

  aboutToDisappear() {
    if (this.backAnimator) {
      this.backAnimator.cancel();
    }
    this.backAnimator = undefined;
  }

  build() {
    Stack() {
      Image($rawfile('scan_line.png')).width('100%').height(2)
        .position({
          x: 0,
          y: this.linePosition + '%'
        })
      Image($rawfile('scan_shadow.png'))
        .imageAnimation(this.speed, this.linePosition, this.allAngle)

      Particle({
        particles: [
          {
            emitter: this.emitterOptions,
            scale: {
              range: [0.4, 1.1],
              updater: {
                type: ParticleUpdater.RANDOM,
                config: [
                  0.4, 1.1
                ]
              }
            },
            color: {
              range: ['#0A8BF5', '#FFFFFF']
            },
            opacity: {
              range: [0, 0.5],
              updater: {
                type: ParticleUpdater.CURVE,
                config: [
                  this.particlePropertyAnimationDown,
                  this.particlePropertyAnimationUp
                ]
              }
            }
          }
        ]
      }).width('80%')
        .height('100%')
        .markAnchor({ y: this.allAngle == 180 ? (60 * this.speed) : 0 })
        .maskShape(new Rect({ width: '100%', height: 60 * (this.speed) })
          .position({ y: this.linePosition + '%' })
          .fill(Color.White))
    }
    .width(this.currentBreakpoint === BreakpointConstants.BREAKPOINT_SM ? '100%' : '50%')
    .height('100%')
  }
}