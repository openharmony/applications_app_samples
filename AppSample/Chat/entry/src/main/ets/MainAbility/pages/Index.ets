// @ts-nocheck
/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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
import { ChatListView } from './ChatListPage'
import { DiscoverPage } from './DiscoverPage'
import { SettingPage } from './SettingPage'
import { FriendsPage } from './FriendsPage'
import { Prompt } from '../components/Header';

@Entry
@Component
struct Index {
  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            TopBar()
            ChatListView()
          }
        }
        .tabBar({ icon: $r('app.media.afr'), text: "聊天" })

        TabContent() {
          FriendsPage()
        }
        .tabBar({ icon: $r('app.media.contact_list_normal'), text: "通讯录" })

        TabContent() {
          DiscoverPage()
        }
        .tabBar({ icon: $r('app.media.find_normal'), text: "发现" })

        TabContent() {
          SettingPage()
        }
        .tabBar({ icon: $r('app.media.profile_normal'), text: "我" })
      }
      .barWidth(400)
      .barHeight(50)
      .animationDuration(0)
    }
    .width('100%')
    .height('100%')
  }

  pageTransition() {
    PageTransitionEnter({ duration: 0 })
    PageTransitionExit({ duration: 0 })
  }
}

@Component
struct TopBar {
  @State num: number = 0
  dialogController: CustomDialogController = new CustomDialogController({
    builder: CustomDialogExample({}),
    autoCancel: true,
    alignment: DialogAlignment.TopEnd,
    offset: { dx: "-5", dy: "40" },
    customStyle: true
  })

  build() {
    Row() {
      Column() {
        Stack({ alignContent: Alignment.Center }) {
          Stack({ alignContent: Alignment.Center }) {
            Text("聊天")
              .fontSize(20)
              .fontColor(Color.Black)
          }
          .height(50)
          .width("100%")

          Stack({ alignContent: Alignment.End }) {
            Stack({ alignContent: Alignment.End }) {
              Image($r('app.media.ic_public_add_filled'))
                .height(30)
                .width(30)
            }
            .key('addBtn')
            .height("100%")
            .width(50)
            .onClick(() => {
              this.dialogController.open()
            })
          }
          .height(50)
          .width("100%")
          .padding(10)
        }
        .backgroundColor('#eeeeee')
        .height(50)
        .width("100%")
      }
    }
    .width('100%')
    .height(50)
  }
}

@CustomDialog
struct CustomDialogExample {
  private asd = [[], [], [], []]
  controller: CustomDialogController

  build() {
    Column() {
      Column() {
        Prompt({ img: $r('app.media.pic1'), text: "添加好友" })
      }.onClick(() => {
        this.controller.close()
        router.push({ url: "pages/AddFriendsPage" })
      })

      Column() {
        Prompt({ img: $r('app.media.pic2'), text: "发起群聊" })
      }.onClick(() => {
        this.controller.close()
        router.push({ url: "pages/CreateGroupChatPage" })
      })

      Column() {
        Prompt({ img: $r('app.media.pic3'), text: "扫一扫" })
      }.onClick(() => {
        this.controller.close()
      })

      Column() {
        Prompt({ img: $r('app.media.pic4'), text: "收付款" })
      }.onClick(() => {
        this.controller.close()
      })

      Column() {
        Prompt({ img: $r('app.media.pic5'), text: "帮助与反馈" })
      }.onClick(() => {
        this.controller.close()
      })
    }
    .backgroundColor("#696969")
    .borderRadius(5)
    .padding({ left: 5, bottom: 5 })
    .width(120)
  }
}