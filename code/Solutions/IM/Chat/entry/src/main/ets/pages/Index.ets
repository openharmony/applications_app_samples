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

import { ChatListView } from './ChatListPage'
import { FriendsPage } from './FriendsPage'
import { DiscoverPage } from './DiscoverPage'
import { SettingPage } from './SettingPage'
import fileio from '@ohos.fileio'
import Want from '@ohos.app.ability.Want'
import Logger from '../common/Logger';

const TAG: string = "[Sample_Chat]"

export class WantModel {
  srcImg: string
  textCon: string
  kindId: number

  constructor(srcImg?: string, text?: string, kindId?: number) {
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

  constructor(fdImg?: number , kindId?: number ) {
    this.fdImg = fdImg;
    this.kindId = kindId;
  }
}

@Entry
@Component
struct Index {
  wantParams: WantModel = new WantModel("./resources/images/photo0.jpg", "111", 0)
  wantFileParams: WantFileModel = new WantFileModel()
  @State flagWant: boolean = false;
  @State want: Want = undefined

  private async getWant() {
    Logger.info(`${TAG}  get want start`)
    this.want = AppStorage.Get("want")
    Logger.info(`${TAG}  getWant: want.parameters ---${JSON.stringify(this.want.parameters)}`)
    if (this.want.parameters) {
      // 文本、链接的参数处理
      this.wantParams.srcImg = this.want.parameters.srcImg as string;
      this.wantParams.textCon = this.want.parameters.text as string;
      this.wantParams.kindId = this.want.parameters.kindId as number;
      Logger.info(`${TAG} getWant: params.srcImg--- ${this.want.parameters.srcImg}`)
      Logger.info(`${TAG} getWant: params.textContent---${this.want.parameters.text}`)
      // 图片文件的参数处理
      // @ts-ignore
      this.wantFileParams.fdImg = this.want.parameters["keyFd"].value
      this.wantFileParams.kindId = this.want.parameters.kindId as number
      Logger.info(`${TAG} getWant: params.fdImg--- ${this.wantFileParams.fdImg} ,type: ${typeof (this.wantFileParams.fdImg)} `)
      Logger.info(`${TAG} getWant: params.kindId---${this.wantFileParams.kindId}`)
      let fd = this.want.parameters["keyFd"] as number;
      Logger.info(`${TAG} getWant, fd111 = ${JSON.stringify(fd)}`)
      // Test
      let buf = new ArrayBuffer(90960);
      let opt = {
        offset: 0,
        position: 0,
        length: 90000
      }
      try {
        let readOut, view
        readOut = fileio.readSync(fd, buf, opt)
        Logger.info(TAG + "getWant, fd = " + JSON.stringify(fd))
        Logger.info(TAG + "getWant, readLength = " + JSON.stringify(readOut))
        Logger.info(TAG + "getWant, buf = " + JSON.stringify(buf))
        view = new Uint32Array(buf)
        Logger.info(TAG + "getWant, view = " + JSON.stringify(view))
      } catch (e) {
        Logger.info(TAG + "getWant, e = " + JSON.stringify(e))
      }
      // 查看fd是否传来成功
      try {
        let stat = fileio.fstatSync(this.wantFileParams.fdImg)
        Logger.info(TAG + `getWant ,stat ---${stat.uid}`)
      } catch (error) {
        Logger.info(TAG + 'getWant ,stat error')
      }
      this.flagWant = true;
      return this.flagWant;
    }
    return this.flagWant;

  }

  aboutToAppear(): void {
    this.getWant();
  }

  onPageShow(){
    this.getWant();
  }

  build() {
    Row() {
      Tabs({ barPosition: BarPosition.End }) {
        TabContent() {
          Column() {
            TopBar()
            ChatListView({ wantParams: this.wantParams, wantFileParams: this.wantFileParams })
          }
        }
        .tabBar({ icon: $r('app.media.afr'), text: $r('app.string.chat') })

        TabContent() {
          FriendsPage()
        }
        .tabBar({ icon: $r('app.media.contact_list_normal'), text: $r('app.string.contacts') })

        TabContent() {
          DiscoverPage()
        }
        .tabBar({ icon: $r('app.media.find_normal'), text: $r('app.string.discovery') })

        TabContent() {
          SettingPage()
        }
        .tabBar({ icon: $r('app.media.profile_normal'), text: $r('app.string.my') })
      }
      .backgroundColor('#eeeeee')
      .barWidth(400)
      .barHeight(50)
      .animationDuration(0)
    }
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
            Text($r('app.string.chat'))
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
            .id('addBtn')
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
  controller: CustomDialogController

  build() {
    Column() {
      Column() {
        Prompt({ img: $r('app.media.pic1'), text: $r('app.string.add_friends') })
      }.onClick(() => {
        this.controller.close()
        AlertDialog.show(
          {
            message: $r('app.string.alert_dialog'),
          }
        )
      })

      Column() {
        Prompt({ img: $r('app.media.pic2'), text: $r('app.string.group_chat') })
      }.onClick(() => {
        this.controller.close()
        AlertDialog.show(
          {
            message: $r('app.string.alert_dialog'),
          }
        )
      })

      Column() {
        Prompt({ img: $r('app.media.pic3'), text: $r('app.string.scan') })
      }.onClick(() => {
        this.controller.close()
        AlertDialog.show(
          {
            message: $r('app.string.alert_dialog'),
          }
        )
      })

      Column() {
        Prompt({ img: $r('app.media.pic4'), text: $r('app.string.collection_payment') })
      }.onClick(() => {
        this.controller.close()
        AlertDialog.show(
          {
            message: $r('app.string.alert_dialog'),
          }
        )
      })

    }
    .backgroundColor("#696969")
    .borderRadius(5)
    .padding({ left: 5, bottom: 5 })
    .width(120)
  }
}

@Component
struct Prompt {
  @State img: Resource = $r("app.media.empresa")
  text: string | Resource

  build() {
    Row() {
      Image(this.img)
        .height(30)
        .width(30)
        .margin({ top: 5 })
      Text(this.text)
        .fontSize(20)
        .fontColor("#ffffff")
        .margin({ top: 5 })
    }
    .width('100%')
    .justifyContent(FlexAlign.Start)
  }
}

