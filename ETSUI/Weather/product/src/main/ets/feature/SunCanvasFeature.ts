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

/**
 * 日出日落图
 * @param context
 * @param img
 */
function initSun(context: CanvasRenderingContext2D, img) {
  /*
   * 根据日出日落时间点绘制
   * 获取两个时间点
   * 分割成一个半圆
   * 角度换算刻度
   * 绘制
   */

  let begin = '日出 早上6:00'
  let final = '日落 傍晚5:32'
  let now = new Date()
  let time: number = now.getHours()
  let flag = true // 太阳是否绘制
  let scale: number = Math.floor((time - 6) * 18 / 11)
  if (now.getHours() < 6 || now.getHours() >= 17) {
    flag = false
    scale = 0
  }

  let width = context.width, height = context.height


  // 下线
  context.beginPath()
  context.strokeStyle = "#33ffffff"
  context.setLineDash([])
  context.moveTo(0, height - 54)
  context.lineTo(width, height - 54)
  context.stroke()

  // 文字
  context.font = '20px'
  context.fillStyle = "#99ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText(begin, width / 6, height - 40)

  context.font = '20px'
  context.fillStyle = "#99ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText(final, width / 6 * 5, height - 40)

  // 渐变色
  let color = context.createLinearGradient(0, 0, width, height)
  color.addColorStop(0, '#FFAF38')
  color.addColorStop(scale / 18, '#DDFAD961')
  color.addColorStop(1, '#11FFFFFF')
  context.save()
  context.beginPath()
  context.lineWidth = 1
  if (flag) {
    context.strokeStyle = color
  } else {
    context.strokeStyle = '#33c0c0c0'
  }
  context.arc(width / 2, height - 25, width * 0.4, Math.PI / 180 * 193, Math.PI * 2 / 180 * 173, false)
  context.setLineDash([8])
  context.stroke()
  context.restore()

  if (flag) {
    drawSun()
  }
  // color类型string
  function drawSun() {
    // x为刻度线
    context.save()
    // 弧度*π/180 得到弧度
    let deg = Math.PI / 180 * (193 + scale * 9)
    let offsetX = -(Math.cos(deg) * width * 0.4)
    let offsetY = -(Math.sin(deg) * width * 0.40)

    context.drawImage(img, 0, 0, 120, 120, width / 2 - offsetX - 12, height - 37 - offsetY, 24, 24)
  }
}

/**
 * 月出月落图
 * @param context
 * @param img
 * @param iconMoon
 */
function initMoon(context: CanvasRenderingContext2D, img, iconMoon) {
  /*
    * 根据月出月落时间点绘制
    * 获取两个时间点
    * 分割成一个半圆
    * 角度换算刻度
    * 绘制
    */

  let begin = '月出 傍晚5:12'
  let final = '月落 早上6:20'
  let now = new Date()
  let time: number = now.getHours()
  let flag = true // 月亮是否绘制
  let index: number = time >= 17 ? time - 17 : time + 7
  let scale = Math.floor(index * 18 / 13)
  if (now.getHours() >= 6 && now.getHours() < 17) {
    flag = false
    scale = 0
  }

  let width = context.width, height = context.height

  // 文字
  context.font = '20px'
  context.fillStyle = "#99ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText(begin, width / 6, height - 20)

  context.font = '20px'
  context.fillStyle = "#99ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText('上弦月', width / 2, height - 20)

  context.font = '20px'
  context.fillStyle = "#99ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText(final, width / 6 * 5, height - 20)

  context.drawImage(iconMoon, 0, 0, 16, 16, width / 2 - 5, height - 45, 24, 24)

  // 渐变色
  let color = context.createLinearGradient(0, 0, width, height)
  color.addColorStop(0, '#FFAF38')
  color.addColorStop(scale / 18, '#DDFAD961')
  color.addColorStop(1, '#11FFFFFF')
  context.save()
  context.beginPath()
  context.lineWidth = 1
  if (flag) {
    context.strokeStyle = color
  } else {
    context.strokeStyle = '#33c0c0c0'
  }
  context.arc(width / 2, height - 25, width * 0.3, Math.PI / 180 * 197, Math.PI * 2 / 180 * 171, false)
  context.setLineDash([8])
  context.stroke()
  context.restore()

  if (flag) {
    drawMoon()
  }
  // color类型string
  function drawMoon() {
    // x为刻度线
    context.save()
    // 弧度*π/180 得到弧度
    let deg = Math.PI / 180 * (197 + scale * 9)
    let offsetX = -(Math.cos(deg) * width * 0.3)
    let offsetY = -(Math.sin(deg) * width * 0.3)

    context.drawImage(img, 0, 0, 120, 120, width / 2 - offsetX - 12, height - 37 - offsetY, 24, 24)
  }
}

export { initSun, initMoon }