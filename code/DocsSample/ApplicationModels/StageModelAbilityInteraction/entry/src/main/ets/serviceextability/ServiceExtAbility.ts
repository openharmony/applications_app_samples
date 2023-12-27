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

import hilog from '@ohos.hilog';
import ServiceExtensionAbility from '@ohos.app.ability.ServiceExtensionAbility';
import ServiceExtImpl from '../IdlServiceExt/idl_service_ext_impl';
import type Want from '@ohos.app.ability.Want';
import type rpc from '@ohos.rpc';

const TAG: string = '[ServiceExtAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class ServiceExtAbility extends ServiceExtensionAbility {
  serviceExtImpl: ServiceExtImpl = new ServiceExtImpl('ExtImpl');

  onCreate(want: Want): void {
    let serviceExtensionContext = this.context;
    hilog.info(DOMAIN_NUMBER, TAG, `onCreate, want: ${want.abilityName}`);
  };

  onRequest(want: Want, startId: number): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onRequest, want: ${want.abilityName}`);
  };

  onConnect(want: Want): rpc.RemoteObject {
    hilog.info(DOMAIN_NUMBER, TAG, `onConnect, want: ${want.abilityName}`);
    // 返回ServiceExtImpl对象，客户端获取后便可以与ServiceExtensionAbility进行通信
    return this.serviceExtImpl as rpc.RemoteObject;
  };

  onDisconnect(want: Want): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onDisconnect, want: ${want.abilityName}`);
  };

  onDestroy(): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onDestroy');
  };
};