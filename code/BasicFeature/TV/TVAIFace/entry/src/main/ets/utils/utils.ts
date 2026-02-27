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
import { initInfo } from "../utils/log";
import { globalThis } from '../common/globalThis';
import { WindowSizeInfo } from '../Types/ParamsType';

let log: (tag?: string | number, log?: string | number | undefined) => void = initInfo('utils');

export async function getAppWindowSize(win: window.Window) {
  let width: number = 1920; // src/main/resources/base/profile/main_pages.json 中的designWidth

  let avoidArea: window.AvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
  let avoidAreaHeight: number = avoidArea.topRect.height + avoidArea.bottomRect.height;

  let prop: window.WindowProperties = await win.getProperties();
  let rect: window.Rect = prop.windowRect;
  let height: number = (rect.height - avoidAreaHeight) * width / rect.width;
  let lpi: number = parseFloat((rect.width / width).toFixed(3));
  let dis: display.Display = await display.getDefaultDisplaySync();
  let dpi: number = parseFloat((dis.densityDPI / 160).toFixed(3));
  let res: WindowSizeInfo = {
    width: width,
    height: Math.floor(height),
    pageW: rect.width,
    pageH: rect.height - avoidAreaHeight,
    dpi: dpi,
    lpi: lpi
  };
  return res;
}

export async function getScreenSize() {
  let width: number = 1920;
  // 应用所在window尺寸
  let win: window.Window = await window.getLastWindow(globalThis.get().getCameraSettingContext());

  let avoidArea: window.AvoidArea = win.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM);
  let avoidAreaHeight: number = avoidArea.topRect.height + avoidArea.bottomRect.height;

  let prop: window.WindowProperties = await win.getWindowProperties();
  let rect: window.Rect = prop.windowRect;
  let height: number = (rect.height - avoidAreaHeight) * 1920 / rect.width;

  let lpi: number = parseFloat((rect.width / 1920).toFixed(3));
  let dis: display.Display = await display.getDefaultDisplaySync();
  let dpi: number = parseFloat((dis.densityDPI / 160).toFixed(3));
  let res: WindowSizeInfo = {
    width: width,
    height: Math.floor(height),
    pageW: rect.width,
    pageH: rect.height - avoidAreaHeight,
    dpi: dpi,
    lpi: lpi
  };
  return res;
}

export function objType(obj) {
  return Object.prototype.toString.call(obj)
    .replace(/\[object /, '')
    .replace(/\]/, '')
    .toLowerCase();
}

export function drawImageSize(imgW: number, imgH: number, canvasW: number, canvasH: number) {
  let cW: number = canvasW;
  let cH: number = canvasH;

  let canvas_s: number = cW / cH;
  let img_s: number = imgW / imgH;

  let img_w: number = cW;
  let img_h: number = cH;


  if (canvas_s > img_s) {
    img_w = parseInt((cH * img_s).toFixed(0));
  } else {
    img_h = parseInt((cW / img_s).toFixed(0));
  }

  let x: number = Math.floor((canvasW - img_w) / 2);
  let y: number = Math.floor((canvasH - img_h) / 2);

  return {
    x,
    y,
    width: img_w,
    height: img_h
  };
}
