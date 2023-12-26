/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import { CreateRoomDialog } from '../components/CreateRoomDialog';
import { InvitationDialog } from '../components/InvitationDialog';
import { SocketType } from '../model/Socket';

const TAG: string = '[CreateRoom] ';


@Entry
@Component
export default struct CreateRoom {
  @State roomNumber: string = '';
  @State roomTip: boolean = false;
  @State invitation: Resource = $r('app.string.invitation_detail');
  private userId: number = (router.getParams() as Record<string, number | Object>).userId as number;
  private socketType: SocketType = (router.getParams() as Record<string, number | Object>).socketType as SocketType;;
  @StorageLink('invitationNumber') @Watch('invitationNumberChange') invitationNumber: string = '';

  invitationNumberChange(): void {
    this.invitation = $r('app.string.invitation_detail', this.invitationNumber);
    this.invitationDialog.open();
  }

  // 创建房间弹窗
  private createRoomDialog: CustomDialogController = new CustomDialogController({
    builder: CreateRoomDialog({
      roomNumber: $roomNumber
    })
  });

  // 邀请聊天弹窗
  private invitationDialog: CustomDialogController = new CustomDialogController({
    builder: InvitationDialog({
      invitation: $invitation,
      userId: this.userId,
      socketType: this.socketType
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 }
  });

  /**
   * 跳转至Index页面
   */
  pushIndex(): void {
    router.pushUrl({
      url: 'pages/NewIndex',
      params: {
        'userId': this.userId,
        'socketType': this.socketType
      }
    });
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .margin({ left: 26 })
          .onClick(e => {
            router.back();
          })
        Column() {
          Text(this.userId === 1 ? $r('app.string.fengzi') : $r('app.string.wenzi'))
            .fontSize(20)
            .fontColor($r('app.color.COLOR_000000'))
            .fontFamily($r('app.string.font_family'))
            .margin({ left: 13, top: 3, bottom: 2 })
          Row() {
            Text()
              .width(12)
              .height(12)
              .backgroundColor($r('app.color.COLOR_5BA854'))
              .borderRadius(6)
              .margin({ left: 13, right: 3 })
            Text($r('app.string.online'))
              .fontSize(14)
              .fontColor($r('app.color.COLOR_99000000'))
              .fontFamily($r('app.string.font_family_regular'))
          }
          .justifyContent(FlexAlign.Start)
        }
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      Column({ space: 8 }) {
        Image($r('app.media.ic_empty'))
          .width(312)
          .height(147)
          .objectFit(ImageFit.Contain)
        Text($r('app.string.not_room'))
          .fontSize(14)
          .fontColor($r('app.color.COLOR_66000000'))
          .fontFamily($r('app.string.font_family_regular'))
      }
      .width('100%')
      .padding({ top: 38 })
      .layoutWeight(1)
      .justifyContent(FlexAlign.Center)

      Column() {
        Button($r('app.string.create_room'))
          .id('createRoom')
          .fontSize(16)
          .width('50%')
          .height(40)
          .backgroundColor($r('app.color.COLOR_007DFF'))
          .onClick(e => {
            this.createRoomDialog.open();
          })
      }
      .width('100%')
      .height(88)
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}