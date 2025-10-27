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

const TEXT_HEIGHT: number = 35;

@Component
export struct AboutComponent {
  @Link vendorId: string;
  @Link productId: string;
  @Link description: string;

  build() {
    Column() {
      Row() {
        Text($r('app.string.about'))
      }.height(60)

      Row() {
        Column() {
          Text('vendorId:')
            .textAlign(TextAlign.End)
            .height(TEXT_HEIGHT)
          Text('productId:')
            .textAlign(TextAlign.End)
            .height(TEXT_HEIGHT)
        }
        .alignItems(HorizontalAlign.End)

        Column() {
          Text(this.vendorId)
            .height(TEXT_HEIGHT)
          Text(this.productId)
            .height(TEXT_HEIGHT)
        }
        .alignItems(HorizontalAlign.Start)
        .margin({ left: 8 })
      }
    }.alignItems(HorizontalAlign.Center)
  }
}