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

import Log from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogDecorator';

enum BluetoothProfileConnectionState {
  STATE_DISCONNECTED = 0,
  STATE_CONNECTING = 1,
  STATE_CONNECTED = 2,
  STATE_DISCONNECTING = 3
}

export class Profile {
  profileId: number = -1;
  deviceId: string = '';
  profileConnectionState: number = -1

  constructor() {
  }
}

/**
 * Bluetooth device class
 */
export default class BluetoothDevice {
  deviceId: string = '';
  deviceName: string = '';
  deviceType: string = '';
  connectionState: number = 0;
  profiles: Map<number, Profile> = new Map();

  constructor() {
  }

  @Log
  setProfiles(data: Profile[]): void{
    data.forEach((item: Profile) => {
      let profile = new Profile();
      profile.profileId = item.profileId;
      profile.deviceId = this.deviceId;
      profile.profileConnectionState = item.profileConnectionState;
      this.setProfile(profile)
    })
  }

  setProfile(data: Profile): void{
    if (this.deviceId !== data.deviceId) {
      return;
    }

    let profile = new Profile();
    profile.profileId = data.profileId;
    profile.deviceId = data.deviceId;
    profile.profileConnectionState = data.profileConnectionState;
    this.profiles.set(data.profileId, profile)

    let countStateDisconnect = 0;
    let countStateConnecting = 0;
    let countStateConnected = 0;
    let countStateDisconnecting = 0;

    this.profiles.forEach((profile, key) => {
      if (profile.profileConnectionState == BluetoothProfileConnectionState.STATE_DISCONNECTED) {
        countStateDisconnect++;
      } else if (profile.profileConnectionState == BluetoothProfileConnectionState.STATE_CONNECTING) {
        countStateConnecting++;
      } else if (profile.profileConnectionState == BluetoothProfileConnectionState.STATE_CONNECTED) {
        countStateConnected++;
      } else if (profile.profileConnectionState == BluetoothProfileConnectionState.STATE_DISCONNECTING) {
        countStateDisconnecting++;
      }
    });

    if (countStateConnected > 0 || countStateDisconnecting > 0) {
      this.connectionState = BluetoothProfileConnectionState.STATE_CONNECTED;
    } else if (countStateConnecting > 0) {
      this.connectionState = BluetoothProfileConnectionState.STATE_CONNECTING;
    } else {
      this.connectionState = BluetoothProfileConnectionState.STATE_DISCONNECTED;
    }
  }
}
