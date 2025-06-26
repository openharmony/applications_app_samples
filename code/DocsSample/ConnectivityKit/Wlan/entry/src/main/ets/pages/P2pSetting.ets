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


import hilog from '../model/Logger';
import router from '@ohos.router'
import wifi from '@ohos.wifiManager';
import promptAction from '@ohos.promptAction'

const TAG = 'p2pSetting'

@Entry
@Component
struct p2pSetting {
  @State deviceAddress: string = '';
  @State netId: number = - 2;
  @State passphrase: string = '';
  @State groupName: string = ''
  @State goBand: number = 0;

  aboutToAppear() {
    AppStorage.setOrCreate('deviceAddress' , this.deviceAddress)
    AppStorage.setOrCreate('netId' , this.netId)
    AppStorage.setOrCreate('passphrase' , this.passphrase)
    AppStorage.setOrCreate('groupName' , this.groupName)
    AppStorage.setOrCreate('goBand' , this.goBand)
  }


  async createGroup() {
    try {
      let deviceInfo = await wifi.getP2pLocalDevice()
      let config:wifi.WifiP2PConfig = {
        deviceAddress: deviceInfo.deviceAddress,
        netId: this.netId,
        passphrase: this.passphrase,
        groupName: this.groupName,
        goBand: this.goBand,
      }
      hilog.info(`deviceAddress: ${config.deviceAddress}, netId: ${config.netId}, pwd: ${config.passphrase}, gpname: ${config.groupName}, goBand: ${config.goBand}`)
      wifi.createGroup(config)
      promptAction.showToast({ message : 'createGroup success' })
    } catch (e) {
      hilog.info(TAG, `createGroup Error: ${JSON.stringify(e)}`)
    }
  }

  build() {
    Column() {
      Row() {
        Text('deviceAddress:').fontSize(16).width(120)
        TextInput({ text : this.deviceAddress , placeholder : 'input peripheral deviceId.' })
          .fontSize('15vp')
          .onChange((strInput: string) => {
            this.deviceAddress = strInput;
            //判断合法性
            if ( strInput.length >= 1 ) {
              AppStorage.setOrCreate('deviceAddress' , this.deviceAddress);
            }
          })
          .width('80%')
          .borderRadius(1)
      }
      .backgroundColor($r('app.color.moon'))
      .padding(5)
      .justifyContent(FlexAlign.Start)
      .alignItems(VerticalAlign.Center)

      Column() {
        Stack().height('0.25vp').backgroundColor('#000000');
        Column() {
          Row() {
            Text('netId:').fontSize(15).width(60);
            TextInput({ text : this.netId.toString() , placeholder : '-2' })
              .fontSize('15vp')
              .onChange((strInput: string) => {
                this.netId = parseInt(strInput);
                //判断合法性
                if ( strInput.length >= 1 ) {
                  AppStorage.setOrCreate('netId' , this.netId);
                }
              })
              .width('80%')
              .borderRadius(1)
          }
          .padding(5)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)
          .backgroundColor($r('app.color.spring'))

          Row() {
            Text('passphrase:').fontSize(15).width(100);
            TextInput({ text : this.passphrase , placeholder : 'input passphrase' })
              .fontSize('15vp')
              .onChange((strInput: string) => {
                this.passphrase = strInput;
                if ( strInput.length >= 1 ) {
                  AppStorage.setOrCreate('passphrase' , this.passphrase);
                }
              })
              .width('80%')
              .borderRadius(1)
          }
          .backgroundColor($r('app.color.spring'))
          .padding(5)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)

          Row() {
            Text('groupName:').fontSize(15).width(100);
            TextInput({ text : this.groupName , placeholder : 'testGroup' })
              .fontSize('15vp')
              .onChange((strInput: string) => {
                this.groupName = strInput;
                if ( strInput.length >= 1 ) {
                  AppStorage.setOrCreate('groupName' , this.groupName);
                }
              })
              .width('80%')
              .borderRadius(1)
          }
          .backgroundColor($r('app.color.spring'))
          .padding(5)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)

          Row() {
            Text('goBand:').fontSize(15).width(80);
            TextInput({ text : this.goBand.toString() , placeholder : '0' })
              .fontSize('15vp')
              .onChange((strInput: string) => {
                this.goBand = Number(strInput);
                if ( strInput.length >= 1 ) {
                  AppStorage.setOrCreate('goBand' , this.goBand);
                }
              })
              .width('80%')
              .borderRadius(1)
          }
          .backgroundColor($r('app.color.spring'))
          .padding(5)
          .justifyContent(FlexAlign.Start)
          .alignItems(VerticalAlign.Center)

        }

        Stack().height('0.25vp').backgroundColor('#000000');
      }

      Row() {
        Button($r('app.string.create_group'))// .dialogButtonStyle()
          .fontSize('16fp')
          .onClick(() => {
            if(this.passphrase === '' || this.groupName === '') {
              hilog.info(TAG, 'ssid || preSharedKey is null');
              promptAction.showToast({ message : 'passphrase or groupName is null' })
              return;
            }
            this.createGroup();
          })
          .height('100%')
        }
      .width('50%')
      .height('6%')
      .justifyContent(FlexAlign.SpaceBetween)
    }
  }
}