/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { CategoryContact, Contact } from '../model/Contact';
import { JSON } from '@kit.ArkTS';
import { ContactDataSource } from '../model/DataSource';
import { CommonConstants } from '../constant/CommonConstant';

// TODO:知识点：@Reusable表示组件可以被复用，结合LazyForEach懒加载一起使用，可以进一步解决列表滑动场景的瓶颈问题，提供滑动场景下高性能创建组件的方式来提升滑动帧率。
//  参考链接：https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/performance/component_recycle_case.md
@Reusable
@Component
struct ItemComponent {
  @State name: string = ''

  aboutToReuse(params: Record<string, ESObject>) {
    this.name = params.name;
  }

  build() {
    Text(this.name)
      .width(CommonConstants.FULL_PERCENT)
      .height($r('app.integer.operate_rdb_in_taskpool_list_item_height'))
      .fontSize($r('app.integer.operate_rdb_in_taskpool_list_font_size'))
      .padding({ left: $r('app.integer.operate_rdb_in_taskpool_list_padding_left') })

  }
}

@Component
export struct AddressBookList {
  private scroller: Scroller = new Scroller();
  @State pageInfos: NavPathStack = new NavPathStack();
  // 数据源
  @State sourceArray: ContactDataSource = new ContactDataSource();
  @StorageProp('categoryArray') categoryArray: Array<string> = [];
  @State selectIndex: number = 0;

  @Builder
  itemHead(text: string) {
    // 列表分组的头部组件，对应联系人分组A、B等位置的组件
    Text(text)
      .fontSize($r('app.integer.operate_rdb_in_taskpool_list_head_font_size'))
      .fontWeight(FontWeight.Medium)
      .width(CommonConstants.FULL_PERCENT)
      .height($r('app.integer.operate_rdb_in_taskpool_list_head_height'))
      .backgroundColor($r('app.color.operate_rdb_in_taskpool_list_head_background_color'))
      .padding({ left: $r('app.integer.operate_rdb_in_taskpool_list_head_padding_left') })
  }

  build() {
    Stack({ alignContent: Alignment.End }) {
      List({
        space: CommonConstants.LIST_SPACE,
        initialIndex: CommonConstants.INITIAL_INDEX,
        scroller: this.scroller
      }) {
        LazyForEach(this.sourceArray, (item: CategoryContact, indexGroup: number) => {
          ListItemGroup({ header: this.itemHead(item.category) }) {
            // 循环渲染ListItem
            ForEach(item.itemsContact, (contact: Contact, indexItem: number) => {
              ListItem() {
                ItemComponent({
                  name: contact.name
                })
              }
              .onClick(() => {
                // 跳转详情页
                this.pageInfos.pushDestinationByName('AddressBookDetail', {
                  contact: contact,
                  deleteCallback: (deleteContact: Contact) => {
                    // 删除通讯录回调数据处理
                    if (deleteContact.id === contact.id) {
                      this.sourceArray.deleteDataItem(this.categoryArray, indexGroup, indexItem);
                    }
                  },
                  editCallback: (editContact: Contact) => {
                    // 编辑通讯录回调数据处理
                    if (editContact.id === contact.id) {
                      this.sourceArray.updateDataItem(this.categoryArray, indexGroup, indexItem, editContact);
                    }
                  }
                })
              })
            }, (item: Contact) => item.id.toString())
          }
          .divider({
            strokeWidth: CommonConstants.STROKE_WIDTH_LIST,
            color: $r('app.color.operate_rdb_in_taskpool_list_divider_background_color'),
            startMargin: CommonConstants.START_MARGIN,
            endMargin: CommonConstants.END_MARGIN
          })
        }, (item: CategoryContact, index: number) => JSON.stringify(item) + index)
      }
      .cachedCount(CommonConstants.CACHE_COUNT)
      .width(CommonConstants.FULL_PERCENT)
      .layoutWeight(CommonConstants.LAYOUT_WEIGHT)
      .margin({
        top: $r('app.integer.operate_rdb_in_taskpool_list_margin_top'),
        bottom: $r('app.integer.operate_rdb_in_taskpool_list_margin_bottom')
      })
      .sticky(StickyStyle.Header)
      .scrollBar(BarState.Off)
      .onScrollIndex((firstIndex: number) => {
        this.selectIndex = firstIndex;
      })

      /* TODO：知识点：可以与容器组件联动用于按逻辑结构快速定位容器显示区域的组件，arrayValue为字母索引字符串数组，selected为初始选中项索引值。
       * 1. 当用户滑动List组件，list组件onScrollIndex监听到firstIndex的改变，绑定赋值给AlphabetIndexer的selected属性，从而定位到字母索引。
       * 2. 当点击AlphabetIndexer的字母索引时，通过scrollToIndex触发list组件滑动并指定firstIndex，从而实现List列表与AlphabetIndexer组件
       * 首字母联动吸顶展示。
       */
      AlphabetIndexer({ arrayValue: this.categoryArray, selected: this.selectIndex })
        .height(CommonConstants.FULL_PERCENT)
        .selectedColor($r('app.color.operate_rdb_in_taskpool_alphabet_selected_color'))// 选中项文本颜色
        .popupColor($r('app.color.operate_rdb_in_taskpool_alphabet_popup_color'))// 弹出框文本颜色
        .selectedBackgroundColor($r('app.color.operate_rdb_in_taskpool_alphabet_selected_bacground_color'))// 选中项背景颜色
        .popupBackground($r('app.color.operate_rdb_in_taskpool_alphabet_popup_background_color'))// 弹出框背景颜色
        .popupPosition({ x: CommonConstants.POPUP_X, y: CommonConstants.POPUP_Y })
        .usingPopup(true)// 是否显示弹出框
        .selectedFont({ size: CommonConstants.POPUP_SELECTED_FONT_SIZE, weight: FontWeight.Bolder })// 选中项字体样式
        .popupFont({ size: CommonConstants.POPUP_FONT_SIZE, weight: FontWeight.Bolder })// 弹出框内容的字体样式
        .alignStyle(IndexerAlign.Right)// 弹出框在索引条左侧弹出
        .itemSize(CommonConstants.POPUP_ITEM_SIZE)// 每一项的尺寸大小
        .margin({ right: $r('app.integer.operate_rdb_in_taskpool_alphabet_margin_right') })
        .onSelect((tabIndex: number) => {
          this.scroller.scrollToIndex(tabIndex);
        })
        .padding({ right: $r('app.integer.operate_rdb_in_taskpool_alphabet_padding_right') })

      Image($r('app.media.operate_rdb_in_taskpool_add'))
        .width($r('app.integer.operate_rdb_in_taskpool_add_image_width'))
        .height($r('app.integer.operate_rdb_in_taskpool_add_image_height'))
        .zIndex(CommonConstants.Z_INDEX)
        .position({
          bottom: CommonConstants.ADD_IMAGE_BOTTOM,
          right: CommonConstants.ADD_IMAGE_RIGHT
        })// TODO：知识点：通过x、y可以设置距左上的绝对位置，通过bottom、right可以设置距右下的绝对位置
        .onClick(() => {
          // 跳转新增页
          this.pageInfos.pushDestinationByName('AddressBookEdit', {
            contact: null,
            addCallback: (contact: Contact) => {
              this.sourceArray.pushDataItem(this.categoryArray, contact)
            },
            editCallback: null
          })
        });
    }
    .backgroundColor(Color.White)
  }
}
