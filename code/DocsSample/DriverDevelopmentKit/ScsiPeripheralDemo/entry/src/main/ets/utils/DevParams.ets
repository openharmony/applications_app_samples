/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

export default class DevParams {
  public deviceId: number = -1;
  public devType: number = -1;
  public vendorId: string = '';
  public productId: string = '';
  public revision: string = '';
  public volumeNumType: number = 0;
  public volumeStrType: string = '';
  public blockNum: number = 0;
  public blockVolume: number = 0;

  capacityTransferToSuitUnit(devVolume: number) {
    let capacity = '';
    let devVolumeFloat = 0;
    if (devVolume < 1024) { // 字节
      capacity = devVolumeFloat + 'B';
    } else if (devVolume >= 1024 && devVolume < (1024 * 1024)) {  // KB
      devVolumeFloat = devVolume / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = devVolumeFloat + 'KB';
    } else if (devVolume >= (1024 * 1024) && devVolume < (1024 * 1024 * 1024)) { // M
      devVolumeFloat = devVolume / 1024 / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = devVolumeFloat + 'M';
    } else if (devVolume >= (1024 * 1024 * 1024) && devVolume < (1024 * 1024 * 1024 * 1024)) { // G
      devVolumeFloat = devVolume / 1024 / 1024 / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = devVolumeFloat + 'G';
    } else if (devVolume >= (1024 * 1024 * 1024 * 1024) && devVolume < (1024 * 1024 * 1024 * 1024 * 1024)) { // T
      devVolumeFloat = devVolume / 1024 / 1024 / 1024 / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = devVolumeFloat + 'T';
    }

    return capacity;
  }

  setValue(devParams: DevParams) {
    this.deviceId = devParams.deviceId;
    this.devType = devParams.devType;
    this.vendorId = devParams.vendorId;
    this.productId = devParams.productId;
    this.revision = devParams.revision;
    this.blockNum = devParams.blockNum;
    this.blockVolume = devParams.blockVolume;

    this.volumeNumType = (this.blockNum + 1) * this.blockVolume;
    this.volumeStrType = this.capacityTransferToSuitUnit(this.volumeNumType);
  }

  clear() {
    this.deviceId = -1;
    this.devType = -1;
    this.vendorId = '';
    this.productId = '';
    this.revision = '';
    this.volumeNumType = 0;
    this.volumeStrType = '';
    this.blockNum = 0;
    this.blockVolume = 0;
  }
}