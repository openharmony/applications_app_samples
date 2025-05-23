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

import { curves } from '@kit.ArkUI';
import { ComponentCard } from '../../common/Card';

interface ItemInfo {
  index: number,
  name: string,
  label: ResourceStr,
  type?: string,
}

interface ItemGroupInfo extends ItemInfo {
  children: ItemInfo[]
}


@Entry
@Component
export struct CollapseAndExpand {
  @State routes: ItemGroupInfo[] = [
    {
      index: 0,
      name: 'basicInfo',
      label: '个人基本资料',
      children: [
        {
          index: 0,
          name: '昵称',
          label: 'xxxx',
          type: 'Text'
        },
        {
          index: 1,
          name: '头像',
          label: $r('sys.media.ohos_user_auth_icon_face'),
          type: 'Image'
        },
        {
          index: 2,
          name: '年龄',
          label: 'xxxx',
          type: 'Text'
        },
        {
          index: 3,
          name: '生日',
          label: 'xxxxxxxxx',
          type: 'Text'
        },
        {
          index: 4,
          name: '性别',
          label: 'xxxxxxxx',
          type: 'Text'
        },
      ]
    },
    {
      index: 1,
      name: 'equipInfo',
      label: '设备信息',
      children: []
    },
    {
      index: 2,
      name: 'appInfo',
      label: '应用使用信息',
      children: []
    },
    {
      index: 3,
      name: 'uploadInfo',
      label: '您主动上传的数据',
      children: []
    },
    {
      index: 4,
      name: 'tradeInfo',
      label: '交易与资产信息',
      children: []
    },
    {
      index: 5,
      name: 'otherInfo',
      label: '其他资料',
      children: []
    },
  ];

  @State expandedItems: boolean[] = Array(this.routes.length).fill(false);
  @State selection: string | null = null;

  @Builder
  ListItemGroupHeader(itemGroup: ItemGroupInfo) {
    Row() {
      Text(itemGroup.label)
      Blank()
      Image($r('sys.media.ohos_ic_public_arrow_down'))
        .fillColor($r('sys.color.ohos_id_color_fourth'))
        .height(30)
        .width(30)
        .rotate({ angle: !!itemGroup.children.length ? (this.expandedItems[itemGroup.index] ? 180 : 0) : 180 })
        .animation({ curve: curves.interpolatingSpring(0, 1, 228, 22) })
    }
    .width("100%")
    .padding(10)
    .animation({ curve: curves.interpolatingSpring(0, 1, 528, 39) })
    .onClick(() => {
      if (itemGroup.children.length) {
        this.getUIContext()?.animateTo({ curve: curves.interpolatingSpring(0, 1, 528, 39) }, () => {
          this.expandedItems[itemGroup.index] = !this.expandedItems[itemGroup.index];
        })
      }
    })
  }
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard({ title: $r('app.string.CollapseAndExpand_title') }) {
          Column() {
            List({ space: 10 }) {
              ForEach(this.routes, (itemGroup: ItemGroupInfo) => {
                ListItemGroup({
                  header: this.ListItemGroupHeader(itemGroup),
                  style: ListItemGroupStyle.CARD,
                }) {
                  if (this.expandedItems[itemGroup.index] && itemGroup.children) {
                    ForEach(itemGroup.children, (item: ItemInfo) => {
                      ListItem({ style: ListItemStyle.CARD }) {
                        Row() {
                          Text(item.name)
                          Blank()
                          if (item.type === 'Image') {
                            Image(item.label)
                              .height(20)
                              .width(20)
                          } else {
                            Text(item.label)
                          }
                          Image($r('sys.media.ohos_ic_public_arrow_right'))
                            .fillColor($r('sys.color.ohos_id_color_fourth'))
                            .height(30)
                            .width(30)
                        }
                        .width("100%")
                      }
                      .width("100%")
                      .animation({ curve: curves.interpolatingSpring(0, 1, 528, 39) })
                    })
                  }
                }.clip(true)
              })
            }
            .width("100%")
          }
          .width('100%')
          .height('100%')
          .justifyContent(FlexAlign.Start)
          .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CollapseAndExpand_title'))
  }

}