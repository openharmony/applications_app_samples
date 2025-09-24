'use static';
/**
 *
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 *
 * All rights reserved.
 * Redistribution and use in source and binary forms, with or without modification,
 * are permitted provided that the following conditions are met:
 *
 * Redistributions of source code must retain the above copyright notice,this
 * list of conditions and the following disclaimer.
 *
 * Redistributions in binary form must reproduce the above copyright notice,
 * this list of conditions and the following disclaimer in the documentation
 * and/or other materials provided with the distribution.
 *
 * THIS IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 'AS IS' AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
 * ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,
 * INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
 * PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
 * OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
 * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS,
 *
 * EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
import {
  memo,
  __memo_context_type,
  __memo_id_type
} from '@ohos.arkui.stateManagement';
import {
  Text,
  TextAttribute,
  Column,
  Component,
  Button,
  ButtonAttribute,
  ClickEvent,
  Entry
} from '@ohos.arkui.component';

import {
  State,
  Link,
  MutableState,
  stateOf,
  observableProxy
} from '@ohos.arkui.stateManagement';
import hilog from '@ohos.hilog';

const SATURDAY: int = 6; // 日历表上周六对应的序列号，从周日开始算起，取值0~6

/*
 * 根据指定年份和月份获取该月在日历表上的日期排布数据
 * @param {int} specifiedMonth - 指定月份
 * @param {int} specifiedYear - 指定年份
//  */
export function getMonthDate(specifiedMonth: int, specifiedYear: int): int[] {
  let currentFirstWeekDay: int = 0; // 初始化指定月的第一天是周几
  let currentLastWeekDay: int = 0; // 初始化指定月的最后一天是周几
  let currentAllDay: int[] = []; // 初始化指定月的日期排列数组
  let totalDays = new Date(specifiedYear, specifiedMonth, 0).getDate().toInt(); // 初始化指定月总天数
  currentFirstWeekDay = new Date(specifiedYear, specifiedMonth - 1, 1).getDay().toInt(); // 获取指定月的第一天是周几
  currentLastWeekDay = new Date(specifiedYear, specifiedMonth - 1, totalDays).getDay().toInt(); // 获取指定月的最后一天是周几
  // 将月份中显示上个月日期的内容置0
  for (let item = 0; item < currentFirstWeekDay; item++) {
    currentAllDay.push(0);
  }
  // 将本月日期内容存入数组
  for (let item = 1; item <= totalDays; item++) {
    currentAllDay.push(item);
  }
  // 将月份中显示下个月日期的内容置0
  for (let item = 0; item < SATURDAY - currentLastWeekDay; item++) {
    currentAllDay.push(0);
  }
  return currentAllDay;
}