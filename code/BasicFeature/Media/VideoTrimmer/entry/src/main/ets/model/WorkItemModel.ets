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
 * 视频信息，包括标题、视频地址、首帧图片、视频详情
 */
export class WorkItem {
  public date: string; // 日期
  public time: string; // 详细记录时间
  public author: string; // 作者
  public videoSrc: string; // 视频地址
  public trimmerSrc: string; // 裁剪过后的视频地址
  public firstImage: ResourceStr | PixelMap; // 首帧图片
  public labels: ResourceStr; // 标签
  public address: string; // 所在位置
  public isDayTop: boolean = false; // 当天的第一条
  public index: number = 0; // 排序

  constructor(date: string = '', time: string = '', videoSrc: string = '', firstImage: ResourceStr = '',
    labels: ResourceStr = '',
    isTop: boolean = false, index: number = 0) {
    this.date = date;
    this.time = time;
    this.videoSrc = videoSrc;
    this.trimmerSrc = '';
    this.firstImage = firstImage;
    this.labels = labels;
    this.isDayTop = isTop;
    this.author = '徐霞客';
    this.address = '杭州';
    this.index = index;
  }
}

export const WORK_LIST_DATA = [
  new WorkItem('12月9日', '11-09 16:40',
    getContext(this)
      .resourceManager
      .getStringSync($r('app.string.video_trimmer_video_url1')),
    $r('app.media.video_trimmer_autoplay_preview1'), '北高峰，杭州', true),
  new WorkItem('12月9日', '11-09 16:35',
    getContext(this)
      .resourceManager
      .getStringSync($r('app.string.video_trimmer_video_url2')),
    $r('app.media.video_trimmer_autoplay_preview2'), '北高峰，杭州', false),
  new WorkItem('12月9日', '11-09 16:10',
    getContext(this)
      .resourceManager
      .getStringSync($r('app.string.video_trimmer_video_url3')),
    $r('app.media.video_trimmer_autoplay_preview3'), '北高峰，杭州', false),
  new WorkItem('12月8日', '11-08 15:40',
    getContext(this)
      .resourceManager
      .getStringSync($r('app.string.video_trimmer_video_url4')),
    $r('app.media.video_trimmer_autoplay_preview4'), '北高峰，杭州', true),
  new WorkItem('12月7日', '11-07 18:40',
    getContext(this)
      .resourceManager
      .getStringSync($r('app.string.video_trimmer_video_url1')),
    $r('app.media.video_trimmer_autoplay_preview2'), '北高峰，杭州'),
]