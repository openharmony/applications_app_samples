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

import { subjectSegmentation } from '@kit.CoreVisionKit';
import { image } from '@kit.ImageKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;
const TAG  = 'testTag';
const subjectMaxCount = '2';

export class SegmentationUtil {

  private static segmentationUtil: SegmentationUtil;

  public static getInstance(): SegmentationUtil {
    if (!SegmentationUtil.segmentationUtil) {
      SegmentationUtil.segmentationUtil = new SegmentationUtil();
    }
    return SegmentationUtil.segmentationUtil;
  }

  async SegmentationImage(resource: Resource, context: common.UIAbilityContext): Promise<image.PixelMap | undefined> {
    if (!resource) {
      return undefined;
    }
    let img: image.PixelMap | undefined = await this.loadImage(resource, context);
    if (!img) {
      return undefined;
    }
    let visionInfo: subjectSegmentation.VisionInfo = {
      pixelMap: img,
    };
    let config: subjectSegmentation.SegmentationConfig = {
      maxCount: parseInt(subjectMaxCount),
      enableSubjectDetails: true,
      enableSubjectForegroundImage: true
    };
    try {
      let data: subjectSegmentation.SegmentationResult = await subjectSegmentation.doSegmentation(visionInfo, config);
      if (data.fullSubject && data.fullSubject.foregroundImage) {
        return data.fullSubject.foregroundImage;
      }
    } catch (e) {
      hilog.error(DOMAIN, TAG, 'Image segmentation failed: %{public}s', JSON.stringify(e));
    }
    return undefined;
  }

  async loadImage(resource: Resource, context: common.UIAbilityContext): Promise<image.PixelMap | undefined> {
    const resourceManager = context.resourceManager; // 获取图片数据
    let fileData: Uint8Array;
    try {
      fileData = await resourceManager.getMediaContent(resource.id); // 返回对应的媒体文件内容。
    } catch (e) {
      return undefined;
    }
    let buffer: ArrayBuffer = fileData.buffer.slice(0);
    const imageSource: image.ImageSource = image.createImageSource(buffer);
    const pixelMap: image.PixelMap = await imageSource.createPixelMap();
    imageSource.release();
    return pixelMap;
  }
}