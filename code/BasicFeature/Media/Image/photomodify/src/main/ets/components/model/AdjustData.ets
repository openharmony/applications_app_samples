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

export enum Tasks {
  SCALE,
  CROP,
  ROTATE,
  TONING,
  TEXT,
  STICKER,
  ADJUST,
  MARK,
  COLORSPACE,
  NONE = 99
}

export enum CropTasks {
  ORIGIN,
  ONE_ONE,
  THREE_FOUR,
  NINE_SIXTH,
  NONE = 99
}

export enum ScaleTasks {
  AMPLIFICARION,
  NARROW,
  NONE = 99
}

export enum ColorSpaceTasks {
  ADOBERGB,
  SRGB,
  DCIP3,
  DISPLAYP3,
  NONE = 99
}

export class TaskData {
  task?: number
  image?: Resource
  text?: Resource

  constructor(task?: number, image?: Resource, text?: Resource) {
    this.task = task;
    this.image = image;
    this.text = text;
  }
}