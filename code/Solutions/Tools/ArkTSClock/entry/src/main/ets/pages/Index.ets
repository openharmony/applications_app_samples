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
import display from '@ohos.display'
import Logger from '../model/Logger'

const HOURS: Array<string> = ['3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '1', '2']
const HEIGHT_ADD: number = 150 // 表盘下面需要绘制时间，canvas高度是宽度加150
const TAG: string = 'Index'

@Entry
@Component
struct Clock {
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  @State canvasWidth: number = 300 // 300是表盘默认大小
  private radius: number = 150 // 默认表盘半径
  private intervalId: number = 0
  updateTime = () => {
    Logger.info(TAG, `start call updateTime`)
    Logger.info(TAG, `time5:${new Date(new Date().getTime())}`)
    this.context.clearRect(0, 0, this.canvasWidth, this.canvasWidth + HEIGHT_ADD)
    Logger.info(`updateTime,call clearRect`)
    Logger.info(TAG, `time6:${new Date(new Date().getTime())}`)
    let nowTime = new Date()
    let hour = nowTime.getHours()
    let minute = nowTime.getMinutes()
    let second = nowTime.getSeconds()
    let time = `${this.fillTime(hour)}:${this.fillTime(minute)}:${this.fillTime(second)}`
    Logger.info(TAG, `current clock show time is:${JSON.stringify(time)}`)
    Logger.info(TAG, `time7:${new Date(new Date().getTime())}`)
    this.drawBackGround()
    Logger.info(TAG, `time38:${new Date(new Date().getTime())}`)
    this.drawHour(hour, minute)
    Logger.info(TAG, `time49:${new Date(new Date().getTime())}`)
    this.drawMinute(minute)
    Logger.info(TAG, `time60:${new Date(new Date().getTime())}`)
    this.drawSecond(second)
    Logger.info(TAG, `time71:${new Date(new Date().getTime())}`)
    this.drawDot()
    Logger.info(TAG, `time79:${new Date(new Date().getTime())}`)
    this.drawTime(time)
    Logger.info(TAG, `time86:${new Date(new Date().getTime())}`)
    this.context.translate(-this.radius, -this.radius)
    Logger.info(TAG, `updateTime,call translate`)
    Logger.info(TAG, `time87:${new Date(new Date().getTime())}`)
    Logger.info(TAG, `call updateTime end`)
  }

  fillTime(time: number) {
    return time < 10 ? `0${time}` : `${time}`
  }

  aboutToAppear() {
    Logger.info(TAG, `enter aboutToAppear`)
    this.getSize()
  }

  // 获取设备宽高计算表盘大小
  async getSize() {
    Logger.info(TAG, `start call getSize`)
    Logger.info(TAG, `time1:${new Date(new Date().getTime())}`)
    let mDisplay = await display.getDefaultDisplay()
    Logger.info(TAG, `time2:${new Date(new Date().getTime())}`)
    Logger.info(TAG, `getDefaultDisplay mDisplay = ${JSON.stringify(mDisplay)}`)
    Logger.info(TAG, `time3:${new Date(new Date().getTime())}`)
    this.canvasWidth = px2vp(mDisplay.width > mDisplay.height ? mDisplay.height * 0.6 : mDisplay.width * 0.6)
    Logger.info(TAG, `time4:${new Date(new Date().getTime())}`)
    this.radius = this.canvasWidth / 2
  }

  drawBackGround() {
    Logger.info(TAG, `start call drawBackGround`)

    // 绘制背景
    Logger.info(TAG, `time8:${new Date(new Date().getTime())}`)
    let grad = this.context.createRadialGradient(this.radius, this.radius, this.radius - 32, this.radius,
      this.radius, this.radius)
    Logger.info(TAG, `drawBackGround,call createRadialGradient`)
    Logger.info(TAG, `time9:${new Date(new Date().getTime())}`)
    grad.addColorStop(0.0, 'white')
    Logger.info(TAG, `drawBackGround,call addColorStop 0.0`)
    Logger.info(TAG, `time10:${new Date(new Date().getTime())}`)
    grad.addColorStop(0.9, '#eee')
    Logger.info(TAG, `drawBackGround,call addColorStop 0.9`)
    Logger.info(TAG, `time11:${new Date(new Date().getTime())}`)
    grad.addColorStop(1.0, 'white')
    Logger.info(TAG, `drawBackGround,call addColorStop 1.0`)
    Logger.info(TAG, `time12:${new Date(new Date().getTime())}`)
    this.context.fillStyle = grad
    Logger.info(TAG, `time13:${new Date(new Date().getTime())}`)
    this.context.fillRect(0, 0, this.canvasWidth, this.canvasWidth)
    Logger.info(TAG, `drawBackGround,call fillRect`)
    Logger.info(TAG, `time14:${new Date(new Date().getTime())}`)

    // 绘制外圈圆
    this.context.translate(this.radius, this.radius)
    Logger.info(TAG, `drawBackGround,call translate`)
    Logger.info(TAG, `time15:${new Date(new Date().getTime())}`)
    this.context.lineWidth = 6
    Logger.info(TAG, `time16:${new Date(new Date().getTime())}`)
    this.context.beginPath()
    Logger.info(TAG, `drawBackGround,call beginPath`)
    Logger.info(TAG, `time17:${new Date(new Date().getTime())}`)
    this.context.strokeStyle = '#fff'
    Logger.info(TAG, `time18:${new Date(new Date().getTime())}`)
    this.context.arc(0, 0, this.radius - 5, 0, 2 * Math.PI, false)
    Logger.info(TAG, `drawBackGround,call arc`)
    Logger.info(TAG, `time19:${new Date(new Date().getTime())}`)
    this.context.stroke()
    Logger.info(TAG, `drawBackGround,call stroke`)
    Logger.info(TAG, `time20:${new Date(new Date().getTime())}`)

    // 绘制时间文字
    this.context.font = '30px'
    this.context.textAlign = "center"
    this.context.textBaseline = "middle"
    this.context.fillStyle = '#000'
    Logger.info(TAG, `draw time and word`)
    Logger.info(TAG, `time21:${new Date(new Date().getTime())}`)
    this.context.save()
    Logger.info(TAG, `drawBackGround,call save`)
    Logger.info(TAG, `time22:${new Date(new Date().getTime())}`)
    HOURS.forEach((num, index) => {
      Logger.info(TAG, `num:${JSON.stringify(num)}`)
      let rad = 2 * Math.PI / 12 * index
      let x = Math.cos(rad) * (this.radius - 38)
      let y = Math.sin(rad) * (this.radius - 38)
      Logger.info(TAG, `time23:${new Date(new Date().getTime())}`)
      this.context.fillText(num, x, y)
      Logger.info(TAG, `drawBackGround,call fillText`)
      Logger.info(TAG, `time24:${new Date(new Date().getTime())}`)
    })
    Logger.info(TAG, `hour text fill finish`)
    Logger.info(TAG, `time25:${new Date(new Date().getTime())}`)
    this.context.restore()
    Logger.info(TAG, `drawBackGround,call restore`)
    Logger.info(TAG, `time26:${new Date(new Date().getTime())}`)

    // 绘制刻度
    for (let i = 0; i < 60; i++) {
      let rad = 2 * Math.PI / 60 * i
      let x = Math.cos(rad) * (this.radius - 12)
      let y = Math.sin(rad) * (this.radius - 12)
      Logger.info(TAG, `start draw scal`)
      Logger.info(TAG, `time27:${new Date(new Date().getTime())}`)
      this.context.beginPath()
      Logger.info(TAG, `drawBackGround,call beginPath`)
      Logger.info(TAG, `time28:${new Date(new Date().getTime())}`)
      this.context.moveTo(x, y)
      Logger.info(TAG, `drawBackGround,call moveTo`)
      Logger.info(TAG, `time29:${new Date(new Date().getTime())}`)
      if (i % 5 == 0) {
        let x1 = Math.cos(rad) * (this.radius - 20)
        let y1 = Math.sin(rad) * (this.radius - 20)
        this.context.strokeStyle = '#000'
        this.context.lineWidth = 2
        Logger.info(TAG, `set hour color and line width`)
        Logger.info(TAG, `time30:${new Date(new Date().getTime())}`)
        this.context.lineTo(x1, y1)
        Logger.info(TAG, `drawBackGround,call lineTo`)
        Logger.info(TAG, `time31:${new Date(new Date().getTime())}`)
      } else {
        let x1 = Math.cos(rad) * (this.radius - 18)
        let y1 = Math.sin(rad) * (this.radius - 18)
        this.context.strokeStyle = '#ccc'
        this.context.lineWidth = 1
        Logger.info(TAG, `time32:${new Date(new Date().getTime())}`)
        Logger.info(TAG, `set minute color and line width`)
        this.context.lineTo(x1, y1)
        Logger.info(TAG, `drawBackGround,call lineTo`)
        Logger.info(TAG, `time33:${new Date(new Date().getTime())}`)
      }
      Logger.info(TAG, `time34:${new Date(new Date().getTime())}`)
      this.context.stroke()
      Logger.info(TAG, `drawBackGround,call stroke`)
      Logger.info(TAG, `time35:${new Date(new Date().getTime())}`)
    }
    Logger.info(TAG, `hour and minute hand draw finish`)
    Logger.info(TAG, `time36:${new Date(new Date().getTime())}`)
    this.context.restore()
    Logger.info(TAG, `drawBackGround,call restore`)
    Logger.info(TAG, `time37:${new Date(new Date().getTime())}`)
  }

  // 绘制时针
  drawHour(hour: number, minute: number) {
    Logger.info(TAG, `start draw hour`)
    Logger.info(TAG, `time39:${new Date(new Date().getTime())}`)
    this.context.save()
    Logger.info(TAG, `drawHour,call save`)
    Logger.info(TAG, `time40:${new Date(new Date().getTime())}`)
    this.context.beginPath()
    Logger.info(TAG, `drawHour,call beginPath`)

    Logger.info(TAG, `time41:${new Date(new Date().getTime())}`)
    this.context.lineWidth = 8
    this.context.lineCap = 'round'
    let rad = 2 * Math.PI / 12 * hour
    let mrad = 2 * Math.PI / 12 / 60 * minute
    Logger.info(TAG, `time42:${new Date(new Date().getTime())}`)
    this.context.rotate(rad + mrad)
    Logger.info(TAG, `drawHour,call rotate`)
    Logger.info(TAG, `time43:${new Date(new Date().getTime())}`)
    this.context.moveTo(0, 10)
    Logger.info(TAG, `drawHour,call moveTo`)
    Logger.info(TAG, `time44:${new Date(new Date().getTime())}`)
    this.context.strokeStyle = '#000'
    Logger.info(TAG, `time45:${new Date(new Date().getTime())}`)
    this.context.lineTo(0, -this.radius / 2)
    Logger.info(TAG, `drawHour,call lineTo`)
    Logger.info(TAG, `time46:${new Date(new Date().getTime())}`)
    this.context.stroke()
    Logger.info(TAG, `drawHour,call stroke`)
    Logger.info(TAG, `time47:${new Date(new Date().getTime())}`)
    this.context.restore()
    Logger.info(TAG, `drawHour,call restore`)
    Logger.info(TAG, `time48:${new Date(new Date().getTime())}`)
    Logger.info(TAG, `draw hour end`)
  }

  // 绘制分针
  drawMinute(minute: number) {
    Logger.info(TAG, `start call drawMinute`)
    Logger.info(TAG, `time50:${new Date(new Date().getTime())}`)
    this.context.save()
    Logger.info(TAG, `drawMinute,call save`)
    Logger.info(TAG, `time51:${new Date(new Date().getTime())}`)
    this.context.beginPath()
    Logger.info(TAG, `drawMinute,call beginPath`)
    Logger.info(TAG, `time52:${new Date(new Date().getTime())}`)
    this.context.lineWidth = 5
    this.context.lineCap = 'round'
    let rad = 2 * Math.PI / 60 * minute
    Logger.info(TAG, `time53:${new Date(new Date().getTime())}`)
    this.context.rotate(rad)
    Logger.info(TAG, `drawMinute,call rotate`)
    Logger.info(TAG, `time54:${new Date(new Date().getTime())}`)
    this.context.moveTo(0, 10)
    Logger.info(TAG, `drawMinute,call moveTo`)
    Logger.info(TAG, `time55:${new Date(new Date().getTime())}`)
    this.context.strokeStyle = '#000'
    Logger.info(TAG, `time56:${new Date(new Date().getTime())}`)
    this.context.lineTo(0, -this.radius + 40)
    Logger.info(TAG, `drawMinute,call lineTo`)
    Logger.info(TAG, `time57:${new Date(new Date().getTime())}`)
    this.context.stroke()
    Logger.info(TAG, `drawMinute,call stroke`)
    Logger.info(TAG, `time58:${new Date(new Date().getTime())}`)
    this.context.restore()
    Logger.info(TAG, `drawMinute,call restore`)
    Logger.info(TAG, `time59:${new Date(new Date().getTime())}`)
    Logger.info(TAG, `call draw minute end`)
  }

  // 绘制秒针
  drawSecond(second: number) {
    Logger.info(TAG, `start call drawSecond`)
    Logger.info(TAG, `time61:${new Date(new Date().getTime())}`)
    this.context.save()
    Logger.info(TAG, `drawSecond,call save`)
    Logger.info(TAG, `time62:${new Date(new Date().getTime())}`)
    this.context.beginPath()
    Logger.info(TAG, `drawSecond,call beginPath`)
    Logger.info(TAG, `time63:${new Date(new Date().getTime())}`)
    this.context.lineWidth = 2
    this.context.lineCap = 'round'
    let rad = 2 * Math.PI / 60 * second
    Logger.info(TAG, `time64:${new Date(new Date().getTime())}`)
    this.context.rotate(rad)
    Logger.info(TAG, `drawSecond,call rotate`)
    Logger.info(TAG, `time65:${new Date(new Date().getTime())}`)
    this.context.moveTo(0, 10)
    Logger.info(TAG, `drawSecond,call moveTo`)
    Logger.info(TAG, `time66:${new Date(new Date().getTime())}`)
    this.context.strokeStyle = '#05f'
    Logger.info(TAG, `time67:${new Date(new Date().getTime())}`)
    this.context.lineTo(0, -this.radius + 21)
    Logger.info(TAG, `drawSecond,call lineTo`)
    Logger.info(TAG, `time68:${new Date(new Date().getTime())}`)
    this.context.stroke()
    Logger.info(TAG, `drawSecond,call stroke`)
    Logger.info(TAG, `time69:${new Date(new Date().getTime())}`)
    this.context.restore()
    Logger.info(TAG, `drawSecond,call restore`)
    Logger.info(TAG, `time70:${new Date(new Date().getTime())}`)
    Logger.info(TAG, `call drawSecond end`)
  }

  // 绘制中心点
  drawDot() {
    Logger.info(TAG, `start call drawDot`)
    Logger.info(TAG, `time72:${new Date(new Date().getTime())}`)
    this.context.save()
    Logger.info(TAG, `drawDot,call save`)
    Logger.info(TAG, `time73:${new Date(new Date().getTime())}`)
    this.context.beginPath()
    Logger.info(TAG, `drawDot,call beginPath`)
    Logger.info(TAG, `time74:${new Date(new Date().getTime())}`)
    this.context.fillStyle = '#05f'
    Logger.info(TAG, `time75:${new Date(new Date().getTime())}`)
    this.context.arc(0, 0, 4, 0, 2 * Math.PI, false)
    Logger.info(TAG, `drawDot,call arc`)
    Logger.info(TAG, `time76:${new Date(new Date().getTime())}`)
    this.context.fill()
    Logger.info(TAG, `drawDot,call fill`)
    Logger.info(TAG, `time77:${new Date(new Date().getTime())}`)
    this.context.restore()
    Logger.info(TAG, `drawDot,call restore`)
    Logger.info(TAG, `time78:${new Date(new Date().getTime())}`)
    Logger.info(TAG, `call drawDot end`)
  }

  // 绘制表盘下面时间文本
  drawTime(time: string) {
    Logger.info(TAG, `start call drawTime`)
    Logger.info(TAG, `time80:${new Date(new Date().getTime())}`)
    this.context.save()
    Logger.info(TAG, `drawTime,call save`)
    Logger.info(TAG, `time8:${new Date(new Date().getTime())}`)
    this.context.beginPath()
    Logger.info(TAG, `drawTime,call beginPath`)
    Logger.info(TAG, `time82:${new Date(new Date().getTime())}`)
    this.context.font = '90px'
    this.context.textAlign = "center"
    this.context.textBaseline = "middle"
    this.context.fillStyle = '#000'
    Logger.info(TAG, `time83:${new Date(new Date().getTime())}`)
    this.context.fillText(time, 0, this.radius + 80)
    Logger.info(TAG, `drawTime,call fillText`)
    Logger.info(TAG, `time84:${new Date(new Date().getTime())}`)
    this.context.restore()
    Logger.info(TAG, `drawTime,call restore`)
    Logger.info(TAG, `time85:${new Date(new Date().getTime())}`)
    Logger.info(TAG, `call drawTime end`)
  }

  build() {
    Stack({ alignContent: Alignment.Center }) {
      Canvas(this.context)
        .padding({ top: 76 })
        .width(this.canvasWidth)
        .height(this.canvasWidth + HEIGHT_ADD)
        .onReady(() => {
          Logger.info(TAG, `onReady`)
          this.updateTime()
          Logger.info(TAG, `time88:${new Date(new Date().getTime())}`)
          this.intervalId = setInterval(this.updateTime, 1000)
          Logger.info(TAG, `time89:${new Date(new Date().getTime())}`)
        })
    }
    .width('100%')
    .height('100%')
  }

  onPageHide() {
    Logger.info(TAG, `onPageHide`)
    Logger.info(TAG, `time90:${new Date(new Date().getTime())}`)
    clearInterval(this.intervalId)
    Logger.info(TAG, `time91:${new Date(new Date().getTime())}`)
  }

  aboutToDisappear() {
    Logger.info(TAG, `aboutToDisappear`)
    Logger.info(TAG, `time92:${new Date(new Date().getTime())}`)
    clearInterval(this.intervalId)
    Logger.info(TAG, `time93:${new Date(new Date().getTime())}`)
  }
}