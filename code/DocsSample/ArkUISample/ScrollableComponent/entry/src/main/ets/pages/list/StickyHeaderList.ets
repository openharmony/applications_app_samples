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
import { util } from '@kit.ArkTS';

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
  } as ContactsGroup
];

@Entry
@Component
export struct StickyHeaderList {
  // 定义分组联系人数据集合contactsGroups数组
  @Builder
  itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize(20)
      .backgroundColor('#fff1f3f5')
      .width('100%')
      .padding(5)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.StickyHeaderList_titleExample') }) {
          List() {
            // 循环渲染ListItemGroup，contactsGroups为多个分组联系人contacts和标题title的数据集合
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
                    }
                  }, (item: Contact) => JSON.stringify(item))
                }
              }
            }, (itemGroup: ContactsGroup) => JSON.stringify(itemGroup))
          }
          .height(230)
          .sticky(StickyStyle.Header) // 设置吸顶，实现粘性标题效果
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.StickyHeaderList_title'))
  }
}