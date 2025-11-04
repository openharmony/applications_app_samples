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
// [Start add_sticky_titles]
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

export class ContactsGroupDataSource implements IDataSource {
  private list: object[] = [];

  constructor(list: object[]) {
    this.list = list;
  }

  totalCount(): number {
    return this.list.length;
  }

  getData(index: number): object {
    return this.list[index];
  }

  registerDataChangeListener(listener: DataChangeListener): void {
  }

  unregisterDataChangeListener(listener: DataChangeListener): void {
  }
}

export let contactsGroups: object[] = [
  {
    title: 'A',
    contacts: [
      // app.string.contacts_A_one 资源文件中的value值为'艾佳'，app.media.iconA为自定义资源
      new Contact($r('app.string.contacts_A_one'), $r('app.media.iconA')),
      // app.string.contacts_A_two 资源文件中的value值为'安安'，app.media.iconB为自定义资源
      new Contact($r('app.string.contacts_A_two'), $r('app.media.iconB')),
      // app.media.iconC为自定义资源
      new Contact('Angela', $r('app.media.iconC')),
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup,
  {
    title: 'B',
    contacts: [
      // app.string.contacts_B_one 资源文件中的value值为'白叶'，app.media.iconD为自定义资源
      new Contact($r('app.string.contacts_B_one'), $r('app.media.iconD')),
      // app.string.contacts_B_three 资源文件中的value值为'伯明'，app.media.iconE为自定义资源
      new Contact($r('app.string.contacts_B_three'), $r('app.media.iconE'))
    ],
    key: util.generateRandomUUID(true)
  } as ContactsGroup
];
export let contactsGroupsDataSource: ContactsGroupDataSource = new ContactsGroupDataSource(contactsGroups);

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
    // [StartExclude add_sticky_titles]
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.StickyHeaderList_titleExample') }) {
          // [EndExclude add_sticky_titles]
          List() {
            // 懒加载ListItemGroup，contactsGroups为多个分组联系人contacts和标题title的数据集合
            LazyForEach(contactsGroupsDataSource, (itemGroup: ContactsGroup) => {
              ListItemGroup({ header: this.itemHead(itemGroup.title) }) {
                // 循环渲染ListItem
                if (itemGroup.contacts) {
                  LazyForEach(new ContactsGroupDataSource(itemGroup.contacts), (item: Contact) => {
                    ListItem() {
                      // [StartExclude add_sticky_titles]
                      Row() {
                        Image(item.icon).width(40).height(40).margin(10)
                        Text(item.name).fontSize(20)
                      }.width('100%').justifyContent(FlexAlign.Start)
                      // [EndExclude add_sticky_titles]
                    }
                  }, (item: Contact) => JSON.stringify(item))
                }
              }
            }, (itemGroup: ContactsGroup) => JSON.stringify(itemGroup))
          }
          .sticky(StickyStyle.Header) // 设置吸顶，实现粘性标题效果
          // [StartExclude add_sticky_titles]
          .height(230)
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.StickyHeaderList_title'))
    // [EndExclude add_sticky_titles]
  }
}
// [End add_sticky_titles]
