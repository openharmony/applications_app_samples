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
/* eslint-disable */
import { screen, display, window } from '@kit.ArkUI';
import { initInfo } from '../utils/log';

let log = initInfo('utils');

interface WindowRectInfo {
  width: number;
  height: number;
}

interface WindowPropertiesInfo {
  windowRect: WindowRectInfo;
}

interface ScreenSizeResult {
  width: number;
  height: number;
  pageW: number;
  pageH: number;
  dpi: number;
  lpi: number;
}

interface VideoSizeResult {
  width: number;
  height: number;
}

// 监听横竖屏
export function onScreenOrientationChange(callback: (orientation: number) => void): void {
  screen.on('change', async (n) => {

    let screenArr = await screen.getAllScreens();
    let orientation = screenArr[0].orientation;
    //        UNSPECIFIED = 0,
    //        VERTICAL = 1,
    //        HORIZONTAL = 2,
    //        REVERSE_VERTICAL = 3,
    //        REVERSE_HORIZONTAL = 4,
    log('onScreenOrientationChange change orientation:' + orientation);
    getScreenSize();
    callback(orientation)
  })
}

// 获取横竖屏
export async function getScreenOrientation() {
  let screenArr = await screen.getAllScreens();
  let orientation = screenArr[0].orientation;
  log('getScreenOrientation change orientation:' + orientation);
  return orientation;
}

// 设置横竖屏
export async function setScreenOrientation(orientation: number) {
  let screenArr = await screen.getAllScreens();
  await screenArr[0].setOrientation(orientation);
}

export async function setDensityDpi() {
  let screenArr = await screen.getAllScreens();
  await screenArr[0].setDensityDpi(320);
}

export async function getScreenSize(): Promise<ScreenSizeResult> {
  let width = 1280;


  let win: window.Window = await window.getLastWindow(globalThis.abilityContext)


  let prop: WindowPropertiesInfo = await win.getProperties() as WindowPropertiesInfo;
  let rect: WindowRectInfo = prop.windowRect;
  let height = rect.height * 1280 / rect.width;

  let lpi = parseFloat((rect.width / 1280).toFixed(3));

  //update start
  // let dis = await display.getDefaultDisplay();
  let dis = display.getDefaultDisplaySync();
  // update end

  let dpi = parseFloat((dis.densityDPI / 160).toFixed(3));

  // 屏幕尺寸


  let res: ScreenSizeResult = {
    width: width,
    height: Math.floor(height),
    pageW: rect.width,
    pageH: rect.height,
    dpi: dpi,
    lpi: lpi
  };
  AppStorage.setOrCreate<number>('screen_px_w', res.pageW)
  AppStorage.setOrCreate<number>('screen_px_h', res.pageH)
  AppStorage.setOrCreate<number>('screen_lpx_w', res.width)
  AppStorage.setOrCreate<number>('screen_lpx_h', res.height)
  AppStorage.setOrCreate<number>('screen_dpi', res.dpi)
  AppStorage.setOrCreate<number>('screen_lpi', res.lpi)

  log('getScreenSize res:' + JSON.stringify(res));
  return res;
}

export function objType(obj: Object | string | number | boolean | null | undefined): string {
  if (obj === null) {
    return 'null';
  }
  if (obj === undefined) {
    return 'undefined';
  }
  if (Array.isArray(obj)) {
    return 'array';
  }
  if (obj instanceof Set) {
    return 'set';
  }
  if (obj instanceof Map) {
    return 'map';
  }
  if (obj instanceof Date) {
    return 'date';
  }
  const objTypeValue: string = typeof obj;
  if (objTypeValue === 'boolean' || objTypeValue === 'number' || objTypeValue === 'string' ||
    objTypeValue === 'symbol' || objTypeValue === 'function') {
    return objTypeValue;
  }
  return 'object';
}

export function getTimeStr(s: number) {

  let h = '';
  let m = '';
  let sec = ''
  let seconds = Math.floor(s / 1000);

  let hour = Math.floor(seconds / 3600);

  seconds = seconds - hour * 3600
  if (hour > 0) {
    h = `${hour}:`
  }
  let min = Math.floor(seconds / 60);

  seconds = seconds - min * 60;

  m = String(min).padStart(2, '0') + ':';
  sec = String(seconds).padStart(2, '0');
  return `${h}${m}${sec}`;
}

export function getVideoSize(
  pageW: number,
  pageH: number,
  videoW: number,
  videoH: number,
  type: string | number,
  isRotated: boolean = false
): VideoSizeResult {
  let pageScale = pageW / pageH;
  let videoScale = videoW / videoH;

  let videoWidthResult = pageW;
  let videoHeight = pageH;
  if (isRotated) {
    switch (type) {
      case 0: { //4:3
        if (pageScale > (4 / 3)) {
          videoHeight = parseInt((pageH * 3 / 4).toFixed(0))
          videoWidthResult = pageH
        }
        break;
      }
      case 1: { //16:9
        videoHeight = parseInt((pageH * 9 / 16).toFixed(0))
        console.log('hsqcase', videoHeight)
        videoWidthResult = pageH
        break;
      }
    }
  } else {
    switch (type) {
      case 0: { //4:3
        if (pageScale > (4 / 3)) {
          videoWidthResult = parseInt((pageH * 4 / 3).toFixed(0))
        } else {
          videoHeight = parseInt((pageW * 3 / 4).toFixed(0))
        }
        break;
      }
      case 1: { //16:9
        if (pageScale > (16 / 9)) {
          videoWidthResult = parseInt((pageH * 16 / 9).toFixed(0))
        } else {
          videoHeight = parseInt((pageW * 9 / 16).toFixed(0))
        }
        break;
      }
      case 6: {
        if (pageScale > videoScale) {
          videoWidthResult = parseInt((pageH * videoScale).toFixed(0))
        } else {
          videoHeight = parseInt((pageW / videoScale).toFixed(0))
        }
        break;
      }
    }
  }
  let videoSize: VideoSizeResult = { width: videoWidthResult, height: videoHeight };
  return videoSize;
}

// 毫秒转日期
export function secToStr(sec: number): string {
  let time = new Date(sec);
  let year: string = String(time.getFullYear());
  let month: string = String(time.getMonth() + 1);
  let day: string = String(time.getDate());
  let h: string = String(time.getHours());
  let m: string = String(time.getMinutes());
  let s: string = String(time.getSeconds());

  month = String(month).padStart(2, '0');
  day = String(day).padStart(2, '0');
  h = String(h).padStart(2, '0');
  m = String(m).padStart(2, '0');
  s = String(s).padStart(2, '0');
  return `${year}-${month}-${day} ${h}:${m}:${s}`;
}

export enum MediaType {
  AUDIO = 1,
  VIDEO,
  IMAGE,
  TXT,
  DIR,
  OTHER
}

export function isVideoFile(name: string) {
  let lastDotInd = name.lastIndexOf('.');
  if (lastDotInd == -1) {
    return false;
  }
  let isEquals = false
  let type = name.substring(lastDotInd + 1, name.length).toLowerCase();
  let types: string[] =
    ['avi', 'flv', 'm2ts', 'm4v', 'mkv', 'mov', 'mp4', 'mpg', 'mts', 'rmvb', 'trp', 'ts', 'vob', 'webm', 'wmv']
  types.forEach(element => {
    if (element === type) {
      isEquals = true
      return
    }
  });
  return isEquals;
}
