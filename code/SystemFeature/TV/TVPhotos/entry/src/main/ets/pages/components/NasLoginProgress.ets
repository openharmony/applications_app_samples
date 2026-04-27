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

const TAG = 'NAS_loginProgress'

@CustomDialog
export struct NasLoginProgress {
  controller?: CustomDialogController

  build() {
    Row() {
      Text($r('app.string.nas_connecting'))
        .fontFamily('HarmonyOS Sans')
        .fontWeight(FontWeight.Medium)
        .fontColor(Color.White)
        .fontSize('48lpx')
      Blank()
      LoadingProgress()
        .color(Color.White)
        .width('80lpx')
        .height('80lpx')
    }
    .padding('78lpx')
    .width('100%')
    .height('100%')
  }
}
