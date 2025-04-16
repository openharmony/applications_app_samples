/*
 * Copyright (C) 2025 Huawei Device Co., Ltd.
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

import audio from '@ohos.multimedia.audio';
import common from '@ohos.app.ability.common';
import fs from '@ohos.file.fs';
import image from '@ohos.multimedia.image';
import media from '@ohos.multimedia.media';
import { BusinessError } from '@ohos.base';
import CommonConstants from '../constants/Constants';
import { logger } from '../utils/Logger';
// mp4parser 三方库组件
import { IFrameCallBack, ICallBack, MP4Parser } from '@ohos/mp4parser';
// 时间工具
import { TimeUtils } from '../utils/TimeUtils';
// 视频剪辑选项
import { VideoTrimmerOption } from './VideoTrimmerOption';
// 视频帧图片预览列表相关
import { ThumbContent, VideoThumbOption } from './VideoThumbOption';
import { VideoThumbListView } from './VideoThumbListView';
// 视频剪辑选择条相关
import { RangeSeekBarView, MediaPlayerStatus } from './RangeSeekBarView';
import { RangSeekBarListener } from './RangSeekBarListener';
import { RangSeekBarOption } from './RangSeekBarOption';

const TAG: string = 'videoTrimmer_component';

@Component
export struct VideoTrimmerView {
  @Prop @Watch('watchVideoTrimmerOption') videoTrimmerOption: VideoTrimmerOption;

  // 裁剪选项变动时停止播放刷新界面
  watchVideoTrimmerOption() {
    this.configUIInfo();
    this.isPausePreview = true;
    this.waitLoadedInitAVPlayer();
  }

  private isLoadFrame: boolean = false;  // 是否在加载帧数据
  // 视频图片预览区选择区域相关参数
  @State hintText?: string = '拖动选择你要发表的10秒以内片段';
  // 播放进度条位置
  private mRedProgressBarPos: number = 0;
  // 滑动条相关变量
  private mVideoParentHeight: number = 0;
  private mVideoParentWidth: number = 0;
  private mSeekBarWidth: number = 0;
  private mSeekBarHeight: number = 0;
  @State thumbWidth: number = 30; // 滑动宽度
  private thumbLimitLow: number = 6; // 滑动最低限制
  @State paddingLineHeight: number = 10; // 滑动条边框
  private padLimitHigh: number = 20; // 滑动条边框最高限制
  private padLimitLow: number = 2; // 滑动条边框最低限制
  private thumbLimitRate: number = 0.15;
  // 视频总时长
  private mDuration: number = 0;
  // 是否是restore
  private isFromRestore: boolean = false;
  private scroller: Scroller = new Scroller();
  @State ratio: number = 1.0;
  @State currentTime: string = '0';
  @State durationTimeText: string = '100';
  @State descriptionValue: string = '';
  private avPlayer?: media.AVPlayer = undefined;
  private surfaceID: string = '';
  private mXcomponentController: XComponentController = new XComponentController();
  // XComponent 加载状态
  private isLoaded: boolean = false;
  private isTrimming: boolean = false;
  @State videoMaxTime: number = 8; // 8秒
  @State videoMinTime: number = 3; // 最小剪辑时间3s
  @State maxCountRange: number = 8; //seekBar的区域内一共有多少张图片
  // 小图选项
  @State mVideoThumbOption: VideoThumbOption = {
    videoThumbWidth: 0,
    videoThumbs: []
  };
  // 视频剪辑长度选项
  @State mRangSeekBarOption: RangSeekBarOption = {
    mLeftProgressPos: 0,
    mRightProgressPos: 10 * 1000,
    // 最小时间 比如一屏幕10张图 间隔10s, 现在最小时间是3s,那么leftThumb和rightThumb的最小间隔是3张图宽度
    mMinShootTime: 3,
    // 最大时间 约束了右侧thumb和左侧thumb的距离
    mMaxShootTime: 10,
    // 一屏幕展示最大图片数量, 一张图是1s,如果最大数量是20, 最大时间是10s，那么 rightThumb 距离 leftThumb 就是屏幕的10/20
    // 需要保证mMaxCountRange <= mMaxShootTime 否则右侧的thumb会出界
    mMaxCountRange: 10,
    mThumbWidth: 30,
    mPaddingTopBottom: 10
  };
  // 视频播放状态
  @State mMediaPlayerStatus: MediaPlayerStatus = {
    isPlaying: false,
    redLineProgress: 0
  };
  // 剪辑初始时间
  private startTruncationTime: number = 0;
  // 剪辑结束时间
  private endTruncationTime: number = 0;
  // 视频分辨率信息
  private imageWidth: number = 0;
  private imageHeight: number = 0;
  // 压缩命令
  private scaleCmd: string = '';
  @State mRangSeekBarListener: RangSeekBarListener = {
    onRangeSeekBarValuesChanged: (minValue, maxValue) => {
      // 视频裁剪 和 预览的时间范围
      logger.info(TAG, 'RangSeekBarListener minValue=' + minValue + ', maxValue=' + maxValue);
      this.pause();
      this.isPausePreview = true;
      // 裁剪时间段
      this.startTruncationTime = Math.floor(minValue);
      this.endTruncationTime = Math.floor(maxValue);

      this.mMediaPlayerStatus = {
        isPlaying: false,
        redLineProgress: 0
      }
      this.seekTo(this.startTruncationTime);
    },
    onRangeSeekBarScrollChanged: (startPos, endPos) => {
      // 其他操作正在加载帧数据的话，返回
      if(this.isLoadFrame) {
        logger.warn(TAG, 'other operate is LoadFrame, please wait a moment!');
        return;
      }
      this.isLoadFrame = true;
      logger.info(TAG,
        'RangSeekBarListener onRangeSeekBarScrollChanged startPos=' + startPos + ' endPos=' + endPos);
      let videoThumbs = this.mVideoThumbOption.videoThumbs;
      if (videoThumbs == undefined) {
        for (let i = 0; i < this.mDuration; i = i + CommonConstants.MS_ONE_SECOND) {
          let temp = new ThumbContent();
          if (this.videoTrimmerOption.framePlaceholder) {
            temp.framePlaceholder = this.videoTrimmerOption.framePlaceholder;
          }
          if (this.videoTrimmerOption.frameBackground) {
            temp.frameBackground = this.videoTrimmerOption.frameBackground;
          }
          videoThumbs.push(temp);
        }
      }

      let reqStartPos = 0;
      for (let i = startPos; i <= endPos; i = i + 1) {
        if (i < videoThumbs.length && videoThumbs[i] && !videoThumbs[i].pixelMap) {
          reqStartPos = i;
          break;
        } else {
          continue;
        }
      }

      if (reqStartPos > 0) {
        this.videoTrimmerOption.loadFrameListener.onStartLoad()
        let reqCount = endPos - reqStartPos + 1;
        let count = 0;
        let callBack: ICallBack = {
          callBackResult: (code: number) => {
            if (code === 0) {
              // 请求新的帧数据
              let frameCallBack: IFrameCallBack = {
                callBackResult: async (data: ArrayBuffer, timeUs: number) => {
                  const imageSource: image.ImageSource = image.createImageSource(data);

                  let videoThumbWidth = vp2px((this.mSeekBarWidth - 2 * this.thumbWidth) / this.maxCountRange);
                  let videoThumbHeight = vp2px(this.mSeekBarHeight);

                  let decodingOptions: image.DecodingOptions = {
                    sampleSize: 1,
                    editable: true,
                    desiredSize: { width: videoThumbWidth, height: videoThumbHeight },
                    desiredPixelFormat: image.PixelMapFormat.RGBA_8888
                  }
                  imageSource.createPixelMap(decodingOptions).then(px => {
                    let second = timeUs / CommonConstants.US_ONE_SECOND;
                    let framePos = reqStartPos + count;
                    if (second === framePos) {
                      logger.info(TAG, 'second equal framePos, second=' + second + ' timeUs=' + timeUs + ' length=' +
                      videoThumbs.length)
                      videoThumbs[second].pixelMap = px;
                      // 更新加载的视频帧图片
                      this.updateList(videoThumbs);
                      count++;
                      imageSource.release();
                    } else {

                      logger.info(TAG, 'second not equal framePos,  framePos=' + framePos + ' timeUs=' + timeUs);
                      videoThumbs[framePos].pixelMap = px;
                      this.updateList(videoThumbs);
                      count++;
                      imageSource.release();
                    }
                    if (count == reqCount) {
                      this.videoTrimmerOption.loadFrameListener.onFinishLoad();
                      this.isLoadFrame = false;
                    }
                  }).catch((err: Error) => {
                    // 部分视频创建图片异常，直接返回
                    logger.error(TAG, 'createPixelMap Failed, err = ' + err.name + ', message = ' + err.message);
                    this.videoTrimmerOption.loadFrameListener.onFinishLoad();
                    this.isLoadFrame = false;
                  })
                }
              }
              let startTime = reqStartPos * CommonConstants.US_ONE_SECOND + '';
              let endTime = endPos * CommonConstants.US_ONE_SECOND + '';
              // TODO: 知识点: 截取所选时间段的视频
              MP4Parser.getFrameAtTimeRang(startTime, endTime, MP4Parser.OPTION_CLOSEST, frameCallBack);
            } else {
              logger.error(TAG, 'setDataSource fail, error code =' + code.toString());
              // 部分视频创建图片异常，直接返回
              this.videoTrimmerOption.loadFrameListener.onFinishLoad();
              this.isLoadFrame = false;
            }
          }
        }
        // TODO: 知识点: 设置视频源及回调
        MP4Parser.setDataSource(this.videoTrimmerOption.srcFilePath, callBack);
      }
    }
  }

  // 释放播放器
  releaseAvPlayer(): Promise<void> {
    return new Promise((resolve, reject) => {
      if (this && this.avPlayer) {
        this.setOffCallback();
        this.avPlayer?.stop().then(() => {
          this.avPlayer?.release().then(() => {
            resolve();
          })
            .catch((err: BusinessError) => {
              reject(err);
            })
        })
          .catch((err: BusinessError) => {
            reject(err);
          })
      } else {
        reject('this.avPlayer? is not init cannot stop and release!');
      }
    })
  }

  configUIInfo() {
    if (this.videoTrimmerOption.videoMaxTime) {
      this.videoMaxTime = this.videoTrimmerOption.videoMaxTime;
    }
    if (this.videoTrimmerOption.videoMinTime) {
      this.videoMinTime = this.videoTrimmerOption.videoMinTime;
    }
    if (this.videoTrimmerOption.maxCountRange) {
      this.maxCountRange = this.videoTrimmerOption.maxCountRange;
    }
    if (this.videoTrimmerOption.thumbWidth) {
      this.thumbWidth = this.videoTrimmerOption.thumbWidth;
    }
    if (this.videoTrimmerOption.paddingLineHeight) {
      this.paddingLineHeight = this.videoTrimmerOption.paddingLineHeight;
    }

    // 限制maxCountRange的图片最小宽度1vp
    if (this.mSeekBarWidth > 0) {
      let maxVp = (this.mSeekBarWidth - 2 * this.thumbWidth)
      if (this.maxCountRange > maxVp) {
        this.maxCountRange = maxVp;
      }
      // check 限制最大截取时间不超过 maxCountRange
      if (this.videoMaxTime > this.maxCountRange) {
        this.videoMaxTime = this.maxCountRange;
      }
    }
    // 滑动条设置
    if (this.mVideoParentWidth > 0) {
      let thumbLimitHigh = this.mVideoParentWidth * this.thumbLimitRate;
      if (this.thumbWidth > thumbLimitHigh) {
        this.thumbWidth = thumbLimitHigh;
      }
      if (this.thumbWidth < this.thumbLimitLow) {
        this.thumbWidth = this.thumbLimitLow;
      }
    }

    // 滑动条上下边框设置
    if (this.mVideoParentHeight > 0) {
      if (this.paddingLineHeight < this.padLimitLow) {
        this.paddingLineHeight = this.padLimitLow;
      }
      if (this.paddingLineHeight > this.padLimitHigh) {
        this.paddingLineHeight = this.padLimitHigh;
      }
    }
  }

  // 界面销毁监听
  async aboutToDisappear(): Promise<void> {
    // 保证页面销毁 如果还有取帧行为应该及时停止该子线程操作
    MP4Parser.stopGetFrame();
    logger.info(TAG, 'aboutToDisappear success');
    this.setOffCallback();
    await this.avPlayer?.stop();
    await this.avPlayer?.release();
  }

  // 设置播放时间上报监听
  timeUpdate(): void {
    this.avPlayer?.on('timeUpdate', (time: number) => {
      if (!this.isPausePreview) {
        // 播放占比情况
        if (this.avPlayer != undefined) {
          this.mRedProgressBarPos = (this.avPlayer?.currentTime - this.startTruncationTime) * (1.0) /
            (this.endTruncationTime - this.startTruncationTime);
        }
        if (this.mRedProgressBarPos <= 0) {
          this.mRedProgressBarPos = 0;
        }
        if (this.mRedProgressBarPos >= 1) {
          this.mRedProgressBarPos = 1;
        }
        this.mMediaPlayerStatus = {
          isPlaying: true,
          redLineProgress: this.mRedProgressBarPos
        };
      }
      // 当播放的时间大于等于截止时间时候 停止播放
      if (this.avPlayer != undefined && this.avPlayer.currentTime >= this.endTruncationTime) {
        this.isPausePreview = true;
        this.pause();
        this.seekTo(this.startTruncationTime);
        this.mMediaPlayerStatus = {
          isPlaying: false,
          redLineProgress: 0
        };
      }
    })
  }

  // 设置错误监听
  setErrorCallback(): void {
    this.avPlayer?.on('error', (error) => {
      // 输出错误日志
      logger.info(TAG, 'error happened,message is :' + error.message);
    })
  }

  // 注销回调函数接口
  setOffCallback(): void {
    if (this && this.avPlayer) {
      this.avPlayer?.off('volumeChange');
      this.avPlayer?.off('endOfStream');
      this.avPlayer?.off('seekDone');
      this.avPlayer?.off('durationUpdate');
      this.avPlayer?.off('speedDone');
      this.avPlayer?.off('bitrateDone');
      this.avPlayer?.off('bufferingUpdate');
      this.avPlayer?.off('startRenderFrame');
      this.avPlayer?.off('videoSizeChange');
      this.avPlayer?.off('audioInterrupt');
      this.avPlayer?.off('availableBitrates');
      this.avPlayer?.off('error');
      this.avPlayer?.off('stateChange');
    }
  }

  //设置播放surfaceID，播放音频时无需设置
  setSurfaceID(): void {
    if (this && this.avPlayer) {
      this.avPlayer.surfaceId = this.surfaceID;
    }
  }

  // 视频信息上报函数
  async setSourceInfo(): Promise<void> {
    if (this && this.avPlayer) {
      // 音量变化回调函数
      this.avPlayer?.on('volumeChange', (vol: number) => {
        logger.info(TAG, 'volumeChange success,and new volume is :' + vol);
      });
      // 视频播放结束触发回调
      this.avPlayer?.on('endOfStream', () => {
        logger.info(TAG, 'endOfStream success');
      });
      // seek操作回调函数
      this.avPlayer?.on('seekDone', (seekDoneTime: number) => {
        logger.info(TAG, 'seekDone success,and seek time is:' + seekDoneTime);
      });
      // 视频总时长上报函数
      this.avPlayer?.on('durationUpdate', (duration: number) => {
        logger.info(TAG, 'durationUpdate success,and durationUpdate is:' + duration);
      });
      // 设置倍速播放回调函数
      this.avPlayer?.on('speedDone', (speed: number) => {
        logger.info(TAG, 'speedDone success,and speed value is:' + speed + ', speed state is :' + this.getState());
      });
      // bitrate设置成功回调函数
      this.avPlayer?.on('bitrateDone', (bitrate: number) => {
        logger.info(TAG, 'bitrateDone success,and bitrate value is:' + bitrate);
      });
      // 缓冲上报回调函数
      this.avPlayer?.on('bufferingUpdate', (infoType: media.BufferingInfoType, value: number) => {
        logger.info(TAG, 'bufferingUpdate success,and infoType value is:' + infoType + ', value is :' + value);
      });
      // 首帧上报回调函数
      this.avPlayer?.on('startRenderFrame', () => {
        logger.info(TAG, 'startRenderFrame success');
      });
      // 视频宽高上报回调函数
      this.avPlayer?.on('videoSizeChange', (width: number, height: number) => {
        logger.info(TAG, 'videoSizeChange success,and width is:' + width + ', height is :' + height);
      });
      // 焦点上报回调函数
      this.avPlayer?.on('audioInterrupt', (info: audio.InterruptEvent) => {
        // 触发焦点上报后调用暂停接口暂停播放
        this.pause();
        logger.info(TAG, 'audioInterrupt success,and InterruptEvent info is:' + JSON.stringify(info));
      });
      // HLS上报所有支持的比特率
      this.avPlayer?.on('availableBitrates', (bitrates: Array<number>) => {
        logger.info(TAG, 'availableBitrates success,and availableBitrates length is:' + bitrates.length);
      });
    }
  }

  isNext = true;

  // 状态机上报回调函数
  async setStateChangeCallback(): Promise<void> {
    if (this && this.avPlayer) {
      this.avPlayer?.on('stateChange', async (state, reason) => {

        logger.info(TAG, 'stateChange callback function is triggered,state is:' + state + ',reason is :' + reason);
        switch (state) {
          case 'idle':
            logger.info(TAG, 'state idle called');
            break;
          case 'initialized':
            logger.info(TAG, 'state initialized called');
            if (this.isNext) {
              this.setSurfaceID();
              await this.avPlayer?.prepare();
            }
            break;
          case 'prepared':
            // 设置焦点上报类型
            if (this.avPlayer != undefined) {
              this.avPlayer.audioInterruptMode = audio.InterruptMode.INDEPENDENT_MODE;
            }
            this.videoPrepared()
            logger.info(TAG, 'state prepared called ：' + this.getCurrentTime());
            if (this.isPausePreview) {
              this.play();
            }
            this.isNext = false;
            break;
          case 'playing':
            logger.info(TAG, 'state playing called');
            break;
          case 'paused':
            logger.info(TAG, 'state paused called');
            break;
          case 'completed':
            logger.info(TAG, 'state completed called');
            this.isPausePreview = true;
            this.pause();
            this.seekTo(this.startTruncationTime)
            this.mRedProgressBarPos = 0
            this.mMediaPlayerStatus = {
              isPlaying: false,
              redLineProgress: this.mRedProgressBarPos
            };
            break;
          case 'stopped':
            logger.info(TAG, 'state stopped called');
            break;
          case 'released':
            logger.info(TAG, 'state released called');
            break;
          case 'error':
            logger.info(TAG, 'state error called');
            break;
          default:
            logger.info(TAG, 'unkown state :' + state);
            break;
        }
      })
    }
  }

  // 创建AVPlayer实例对象
  async createAVPlayer(): Promise<boolean> {
    logger.info(TAG, 'createAVPlayer start');
    let ret = false;
    if (this.avPlayer !== undefined) {
      await this.avPlayer?.release();
      this.avPlayer = undefined;
    }
    this.avPlayer = await media.createAVPlayer();
    if (this.avPlayer !== undefined) {
      ret = true;
    }
    this.avPlayer.url = this.fdPath;
    logger.info(TAG, 'createAVPlayer end');
    return ret;
  }

  // 调用播放接口
  async play(): Promise<void> {
    logger.info(TAG, 'start to play');
    if (this.avPlayer) {
      logger.info(TAG, 'start to play1');
      this.avPlayer?.play();
      logger.info(TAG, 'start to play2');
    } else {
      logger.info(TAG, ' pause() must init avplayer');
    }
  }

  // 暂停接口
  pause(): void {
    logger.info(TAG, 'start to pause');
    if (this.avPlayer) {
      this.avPlayer?.pause();
    } else {
      logger.info(TAG, ' pause() must init avplayer');
    }
  }

  // 设置倍数接口
  setSpeed(speedValue: number): void {
    logger.info(TAG, 'set speed value is:' + speedValue);
    switch (speedValue) {
      case 0:
        this.avPlayer?.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_0_75_X);
        break;
      case 1:
        this.avPlayer?.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_00_X);
        break;
      case 2:
        this.avPlayer?.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_25_X);
        break;
      case 3:
        this.avPlayer?.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_1_75_X);
        break;
      case 4:
        this.avPlayer?.setSpeed(media.PlaybackSpeed.SPEED_FORWARD_2_00_X);
        break;
      default:
        logger.info(TAG, 'no this mode speed:' + speedValue);
        break;
    }
  }

  // 获取当前播放时间函数
  getCurrentTime(): number {
    if (this.avPlayer != undefined) {
      return this.avPlayer?.currentTime;
    }
    return 0;
  }

  // 获取当前播放状态函数
  getState(): string {
    if (this.avPlayer != undefined) {
      return this.avPlayer.state;
    } else {
      return 'error';
    }
  }

  // 设置loop函数
  setLoop(loopValue: boolean): void {
    if (this.avPlayer != undefined) {
      this.avPlayer.loop = loopValue;
    }
  }

  private onReadNext?: () => void = () => {
  }

  private runNextFunction(nextFunction: () => void) {
    if (!this.isLoaded) {
      this.onReadNext = nextFunction;
    } else {
      nextFunction();
    }
  }

  async waitLoadedInitAVPlayer(): Promise<void> {
    this.runNextFunction(this.initAVPlayer);
  }

  private fdHead: string = 'fd://';
  private fdPath: string = '';
  private fd: number = -1;
  // 初始化函数
  initAVPlayer: () => Promise<void> = async () => {
    logger.info(TAG, 'initAVPlayer success');
    let filePath = '';
    if (this.videoTrimmerOption) {
      filePath = this.videoTrimmerOption.srcFilePath;
    }
    if (filePath.length <= 0) {
      return;
    }

    this.fd = fs.openSync(filePath, fs.OpenMode.READ_ONLY).fd;
    this.fdPath = this.fdHead + this.fd;
    logger.info(TAG, 'filePath=' + filePath + 'videoFd = ' + this.fdPath);
    this.surfaceID = this.mXcomponentController.getXComponentSurfaceId();
    logger.info(TAG, 'surfaceID is : ' + this.surfaceID);
    await this.createAVPlayer();
    this.setStateChangeCallback();
    this.setErrorCallback();
    this.timeUpdate();
    this.setSourceInfo();
  }

  // 界面初始化函数
  aboutToAppear() {
    this.configUIInfo();
    this.isPausePreview = true;
    this.waitLoadedInitAVPlayer();
  }

  onBackPress() {
    this.releaseAvPlayer().then(() => {
      // 释放avPlayer 无需后续操作
    })
  }

  build() {
    Column() {
      // 视频窗口
      this.videoContent();
      // 底部裁剪区
      this.bottomContent();
    }.width($r('app.string.video_trimmer_full_size'))
    .height($r('app.string.video_trimmer_full_size'))
    .backgroundColor(Color.Black)
  }

  @Builder
  private videoContent() {
    Stack({ alignContent: Alignment.Center }) {
      XComponent({
        id: 'componentId',
        type: XComponentType.SURFACE,
        controller: this.mXcomponentController
      })
        .onLoad(async () => {
          this.isLoaded = true;
          // 加载完成后调用初始化播放器函数
          if (this.onReadNext) {
            this.onReadNext();
            this.onReadNext = undefined
          }
        })
        .aspectRatio(this.ratio)
    }
    .onAreaChange((oldValue, newValue) => {
      this.mVideoParentWidth = newValue.width as number;
      this.mVideoParentHeight = newValue.height as number;
    })
    .width($r('app.string.video_trimmer_full_size'))
    .height('75%')
  }

  @Builder
  private bottomContent() {
    Column() {
      // Text(`拖动选择你要发表的${this.videoMaxTime}秒以内片段`)
      Text(this.hintText)
        .fontColor(Color.White)
        .height($r('app.integer.video_trimmer_hit_height'))
      this.userSelectContent()
      this.bottomClickContent()
    }
    .alignItems(HorizontalAlign.Center)
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.string.video_trimmer_bottom_height'))
  }

  @State isPausePreview: boolean = true;

  @Builder
  private bottomClickContent() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Text($r('app.string.video_trimmer_cancel'))
        .id('txt_trimmer_cancel')
        .fontColor(Color.White)
        .textAlign(TextAlign.Center)
        .width($r('app.integer.video_trimmer_btn_width'))
        .height($r('app.integer.video_trimmer_btn_height'))

        .onClick(() => {
          if (this.videoTrimmerOption) {
            this.releaseAvPlayer().then(() => {
              this.videoTrimmerOption.listener.onCancel()
            }).catch((err: BusinessError) => {

              logger.info(TAG, 'VideoTrimmerView onCancel avplayer.stop() Or avplayer.release() err=' +
              (err as BusinessError).message)
              this.videoTrimmerOption.listener.onCancel()
            })
          }
        })

      Image(this.isPausePreview ? $r('app.media.video_trimmer_icon_pause') : $r('app.media.video_trimmer_icon_play'))
        .id('txt_trimmer_play')
        .height($r('app.integer.video_trimmer_video_item_news_image_height'))
        .width($r('app.integer.video_trimmer_video_item_news_image_height'))
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          // 改变状态
          this.isPausePreview = !this.isPausePreview;

          if (this.isPausePreview) {
            //  暂停
            this.mMediaPlayerStatus = {
              isPlaying: false,
              redLineProgress: this.mRedProgressBarPos
            };
            // 暂停视频播放
            this.pause();
          } else {
            // 开始预览视频
            this.play();
          }
        })

      Text($r('app.string.video_trimmer_finish'))
        .fontColor($r('app.color.video_trimmer_finish_color'))
        .id('txt_trimmer_finish')
        .textAlign(TextAlign.Center)
        .width($r('app.integer.video_trimmer_btn_width'))
        .height($r('app.integer.video_trimmer_btn_height'))
        .onClick(() => {
          if (this.isTrimming) {
            return;
          }
          this.isTrimming = true;
          if (this.videoTrimmerOption) {
            // 开始裁剪
            this.videoTrimmerOption.listener.onStartTrim();
          }

          // 最后一帧保护
          let sTime1 = 0;
          let eTime1 = 0;
          let lastFrameTime =
            Math.floor(this.mDuration / CommonConstants.MS_ONE_SECOND) * CommonConstants.MS_ONE_SECOND;
          if (this.endTruncationTime > lastFrameTime) {
            eTime1 = lastFrameTime;
            sTime1 = eTime1 - (this.endTruncationTime - this.startTruncationTime);
            eTime1 += CommonConstants.MS_ONE_SECOND; // 补偿1s
          } else {
            sTime1 = this.startTruncationTime;
            eTime1 = this.endTruncationTime;
          }
          // 选取的裁剪时间段
          let sTime = TimeUtils.msToHHMMSS(sTime1);
          let eTime = TimeUtils.msToHHMMSS(eTime1);

          let srcFilePath = this.videoTrimmerOption.srcFilePath;
          // 保留原来的文件名
          let fileName: string | undefined = srcFilePath!.split('/').pop()!.split('.')[0];
          // 组装剪辑后的文件路径(以 原来的文件名+当前时间 命名)
          let outFilePath: string =
            getContext(this).cacheDir + '/' + fileName + '_' + TimeUtils.format(new Date()) + '.mp4';
          // 剪辑回调函数
          let callback: ICallBack = {
            callBackResult: (code: number) => {
              if (code === 0) {
                if (this.videoTrimmerOption) {
                  // 通知上层调用
                  this.videoTrimmerOption.listener.onFinishTrim(outFilePath);
                  this.isTrimming = false;
                }
              }
            }
          }
          // TODO: // 知识点： 根据开始、结束时间，视频源以及目标文件地址对视频进行剪辑
          this.videoClip(sTime, eTime, srcFilePath, outFilePath, this.scaleCmd, callback);
        })
    }
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.string.video_trimmer_half_height'))
  }

  /**
   * 用户选择视频事件范围区域
   */
  @Builder
  private userSelectContent() {
    Stack() {
      Column() {
        Stack() {
        }
        .width($r('app.string.video_trimmer_full_size'))
        .height($r('app.string.video_trimmer_rangeSeekBar_height'))

        // 加载的视频帧图片列表组件
        VideoThumbListView({ scroller: this.scroller, mVideoThumbOption: this.mVideoThumbOption })
          .width($r('app.string.video_trimmer_full_size'))
          .height($r('app.string.video_trimmer_list_height'))
      }.margin({ left: this.thumbWidth, right: this.thumbWidth })

      // 视频剪辑时间长度选择组件
      RangeSeekBarView({
        scroller: this.scroller,
        mRangSeekBarOption: this.mRangSeekBarOption,
        mMediaPlayerStatus: this.mMediaPlayerStatus,
        mRangSeekBarListener: this.mRangSeekBarListener
      })
        .width($r('app.string.video_trimmer_full_size'))
        .height($r('app.string.video_trimmer_full_size'))
        .onAreaChange((oldValue, newValue) => {
          this.mSeekBarWidth = newValue.width as number;
          this.mSeekBarHeight = newValue.height as number;
          this.configUIInfo();
        })
    }
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.integer.video_trimmer_user_select_height'))
  }

  videoPrepared() {
    // 提示语设置
    this.hintText = this.getFormatString($r('app.string.video_trimmer_hint'), `${this.videoMaxTime}`)
    // 宽高比 设置
    if (this.avPlayer != undefined) {
      let videoWidth = this.avPlayer.width;
      let videoHeight = this.avPlayer.height;
      this.ratio = videoWidth * (1.0) / videoHeight;
      logger.info(TAG, 'this.ratio=' + this.ratio);
    }

    // 设置当前Video 总时长
    if (this.avPlayer != undefined) {
      this.mDuration = this.avPlayer.duration;
      logger.info(TAG, 'this.mDuration =' + this.mDuration.toString());
    }
    // 默认的截取时间段[0-Nath.min(videoMaxTime,mDuration)]
    this.startTruncationTime = 0;
    this.endTruncationTime = Math.min(this.videoMaxTime * CommonConstants.MS_ONE_SECOND, this.mDuration);

    if (!this.getRestoreState()) {
      this.seekTo(this.mRedProgressBarPos);
    } else {
      this.setRestoreState(false);
      this.seekTo(this.mRedProgressBarPos);
    }
    // 初始化剪辑区域图片列表
    this.initImageList();
    // 初始化剪辑区域
    this.initRangeSeekBarView();
  }

  /**
   * 初始化剪辑区域图片列表
   */
  initImageList() {
    // 将视频长度分割为一秒一张图片
    let videoThumbs: ThumbContent[] = [];
    for (let i = 0; i < this.mDuration; i = i + CommonConstants.MS_ONE_SECOND) {
      let temp = new ThumbContent();

      if (this.videoTrimmerOption.framePlaceholder) {
        temp.framePlaceholder = this.videoTrimmerOption.framePlaceholder;
      }
      if (this.videoTrimmerOption.frameBackground) {
        temp.frameBackground = this.videoTrimmerOption.frameBackground;
      }
      videoThumbs.push(temp);
    }

    let firstLoadMax = this.maxCountRange;
    if (this.mDuration / CommonConstants.MS_ONE_SECOND < this.maxCountRange) {
      firstLoadMax = Math.ceil(this.mDuration / CommonConstants.MS_ONE_SECOND);
    }

    this.isLoadFrame = true;
    let callBack: ICallBack = {
      callBackResult: (code: number) => {
        if (code === 0) {
          let count = 0;

          let frameCallBack: IFrameCallBack = {
            callBackResult: async (data: ArrayBuffer, timeUs: number) => {
              const imageSource: image.ImageSource = image.createImageSource(data);
              // TODO: 知识点: 如果要压缩分辨率，则加载第一张图时（根据this.imageWidth === 0做判断），获取视频的压缩分辨率相关参数信息，生成视频压缩命令
              if (this.videoTrimmerOption!.scaleNum! > 0 &&
                this.videoTrimmerOption!.scaleNum !== CommonConstants.SCALE_NUM &&
                this.imageWidth === 0) {
                // 读取图片信息
                const imageInfo: image.ImageInfo = await imageSource!.getImageInfo();
                this.imageWidth = imageInfo.size.width;
                this.imageHeight = imageInfo.size.height;
                // 生成视频压缩命令
                this.scaleCmd =
                  'scale=' +
                  ((this.imageWidth / CommonConstants.SCALE_NUM) * this.videoTrimmerOption!.scaleNum!).toString() +
                    ':' +
                  ((this.imageHeight / CommonConstants.SCALE_NUM) * this.videoTrimmerOption!.scaleNum!).toString()
                logger.info(TAG,
                  'init imageSize width = ' + this.imageWidth.toString() + ' height =' + this.imageHeight.toString() +
                    ', scaleNum = ' + this.videoTrimmerOption!.scaleNum?.toString());
              }
              // 根据SeekBar尺寸生成小图参数
              let videoThumbWidth: number = vp2px((this.mSeekBarWidth - 2 * this.thumbWidth) / this.maxCountRange);
              let videoThumbHeight: number = vp2px(this.mSeekBarHeight);
              let decodingOptions: image.DecodingOptions = {
                sampleSize: 1,
                editable: true,
                desiredSize: { width: videoThumbWidth, height: videoThumbHeight },
                desiredPixelFormat: image.PixelMapFormat.RGBA_8888
              };
              // TODO: 知识点: 使用回调函数中的ArrayBuffer数据生成小图，更新到小图列表中
              imageSource.createPixelMap(decodingOptions).then((px: image.PixelMap) => {
                let second = timeUs / CommonConstants.US_ONE_SECOND;
                let framePos = count;
                if (second === framePos) {
                  logger.info(TAG,
                    'framePos equal second, second=' + second + ' timeUs=' + timeUs + ' length=' + videoThumbs.length);
                  videoThumbs[second].pixelMap = px;
                  this.updateList(videoThumbs);
                  count++;
                  imageSource.release();
                } else {
                  logger.info(TAG, 'framePos not equal second, framePos=' + framePos + ' timeUs=' + timeUs);
                  videoThumbs[framePos].pixelMap = px;
                  this.updateList(videoThumbs);
                  count++;
                  imageSource.release();
                }
                // 获取到所需的图片数量后，停止获取
                if (count == firstLoadMax) {
                  this.videoTrimmerOption.loadFrameListener.onFinishLoad();
                  this.isLoadFrame = false;
                }
              }).catch((err: Error) => {
                // 部分视频创建图片异常，直接返回
                logger.error(TAG, 'createPixelMap Failed, err = ' + err.name + ', message = ' + err.message);
                this.videoTrimmerOption.loadFrameListener.onFinishLoad();
                this.isLoadFrame = false;
              })
            }
          }
          // TODO: 知识点: 根据开始、结束时间，通过MP4Parser.getFrameAtTimeRang命令循环生成小图
          let startTime = 0 * CommonConstants.US_ONE_SECOND + '';
          let endTime = (firstLoadMax - 1) * CommonConstants.US_ONE_SECOND + '';
          // 通过开始、结束时间，回调函数，获取视频小图
          MP4Parser.getFrameAtTimeRang(startTime, endTime, MP4Parser.OPTION_CLOSEST, frameCallBack);
        } else {
          logger.info(TAG, 'setDataSource fail, error code =' + code.toString());
        }
      }
    }
    this.videoTrimmerOption.loadFrameListener.onStartLoad();
    // 设置视频源和回调函数
    MP4Parser.setDataSource(this.videoTrimmerOption.srcFilePath, callBack);
    logger.info(TAG, 'initList list size=' + videoThumbs.length);
    this.updateList(videoThumbs);
  }

  // 更新小图列表
  updateList(videoThumbs: ThumbContent[]) {
    this.mVideoThumbOption = {
      videoThumbWidth: (this.mSeekBarWidth - 2 * this.thumbWidth) / this.maxCountRange,
      videoThumbs: videoThumbs
    }
  }

  // 初始视频选择区域范围
  initRangeSeekBarView() {
    this.mRangSeekBarOption = {
      mLeftProgressPos: 0,
      mRightProgressPos: this.mDuration,
      // 最小时间 比如一屏幕10张图 间隔10s, 现在最小时间是3s,那么leftThumb和rightThumb的最小间隔是3张图宽度
      mMinShootTime: this.videoMinTime,
      // 最大时间 约束了右侧thumb和左侧thumb的距离
      mMaxShootTime: this.videoMaxTime,
      // 一屏幕展示最大图片数量, 一张图是1s,如果最大数量是20, 最大时间是10s，那么 rightThumb 距离 leftThumb 就是屏幕的10/20
      // 需要保证mMaxCountRange <= mMaxShootTime 否则右侧的thumb会出界
      mMaxCountRange: this.maxCountRange,
      mThumbWidth: this.thumbWidth,
      mPaddingTopBottom: this.paddingLineHeight
    };
  }

  getRestoreState(): boolean {
    return this.isFromRestore;
  }

  // 设置播放位置
  seekTo(msec: number) {
    if (this && this.avPlayer) {
      this.avPlayer?.seek(msec);
    }
  }

  setRestoreState(fromRestore: boolean) {
    this.isFromRestore = fromRestore;
  }

  // 获取选择时间范围后的提示信息
  getFormatString(res: Resource, instead: string): string {
    let resId = res.id;
    let ctx = this.videoTrimmerOption.context;
    if (ctx != undefined) {
    } else {
      ctx = getContext(this) as common.UIAbilityContext;
    }

    let ret: string = '';
    let resMgr = ctx.resourceManager;
    try {
      let value = resMgr.getStringSync(resId);
      let values = value.split('%s');
      ret = values[0] + instead + values[1];
    } catch (error) {
      logger.info(TAG, 'VideTrimmerView getFormatString has error msg:' + (error as BusinessError).message);
    }
    logger.info(TAG, 'getFormatString success, ret = ' + ret);
    return ret;
  }

  // TODO: 知识点: 视频剪辑。scaleCmd为视频压缩命令
  videoClip(sTime: string, eTime: string, srcFilePath: string, outFilePath: string, scaleCmd: string,
    callback: ICallBack) {
    let ffmpegCmd: string = '';
    if (scaleCmd !== '') {
      ffmpegCmd =
        'ffmpeg -y -i ' + srcFilePath + ' -vf ' + scaleCmd + ' -c:v mpeg4 -c:a aac -ss ' + sTime + ' -to ' + eTime +
          ' ' + outFilePath;
    } else {
      ffmpegCmd = 'ffmpeg -y -i ' + srcFilePath + ' -c:v mpeg4 -c:a aac -ss ' + sTime + ' -to ' + eTime +
        ' ' + outFilePath;
    }
    logger.info(TAG, 'videoClip cmd: ' + ffmpegCmd);
    MP4Parser.ffmpegCmd(ffmpegCmd, callback);
  }
}





