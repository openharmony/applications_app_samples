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

import Logger from '../utils/Logger';
import startAbility from '../utils/AbilityUtil';
import { ChatBox } from '../data/ChatBox';
import { ChatSource } from '../data/DataSource';
import ToolData from '../data/ToolData';
import { SocketType } from '../model/Socket';
import ChatComponent from '../components/ChatComponent';
import Constants from '../Constants';
import Want from '@ohos.app.ability.Want';

const TAG: string = '[NewIndex] ';

@Entry
@Component
struct NewIndex {
  private userId: number = (router.getParams() as Record<string, number | Object>).userId as number;
  private oppositeId: number = this.userId === 1 ? 2 : 1;
  private socketType?: SocketType = (router.getParams() as Record<string, number | Object>).socketType as SocketType;
  @State chats: ChatSource = new ChatSource();
  @State onlineState: boolean = true;
  @StorageLink('receiveMsg') @Watch('decodeMsg') receiveMsg: string = '';
  @State message: string = '';
  @State isPanelShow: boolean = false; // 下拉面板是否拉出

  @State toolArray: Array<ToolData> = [];

  /**
   * 解析收到的消息数据
   */
  decodeMsg(): void {
    Logger.info(TAG, `decodeMsg aray buffer begin:${this.receiveMsg}`);

    if (this.receiveMsg === '' || this.receiveMsg === 'clear') {
      Logger.info(TAG, `decodeMsg receiveMsg null:${this.receiveMsg}`);
      return;
    }
    Logger.info(TAG, `decodeMsg aray buffer:${this.receiveMsg}`);

    if (this.receiveMsg === 'online') {
      this.onlineState = true;
    }
    else if (this.receiveMsg === 'offline') {
      this.onlineState = false;
      AppStorage.setOrCreate('sendMsg', 'closeSocket');
    } else if (this.receiveMsg === 'exit') {
      AppStorage.setOrCreate('sendMsg', 'closeSocket');
      this.chats.cleanData()
      router.back();
    } else {
      Logger.info(TAG, `receive in Chat sucess`);
      let date = (new Date().getMonth() + 1) + '.' + new Date().getDate() + '-' + new Date().getHours() + ':' + new Date().getMinutes();
      Logger.info(TAG, `pre:this.chats=${JSON.stringify(this.chats)}`);
      this.chats.pushData(new ChatBox(false, this.receiveMsg, date));
      Logger.info(TAG, `after:this.chats=${JSON.stringify(this.chats)}`);
    }
    this.receiveMsg = '';
  }

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_public_back'))
          .id('indexBack')
          .width(24)
          .height(24)
          .objectFit(ImageFit.Contain)
          .margin({ left: 26 })
          .onClick(() => {
            router.back();
          })

        Column() {
          Text(this.userId === 1 ? $r('app.string.wenzi') : $r('app.string.fengzi'))
            .fontSize(20)
            .fontColor($r('app.color.COLOR_000000'))
            .fontFamily($r('app.string.font_family'))
            .margin({ left: 13, top: 3, bottom: 2 })
          Row() {
            Text()
              .width(12)
              .height(12)
              .backgroundColor(this.onlineState ? $r('app.color.COLOR_5BA854') : $r('app.color.COLOR_F1F3F5'))
              .borderRadius(6)
              .margin({ left: 13, right: 3 })
            Text(this.onlineState === true ? $r('app.string.online') : $r('app.string.offline'))
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

      Column() {
        // 消息面板
        Scroll() {
          Column() {
            LazyForEach(this.chats, (item: ChatBox, index) => {
              Row() {
                ChatComponent({ item: item, userId: this.userId })
                  .margin({ top: 24 })
              }
              .margin({ top: 5, bottom: 10 })
              .alignSelf(item.isSend ? ItemAlign.End : ItemAlign.Start)
            }, (item: ChatBox) => item.message)
          }
          .width('100%')
          .padding(5)
        }
        .scrollable(ScrollDirection.Vertical)
        .scrollBar(BarState.Auto)
        .scrollBarColor(Color.Gray)
        .scrollBarWidth(5)
        .width('100%')
      }
      .padding({ top: 29 })
      .width('100%')
      .backgroundColor($r('app.color.COLOR_F1F3F5'))
      .layoutWeight(1)

      Row() {
        if (this.socketType == SocketType.TCP) {
          Image($r('app.media.ic_phone'))
            .width(20)
            .height(20)
            .margin({ left: 14, top: 18, bottom: 18 })
            .objectFit(ImageFit.Contain)
            .onClick(() => {

              let parameters: Record<string, Object> = {
                'START_ABILITY_EVENT_KEY': Constants.START_ABILITY_EVENT_CALL,
                'START_ABILITY_DATA_KEY': this.oppositeId
              };

              let want: Want = {
                bundleName: Constants.BUNDLE_NAME,
                abilityName: Constants.ABILITY_NAME,
                parameters: parameters
              };

              AppStorage.setOrCreate('sendMsg', Constants.START_ABILITY_EVENT_ANSWER);
              AppStorage.setOrCreate('sendMsg', 'clear');
              startAbility(want);
            })
        }

        TextInput({ placeholder: this.message, text: this.message })
          .id('inputMsg')
          .layoutWeight(1)
          .height(40)
          .backgroundColor($r('app.color.COLOR_0D000000'))
          .width('85%')
          .fontSize(16)
          .fontColor($r('app.color.COLOR_E6000000'))
          .fontFamily($r('app.string.font_family_regular'))
          .margin({ left: 14, right: 12 })
          .onChange((inputs: string) => {
            this.message = inputs;
          })

        Button($r('app.string.send_message'))
          .id('sendMsg')
          .fontSize(16)
          .width(80)
          .height(40)
          .margin({ right: 12 })
          .backgroundColor($r('app.color.COLOR_5BA854'))
          .onClick(() => {
            Logger.info(TAG, `send message: ${this.message}`);
            if (this.message) {
              let date: string = (new Date().getMonth() + 1) + '.' + new Date().getDate() + '-' + new Date().getHours() + ':' + new Date().getMinutes();
              let sendMessage: ChatBox = new ChatBox(true, this.message, date);
              this.chats.pushData(sendMessage);
              let bool1: boolean = AppStorage.set('sendMsg', this.message);
              let bool2: boolean = AppStorage.set('sendMsg', 'clear');
              Logger.info(TAG, `send message bool1: ${bool1}`);
              Logger.info(TAG, `send message bool2: ${bool2}`);
            }
            this.message = '';
          })
      }
      .width('100%')
      .height(56)
    }
    .width('100%')
    .height('100%')
  }
}