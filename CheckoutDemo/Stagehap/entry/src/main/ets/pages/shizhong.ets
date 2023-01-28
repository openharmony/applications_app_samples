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


// @ts-nocheck

import router from '@ohos.router';

@Entry
@Component
struct ShiZhongPage {
  @State week_day: [] = ['星期日', '星期一', '星期二', '星期三', '星期四', '星期五', '星期六']
  @State this_day: object = new Date()
  @State hour: number = new Date().getHours()
  @State minute: number = new Date().getMinutes()
  @State second: number = new Date().getSeconds()
  @State second1: number = new Date().getSeconds() - 1
  @State hour_rotate: number = (this.hour * 30 - 90) + (Math.floor(this.minute / 12) * 6)
  @State year: number = new Date().getFullYear()
  @State month: number = new Date().getMonth() + 1 < 10 ? "0" + (new Date().getMonth() + 1) : (new Date().getMonth() + 1)
  @State date: number = new Date().getDate() < 10 ? "0" + (new Date().getDate()) : (new Date().getDate())
  @State R: number = 200
  @State r: number = 160
  @State h: number = 40
  @State w: number = 40
  @State numXY: [] = []
  @State array1: [] = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12]

  aboutToAppear(): void{
    setInterval(() => {
      this.hour = this.hour_rotate + 1
    }, 360000)
    setInterval(() => {
        this.second == 0 && this.minute < 59 ? this.minute = this.minute + 1 : this.minute = this.minute
        this.second < 59 ? this.second + 1 : this.second = 0
        this.second1 < 59 ? this.second1 = this.second1 + 1 : this.second1 = 0
    }, 1000)
  }

  //  private onPageShow():void{
  //    if(this.ciChu){
  //      this.timer1 = setTimeout(() => {
  //        router.push({url:'pages/Video'})
  //      },5000)
  //    }
  //  }

  build() {
    Row() {
      Column() {

        Row() {
          //           画外面的刻度值
          Progress({ value: (this.second / 6 * 10 + 1), style: ProgressStyle.ScaleRing, color: '#fff60707' })
            .height(360)
            .circularStyle({ strokeWidth: 10, scaleCount: 60, scaleWidth: 2 })
            .position({ x: 12, y: 8 })
            .zIndex(29)

          //          写1到12的数字
          Text('1')
            .fontSize(20)
            .position({ x: 280, y: 48 })

          Text('2')
            .fontSize(20)
            .position({ x: 332, y: 110 })

          Text('3')
            .fontSize(20)
            .position({ x: 340, y: 193 })

          Text('4')
            .fontSize(20)
            .position({ x: 313, y: 270 })

          Text('5')
            .fontSize(20)
            .position({ x: 250, y: 320 })

          Text('6')
            .fontSize(20)
            .position({ x: 170, y: 330 })

          Text('7')
            .fontSize(20)
            .position({ x: 90, y: 306 })

          Text('8')
            .fontSize(20)
            .position({ x: 38, y: 243 })

          Text('9')
            .fontSize(20)
            .position({ x: 28, y: 160 })

          Text('10')
            .fontSize(20)
            .position({ x: 58, y: 80 })

          Text('11')
            .fontSize(20)
            .position({ x: 116, y: 35 })

          Text('12')
            .fontSize(20)
            .position({ x: 196, y: 25 })

          //          画一个小圆圈
          Row() {

          }
          .width(6)
          .height(6)
          .borderRadius(3)
          .backgroundColor('#ff08f1f1')
          .position({ x: 199, y: 199 })
          .zIndex(99)

          //          Rour-line
          Row() {

          }
          .width(90)
          .height(8)
          .borderRadius(5)
          .position({ x: 200, y: 198 })
          .zIndex(20)
          .backgroundColor('#FFF60505')
          .shadow({ radius: 10, color: '#aaa', offsetX: 1, offsetY: -3 })
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            centerX: '0%',
            centerY: '50%',
            angle: this.hour_rotate
          })

          //          minute-line
          Row() {

          }
          .width(130)
          .height(5)
          .borderRadius(12)
          .position({ x: 190, y: 198 })
          .zIndex(20)
          .backgroundColor('#dafae20c')
          .shadow({ radius: 10, color: '#aaa', offsetX: 1, offsetY: -3 })
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            centerX: '7.692%',
            centerY: '50%',
            angle: (this.minute * 6 - 90)
          })

          //          second-line
          Row() {

          }
          .width(170)
          .height(1)
          .position({ x: 180, y: 199.5 })
          .zIndex(20)
          .backgroundColor('#ff08f1f1')
          .shadow({ radius: 10, color: '#aaa', offsetX: 1, offsetY: -3 })
          .rotate({
            x: 0,
            y: 0,
            z: 1,
            centerX: '11.765%',
            centerY: '50%',
            angle: (this.second * 6 - 90)
          })

          //          日期 date-info
          Text(this.year + "-" + this.month + "-" + this.date + this.week_day[this.day]) {

          }
          .width(160)
          .height(28)
          .lineHeight(28)
          .textAlign(TextAlign.Center)
          .position({ x: 120, y: 230 })
          .zIndex(11)
          .fontColor('#555')
          .fontWeight(FontWeight.Bold)
          .fontFamily("微软雅黑")

          //          时间
          Row() {
            //            小时时间，PC预览上少了9个小时，不用管
            Text(this.hour < 10 ? "0" + this.hour : '' + this.hour) {

            }
            .width(30)
            .height(30)
            .textAlign(TextAlign.Center)
            .fontColor('#fff')
            .backgroundColor('#555')
            .fontWeight(FontWeight.Bold)

            //            分钟时间
            Text(this.minute < 10 ? "0" + this.minute : '' + this.minute) {

            }
            .width(30)
            .height(30)
            .textAlign(TextAlign.Center)
            .fontColor('#fff')
            .backgroundColor('#555')
            .fontWeight(FontWeight.Bold)
            .border({ left: 1, right: 1 })
            .margin({ left: 1, right: 1 })

            //            秒钟时间
            Text(this.second1 < 10 ? "0" + this.second1 : '' + this.second1) {

            }
            .width(30)
            .height(30)
            .textAlign(TextAlign.Center)
            .fontColor('#fff')
            .backgroundColor('#555')
            .fontWeight(FontWeight.Bold)
          }
          .height(30)
          .position({ x: 154, y: 270 })
          .zIndex(11)
          .shadow({ radius: 10, color: '#222', offsetX: -9, offsetY: -2 })
        }
        .width(400)
        .height(400)
        .border({ width: 10, color: '#333' })
        .shadow({ radius: 10, color: '#444', offsetX: 5, offsetY: 5 })
        .borderRadius(200)
        .margin({ left: 5 })
        .zIndex(10)
        .backgroundColor('#f6f6f6')

      }
      .width('100%')
      .height('100%')
      .margin({ top: 50 })
    }
    .height('100%')
  }
}