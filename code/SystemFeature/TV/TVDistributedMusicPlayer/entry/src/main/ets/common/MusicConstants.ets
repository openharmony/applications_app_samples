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

import { songItemType } from '../model/Music';

// 歌曲列表
export const songs: songItemType[] = [
  {
    img: $r('app.media.album1'),
    name: 'dynamic',
    author: '佚名',
    url: 'system/etc/dynamic.wav',
    time: 68372
  },
  {
    img: $r('app.media.album3'),
    name: '轻音乐',
    author: '小白团队',
    url: 'system/etc/demo.wav',
    time: 28232
  },
  {
    img: $r('app.media.album4'),
    name: '流行音乐',
    author: '大型歌剧院',
    url: 'system/etc/graphic/bootsound.wav',
    time:5041
  }
]