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

export function initRound(context: CanvasRenderingContext2D, air) {
  let width = context.width
  let height = context.height
  // 百分比转换
  let percent = +air.airQuality * 2 / 100 + 0.5
  // 背景
  context.save()
  context.beginPath()
  context.lineWidth = 8
  context.lineCap = 'round'
  context.strokeStyle = "#33FFFFFF"
  context.arc(width / 2, width / 2, width / 2 - 10, Math.PI * 0.3, Math.PI * 0.7, true)
  context.stroke()
  context.closePath()
  context.restore()

  // 绘制圆环
  context.save()
  context.lineWidth = 8
  context.lineCap = 'round'
  context.beginPath()
  // 渐变色
  let color = context.createLinearGradient(0, 0, width, height)
  color.addColorStop(0, '#AED34A')
  color.addColorStop(0.5, '#82CD61')
  color.addColorStop(1, '#82CD61')
  context.strokeStyle = color

  context.arc(width / 2, width / 2, width / 2 - 10, Math.PI * 0.7, Math.PI * percent, false)
  context.stroke()
  context.closePath()
  context.restore()

  // 中间文字
  context.font = '22px'
  context.fillStyle = "#ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText(air.airDesc, width / 2, height / 2 - 20)

  // 中间文字
  context.font = '48px'
  context.fillStyle = "#ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText(air.airQuality, width / 2, height / 2 + 5)

  context.font = '20px'
  context.fillStyle = "#99ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText('0', width / 2 - 30, height - 5)

  context.font = '20px'
  context.fillStyle = "#99ffffff"
  context.textAlign = 'center'
  context.textBaseline = 'middle'
  context.fillText('500', width / 2 + 25, height - 5)
}