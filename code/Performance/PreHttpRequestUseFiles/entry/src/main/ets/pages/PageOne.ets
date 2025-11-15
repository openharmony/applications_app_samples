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

@Builder
export function PageOneBuilder() {
  PageOne();
}

@Component
export struct PageOne {
  pageInfo: NavPathStack = new NavPathStack();
  @State name: string = 'pageOne';
  @LocalStorageLink('imageData') imageData: PixelMap | undefined = undefined;

  build() {
    NavDestination() {
      Row() {
        // Positive example: At this time, the Image has obtained the network image that has been loaded in advance,
        // reducing the time for white blocks to appear.
        Image(this.imageData)
          .objectFit(ImageFit.Auto)
          .width('100%')
          .height('100%')
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
    }
    .title(this.name)
  }
}