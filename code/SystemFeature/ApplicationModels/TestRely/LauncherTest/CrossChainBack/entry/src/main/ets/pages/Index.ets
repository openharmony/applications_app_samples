/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
import common from '@ohos.app.ability.common';
import rpc from '@ohos.rpc';
import Want from '@ohos.app.ability.Want';
import { ConnectOptions } from 'ability/connectOptions';
import { ElementName } from 'bundle/elementName';
import Logger from '../logger/Logger';

@Entry
@Component
struct Index {
  @State message: string = 'EntryAbility';
  private context: common.UIAbilityContext;
  private remoteConnectId: number = -1;

  aboutToAppear() {
    this.context = getContext(this) as common.UIAbilityContext;
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .id('EntryAbility')
        Text('')
          .height(25)
        Button('startSecondAbility')
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .onClick(async () => {
            Logger.debug('connect Service Extension Ability begin');
            let connectWant: Want = {
              bundleName: 'com.acts.abilityabacktoabilityb',
              abilityName: 'ServiceAbility'
            };

            let connectOptions: ConnectOptions = {
              onConnect(elementName: ElementName, remote: rpc.IRemoteObject): void {
                Logger.debug('ServiceExtensionAbility has been onConnect');
              },
              onDisconnect(elementName: ElementName): void {
                Logger.debug('ServiceExtensionAbility has been onDisconnect');
              },
              onFailed(code: number): void {
                Logger.debug('ServiceExtensionAbility has been onFailed');
              }
            };

            if (this.remoteConnectId !== -1) {
              try {
                await this.context.stopServiceExtensionAbility(connectWant);
                this.remoteConnectId = this.context.connectServiceExtensionAbility(connectWant, connectOptions);
              } catch (err) {
                Logger.error('connectServiceExtensionAbility failed');
              }
            } else {
              try {
                this.remoteConnectId = this.context.connectServiceExtensionAbility(connectWant, connectOptions);
              } catch (err) {
                Logger.error('connectServiceExtensionAbility failed');
              }
            }

            Logger.debug('connect Service Extension Ability end');
          })
          .id('startSecondAbility')
          .width(400)
          .height(50)
      }
      .width('100%')
    }
    .height('100%')
  }
}