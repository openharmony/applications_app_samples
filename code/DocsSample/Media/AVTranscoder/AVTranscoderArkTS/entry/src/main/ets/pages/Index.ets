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
import {AVTranscoderDemo} from '../transcoder/AVTranscoderManager'

@Entry
@Component
struct Index {
  private context:Context | undefined = this.getUIContext().getHostContext();
  @State avTranscoder: AVTranscoderDemo = new AVTranscoderDemo(this.context);

  build() {
    RelativeContainer() {
      Column() {
        Button($r('app.string.StartTranscoder'))
          .onClick(async () => {
            console.info(`Button put`);
            await this.avTranscoder.avTranscoderDemo();
          })
          .id('AVTranscoderButton')
        Progress({ value: 0, total: 100, type: ProgressType.Linear }).value(this.avTranscoder.getCurrentProgress())
          .height(50)
          .width('80%')
      }
      .alignRules({
        center: { anchor: '__container__', align: VerticalAlign.Center },
        middle: { anchor: '__container__', align: HorizontalAlign.Center }
      })
    }
    .height('100%')
    .width('100%')
  }
}
