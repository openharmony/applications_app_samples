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

import { ColorSpaceTasks,CropTasks, ScaleTasks, TaskData, Tasks } from '../model/AdjustData';

export const adjustDatas: TaskData [] = [
  new TaskData(Tasks.CROP, $r('app.media.ic_screen'), $r('app.string.crop')),
  new TaskData(Tasks.SCALE, $r('app.media.ic_scale'), $r('app.string.scale')),
  new TaskData(Tasks.ROTATE, $r('app.media.ic_rotate'), $r('app.string.rotate')),
  new TaskData(Tasks.TONING, $r('app.media.ic_brightness_small'), $r('app.string.toning')),
  new TaskData(Tasks.COLORSPACE, $r('app.media.ic_brightness_small'), $r('app.string.colorSpace'))

];

export const markDatas: TaskData [] = [
  new TaskData(Tasks.TEXT, $r('app.media.ic_font'), $r('app.string.text')),
  new TaskData(Tasks.STICKER, $r('app.media.ic_image'), $r('app.string.sticker'))
];


export const cropTaskDatas: TaskData[] = [
  new TaskData(CropTasks.ORIGIN, $r('app.media.ic_origin'), $r('app.string.origin_photo')),
  new TaskData(CropTasks.THREE_FOUR, $r('app.media.three_four_gray'), $r('app.string.proportion_three_four')),
  new TaskData(CropTasks.NINE_SIXTH, $r('app.media.nine_sixth_gray'), $r('app.string.proportion_nine_sixth')),
  new TaskData(CropTasks.ONE_ONE, $r('app.media.one_one_gray'), $r('app.string.proportion_one_one'))
];

export const scaleTaskDatas: TaskData[] = [
  new TaskData(ScaleTasks.AMPLIFICARION, $r('app.media.scale_big'), $r('app.string.amplification')),
  new TaskData(ScaleTasks.NARROW, $r('app.media.scale_small'), $r('app.string.narrow'))
];

export const colorSpaceTaskDatas: TaskData[] = [
  new TaskData(ColorSpaceTasks.SRGB, $r('app.media.ic_image'), $r('app.string.colorSpaceSRGB')),
  new TaskData(ColorSpaceTasks.ADOBERGB, $r('app.media.ic_image'), $r('app.string.colorSpaceAdobeRGB')),
  new TaskData(ColorSpaceTasks.DCIP3, $r('app.media.ic_image'), $r('app.string.colorSpaceDCIP3')),
  new TaskData(ColorSpaceTasks.DISPLAYP3, $r('app.media.ic_image'), $r('app.string.colorSpaceDisplayP3'))
];