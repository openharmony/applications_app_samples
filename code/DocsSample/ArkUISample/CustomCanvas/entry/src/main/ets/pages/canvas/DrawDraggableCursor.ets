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
// [Start cursor_moving_canvas]
@Entry
@Component
struct CursorMoving {
  // 监听是否按下，刷新光标颜色
  @State @Watch('drawCursor') isTouchDown: boolean = false;
  // 监听位置变化，刷新页面
  @State @Watch('drawCursor') cursorPosition: RectPosition = {
    x: 0,
    y: 0,
    width: 0,
    height: 0,
  };
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private canvasContext: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private sw: number = 360; // Canvas固定宽度
  private sh: number = 270; // Canvas固定高度
  private cursorWH: number = 50; // 光标区域宽高
  private dashedLineW: number = 7; // 光标宽高
  private arcRadius: number = 6; // 光标中心圆半径
  private isReadyMove: boolean = false;
  private touchPosition: Position = {
    x: 0,
    y: 0,
  };
  private cursorCenterPosition: Position = {
    x: 0,
    y: 0,
  };

  build() {
    Column() {
      // 绘制光标
      Canvas(this.canvasContext)
        .width(this.sw)
        .height(this.sh)
        .backgroundColor('#D5D5D5')
        .onReady(() => {
          this.cursorPosition.x = (this.sw - this.cursorWH) / 2;
          this.cursorPosition.y = (this.sh - this.cursorWH) / 2;
          this.cursorPosition.width = this.cursorWH;
          this.cursorPosition.height = this.cursorWH;
          this.cursorCenterPosition = {
            x: this.cursorPosition.x + this.cursorPosition.width / 2,
            y: this.cursorPosition.y + this.cursorPosition.height / 2
          };
          this.drawCursor();
        })
        .onTouch(event => {
          if (event.type === TouchType.Down) {
            this.isReadyMove = this.isTouchCursorArea(event.touches[0]);
            if (this.isReadyMove) {
              this.isTouchDown = true;
            }

            this.touchPosition = {
              x: event.touches[0].displayX,
              y: event.touches[0].displayY
            };
          } else if (event.type === TouchType.Move) {
            if (this.isReadyMove) {
              let moveX = event.changedTouches[0].displayX - this.touchPosition.x;
              let moveY = event.changedTouches[0].displayY - this.touchPosition.y;
              this.touchPosition = {
                x: event.changedTouches[0].displayX,
                y: event.changedTouches[0].displayY
              };
              this.cursorPosition.x += moveX;
              this.cursorPosition.y += moveY;

              this.cursorCenterPosition = {
                x: this.cursorPosition.x + this.cursorPosition.width / 2,
                y: this.cursorPosition.y + this.cursorPosition.height / 2
              };
              // 光标区域中心点位置限制
              if (this.cursorCenterPosition.x < 0) {
                this.cursorPosition.x = -this.cursorPosition.width / 2;
              }
              if (this.cursorCenterPosition.y < 0) {
                this.cursorPosition.y = -this.cursorPosition.height / 2;
              }
              if (this.cursorCenterPosition.x > this.sw) {
                this.cursorPosition.x = this.sw - this.cursorPosition.width / 2;
              }
              if (this.cursorCenterPosition.y > this.sh) {
                this.cursorPosition.y = this.sh - this.cursorPosition.height / 2;
              }
            }
          } else {
            this.isTouchDown = false;
          }
        });
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }

  // 绘制裁剪框
  drawCursor() {
    // 算出菱形四个点
    let positionL: Position = { x: this.cursorPosition.x, y: this.cursorPosition.y + this.cursorPosition.height / 2 };
    let positionT: Position = { x: this.cursorPosition.x + this.cursorPosition.width / 2, y: this.cursorPosition.y };
    let positionR: Position = {
      x: this.cursorPosition.x + this.cursorPosition.width,
      y: this.cursorPosition.y + this.cursorPosition.height / 2
    };
    let positionB: Position = {
      x: this.cursorPosition.x + this.cursorPosition.width / 2,
      y: this.cursorPosition.y + this.cursorPosition.height
    };
    let lineWidth = 2;
    this.canvasContext.clearRect(0, 0, this.sw, this.sh);
    this.canvasContext.lineWidth = lineWidth;
    this.canvasContext.strokeStyle = this.isTouchDown ? '#ff1a5cae' : '#ffffffff';

    // 画出四角
    this.canvasContext.beginPath();
    this.canvasContext.moveTo(positionL.x + this.dashedLineW, positionL.y - this.dashedLineW);
    this.canvasContext.lineTo(positionL.x, positionL.y);
    this.canvasContext.lineTo(positionL.x + this.dashedLineW, positionL.y + this.dashedLineW);

    this.canvasContext.moveTo(positionT.x - this.dashedLineW, positionT.y + this.dashedLineW);
    this.canvasContext.lineTo(positionT.x, positionT.y);
    this.canvasContext.lineTo(positionT.x + this.dashedLineW, positionT.y + this.dashedLineW);

    this.canvasContext.moveTo(positionR.x - this.dashedLineW, positionR.y - this.dashedLineW);
    this.canvasContext.lineTo(positionR.x, positionR.y);
    this.canvasContext.lineTo(positionR.x - this.dashedLineW, positionR.y + this.dashedLineW);

    this.canvasContext.moveTo(positionB.x - this.dashedLineW, positionB.y - this.dashedLineW);
    this.canvasContext.lineTo(positionB.x, positionB.y);
    this.canvasContext.lineTo(positionB.x + this.dashedLineW, positionB.y - this.dashedLineW);

    this.canvasContext.stroke();

    // 画出中心圆
    this.canvasContext.beginPath();
    this.canvasContext.strokeStyle = this.isTouchDown ? '#ff1a5cae' : '#ff9ba59b';
    this.canvasContext.fillStyle = this.isTouchDown ? '#ff1a5cae' : '#ff9ba59b';
    this.canvasContext.arc(this.cursorPosition.x + this.cursorPosition.width / 2,
      this.cursorPosition.y + this.cursorPosition.width / 2, this.arcRadius, 0, 2 * Math.PI);
    this.canvasContext.fill();
    this.canvasContext.stroke();

    // 画出四条线
    this.canvasContext.beginPath();
    this.canvasContext.lineWidth = 0.7;
    this.canvasContext.moveTo(positionL.x, positionL.y);
    this.canvasContext.lineTo(0, positionL.y);

    this.canvasContext.moveTo(positionT.x, positionT.y);
    this.canvasContext.lineTo(positionT.x, 0);

    this.canvasContext.moveTo(positionR.x, positionR.y);
    this.canvasContext.lineTo(this.sw, positionR.y);

    this.canvasContext.moveTo(positionB.x, positionB.y);
    this.canvasContext.lineTo(positionB.x, this.sh);

    this.canvasContext.stroke();
  }

  // 判断点击位置是否在棱形中
  isTouchCursorArea(touch: TouchObject) {
    let tempLength = Math.sqrt((touch.x - this.cursorCenterPosition.x) * (touch.x - this.cursorCenterPosition.x) +
      (touch.y - this.cursorCenterPosition.y) * (touch.y - this.cursorCenterPosition.y));
    if (tempLength < (this.cursorWH / 2 / 1.414)) {
      return true;
    }
    return false;
  }
}

export interface RectPosition {
  x: number;
  y: number;
  height: number;
  width: number;
};

export interface Position {
  x: number;
  y: number;
};
// [End cursor_moving_canvas]