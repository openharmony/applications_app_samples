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
import { BasicDataSource, ChatContact } from '@ohos/chatList';
import Constants from '@ohos/chatList/src/main/ets/utils/Constants';
import PageConstants from '@ohos/chatList/src/main/ets/utils/PageConstants';
import { getChatModelObjFromJSON } from '@ohos/chatList/src/main/ets/utils/DataFactory';
import Logger from '@ohos/chatList/src/main/ets/utils/Logger';

const TAG: string = 'entry_FriendsPage';
const LIST_SPACE: number = 2;
const LIST_INITIAL_INDEX: number = 0;

/**
 * 通讯录页面组件
 */
@Component
export struct FriendsPage {
  @State friendsListLength: number = 0;
  private friendsListData = new FriendsListData();
  private friendsPageItem = [
    { image: $r('app.media.icon_addfriend'), text: $r('app.string.new_friend') },
    { image: $r('app.media.icon_group'), text: $r('app.string.group') },
    { image: $r('app.media.chat_home'), text: $r('app.string.only_chat') },
    { image: $r('app.media.label'), text: $r('app.string.label') },
    { image: $r('app.media.public'), text: $r('app.string.official_account') },
    { image: $r('app.media.icon_public'), text: $r('app.string.subscription') },
    { image: $r('app.media.empresa'), text: $r('app.string.enterprise') }];

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
          List() {
            ListItem() {
              Column() {
                Stack({ alignContent: Alignment.Center }) {
                  Text($r('app.string.search'))
                    .fontSize($r('app.integer.text_font_20'))
                }
                .backgroundColor(Color.White)
                .height($r('app.string.layout_50'))
                .width($r('app.string.layout_100_percent'))
                .margin({
                  left: $r('app.integer.layout_10'),
                  right: $r('app.integer.layout_10'),
                  top: $r('app.integer.layout_5'),
                  bottom: $r('app.integer.layout_5')
                })
                .onClick(() => {
                  router.pushUrl({ url: PageConstants.SEARCH_PAGE });
                })

                List({ space: LIST_SPACE, initialIndex: LIST_INITIAL_INDEX }) {
                  ForEach(this.friendsPageItem, (item) => {
                    ListItem() {
                      ChatContactItemView({ image: item.image, text: item.text })
                    }
                  }, item => JSON.stringify(item))
                }
              }
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
            }, (msg: ChatContact) => msg.userId)
          }
          .listDirection(Axis.Vertical)
          .width($r('app.string.layout_100'))
          .height($r('app.string.layout_100'))
        }
      }
      .width($r('app.string.layout_100'))
    }
    .backgroundColor($r('app.color.friends_page_background'))
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
  }

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToAppear');
    await this.makeDataLocal();
  }

  async makeDataLocal(): Promise<void> {
    Logger.info(TAG, 'makeDataLocal');
    let chatModelMockData = await getChatModelObjFromJSON();
    for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
      this.friendsListData.pushData(chatModelMockData[i].user);
    }
  }
}

/**
 * 通讯录页面中，联系人布局组件
 */
@Component
export struct ChatContactItemView {
  private image: string | Resource;
  private text: string | Resource;

  build() {
    Row() {
      Image(this.image)
        .width($r('app.integer.layout_40'))
        .height($r('app.integer.layout_40'))
        .borderRadius($r('app.integer.layout_5'))
      Text(this.text)
        .fontSize($r('app.integer.layout_15'))
        .fontColor($r('app.color.friends_page_text_color'))
        .margin({ left: $r('app.integer.layout_10') })
    }
    .width($r('app.string.layout_100'))
    .height($r('app.integer.layout_60'))
    .padding({ left: $r('app.integer.layout_10'), right: $r('app.integer.layout_10') })
    .backgroundColor(Color.White)
  }
}

class FriendsListData extends BasicDataSource {
  friendsList: Array<ChatContact> = [];

  public totalCount(): number {
    return this.friendsList.length;
  }

  public getData(index: number): any {
    return this.friendsList[index];
  }

  public addData(index: number, data: ChatContact): void {
    this.friendsList.splice(index, 0, data);
    this.notifyDataAdd(index);
  }

  public pushData(data: ChatContact): void {
    this.friendsList.push(data);
    this.notifyDataAdd(this.friendsList.length - 1);
  }
}