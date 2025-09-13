/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { LoggerUtils } from './../utils/LoggerUtils';

@Builder
export function PageOneBuilder() {
  Index();
}

@Entry
@Component
export struct Index {
  @State message: string = 'calledHspIndex';
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Row() {
        Column() {
          Text($r('app.string.logger_debug'))
            .fontSize($r('app.float.page_text_font_size'))
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              LoggerUtils.debug('call debug');
            })
          Button($r('app.string.back_to_index')).fontSize($r('app.float.page_text_font_size')).onClick(() => {
            this.pathStack.pop();
          })
        }
        .width('100%')
      }
      .height('100%')
    }.title($r('app.string.calledHspIndex'))
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
