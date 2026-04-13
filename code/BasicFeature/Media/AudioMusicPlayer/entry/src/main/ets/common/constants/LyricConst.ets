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
 * Lyrics scrolling effect.
 */
export const enum LyricScrollEffect {
  /**
   * Full line scrolling
   */
  Line,

  /**
   * Gradient Color
   */
  LetterGradient,

  /**
   * Single character scaling and gradation.
   */
  LetterScaleGradient,

  /**
   * Star scrolling style.
   */
  LetterStar
}

/**
 * Lyrics initial position
 */
export const enum LyricTopPosition {
  Top,
  Middle
}

export class LyricFile {
  static readonly KRC: string = '.krc';
  static readonly LRC: string = '.lrc';
}

export class Rectangle {
  left: number = 0;
  top: number = 0;
  right: number = 0;
  bottom: number = 0;

  constructor(left: number, top: number, right: number, bottom: number) {
    if (left > right || top > bottom) {
      return;
    }
    this.left = left;
    this.top = top;
    this.right = right;
    this.bottom = bottom;
  }

  public isIn(x: number, y: number) {
    return x >= this.left && x <= this.right && y >= this.top && y <= this.bottom;
  }

  toString() {
    return `[Rectangle] = ${this.left}, ${this.top}, ${this.right},${this.bottom}`;
  }
}