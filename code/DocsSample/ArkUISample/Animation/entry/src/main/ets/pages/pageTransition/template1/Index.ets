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
@Entry
@Component
struct pageTransition1 {
  @State scale1: number = 1;
  @State opacity1: number = 1;

  build() {
    Column() {
      Image($r("app.media.transition_image1")).width('100%').height('100%')
    }
    .width('100%')
    .height('100%')
    .scale({ x: this.scale1 })
    .opacity(this.opacity1)
    .onClick(() => {
      this.getUIContext().getRouter().pushUrl({ url: 'pages/pageTransition/template1/Page1' });
    })
  }

  pageTransition() {
    PageTransitionEnter({ duration: 1200, curve: Curve.Linear })
      .onEnter((type: RouteType, progress: number) => {
        if (type == RouteType.Push || type == RouteType.Pop) {
          this.scale1 = progress;
          this.opacity1 = progress;
        }
      })
    PageTransitionExit({ duration: 1200, curve: Curve.Ease })
      .onExit((type: RouteType, progress: number) => {
        if (type == RouteType.Push) {
          this.scale1 = 1 - progress;
          this.opacity1 = 1 - progress;
        }
      })
  }
}