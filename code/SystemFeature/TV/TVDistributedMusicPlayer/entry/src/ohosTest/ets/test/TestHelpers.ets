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

import { PlayStateType, defaultState } from '../../../main/ets/model/PlayState';
import { songItemType } from '../../../main/ets/model/Music';

export function makePlayState(
  img?: string,
  name?: string,
  author?: string,
  url?: string,
  playIndex?: number,
  time?: number,
  duration?: number,
  isPlay?: boolean,
  playMode?: 'auto' | 'repeat' | 'random',
  playList?: songItemType[]
): PlayStateType {
  let result: PlayStateType = {
    img: defaultState.img,
    name: defaultState.name,
    author: defaultState.author,
    url: defaultState.url,
    playIndex: defaultState.playIndex,
    time: defaultState.time,
    duration: defaultState.duration,
    isPlay: defaultState.isPlay,
    playMode: defaultState.playMode,
    playList: defaultState.playList
  };
  if (img !== undefined) { result.img = img; }
  if (name !== undefined) { result.name = name; }
  if (author !== undefined) { result.author = author; }
  if (url !== undefined) { result.url = url; }
  if (playIndex !== undefined) { result.playIndex = playIndex; }
  if (time !== undefined) { result.time = time; }
  if (duration !== undefined) { result.duration = duration; }
  if (isPlay !== undefined) { result.isPlay = isPlay; }
  if (playMode !== undefined) { result.playMode = playMode; }
  if (playList !== undefined) { result.playList = playList; }
  return result;
}
