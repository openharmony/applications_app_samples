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

//[Start List_item_data_structure]
import { curves } from '@kit.ArkUI';
//[StartExclude List_item_data_structure]
import { ComponentCard } from '../../common/Card';

// [EndExclude List_item_data_structure]
interface ItemInfo {
  index: number,
  name: string,
  label: ResourceStr,
  type?: string,
}

interface ItemGroupInfo extends ItemInfo {
  children: ItemInfo[]
}

//[End List_item_data_structure]

@Entry
@Component
export struct CollapseAndExpand {
  //[Start List_item_data_structure]
  @State routes: ItemGroupInfo[] = [
    {
      index: 0,
      name: 'basicInfo',
      label: 'Personal_Basic_Information',
      children: [
        {
          index: 0,
          name: 'nick_name',
          label: 'xxxx',
          type: 'Text'
        },
        {
          index: 1,
          name: 'avatar',
          label: $r('sys.media.ohos_user_auth_icon_face'),
          type: 'Image'
        },
        {
          index: 2,
          name: 'age',
          label: 'xxxx',
          type: 'Text'
        },
        {
          index: 3,
          name: 'birthday',
          label: 'xxxxxxxxx',
          type: 'Text'
        },
        {
          index: 4,
          name: 'gender',
          label: 'xxxxxxxx',
          type: 'Text'
        },
      ]
    },
    {
      index: 1,
      name: 'equipInfo',
      label: 'Device_Information',
      children: []
    },
    {
      index: 2,
      name: 'appInfo',
      label: 'Application_usage_information',
      children: []
    },
    {
      index: 3,
      name: 'uploadInfo',
      label: 'data_you_voluntarily_uploaded',
      children: []
    },
    {
      index: 4,
      name: 'tradeInfo',
      label: 'Trading_and_asset_information',
      children: []
    },
    {
      index: 5,
      name: 'otherInfo',
      label: 'Other_materials',
      children: []
    },
  ];
  @State expandedItems: boolean[] = Array(this.routes.length).fill(false);
  @State selection: string | null = null;

  //[Start List_item_data_structure]
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

  //[End List_item_data_structure]
  build() {
    //[StartExclude List_item_data_structure]
    NavDestination() {
      Column({ space: 12 }) {
        // $r('app.string.CollapseAndExpand_title')需要替换为开发者所需的资源文件
        ComponentCard({ title: $r('app.string.CollapseAndExpand_title') }) {
          // [EndExclude List_item_data_structure]
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
                          // $r('app.string.ohos_ic_public_arrow_right')需要替换为开发者所需的资源文件
                          Image($r('sys.media.ohos_ic_public_arrow_right'))
                          // $r('app.string.ohos_id_color_fourth')需要替换为开发者所需的资源文件
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
          // $r('app.string.ohos_id_color_sub_background')需要替换为开发者所需的资源文件
          .backgroundColor($r('sys.color.ohos_id_color_sub_background'))
        }

        //[End List_item_data_structure]
      }
      //[StartExclude List_item_data_structure]
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    // [EndExclude List_item_data_structure]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.CollapseAndExpand_title'))
  }
}