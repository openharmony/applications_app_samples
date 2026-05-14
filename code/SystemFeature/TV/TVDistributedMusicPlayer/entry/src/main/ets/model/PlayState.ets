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

import { songItemType } from './Music';
// 播放器通知页面的数据结构
export interface PlayStateType {
  img: string
  name: string
  author: string
  url: string
  playIndex: number
  time: number
  duration: number
  isPlay: boolean
  playMode: 'auto' | 'repeat' | 'random'
  playList: songItemType[]
}

export class PlayStateTypeModel implements PlayStateType {
  public img: string;
  public name: string;
  public author: string;
  public url: string;
  public playIndex: number;
  public time: number;
  public duration: number;
  public isPlay: boolean;
  public playMode: 'auto' | 'repeat' | 'random';
  public playList: songItemType[];

  constructor(model: PlayStateType) {
    this.img = model.img;
    this.name = model.name;
    this.author = model.author;
    this.url = model.url;
    this.playIndex = model.playIndex;
    this.time = model.time;
    this.duration = model.duration;
    this.isPlay = model.isPlay;
    this.playMode = model.playMode;
    this.playList = model.playList;
  }
}


export const defaultState = {
  img: '',
  name: '',
  author: '',
  url: '',
  playIndex: 0,
  time: 0,
  duration: 0,
  isPlay: false,
  playMode: 'auto',
  playList: []
} as PlayStateType