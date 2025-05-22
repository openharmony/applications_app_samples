
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

import { ComponentCard } from '../../common/Card';

// [Start list_statically_creates_the_contents_of_list_item]
@Entry
@Component
export struct DataInList {
  build() {
    // [StartExclude list_statically_creates_the_contents_of_list_item]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.DataInList_titleCityList') }) {
          // [EndExclude list_statically_creates_the_contents_of_list_item]
          List() {
            ListItem() {
              Text($r('app.string.city_beijing'))
                .fontSize(24)
            }

            ListItem() {
              Text($r('app.string.city_hangzhou'))
                .fontSize(24)
            }

            ListItem() {
              Text($r('app.string.city_shanghai'))
                .fontSize(24)
            }
          }
          .backgroundColor('#FFF1F3F5')
          .alignListItem(ListItemAlign.Center)
        }
        // [End list_statically_creates_the_contents_of_list_item]

        ComponentCard({ title: $r('app.string.DataInList_titleContactsList') }) {
          // [Start encapsulate_the_image_and_text_into_a_row]
          List() {
            ListItem() {
              Row() {
                Image($r('sys.media.ohos_ic_public_phone'))
                  .width(40)
                  .height(40)
                  .margin(10)

                Text($r('app.string.peopleOne'))
                  .fontSize(20)
              }
            }

            ListItem() {
              Row() {
                Image($r('sys.media.ohos_ic_public_phone'))
                  .width(40)
                  .height(40)
                  .margin(10)

                Text($r('app.string.peopleTwo'))
                  .fontSize(20)
              }
            }
          }
        }
      }
      // [End encapsulate_the_image_and_text_into_a_row]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.DataInList_titlePage'))
  }
}