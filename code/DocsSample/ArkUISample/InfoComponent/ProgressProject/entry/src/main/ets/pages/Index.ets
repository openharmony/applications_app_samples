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
  scroller: Scroller = new Scroller();
  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({space:10}) {
          Text($r('app.string.Linear_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          // [Start progress_style_1]
          Progress({ value: 20, total: 100, type: ProgressType.Linear }).width(200).height(50)
          Progress({ value: 20, total: 100, type: ProgressType.Linear }).width(50).height(200)
          // [End progress_style_1]

          Text($r('app.string.Ring_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          Row({space:40}) {
            // [Start progress_style_2]
            // 从左往右，1号环形进度条，默认前景色为蓝色渐变，默认strokeWidth进度条宽度为2.0vp
            Progress({ value: 40, total: 150, type: ProgressType.Ring }).width(100).height(100)
            // 从左往右，2号环形进度条
            Progress({ value: 40, total: 150, type: ProgressType.Ring }).width(100).height(100)
              .color(Color.Grey)	// 进度条前景色为灰色
              .style({ strokeWidth: 15})	// 设置strokeWidth进度条宽度为15.0vp
            // [End progress_style_2]
          }

          Text($r('app.string.ScaleRing_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          Row({space:40}) {
            // [Start progress_style_3]
            Progress({ value: 20, total: 150, type: ProgressType.ScaleRing }).width(100).height(100)
              .backgroundColor(Color.Black)
              .style({ scaleCount: 20, scaleWidth: 5 })	// 设置环形有刻度进度条总刻度数为20，刻度宽度为5vp
            Progress({ value: 20, total: 150, type: ProgressType.ScaleRing }).width(100).height(100)
              .backgroundColor(Color.Black)
              .style({ strokeWidth: 15, scaleCount: 20, scaleWidth: 5 })	// 设置环形有刻度进度条宽度15，总刻度数为20，刻度宽度为5vp
            Progress({ value: 20, total: 150, type: ProgressType.ScaleRing }).width(100).height(100)
              .backgroundColor(Color.Black)
              .style({ strokeWidth: 15, scaleCount: 20, scaleWidth: 3 })	// 设置环形有刻度进度条宽度15，总刻度数为20，刻度宽度为3vp
            // [End progress_style_3]
          }

          Text($r('app.string.Eclipse_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          Row({space:40}) {
            // [Start progress_style_4]
            // 从左往右，1号圆形进度条，默认前景色为蓝色
            Progress({ value: 10, total: 150, type: ProgressType.Eclipse }).width(100).height(100)
            // 从左往右，2号圆形进度条，指定前景色为灰色
            Progress({ value: 20, total: 150, type: ProgressType.Eclipse }).color(Color.Grey).width(100).height(100)
            // [End progress_style_4]
          }

          Text($r('app.string.Capsule_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          Row({space:40}) {
            // [Start progress_style_5]
            Progress({ value: 10, total: 150, type: ProgressType.Capsule }).width(100).height(50)
            Progress({ value: 20, total: 150, type: ProgressType.Capsule }).width(50).height(100).color(Color.Grey)
            Progress({ value: 50, total: 150, type: ProgressType.Capsule }).width(50).height(100).color(Color.Blue).backgroundColor(Color.Black)
            // [End progress_style_5]
          }
          // [Start progress_example]
          Progress({value:0, total:100, type:ProgressType.Capsule}).width(200).height(50).value(this.progressValue)
          Row().width('100%').height(5)
          Button("进度条+5")
            .onClick(()=>{
              this.progressValue += 5;
              if (this.progressValue > 100){
                this.progressValue = 0;
              }
            })
          // [End progress_example]
        }.width('100%')
      }.id('scroll_')
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Progress_Style'))
  }
}
