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

import batteryStats from '@ohos.batteryStatistics';
import { BatteryStatsModel } from '../model/BatteryStatsModel';
import bundleManager from '@ohos.bundle.bundleManager';
import { logger } from '@ohos/common/src/main/ets/util/Logger';
import { GlobalContext } from '../../../../../../entry/src/main/ets/pages/GlobalContext';
import resourceManager from '@ohos.resourceManager';

const TAG: string = '[Sample_BatteryStatsUtil]';

/**
 * Binds battery data to components and provides interfaces.
 */
export class BatteryStatsUtil {
  // 缓存应用
  private applications: Array<bundleManager.ApplicationInfo> = [];
  private hardwareNames: Map<batteryStats.ConsumptionType, Resource> = new Map<batteryStats.ConsumptionType, Resource>();
  private hardwareIcons: Map<batteryStats.ConsumptionType, Resource> = new Map<batteryStats.ConsumptionType, Resource>();

  /**
   * 获取软件耗电统计
   * @return {Array<BatteryStatsModel>} listItems
   */
  async getSoftListData(): Promise<Array<BatteryStatsModel>> {
    return new Promise(async (resolve, reject) => {
      let appFlags = bundleManager.ApplicationFlag.GET_APPLICATION_INFO_DEFAULT;
      let listItems: BatteryStatsModel[] = [];
      try {
        if (!this.applications || this.applications.length === 0) {
          this.applications = await bundleManager.getAllApplicationInfo(appFlags);
        }
        let length = this.applications.length;
        for (let i = 0;i < length; i++) {
          let software = await this.getItemSoftware(this.applications[i]);
          if (software !== null) {
            listItems.push(software);
          }
        }
        resolve(listItems.sort(this.compare()))
      } catch (err) {
        logger.error(TAG, 'getAllApplicationInfo failed:' + err.message);
        resolve(listItems.sort(this.compare()))
      }
    })
  }

  /**
   * 获取硬件耗电统计
   CONSUMPTION_TYPE_INVALID  -17  表示电量消耗类型未知。
   CONSUMPTION_TYPE_APP  -16  表示应用消耗的电量类型。
   CONSUMPTION_TYPE_BLUETOOTH  -15  表示蓝牙消耗的电量类型。
   CONSUMPTION_TYPE_IDLE  -14  表示CPU空闲时消耗的电量类型。
   CONSUMPTION_TYPE_PHONE  -13  表示通话来电消耗的电量类型。
   CONSUMPTION_TYPE_RADIO  -12  表示无线通讯消耗的电量类型。
   CONSUMPTION_TYPE_SCREEN  -11  表示屏幕消耗的电量类型。
   CONSUMPTION_TYPE_USER  -10  表示用户消耗的电量类型。
   CONSUMPTION_TYPE_WIFI  -9  表示无线网消耗的电量类型。
   */
  getHardwareListData(): Promise<Array<BatteryStatsModel>> {
    return new Promise(async (resolve, reject) => {
      let listItems: Array<BatteryStatsModel> = [];
      listItems.push(this.getItemDataHardware(batteryStats.ConsumptionType.CONSUMPTION_TYPE_BLUETOOTH));
      listItems.push(this.getItemDataHardware(batteryStats.ConsumptionType.CONSUMPTION_TYPE_IDLE));
      listItems.push(this.getItemDataHardware(batteryStats.ConsumptionType.CONSUMPTION_TYPE_PHONE));
      listItems.push(this.getItemDataHardware(batteryStats.ConsumptionType.CONSUMPTION_TYPE_RADIO));
      listItems.push(this.getItemDataHardware(batteryStats.ConsumptionType.CONSUMPTION_TYPE_SCREEN));
      listItems.push(this.getItemDataHardware(batteryStats.ConsumptionType.CONSUMPTION_TYPE_WIFI));
      resolve(listItems.sort(this.compare()))
    })
  }

  /**
   * 根据电量排序
   * @param pro='power'
   * @param order='desc'
   */
  compare() {
    return (obj1: BatteryStatsModel, obj2: BatteryStatsModel) => {
      let val1: number = obj1.percent;
      let val2: number = obj2.percent;
      if (val2 < val1) {
        return 1;
      } else if (val2 > val1) {
        return -1;
      } else {
        return 0;
      }
    }
  }

  getTotalPercent(list: Array<BatteryStatsModel>) {
    let total = 0;
    list.forEach(item => {
      total += item.percent;
    })
    return (total * 100).toFixed(0);
  }

  /**
   * 获取软件耗电信息
   * @return {BatteryStatsModel} new BatteryStatsModel()
   */
  getItemSoftware(appInfo: bundleManager.ApplicationInfo): Promise<BatteryStatsModel | null> {
    return new Promise(async (resolve, reject) => {
      let label: string = '';
      let imageBase64: string = '';
      let power = 0;
      let percent = 0;
      let icon: Resource | undefined = undefined;

      let labelResource: resourceManager.Resource = {
        bundleName: appInfo.labelResource.bundleName,
        moduleName: appInfo.labelResource.moduleName,
        id: appInfo.labelResource.id
      };
      try {
        let ctx: Context = GlobalContext.getContext().getValue('abilityContext') as Context;
        label = await ctx.resourceManager.getStringValue(labelResource);
      } catch (err) {
        logger.error(TAG, `getStringValue failed, err : ${JSON.stringify(err)}.`);
      }

      if (label) {
        let iconResource: resourceManager.Resource = {
          bundleName: appInfo.iconResource.bundleName,
          moduleName: appInfo.iconResource.moduleName,
          id: appInfo.iconResource.id
        };
        try {
          let ctx: Context = GlobalContext.getContext().getValue('abilityContext') as Context;
          imageBase64 = await ctx.resourceManager.getMediaContentBase64(iconResource);
        } catch (err) {
          logger.error(TAG, `getMediaContent failed, err : ${JSON.stringify(err)}.`);
          icon = $r("app.media.ic_default");
        }

        try {
          // 根据耗电类型获取硬件单元的耗电百分比。
          percent = batteryStats.getAppPowerPercent(appInfo.uid);
        } catch (err) {
          logger.info(TAG, `getAppPowerPercent err: ${JSON.stringify(err)}`);
        }

        let itemInfo: BatteryStatsModel = new BatteryStatsModel();
        itemInfo.uid = appInfo.uid;
        itemInfo.power = power;
        itemInfo.percent = percent;
        itemInfo.nameStr = label;
        if (imageBase64 !== '') {
          itemInfo.iconBase64 = imageBase64;
        }
        itemInfo.icon = icon;
        resolve(itemInfo)
      } else {
        resolve(null)
      }
    })
  }

  /**
   * 获取硬件耗电信息
   * @return {BatteryStatsModel} new BatteryStatsModel()
   */
  getItemDataHardware(type: batteryStats.ConsumptionType) {
    let power = 0;
    let percent = 0;
    try {
      // 根据耗电类型获取耗电百分比。
      percent = batteryStats.getHardwareUnitPowerPercent(type);
    } catch (err) {
      logger.info(TAG, `getHardwareUnitPowerPercent failed:${type}, ${err}`);
    }
    let itemInfo: BatteryStatsModel = new BatteryStatsModel();
    itemInfo.power = power;
    itemInfo.percent = percent;
    itemInfo.icon = this.getHardwareIcon(type);
    itemInfo.name = this.getHardwareName(type);
    return itemInfo;
  }

  /**
   * 获取硬件对应名称
   */
  getHardwareName(type: batteryStats.ConsumptionType) {
    if (this.hardwareNames.size === 0) {
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_INVALID, $r("app.string.battery_stats_type_invalid"));
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_BLUETOOTH, $r("app.string.battery_stats_type_bluetooth"));
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_IDLE, $r("app.string.battery_stats_type_idle"));
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_PHONE, $r("app.string.battery_stats_type_phone"));
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_RADIO, $r("app.string.battery_stats_type_radio"));
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_SCREEN, $r("app.string.battery_stats_type_screen"));
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_USER, $r("app.string.battery_stats_type_user"));
      this.hardwareNames.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_WIFI, $r("app.string.battery_stats_type_wifi"));
    }
    return this.hardwareNames.get(type);
  }

  /**
   * 获取硬件对应图标
   */
  getHardwareIcon(type: batteryStats.ConsumptionType) {
    if (this.hardwareIcons.size === 0) {
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_INVALID, $r("app.media.ic_battery_invalid"));
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_BLUETOOTH, $r("app.media.ic_battery_bluetooth"));
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_IDLE, $r("app.media.ic_battery_idle"));
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_PHONE, $r("app.media.ic_battery_phone"));
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_SCREEN, $r("app.media.ic_battery_screen"));
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_RADIO, $r("app.media.ic_battery_radio"));
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_USER, $r("app.media.ic_battery_user"));
      this.hardwareIcons.set(batteryStats.ConsumptionType.CONSUMPTION_TYPE_WIFI, $r("app.media.ic_battery_wifi"));
    }
    return this.hardwareIcons.get(type);
  }
}

let batteryListModel = new BatteryStatsUtil();

export default batteryListModel as BatteryStatsUtil