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

@Component
export struct Play {
  build() {
    Column() {
      GridRow() {
        GridCol({ span: { sm: 12, md: 6, lg: 6 } }) {
          Row() {
            Image($r('app.media.sing'))
              .width(200)
              .height(200)
              .objectFit(ImageFit.Contain)
          }.margin({ bottom: 10 })
        }

        GridCol({ span: { sm: 12, md: 6, lg: 6 } }) {
          Row() {
            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.favorite')).width(48).height(48)}
            .width(48)
            .height(48)
            .displayPriority(1)
            .backgroundColor('white')

            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.down')).width(48).height(48)}
              .width(48)
              .height(48)
              .displayPriority(2)
              .backgroundColor('white')

            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.pause')).width(48).height(48)}
            .width(48)
            .height(48)
            .displayPriority(3)
            .backgroundColor('white')

            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.next')).width(48).height(48)}
            .width(48)
            .height(48)
            .displayPriority(2)
            .backgroundColor('white')

            Button({ type: ButtonType.Circle, stateEffect: true }) {
              Image($r('app.media.list')).width(48).height(48)}
            .width(48)
            .height(48)
            .displayPriority(1)
            .backgroundColor('white')
          }
          .width('100%')
          .height('100%')
          .height(90)
          .borderRadius(16)
          .backgroundColor('#FFFFFF')
          .justifyContent(FlexAlign.Center)
        }
      }
    }.width('80%')
  }
}