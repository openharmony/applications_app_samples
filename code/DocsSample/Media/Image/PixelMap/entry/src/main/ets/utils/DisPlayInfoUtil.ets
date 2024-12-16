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

import { display } from '@kit.ArkUI';
import Logger from '../common/Logger';

export class DisPlayInfo {
  private screenWidth = 0;
  private screenHeight = 0;
  private static readonly STANDARD_WIDTH = 720;
  private static readonly STANDARD_HEIGHT = 1280;

  constructor() {
    let screenWidth = display.getDefaultDisplaySync().width;
    let screenHeight = display.getDefaultDisplaySync().height;
    this.screenWidth = Math.min(screenWidth, screenHeight);
    this.screenHeight = Math.max(screenWidth, screenHeight);
    Logger.info('screenWidth ', this.screenWidth.toString(), 'screenHeight ', this.screenHeight.toString());
  }

  public getWidth(width: number): PX {
    let realWidth: number = Math.floor(width * this.screenWidth / DisPlayInfo.STANDARD_WIDTH);
    return `${realWidth}px`;
  }

  public getHeight(height: number): PX {
    let realHeight: number = Math.floor(height * this.screenWidth / DisPlayInfo.STANDARD_WIDTH);
    return `${realHeight}px`;
  }

}

