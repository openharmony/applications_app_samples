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
//[Start data_structures_head]
import { curves } from '@kit.ArkUI';

interface ItemInfo {
  index: number,
  name: ResourceStr,
  label: ResourceStr,
  type?: string,
}

interface ItemGroupInfo extends ItemInfo {
  children: ItemInfo[]
}
//[End data_structures_head]

@Entry
@Component
export struct CollapseAndExpand {
  //[Start list_item_data_structure]
  @State routes: ItemGroupInfo[] = [
    {
      index: 0,
      name: 'basicInfo',
      // app.string.Personal_Basic_Information 资源文件中的value值为'个人基本资料'
      label: $r('app.string.Personal_Basic_Information'),
      children: [
        {
          index: 0,
          // app.string.nick_name 资源文件中的value值为'昵称'
          name: $r('app.string.nick_name'),
          label: 'xxxx',
          type: 'Text'
        },
        {
          index: 1,
          // app.string.avatar 资源文件中的value值为'头像'
          name: $r('app.string.avatar'),
          label: $r('sys.media.ohos_user_auth_icon_face'),
          type: 'Image'
        },
        {
          index: 2,
          // app.string.age 资源文件中的value值为'年龄'
          name: $r('app.string.age'),
          label: 'xxxx',
          type: 'Text'
        },
        {
          index: 3,
          // app.string.birthday 资源文件中的value值为'性别'
          name: $r('app.string.birthday'),
          label: 'xxxxxxxxx',
          type: 'Text'
        },
        {
          index: 4,
          // app.string.gender 资源文件中的value值为''
          name: $r('app.string.gender'),
          label: 'xxxxxxxx',
          type: 'Text'
        },
      ]
    },
    {
      index: 1,
      name: 'equipInfo',
      // app.string.Device_Information 资源文件中的value值为'设备信息'
      label: $r('app.string.Device_Information'),
      children: []
    },
    {
      index: 2,
      name: 'appInfo',
      // app.string.Application_usage_information 资源文件中的value值为'应用使用信息'
      label: $r('app.string.Application_usage_information'),
      children: []
    },
    {
      index: 3,
      name: 'uploadInfo',
      // app.string.data_you_voluntarily_uploaded 资源文件中的value值为'您主动上传的数据'
      label: $r('app.string.data_you_voluntarily_uploaded'),
      children: []
    },
    {
      index: 4,
      name: 'tradeInfo',
      // app.string.Trading_and_asset_information 资源文件中的value值为'交易与资产信息'
      label: $r('app.string.Trading_and_asset_information'),
      children: []
    },
    {
      index: 5,
      name: 'otherInfo',
      // app.string.Other_materials 资源文件中的value值为'其他资料'
      label: $r('app.string.Other_materials'),
      children: []
    },
  ];
  @State expandedItems: boolean[] = Array(this.routes.length).fill(false);
  @State selection: string | null = null;

  //[StartExclude list_item_data_structure]
  //[Start list_item_data_group_info]
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
  //[End list_item_data_group_info]
  //[EndExclude list_item_data_structure]

  build() {
    //[StartExclude list_item_data_structure]
    NavDestination() {
      Column({ space: 12 }) {
        // $r('app.string.CollapseAndExpand_title')需要替换为开发者所需的资源文件
        ComponentCard({ title: $r('app.string.CollapseAndExpand_title') }) {
          // [EndExclude list_item_data_structure]
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
          //[StartExclude list_item_data_structure]
        }
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CollapseAndExpand_title'))
    // [EndExclude list_item_data_structure]
  }
}
//[End list_item_data_structure]