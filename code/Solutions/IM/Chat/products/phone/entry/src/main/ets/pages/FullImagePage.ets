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

import router from '@ohos.router';
import worker, { MessageEvents } from '@ohos.worker';
import common from '@ohos.app.ability.common';

// 动画持续时间
const DURATION: number = 300;
// 初始化捏合指数为2
const FINGERS: number = 2;
// 旋转角度
const ROTATEANGLE = 360;
// 弹窗开启添加延时
const LOADING_DURATION_OPEN: number = 100;
// 遮罩层透明度
const OPACITY: number = 0.4;
// swiper组件导航点rgba值
const INDICATOR_COLOR: string = '#99ffffff';
// 定时器时间间隔
const INTERVAL_TIME: number = 20;

// work线程返回值
class WorkData {
  isComplete: boolean;
  filePath: string;

  constructor(isComplete: boolean, filePath: string) {
    this.isComplete = isComplete;
    this.filePath = filePath;
  }
}

@Entry
@Component
struct FullImagePage {
  @State mediaData: string = (router.getParams() as Record<string, Object>)['resourceUrl'] as string;
  // swiper当前图片地址
  @State imageUrlArray: Array<string> = [];
  // 初始化图片放大倍数
  @State imageScale: number = 1;
  // 是否是图片数据
  @State isImageData: boolean = (router.getParams() as Record<string, Object>)['isMedia'] as boolean;
  // 选中图片的index
  @State imageIndex: number = (router.getParams() as Record<string, Object>)['imageIndex'] as number;
  // 是否多图片
  @State isMultipleImages: boolean = (router.getParams() as Record<string, Object>)['isMultipleImages'] as boolean;
  // 初始化文件加载路径
  @State filePath: string = '';
  // 初始化下载是否完成状态
  @StorageLink('downComplete') downComplete: boolean = true;
  // 初始化下载状态
  @StorageLink('downloadStatus') downloadStatus: boolean = false;
  // 初始化播放总时长
  @StorageLink('videoDuration') videoDuration: number = 0;
  // 初始化播放当前时长
  @StorageLink('videoCurrentTime') videoCurrentTime: number = 0;
  // 旋转角度
  @State rotateAngle: number = 0;
  // 设置可选导航点指示器样式
  private dotIndicator: DotIndicator = new DotIndicator();

  // 下载状态组件
  @Builder
  AnimationComp() {
    if (this.downloadStatus) {
      Stack() {
        Column() {
        }
        .width('100%')
        .height('100%')
        .backgroundColor(Color.Black)
        .opacity(OPACITY)

        Image($r('app.media.loading'))
          .width($r('app.integer.loading_size'))
          .height($r('app.integer.loading_size'))
          .rotate({ angle: this.rotateAngle })
      }.width('100%')
      .height('100%')
      // 脱离文档流，x轴和y轴偏离位置为0
      .position({ x: 0, y: 0 })
    }
  }

  build() {
    Stack({ alignContent: Alignment.TopEnd }) {
      if (!this.isImageData) {
        if (!this.isMultipleImages) {
          // 图片显示模块
          Row() {
            Image(this.mediaData)
              .width($r('app.string.layout_100_percent'))
              .height($r('app.integer.image_height_size'))
              .objectFit(ImageFit.Contain)
              .gesture(
                PinchGesture({ fingers: FINGERS })
                  .onActionUpdate((event: GestureEvent) => {
                    this.imageScale = event.scale;
                  })
              )
          }
          .backgroundColor(Color.Black)
          .justifyContent(FlexAlign.Center)
          .width($r('app.string.layout_100_percent'))
          .height($r('app.string.layout_100_percent'))
        } else {
          Column() {
            Swiper() {
              ForEach(this.imageUrlArray, (item: string) => {
                Image(item)
                  .id('swiperImage')
                  .width($r('app.string.layout_100_percent'))
                  .height($r('app.integer.image_height_size'))
                  .objectFit(ImageFit.Contain)
                  .gesture(
                    PinchGesture({ fingers: FINGERS })
                      .onActionUpdate((event: GestureEvent) => {
                        this.imageScale = event.scale;
                      })
                  )
              })
            }.index(this.imageIndex)
            .indicator(this.dotIndicator.color(INDICATOR_COLOR))
          }.backgroundColor(Color.Black)
          .justifyContent(FlexAlign.Center)
          .width($r('app.string.layout_100_percent'))
          .height($r('app.string.layout_100_percent'))
        }
      } else {
        // 视频显示模块
        Stack({ alignContent: Alignment.Bottom }) {
          Column() {
            Video({ src: `file://${this.filePath}` })
              .width($r('app.integer.video_size'))
              .height($r('app.integer.video_size'))
              .controls(false)
              .autoPlay(true)
              .onPrepared((e) => {
                if (e !== undefined) {
                  this.videoDuration = e.duration;
                }

              })
              .onUpdate((e) => {
                if (e !== undefined) {
                  this.videoCurrentTime = e.time;
                }
              })
          }
          .width($r('app.string.layout_100_percent'))
          .height($r('app.string.layout_100_percent'))
          .backgroundColor(Color.Black)
          .justifyContent(FlexAlign.Center)

          if (this.downComplete) {
            Slider({
              value: this.videoCurrentTime,
              // Slider最小值为0
              min: 0,
              max: this.videoDuration,
              style: SliderStyle.OutSet
            })
              .showTips(true)
              .width($r('app.integer.slide_width_size'))
              .margin({ bottom: $r('app.integer.slide_margin_top') })
          }
        }
      }
      this.AnimationComp();
    }
    .id('mediaPage')
    .onClick(() => {
      router.back();
    })
  }

  aboutToAppear() {
    // 判断是否媒体视频
    if (this.isImageData) {
      this.downloadStatus = true;
      setTimeout(() => {
        this.rotateAnimation();
      }, INTERVAL_TIME)
      this.downLoadFile();
    } else {
      // 判断是否为多图片
      if (this.isMultipleImages) {
        this.imageUrlArray = JSON.parse(this.mediaData);
      }
    }
  }

  aboutToDisappear() {
    if (this.downComplete) {
      this.downComplete = false;
    }
    // 视频总时长和当前时长为0
    this.videoDuration = 0;
    this.videoCurrentTime = 0;
  }

  rotateAnimation() {
    animateTo({
      duration: DURATION,
      curve: Curve.Friction,
      // 动画延迟时间为0
      delay: 0,
      // iterations设置-1表示动画无限循环
      iterations: -1,
      playMode: PlayMode.Normal,
    }, () => {
      this.rotateAngle = ROTATEANGLE;
    })
  }

  // 启动worker发送下载请求
  downLoadFile(): void {
    let workerInstance = new worker.ThreadWorker('entry/ets/pages/workers/worker.ts', {
      name: 'FriendsMoments Worker'
    });
    // 请求网络数据
    let context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    workerInstance.postMessage({ context, mediaData: this.mediaData, isImageData: this.isImageData });
    workerInstance.onmessage = (e: MessageEvents): void => {
      let workData: WorkData = e.data;
      if (workData) {
        this.downComplete = workData.isComplete;
        this.filePath = workData.filePath;
        workerInstance.terminate();
        setTimeout(() => {
          this.downloadStatus = false;
        }, LOADING_DURATION_OPEN)
      }
    }
  }
}
