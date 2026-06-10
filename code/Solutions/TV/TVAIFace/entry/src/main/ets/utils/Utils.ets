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
import { display } from '@kit.ArkUI';
import { window } from '@kit.ArkUI';
import { initInfo } from './Log';
import { GlobalThis } from '../common/GlobalThis';

let log = initInfo('utils');

interface ScreenMss {
  width: number,
  height: number,
  pageW: number,
  pageH: number,
  dpi: number,
  lpi: number
}

interface ImgSize {
  x: number,
  y: number,
  width: number,
  height: number
}

export async function getAppWindowSize(win: window.Window): Promise<ScreenMss> {
  let width = 1920; // src/main/resources/base/profile/main_pages.json 中的designWidth

  let avoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
  let avoidAreaHeight = avoidArea.topRect.height + avoidArea.bottomRect.height;

  let prop = await win.getProperties();
  let rect = prop.windowRect;
  let height = (rect.height - avoidAreaHeight) * width / rect.width;
  let lpi = parseFloat((rect.width / width).toFixed(3));
  let dis = await display.getDefaultDisplaySync();
  let dpi = parseFloat((dis.densityDPI / 160).toFixed(3));
  let res: ScreenMss = {
    width: width,
    height: Math.floor(height),
    pageW: rect.width,
    pageH: rect.height - avoidAreaHeight,
    dpi: dpi,
    lpi: lpi
  };
  return res;
}

export async function getScreenSize(): Promise<ScreenMss> {
  let width = 1920;
  // 应用所在window尺寸
  let win = await window.getLastWindow(GlobalThis.get().getCameraSettingContext());

  let avoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
  let avoidAreaHeight = avoidArea.topRect.height + avoidArea.bottomRect.height;

  let prop = await win.getWindowProperties();
  let rect = prop.windowRect;
  let height = (rect.height - avoidAreaHeight) * 1920 / rect.width;

  let lpi = parseFloat((rect.width / 1920).toFixed(3));
  let dis = await display.getDefaultDisplaySync();
  let dpi = parseFloat((dis.densityDPI / 160).toFixed(3));
  let res: ScreenMss = {
    width: width,
    height: Math.floor(height),
    pageW: rect.width,
    pageH: rect.height - avoidAreaHeight,
    dpi: dpi,
    lpi: lpi
  };
  return res;
}

export function drawImageSize(imgW: number, imgH: number, canvasW: number, canvasH: number): ImgSize {
  let cW = canvasW;
  let cH = canvasH;

  let canvasSize = cW / cH;
  let imgSize = imgW / imgH;

  let imgWidth = cW;
  let imgHeight = cH;


  if (canvasSize > imgSize) {
    imgWidth = parseInt((cH * imgSize).toFixed(0));
  } else {
    imgHeight = parseInt((cW / imgSize).toFixed(0));
  }

  let x = Math.floor((canvasW - imgWidth) / 2);
  let y = Math.floor((canvasH - imgHeight) / 2);

  return {
    x,
    y,
    width: imgWidth,
    height: imgHeight
  };
}
