/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
struct ProgressCase1 {
  @State progressValue: number = 0	// 设置进度条初始值为0
  build() {
    Column({space:10}) {
      Text($r('app.string.Linear_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
      Progress({ value: 0, total: 100, type: ProgressType.Linear }).width(200).height(50).value(this.progressValue)
      Progress({ value: 0, total: 100, type: ProgressType.Linear }).width(50).height(100).value(this.progressValue)

      Text($r('app.string.Ring_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
      Row({space:40}) {
        // 从左往右，1号环形进度条，默认前景色为蓝色渐变，默认strokeWidth进度条宽度为2.0vp
        Progress({ value: 0, total: 100, type: ProgressType.Ring }).width(50).height(50).value(this.progressValue)
        // 从左往右，2号环形进度条
        Progress({ value: 0, total: 100, type: ProgressType.Ring }).width(50).height(50)
          .color(Color.Grey)// 进度条前景色为灰色
          .style({ strokeWidth: 15 }) // 设置strokeWidth进度条宽度为15.0vp
          .value(this.progressValue)
      }

      Text($r('app.string.ScaleRing_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
      Row({space:40}) {
        Progress({ value: 0, total: 100, type: ProgressType.ScaleRing }).width(50).height(50)
          .backgroundColor(Color.Black)
          .style({ scaleCount: 20, scaleWidth: 5 }) // 设置环形有刻度进度条总刻度数为20，刻度宽度为5vp
          .value(this.progressValue)
        Progress({ value: 0, total: 100, type: ProgressType.ScaleRing }).width(50).height(50)
          .backgroundColor(Color.Black)
          .style({ strokeWidth: 15, scaleCount: 20, scaleWidth: 5 }) // 设置环形有刻度进度条宽度15，总刻度数为20，刻度宽度为5vp
          .value(this.progressValue)
        Progress({ value: 0, total: 100, type: ProgressType.ScaleRing }).width(50).height(50)
          .backgroundColor(Color.Black)
          .style({ strokeWidth: 15, scaleCount: 20, scaleWidth: 3 }) // 设置环形有刻度进度条宽度15，总刻度数为20，刻度宽度为3vp
          .value(this.progressValue)
      }

      Text($r('app.string.Eclipse_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
      Row({space:40}) {
        // 从左往右，1号圆形进度条，默认前景色为蓝色
        Progress({ value: 0, total: 100, type: ProgressType.Eclipse }).width(50).height(50).value(this.progressValue)
        // 从左往右，2号圆形进度条，指定前景色为灰色
        Progress({ value: 0, total: 100, type: ProgressType.Eclipse }).color(Color.Grey).width(50).height(50).value(this.progressValue)
      }

      Text($r('app.string.Capsule_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
      Row({space:40}) {
        Progress({ value: 0, total: 100, type: ProgressType.Capsule }).width(50).height(50).value(this.progressValue)
        Progress({ value: 0, total: 100, type: ProgressType.Capsule }).width(50).height(50).color(Color.Grey).value(this.progressValue)
        Progress({ value: 0, total: 100, type: ProgressType.Capsule })
          .width(50)
          .height(50)
          .color(Color.Blue)
          .backgroundColor(Color.Black)
          .value(this.progressValue)
      }
      Progress({value:0, total:100, type:ProgressType.Capsule}).width(200).height(50).value(this.progressValue)
      Row().width('100%').height(20)

      Button($r('app.string.progress_add'))
        .onClick(()=>{
          this.progressValue += 5
          if (this.progressValue > 100){
            this.progressValue = 0
          }
        })
      Button($r('app.string.progress_reduce'))
        .onClick(()=>{
          if (this.progressValue >= 5){
            this.progressValue -= 5
          }
        })
    }.width('100%').height('100%')
  }
}
