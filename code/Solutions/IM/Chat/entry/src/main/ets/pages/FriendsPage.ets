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

@Component
export struct FriendsPage {
  @State friendsListLength: number = 0
  private friendListData = new FriendListData()

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
                .width('100%')
                .margin({ left: 10, right: 10, top: 5, bottom: 5 })
                .onClick(() => {
                  router.pushUrl({ url: 'pages/SearchPage' })
                })

                Column() {
                  EMContactItemView({ image: $r('app.media.icon_addfriend'), text: $r('app.string.new_friend') })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.icon_group'), text: $r('app.string.group') })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.chat_home'), text: $r('app.string.only_chat') })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.label'), text: $r('app.string.label') })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.public'), text: $r('app.string.official_account') })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.empresa'), text: $r('app.string.enterprise') })
                }

                Column() {
                  EMContactItemView({ image: $r('app.media.icon_public'), text: $r('app.string.subscription') })
                }
              }
            }

            LazyForEach(this.friendListData, (msg: ChatContact) => {
              ListItem() {
                EMContactItemView({ image: msg.userImage, text: msg.userName })
              }
              .onClick(() => {
                router.pushUrl({
                  url: "pages/ChatDetailPage",
                  params: { chatImage: msg.userImage, chatName: msg.userName, chatId: msg.userId } })
              })
            }, (msg: ChatContact) => msg.userId)
          }
          .listDirection(Axis.Vertical)
          .height('100%')
          .width('100%')
        }
      }
      .width('100%')
    }
    .backgroundColor('#e3e3e3')
    .width('100%')
    .height('100%')
  }

  aboutToAppear(): void {
    this.makeDataLocal()
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }

  makeDataLocal() {
    for (let i = 0;i < 1000; i++) {
      let imageStr = `/resources/images/photo${(i % 50).toString()}.jpg`
      let temp1 = new ChatContact(i.toString(), `朋友${i.toString()}`, imageStr);
      this.friendListData.pushData(temp1)
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
        .fontColor("#000000")
        .margin({ left: 10 })
    }
    .width('100%')
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