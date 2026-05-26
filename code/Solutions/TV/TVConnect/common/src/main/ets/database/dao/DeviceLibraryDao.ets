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
import { Device, Industry, LibraryDevice } from '../entity/Device';
import { ConnectDatabaseHelperImpl } from '../ConnectDatabaseHelperImpl';
import { DeviceLibraryField, TableType, } from '../TableConfig';
import { ValuesBucket } from '@ohos.data.ValuesBucket';
import relationalStore from '@ohos.data.relationalStore';
import I18n from '@ohos.i18n';
import { PreferencesHelper } from '../PreferencesHelper';
import fileUri from '@ohos.file.fileuri';

/*
 * 设备库持久化接口
 * */
export class DeviceLibraryDao {
  public static readonly ICON_ROOT_PATH_KEY = 'icon_root_path';
  private databaseHelper: ConnectDatabaseHelperImpl | undefined = undefined;
  private isZh = true;

  constructor(databaseHelper: ConnectDatabaseHelperImpl) {
    this.databaseHelper = databaseHelper;
    this.initZh();
  }

  private initZh() {
    let appPreferredLanguage: string = I18n.System.getAppPreferredLanguage();
    const zhReg = '\^zh\(\-\[\\w\]\+\)\*\$';
    let matchRes = appPreferredLanguage.toLowerCase().match(zhReg);
    this.isZh = matchRes != null;
  }

  /*
   * 添加设备
   * */
  async addDeviceList(deviceList: Array<LibraryDevice>, iconRootPath: string): Promise<boolean> {
    await PreferencesHelper.put(DeviceLibraryDao.ICON_ROOT_PATH_KEY, iconRootPath);
    let vbs: ValuesBucket[] = [];
    for (let i of deviceList) {
      let pid = i.productID;
      let value = JSON.stringify(i);
      let vb = { 'pid': pid, 'value': value } as ValuesBucket;
      vbs.push(vb);
    }
    if (this.databaseHelper != undefined) {
      return await this.databaseHelper.batchInsert(TableType.DEVICE_LIBRARY, vbs);
    }
    return false;
  }

  /*
   * 删除设备库全部信息
   * */
  async deleteAllDevice(): Promise<boolean> {
    let res: boolean = false;
    if (this.databaseHelper !== undefined) {
      res = await this.databaseHelper.delete(new relationalStore.RdbPredicates(TableType.DEVICE_LIBRARY));
    }
    return res;
  }

  /*
   * 查询全部设备
   * */
  async queryAllDevice(): Promise<Device[]> {
    let res: Device[] = [];
    let predicates = new relationalStore.RdbPredicates(TableType.DEVICE_LIBRARY);
    if (this.databaseHelper != undefined) {
      let devices = await this.databaseHelper.queryByCondition(TableType.DEVICE_LIBRARY, predicates);
      let iconRootPath = (await PreferencesHelper.get(DeviceLibraryDao.ICON_ROOT_PATH_KEY, '')) as string + '/';
      for (let d of devices) {
        let i = d.get(DeviceLibraryField.VALUE);
        if (i != undefined) {
          let devicelib: LibraryDevice = JSON.parse(i) as LibraryDevice;
          let device = await this.LibraryDeviceToDevice(devicelib, iconRootPath);
          res.push(device);
        }
      }
    }
    return res;
  }

  /*
   * 根据pid查询设备
   * */
  async queryDeviceByPid(pid: string): Promise<Device | null> {
    let res: Device | null = null;
    let predicates = new relationalStore.RdbPredicates(TableType.DEVICE_LIBRARY);
    predicates.equalTo(DeviceLibraryField.PID, pid);
    if (this.databaseHelper != undefined) {
      let devices = await this.databaseHelper.queryByCondition(TableType.DEVICE_LIBRARY, predicates);
      let iconRootPath = (await PreferencesHelper.get(DeviceLibraryDao.ICON_ROOT_PATH_KEY, '')) as string + '/';
      for (let d of devices) {
        let i = d.get(DeviceLibraryField.VALUE);
        if (i != undefined) {
          let devicelib: LibraryDevice = JSON.parse(i) as LibraryDevice;
          res = await this.LibraryDeviceToDevice(devicelib, iconRootPath);
        }
      }
    }
    return res;
  }

  private async LibraryDeviceToDevice(devicelib: LibraryDevice, iconRootPath: string): Promise<Device> {
    let isZh = this.isZh;
    let device = new Device();
    for (let i = 0; i < devicelib.industryId.length; i++) {
      let indu: Industry = new Industry();
      indu.industryId = devicelib.industryId[i];
      indu.industryName = isZh ? devicelib.industryName[i] : devicelib.industryNameEn[i] || devicelib.industryName[i];
      device.industry.push(indu);
    }
    device.manufacturer.manufacturerId = devicelib.manufacturerId;
    device.manufacturer.manufacturerName =
      isZh ? devicelib.manufacturerName : devicelib.manufacturerNameEn || devicelib.manufacturerName;
    device.manufacturer.manufacturerFullName =
      isZh ? devicelib.manufacturerFullName : devicelib.manufacturerFullNameEn || devicelib.manufacturerFullName;
    device.deviceType.deviceTypeId = devicelib.deviceTypeId;
    device.deviceType.deviceTypeName = isZh ? devicelib.deviceTypeName : devicelib.deviceTypeNameEn;
    device.productId = devicelib.productID;
    device.deviceName = isZh ? devicelib.deviceName : devicelib.deviceNameEn || devicelib.deviceName;
    device.osTypeName = isZh ? devicelib.osTypeName : devicelib.osTypeNameEn || devicelib.osTypeName;
    device.osVersion = devicelib.osVersion;
    device.typicalService = isZh ? devicelib.typicalService : devicelib.typicalServiceEn || devicelib.typicalService;
    for (let i = 0; i < devicelib.deviceIcons.length; i++) {
      device.deviceIcons.push(fileUri.getUriFromPath(iconRootPath + devicelib.deviceIcons[i]));
    }
    device.deviceModel = devicelib.deviceModel;
    device.deviceProfile = devicelib.deviceProfile;
    device.pinType = devicelib.pinType;
    device.oHConnectCertified = devicelib.ohConnectCertified;
    return device;
  }
}