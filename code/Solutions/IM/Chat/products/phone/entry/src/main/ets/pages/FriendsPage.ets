/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';
import { BasicDataSource, ChatContact } from '@ohos/chatlist';
import Constants from '@ohos/chatlist/src/main/ets/utils/Constants';
import PageConstants from '@ohos/chatlist/src/main/ets/utils/PageConstants';
import { getChatModelObjFromJSON } from '@ohos/chatlist/src/main/ets/utils/DataFactory';
import Logger from '@ohos/chatlist/src/main/ets/utils/Logger';
import hiTraceMeter from '@ohos.hiTraceMeter';
import ChatListJsonData from '@ohos/chatlist/src/main/ets/utils/ChatListJsonData';

const TAG: string = 'entry_FriendsPage';
const LIST_SPACE: number = 0; // 列表默认间隔
const LAYOUT_WEIGHT: number = 1; // 自动分配剩余空间
const LIST_INITIAL_INDEX: number = 0;
const ABOUT_TO_APPEAR_TRACE: string = 'FriendsPage_AboutToAppear_HiTrace';
const ABOUT_TO_APPEAR_TRACE_ID: number = 1; // aboutToAppear 中使用的 taskId
const MAKE_DATA_LOCAL_TRACE: string = 'FriendsPage_MakeDataLocal_HiTrace';
const MAKE_DATA_LOCAL_TRACE_ID: number = 2; // makeDataLocal 中使用的 taskId
const ID_SEARCH: string = 'search'; // 搜索框中搜索栏的ID

class FriendsPageItemType {
  image: string | Resource = '';
  text: string | Resource = '';
}

/**
 * 通讯录页面组件
 */
@Preview
@Component
export struct FriendsPage {
  @State friendsListLength: number = 0;
  private friendsListData: FriendListData = new FriendListData();
  private friendsPageItem: FriendsPageItemType[] = [
    { image: $r('app.media.new_friend'), text: $r('app.string.new_friend') },
    { image: $r('app.media.group'), text: $r('app.string.group') },
    { image: $r('app.media.chat_only'), text: $r('app.string.only_chat') },
    { image: $r('app.media.label'), text: $r('app.string.label') },
    { image: $r('app.media.official_account'), text: $r('app.string.official_account') },
    { image: $r('app.media.subscription'), text: $r('app.string.subscription') },
    { image: $r('app.media.enterprise'), text: $r('app.string.enterprise') }];

  build() {
    Column() {
      Row() {
        Text($r('app.string.contacts'))
          .fontSize($r('app.integer.friends_page_title_font_size'))
          .fontWeight(FontWeight.Bold)
          .lineHeight($r('app.integer.friends_page_title_height'))
          .fontColor($r('app.color.title_font_color'))
          .fontFamily($r('app.string.harmony_hei_ti'))
          .height($r('app.integer.friends_page_title_height'))
      }
      .width($r('app.string.layout_100'))
      .height($r('app.integer.friends_page_title_bar_height'))
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      // 搜索栏
      Row() {
        Search({ placeholder: $r('app.string.search_place_holder') })
          .enableKeyboardOnFocus(false)
          .placeholderFont({ size: $r('app.integer.search_font_size') })
          .searchIcon({
            src: $r('app.media.search_svg'),
            size: $r('app.integer.search_svg_height')
          })
          .placeholderColor($r('app.string.search_inline_border_color'))
          .backgroundColor(Color.White)
          .height($r('app.integer.search_inline_height'))
          .width($r('app.string.layout_100'))
          .textFont({ size: $r('app.integer.search_font_size') })
          .border({
            width: $r('app.float.search_inline_border_width'),
            color: $r('app.string.search_inline_border_color')
          })
          .borderRadius($r('app.integer.search_border_radius'))
          .id(ID_SEARCH)
      }
      .alignItems(VerticalAlign.Center)
      .justifyContent(FlexAlign.Center)
      .height($r('app.integer.search_outline_height'))
      .width($r('app.string.layout_100'))
      .backgroundColor($r('app.color.search_outline_background_color'))
      .margin({ top: $r('app.integer.discovery_list_margin_top') })

      List() {
        ListItem() {
          List({ space: LIST_SPACE, initialIndex: LIST_INITIAL_INDEX }) {
            ForEach(this.friendsPageItem, (item: FriendsPageItemType) => {
              ListItem() {
                ChatContactItemView({ image: item.image, text: item.text })
              }
            }, (item: FriendsPageItemType) => JSON.stringify(item))
          }
          .divider({
            strokeWidth: $r('app.integer.friends_page_divider_width'),
            color: $r('app.color.friends_page_divider_color'),
            startMargin: $r('app.integer.friends_page_search_divider_start_margin')
          })
        }

        LazyForEach(this.friendsListData, (msg: ChatContact) => {
          ListItem() {
            ChatContactItemView({ image: msg.userImage, text: msg.userName })
          }
          .onClick(() => {
            router.pushUrl({
              url: PageConstants.CHAT_DETAIL_PAGE,
              params: { chatImage: msg.userImage, chatName: msg.userName, chatId: msg.userId } });
          })
        })
      }
      .layoutWeight(LAYOUT_WEIGHT)
      .divider({
        strokeWidth: $r('app.integer.friends_page_divider_width'),
        color: $r('app.color.friends_page_divider_color'),
        startMargin: $r('app.integer.friends_page_search_divider_start_margin')
      })
    }
    .backgroundColor($r('app.color.friends_page_background'))
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
    .padding({
      left: $r('app.integer.friends_page_padding_left'),
      right: $r('app.integer.friends_page_padding_left')
    })
  }

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToAppear');
    hiTraceMeter.startTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
    await this.makeDataLocal();
    hiTraceMeter.finishTrace(ABOUT_TO_APPEAR_TRACE, ABOUT_TO_APPEAR_TRACE_ID);
  }

  async makeDataLocal(): Promise<void> {
    Logger.info(TAG, 'makeDataLocal');
    hiTraceMeter.startTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
    // 循环获取两个json文件，如若单个文件可能导致过大无法读取
    for (let i = 0; i < ChatListJsonData.CHAT_LIST_JSON_DATA.length; i++) {
      let chatModelMockData = await getChatModelObjFromJSON(ChatListJsonData.CHAT_LIST_JSON_DATA[i]);
      for (let j = 0; j < Constants.DATA_MOCK_COUNT; j++) {
        this.friendsListData.pushData(chatModelMockData[j].user);
      }
    }
    hiTraceMeter.finishTrace(MAKE_DATA_LOCAL_TRACE, MAKE_DATA_LOCAL_TRACE_ID);
  }
}

/**
 * 通讯录页面中，联系人布局组件
 */
@Component
export struct ChatContactItemView {
  private image: string | Resource = '';
  private text: string | Resource = '';

  build() {
    Row() {
      Image(this.image)
        .width($r('app.integer.friends_page_contact_image_width'))
        .height($r('app.integer.friends_page_contact_image_width'))
        .borderRadius($r('app.integer.friends_page_contact_image_border_radius'))
      Text(this.text)
        .width($r('app.integer.friends_page_contact_text_width'))
        .height($r('app.integer.friends_page_contact_text_height'))
        .fontSize($r('app.integer.friends_page_contact_text_font_size'))
        .fontFamily($r('app.string.harmony_hei_ti'))
        .fontColor($r('app.color.title_font_color'))
        .fontWeight(FontWeight.Bold)
        .margin({ left: $r('app.integer.friends_page_contact_text_margin_left') })
    }
    .width($r('app.string.layout_100'))
    .height($r('app.integer.friends_page_contact_row_height'))
    .backgroundColor(Color.White)
  }
}

class FriendListData extends BasicDataSource<ChatContact> {
  friendList: Array<ChatContact> = [];

  public totalCount(): number {
    return this.friendList.length;
  }

  public getData(index: number): ChatContact {
    return this.friendList[index];
  }

  public addData(index: number, data: ChatContact): void {
    this.friendList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: ChatContact): void {
    this.friendList.push(data);
    this.notifyDataAdd(this.friendList.length - 1);
  }
}