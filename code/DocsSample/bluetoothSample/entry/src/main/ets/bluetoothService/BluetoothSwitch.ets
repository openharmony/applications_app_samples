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

import { access } from '@kit.ConnectivityKit';

export class BluetoothSwitch {
  public openBluetooth() {
    access.off('stateChange');
    access.enableBluetooth();
    access.on('stateChange', (data) => {
      let btStateMessage = '';
      switch (data) {
        case 0:
          btStateMessage += 'STATE_OFF';
          break;
        case 1:
          btStateMessage += 'STATE_TURNING_ON';
          break;
        case 2:
          btStateMessage += 'STATE_ON';
          break;
        case 3:
          btStateMessage += 'STATE_TURNING_OFF';
          break;
        case 4:
          btStateMessage += 'STATE_BLE_TURNING_ON';
          break;
        case 5:
          btStateMessage += 'STATE_BLE_ON';
          break;
        case 6:
          btStateMessage += 'STATE_BLE_TURNING_OFF';
          break;
        default:
          btStateMessage += 'unknown status';
          break;
      }
      if (btStateMessage == 'STATE_ON') {
        access.off('stateChange');
      }
      console.info('bluetooth statues: ' + btStateMessage);
    });

  }

  public closeBluetooth() {
    access.off('stateChange');
    access.disableBluetooth();
    access.on('stateChange', (data) => {
      let btStateMessage = '';
      switch (data) {
        case 0:
          btStateMessage += 'STATE_OFF';
          break;
        case 1:
          btStateMessage += 'STATE_TURNING_ON';
          break;
        case 2:
          btStateMessage += 'STATE_ON';
          break;
        case 3:
          btStateMessage += 'STATE_TURNING_OFF';
          break;
        case 4:
          btStateMessage += 'STATE_BLE_TURNING_ON';
          break;
        case 5:
          btStateMessage += 'STATE_BLE_ON';
          break;
        case 6:
          btStateMessage += 'STATE_BLE_TURNING_OFF';
          break;
        default:
          btStateMessage += 'unknown status';
          break;
      }
      if (btStateMessage == 'STATE_OFF') {
        access.off('stateChange');
      }
    });
  }
}
