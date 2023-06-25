/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CropTasks, ScaleTasks, TaskData, Tasks } from '../model/AdjustData';

export const adjustDatas: TaskData [] = [
  {
    'task': Tasks.CROP,
    'image': $r('app.media.ic_screen'),
    'text': $r('app.string.crop'),
  },
  {
    'task': Tasks.SCALE,
    'image': $r('app.media.ic_scale'),
    'text': $r('app.string.scale'),
  },
  {
    'task': Tasks.ROTATE,
    'image': $r('app.media.ic_rotate'),
    'text': $r('app.string.rotate'),
  },
  {
    'task': Tasks.TONING,
    'image': $r('app.media.ic_brightness_small'),
    'text': $r('app.string.toning'),
  },
];

export const markDatas: TaskData [] = [
  {
    'task': Tasks.TEXT,
    'image': $r('app.media.ic_font'),
    'text': $r('app.string.text'),
  },
  {
    'task': Tasks.STICKER,
    'image': $r('app.media.ic_image'),
    'text': $r('app.string.sticker')
  }
];


export const cropTaskDatas: TaskData[] = [
  {
    'task': CropTasks.ORIGIN,
    'image': $r('app.media.ic_origin'),
    'text': $r('app.string.origin_photo')
  },
  {
    'task': CropTasks.THREE_FOUR,
    'image': $r('app.media.three_four_gray'),
    'text': $r('app.string.proportion_three_four'),
  },
  {
    'task': CropTasks.NINE_SIXTH,
    'image': $r('app.media.nine_sixth_gray'),
    'text': $r('app.string.proportion_nine_sixth'),
  },
  {
    'task': CropTasks.ONE_ONE,
    'image': $r('app.media.one_one_gray'),
    'text': $r('app.string.proportion_one_one')
  }
];

export const scaleTaskDatas: TaskData[] = [
  {
    'task': ScaleTasks.AMPLIFICARION,
    'image': $r('app.media.scale_big'),
    'text': $r('app.string.amplification'),
  },
  {
    'task': ScaleTasks.NARROW,
    'image': $r('app.media.scale_small'),
    'text': $r('app.string.narrow'),
  }
];
