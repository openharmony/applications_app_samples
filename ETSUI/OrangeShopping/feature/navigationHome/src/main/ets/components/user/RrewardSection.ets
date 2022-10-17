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

@Component
export struct RewardSectionComponent {

  @Builder options(img: Resource, label: Resource) {
    Column() {
      Image(img)
        .aspectRatio(1)
        .width(40)
        .objectFit(ImageFit.Contain)
      Text(label)
        .margin({ top: 12 })
        .fontSize(12)
    }
    .width('25%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Row() {
      this.options($r('app.media.vip_channel'), $r('app.string.point_reward'))
      this.options($r('app.media.point_reward'), $r('app.string.interaction'))
      this.options($r('app.media.interaction'), $r('app.string.interaction'))
      this.options($r('app.media.card_volumn'), $r('app.string.card_volume'))
    }
    .width('100%')
    .padding({ top: 16, bottom: 16})
    .backgroundColor($r('app.color.white'))
    .border({ radius: 16 })
  }
}