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

import common from '@ohos.app.ability.common';
import { VideoLoadFramesListener } from './VideoLoadFramesListener';
import { VideoTrimListener } from './VideoTrimListener';

/**
 * 视频剪辑参数选项
 */
@Observed
export class VideoTrimmerOption {
  constructor() {
    this.scaleNum = 100;
    this.videoMaxTime = 8;
    this.videoMinTime = 3;
    this.maxCountRange = 8;
    this.thumbWidth = 30;
    this.paddingLineHeight = 10;
  }

  // 源文件路径
  @Track public srcFilePath: string = '';
  // 视频剪辑回调接口
  @Track public listener: VideoTrimListener = {
    onStartTrim() {
    },
    onFinishTrim(outputFile: string) {
    },
    onCancel() {
    }
  };
  // 视频帧加载回调接口
  @Track public loadFrameListener: VideoLoadFramesListener = {
    onStartLoad() {
    },
    onFinishLoad() {
    }
  }
  // 裁剪事件长度 默认值8秒
  @Track public videoMaxTime?: number = 8;
  // 最小剪辑时间
  @Track public videoMinTime?: number = 3;
  // seekBar的区域内一共有多少张图片
  @Track public maxCountRange?: number = 8;
  // 裁剪视频预览长方形条状左右边缘宽度
  @Track public thumbWidth?: number = 30;
  // 裁剪视频预览长方形条状上下边缘高度
  @Track public paddingLineHeight?: number = 10;
  // 当加载帧没有完成，默认的占位图
  @Track public framePlaceholder?: PixelMap;
  // 裁剪视频预览长方形条状区域背景颜色
  @Track public frameBackground?: string;
  @Track public context?: common.UIAbilityContext;
  // 裁剪时压缩比率，100 为1：1，即不压缩
  @Track public scaleNum?: number = 100;
}