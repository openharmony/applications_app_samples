/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import Log from '../utils/Log'
import DateUtils from '../utils/DateUtils'

const TAG = '[Sample_HeartRateGraph]'

const SIZE: number = 12
const COORDINATE_SIZE: number = 5
const LINE_WIDTH: number = px2vp(6)
const COLOR_LINE: string = '#FF0A59F7'
const MAX_HEART_RATE: number = 200
const WIDTH_CHANGE_POINT: number = px2vp(900)

const X_COORDINATE_TEXT_HEIGHT: number = px2vp(30)
const START_X: number = px2vp(40)
const PADDING_VERTICAL: number = px2vp(40)
const PADDING_HORIZONTAL: number = px2vp(40)

@Component
export default struct HeartRateGraph {
  @StorageLink('heartRate') @Watch('onHeartRate') heartRate: number = 0
  @Prop @Watch('onViewSizeChange') viewWidth: number
  @Prop @Watch('onViewSizeChange') viewHeight: number
  @State heartRateArr: Array<number> = []
  @State timeArr: Array<string> = []
  private settings: RenderingContextSettings = new RenderingContextSettings(true)
  private context: CanvasRenderingContext2D = new CanvasRenderingContext2D(this.settings)
  private mCoordinateLineEndX: number = 0
  private mOffset: number = 0
  private mHeightRatio: number = 0
  private mHeartRateCoordinateArr: Array<number> = []

  aboutToAppear() {
    this.calculateLayoutConfig()

    for (let i = 0; i < SIZE; i++) {
      this.heartRateArr[i] = 0
    }
    for (let i = 0; i < SIZE; i++) {
      this.timeArr[i] = `--:--:--`
    }
  }

  onHeartRate() {
    Log.showInfo(TAG, `onHeartRate: heartRate = ${this.heartRate}`)

    // update heart rate arr
    this.heartRateArr.push(this.heartRate)
    if (this.heartRateArr.length > SIZE) {
      this.heartRateArr.shift()
    }
    Log.showInfo(TAG, `onHeartRate: heartRateArr = ${JSON.stringify(this.heartRateArr)}`)

    // update time arr
    this.timeArr.push(DateUtils.format(new Date(), 'HH:mm:ss'))
    if (this.timeArr.length > SIZE) {
      this.timeArr.shift()
    }
    Log.showInfo(TAG, `onHeartRate: timeArr = ${JSON.stringify(this.timeArr)}`)

    this.draw()
  }

  onViewSizeChange() {
    Log.showInfo(TAG, `onViewSizeChange: viewWidth = ${this.viewWidth}, viewHeight = ${this.viewHeight}`)
    this.calculateLayoutConfig()
  }

  calculateLayoutConfig() {
    this.mCoordinateLineEndX = this.viewWidth - PADDING_HORIZONTAL
    this.mOffset = (this.viewWidth - START_X - PADDING_HORIZONTAL * 2) / (SIZE - 1)
    this.mHeightRatio = (this.viewHeight - PADDING_VERTICAL * 2 - X_COORDINATE_TEXT_HEIGHT * 2) / MAX_HEART_RATE
    let heartRateCoordinate: number = MAX_HEART_RATE / (COORDINATE_SIZE - 1)
    this.mHeartRateCoordinateArr = [0, heartRateCoordinate, heartRateCoordinate * 2, heartRateCoordinate * 3, heartRateCoordinate * 4]
    Log.showInfo(TAG, `calculateLayoutConfig: mOffset = ${this.mOffset}, mHeightRatio = ${this.mHeightRatio}`)
  }

  draw() {
    this.context.clearRect(0, 0, this.viewWidth, this.viewHeight)
    this.drawCoordinate()
    this.drawHeartRateLine()
  }

  drawCoordinate() {
    this.context.lineWidth = LINE_WIDTH / 3
    this.context.font = '16px sans-serif'

    // draw y-coordinate(heart rate text)
    let path: Path2D = new Path2D()
    this.context.fillStyle = '#999999'
    for (let i = 0; i < COORDINATE_SIZE; i++) {
      let text = `${this.mHeartRateCoordinateArr[i]}bpm`
      let offsetY = (this.viewHeight - PADDING_VERTICAL * 2 - X_COORDINATE_TEXT_HEIGHT * 2) / (COORDINATE_SIZE - 1)
      let x = 0
      let y = this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2 - offsetY * i + this.context.measureText(text)
        .height / 4
      path.moveTo(x, y)
      this.context.fillText(text, x, y)
      this.context.stroke(path)
    }
    // draw coordinate line
    this.context.strokeStyle = '#1A000000'
    for (let i = 0; i < COORDINATE_SIZE; i++) {
      let offsetY = (this.viewHeight - PADDING_VERTICAL * 2 - X_COORDINATE_TEXT_HEIGHT * 2) / (COORDINATE_SIZE - 1)
      let x = START_X + PADDING_HORIZONTAL
      let y = this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2 - offsetY * i
      let path1: Path2D = new Path2D()
      path1.moveTo(x, y)
      path1.lineTo(this.mCoordinateLineEndX, y)
      this.context.stroke(path1)
    }
    // draw x-coordinate(time text)
    this.context.fillStyle = '#999999'
    let path2: Path2D = new Path2D()
    for (let i = 0; i < SIZE; i++) {
      if (this.viewWidth <= WIDTH_CHANGE_POINT && i % 2 === 0) {
        // viewWidth not wide enough, Ignore half of the content and don't draw.
        continue
      }
      let text = this.timeArr[i]
      let x = START_X + this.mOffset * i + PADDING_HORIZONTAL - this.context.measureText(text).width / 2
      let y = this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT
      path2.moveTo(x, y)
      this.context.fillText(text, x, y)
      this.context.stroke(path2)
    }
    // draw x-coordinate(heart rate text)
    this.context.fillStyle = '#333333'
    let path3: Path2D = new Path2D()
    for (let i = 0; i < SIZE; i++) {
      if (this.viewWidth <= WIDTH_CHANGE_POINT && i % 2 === 0) {
        // viewWidth not wide enough, Ignore half of the content and don't draw.
        continue
      }
      let text = `${this.heartRateArr[i]}bpm`
      let x = START_X + this.mOffset * i + PADDING_HORIZONTAL - this.context.measureText(text).width / 2
      let y = this.viewHeight - PADDING_VERTICAL
      path2.moveTo(x, y)
      this.context.fillText(text, x, y)
      this.context.stroke(path3)
    }
  }

  drawHeartRateLine() {
    this.context.lineWidth = LINE_WIDTH
    this.context.strokeStyle = COLOR_LINE

    // draw broken line
    let path: Path2D = new Path2D()
    for (let i = 0; i < SIZE; i++) {
      let x = START_X + this.mOffset * i + PADDING_HORIZONTAL
      let y = this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2 - this.heartRateArr[i] * this.mHeightRatio
      if (i === 0) {
        path.moveTo(x, this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2)
        path.lineTo(x, y)
      } else {
        path.lineTo(x, y)
      }

      if (i === SIZE - 1) {
        path.lineTo(x, this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2)
      }
    }
    var gradient = this.context.createLinearGradient(0, PADDING_VERTICAL, 0, this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2)
    gradient.addColorStop(0.0, '#660A59F7')
    gradient.addColorStop(1.0, '#000A59F7')
    this.context.fillStyle = gradient
    this.context.fill(path)
    this.context.stroke(path)

    // remove excess draw
    this.context.clearRect(START_X + PADDING_HORIZONTAL - LINE_WIDTH / 2, 0, LINE_WIDTH, this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2 + LINE_WIDTH / 2)
    this.context.clearRect(this.viewWidth - PADDING_HORIZONTAL - LINE_WIDTH / 2, 0, LINE_WIDTH, this.viewHeight - PADDING_VERTICAL - X_COORDINATE_TEXT_HEIGHT * 2 + LINE_WIDTH / 2)
  }

  build() {
    Canvas(this.context)
      .width(this.viewWidth)
      .height(this.viewHeight)
      .onReady(() => {
        this.draw()
      })
  }
}