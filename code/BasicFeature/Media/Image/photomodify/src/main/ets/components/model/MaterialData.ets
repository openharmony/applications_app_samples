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

interface MaterialData {
  getResource(): Resource | undefined;
  getName(): Resource | undefined;
}

class FontColorData implements MaterialData {
  fontColor?: Resource;
  name?: Resource;

  constructor(fontColor?: Resource, name?: Resource) {
    this.fontColor = fontColor;
    this.name = name;
  }

  getResource(): Resource | undefined {
    return this.fontColor;
  }

  getName(): Resource | undefined {
    return this.name;
  }
}

class ImageData implements MaterialData {
  image?: Resource;
  name?: Resource;

  constructor(image?: Resource, name?: Resource) {
    this.image = image;
  }

  getResource(): Resource | undefined {
    return this.image;
  }

  getName(): Resource | undefined {
    return this.name;
  }
}

export { MaterialData, FontColorData, ImageData };