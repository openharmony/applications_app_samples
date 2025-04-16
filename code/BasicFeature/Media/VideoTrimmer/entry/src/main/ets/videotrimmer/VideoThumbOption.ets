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
 * 视频帧图片选项
 */
export class ThumbContent {
  // 当加载帧没有完成，默认的占位图
  public framePlaceholder?: PixelMap = undefined;
  // 裁剪视频预览长方形条状区域背景颜色
  public frameBackground: string = '#000000';
  // 视频帧加载成功后的图片信息
  public pixelMap?: PixelMap = undefined;
}

export class VideoThumbOption {
  // 已加载的图片列表
  public videoThumbs: ThumbContent[] = [];
  // 单张图片宽度
  public videoThumbWidth: number = 30;
}
