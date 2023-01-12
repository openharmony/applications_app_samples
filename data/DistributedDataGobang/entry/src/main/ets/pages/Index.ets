/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import Logger from '../util/Logger'
import { GobangConst } from '../util/GobangConst'
import { TitleBar } from './TitleBar'
import { KvStoreModel } from '../Model/KvStoreModel'
import { RemoteDeviceModel } from '../Model/RemoteDeviceModel'
import { DistributedDataModel } from '../Model/DistributedDataModel'

const TAG: string = 'Index'

@Entry
@Component
struct Index {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private remoteDeviceModel: RemoteDeviceModel = new RemoteDeviceModel()
  private kvStoreModel: KvStoreModel = new KvStoreModel()
  private totalText = ''
  private winText = ''
  private roundText = ''
  private blackChessText = ''
  private whiteChessText = ''
  @State chessMapArr: Array<Array<string>> = []
  @State screenWidth: number = GobangConst.WIDTH
  @State screenHeight: number = GobangConst.HEIGHT
  @State dpiBi: number = vp2px(this.screenWidth) / this.screenWidth
  @State chessSize: number = this.screenWidth / this.dpiBi / GobangConst.SIZE
  @State isDistributed: boolean = false
  @State dialogShow: boolean = false
  @State isFall: boolean = false
  @State isFlush: boolean = false
  @State isRetract: boolean = false
  @State isClick: boolean = true
  @State countOnReady: number = 1
  @State @Watch('dataChange') distributedData: DistributedDataModel = new DistributedDataModel(false)
  @StorageLink('deviceFlag') deviceFlag: string = 'A'

  dataChange() {
    if (this.deviceFlag !== 'A') {
      return
    }
    let gameDataA = {
      isOver: this.distributedData.isOver,
      step: this.distributedData.step,
      chessMapArr: this.distributedData.chessMapArr,
      chessX: this.distributedData.chessX,
      chessY: this.distributedData.chessY,
      clickCount: this.distributedData.clickCount,
      fallLocation: this.distributedData.fallLocation
    }
    try {
      this.kvStoreModel.put(GobangConst.DEVICE_A, JSON.stringify(gameDataA))
    } catch (err) {
      Logger.error(TAG, `dataChange failed, code is ${err.code}, message is ${err.message}`)
    }
    Logger.info(TAG, `put ${this.deviceFlag},${JSON.stringify(gameDataA)}`)
  }

  convertResourceToString(context: any, resource: Resource) {
    return context.resourceManager.getStringSync(resource)
  }

  async aboutToAppear() {
    Logger.info(TAG, `enter aboutToAppear`)
    this.distributedData.init()
    let context = getContext(this) as any
    this.totalText = this.convertResourceToString(context, $r('app.string.total'))
    this.roundText = this.convertResourceToString(context, $r('app.string.round'))
    this.blackChessText = this.convertResourceToString(context, $r('app.string.black_chess'))
    this.whiteChessText = this.convertResourceToString(context, $r('app.string.white_chess'))
    this.winText = this.convertResourceToString(context, $r('app.string.win'))
    if (AppStorage.Get('deviceFlag')) {
      this.isDistributed = true
    }
    if (AppStorage.Get('deviceFlag') === 'B') {
      this.deviceFlag = 'B'
    }
    if (this.deviceFlag === 'B') {
      Logger.info(TAG, `enter deviceFlag B`)
      this.kvStoreModel.setOnMessageReceivedListener(context, GobangConst.DEVICE_A, (value) => {
        let gameDataA = JSON.parse(value)
        this.distributedData.step = gameDataA.step
        this.distributedData.clickCount = gameDataA.clickCount
        this.distributedData.chessMapArr = gameDataA.chessMapArr
        this.distributedData.fallGather = gameDataA.fallGather
        this.distributedData.chessX = gameDataA.chessX
        this.distributedData.chessY = gameDataA.chessY
        this.distributedData.fallLocation = gameDataA.fallLocation
        if (gameDataA.isOver === true) {
          this.isFlush = !this.isFlush
        } else {
          this.distributedData.isOver = gameDataA.isOver
        }
      })
    } else if (this.deviceFlag === 'A') {
      Logger.info(TAG, `enter deviceFlag A`)
      this.kvStoreModel.setOnMessageReceivedListener(context, GobangConst.DEVICE_B, (value) => {
        let gameDataB = JSON.parse(value)
        this.fallChessInner(gameDataB.x, gameDataB.y)
      })
    }
  }

  startAbilityCallBack = (key: string) => {
    if (GobangConst.DEVICE_A === key) {
      try {
        this.kvStoreModel.put(GobangConst.DEVICE_A, this.distributedData)
      } catch (err) {
        Logger.error(`startAbilityCallBack failed, code is ${err.code}, message is ${err.message}`)
      }
    }
    if (GobangConst.EXIT === key) {
      try {
        this.kvStoreModel.put(GobangConst.DEVICE_A, GobangConst.EXIT)
      } catch (err) {
        Logger.error(`startAbilityCallBack failed, code is ${err.code}, message is ${err.message}`)
      }
    }
  }

  private cleanChessBoard() {
    this.context.fillStyle = 'RGB(222,184,135)'
    this.context.fillRect(0, 0, this.screenWidth / this.dpiBi, this.screenWidth / this.dpiBi)
  }

  private drawChess(x, y, color) {
    this.context.beginPath()
    this.context.arc(x, y, this.chessSize / 2 * 0.8, 0, Math.PI * 2, false)
    this.context.closePath()
    this.context.fillStyle = color
    this.context.fill()
  }

  private drawChessBoard() {
    for (let i = 0; i < 15; i++) {
      this.context.beginPath()
      this.context.strokeStyle = '#f2eada'
      this.context.lineWidth = 3
      this.context.beginPath()
      this.context.moveTo((i + 1) * (this.chessSize), (this.chessSize))
      this.context.lineTo((i + 1) * (this.chessSize), (this.chessSize * 15))
      this.context.closePath()
      this.context.stroke()
      this.context.beginPath()
      this.context.moveTo(this.chessSize, (i + 1) * this.chessSize)
      this.context.lineTo((this.chessSize * 15), (i + 1) * this.chessSize)
      this.context.closePath()
      this.context.stroke()
      this.context.shadowBlur = 3
      this.context.shadowColor = '#afb4db'
      this.context.beginPath()
      this.context.arc(this.screenWidth / this.dpiBi / 2, this.screenWidth / this.dpiBi / 2, 3, 0, Math.PI * 2, false)
      this.context.arc(this.screenWidth / this.dpiBi / 4, this.screenWidth / this.dpiBi / 4, 3, 0, Math.PI * 2, false)
      this.context.arc(this.screenWidth / this.dpiBi / 4 * 3, this.screenWidth / this.dpiBi / 4 * 3, 3, 0, Math.PI * 2, false)
      this.context.closePath()
      this.context.fillStyle = 'black'
      this.context.fill()
      this.context.beginPath()
      this.context.arc(this.screenWidth / this.dpiBi / 4, this.screenWidth / this.dpiBi / 4 * 3, 3, 0, Math.PI * 2, false)
      this.context.arc(this.screenWidth / this.dpiBi / 4 * 3, this.screenWidth / this.dpiBi / 4, 3, 0, Math.PI * 2, false)
      this.context.closePath()
      this.context.fillStyle = 'black'
      this.context.fill()
      this.context.closePath()
    }
  }

  private fallChessInner(x: number, y: number) {
    Logger.info(TAG, `enter fallChessInner, this.deviceFlag = ${this.deviceFlag}`)
    if (x < 0 || x > 14 || y < 0 || y > 14) {
      return
    }
    if (this.distributedData.chessMapArr[x][y] === '') {
      if (this.deviceFlag === 'B') {
        let gameDateB = {
          x: x,
          y: y,
        }
        try {
          this.kvStoreModel.put(GobangConst.DEVICE_B, JSON.stringify(gameDateB))
        } catch (err) {
          Logger.error(TAG, `deviceB put failed,code is ${err.code}, message is ${err.message}`)
        }
        Logger.info(TAG, `kvStoreModel.put, deviceB = ${JSON.stringify(gameDateB)}`)
      } else {
        this.distributedData.fallChess(x, y, GobangConst.CHESS_COLOR[this.distributedData.step % 2])
        this.distributedData.step++
        Logger.info(TAG, `fall chess success`)
      }
    }
  }

  constructorMessage() {
    return `${this.totalText}${Math.ceil(this.distributedData.step / 2)}${this.roundText},${this.distributedData.step % 2 === 0 ? this.whiteChessText : this.blackChessText}${this.winText}`
  }

  private fallChess(event) {
    if (this.distributedData.isOver) {
      message:this.constructorMessage()
      return
    }
    let clickX = event.x
    let clickY = event.y
    let dx = Math.floor((clickX + this.chessSize / 2) / this.chessSize) * this.chessSize
    let dy = Math.floor((clickY + this.chessSize / 2) / this.chessSize) * this.chessSize
    if (this.distributedData.fallLocation.toString() === [dx, dy].toString()) {
      this.isFall = true
    }
    this.distributedData.fallLocation[0] = dx
    this.distributedData.fallLocation[1] = dy
    Logger.info(TAG, `fallChess,${this.distributedData.fallLocation},${clickX},${clickY}`)
    if (!this.isFall) {
      return
    }
    let x = Math.round(dx / this.chessSize - 1)
    let y = Math.round(dy / this.chessSize - 1)
    this.fallChessInner(x, y)
    this.isFall = false
    this.isClick = true
  }

  private drawAll() {
    if (this.distributedData.clickCount > 0) {
      if (this.deviceFlag === 'A' && this.distributedData.step % 2 === 0) {
        this.confirmFall()
      } else if (this.deviceFlag === 'B' && this.distributedData.step % 2 !== 0) {
        this.confirmFall()
      }
    }
    if (this.countOnReady++ === 1) {
      return
    }
    for (let i = 0; i < 15; i++) {
      for (let j = 0; j < 15; j++) {
        if (this.distributedData.chessMapArr[i][j] !== '') {
          let dx = (i + 1) * this.chessSize
          let dy = (j + 1) * this.chessSize
          let color = this.distributedData.chessMapArr[i][j]
          this.drawChess(dx, dy, color)
        }
      }
    }
  }

  private checkWin(x, y, color, mode) {
    Logger.info(TAG, `checkWin x = ${x}, y = ${y}`)
    var count = 1
    for (let i = 1; i < 5; i++) {
      if (this.distributedData.chessMapArr[x + i * mode[0]]) {
        if (this.distributedData.chessMapArr[x + i * mode[0]][y + i * mode[1]] === color && color !== '') {
          count++
        } else {
          break
        }
      }
    }
    for (let j = 1; j < 5; j++) {
      if (this.distributedData.chessMapArr[x - j * mode[0]]) {
        if (this.distributedData.chessMapArr[x - j * mode[0]][y - j * mode[1]] === color && color !== '') {
          count++
        } else {
          break
        }
      }
    }
    Logger.info(TAG, `checkWin count = ${count}`)
    if (count >= 5) {
      setTimeout(() => {
        Logger.info(TAG, `AlertDialog`)
        AlertDialog.show({
          message: this.constructorMessage()
        })
      }, 100)
      this.distributedData.isOver = true
    }
  }

  private fallFlag() {
    if (this.distributedData.step !== 0) {
      this.context.beginPath()
      this.context.arc((this.distributedData.chessX + 1) * this.chessSize, (this.distributedData.chessY + 1) * this.chessSize, this.chessSize / 2 * 0.8, 0, Math.PI * 2, false)
      this.context.shadowColor = '#FFFF00'
      this.context.shadowBlur = 20
      this.context.closePath()
      this.context.fillStyle = GobangConst.CHESS_COLOR[(this.distributedData.step + 1) % 2]
      this.context.fill()
    }
  }

  private confirmFall() {
    Logger.info(TAG, `${this.distributedData.fallLocation}`)
    this.context.beginPath()
    this.context.arc(this.distributedData.fallLocation[0], this.distributedData.fallLocation[1], this.chessSize / 2 * 0.8, 0, Math.PI * 2, false)
    this.context.stroke()
    this.context.closePath()
  }

  flushData() {
    this.cleanChessBoard()
    this.drawChessBoard()
    this.drawAll()
    if (this.distributedData.isOver === false) {
      for (var i = 0; i < 4; i++) {
        Logger.info(TAG, `check ${this.distributedData.chessX},${this.distributedData.chessY}`)
        let x = this.distributedData.chessX
        let y = this.distributedData.chessY
        if (x < 0 || x > 14 || y < 0 || y > 14) {
          continue
        }
        let color = this.distributedData.chessMapArr[x][y]
        Logger.info(TAG, `check ${x},${y},${color}`)
        this.checkWin(x, y, color, GobangConst.CHECK_MODE[i])
        Logger.info(TAG, `end Canvas onReady`)
      }
    }
    // 给当前棋子填充颜色
    // 如果悔棋，A盘当前子颜色变为‘’，B盘当前子消失
    // 如果不悔棋,A盘落子颜色正常，B盘落子颜色正常
    if (!this.isRetract) {
      if (this.deviceFlag === 'A' && this.distributedData.step % 2 === 0) {
        // 在A盘，且步长是偶数，表示B下的棋子会在A盘显示，绘制确定好的棋子
        this.fallFlag()
        Logger.info(TAG, `AfallFlag,isRetract=${this.isRetract}`)
      } else if (this.deviceFlag === 'B' && this.distributedData.step % 2 !== 0) {
        // 在B盘，且步长是奇数，表示A下的棋子会在B盘显示，绘制确定好的棋子
        // 如果A盘重开(isRestart=true)，那B盘就要清空棋子;不重开(isRestart=false)时，B盘正常显示
        this.fallFlag()
        Logger.info(TAG, `BfallFlag,isRetract=${this.isRetract}`)
      }
    }
  }

  build() {
    Column() {
      TitleBar({
        startAbilityCallBack: this.startAbilityCallBack,
        remoteDeviceModel: this.remoteDeviceModel,
        isDistributed: $isDistributed,
        dialogShow: $dialogShow,
      })

      Text(`${this.deviceFlag}-${this.distributedData.step}-${this.distributedData.clickCount}`)

      Column() {
        Canvas(this.context)
          .width(this.screenWidth / this.dpiBi)
          .height(this.screenWidth / this.dpiBi)
          .backgroundColor('RGB(222,184,135)')
          .onReady(() => {
            Logger.info(TAG, `enter Canvas onReady`)
            this.flushData()
          })
          .border({ width: 1, color: 'red' })
      }
      .margin({ bottom: 10 })
      .onClick((event) => {
        if (this.deviceFlag === 'A' && this.distributedData.step % 2 === 0) {
          this.fallChess(event)
        } else if (this.deviceFlag === 'B' && this.distributedData.step % 2 !== 0) {
          this.fallChess(event)
        }
        this.distributedData.clickCount++
      })

      Row() {
        if (this.deviceFlag === 'A') {
          Button($r('app.string.restart'), { stateEffect: true })
            .height(40)
            .fontSize(24 / this.dpiBi)
            .margin({ left: 20 })
            .padding({ left: 10, right: 10 })
            .backgroundColor('RGB(210,105,30)')
            .onClick(() => {
              this.distributedData.init()
              this.distributedData.isOver = false
              this.distributedData.step = 0
              this.distributedData.clickCount = 0
              this.distributedData.fallLocation = []
            })
          Blank()
          Button($r('app.string.repentance_chess'), { stateEffect: true })
            .backgroundColor('RGB(210,105,30)')
            .height(40)
            .margin({ right: 20 })
            .padding({ left: 10, right: 10 })
            .fontSize(24 / this.dpiBi)
            .enabled(this.isClick)
            .onClick(() => {
              if (this.distributedData.step > 0) {
                this.distributedData.chessMapArr[this.distributedData.fallGather[0][0]][this.distributedData.fallGather[0][1]] = ''
                this.distributedData.fallGather.shift()
                this.distributedData.step--
                this.isRetract = true
                this.isClick = false
              }
            })
        }
      }
      .width(210)
    }
    .justifyContent(FlexAlign.Center)
    .backgroundImage($r('app.media.bg'))
    .backgroundImageSize({ width: '100%', height: '100%' })
    .width('100%')
    .height('100%')
  }
}