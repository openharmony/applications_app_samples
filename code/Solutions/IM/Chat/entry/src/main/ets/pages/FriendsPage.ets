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

import router from '@ohos.router'
import { BasicDataSource, ChatContact } from "@ohos/chatList"
import Constants from '@ohos/chatList/src/main/ets/utils/Constants'
import { getChatModelObjFromJSON } from '@ohos/chatList/src/main/ets/utils/DataFactory'
import Logger from '../common/Logger'

const TAG: string = 'entry_FriendsPage'
const CHAT_DETAIL_PAGE: string = 'pages/ChatDetailPage'

@Component
export struct FriendsPage {
  @State friendsListLength: number = 0
  private friendListData = new FriendListData()
  private friendsPageItem = [
    { image: $r('app.media.icon_addfriend'), text: $r('app.string.new_friend') },
    { image: $r('app.media.icon_group'), text: $r('app.string.group') },
    { image: $r('app.media.chat_home'), text: $r('app.string.only_chat') },
    { image: $r('app.media.label'), text: $r('app.string.label') },
    { image: $r('app.media.public'), text: $r('app.string.official_account') },
    { image: $r('app.media.icon_public'), text: $r('app.string.subscription') },
    { image: $r('app.media.empresa'), text: $r('app.string.enterprise') }]

  build() {
    Column() {
      Stack({ alignContent: Alignment.Top }) {
        Column() {
          List() {
            ListItem() {
              Column() {
                Stack({ alignContent: Alignment.Center }) {
                  Text($r('app.string.search'))
                    .fontSize(20)
                }
                .backgroundColor(Color.White)
                .height('50')
                .width($r('app.string.layout_100'))
                .margin({ left: 10, right: 10, top: 5, bottom: 5 })
                .onClick(() => {
                  router.pushUrl({ url: 'pages/SearchPage' })
                })
                List({ space: 2, initialIndex: 0 }) {
                  ForEach(this.friendsPageItem, (item) => {
                    ListItem() {
                      EMContactItemView({ image: item.image, text: item.text })
                    }
                  }, item => JSON.stringify(item))
                }
              }
            }

            LazyForEach(this.friendListData, (msg: ChatContact) => {
              ListItem() {
                EMContactItemView({ image: msg.userImage, text: msg.userName })
              }
              .onClick(() => {
                router.pushUrl({
                  url: CHAT_DETAIL_PAGE,
                  params: { chatImage: msg.userImage, chatName: msg.userName, chatId: msg.userId } })
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
    .backgroundColor('#e3e3e3')
    .width($r('app.string.layout_100'))
    .height($r('app.string.layout_100'))
  }

  async aboutToAppear(): Promise<void> {
    Logger.info(TAG, 'aboutToAppear')
    await this.makeDataLocal()
  }

  async makeDataLocal() {
    Logger.info(TAG, 'makeDataLocal')
    let chatModelMockData = await getChatModelObjFromJSON()
    for (let i = 0; i < Constants.DATA_MOCK_COUNT; i++) {
      this.friendListData.pushData(chatModelMockData[i].user)
    }
  }
}

@Component
export struct EMContactItemView {
  private image: string | Resource
  private text: string | Resource

  build() {
    Row() {
      Image(this.image)
        .width(40)
        .height(40)
        .borderRadius(5)
      Text(this.text)
        .fontSize(15)
        .fontColor($r('app.color.friend_page_text'))
        .margin({ left: 10 })
    }
    .width($r('app.string.layout_100'))
    .height(60)
    .padding({ left: 10, right: 10 })
    .backgroundColor(Color.White)
  }
}

class FriendListData extends BasicDataSource {
  friendList: Array<ChatContact> = []

  public totalCount(): number {
    return this.friendList.length
  }

  public getData(index: number): any {
    return this.friendList[index]
  }

  public addData(index: number, data: ChatContact): void {
    this.friendList.splice(index, 0, data)
    this.notifyDataAdd(index)
  }

  public pushData(data: ChatContact): void {
    this.friendList.push(data)
    this.notifyDataAdd(this.friendList.length - 1)
  }
}