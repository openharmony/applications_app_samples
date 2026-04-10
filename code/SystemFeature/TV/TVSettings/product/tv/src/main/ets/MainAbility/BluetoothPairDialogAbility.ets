/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import LogUtil from '../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import { Want } from '@kit.AbilityKit';
import { UIExtensionAbility } from '@kit.AbilityKit';
import { UIExtensionContentSession } from '@kit.AbilityKit';

const TAG: string = 'BluetoothPairDialogAbility';

export enum PinType {
  PAIRING_VARIANT_DISPLAY_PIN = 0,
  PAIRING_VARIANT_PIN = 1,
  PAIRING_VARIANT_DISPLAY_PASSKEY = 2,
  PAIRING_VARIANT_PASSKEY = 3,
  PAIRING_VARIANT_PASSKEY_CONFIRMATION = 4,
  PAIRING_VARIANT_CONSENT = 5,
  PAIRING_VARIANT_OOB_CONSENT = 6,
  PAIRING_VARIANT_PIN_16_DIGITS = 7
}

export class CheckEmptyUtils {
  static isEmpty(obj: null | undefined | string | object): boolean {
    return (typeof obj === 'undefined' || obj == null || obj === '')
  }

  static checkStrIsEmpty(str: string): boolean {
    return typeof str === 'undefined' || str == null || str.trim().length === 0;
  }

  static IsEmptyArr<T>(arr: T[]): boolean {
    return typeof arr === 'undefined' || arr == null || arr.length === 0;
  }
}

export default class BluetoothPairDialogAbility extends UIExtensionAbility {
  onCreate(): void {
    LogUtil.info(`${TAG} onCreate is called`);
    globalThis.bluetoothPairDialogContext = this.context
  }

  onDestroy(): void {
    LogUtil.info(`${TAG} onDestroy is called`);
  }

  onSessionCreate(want: Want, session: UIExtensionContentSession): void {
    LogUtil.info(`${TAG} onSessionCreate is called`);
    if (!this.isParamsValid(want) || CheckEmptyUtils.isEmpty(session)) {
      LogUtil.error(`${TAG} want or session is invalid`);
      session?.terminateSelf();
      return;
    }

    let parameters = want.parameters as Record<string, Object>
    let deviceId = String(parameters.deviceId)
    let pinCode = String(parameters.pinCode)
    let pinType = Number.parseInt(String(parameters.pinType))

    AppStorage.setOrCreate<UIExtensionContentSession>('dialogSession', session);
    AppStorage.setOrCreate<string>('PairDeviceId', deviceId);
    AppStorage.setOrCreate<string>('PairPinCode', pinCode);
    AppStorage.setOrCreate<number>('PairPinType', pinType);
    try {
      session.loadContent('pages/abilityDialog/BluetoothPairDialog');
      session.setWindowBackgroundColor('#00FFFFFF');
    } catch (err) {
      LogUtil.error(`${TAG} onSessionCreate failed`);
    }
    LogUtil.info(`${TAG} onSessionCreate is end`);
  }

  private isParamsValid(want: Want): boolean {
    if (CheckEmptyUtils.isEmpty(want) || typeof want.parameters?.deviceId === 'undefined' ||
      typeof want.parameters?.pinCode === 'undefined' || typeof want.parameters?.pinType === 'undefined') {
      LogUtil.error(`${TAG} deviceId: ${want?.parameters?.deviceId}, pinType:${want?.parameters?.pinType}`);
      return false;
    }
    let type: string = String(want.parameters?.pinType);
    switch (Number.parseInt(type)) {
      case PinType.PAIRING_VARIANT_PIN:
      case PinType.PAIRING_VARIANT_PASSKEY:
      case PinType.PAIRING_VARIANT_PASSKEY_CONFIRMATION:
      case PinType.PAIRING_VARIANT_CONSENT:
      case PinType.PAIRING_VARIANT_DISPLAY_PASSKEY:
      case PinType.PAIRING_VARIANT_DISPLAY_PIN:
      case PinType.PAIRING_VARIANT_OOB_CONSENT:
      case PinType.PAIRING_VARIANT_PIN_16_DIGITS:
        break;
      default:
        LogUtil.error(`${TAG} pin type invalid: ${type}`);
        return false;
    }
    return true;
  }
}
