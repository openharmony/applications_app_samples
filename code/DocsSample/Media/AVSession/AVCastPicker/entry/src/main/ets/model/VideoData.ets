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

export interface VideoData {
  url: string;
  name: string;
  description: string;
  head: Resource;
  index: number;
  duration: number;
}

export const NET_SOURCES: VideoData[] = [
  // 以下网络视频的地址为虚拟地址，开发者可根据需要自行替换。
  {
    url: 'https://www.examples.com',
    name: 'pura-x publicize video',
    description: '色彩碰撞，几何分割，演绎先锋格调；质感素皮，0.05 毫米精致压纹，尽显雅致。',
    head: $r('app.media.video_cover_0'),
    index: 0,
    duration: 85000
  },
  {
    url: 'https://www.examples.com',
    name: 'mate-xt publicize video',
    description: '革新技术，蕴含巧思；尖端工艺，探索极限，以科技勾勒纤薄。',
    head: $r('app.media.video_cover_1'),
    index: 1,
    duration: 197000
  },
  {
    url: 'https://www.examples.com',
    name: 'pura publicize video',
    description: '以大胆想象，探索未见之美；以先锋视角，打开全新视界；以独创风格，引领时尚风向。',
    head: $r('app.media.video_cover_2'),
    index: 2,
    duration: 64000
  },
  {
    url: 'https://www.examples.com',
    name: 'nova publicize video',
    description: '玩转变焦魔法，“视”界由你变！前后置多焦段随心换，轻松捕捉不同的人像故事。远近随心，格外上镜。',
    head: $r('app.media.video_cover_3'),
    index: 3,
    duration: 101000
  },
];

export const LOC_SOURCES: VideoData[] = [
  {
    url: 'kv-popup.mp4',
    name: 'pura-x publicize video',
    description: '色彩碰撞，几何分割，演绎先锋格调；质感素皮，0.05 毫米精致压纹，尽显雅致。',
    head: $r('app.media.video_cover_0'),
    index: 0,
    duration: 85000
  }
];