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

import router from '@ohos.router';
import { sceneData } from '../model/SceneData';
import { SceneMsg } from '../model/SceneMsg';

@Preview
@Component
export struct ifOrVisibilityHomeView {
  @State SceneDataArray: Array<SceneMsg> = sceneData;

  build() {
    Row() {
      Column() {
        Text($r("app.string.choice_render_title"))
          .fontSize($r('app.integer.font_size_30'))
          .fontWeight(FontWeight.Bold)
          .margin({ top: $r('app.integer.layout_30') })
        ForEach(this.SceneDataArray, (item: SceneMsg, index: number) => {
          Button(item.title)
            .urlButtonFancy(item.uri)
        }, (item: SceneMsg) => JSON.stringify(item))
      }
      .width('100%')
      .height("100%")
    }
    .height('100%')
  }
}

@Extend(Button)
function urlButtonFancy(url: string) {
  .width($r('app.string.layout_80_percent'))
  .fontSize($r('app.integer.font_size_18'))
  .margin({ top: $r('app.integer.layout_30') })
  .onClick(() => {
    router.pushUrl({ url: url });
  })
}
