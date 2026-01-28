/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import cameraDemo from 'libentry.so';

export interface ResolutionSize {
  width: number;
  height: number;
}

export interface SurfaceRectSize {
  surfaceWidth: number;
  surfaceHeight: number;
}

const PREFERRED_LIST: ResolutionSize[] = [
  { width: 2560, height: 1440 }, // 标准5M 16:9
  { width: 2408, height: 1080 },
  { width: 2384, height: 1080 },
  { width: 1920, height: 1440 }, // vision kit 固定分辨率
  { width: 1920, height: 1080 },
  { width: 1440, height: 1080 },
  { width: 1280, height: 720 },
  { width: 1088, height: 1088 },
  { width: 1080, height: 1080 },
  { width: 720, height: 720 },
  { width: 640, height: 480 }, // VGA 4:3
  { width: 480, height: 480 }// 1:1
];

/*********************************************
 * func: 将分辨率转为 123*123 格式
 *********************************************/
function formatLabel(size: ResolutionSize): string {
  return `${size.width}*${size.height}`;
}

/*********************************************
 * func: 分辨率去重
 *********************************************/
function cameraSizeDeduplicate(list: ResolutionSize[]): ResolutionSize[] {
  const seen: Record<string, boolean> = {};
  const out: ResolutionSize[] = [];
  for (const str of list) {
    const key = `${str.width}x${str.height}`;
    if (!seen[key]) {
      seen[key] = true;
      out.push(str);
    }
  }
  return out;
}

/*********************************************
 * func: 将输入转换为标准的CameraSize数组
 *********************************************/
function toCameraSizeArray(anyArr: ResolutionSize[]): ResolutionSize[] {
  const out: ResolutionSize[] = [];
  if (!anyArr || !Array.isArray(anyArr)) {
    return out;
  }
  for (const it of anyArr) {
    const w = Number(it.width);
    const h = Number(it.height);
    if (Number.isFinite(w) && Number.isFinite(h) && w > 0 && h > 0) {
      out.push({ width: w, height: h });
    }
  }
  return out;
}


/*********************************************
 * func: 将输入转换为标准的CameraSize数组
 *********************************************/
interface SortInterface {
  s: ResolutionSize;
  rank: number;
}



// 获取预置的分辨率并提示哪些分辨率不支持
function sortByPreferred(supported: ResolutionSize[]): ResolutionSize[] {
  const preferredMap = new Map<string, number>();
  PREFERRED_LIST.forEach((p, index) => preferredMap.set(`${p.width}x${p.height}`, index));
  const supportedSet = new Set<string>(supported.map(s => `${s.width}x${s.height}`));

  const filteredPreferred = PREFERRED_LIST.filter(pref => {
    const key = `${pref.width}x${pref.height}`;
    const isSupported = supportedSet.has(key);
    if (!isSupported){
      console.warn(`[Resolution] ${pref.width}x${pref.height} is not supported by the device.`);
    }
    return isSupported;
  });
  return [...PREFERRED_LIST];
}

export class ResolutionService {
  /**
   * 获取并格式化“照片分辨率”。返回字符串数组 ["1920*1080", ...]
   */
  static getPhotoResolutionLabels(): string[] {
    const raw = cameraDemo.getSupportedPhotoResolutions();
    const sizes = sortByPreferred(cameraSizeDeduplicate(toCameraSizeArray(raw)));
    console.info('photoresolutions'+ sizes.map(formatLabel));
    return sizes.map(formatLabel);
  }

  /**
   * 获取并格式化“录像分辨率”。返回字符串数组
   */
  static getVideoResolutionLabels(): string[] {
    const raw = cameraDemo.getSupportedVideoResolutions();
    const sizes = sortByPreferred(cameraSizeDeduplicate(toCameraSizeArray(raw)));
    console.info('videoresolutions'+ sizes.map(formatLabel));
    return sizes.map(formatLabel);
  }

  /**
   * 解析 "W*H" -> {width,height}
   */
  static parseLabel(label: string): ResolutionSize | null {
    if (!label) {
      return null;
    }
    const idx = label.indexOf('*');
    if (idx <= 0) {
      return null;
    }
    const w = Number(label.substring(0, idx));
    const h = Number(label.substring(idx + 1));
    if (!Number.isFinite(w) || !Number.isFinite(h)) {
      return null;
    }
    return { width: w, height: h };
  }

  static applyPhotoResolution(label: string): number {
    const size = ResolutionService.parseLabel(label);
    if (!size) {
      return -1;
    }
    cameraDemo.setPreviewResolution(size.width, size.height);
    return cameraDemo.setPhotoResolution(size.width, size.height);
  }

  static applyVideoResolution(label: string): number {
    const size = ResolutionService.parseLabel(label);
    if (!size) {
      return -1;
    }
    cameraDemo.setPreviewResolution(size.width, size.height);
    return cameraDemo.setVideoResolution(size.width, size.height);
  }

  static detectAspectLabelBySize(photoSize: ResolutionSize): '16:9' | '20:9' | '4:3' | '1:1' | 'other' {
    const photoWidth: number = photoSize.width;
    const photoHeight: number = photoSize.height;
    const aspectRatio: number = photoWidth / photoHeight;
    const isApproximatelyEqual = (value1: number, value2: number, tolerance: number = 0.02): boolean =>
    Math.abs(value1 - value2) <= tolerance;

    if (isApproximatelyEqual(aspectRatio, 16 / 9)) {
      return '16:9';
    }
    if (isApproximatelyEqual(aspectRatio, 20 / 9)) {
      return '20:9';
    }
    if (isApproximatelyEqual(aspectRatio, 4 / 3)) {
      return '4:3';
    }
    if (isApproximatelyEqual(aspectRatio, 1)) {
      return '1:1';
    }
    return 'other';
  }


  static calcSurfaceRectByScreenWidth(photoSize: ResolutionSize, screenWidthInPx: number): SurfaceRectSize {
    const photoWidth = Number(photoSize?.width ?? 0);
    const photoHeight = Number(photoSize?.height ?? 0);
    const screenWidth = Number(screenWidthInPx ?? 0);

    if (!(photoWidth > 0 && photoHeight > 0 && screenWidth > 0)) {
      return { surfaceWidth: 0, surfaceHeight: 0 };
    }

    const aspectLabel = ResolutionService.detectAspectLabelBySize(photoSize);
    const surfaceWidth = Math.round(screenWidth);
    const surfaceHeightFloat = screenWidth * (photoWidth / photoHeight);
    const surfaceHeight = Math.round(surfaceHeightFloat);

    console.info(`[ResolutionService] aspect=${aspectLabel}, W*H=${photoWidth}*${photoHeight}, screenW=${screenWidth}, calcH=${surfaceHeightFloat.toFixed(2)}`);
    return { surfaceWidth, surfaceHeight };
  }
}
