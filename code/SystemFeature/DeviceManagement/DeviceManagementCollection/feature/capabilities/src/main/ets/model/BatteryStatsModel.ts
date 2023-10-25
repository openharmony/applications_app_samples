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

import type batteryStats from '@ohos.batteryStatistics';

/**
 * baterystats data entity.
 */
export class BatteryStatsModel {
  icon: Resource | undefined; // 耗电信息相关图标资源文件

  iconBase64: string; // 耗电信息相关图标二进制文件

  name: Resource | undefined; // 耗电信息相关的名字资源文件

  nameStr: string; // 耗电信息相关的名字字符串

  uid: number; // 耗电信息相关的UID

  power: number; // 耗电的值，单位毫安时

  percent: number; // 耗电的值占比，百分比

  type: batteryStats.ConsumptionType; // 耗电信息相关的类型
}