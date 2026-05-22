/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

@Component
export struct MediaExperiencePage {
  @State isPlaying: boolean = false
  @State progress: number = 0

  build() {
    Column() {
      Text('影音体验')
        .fontSize(32)
        .fontColor('#333333')
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 30 })

      // 视频播放区域
      this.buildVideoPlayer()

      // 音频特性
      this.buildAudioFeatures()

      // 技术规格
      this.buildTechSpecs()
    }
    .width('100%')
    .height('100%')
    .padding(30)
    .backgroundColor('#FFFFFF')
    .borderRadius(16)
  }

  @Builder
  buildVideoPlayer() {
    Column() {
      // 视频预览图
      Stack() {
        Image($r('app.media.video_thumb'))
          .width('100%')
          .height(200)
          .objectFit(ImageFit.Cover)
          .borderRadius(12)

        if (!this.isPlaying) {
          // 播放按钮
          Column() {
            Image($r('app.media.play_icon'))
              .width(60)
              .height(60)
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Center)
          .alignItems(HorizontalAlign.Center)
          .backgroundColor('#80000000')
          .borderRadius(12)
          .onClick(() => {
            this.isPlaying = true
            this.startVideoPlayback()
          })
        } else {
          // 播放控制条
          Column() {
            // 进度条
            Progress({ value: this.progress, total: 100, type: ProgressType.Linear })
              .width('90%')
              .height(4)
              .color('#0A59F7')

            Row() {
              Image($r('app.media.ChildCare'))
                .width(40)
                .height(40)
                .onClick(() => {
                  this.isPlaying = false
                })

              Text('4K演示视频 - 自然风光')
                .fontSize(16)
                .fontColor(Color.White)
                .layoutWeight(1)
                .margin({ left: 15 })
            }
            .width('90%')
            .margin({ top: 15 })
          }
          .width('100%')
          .padding(15)
          .justifyContent(FlexAlign.End)
          .alignItems(HorizontalAlign.Center)
          // .backgroundBlur(10)
          .backgroundColor('#80000000')
          .borderRadius(12)
        }
      }
      .width('100%')
      .height(200)
    }
    .width('100%')
    .margin({ bottom: 30 })
  }

  @Builder
  buildAudioFeatures() {
    Column() {
      Text('音频特性')
        .fontSize(24)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 15 })

      Row() {
        AudioFeatureItem({ title: '杜比全景声', icon: $r('app.media.dolby_icon') })
        AudioFeatureItem({ title: '智能音场', icon: $r('app.media.sound_icon') })
        AudioFeatureItem({ title: '语音增强', icon: $r('app.media.page1') })
      }
      .width('100%')
      .justifyContent(FlexAlign.SpaceAround)
      .margin({ bottom: 20 })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  buildTechSpecs() {
    Column() {
      Text('技术规格')
        .fontSize(24)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .margin({ bottom: 15 })

      Column() {
        TechSpecItem({ name: 'HDR支持', value: 'HDR10+, Dolby Vision' })
        TechSpecItem({ name: '刷新率', value: '120Hz MEMC' })
        TechSpecItem({ name: '色彩深度', value: '10.7亿色' })
        TechSpecItem({ name: '对比度', value: '1000000:1' })
      }
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  startVideoPlayback() {
    // 模拟视频播放进度
    const intervalId = setInterval(() => {
      if (this.isPlaying && this.progress < 100) {
        this.progress += 1
      } else {
        clearInterval(intervalId)
        if (this.progress >= 100) {
          this.isPlaying = false
          this.progress = 0
        }
      }
    }, 100)
  }
}

@Component
struct AudioFeatureItem {
  @Prop title: string
  @Prop icon: Resource

  build() {
    Column() {
      Image(this.icon)
        .width(40)
        .height(40)
        .margin({ bottom: 8 })

      Text(this.title)
        .fontSize(14)
        .fontColor('#333333')
        .textAlign(TextAlign.Center)
    }
    .padding(15)
    .backgroundColor('#F8F9FA')
    .borderRadius(8)
  }
}

@Component
struct TechSpecItem {
  @Prop name: string
  @Prop value: string

  build() {
    Row() {
      Text(this.name)
        .fontSize(16)
        .fontColor('#333333')
        .fontWeight(FontWeight.Medium)
        .width('40%')

      Text(this.value)
        .fontSize(16)
        .fontColor('#666666')
        .textAlign(TextAlign.End)
        .width('60%')
    }
    .width('100%')
    .padding(12)
    .margin({ bottom: 8 })
    .backgroundColor('#F8F9FA')
    .borderRadius(8)
  }
}