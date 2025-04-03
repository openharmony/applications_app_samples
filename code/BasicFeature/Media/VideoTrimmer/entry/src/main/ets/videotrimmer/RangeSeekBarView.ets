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

/**
 * 视频剪辑时间长度选择组件
 */

import CommonConstants from '../constants/Constants';
import { logger } from '../utils/Logger';
import { RangSeekBarListener } from './RangSeekBarListener';
import { RangSeekBarOption } from './RangSeekBarOption';
import { TimeUtils } from '../utils/TimeUtils';

const TAG: string = 'videoTrimmer_SeekBar';

/**
 * 视频播放状态
 */
export class MediaPlayerStatus {
  public redLineProgress: number = 0; // [0,1]
  public isPlaying: boolean = false; // true播放 false暂停
}

@Component
export struct RangeSeekBarView {
  // 裁剪选择区域变动时刷新界面
  @Prop @Watch('watchRangSeekBarOption') mRangSeekBarOption: RangSeekBarOption;

  watchRangSeekBarOption() {
    this.configUI();
    this.initUIRange();
  }

  // 播放状态发生变动时刷新界面
  @Prop @Watch('watchMediaPlayerStatus') mMediaPlayerStatus: MediaPlayerStatus;

  watchMediaPlayerStatus() {
    if (this.mMediaPlayerStatus) {
      this.showRedProgress = this.mMediaPlayerStatus.isPlaying;
      this.touchEnable = !this.mMediaPlayerStatus.isPlaying;
      this.redLinePosition = {
        x: this.leftThumbRect[2] + this.transparentWidth * this.mMediaPlayerStatus.redLineProgress,
        y: this.topPaddingWidth
      };
    }
  }

  // 视频选取范围侦听回调
  @Require mRangSeekBarListener?: RangSeekBarListener;
  @State leftThumbWidth: number = 30;
  @State rightThumbWidth: number = 30;
  @State topPaddingWidth: number = 10;
  @State bottomPaddingWidth: number = 10;
  @State transparentWidth: number = 0;
  // 可滑动组件的整体宽度
  @State seekCompWidth: number = 0;
  // 可滑动组件的整体高度
  @State seekCompHeight: number = 0;
  // 整个组件的宽度
  componentMaxWidth: number = 0;
  // 整个组件的高度
  componentMaxHeight: number = 0;
  // 侦听选择区域变动
  @Prop @Watch('watchComponentRect') componentRect: Array<number> = [];

  watchComponentRect() {
    logger.info(TAG, 'watchComponentRect = ' + JSON.stringify(this.componentRect));
  }

  // 侦听左边区域变动
  @Prop @Watch('watchLeftThumbRect') leftThumbRect: Array<number> = [];

  watchLeftThumbRect() {
    logger.info(TAG, 'watchLeftThumb =' + JSON.stringify(this.leftThumbRect));
  }

  // 侦听右边区域变动
  @Prop @Watch('watchLeftThumbRect') rightThumbRect: Array<number> = [];

  watchRightThumbRect() {
    logger.info(TAG, 'watchRightThumbRect =' + JSON.stringify(this.rightThumbRect))
  }

  // 触摸位置相关参数
  touchLeftThumb = 1;
  touchRightThumb = 2;
  touchHorScroll = 3;
  touchStatus: number = this.touchHorScroll;
  touchXOld = 0;
  touchDeltaX = 0;
  @State leftThumbPosition: Position = { x: 0, y: 0 };
  @State rightThumbPosition: Position = { x: 0, y: 0 };
  @State middenPosition: Position = { x: 0, y: 0 };
  @State redLinePosition: Position = { x: 0, y: 0 };
  // 左边可滑动条状物 左边间距
  leftPadding = 0;
  // 右边可滑动条状物 右边间距
  rightPadding = 0;
  // 左右可滑动条状物 之间的最小间距
  leftRightPaddingMin = 0;
  // 左右可滑动条状物 之间的最大间距
  leftRightPaddingMax = 0;
  // 一秒钟所占的PX宽度
  msPxAvg: number = 0;
  scroller: Scroller = new Scroller();
  // 滑动速度
  speed: number = 0;
  // 播放状态不响应触碰
  touchEnable: boolean = true;
  // 手势相关参数界面配置
  private panOption: PanGestureOptions = new PanGestureOptions({ direction: PanDirection.Left | PanDirection.Right });
  @State leftText: string = '00:00:00';
  @State rightText: string = '00:00:10';
  @State leftTextPosition: Position = { x: 0, y: 0 };
  @State rightTextPosition: Position = { x: 0, y: 0 };
  // 显示播放进度
  @State showRedProgress: boolean = false;
  leftTextWidth: number = 60;
  rightTextWidth: number = 60;

  aboutToAppear() {
    this.configUI();
  }

  build() {
    Column() {
      // 选取的时间范围界面
      Stack() {
        Text(this.leftText)
          .id('txt_left_time')
          .width(this.leftTextWidth)
          .height($r('app.string.video_trimmer_full_size'))
          .textAlign(TextAlign.Start)
          .position(this.leftTextPosition)
          .fontSize($r('app.integer.video_trimmer_font_size_12'))
          .fontColor(Color.White)

        Text(this.rightText)
          .id('txt_right_time')
          .width(this.rightTextWidth)
          .height($r('app.string.video_trimmer_full_size'))
          .textAlign(TextAlign.End)
          .position(this.rightTextPosition)
          .fontSize($r('app.integer.video_trimmer_font_size_12'))
          .fontColor(Color.White)
      }
      .width(this.seekCompWidth)
      .height($r('app.string.video_trimmer_rangeSeekBar_height'))

      Stack() {
        // 背景框
        Flex({ justifyContent: FlexAlign.SpaceBetween, direction: FlexDirection.Column }) {
          Row() {
          }
          .width($r('app.string.video_trimmer_full_size'))
          .height(this.topPaddingWidth)
          .backgroundColor(Color.White)

          Row() {
          }
          .width($r('app.string.video_trimmer_full_size'))
          .height(this.bottomPaddingWidth)
          .backgroundColor(Color.White)
        }
        .width(this.transparentWidth)
        .height($r('app.string.video_trimmer_full_size'))
        .backgroundColor(Color.Transparent)
        .position(this.middenPosition)

        // 播放进度条
        Stack() {
        }
        .width(1)
        .height(this.seekCompHeight - this.topPaddingWidth - this.bottomPaddingWidth)
        .backgroundColor(Color.Red)
        .visibility(this.showRedProgress ? Visibility.Visible : Visibility.None)
        .position(this.redLinePosition)

        // 左右选择图片
        Image($r('app.media.video_trimmer_thumb_handle'))
          .id('left_thumb_handle')
          .objectFit(ImageFit.Fill)
          .width(this.leftThumbWidth)
          .height($r('app.string.video_trimmer_full_size'))
          .position(this.leftThumbPosition)
        Image($r('app.media.video_trimmer_thumb_handle'))
          .id('right_thumb_handle')
          .objectFit(ImageFit.Fill)
          .width(this.leftThumbWidth)
          .height($r('app.string.video_trimmer_full_size'))
          .position(this.rightThumbPosition)
      }
      .width(this.seekCompWidth)
      .height('85%')
      .onAreaChange((oldValue, newValue) => {
        this.seekCompHeight = newValue.height as number;
      })
    }
    .width($r('app.string.video_trimmer_full_size'))
    .height($r('app.string.video_trimmer_full_size'))
    .enabled(this.touchEnable)
    .onAreaChange((oldValue, newValue) => {
      this.componentMaxWidth = newValue.width as number;
      this.componentMaxHeight = newValue.height as number;
      this.initUIRange();
    })
    // 绑定手势
    .parallelGesture(
      PanGesture(this.panOption)// 根据手势计算选择视频区间的时间位置
        .onActionStart((event?: GestureEvent) => {
          if (this.touchInThumb(event)) {
            // 左边滑块移动
            if (this.touchInLeftThumb(event)) {
              this.touchStatus = this.touchLeftThumb;
            } else if (this.touchInRightThumb(event)) {
              // 右边滑块移动
              this.touchStatus = this.touchRightThumb;
            }
          }
          this.touchXOld = this.clearUndefined(event?.offsetX);
        })
        .onActionUpdate((event?: GestureEvent) => {
          let touchXNew: number = this.clearUndefined(event?.offsetX);
          let delTax: number = touchXNew - this.touchXOld;
          // 左边滑块移动
          if (this.touchStatus == this.touchLeftThumb) {
            this.leftThumbUpdate(delTax);
          } else if (this.touchStatus == this.touchRightThumb) {
            // 右边滑块移动
            this.rightThumbUpdate(delTax);
          } else if (this.touchStatus == this.touchHorScroll) {
            this.scrollUpdate(delTax);
          }
          this.touchDeltaX = delTax;
          this.touchXOld = this.clearUndefined(event?.offsetX);
        })
        .onActionEnd((event?: GestureEvent) => {
          this.touchStatus = this.touchHorScroll;
          this.onRangeStopScrollChanged();
        })
    )
    .parallelGesture(
      SwipeGesture({ direction: SwipeDirection.Horizontal })
        .onAction((event?: GestureEvent) => {
          this.speed = this.clearUndefined(event?.speed);

          logger.info(TAG, 'SwipeGesture onAction speed =' + this.speed);
        })
    )
  }

  // 配置界面UI位置
  configUI() {
    if (this.mRangSeekBarOption.mThumbWidth) {
      this.leftThumbWidth = this.mRangSeekBarOption.mThumbWidth;
      this.rightThumbWidth = this.mRangSeekBarOption.mThumbWidth;
    }
    if (this.mRangSeekBarOption.mPaddingTopBottom) {
      this.topPaddingWidth = this.mRangSeekBarOption.mPaddingTopBottom;
      this.bottomPaddingWidth = this.mRangSeekBarOption.mPaddingTopBottom;
    }
  }

  // 初始化视频剪辑范围
  initUIRange() {
    this.componentRect = [0, 0, this.componentMaxWidth, this.componentMaxHeight];

    this.leftThumbRect = [0, 0, this.leftThumbWidth, this.componentMaxHeight];
    this.leftThumbPosition = { x: this.leftThumbRect[0], y: this.leftThumbRect[1] };
    this.leftTextPosition = { x: this.leftThumbRect[0], y: this.leftThumbRect[1] };

    if (this.mRangSeekBarOption) {
      this.msPxAvg = ((this.componentMaxWidth - (this.leftThumbWidth + this.rightThumbWidth)) * 1000.0) /
      this.mRangSeekBarOption.mMaxCountRange;
      this.leftRightPaddingMax =
        ((this.mRangSeekBarOption.mMaxShootTime * 1.0) / this.mRangSeekBarOption.mMaxCountRange) *
          (this.componentMaxWidth - (this.leftThumbWidth + this.rightThumbWidth));
      this.leftRightPaddingMin =
        ((this.mRangSeekBarOption.mMinShootTime * 1.0) / this.mRangSeekBarOption.mMaxCountRange) *
          (this.componentMaxWidth - (this.leftThumbWidth + this.rightThumbWidth));
    }

    // 获取当前右边界
    let rightMax = this.mRangSeekBarOption.mRightProgressPos / 1000;
    // 视频时间小于录制最大时间情况
    if (rightMax <= this.mRangSeekBarOption.mMaxShootTime) {
      // 最大距离需要重置为 视频时间
      this.leftRightPaddingMax = ((rightMax * 1.0) / this.mRangSeekBarOption.mMaxCountRange) *
        (this.componentMaxWidth - (this.leftThumbWidth + this.rightThumbWidth));
    } else {
      rightMax = this.mRangSeekBarOption.mMaxShootTime;
    }

    // 由于mMaxShootTime <= mMaxCountRange 所以这个值必定在 当前页面内
    let right2LeftDistance = rightMax * (this.msPxAvg / 1000.0);

    this.rightThumbRect =
      [this.leftThumbRect[2] + right2LeftDistance, 0, this.leftThumbRect[2] + right2LeftDistance + this.rightThumbWidth,
        this.componentMaxHeight];
    this.rightThumbPosition = { x: this.rightThumbRect[0], y: this.rightThumbRect[1] };
    this.rightTextPosition = { x: this.rightThumbRect[2] - this.rightTextWidth, y: this.rightThumbRect[1] };

    this.seekCompWidth = this.componentMaxWidth;
    this.middenPosition = { x: this.leftThumbRect[2], y: this.leftThumbRect[1] };
    this.transparentWidth = right2LeftDistance;
    this.leftText = this.showThumbText(this.mRangSeekBarOption.mLeftProgressPos);
    this.rightText = this.showThumbText(Math.min(this.mRangSeekBarOption.mRightProgressPos,
      this.mRangSeekBarOption.mMaxShootTime * 1000));
  }

  // 更新左边滑块位置
  leftThumbUpdate(deltaX: number) {
    let deltaPx = deltaX;
    // 左边距
    if (deltaPx <= 0 && ((this.leftThumbRect[0] + deltaPx) <= this.leftPadding)) {
      deltaPx = this.leftPadding - this.leftThumbRect[0];
    }
    // 右边距
    if (deltaPx >= 0 && ((this.leftThumbRect[2] + deltaPx) >= (this.rightThumbRect[0] - this.leftRightPaddingMin))) {
      deltaPx = (this.rightThumbRect[0] - this.leftRightPaddingMin) - this.leftThumbRect[2];
    }
    // 左边界 新增与右thumb的最大边距
    if (deltaPx <= 0 && ((this.leftThumbRect[2] + deltaPx) <= (this.rightThumbRect[0] - this.leftRightPaddingMax))) {
      deltaPx = (this.rightThumbRect[0] - this.leftRightPaddingMax) - this.leftThumbRect[2];
    }

    let newArea = [
      (this.leftThumbRect[0] + deltaPx),
      this.leftThumbRect[1],
      (this.leftThumbRect[2] + deltaPx),
      this.leftThumbRect[3]];

    this.leftThumbRect = newArea;
    this.leftThumbPosition = { x: newArea[0], y: newArea[1] };
    this.leftTextPosition = { x: newArea[0], y: newArea[1] };

    this.middenPosition = { x: this.leftThumbRect[2], y: this.leftThumbRect[1] };
    this.transparentWidth = this.rightThumbRect[0] - this.leftThumbRect[2];
    // 更新选取视频时间
    this.onRangeValueChanged();
  }

  // 调用时间转换函数显示时间
  showThumbText(time: number): string {
    return TimeUtils.msToHHMMSS(time);
  }

  // 选取时间变动事件
  onRangeValueChanged() {
    let x0: number = this.scroller.currentOffset().xOffset;
    let start: number = x0 + this.leftThumbRect[2] - this.leftThumbWidth;
    let end: number = start + this.transparentWidth;

    let startTime: number = start * CommonConstants.US_ONE_SECOND / this.msPxAvg;
    this.leftText = this.showThumbText(startTime);
    let endTime: number = end * CommonConstants.US_ONE_SECOND / this.msPxAvg;
    this.rightText = this.showThumbText(endTime);

    if (this.mRangSeekBarListener) {
      this.mRangSeekBarListener.onRangeSeekBarValuesChanged(startTime, endTime);
    }
  }

  // 视频范围选择结束
  onRangeStopScrollChanged() {
    let start: number = this.scroller.currentOffset().xOffset;
    // 计算开始位置
    let startPosition: number = start * 1000.0 / this.msPxAvg
    startPosition = Math.max(0, Math.floor(startPosition));

    // 计算结束位置
    let endPosition: number = startPosition + this.mRangSeekBarOption.mMaxCountRange + 5;
    let maxEnd: number = Math.floor(this.mRangSeekBarOption.mRightProgressPos / 1000);
    endPosition = Math.min(maxEnd, endPosition);

    if (this.mRangSeekBarListener) {
      this.mRangSeekBarListener.onRangeSeekBarScrollChanged(startPosition, endPosition);
    }
  }

  // 更新右边滑块位置
  rightThumbUpdate(deltaX: number) {
    let deltaPx = deltaX;
    // 右边距
    if (deltaPx >= 0 && ((this.rightThumbRect[2] + deltaPx) >= this.componentMaxWidth - this.rightPadding)) {
      deltaPx = this.componentMaxWidth - this.rightPadding - this.rightThumbRect[2];
    }
    // 左边距
    if (deltaPx <= 0 && ((this.rightThumbRect[0] + deltaPx) <= (this.leftThumbRect[2] + this.leftRightPaddingMin))) {
      deltaPx = (this.leftThumbRect[2] + this.leftRightPaddingMin) - this.rightThumbRect[0];
    }
    // 右边距 新增 与leftThumb最大距离
    if (deltaPx >= 0 && ((this.rightThumbRect[0] + deltaPx) >= (this.leftThumbRect[2] + this.leftRightPaddingMax))) {
      deltaPx = (this.leftThumbRect[2] + this.leftRightPaddingMax) - this.rightThumbRect[0];
    }

    let newArea = [
      (this.rightThumbRect[0] + deltaPx),
      this.rightThumbRect[1],
      (this.rightThumbRect[2] + deltaPx),
      this.rightThumbRect[3]];

    this.rightThumbRect = newArea;
    this.rightThumbPosition = { x: newArea[0], y: newArea[1] };
    this.rightTextPosition = { x: newArea[2] - this.rightTextWidth, y: newArea[1] };

    this.middenPosition = { x: this.leftThumbRect[2], y: this.leftThumbRect[1] }
    this.transparentWidth = this.rightThumbRect[0] - this.leftThumbRect[2];
    // 更新选取视频时间
    this.onRangeValueChanged();
  }

  scrollUpdate(deltaX: number) {
    let deltaPx = -deltaX;
    this.scroller.scrollBy(deltaPx, 0);
    this.onRangeValueChanged();
  }

  // 判断触碰事件有效
  touchInThumb(event?: GestureEvent): boolean {
    if (this.touchInLeftThumb(event) || this.touchInRightThumb(event)) {
      return true;
    } else {
      return false;
    }
  }

  // 判断左边滑块滑动
  touchInLeftThumb(event?: GestureEvent): boolean {

    logger.info(TAG, ' touchInLeftThumb');
    let pointX: number = this.clearUndefined(event?.fingerList[0].localX);
    let pointY: number = this.clearUndefined(event?.fingerList[0].localY);
    return this.pointInArea(pointX, pointY, this.leftThumbRect);
  }

  // 判断右边滑块滑动
  touchInRightThumb(event?: GestureEvent): boolean {

    logger.info(TAG, ' touchInRightThumb');
    let pointX: number = this.clearUndefined(event?.fingerList[0].localX)
    let pointY: number = this.clearUndefined(event?.fingerList[0].localY)
    return this.pointInArea(pointX, pointY, this.rightThumbRect);
  }

  // 区域判断
  pointInArea(x: number, y: number, area: Array<number>): boolean {

    logger.info(TAG, ' x=' + x + ' y=' + y + ' area=' + area)
    if (area.length == 4) {
      if (x >= area[0] && x <= area[2]) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  // 判断位置坐标值
  clearUndefined(num: number | undefined) {
    if (num == undefined) {
      return 0;
    }
    return num;
  }
}