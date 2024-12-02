/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { DeviceType, ScheduleInfo } from '../model/CalendarModel';

/**
 * 公共数据类
 */
export default class CommonData {
  // 日程点年月日数组，用于月视图和周视图日程点刷新
  public static SCHEDULE_ARRAY: string[] = [];
  // 日程点数组，用于应用持久化存储日程信息
  public static SCHEDULE_DATA: Array<ScheduleInfo> = [];
  // 月视图/周视图上当前选中的日期
  public static CURRENT_SELECT_DATE: string = '';
  // 设备类型
  public static DEVICE_TYPE: DeviceType = DeviceType.PHONE;
  // 是否是折叠屏设备
  public static IS_FOLD: boolean = false;
}