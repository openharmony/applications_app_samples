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

import wifi from '@ohos.wifiManager';
import router from '@ohos.router';
import CommonEvent from '@ohos.commonEventManager';
import promptAction from '@ohos.promptAction';
import Want from '@ohos.app.ability.Want';
import { BusinessError } from '@ohos.base';

import { SelectUserDialog } from '../components/SelectUserDialog';
import { SelectAgreementDialog } from '../components/SelectAgreementDialog';
import SocketController from '../controller/LoginController';
import { SocketType } from '../model/Socket';
import { resolveIP, checkIp } from '../utils/IpUtil';
import Logger from '../utils/Logger';
import startAbility from '../utils/AbilityUtil';
import Constants from '../Constants';

const TAG: string = '[NewLogin] ';

let oppositeAddress = '192.168.8.160';
let oppositePort = 9090;

let localAddress = resolveIP(wifi.getIpInfo().ipAddress);
let localPort = 8081;


@Entry
@Component
export default struct NewLogin {
  @State userId: number = 1;
  @State selectAgreementIndex: number = 0;
  @State receiveMsg: string = '';
  private socketType: Array<SocketType> = [SocketType.UDP, SocketType.TCP, SocketType.TLS];
  private socketTypeResource: Array<Resource> = [$r('app.string.udp'), $r('app.string.tcp'), $r('app.string.tls')];
  private socketController?: SocketController;
  @StorageLink('sendMsg') @Watch('action') sendMsg: string = '';

  // 发送公共事件的回调
  private publishCallback = (err: BusinessError) => {
    if (err !== null && err.code) {
      Logger.info(TAG, `publishCallback publish failed :${JSON.stringify(err)}`);
    } else {
      Logger.info(TAG, `publishCallback publish success`);
    }
  }


  // 选择用户弹窗
  private selectUserDialog: CustomDialogController = new CustomDialogController({
    builder: SelectUserDialog({
      result: $userId
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 }
  });
  // 选择协议弹窗
  private selectAgreementDialog: CustomDialogController = new CustomDialogController({
    builder: SelectAgreementDialog({
      result: $selectAgreementIndex
    }),
    alignment: DialogAlignment.Bottom,
    offset: { dx: 0, dy: -20 }
  });

  /**
   * 聊天页面传来的相应动作
   */
  action(): void {
    Logger.info(TAG, `action_sendMsg:${this.sendMsg}`);
    if (this.sendMsg === 'closeSocket') {
      this.socketController?.closeSocket();
    } else if (this.sendMsg === 'clear') {

    } else {
      // 转发消息 包括事件
      this.sendData(this.sendMsg);
    }
  }

  /**
   * 判断是否为UDP发送
   * @param message
   */
  sendData(message: string): void {
    if (this.socketType[this.selectAgreementIndex] !== SocketType.UDP) {
      this.socketController?.sendData(message);
    } else {
      oppositePort = this.userId === 1 ? 8082 : 8081;
      this.socketController?.udpSendData(message, oppositeAddress, oppositePort);
    }
  }

  /**
   * TCP或TLS连接 服务端或对端
   */
  connectSocketAndOnClose(): void {
    this.socketController?.connectSocket(oppositeAddress, oppositePort, (data: string) => {
      this.receiveMessage(data);
    })

    // 连接同时订阅关闭连接回调
    this.socketController?.onClose(() => {
      CommonEvent.publish(Constants.COMM_EVENT_HANGUP_FROM_HOST, this.publishCallback);
    })

  }

  /**
   * UDP直接订阅消息
   */
  onUdpMessage(): void {
    this.socketController?.onMessage((data: string) => {
      this.receiveMessage(data);
    })
    this.sendData('connect success');
  }

  /**
   * 对接收的消息处理
   * @param data
   */
  receiveMessage(data: string): void {
    Logger.info(TAG, 'receiveMessage begin data ' + JSON.stringify(data));
    if (data.split('&')[0] && data.split('&')[0] === 'invitationNumber') {
      AppStorage.setOrCreate('invitationNumber', data.split('&')[1]);
      return;
    }

    if (data == 'ok') {
      // router.clear();
      this.pushIndex();
    } else if (data === Constants.START_ABILITY_EVENT_ANSWER) {
      // 如果是通话请求，则拉起语音通话应用
      Logger.info(TAG, 'receiveMessage data userId ' + JSON.stringify(data));
      let oppositeId: number = this.userId === 1 ? 2 : 1
      Logger.info(TAG, 'receiveMessage data oppositeId ' + JSON.stringify(data));
      let want: Want = {
        bundleName: Constants.BUNDLE_NAME,
        abilityName: Constants.ABILITY_NAME,
        parameters: {
          'START_ABILITY_EVENT_KEY': Constants.START_ABILITY_EVENT_ANSWER,
          'START_ABILITY_DATA_KEY': oppositeId
        }
      };
      // 拉起语音通话应用
      startAbility(want);
    } else if (data === Constants.COMM_EVENT_ANSWER_FROM_VOICE) {
      // 发布公共事件至语音通话示例：接听
      CommonEvent.publish(Constants.COMM_EVENT_ANSWER_FROM_HOST, this.publishCallback);
      Logger.info(TAG, 'receiveMessage data COMM_EVENT_ANSWER' + JSON.stringify(data));
    } else if (data === Constants.COMM_EVENT_HANGUP_FROM_VOICE) {
      // 发布公共事件至语音通话示例：挂断
      CommonEvent.publish(Constants.COMM_EVENT_HANGUP_FROM_HOST, this.publishCallback);
      Logger.info(TAG, 'receiveMessage data COMM_EVENT_HANGUP' + JSON.stringify(data));
    } else {
      AppStorage.setOrCreate('receiveMsg', data);
      AppStorage.setOrCreate('sendMsg', 'clear');
      this.receiveMsg = data;
    }
  }

  /**
   * 跳转至CreateRoom页面
   */
  pushCreateRoom(): void {
    router.pushUrl({
      url: 'pages/CreateRoom',
      params: {
        'userId': this.userId,
        'socketType': this.socketType[this.selectAgreementIndex]
      }
    });
  }

  /**
   * 跳转至Index页面
   */
  pushIndex(): void {
    router.pushUrl({
      url: 'pages/NewIndex',
      params: {
        'userId': this.userId,
        'socketType': this.socketType[this.selectAgreementIndex]
      }
    });
  }

  build() {
    Column() {
      Row() {
        Text($r('app.string.EntryAbility_label'))
          .fontSize(20)
          .fontColor($r('app.color.COLOR_E6000000'))
          .fontFamily($r('app.string.font_family'))
          .margin({ left: 24, top: 14, bottom: 14 })
      }
      .width('100%')
      .height(56)
      .justifyContent(FlexAlign.Start)

      Column() {
        Text(this.userId === 1 ? $r('app.string.feng') : $r('app.string.wen'))
          .width(104)
          .height(104)
          .fontSize(52)
          .fontColor($r('app.color.COLOR_FFFFFF'))
          .fontFamily($r('app.string.font_family'))
          .textAlign(TextAlign.Center)
          .backgroundColor($r('app.color.COLOR_33000000'))
          .borderRadius(52)

        Row({ space: 8 }) {
          Text(this.userId === 1 ? $r('app.string.fengzi') : $r('app.string.wenzi'))
            .fontSize(20)
            .fontColor($r('app.color.COLOR_E6000000'))
            .fontFamily($r('app.string.font_family'))
            .textAlign(TextAlign.Center)
          Image($r('app.media.ic_select'))
            .width(12)
            .height(24)
            .objectFit(ImageFit.Contain)
        }
        .id('selectUser')
        .width('100%')
        .margin({ left: 8, top: 16, bottom: 4 })
        .justifyContent(FlexAlign.Center)
        .onClick(() => {
          this.selectUserDialog.open();
        })

        Text($r('app.string.local_ip', localAddress))
          .fontSize(16)
          .fontColor($r('app.color.COLOR_99000000'))
          .fontFamily($r('app.string.font_family_regular'))
          .margin({ bottom: 42 })

        Column() {
          Row() {
            Text(this.socketTypeResource[this.selectAgreementIndex])
              .fontSize(16)
              .fontColor($r('app.color.COLOR_FF000000'))
              .fontFamily($r('app.string.font_family_regular'))
            Blank()
            Image($r('app.media.ic_select'))
              .width(12)
              .height(24)
              .objectFit(ImageFit.Contain)
          }
          .id('selectAgreement')
          .width('86%')
          .height(55)
          .onClick(() => {
            this.selectAgreementDialog.open();
          })

          Divider()
            .vertical(false)
            .height(1)
            .width('86%')
            .backgroundColor($r('app.color.COLOR_33000000'))

          Row() {
            TextInput({ placeholder: $r('app.string.please_input_remote_address') })
              .id('inputIp')
              .width('100%')
              .fontSize(16)
              .fontColor($r('app.color.COLOR_E6000000'))
              .fontFamily($r('app.string.font_family'))
              .borderRadius(0)
              .backgroundColor($r('app.color.COLOR_FFFFFF'))
              .padding({ left: 0 })
              .onChange((value: string) => {
                oppositeAddress = value;
              })
          }
          .width('86%')
          .height(55)
          .justifyContent(FlexAlign.Start)

          Divider()
            .vertical(false)
            .height(1)
            .width('86%')
            .backgroundColor($r('app.color.COLOR_33000000'))
        }

      }
      .width('100%')
      .padding({ top: 38 })
      .layoutWeight(1)

      Column() {
        Button($r('app.string.login'))
          .id('login')
          .width('86%')
          .height(40)
          .backgroundColor($r('app.color.COLOR_007DFF'))
          .onClick(() => {
            localPort = this.userId === 1 ? 8081 : 8082;
            this.socketController = new SocketController(this.socketType[this.selectAgreementIndex], localAddress, localPort);

            if (oppositeAddress === '' || !checkIp(oppositeAddress)) {
              promptAction.showToast({ message: $r('app.string.input_ip'), duration: 1000, bottom: 64 });
            } else {
              if (this.socketType[this.selectAgreementIndex] != SocketType.UDP) {
                // TCP或TLS点击连接 服务端或对端
                this.connectSocketAndOnClose();
              } else {
                // UDP则直接订阅消息且发送连接成功信息
                this.onUdpMessage();
              }
              promptAction.showToast({ message: $r('app.string.login_success'), duration: 1000, bottom: 64 });
              this.pushCreateRoom();
            }
          })
      }
      .width('100%')
      .height('30%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}