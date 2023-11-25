/*
 * Copyright (c) 2023 Fujian Newland Auto-ID Tech.Co.,Ltd.
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
import batteryInfo from '@ohos.batteryInfo'
import commonEventManager from '@ohos.commonEventManager'
import { logger } from '@ohos/common/src/main/ets/util/Logger';
import { getString } from '@ohos/common/src/main/ets/util/ResourceUtil';
import { BusinessError } from '@ohos.base'

let mBatteryPresent: SubscribedAbstractProperty<boolean>; // 是否支持电池或电池是否在位
let mBatterySOC: SubscribedAbstractProperty<string>; // 电池电量
let mChargingStatus: SubscribedAbstractProperty<string>; // 电池充电状态
let mHealthStatus: SubscribedAbstractProperty<string>; // 电池健康状态
let mPluggedType: SubscribedAbstractProperty<string>; // 电池充电器类型
let mVoltage: SubscribedAbstractProperty<string>; // 电池电压
let mTechnology: SubscribedAbstractProperty<string>; // 电池技术型号
let mTemperature: SubscribedAbstractProperty<string>; // 电池温度
let mCapacityLevel: SubscribedAbstractProperty<string>; // 电池电量等级
/**
 * 设备管理—电量信息
 */
class BatteryInfoUtil {
  private TAG: string = '[BatteryManager]'
  private subscriber: commonEventManager.CommonEventSubscriber | null = null;

  constructor() {
    mBatteryPresent = AppStorage.SetAndLink('BatteryPresent', true)
    mBatterySOC = AppStorage.SetAndLink("BatterySOC", '')
    mChargingStatus = AppStorage.SetAndLink("ChargingStatus", '')
    mHealthStatus = AppStorage.SetAndLink("HealthStatus", '')
    mPluggedType = AppStorage.SetAndLink("PluggedType", '')
    mVoltage = AppStorage.SetAndLink("Voltage", '')
    mTechnology = AppStorage.SetAndLink("Technology", '')
    mTemperature = AppStorage.SetAndLink("Temperature", '')
    mCapacityLevel = AppStorage.SetAndLink("CapacityLevel", '')
  }

  /**
   * 判断当前设备是否支持电池或者电池是否在位
   * @return 返回检测结果 true-电池在位 false-电池不在位
   */
  public isBatteryPresent(): boolean {
    const temp: boolean = batteryInfo.isBatteryPresent
    mBatteryPresent.set(temp)
    return temp
  }


  /**
   * 获取当前设备剩余电池电量百分比
   */
  public getBatterySOC(): string {
    let soc: number = this.disposeBatterySOC(batteryInfo.batterySOC)
    logger.info(`${this.TAG} getChargingStatus: ${soc}`)
    return soc.toString()
  }

  /**
   * 处理电量
   * @param soc 电量值
   */
  private disposeBatterySOC(soc: number): number {
    if (soc < 0) {
      soc = 0
    } else if (soc > 100) {
      soc = 100
    }
    mBatterySOC.set(soc.toString())
    return soc
  }

  /**
   * 获取当前设备电池的充电状态
   */
  public getChargingStatus(): string {
    const status: batteryInfo.BatteryChargeState = batteryInfo.chargingStatus
    logger.info(`${this.TAG} getChargingStatus: ${JSON.stringify(status)}`)
    let result: string = this.disposeChargingStatus(status)
    return result
  }

  /**
   *  处理设备电池的充电状态数据
   * @param code 状态值
   */
  private disposeChargingStatus(code: number): string {
    let result: string
    switch (code) {
      case batteryInfo.BatteryChargeState.ENABLE: {
        result = getString($r('app.string.battery_charging_status_enable'))
        break
      }
      case batteryInfo.BatteryChargeState.DISABLE: {
        result = getString($r('app.string.battery_charging_status_disable'))
        break
      }
      case batteryInfo.BatteryChargeState.FULL: {
        result = getString($r('app.string.battery_charging_status_full'))
        break
      }
      default: {
        result = getString($r('app.string.battery_unknown_text'))
      }
    }
    mChargingStatus.set(result)
    return result
  }

  /**
   * 获取当前设备电池的健康状态
   */
  public getHealthStatus(): string {
    const status: batteryInfo.BatteryHealthState = batteryInfo.healthStatus
    logger.info(`${this.TAG} getHealthStatus: ${status}`)
    let result: string = this.disposeHealthStatus(status)
    return result
  }

  /**
   * 处理当前设备电池的健康状态数据
   * @param code 状态码
   */
  private disposeHealthStatus(code: number): string {
    let result: string
    switch (code) {
      case batteryInfo.BatteryHealthState.GOOD: {
        result = getString($r('app.string.battery_health_state_good'))
        break
      }
      case batteryInfo.BatteryHealthState.OVERHEAT: {
        result = getString($r('app.string.battery_health_state_overheat'))
        break
      }
      case batteryInfo.BatteryHealthState.OVERVOLTAGE: {
        result = getString($r('app.string.battery_health_state_overvoltage'))
        break
      }
      case batteryInfo.BatteryHealthState.COLD: {
        result = getString($r('app.string.battery_health_state_cold'))
        break
      }
      case batteryInfo.BatteryHealthState.DEAD: {
        result = getString($r('app.string.battery_health_state_dead'))
        break
      }
      default: {
        result = getString($r('app.string.battery_unknown_text'))
      }
    }
    mHealthStatus.set(result)
    return result
  }

  /**
   * 获取当前设备连接的充电器类型
   */
  public getPluggedType(): string {
    const type: batteryInfo.BatteryPluggedType = batteryInfo.pluggedType
    logger.info(`${this.TAG} getPluggedType: ${type}`)
    let result: string = this.disposePluggedType(type)
    return result
  }

  /**
   * 处理当前设备连接的充电器类型数据
   * @param code 类型码
   */
  private disposePluggedType(code: number): string {
    let result: string
    switch (code) {
      case batteryInfo.BatteryPluggedType.AC: {
        result = getString($r('app.string.battery_plugged_type_ac'))
        break
      }
      case batteryInfo.BatteryPluggedType.USB: {
        result = getString($r('app.string.battery_plugged_type_usb'))
        break
      }
      case batteryInfo.BatteryPluggedType.WIRELESS: {
        result = getString($r('app.string.battery_plugged_type_wireless'))
        break
      }
      default: {
        result = getString($r('app.string.battery_unknown_text'))
      }
    }
    mPluggedType.set(result)
    return result
  }

  /**
   * 获取电池电压 单位：微伏
   */
  public getVoltage(): string {
    let voltage: string = batteryInfo.voltage.toString()
    logger.info(`${this.TAG} getVoltage: ${voltage}`)
    mVoltage.set(voltage)
    return voltage
  }

  /**
   * 获取当前设备电池的技术型号
   */
  public getTechnology(): string {
    let technology: string = this.disposeTechnology(batteryInfo.technology)
    logger.info(`${this.TAG} getTechnology: ${technology}`)
    return technology
  }

  /**
   * 处理电池的技术类型数据
   * @param technology 电池技术类型
   */
  private disposeTechnology(technology: string): string {
    if (typeof (technology) === 'undefined' || technology === '') {
      technology = getString($r('app.string.battery_unknown_text'))
    }
    mTechnology.set(technology)
    return technology
  }

  /**
   * 获取当前设备电池的温度，单位0.1摄氏度
   */
  public getBatteryTemperature(): string {
    let temp: number = batteryInfo.batteryTemperature
    logger.info(`${this.TAG} getBatteryTemperature: ${temp}`)
    let temperature: number = temp / 10
    mTemperature.set(temperature.toString())
    return temperature.toString()
  }


  /**
   * 获取当前设备电池电量的等级
   */
  public getBatteryCapacityLevel(): string {
    const level: batteryInfo.BatteryCapacityLevel = batteryInfo.batteryCapacityLevel
    logger.info(`${this.TAG} getBatteryCapacityLevel: ${level.toString()}`)
    let result: string = this.disposeCapacityLevel(level)
    return result
  }

  /**
   * 处理当前设备电池电量的等级数据
   * @param code 等级码
   */
  private disposeCapacityLevel(code: number): string {
    let result: string
    switch (code) {
      case batteryInfo.BatteryCapacityLevel.LEVEL_FULL: {
        result = getString($r('app.string.battery_capacity_level_full'))
        break
      }
      case batteryInfo.BatteryCapacityLevel.LEVEL_HIGH: {
        result = getString($r('app.string.battery_capacity_level_high'))
        break
      }
      case batteryInfo.BatteryCapacityLevel.LEVEL_NORMAL: {
        result = getString($r('app.string.battery_capacity_level_normal'))
        break
      }
      case batteryInfo.BatteryCapacityLevel.LEVEL_LOW: {
        result = getString($r('app.string.battery_capacity_level_low'))
        break
      }
      case batteryInfo.BatteryCapacityLevel.LEVEL_CRITICAL: {
        result = getString($r('app.string.battery_capacity_level_critical'))
        break
      }
      default: {
        result = getString($r('app.string.battery_unknown_text'))
      }
    }
    mCapacityLevel.set(result)
    return result
  }

  public registerEventBatteryChanged(): void {
    // 创建消息订阅者
    let subscribeInfo: commonEventManager.CommonEventSubscribeInfo = {
      events: [commonEventManager.Support.COMMON_EVENT_BATTERY_CHANGED]
    }
    commonEventManager.createSubscriber(subscribeInfo).then((commonEventSubscriber) => {
      logger.info(`${this.TAG} createSubscriber`)
      this.subscriber = commonEventSubscriber
      // 订阅公共事件
      try {
        commonEventManager.subscribe(this.subscriber, (err: BusinessError, data: commonEventManager.CommonEventData) => {
          if (err) {
            logger.error(`${this.TAG} subscribe failed, code is ${err.code}, message is ${err.message}`)
          } else {
            logger.info(`${this.TAG} subscribe data ${JSON.stringify(data)}`)
            // 处理电池各参数数据
            // "parameters":{"0":11,"1":4123456,"2":222,"3":1,"4":0,"5":0,"6":0,"7":0,"8":4000000,"9":false,"10":"Li-ion","11":1000,"moduleName":""}},
            // 电量

            if (data.parameters === undefined) {
              return;
            }

            this.disposeBatterySOC(data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_SOC]);
            logger.info(`${this.TAG} subscribe data EXTRA_SOC ${data?.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_SOC]}`);
            // 电压
            mVoltage.set(data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_VOLTAGE].toString());
            // 温度
            let temperature: number = data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_TEMPERATURE] / 10;
            mTemperature.set(temperature.toString());
            // 电池健康状态
            this.disposeHealthStatus(data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_HEALTH_STATE]);
            // 充电器类型
            this.disposePluggedType(data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_PLUGGED_TYPE]);
            // 充电状态
            this.disposeChargingStatus(data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_CHARGE_STATE]);
            // 技术型号
            this.disposeTechnology(data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_TECHNOLOGY]);
            // 设备是否支持电池或者电池是否在位
            mBatteryPresent.set(data.parameters[batteryInfo.CommonEventBatteryChangedKey.EXTRA_PRESENT]);
          }
        })
      } catch (err) {
        logger.error(`${this.TAG} subscribe failed, code is ${err.code}, message is ${err.message}`)
      }
    }).catch((err: BusinessError) => {
      logger.error(`${this.TAG} createSubscriber failed, code is ${err.code}, message is ${err.message}`)
    })
  }

  public unregisterEventBatteryChanged(): void {
    logger.info(`${this.TAG} unregisterEventBatteryChanged`)
    if (this.subscriber && this.subscriber !== null && this.subscriber !== undefined) {
      try {
        commonEventManager.unsubscribe(this.subscriber, (err) => {
          if (err) {
            logger.error(`${this.TAG} unsubscribe failed, code is ${err.code}, message is ${err.message}`)
          } else {
            logger.info(`${this.TAG} unsubscribe`)
          }
        })
      } catch (err) {
        logger.error(`${this.TAG} unsubscribe failed, code is ${err.code}, message is ${err.message}`)
      }
    } else {
      logger.info(`${this.TAG} subscriber is null or undefined`)
    }
  }
}

export default new BatteryInfoUtil()