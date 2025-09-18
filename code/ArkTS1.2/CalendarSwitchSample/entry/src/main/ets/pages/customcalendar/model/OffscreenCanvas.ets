/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import {
  CanvasRenderingContext2D,
  OffscreenCanvasRenderingContext2D,
  RenderingContextSettings
} from '@ohos.arkui.component';

/**
 * 离屏画布类
 */
export class OffscreenCanvas {
  public settings: RenderingContextSettings = new RenderingContextSettings(true);
  public context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  // OffscreenCanvasRenderingContext2D入参分别是离屏画布的宽度，离屏画布的高度，用来配置OffscreenCanvasRenderingContext2D对象的参数
  public offContext: OffscreenCanvasRenderingContext2D = new OffscreenCanvasRenderingContext2D(200, 200, this.settings);
  public year: number;
  public month: number;

  constructor(year: number, month: number) {
    this.year = year;
    this.month = month;
  }
}