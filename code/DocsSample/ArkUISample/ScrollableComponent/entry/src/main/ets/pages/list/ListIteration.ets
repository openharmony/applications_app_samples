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

// [Start use_foreach_to_replace_similar_list_items]
import { util } from '@kit.ArkTS';
// [StartExclude import_component_card]
import { ComponentCard } from '../../common/Card';
// [EndExclude import_component_card]

class Contact {
  public key: string = util.generateRandomUUID(true);
  public name: ResourceStr;
  public icon: Resource;

  constructor(name: ResourceStr, icon: Resource) {
    this.name = name;
    this.icon = icon;
  }
}

@Entry
@Component
export struct ListIteration {
  private contacts: Array<object> = [
    new Contact($r('app.string.peopleOne'), $r('sys.media.clone_app_badge_1')),
    new Contact($r('app.string.peopleTwo'), $r('sys.media.clone_app_badge_2'))
  ];

  build() {
    // [StartExclude use_the_nav_destination]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ListIteration_titleExample') }) {
          // [EndExclude use_the_nav_destination]
          List() {
            ForEach(this.contacts, (item: Contact) => {
              ListItem() {
                Row() {
                  Image(item.icon)
                    .width(40)
                    .height(40)
                    .margin(10)
                  Text(item.name).fontSize(20)
                }
                .width('100%')
                .justifyContent(FlexAlign.Start)
              }
            }, (item: Contact) => JSON.stringify(item))
          }
          .width('100%')
        }
      }
      // [End use_foreach_to_replace_similar_list_items]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ListIteration_title'))
  }
}