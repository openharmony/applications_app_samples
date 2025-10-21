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

// [Start UIContext]
import { ContextUtils } from '../Common/ContextUtils';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { Router } from '@kit.ArkUI';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State bgColor: Color = Color.Green

  aboutToAppear() {
    try {
      let router1 = this.getUIContext().getRouter();
      AppStorage.setOrCreate<Router>('router', router1);
    } catch (e) {
      console.log('e' + e);
    }
  }

  build() {
    Column() {
      Text('getContext')
        .backgroundColor(this.bgColor)
        .fontSize(20)
        .padding(5)
        .onClick(() => {
          let context = ContextUtils.getContext(this.getUIContext());
          hilog.info(DOMAIN, 'testTag', `The context is ${context}`);
          this.bgColor = Color.Blue
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End UIContext]