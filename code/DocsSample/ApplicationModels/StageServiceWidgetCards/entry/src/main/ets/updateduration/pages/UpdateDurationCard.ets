/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

let storageUpdateDurationCard = new LocalStorage();

@Entry(storageUpdateDurationCard)
@Component
struct UpdateDurationCard {
  @LocalStorageProp('title') title: ResourceStr = $r('app.string.default_title');
  @LocalStorageProp('detail') detail: ResourceStr = $r('app.string.widget_updateduration_desc');

  build() {
    Column() {
      Column() {
        Text(this.title)
          .fontColor('#FFFFFF')
          .opacity(0.9)
          .fontSize(14)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(1)
          .margin({ top: '8%', left: '10%' })
        Text(this.detail)
          .fontColor('#FFFFFF')
          .opacity(0.6)
          .fontSize(12)
          .textOverflow({ overflow: TextOverflow.Ellipsis })
          .maxLines(2)
          .margin({ top: '5%', left: '10%' })
      }.width('100%')
      .alignItems(HorizontalAlign.Start)
    }.width('100%').height('100%')
    .backgroundImage($r('app.media.CardEvent'))
    .backgroundImageSize(ImageSize.Cover)
  }
}