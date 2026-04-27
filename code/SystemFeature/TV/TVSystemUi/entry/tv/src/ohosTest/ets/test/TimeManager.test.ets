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
 

import { describe, it, expect } from '@ohos/hypium';
import { concatTime } from '@ohos/common/src/main/ets/default/TimeManager';

export default function timeManagerTest() {
  describe('TimeManager_Test', () => {

    // concatTime 是状态栏时钟 UI 的格式化函数，
    // TV 时钟区域宽度固定，必须始终输出"HH:MM"五字符格式，
    // 任何位数不足都会导致时钟区域宽度跳变，破坏状态栏布局稳定性。

    // ---- 格式化正确性 ----

    it('should_pad_single_digit_hour_and_minute', 0, () => {
      // 单位数时分必须左补零，TV 时钟 UI 需要固定宽度
      expect(concatTime(9, 5)).assertEqual('09:05');
    });

    it('should_not_pad_double_digit_values', 0, () => {
      expect(concatTime(14, 22)).assertEqual('14:22');
    });

    it('should_format_midnight', 0, () => {
      expect(concatTime(0, 0)).assertEqual('00:00');
    });

    it('should_format_end_of_day', 0, () => {
      expect(concatTime(23, 59)).assertEqual('23:59');
    });

    it('should_pad_minute_only_when_hour_is_double_digit', 0, () => {
      expect(concatTime(10, 5)).assertEqual('10:05');
    });

    it('should_pad_hour_only_when_minute_is_double_digit', 0, () => {
      expect(concatTime(9, 45)).assertEqual('09:45');
    });

    it('should_format_noon', 0, () => {
      expect(concatTime(12, 0)).assertEqual('12:00');
    });

    it('should_format_single_digit_hour_max_minute', 0, () => {
      expect(concatTime(1, 59)).assertEqual('01:59');
    });

    it('should_format_1am_01_minute', 0, () => {
      expect(concatTime(1, 1)).assertEqual('01:01');
    });

    // ---- 结构正确性 ----
    // 结构用例从字符串维度验证格式契约，与值正确性用例互补——
    // 值正确不代表结构正确（如 '9:5' 值对但长度为3），
    // TV UI 的 split(':') 解析依赖固定结构，结构异常会导致解析越界崩溃。

    it('result_is_always_5_characters', 0, () => {
      // 时钟 UI 需要固定宽度，所有合法时间格式化后必须是5个字符
      const testCases: number[][] = [[0, 0], [1, 1], [9, 9], [10, 10], [12, 0], [23, 59]];
      for (let i = 0; i < testCases.length; i++) {
        expect(concatTime(testCases[i][0], testCases[i][1]).length).assertEqual(5);
      }
    });

    it('colon_always_at_index_2', 0, () => {
      // 冒号位置固定在索引2，确保 UI 可以精确定位分隔符进行样式处理
      expect(concatTime(9, 5)[2]).assertEqual(':');
      expect(concatTime(23, 59)[2]).assertEqual(':');
    });

    it('exactly_two_parts_when_split_by_colon', 0, () => {
      const parts = concatTime(14, 22).split(':');
      expect(parts.length).assertEqual(2);
    });

    it('hour_part_is_always_2_chars', 0, () => {
      expect(concatTime(0, 0).split(':')[0].length).assertEqual(2);
      expect(concatTime(9, 0).split(':')[0].length).assertEqual(2);
      expect(concatTime(23, 0).split(':')[0].length).assertEqual(2);
    });

    it('minute_part_is_always_2_chars', 0, () => {
      expect(concatTime(0, 0).split(':')[1].length).assertEqual(2);
      expect(concatTime(0, 9).split(':')[1].length).assertEqual(2);
      expect(concatTime(0, 59).split(':')[1].length).assertEqual(2);
    });

    it('hour_part_value_correct', 0, () => {
      expect(concatTime(7, 30).split(':')[0]).assertEqual('07');
    });

    it('minute_part_value_correct', 0, () => {
      expect(concatTime(14, 3).split(':')[1]).assertEqual('03');
    });

  });
}
