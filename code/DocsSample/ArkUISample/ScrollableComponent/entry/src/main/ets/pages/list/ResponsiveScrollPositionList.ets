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

import { util } from '@kit.ArkTS';
import { ComponentCard } from '../../common/Card';

// [Start respond_to_scroll_position]
const alphabets = ['#', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K',
  'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'];

// [StartExclude respond_to_scroll_position]
class Contact {
  public key: string = util.generateRandomUUID(true);
  public name: string | Resource;
  public icon: Resource;

  constructor(name: string | Resource, icon: Resource) {
    this.name = name;
    this.icon = icon;
  }
}

class ContactsGroup {
  public title: string = '';
  public contacts: Array<object> | null = null;
  public key: string = '';
}

export let contactsGroups: object[] = [
  {
    title: 'A',
    contacts: [
      new Contact($r('app.string.contacts_A_one'), $r('sys.media.clone_app_badge_1')),
      new Contact($r('app.string.contacts_A_two'), $r('sys.media.clone_app_badge_2'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup,
  {
    title: 'B',
    contacts: [
      new Contact($r('app.string.contacts_B_one'), $r('sys.media.clone_app_badge_3')),
      new Contact($r('app.string.contacts_B_two'), $r('sys.media.clone_app_badge_4')),
      new Contact($r('app.string.contacts_B_three'), $r('sys.media.clone_app_badge_5'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup,
  {
    title: 'D',
    contacts: [
      new Contact($r('app.string.contacts_D_one'), $r('sys.media.clone_app_badge_3')),
      new Contact($r('app.string.contacts_D_two'), $r('sys.media.clone_app_badge_4')),
      new Contact($r('app.string.contacts_D_three'), $r('sys.media.clone_app_badge_5'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup,
  {
    title: 'F',
    contacts: [
      new Contact($r('app.string.contacts_F_one'), $r('sys.media.clone_app_badge_3')),
      new Contact($r('app.string.contacts_F_two'), $r('sys.media.clone_app_badge_4'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup,
  {
    title: 'G',
    contacts: [
      new Contact($r('app.string.contacts_G_one'), $r('sys.media.clone_app_badge_3')),
      new Contact($r('app.string.contacts_G_two'), $r('sys.media.clone_app_badge_4'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup,
  {
    title: 'H',
    contacts: [
      new Contact($r('app.string.contacts_H_one'), $r('sys.media.clone_app_badge_3')),
      new Contact($r('app.string.contacts_H_two'), $r('sys.media.clone_app_badge_4')),
      new Contact($r('app.string.contacts_H_three'), $r('sys.media.clone_app_badge_5'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup,
  {
    title: 'X',
    contacts: [
      new Contact($r('app.string.contacts_X_one'), $r('sys.media.clone_app_badge_3')),
      new Contact($r('app.string.contacts_X_two'), $r('sys.media.clone_app_badge_4')),
      new Contact($r('app.string.contacts_X_three'), $r('sys.media.clone_app_badge_5'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup
];
// [EndExclude respond_to_scroll_position]

@Entry
@Component
export struct ResponsiveScrollPositionList {
  @State selectedIndex: number = 0;
  private listScroller: Scroller = new Scroller();
  private currentGroupTitle: string = ''; // 用于跟踪当前显示的分组标题

  // [StartExclude respond_to_scroll_position]
  @Builder
  itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }
  // [EndExclude respond_to_scroll_position]

  build() {
    // [StartExclude respond_to_scroll_position]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.ResponsiveScrollPositionList_titleExample') }) {
          // [EndExclude use_stack]
          Stack({ alignContent: Alignment.End }) {
            // 此为响应滚动位置示例List容器
            List({ scroller: this.listScroller }) {
              // [StartExclude use_foreach]
              ForEach(contactsGroups, (itemGroup: ContactsGroup) => {
                ListItemGroup({ header: this.itemHead(itemGroup.title) }) {
                  // 循环渲染ListItem
                  if (itemGroup.contacts) {
                    ForEach(itemGroup.contacts, (item: Contact) => {
                      ListItem() {
                        Row() {
                          Image(item.icon).width(40).height(40).margin(10)
                          Text(item.name).fontSize(20)
                        }.width('100%').justifyContent(FlexAlign.Start)
                        // [EndExclude respond_to_scroll_position]
                      }
                      // [StartExclude respond_to_scroll_position]
                    }, (item: Contact) => JSON.stringify(item))
                  }
                }
              }, (itemGroup: ContactsGroup) => JSON.stringify(itemGroup))
            }
            // [EndExclude respond_to_scroll_position]
            .onScrollIndex((firstIndex: number) => {
              // [StartExclude respond_to_scroll_position]
              // 根据列表滚动到的索引值，重新计算对应联系人索引栏的位置this.selectedIndex
              let group = contactsGroups[firstIndex] as ContactsGroup;
              this.currentGroupTitle = group.title;
              this.selectedIndex = alphabets.indexOf(this.currentGroupTitle);
              // [EndExclude respond_to_scroll_position]
            })

            // 字母表索引组件
            AlphabetIndexer({ arrayValue: alphabets, selected: 0 })
              .selected(this.selectedIndex)
            // [End respond_to_scroll_position]
          }.height('90%')
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.ResponsiveScrollPositionList_title'))
  }
}