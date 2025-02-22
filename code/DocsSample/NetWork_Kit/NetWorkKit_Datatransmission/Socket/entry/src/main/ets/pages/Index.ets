/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import TitleBar from '../components/TitleBar';
import router from '@ohos.router';

interface Item {
  text: string;
}

const operationUrls: Array<string> = [
  'connect/TcpClient',
  'connect/TcpServer',
  'connect/UdpClient_Server',
  'connect/Multicast',
  'connect/LocalSocket',
  'connect/OneWayTls',
  'connect/TwoWayTls',
  'connect/Tcp2OneWayTls',
  'connect/Tcp2TwoWayTls',
  'connect/TlsServer',
];

@Entry
@Component
struct Index {
  ResourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }

  @State ListItem: Item[] = [
    { text: this.ResourceToString($r('app.string.TcpClient')) },
    { text: this.ResourceToString($r('app.string.TcpServer')) },
    { text: this.ResourceToString($r('app.string.Udp')) },
    { text: this.ResourceToString($r('app.string.Multicast')) },
    { text: this.ResourceToString($r('app.string.LocalSocket')) },
    { text: this.ResourceToString($r('app.string.OneWayTls')) },
    { text: this.ResourceToString($r('app.string.TwoWayTls')) },
    { text: this.ResourceToString($r('app.string.Tcp2OneWayTls')) },
    { text: this.ResourceToString($r('app.string.Tcp2TwoWayTls')) },
    { text: this.ResourceToString($r('app.string.TlsServer')) },
  ]

  build() {
    Column() {
      TitleBar()
      List() {
        ForEach(this.ListItem, (item: Item, index) => {
          ListItem() {
            Row() {
              Blank().width('4%')
              Text(item.text)
                .fontSize(16)
                .fontColor('black')
                .width('90%')
              Image($r('app.media.right'))
                .height(12)
                .width(12)
            }
            .onClick(() => {
              router.pushUrl({
                url: operationUrls[index]
              });
            })
            .border({ radius: 20 })
            .width('90%')
            .height('8%')
            .backgroundColor(Color.White)
            .margin({ top: 12, left: 15, right: 8 })
          }
        })
      }
      .height('90%')
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#F1F3F5')
  }
}