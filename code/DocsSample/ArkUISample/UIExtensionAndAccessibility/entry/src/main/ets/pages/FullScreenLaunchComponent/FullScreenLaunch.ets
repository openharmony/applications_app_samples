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

import { FullScreenLaunchComponent } from '@kit.ArkUI'

@Builder
function sampleColumnChild() {
  Column() {
    Image($r('app.media.app_icon'))
    Text('test')
  }
}

@Component
export struct FullScreenLaunch {
  @State appId: string = '5765880207855083101'; // 原子化服务appId

  build() {
    NavDestination() {
      Column() {
        FullScreenLaunchComponent({
          content: sampleColumnChild,
          appId: this.appId,
          options: {},
          onTerminated: (info) => {
            console.info('onTerminated code: ' + info.code.toString());
          },
          onError: (err) => {
            console.error('onError code: ' + err.code + ', message: ', err.message);
          }
        }).width('80vp').height('80vp')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Full_Screen_Launch_Component_title'))
  }
}