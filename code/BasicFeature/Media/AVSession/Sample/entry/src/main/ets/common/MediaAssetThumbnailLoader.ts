/**
 * Copyright (c) 2021-2022 Huawei Device Co., Ltd.
 */

import image from '@ohos.multimedia.image';

export class PixelMapWrapper {
  pixelMap: image.PixelMap = undefined;
  width: number = 0;
  height: number = 0;

  constructor(pixelMap: image.PixelMap, width: number, height: number) {
    this.pixelMap = pixelMap;
    this.width = width;
    this.height = height;
  }

  release(): void {
    if (this.pixelMap !== null && this.pixelMap !== undefined) {
      this.pixelMap.release();
    }
    this.pixelMap = undefined;
    this.width = 0;
    this.height = 0;
  }
}

export class Size {
  width: number = 0
  height: number = 0
}

export enum CircleAngle {
  ONE_QUARTER_CIRCLE_ANGLE = 90,
  HALF_CIRCLE_ANGEL = 180,
  THREE_QUARTER_CIRCLE_ANGLE = 270,
  CIRCLE_ANGLE = 360
}
