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
export struct ServiceSectionComponent {

  @Builder serverSection(img: Resource, label: Resource) {
    Column() {
      Image(img)
        .width(40)
        .aspectRatio(1)
        .objectFit(ImageFit.Contain)
      Text(label)
        .fontSize(12)
        .margin({ top: 12 })
    }
    .width('25%')
    .justifyContent(FlexAlign.Center)
  }

  build() {
    Row() {
      this.serverSection($r('app.media.official_service'), $r('app.string.official_Service'))
      this.serverSection($r('app.media.cash'), $r('app.string.cash'))
      this.serverSection($r('app.media.old_fornew'), $r('app.string.old_for_new'))
      this.serverSection($r('app.media.my_evaluation'), $r('app.string.my_evaluation'))
    }
    .width('100%')
    .justifyContent(FlexAlign.SpaceBetween)
    .padding({ top: 16, bottom: 16})
    .backgroundColor($r('app.color.white'))
    .border({ radius: 16 })
  }
}