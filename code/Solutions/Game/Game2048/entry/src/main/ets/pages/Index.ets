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

import display from '@ohos.display'
import Logger from '../model/Logger'
import data_preferences from '@ohos.data.preferences'
import { GameRule } from '../model/GameRule'
import { MyDataSource, screenSizeType, DataType } from '../model/GameModuel';
import { GameStatus, TEXT_COLOR } from '../muck/GameData'

const TAG = '[Game2048]'

@Entry
@Component
struct Game2048 {
  @State dataNumbers: MyDataSource = new MyDataSource([
    new DataType(0, 0), new DataType(1, 0), new DataType(2, 0), new DataType(3, 0),
    new DataType(4, 0), new DataType(5, 0), new DataType(6, 0), new DataType(7, 0),
    new DataType(8, 0), new DataType(9, 0), new DataType(10, 0), new DataType(11, 0),
    new DataType(12, 0), new DataType(13, 0), new DataType(14, 0), new DataType(15, 0)])
  @State gameRule: GameRule = new GameRule(this.dataNumbers['dataArray'])
  @State maxScore: number = 123456
  @State curScore: number = 0
  @State @Watch('onGameOver') gameStatus: number = GameStatus.BEFORE
  dialogController: CustomDialogController = new CustomDialogController({
    builder: ScorePannel({
      curScore: this.curScore,
      maxScore: this.maxScore,
      gameStart: this.gameStart.bind(this)
    }),
    autoCancel: false
  })
  @State screenSize: screenSizeType = { x: px2vp(1080), y: px2vp(0) }

  // gameStatus listener
  onGameOver() {
    if (this.gameStatus === GameStatus.OVER) {
      this.curScore = this.gameRule.score
      this.dialogController.open()
    }
  }

  // restart game
  gameStart() {
    this.gameRule.init()
    this.gameRule.dataNumbers.forEach((item, index) => {
      this.dataNumbers['dataArray'][index].data = item;
    })
    this.gameStatus = GameStatus.RUNNING
    this.handleLocalData('put')
  }

  // dataView
  dataView() {
    this.gameRule.dataNumbers.forEach((item, index) => {
      this.dataNumbers['dataArray'][index].data = item;
    })
    this.gameStatus = this.gameRule.status
    this.curScore = this.gameRule.score
  }

  aboutToAppear() {
    display.getDefaultDisplay((err, data) => {
      if (data.height > data.width) {
        this.screenSize = { x: px2vp(data.width), y: px2vp(data.height) }
      } else {
        this.screenSize = { x: px2vp(750), y: px2vp(data.width) }
      }
      Logger.info(TAG, `宽 ${this.screenSize.x}`)
      Logger.info(TAG, `高 ${this.screenSize.y}`)
    })
    this.handleLocalData('has')
  }

  // handle local data
  async handleLocalData(method: string) {
    let context = getContext(this)
    let preferences = await data_preferences.getPreferences(context, 'mystore')
    if (this.gameRule.score === undefined || this.gameRule.status === undefined || this.gameRule.dataNumbers === undefined) {
      return
    }
    if (method === 'put') {
      await preferences.put('gameData', JSON.stringify(this.dataNumbers))
      let score: string = this.gameRule.score.toString()
      await preferences.put('score', score)
      await preferences.put('gameStatus', this.gameRule.status.toString())
      await preferences.flush()
    } else if (method === 'has') {
      if (await preferences.has('gameData')) {
        this.gameRule.score = this.curScore = Number(await preferences.get('score', 'string'))
        this.gameStatus = this.gameRule.status = Number(await preferences.get('gameStatus', 'string'))
        let tempData: MyDataSource = JSON.parse(await preferences.get('gameData', 'string') as string);
        tempData['dataArray'].forEach((item: DataType, index: number) => {
          this.gameRule.dataNumbers[index] = item.data;
          this.dataNumbers['dataArray'][index].data = item.data;
        })
      }
    }
  }

  build() {
    Column() {
      Column() {
        Row() {
          Image($r('app.media.logo2048'))
            .id('logo2048')
            .width(this.screenSize.x * 0.25)
            .height(this.screenSize.x * 0.25)

          Column() {
            Text('Score')
              .fontSize('30px')
              .fontColor($r('app.color.text_color'))
              .fontWeight(FontWeight.Bolder)

            Text(`${this.gameRule.score}`)
              .fontSize('30px')
              .fontColor($r('app.color.score_color'))
              .fontWeight(FontWeight.Bolder)
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.top_color'))
          .width(this.screenSize.x * 0.25)
          .height(this.screenSize.x * 0.25)
          .borderRadius(15)

          Column() {
            Text('Max')
              .fontSize('50px')
              .fontColor($r('app.color.text_color'))
              .fontWeight(FontWeight.Bolder)

            Text(`${this.maxScore}`)
              .fontSize('30px')
              .fontColor($r('app.color.score_color'))
              .fontWeight(FontWeight.Bolder)
          }
          .alignItems(HorizontalAlign.Center)
          .justifyContent(FlexAlign.Center)
          .backgroundColor($r('app.color.top_color'))
          .width(this.screenSize.x * 0.25)
          .height(this.screenSize.x * 0.25)
          .borderRadius(15)
        }
        .alignItems(VerticalAlign.Center)
        .justifyContent(FlexAlign.SpaceAround)
        .margin({ bottom: 20 })
        .width(this.screenSize.x)

        Grid() {
          LazyForEach(this.dataNumbers, (item) => {
            GridItem() {
              MyGridItem({ gridData: item })
            }
          }, (item: DataType) => item.id.toString())
        }
        .columnsTemplate('1fr 1fr 1fr 1fr')
        .rowsTemplate('1fr 1fr 1fr 1fr')
        .columnsGap(10)
        .rowsGap(10)
        .width(this.screenSize.x)
        .padding(10)
        .backgroundColor('rgba(80,69,46,0.26)')
        .height(this.screenSize.x)
        .borderRadius(10)
        .gesture(GestureGroup(GestureMode.Exclusive,
        PanGesture({ direction: PanDirection.Left }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('left')
          this.dataView()
          this.handleLocalData('put')
        }),
        PanGesture({ direction: PanDirection.Right }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('right')
          this.dataView()
          this.handleLocalData('put')
        }),
        PanGesture({ direction: PanDirection.Up }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('up')
          this.dataView()
          this.handleLocalData('put')
        }),
        PanGesture({ direction: PanDirection.Down }).onActionEnd(() => {
          this.gameRule.status === 1 && this.gameRule.move('down')
          this.dataView()
          this.handleLocalData('put')
        })
        ))

        if (this.gameStatus === -1) {
          Button('Start', { type: ButtonType.Normal })
            .borderRadius(5)
            .margin({ top: 50 })
            .width(200)
            .id('startGame')
            .onClick(() => {
              this.gameStart()
            })
        }
      }
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height('100%')
      .width('100%')
    }
    .alignItems(HorizontalAlign.Center)
    .justifyContent(FlexAlign.Start)
    .width('100%')
    .height('100%')
    .backgroundImage($r('app.media.gridBackground'))
    .backgroundImageSize(ImageSize.Cover)
  }
}

@Component
struct MyGridItem {
  @ObjectLink gridData: DataType

  build() {
    Text(`${this.gridData.data === 0 ? '' : this.gridData.data}`)
      .fontSize(30)
      .fontColor(this.gridData.data <= 4 ? '#000' : $r('app.color.score_color'))
      .fontWeight(FontWeight.Bolder)
      .width('100%')
      .height('100%')
      .textAlign(TextAlign.Center)
      .borderRadius(10)
      .backgroundColor(this.gridData.data === 0 ? $r('app.color.item_bg'): TEXT_COLOR[(Math.log(this.gridData.data) / Math.log(2))])
  }
}

@CustomDialog
struct ScorePannel {
  controller: CustomDialogController
  gameStart: () => void
  curScore: number
  maxScore: number

  build() {
    Column() {
      Text('Game Over')
        .fontSize(30)
        .fontWeight(FontWeight.Medium)
        .margin({ top: 10 })

      Text('Score')
        .fontColor($r('app.color.title_color'))
        .fontSize(20)
        .margin({ top: 10 })

      Text(`${this.curScore}`)
        .fontColor($r('app.color.cur_score_color'))
        .fontSize(40)
        .margin({ top: 10 })

      Text(`maxScore:${this.maxScore}`)
        .fontSize(20)
        .width('90%')
        .borderRadius(20)
        .margin({ top: 10 })
        .height(40)
        .textAlign(TextAlign.Center)

      Row() {
        Button('Reset', { type: ButtonType.Normal })
          .borderRadius(5)
          .margin({ top: 10 })
          .width(200)
          .onClick(() => {
            this.gameStart()
            this.controller.close()
          })
      }
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ top: 10, bottom: 10 })
    }
    .backgroundColor($r('app.color.index_bg'))
    .borderRadius(25)
  }
}