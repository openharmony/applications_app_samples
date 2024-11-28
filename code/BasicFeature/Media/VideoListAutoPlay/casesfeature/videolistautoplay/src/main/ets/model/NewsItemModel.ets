/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
export class NewsItem {
  newsName: string; // 标题
  newsVideoSrc: string; // 视频地址
  newsImage: ResourceStr; // 首帧图片
  newsDetails: ResourceStr; // 详情

  constructor(newsName: string, newsVideoSrc: string, newsImage: ResourceStr, newsDetails: ResourceStr) {
    this.newsName = newsName;
    this.newsVideoSrc = newsVideoSrc;
    this.newsImage = newsImage;
    this.newsDetails = newsDetails;
  }
}

export const NEWS_LIST_DATA = [
  new NewsItem('AI伦理讨论峰会',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('祝贺！谷神星一号海射型遥二运载火箭发射成功',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('超高速磁悬浮列车',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('中国首台可用于临床的科研型7T磁共振投入使用',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('太阳能技术革新',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('量子加密通信网',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('深海探索潜水器',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('环保材料研发',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
  new NewsItem('太空旅行计划',
    'https://v.oh4k.com/muhou/2022/07/20220704-RIUq3Z.mp4',
    $r('app.media.video_list_autoplay_preview2'), '伤心千古，泪痕如洗'),
]
