/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

export class IconItem {
  imageSrc: Resource;
  description: Resource | string;

  constructor(imageSrc: Resource, description: Resource | string) {
    this.imageSrc = imageSrc;
    this.description = description;
  }
}

export class OffsetDataType {
  x: number;
  y: number;

  constructor(x: number, y: number) {
    this.x = x;
    this.y = y;
  }
}

export class PaddingDataType {
  left: number;
  right: number;

  constructor(left: number, right: number) {
    this.left = left;
    this.right = right;
  }
}

export class SongType {
  imageSrc: Resource;
  description: Resource;
  count: number;

  constructor(imageSrc: Resource, description: Resource, count: number) {
    this.count = count;
    this.imageSrc = imageSrc;
    this.description = description;
  }
}