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

import { BreakpointSystem, BreakpointState } from './Breakpoint'

@Entry
@Component
struct BreakpointSample {
  @State compStr: BreakpointState<string> = BreakpointState.of({ sm: "sm", md: "md", lg: "lg" })
  @State compImg: BreakpointState<Resource> = BreakpointState.of({
    sm: $r('app.media.sm_new'),
    md: $r('app.media.md_new'),
    lg: $r('app.media.lg_new')
  });

  aboutToAppear() {
    BreakpointSystem.getInstance().attach(this.compStr)
    BreakpointSystem.getInstance().attach(this.compImg)
    BreakpointSystem.getInstance().start()
  }

  aboutToDisappear() {
    BreakpointSystem.getInstance().detach(this.compStr)
    BreakpointSystem.getInstance().detach(this.compImg)
    BreakpointSystem.getInstance().stop()
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Column()
        .height(100)
        .width(100)
        .backgroundImage(this.compImg.value)
        .backgroundImagePosition(Alignment.Center)
        .backgroundImageSize(ImageSize.Contain)

      Text(this.compStr.value)
        .fontSize(24)
        .margin(10)
    }
    .width('100%')
    .height('100%')
  }
}