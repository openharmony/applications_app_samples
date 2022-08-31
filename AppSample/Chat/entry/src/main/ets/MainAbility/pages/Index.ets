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
import featureAbility from '@ohos.ability.featureAbility'
import image from '@ohos.multimedia.image'
import fileio from '@ohos.fileio'
import { ChatListView } from './ChatListPage'
import { DiscoverPage } from './DiscoverPage'
import { SettingPage } from './SettingPage'
import { FriendsPage } from './FriendsPage'
import { Prompt } from '../components/Header';

const TAG: string = "[Sample_Chat]"

export class WantModel {
  srcImg: string
  textCon: string
  kindId: number

  constructor(srcImg: string, text: string, kindId: number) {
    this.srcImg = srcImg;
    this.textCon = text;
    this.kindId = kindId;
  }

  toString(): string {
    return this.srcImg + "  " + this.textCon + "  " + this.kindId
  }
}

export class WantFileModel {
  fdImg: number
  kindId: number
}

@Entry
@Component
struct Index {
  @State wantParams: WantModel = new WantModel("./resources/images/photo0.jpg", "111", 0)
  @State wantFileParams: WantFileModel = new WantFileModel()
  @State flagWant: boolean = false;
  @State _pixelMap: image.PixelMap = undefined
  @State imgSource: image.ImageSource = undefined

  private async getWant() {
    featureAbility.getWant()
      .then(async (data) => {
        console.info("Sample_Chat")
        let want = data;
        console.info(`${TAG}  getWant: want.parameters ---${JSON.stringify(want.parameters)}`)
        if (want.parameters) {
          // 文本、链接的参数处理
          this.wantParams.srcImg = want.parameters.srcImg;
          this.wantParams.textCon = want.parameters.text;
          this.wantParams.kindId = want.parameters.kindId;
          console.info(`${TAG} getWant: params.srcImg--- ${want.parameters.srcImg}`)
          console.info(`${TAG} getWant: params.textContent---${want.parameters.text}`)
          // 图片文件的参数处理
          this.wantFileParams.fdImg = want.parameters["keyFd"].value
          this.wantFileParams.kindId = want.parameters.kindId
          console.info(`${TAG} getWant: params.fdImg--- ${this.wantFileParams.fdImg} ,type: ${typeof (this.wantFileParams.fdImg)} `)
          console.info(`${TAG} getWant: params.kindId---${this.wantFileParams.kindId}`)
          let fd = want.parameters["keyFd"].value;
          console.info(`${TAG} getWant, fd111 = ${JSON.stringify(fd)}`)
          // Test
          let buf = new ArrayBuffer(90960);
          let opt = {
            offset: 0,
            position: 0,
            length: 90000
          }
          try {
            let readOut, view
            readOut = await fileio.readSync(fd, buf, opt)
            console.info(TAG + "getWant, fd222 = " + JSON.stringify(fd))
            console.info(TAG + "getWant, readLength = " + JSON.stringify(readOut))
            console.info(TAG + "getWant, buf = " + JSON.stringify(buf))
            view = new Uint32Array(buf)
            console.info(TAG + "getWant, view = " + JSON.stringify(view))
          } catch (e) {
            console.info(TAG + "getWant, e = " + JSON.stringify(e))
          }
          // 查看fd是否传来成功
          try {
            let stat = fileio.fstatSync(this.wantFileParams.fdImg)
            console.info(TAG + `getWant ,stat ---${stat.uid}`)
          } catch (error) {
            console.info(TAG + 'getWant ,stat error')
          }
          this.flagWant = true;
          return this.flagWant;
        }
        return this.flagWant;

      })
  }

  private aboutToAppear(): void {
    this.getWant();
  }

  build() {
    Column() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            TopBar()
            ChatListView({ wantParams: this.wantParams, wantFileParams: this.wantFileParams })
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