/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

@Entry
@Component
struct Index {
  private BLACK_WIN: string = 'BLACK WINS!';
  private WHITE_WIN: string = 'WHITE WINS!';
  private BLACK_FIRST: string = 'BLACK FIRST';
  private BLACK_STEP: string = 'BLACK STEP';
  private WHITE_STEP: string = 'WHITE STEP';
  private ALREADY_STEP: string = 'ALREADY STEP';
  private setInfo: RenderingContextSettings = new RenderingContextSettings(true);
  private ctxInfo: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.setInfo);
  private settings: RenderingContextSettings = new RenderingContextSettings(true);
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings);
  private infoAreaWidth: number = 0;
  private infoAreaHeight: number = 0;
  private canvasWidth: number = 0;
  private canvasHeight: number = 0;
  private chessboardMargin: number = 0.05;
  private chessboardPosX: number = 0;
  private chessboardPosY: number = 0;
  private chessboardWidth: number = 0;
  private chessboardHeight: number = 0;
  private chessboardLines: number = 14;
  private chessboardDotInfo: number = 4;
  private chessboardLineWidth: number = 1.5;
  private chessboardDotRadius: number = this.chessboardLineWidth * 3;
  private chessPiecesCount: number = 0;
  private chessPiecesArray: any = null;
  private processRecord: any = null;

  chessPiecesInit(areaWidth, areaHeight): void {
    this.canvasWidth = areaWidth;
    this.canvasHeight = areaHeight;
    this.chessboardPosX = this.canvasWidth * this.chessboardMargin;
    this.chessboardPosY = this.canvasHeight * this.chessboardMargin;
    this.chessboardWidth = this.canvasWidth - this.chessboardPosX * 2;
    this.chessboardHeight = this.canvasHeight - this.chessboardPosY * 2;
    this.processRecord = new Array();
    this.chessPiecesArray = new Array();
    for (let i = 0; i <= this.chessboardLines; ++i) {
      this.chessPiecesArray[i] = new Array();
      for (let j = 0; j <= this.chessboardLines; ++j) {
        // -1 for blank space; 0 for black chess; 1 for white chess
        this.chessPiecesArray[i][j] = -1;
      }
    }
    console.info(`[ArkTSCard] ${this.chessboardWidth} -- ${this.chessboardHeight}`)
  }

  restart(): void {
    console.info('[ArkTSCard] Paint chessboard restart');
    this.chessPiecesCount = 0;
    this.processRecord.length = 0;
    for (let i = 0; i <= this.chessboardLines; ++i) {
      for (let j = 0; j <= this.chessboardLines; ++j) {
        // -1 for blank space; 0 for black chess; 1 for white chess
        this.chessPiecesArray[i][j] = -1;
      }
    }
    this.paintStartInfo();
    this.paintBackground();
    this.paintChessboard();
  }

  fallback(): void {
    console.info(`[ArkTSCard] Fallback ${this.processRecord.length} - ${this.chessPiecesCount}`);
    if (this.chessPiecesCount <= 0) {
      this.paintStartInfo();
      return;
    }
    let prev = this.processRecord.pop();
    this.chessPiecesArray[prev[0]][prev[1]] = -1;
    this.paintBackground();
    this.paintChessboard();
    for (let i = 0; i < this.processRecord.length; ++i) {
      let process = this.processRecord[i];
      this.paintChessPieces(process[0], process[1], i);
    }
    this.chessPiecesCount--;
    this.paintProcess();
  }

  paintBackground(): void {
    console.info('[ArkTSCard] Paint Background');
    this.context.fillStyle = 'rgba(250, 204, 164, 1.00)';
    this.context.fillRect(0, 0, this.canvasWidth, this.canvasHeight);
    this.context.fillStyle = 'rgba(255, 119, 0, 1.00)';
    this.context.fillRect(this.chessboardPosX, this.chessboardPosY, this.chessboardWidth, this.chessboardHeight);
  }

  paintChessboard(): void {
    console.info('[ArkTSCard] Paint Chessboard');
    let widthGap = this.chessboardWidth / this.chessboardLines;
    let heightGap = this.chessboardHeight / this.chessboardLines;
    this.context.beginPath();
    this.context.strokeStyle = '#000000';
    this.context.lineWidth = this.chessboardLineWidth;
    for (let i = 0; i <= this.chessboardLines; ++i) {
      let startPosX = this.chessboardPosX;
      let startPosY = this.chessboardPosY + i * heightGap;
      let endPosX = this.chessboardPosX + this.chessboardWidth;
      let endPosY = this.chessboardPosY + i * heightGap;
      this.context.moveTo(startPosX, startPosY);
      this.context.lineTo(endPosX, endPosY);
      console.info(`[ArkTSCard] Paint ${startPosX} ${startPosY} ${endPosX} ${endPosY}`);
    }
    for (let i = 0; i <= this.chessboardLines; ++i) {
      let startPosX = this.chessboardPosX + i * widthGap;
      let startPosY = this.chessboardPosY;
      let endPosX = this.chessboardPosX + i * widthGap;
      let endPosY = this.chessboardPosY + this.chessboardHeight;
      this.context.moveTo(startPosX, startPosY);
      this.context.lineTo(endPosX, endPosY);
      console.info(`[ArkTSCard] Paint ${startPosX} ${startPosY} ${endPosX} ${endPosY}`);
    }
    this.context.stroke();
    this.context.closePath();

    let dotIndex = this.chessboardLines % this.chessboardDotInfo;
    this.paintChessboardDot(
      this.chessboardPosX + dotIndex * widthGap,
      this.chessboardPosY + dotIndex * heightGap,
      this.chessboardDotRadius, '#000000'
    );
    this.paintChessboardDot(
      this.chessboardPosX + (this.chessboardLines - dotIndex) * widthGap,
      this.chessboardPosY + dotIndex * heightGap,
      this.chessboardDotRadius, '#000000'
    );
    this.paintChessboardDot(
      this.chessboardPosX + dotIndex * widthGap,
      this.chessboardPosY + (this.chessboardLines - dotIndex) * heightGap,
      this.chessboardDotRadius, '#000000'
    );
    this.paintChessboardDot(
      this.chessboardPosX + (this.chessboardLines - dotIndex) * widthGap,
      this.chessboardPosY + (this.chessboardLines - dotIndex) * heightGap,
      this.chessboardDotRadius, '#000000'
    );
  }

  paintChessboardDot(posX, poxY, radius, color): void {
    this.context.beginPath();
    this.context.moveTo(posX - radius, poxY);
    this.context.arc(posX, poxY, radius, 2 * Math.PI, 0, true);
    this.context.strokeStyle = color;
    this.context.closePath();
    this.context.fillStyle = color;
    this.context.fill();
  }

  processClick(posX, posY): void {
    let widthGap = this.chessboardWidth / this.chessboardLines;
    let heightGap = this.chessboardHeight / this.chessboardLines;
    let chessIndexX = Math.round((posX - this.chessboardPosX) / widthGap);
    let chessIndexY = Math.round((posY - this.chessboardPosY) / heightGap);
    chessIndexX = Math.min(chessIndexX, this.chessboardLines);
    chessIndexY = Math.min(chessIndexY, this.chessboardLines);
    if (this.chessPiecesArray[chessIndexX][chessIndexY] != -1) {
      this.paintPrompting();
      return;
    }
    console.info(`[ArkTSCard] Click:[${posX} ${posY}] Put:[${chessIndexX} ${chessIndexY}]`);
    this.chessPiecesArray[chessIndexX][chessIndexY] = this.chessPiecesCount % 2;
    let currentProcess = [chessIndexX, chessIndexY];
    this.processRecord.push(currentProcess);
    this.paintChessPieces(chessIndexX, chessIndexY, this.chessPiecesCount);
    this.chessPiecesCount++;
    this.paintProcess();
    this.checkVictoryDefeat();
  }

  paintChessPieces(chessIndexX, chessIndexY, count): void {
    let widthGap = this.chessboardWidth / this.chessboardLines;
    let heightGap = this.chessboardHeight / this.chessboardLines;
    let drawPosX = chessIndexX * widthGap + this.chessboardPosX;
    let drawPosY = chessIndexY * heightGap + this.chessboardPosY;
    let chessPiecesRadius = Math.min(widthGap, heightGap) / 2;
    let color = count % 2 == 0 ? '#000000' : '#ffffff';
    console.info(`[ArkTSCard] Put:[${chessIndexX} ${chessIndexY}] draw:[${drawPosX} ${drawPosY}]`);
    this.paintChessboardDot(drawPosX, drawPosY, chessPiecesRadius, color);
  }

  dfsCheckCountLW(type, count, indexX, indexY): number {
    let curCount = count;
    if (indexX - 1 >= 0) { // Left
      if (this.chessPiecesArray[indexX - 1][indexY] == type) {
        this.chessPiecesArray[indexX - 1][indexY] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountLW(type, count + 1, indexX - 1, indexY));
      }
    }
    if (indexX + 1 <= this.chessboardLines) { // Write
      if (this.chessPiecesArray[indexX + 1][indexY] == type) {
        this.chessPiecesArray[indexX + 1][indexY] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountLW(type, count + 1, indexX + 1, indexY));
      }
    }
    return curCount;
  }

  dfsCheckCountUD(type, count, indexX, indexY): number {
    let curCount = count;
    if (indexY - 1 >= 0) { // Up
      if (this.chessPiecesArray[indexX][indexY - 1] == type) {
        this.chessPiecesArray[indexX][indexY - 1] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountUD(type, count + 1, indexX, indexY - 1));
      }
    }
    if (indexY + 1 <= this.chessboardLines) { // Down
      if (this.chessPiecesArray[indexX][indexY + 1] == type) {
        this.chessPiecesArray[indexX][indexY + 1] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountUD(type, count + 1, indexX, indexY + 1));
      }
    }
    return curCount
  }

  dfsCheckCountLU(type, count, indexX, indexY): number {
    let curCount = count;
    if (indexX - 1 >= 0 && indexY - 1 >= 0) { // Left & Up
      if (this.chessPiecesArray[indexX - 1][indexY -1] == type) {
        this.chessPiecesArray[indexX - 1][indexY -1] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountLU(type, count + 1, indexX - 1, indexY - 1));
      }
    }
    if (indexX + 1 <= this.chessboardLines && indexY + 1 <= this.chessboardLines) { // Write & Down
      if (this.chessPiecesArray[indexX + 1][indexY + 1] == type) {
        this.chessPiecesArray[indexX + 1][indexY + 1] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountLU(type, count + 1, indexX + 1, indexY + 1));
      }
    }
    return curCount;
  }

  dfsCheckCountWU(type, count, indexX, indexY): number {
    let curCount = count;
    if (indexX + 1 <= this.chessboardLines && indexY - 1 >= 0) { // Write & Up
      if (this.chessPiecesArray[indexX + 1][indexY - 1] == type) {
        this.chessPiecesArray[indexX + 1][indexY - 1] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountWU(type, count + 1, indexX + 1, indexY - 1));
      }
    }
    if (indexX - 1 >= 0 && indexY + 1 <= this.chessboardLines) { // Left & Down
      if (this.chessPiecesArray[indexX - 1][indexY + 1] == type) {
        this.chessPiecesArray[indexX - 1][indexY + 1] = type + 100; // Avoid dead cycle
        curCount = Math.max(curCount, this.dfsCheckCountWU(type, count + 1, indexX - 1, indexY + 1));
      }
    }
    return curCount;
  }

  restoreChessPiecesArray(): void {
    for (let i = 0; i <= this.chessboardLines; ++i) {
      for (let j = 0; j <= this.chessboardLines; ++j) {
        if (this.chessPiecesArray[i][j] >= 10) {
          this.chessPiecesArray[i][j] -= 100;
        }
      }
    }
  }

  dfsCheckCount(type, count, indexX, indexY): number {
    let curCount = count;
    this.chessPiecesArray[indexX][indexY] += 100; // Avoid dead cycle
    curCount = Math.max(curCount, this.dfsCheckCountLW(type, count, indexX, indexY));
    this.restoreChessPiecesArray();
    this.chessPiecesArray[indexX][indexY] += 100; // Avoid dead cycle
    curCount = Math.max(curCount, this.dfsCheckCountUD(type, count, indexX, indexY));
    this.restoreChessPiecesArray();
    this.chessPiecesArray[indexX][indexY] += 100; // Avoid dead cycle
    curCount = Math.max(curCount, this.dfsCheckCountLU(type, count, indexX, indexY));
    this.restoreChessPiecesArray();
    this.chessPiecesArray[indexX][indexY] += 100; // Avoid dead cycle
    curCount = Math.max(curCount, this.dfsCheckCountWU(type, count, indexX, indexY));
    this.restoreChessPiecesArray();
    return curCount;
  }

  checkVictoryDefeat(): void {
    let countWhite = 0;
    let countBlack = 0;
    for (let i = 0; i <= this.chessboardLines; ++i) {
      for (let j = 0; j <= this.chessboardLines; ++j) {
        if (this.chessPiecesArray[i][j] == -1) {
          continue;
        }
        if (this.chessPiecesArray[i][j] == 0) {
          countBlack = Math.max(countBlack, this.dfsCheckCount(0, 1, i, j));
          if (countBlack >= 5) {
            break;
          }
        }
        if (this.chessPiecesArray[i][j] == 1) {
          countWhite = Math.max(countWhite, this.dfsCheckCount(1, 1, i, j));
          if (countWhite >= 5) {
            break;
          }
        }
      }
    }
    for (let i = 0; i <= this.chessboardLines; ++i) {
      for (let j = 0; j <= this.chessboardLines; ++j) {
        if (this.chessPiecesArray[i][j] >= 10) {
          this.chessPiecesArray[i][j] -= 100;
        }
      }
    }
    console.info(`[ArkTSCard] countBlack:[${countBlack}] countWhite:[${countWhite}]`);
    if (countBlack >= 5) {
      this.paintGameOver(0);
    }
    if (countWhite >= 5) {
      this.paintGameOver(1);
    }
  }

  paintPrompting(): void {
    console.info('[ArkTSCard] Paint prompting info');
    this.ctxInfo.fillStyle = 'rgba(207, 186, 170, 1.00)';
    this.ctxInfo.fillRect(0, 0, this.infoAreaWidth, this.infoAreaHeight);
    this.context.textAlign = 'center';
    this.ctxInfo.fillStyle = 'rgba(0, 0, 0, 1.00)';
    this.ctxInfo.font = '30px sans-serif';
    this.ctxInfo.fillText(this.ALREADY_STEP, 0, this.infoAreaHeight / 1.5);
  }

  paintProcess(): void {
    console.info('[ArkTSCard] Paint process info');
    let info = this.BLACK_STEP;
    if (this.chessPiecesCount % 2 == 1) {
      info = this.WHITE_STEP;
    }
    this.ctxInfo.fillStyle = 'rgba(207, 186, 170, 1.00)';
    this.ctxInfo.fillRect(0, 0, this.infoAreaWidth, this.infoAreaHeight);
    this.context.textAlign = 'center';
    this.ctxInfo.fillStyle = 'rgba(0, 0, 0, 1.00)';
    this.ctxInfo.font = '30px sans-serif';
    this.ctxInfo.fillText(info, 0, this.infoAreaHeight / 1.5);
  }

  paintStartInfo(): void {
    console.info('Paint Start info');
    this.ctxInfo.fillStyle = 'rgba(207, 186, 170, 1.00)';
    this.ctxInfo.fillRect(0, 0, this.infoAreaWidth, this.infoAreaHeight);
    this.context.textAlign = 'center';
    this.ctxInfo.fillStyle = 'rgba(0, 0, 0, 1.00)';
    this.ctxInfo.font = '30px sans-serif';
    this.ctxInfo.fillText(this.BLACK_FIRST, 0, this.infoAreaHeight / 1.5);
  }

  paintGameOver(type): void {
    console.info('[ArkTSCard] Paint game over');
    let info = this.BLACK_WIN;
    if (type == 1) {
      info = this.WHITE_WIN;
    }
    this.ctxInfo.fillStyle = 'rgba(207, 186, 170, 1.00)';
    this.ctxInfo.fillRect(0, 0, this.infoAreaWidth, this.infoAreaHeight);
    this.context.textAlign = 'center';
    this.ctxInfo.fillStyle = 'rgba(0, 0, 0, 1.00)';
    this.ctxInfo.font = '30px sans-serif';
    this.ctxInfo.fillText(info, 0, this.infoAreaHeight / 1.5);
  }

  build() {
    Column() {
      Row() {
        Column() {
          Column() {
            Row() {
              Column() {
                Button($r('app.string.res_restart')).width('80%').height('95%')
                  .onClick(() => {
                    this.restart();
                  })
              }.width('30%')

              Column() {
                Canvas(this.ctxInfo)
                  .width('100%')
                  .height('100%')
                  .backgroundColor('#fff5cccc')
                  .onReady(() => {
                    console.info('[ArkTSCard] onReady for canvas draw info');
                    this.infoAreaWidth = Number(this.ctxInfo.width);
                    this.infoAreaHeight = Number(this.ctxInfo.height);
                    this.paintStartInfo();
                  })
              }.width('40%').height('100%')
              .backgroundColor('#fff8c6c6')
              Column() {
                Button($r('app.string.res_fallback')).width('80%').height('95%')
                  .onClick(() => {
                    this.fallback();
                  })
              }.width('30%')
            }
          }.height('10%').width('100%')

          Row() {
            Canvas(this.context)
              .width('100%')
              .height('90%')
              .onReady(() => {
                console.info('[ArkTSCard] onReady for canvas draw content');
                this.chessPiecesInit(this.context.width, this.context.height);
                this.paintBackground();
                this.paintChessboard();
              })
              .onClick((event: ClickEvent) => {
                console.info(`[ArkTSCard] Click: PosX:${event.x} PosX:${event.y}`);
                this.processClick(event.x, event.y);
              })
          }
        }.height('100%').width('100%')
      }.backgroundColor('#ffb0cfcf')
      .height('70%').width('90%')
      .border({ width: 5, color: 0xe3d37c, radius: 10, style: BorderStyle.Solid })
    }
    .borderRadius('3%')
    .width('100%')
    .height('100%')
    .backgroundColor('#AFEEEE')
  }

  aboutToAppear() {
    console.info('[ArkTSCard] aboutToAppear');
  }

  aboutToDisappear() {
    console.info('[ArkTSCard] aboutToDisappear');
  }

  onPageShow() {
    console.info('[ArkTSCard] onPageShow');
  }

  onPageHide() {
    console.info('[ArkTSCard] onPageHide');
  }

  onBackPress() {
    console.info('[ArkTSCard] onBackPress');
  }
}