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
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  scroller: Scroller = new Scroller();
  build() {
    NavDestination() {
      Scroll(this.scroller) {
        Column({space:10}) {
          Row() {
            // 请将$r('app.string.Progress_Style')替换为实际资源文件，在本示例中该资源文件的value值为"不同进度条样式"
            Text($r('app.string.Progress_Style'))
            Blank()
            // 请将$r('app.string.Progress_Update_Example')替换为实际资源文件，在本示例中该资源文件的value值为"更新进度示例"
            Button($r('app.string.Progress_Update_Example'))
              .onClick((event: ClickEvent) => {
                router.pushUrl({
                  url: 'pages/ProgressCase1'
                })
              })
          }.width('90%')
          // 请将$r('app.string.Linear_Progress')替换为实际资源文件，在本示例中该资源文件的value值为"线性样式进度条"
          Text($r('app.string.Linear_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          // [Start progress_style_1]
          Progress({ value: 20, total: 100, type: ProgressType.Linear }).width(200).height(50)
          Progress({ value: 20, total: 100, type: ProgressType.Linear }).width(50).height(200)
          // [End progress_style_1]

          // 请将$r('app.string.Ring_Progress')替换为实际资源文件，在本示例中该资源文件的value值为"环形无刻度样式进度条"
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

          // 请将$r('app.string.Ring_Progress')替换为实际资源文件，在本示例中该资源文件的value值为"环形有刻度样式进度条"
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

          // 请将$r('app.string.Eclipse_Progress')替换为实际资源文件，在本示例中该资源文件的value值为"圆形样式进度条"
          Text($r('app.string.Eclipse_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          Row({space:40}) {
            // [Start progress_style_4]
            // 从左往右，1号圆形进度条，默认前景色为蓝色
            Progress({ value: 10, total: 150, type: ProgressType.Eclipse }).width(100).height(100)
            // 从左往右，2号圆形进度条，指定前景色为灰色
            Progress({ value: 20, total: 150, type: ProgressType.Eclipse }).color(Color.Grey).width(100).height(100)
            // [End progress_style_4]
          }

          // 请将$r('app.string.Capsule_Progress')替换为实际资源文件，在本示例中该资源文件的value值为"胶囊样式进度条"
          Text($r('app.string.Capsule_Progress')).fontSize(9).fontColor(0xCCCCCC).width('90%')
          Row({space:40}) {
            // [Start progress_style_5]
            Progress({ value: 10, total: 150, type: ProgressType.Capsule }).width(100).height(50)
            Progress({ value: 20, total: 150, type: ProgressType.Capsule }).width(50).height(100).color(Color.Grey)
            Progress({ value: 50, total: 150, type: ProgressType.Capsule }).width(50).height(100).color(Color.Blue).backgroundColor(Color.Black)
            // [End progress_style_5]
          }
        }.width('100%')
      }
      .scale({ x: 0.98 })
      .id('scroll_')
    }
    .backgroundColor('#f1f2f3')
  }
}

