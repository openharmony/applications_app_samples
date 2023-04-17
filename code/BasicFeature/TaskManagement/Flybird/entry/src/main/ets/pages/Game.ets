/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import usageStatistics from '@ohos.resourceschedule.usageStatistics';
import Logger from '../model/Logger'

const TAG = "Game"

@Entry
@Component
struct Game {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private canvasRendering: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private isInit: boolean = false;
  private bgOne: ImageBitmap = new ImageBitmap("/common/pic/bgOne.png")
  private pipeNorthOne: ImageBitmap = new ImageBitmap("/common/pic/pipeNorthOne.png")
  private pipeSouthOne: ImageBitmap = new ImageBitmap("/common/pic/pipeSouthOne.png")
  private fgOne: ImageBitmap = new ImageBitmap("/common/pic/fgOne.png")
  private bgTwo: ImageBitmap = new ImageBitmap("/common/pic/bgTwo.png")
  private pipeNorthTwo: ImageBitmap = new ImageBitmap("/common/pic/pipeNorthTwo.png")
  private pipeSouthTwo: ImageBitmap = new ImageBitmap("/common/pic/pipeSouthTwo.png")
  private fgTwo: ImageBitmap = new ImageBitmap("/common/pic/fgTwo.png")
  private bgThree: ImageBitmap = new ImageBitmap("/common/pic/bgThree.png")
  private pipeNorthThree: ImageBitmap = new ImageBitmap("/common/pic/pipeNorthThree.png")
  private pipeSouthThree: ImageBitmap = new ImageBitmap("/common/pic/pipeSouthThree.png")
  private fgThree: ImageBitmap = new ImageBitmap("/common/pic/fgThree.png")
  private bgFour: ImageBitmap = new ImageBitmap("/common/pic/bgFour.png")
  private pipeNorthFour: ImageBitmap = new ImageBitmap("/common/pic/pipeNorthFour.png")
  private pipeSouthFour: ImageBitmap = new ImageBitmap("/common/pic/pipeSouthFour.png")
  private fgFour: ImageBitmap = new ImageBitmap("/common/pic/fgFour.png")
  private bgFive: ImageBitmap = new ImageBitmap("/common/pic/bgFive.png")
  private pipeNorthFive: ImageBitmap = new ImageBitmap("/common/pic/pipeNorthFive.png")
  private pipeSouthFive: ImageBitmap = new ImageBitmap("/common/pic/pipeSouthFive.png")
  private fgFive: ImageBitmap = new ImageBitmap("/common/pic/fgFive.png")
  private bird: ImageBitmap = new ImageBitmap("/common/pic/bird.png")
  private sleep: number = 90;
  private timeId: number = -1
  @State gap: number = 105;
  @State constant: number = 0;
  @State score: number = 0;
  @State drawAreaX: number = 10 // 绘制区域左上角在x轴的位置
  @State drawAreaY: number = 150 // 绘制区域左上角在y轴的位置
  @State gravity: number = 2;
  @State pipe: any [] = [];
  @State birdHeigth: number = 26;
  @State birdWidth: number = 38;
  @State pipeNorthHeight: number = 242;
  @State pipeNorthWidth: number = 52;
  @State cvsHeigth: number = 512;
  @State cvsWidth: number = 288;
  @State fgHeight: number = 160;
  @State fgWidth: number = 306;
  @State scoreTemp: number = 0;
  @State beginTime: number = 0;
  @State endTime: number = 200000000000000;
  @State historyTime: number = 0;
  @State pipeLength: number = 125;
  @State isChange: boolean = false;
  draw = () => {
    if (router.getParams() && router.getParams()['id']) {
      let id = router.getParams()['id']
      let fg
      let pipeNorth
      let pipeSouth
      let bg
      switch (id) {
        case 1:
          fg = this.bgOne
          pipeNorth = this.pipeNorthOne
          pipeSouth = this.pipeSouthOne
          bg = this.bgOne
          break
        case 2:
          fg = this.bgTwo
          pipeNorth = this.pipeNorthTwo
          pipeSouth = this.pipeSouthTwo
          bg = this.bgTwo
          this.sleep = 70
          break
        case 3:
          fg = this.bgThree
          pipeNorth = this.pipeNorthThree
          pipeSouth = this.pipeSouthThree
          bg = this.bgThree
          this.sleep = 50
          break
        case 4:
          fg = this.bgFour
          pipeNorth = this.pipeNorthFour
          pipeSouth = this.pipeSouthFour
          bg = this.bgFour
          this.sleep = 30
          break
        case 5:
          fg = this.bgFive
          pipeNorth = this.pipeNorthFive
          pipeSouth = this.pipeSouthFive
          bg = this.bgFive
          this.sleep = 10
          break
        default:
          break
      }
      this.realDraw(fg, pipeNorth, pipeSouth, bg);
    }
  }

  realDraw(fg: ImageBitmap, pipeNorth: ImageBitmap, pipeSouth: ImageBitmap, bg: ImageBitmap) {
    let ctx = this.canvasRendering;
    ctx.clearRect(0, 0, this.cvsWidth, this.cvsHeigth);
    ctx.drawImage(bg, 0, 0, this.cvsWidth, this.cvsHeigth);
    this.drawPipe(ctx, fg, pipeNorth, pipeSouth);

    ctx.drawImage(fg, 0, this.cvsHeigth - this.fgHeight, this.fgWidth, this.fgHeight);
    ctx.drawImage(this.bird, this.drawAreaX, this.drawAreaY, this.birdWidth, this.birdHeigth);
    this.drawAreaY += this.gravity;
    ctx.fillStyle = "#000";
    ctx.font = "20px Verdana";

    if (this.scoreTemp >= this.score) {
      this.scoreTemp = this.scoreTemp
    } else {
      this.scoreTemp = this.score;
    }
    ctx.fillText(`History Highest Score : ${this.scoreTemp}`, 10, this.cvsHeigth - 50);
    ctx.fillText(`Score : ${this.score}`, 10, this.cvsHeigth - 30);
    if (this.historyTime !== 0) {
      let min = parseInt((this.historyTime / 1000 / 60).toString(), 10);
      let sec = parseInt(((this.historyTime - min * 1000 * 60) / 1000).toString(), 10);
      ctx.fillText(`historyTime : ${min} min ${sec} s`, 10, this.cvsHeigth - 10);
    }
    else {
      ctx.fillText(`historyTime : 0 min 0 s`, 10, this.cvsHeigth - 10);
    }
    if (this.timeId !== -1) {
      this.timeId = setTimeout(this.draw, this.sleep);
    }
  }

  drawPipe(ctx: CanvasRenderingContext2D, fg: ImageBitmap, pipeNorth: ImageBitmap, pipeSouth: ImageBitmap) {
    for (let i = 0; i < this.pipe.length; i++) {
      this.constant = this.pipeNorthHeight + this.gap;
      ctx.drawImage(pipeNorth, this.pipe[i].x, this.pipe[i].y, this.pipeNorthWidth, this.pipeNorthHeight);
      ctx.drawImage(pipeSouth, this.pipe[i].x, this.pipe[i].y + this.constant, this.pipeNorthWidth, this.pipeNorthHeight);
      this.pipe[i].x--;
      if (this.pipe[i].x === this.pipeLength) {
        this.pipe.push(
          {
            x: this.cvsWidth,
            y: Math.floor(Math.random() * this.pipeNorthHeight) - this.pipeNorthHeight + 5,
          }
        )
      }
      if (this.drawAreaX + this.birdWidth >= this.pipe[i].x
      && this.drawAreaX <= this.pipe[i].x + this.pipeNorthWidth
      && (this.drawAreaY <= this.pipe[i].y + this.pipeNorthHeight
      || this.drawAreaY + this.birdHeigth >= this.pipe[i].y + this.constant)
      || this.drawAreaY + this.birdHeigth >= this.cvsHeigth - this.fgHeight) {
        this.showDialog();
        ctx.drawImage(fg, 0, this.cvsHeigth - this.fgHeight, this.fgWidth, this.fgHeight);
        ctx.drawImage(this.bird, this.drawAreaX, this.drawAreaY, this.birdWidth, this.birdHeigth);
        ctx.fillText(`History Highest Score : ${this.scoreTemp}`, 10, this.cvsHeigth - 50);
        ctx.fillText(`Score : ${this.score}`, 10, this.cvsHeigth - 30);
        if (this.historyTime !== 0) {
          let min = parseInt((this.historyTime / 1000 / 60).toString(), 10);
          let sec = parseInt(((this.historyTime - min * 1000 * 60) / 1000).toString(), 10);
          ctx.fillText(`historyTime : ${min} min ${sec} s`, 10, this.cvsHeigth - 10);
        } else {
          ctx.fillText(`historyTime : 0 min 0 s`, 10, this.cvsHeigth - 10);
        }
        this.restart();
        clearTimeout(this.timeId);
        this.timeId = -1
      }
      if (this.pipe[i] && this.pipe[i].x) {
        if (this.pipe[i].x === 5) {
          this.score++;
        }
      }
      if (this.pipe.length % 4 === 0) {
        this.pipe.shift();
      }
    }
  }

  showDialog() {
    AlertDialog.show({
      message: 'over',
      primaryButton: {
        value: $r('app.string.refresh'),
        action: () => {
          this.restart();
          this.timeId = setTimeout(this.draw, this.sleep);
        }
      },
      secondaryButton: {
        value: $r('app.string.back'),
        action: () => {
          router.back()
        }
      },
      cancel: () => {
        this.restart();
        this.timeId = setTimeout(this.draw, this.sleep);
      }
    })
  }

  restart() {
    this.pipe = [];
    this.pipe[0] = {
      x: this.cvsWidth,
      y: 0
    };
    this.constant = 0;
    this.score = 0;
    this.drawAreaY = 150;
  }

  moveUp() {
    this.drawAreaY -= 20;
  }

  onBackPress() {
    this.isChange = true;
    router.back();
    return true;
  }

  showHistoryScore() {
    usageStatistics.queryBundleStatsInfos(Number(this.beginTime), Number(this.endTime), (err, res) => {
      if (err) {
        Logger.info(TAG, `queryBundleStateInfos1 callback failed,because: ${err.code}`)
      }
      else {
        Logger.info(TAG, `queryBundleStateInfos1 callback success.`);
        let count = 1;
        for (let key in res) {
          Logger.info(TAG, `queryBundleStateInfos1 callback i : ${count}`);
          Logger.info(TAG, `queryBundleStateInfos1 callback result : ${JSON.stringify(res[key])}`)
          if (res[key].bundleName.includes('flybird')) {
            this.historyTime = res[key].abilityInFgTotalTime;
          }
          count++;
        }
      }
    })
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Canvas(this.canvasRendering)
        .width(280)
        .height(512)
        .onReady(() => {
          Logger.info(TAG, 'onReady');
          let id = router.getParams() // 获取关卡id
          Logger.info(TAG, `prams id ${id} ${id['id']}`);
          this.pipe[0] = {
            x: this.cvsWidth,
            y: 0,
          }
          this.showHistoryScore();
          this.timeId = setTimeout(this.draw, this.sleep);
        })
        .onClick((event: ClickEvent) => {
          this.moveUp()
        })
    }
    .width('100%')
    .height('100%')
  }
}