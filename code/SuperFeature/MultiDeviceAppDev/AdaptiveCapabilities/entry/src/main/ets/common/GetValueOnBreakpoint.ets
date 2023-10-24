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

import window from '@ohos.window';

export class Breakpoints {
  xs: number = 0;
  sm: number = 0;
  md: number = 0;
  lg: number = 0;
}

// 全局断点接口
export default function getValueOnBreakpoint(breakpointsLabels: string[], breakpoints: Breakpoints): string {
  if (breakpointsLabels.length < 4) {
    return '';
  }
  let windowObj: window.Window |undefined= AppStorage.Get('windowObj');
  if(windowObj == undefined){
    return '';
  }
  let windowWidthVp = px2vp(windowObj.getWindowProperties().windowRect.width);
  let newBreakpoint: string = '';
  if (windowWidthVp < breakpoints.sm) {
    newBreakpoint = breakpointsLabels[0];
  } else if (windowWidthVp < breakpoints.md) {
    newBreakpoint = breakpointsLabels[1];
  } else if (windowWidthVp < breakpoints.lg) {
    newBreakpoint = breakpointsLabels[2];
  } else {
    newBreakpoint = breakpointsLabels[3];
  }
  return newBreakpoint;
}