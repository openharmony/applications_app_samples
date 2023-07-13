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
import deviceInfo from '@ohos.deviceInfo'

export class DeviceUtil {

  /**
   * 设备类型
   */
  static deviceType(): string {
    return deviceInfo.deviceType
  }

  /**
   * 获取设备厂家名称
   */
  static manufacture(): string {
    return deviceInfo.manufacture
  }

  /**
   * 设备品牌名称
   */
  static brand(): string {
    return deviceInfo.brand
  }

  /**
   * 外部产品系列
   */
  static markerName(): string {
    return deviceInfo.marketName
  }

  /**
   * 产品系列
   */
  static productSeries(): string {
    return deviceInfo.productSeries
  }

  /**
   * 认证型号
   */
  static productModel(): string {
    return deviceInfo.productModel
  }

  /**
   * 内部软件子型号
   */
  static softwareModel(): string {
    return deviceInfo.softwareModel
  }

  /**
   *  硬件版本号
   */
  static hardwareModel(): string {
    return deviceInfo.hardwareModel
  }

  /**
   * 硬件Profile
   */
  static hardwareProfile(): string {
    return deviceInfo.hardwareProfile
  }

  /**
   * 设备序列号
   */
  static serial(): string {
    return deviceInfo.serial
  }

  /**
   * Bootloader版本号
   */
  static bootloaderVersion(): string {
    return deviceInfo.bootloaderVersion
  }

  /**
   * 应用二进制接口（Abi）列表
   */
  static abiList(): string {
    return deviceInfo.abiList
  }

  /**
   * 安全补丁级别
   */
  static securityPatchTag(): string {
    return deviceInfo.securityPatchTag
  }

  /**
   * 产品版本
   */
  static displayVersion(): string {
    return deviceInfo.displayVersion
  }

  /**
   * 差异版本号
   */
  static incrementalVersion(): string {
    return deviceInfo.incrementalVersion
  }

  /**
   * 系统的发布类型
   */
  static osReleaseType(): string {
    return deviceInfo.osReleaseType
  }

  /**
   * 系统版本
   */
  static osFullName(): string {
    return deviceInfo.osFullName
  }
  /**
   * Major版本号，随主版本更新增加。
   */
  static majorVersion() {
    return deviceInfo.majorVersion + ''
  }

  /**
   * Senior版本号，随局部架构、重大特性增加。
   */
  static seniorVersion(): string {
    return deviceInfo.seniorVersion + ''
  }

  /**
   * Feature版本号，标识规划的新特性版本。
   */
  static featureVersion(): string {
    return deviceInfo.featureVersion + ''
  }

  /**
   * Build版本号，标识编译构建的版本号。
   */
  static buildVersion(): string {
    return deviceInfo.buildVersion + ''
  }

  /**
   * 系统软件API版本
   */
  static sdkApiVersion(): string {
    return deviceInfo.sdkApiVersion + ''
  }

  /**
   * 首个版本系统软件API版本
   */
  static firstApiVersion(): string {
    return deviceInfo.firstApiVersion + ''
  }

  /**
   * 版本ID
   */
  static versionId(): string {
    return deviceInfo.versionId
  }
  /**
   * 构建类型
   */
  static buildType(): string {
    return deviceInfo.buildType
  }

  /**
   * 构建用户
   */
  static buildUser(): string {
    return deviceInfo.buildUser
  }

  /**
   * 构建主机
   */
  static buildHost(): string {
    return deviceInfo.buildHost
  }

  /**
   * 构建时间
   */
  static buildTime(): string {
    return deviceInfo.buildTime
  }
  /**
   * 构建版本Hash
   */
  static buildRootHash(): string {
    return deviceInfo.buildRootHash
  }

  /**
   * 设备Udid
   */
  static udid(): string {
    return deviceInfo.udid
  }
}