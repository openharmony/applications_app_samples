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

import Constant from '../../common/Constant'

const HOURS: Array<string> = ['3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '1', '2']
const TIME_TEXT_HEIGHT: number = 150 // The underside of the dial needs to be drawn, and the canvas height is width plus 150

@Component
export struct DrawClock {
  @Link radius: number
  @Link canvasWidth: number
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private intervalId: number = 0
  updateTime = () => {
    this.context.clearRect(0, 0, this.canvasWidth, this.canvasWidth + TIME_TEXT_HEIGHT)
    let nowTime = new Date()
    let hour = nowTime.getHours()
    let minute = nowTime.getMinutes()
    let second = nowTime.getSeconds()
    let time = `${this.fillTime(hour)}:${this.fillTime(minute)}:${this.fillTime(second)}`
    this.drawBackground()
    this.drawHour(hour, minute)
    this.drawMinute(minute)
    this.drawSecond(second)
    this.drawDot()
    this.drawTime(time)
    this.context.translate(-this.radius, -this.radius)
  }

  build() {
    Canvas(this.context)
      .width(this.canvasWidth)
      .height(this.canvasWidth + TIME_TEXT_HEIGHT)
      .onReady(() => {
        this.updateTime()
        this.intervalId = setInterval(this.updateTime, Constant.SECONDS_MILLISECONDS)
      })
  }

  fillTime(time) {
    return time < 10 ? `0${time}` : `${time}`
  }

  drawBackground() {
    this.context.save()
    // Draw the background
    let grad = this.context.createRadialGradient(this.radius, this.radius, this.radius - 35, this.radius,
      this.radius, this.radius)
    grad.addColorStop(0.0, '#F1F3F5')
    grad.addColorStop(0.9, '#EEEEEE')
    grad.addColorStop(1.0, '#F1F3F5')
    this.context.fillStyle = grad
    this.context.fillRect(0, 0, this.canvasWidth, this.canvasWidth)
    // Draw an outer circle
    this.context.translate(this.radius, this.radius)
    this.context.lineWidth = 6
    this.context.beginPath()
    this.context.strokeStyle = '#FFFFFF'
    this.context.arc(0, 0, this.radius - 6, 0, 2 * Math.PI, false)
    this.context.stroke()
    // Draw time text
    this.context.font = '25px'
    this.context.textAlign = 'center'
    this.context.textBaseline = 'middle'
    this.context.fillStyle = '#000000'
    HOURS.forEach((num, index) => {
      this.context.save()
      let rad = 2 * Math.PI / 12 * index
      let x = Math.cos(rad) * (this.radius - 38)
      let y = Math.sin(rad) * (this.radius - 38)
      this.context.fillText(num, x, y)
    })
    // Draw the scale
    for (let i = 0; i < 60; i++) {
      let rad = 2 * Math.PI / 60 * i
      let x = Math.cos(rad) * (this.radius - 12)
      let y = Math.sin(rad) * (this.radius - 12)
      this.context.beginPath()
      this.context.moveTo(x, y)
      if (i % 5 == 0) {
        let x1 = Math.cos(rad) * (this.radius - 20)
        let y1 = Math.sin(rad) * (this.radius - 20)
        this.context.strokeStyle = '#000000'
        this.context.lineWidth = 4
        this.context.lineTo(x1, y1)
      } else {
        let x1 = Math.cos(rad) * (this.radius - 18)
        let y1 = Math.sin(rad) * (this.radius - 18)
        this.context.strokeStyle = '#CCCCCC'
        this.context.lineWidth = 3
        this.context.lineTo(x1, y1)
      }
      this.context.stroke()
    }
  }

  // Draw the hour hand
  drawHour(hour, minute) {
    this.context.save()
    this.context.beginPath()
    this.context.lineWidth = 8
    this.context.lineCap = 'round'
    let rad = 2 * Math.PI / 12 * hour
    let mrad = 2 * Math.PI / 12 / 60 * minute
    this.context.rotate(rad + mrad)
    this.context.moveTo(0, 10)
    this.context.strokeStyle = '#000000'
    this.context.lineTo(0, -this.radius / 2)
    this.context.stroke()
    this.context.restore()
  }

  // Draw the minute hand
  drawMinute(minute) {
    this.context.save()
    this.context.beginPath()
    this.context.lineWidth = 6
    this.context.lineCap = 'round'
    let rad = 2 * Math.PI / 60 * minute
    this.context.rotate(rad)
    this.context.moveTo(0, 10)
    this.context.strokeStyle = '#000000'
    this.context.lineTo(0, -this.radius + 40)
    this.context.stroke()
    this.context.restore()
  }

  // Draw the second hand
  drawSecond(second) {
    this.context.save()
    this.context.beginPath()
    this.context.lineWidth = 4
    this.context.lineCap = 'round'
    let rad = 2 * Math.PI / 60 * second
    this.context.rotate(rad)
    this.context.moveTo(0, 10)
    this.context.strokeStyle = '#0055FF'
    this.context.lineTo(0, -this.radius + 18)
    this.context.stroke()
    this.context.restore()
  }

  // Draw the center point
  drawDot() {
    this.context.save()
    this.context.beginPath()
    this.context.fillStyle = '#0055FF'
    this.context.arc(0, 0, 4, 0, 2 * Math.PI, false)
    this.context.fill()
    this.context.restore()
  }

  // Draw the time text below the dial
  drawTime(time) {
    this.context.save()
    this.context.beginPath()
    this.context.font = '60px'
    this.context.textAlign = 'center'
    this.context.textBaseline = 'middle'
    this.context.fillStyle = '#000000'
    this.context.fillText(time, 0, this.radius + 80)
    this.context.restore()
  }
}