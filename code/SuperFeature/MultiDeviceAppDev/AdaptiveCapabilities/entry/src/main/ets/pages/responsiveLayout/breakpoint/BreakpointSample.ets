/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import window from '@ohos.window'
import getValueOnBreakpoint, { Breakpoints } from '../../../common/GetValueOnBreakpoint';

@Entry
@Component
struct BreakpointSample {
  @State currentBreakpoint: string = 'small';

  listenOnBreakpoint(windowObj: window.Window) {
    const breakpointsLabels: string[] = ['xSmall', 'small', 'medium', 'large'];
    const breakpoints :Breakpoints= { xs: 0, sm: 320, md: 600, lg: 840 };
    this.currentBreakpoint = getValueOnBreakpoint(breakpointsLabels, breakpoints);
    windowObj.on('windowSizeChange', () => {
      this.currentBreakpoint = getValueOnBreakpoint(breakpointsLabels, breakpoints);
    });
  }

  aboutToAppear() {
    let windowObj: window.Window | undefined = AppStorage.Get('windowObj');
    if(windowObj != undefined){
      this.listenOnBreakpoint(windowObj);
    }
  }

  aboutToDisappear() {
    let windowObj: window.Window | undefined= AppStorage.Get('windowObj');
    if(windowObj != undefined){
      windowObj.off('windowSizeChange');
    }
  }

  build() {
    Column() {
      Text(this.currentBreakpoint)
        .fontSize(50)
        .fontWeight(FontWeight.Medium)
    }
    .height('100%')
    .width('100%')
    .justifyContent(FlexAlign.Center)
  }
}