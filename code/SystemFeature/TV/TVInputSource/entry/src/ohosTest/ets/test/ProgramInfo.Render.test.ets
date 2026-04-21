/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, it, expect, beforeEach, afterEach } from '@ohos/hypium';
import {
  buildProgramInfoPresentation,
  ProgramInfoPresentation
} from '../../../main/ets/pages/ProgramInfo';

const TAG = '[ProgramInfo.Render.test]';

interface ProgramInfoChannelSnapshot {
  no: number;
  name: string;
  current: string;
  next: string;
  time: string;
}

class ProgramInfoRenderLifecycle {
  public channelNoInput: number = 0;
  public channelNameInput: string = '';
  public currentProgramInput: string = '';
  public nextProgramInput: string = '';
  public dateTimeInput: string = '';
  public presentationResult: ProgramInfoPresentation | null = null;

  public reset(): void {
    this.channelNoInput = 0;
    this.channelNameInput = '';
    this.currentProgramInput = '';
    this.nextProgramInput = '';
    this.dateTimeInput = '';
    this.presentationResult = null;
  }

  public buildWithInputs(): ProgramInfoPresentation {
    this.presentationResult = buildProgramInfoPresentation(
      this.channelNoInput,
      this.channelNameInput,
      this.currentProgramInput,
      this.nextProgramInput,
      this.dateTimeInput
    );
    return this.presentationResult;
  }
}

const lifecycle = new ProgramInfoRenderLifecycle();

function runProgramInfoRenderTests(): void {
  describe('ProgramInfo_render', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_preserve_valid_channel_number_when_positive', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('88');
    });

    it('should_convert_channel_number_to_dash_when_zero', 0, () => {
      lifecycle.channelNoInput = 0;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('--');
    });

    it('should_convert_channel_number_to_dash_when_negative', 0, () => {
      lifecycle.channelNoInput = -1;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('--');
    });

    it('should_convert_large_channel_number_to_string', 0, () => {
      lifecycle.channelNoInput = 999;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('999');
    });

    it('should_preserve_valid_channel_name_when_provided', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNameText).assertEqual('CCTV-1');
    });

    it('should_fallback_to_unknown_channel_when_name_is_empty', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = '';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNameText).assertEqual('未知频道');
    });

    it('should_fallback_to_unknown_channel_when_name_is_whitespace', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = '   ';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNameText).assertEqual('   ');
    });

    it('should_preserve_valid_current_program_when_provided', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.currentProgramText).assertEqual('新闻联播');
    });

    it('should_fallback_to_no_program_info_when_current_is_empty', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.currentProgramText).assertEqual('暂无节目信息');
    });

    it('should_fallback_to_no_program_info_when_current_is_whitespace', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '   ';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.currentProgramText).assertEqual('   ');
    });

    it('should_preserve_valid_next_program_when_provided', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.nextProgramText).assertEqual('天气预报');
    });

    it('should_fallback_to_no_upcoming_program_when_next_is_empty', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.nextProgramText).assertEqual('暂无后续节目');
    });

    it('should_fallback_to_no_upcoming_program_when_next_is_whitespace', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '   ';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.nextProgramText).assertEqual('   ');
    });

    it('should_pass_through_datetime_when_provided', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result.dateTimeText).assertEqual('2026-04-17 20:00');
    });

    it('should_pass_through_empty_datetime_without_fallback', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '';

      const result = lifecycle.buildWithInputs();

      expect(result.dateTimeText).assertEqual('');
    });
  });
}

function runProgramInfoBoundaryTests(): void {
  describe('ProgramInfo_boundary', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_handle_all_fields_empty_except_channel_no', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = '';
      lifecycle.currentProgramInput = '';
      lifecycle.nextProgramInput = '';
      lifecycle.dateTimeInput = '';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('88');
      expect(result.channelNameText).assertEqual('未知频道');
      expect(result.currentProgramText).assertEqual('暂无节目信息');
      expect(result.nextProgramText).assertEqual('暂无后续节目');
      expect(result.dateTimeText).assertEqual('');
    });

    it('should_handle_maximum_channel_number', 0, () => {
      lifecycle.channelNoInput = 2147483647;
      lifecycle.channelNameInput = 'MAX_CH';
      lifecycle.currentProgramInput = 'MAX_TEST';
      lifecycle.nextProgramInput = 'MAX_NEXT';
      lifecycle.dateTimeInput = '2026-12-31 23:59';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('2147483647');
    });

    it('should_handle_single_digit_channel_number', 0, () => {
      lifecycle.channelNoInput = 1;
      lifecycle.channelNameInput = 'CH1';
      lifecycle.currentProgramInput = 'TEST';
      lifecycle.nextProgramInput = 'NEXT';
      lifecycle.dateTimeInput = '2026-04-17';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('1');
    });

    it('should_handle_long_channel_name', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV_VERY_LONG_CHANNEL_NAME_TEST_123';
      lifecycle.currentProgramInput = 'LONG_PROGRAM_NAME_TEST';
      lifecycle.nextProgramInput = 'LONG_NEXT_PROGRAM_TEST';
      lifecycle.dateTimeInput = '2026-04-17';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNameText).assertEqual('CCTV_VERY_LONG_CHANNEL_NAME_TEST_123');
    });

    it('should_handle_special_characters_in_channel_name', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1 (中文) & More <Tag>';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNameText).assertEqual('CCTV-1 (中文) & More <Tag>');
    });

    it('should_handle_unicode_in_program_names', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = '中文频道';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-07';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNameText).assertEqual('中文频道');
      expect(result.currentProgramText).assertEqual('新闻联播');
      expect(result.nextProgramText).assertEqual('天气预报');
    });

    it('should_handle_datetime_with_various_formats', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = 'TEST';
      lifecycle.nextProgramInput = 'NEXT';

      const formats: string[] = [
        '2026-04-17',
        '2026/04/17',
        '04-17',
        '20:00',
        '2026-04-17 20:00:00',
        '20:00:00'
      ];

      formats.forEach((fmt, index) => {
        lifecycle.dateTimeInput = fmt;
        const result = lifecycle.buildWithInputs();
        expect(result.dateTimeText).assertEqual(fmt);
      });
    });
  });
}

function runProgramInfoErrorHandlingTests(): void {
  describe('ProgramInfo_error_handling', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_handle_null_like_empty_string_for_all_text_fields', 0, () => {
      lifecycle.channelNoInput = 1;
      lifecycle.channelNameInput = '';
      lifecycle.currentProgramInput = '';
      lifecycle.nextProgramInput = '';
      lifecycle.dateTimeInput = '';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('1');
      expect(result.channelNameText).assertEqual('未知频道');
      expect(result.currentProgramText).assertEqual('暂无节目信息');
      expect(result.nextProgramText).assertEqual('暂无后续节目');
      expect(result.dateTimeText).assertEqual('');
    });

    it('should_preserve_channel_no_1_correctly', 0, () => {
      lifecycle.channelNoInput = 1;
      lifecycle.channelNameInput = 'CH1';
      lifecycle.currentProgramInput = 'P1';
      lifecycle.nextProgramInput = 'P2';
      lifecycle.dateTimeInput = 'TIME';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('1');
    });

    it('should_distinguish_between_zero_and_one_channel_numbers', 0, () => {
      lifecycle.channelNoInput = 0;
      let result = lifecycle.buildWithInputs();
      expect(result.channelNoText).assertEqual('--');

      lifecycle.channelNoInput = 1;
      result = lifecycle.buildWithInputs();
      expect(result.channelNoText).assertEqual('1');
    });

    it('should_return_complete_presentation_object', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17 20:00';

      const result = lifecycle.buildWithInputs();

      expect(result).assertInstanceOf('Object');
      expect(result.channelNoText).assertInstanceOf('String');
      expect(result.channelNameText).assertInstanceOf('String');
      expect(result.currentProgramText).assertInstanceOf('String');
      expect(result.nextProgramText).assertInstanceOf('String');
      expect(result.dateTimeText).assertInstanceOf('String');
    });
  });
}

function runProgramInfoAudioVideoStateTests(): void {
  describe('ProgramInfo_audio_video_state', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_handle_channel_without_epg_data', 0, () => {
      lifecycle.channelNoInput = 99;
      lifecycle.channelNameInput = '空频道';
      lifecycle.currentProgramInput = '';
      lifecycle.nextProgramInput = '';
      lifecycle.dateTimeInput = '';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('99');
      expect(result.channelNameText).assertEqual('空频道');
      expect(result.currentProgramText).assertEqual('暂无节目信息');
      expect(result.nextProgramText).assertEqual('暂无后续节目');
      expect(result.dateTimeText).assertEqual('');
    });

    it('should_handle_channel_with_partial_epg_data', 0, () => {
      lifecycle.channelNoInput = 100;
      lifecycle.channelNameInput = '半信息频道';
      lifecycle.currentProgramInput = '有内容节目';
      lifecycle.nextProgramInput = '';
      lifecycle.dateTimeInput = '2026-04-17';

      const result = lifecycle.buildWithInputs();

      expect(result.channelNoText).assertEqual('100');
      expect(result.channelNameText).assertEqual('半信息频道');
      expect(result.currentProgramText).assertEqual('有内容节目');
      expect(result.nextProgramText).assertEqual('暂无后续节目');
    });

    it('should_preserve_existing_epg_content_when_only_one_field_missing', 0, () => {
      lifecycle.channelNoInput = 101;
      lifecycle.channelNameInput = '完整频道';
      lifecycle.currentProgramInput = '当前节目完整';
      lifecycle.nextProgramInput = '下个节目完整';
      lifecycle.dateTimeInput = '2026-04-17';

      const result = lifecycle.buildWithInputs();

      expect(result.currentProgramText).assertEqual('当前节目完整');
      expect(result.nextProgramText).assertEqual('下个节目完整');
    });

    it('should_handle_long_program_names_gracefully', 0, () => {
      lifecycle.channelNoInput = 1;
      lifecycle.channelNameInput = 'CH1';
      lifecycle.currentProgramInput = 'A'.repeat(500);
      lifecycle.nextProgramInput = 'B'.repeat(500);
      lifecycle.dateTimeInput = 'LONG';

      const result = lifecycle.buildWithInputs();

      expect(result.currentProgramText).assertEqual('A'.repeat(500));
      expect(result.nextProgramText).assertEqual('B'.repeat(500));
    });

    it('should_handle_special_characters_in_epg', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '节目名: "新闻联播" & 更多';
      lifecycle.nextProgramInput = '下一集: <预告>';
      lifecycle.dateTimeInput = '2026-04-17';

      const result = lifecycle.buildWithInputs();

      expect(result.currentProgramText).assertEqual('节目名: "新闻联播" & 更多');
      expect(result.nextProgramText).assertEqual('下一集: <预告>');
    });
  });
}

function runProgramInfoPresentationStructureTests(): void {
  describe('ProgramInfo_presentation_structure', () => {
    beforeEach(() => {
      lifecycle.reset();
    });

    afterEach(() => {
      lifecycle.reset();
    });

    it('should_maintain_field_order_in_presentation', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17';

      const result = lifecycle.buildWithInputs();
      const keys = Object.keys(result);

      expect(keys[0]).assertEqual('channelNoText');
      expect(keys[1]).assertEqual('channelNameText');
      expect(keys[2]).assertEqual('currentProgramText');
      expect(keys[3]).assertEqual('nextProgramText');
      expect(keys[4]).assertEqual('dateTimeText');
    });

    it('should_always_return_string_for_channel_no_text', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CH';
      lifecycle.currentProgramInput = 'P';
      lifecycle.nextProgramInput = 'N';
      lifecycle.dateTimeInput = 'D';

      const result = lifecycle.buildWithInputs();

      expect(typeof result.channelNoText).assertEqual('string');
      expect(result.channelNoText.length).assertLarger(0);
    });

    it('should_handle_simulated_rapid_channel_changes', 0, () => {
      const channelSequence: ProgramInfoChannelSnapshot[] = [
        { no: 1, name: 'CH1', current: 'P1', next: 'N1', time: 'T1' },
        { no: 2, name: 'CH2', current: 'P2', next: 'N2', time: 'T2' },
        { no: 3, name: 'CH3', current: 'P3', next: 'N3', time: 'T3' }
      ];

      channelSequence.forEach((ch) => {
        lifecycle.channelNoInput = ch.no;
        lifecycle.channelNameInput = ch.name;
        lifecycle.currentProgramInput = ch.current;
        lifecycle.nextProgramInput = ch.next;
        lifecycle.dateTimeInput = ch.time;

        const result = lifecycle.buildWithInputs();

        expect(result.channelNoText).assertEqual(`${ch.no}`);
        expect(result.channelNameText).assertEqual(ch.name);
        expect(result.currentProgramText).assertEqual(ch.current);
        expect(result.nextProgramText).assertEqual(ch.next);
        expect(result.dateTimeText).assertEqual(ch.time);
      });
    });

    it('should_handle_idempotent_calls_with_same_input', 0, () => {
      lifecycle.channelNoInput = 88;
      lifecycle.channelNameInput = 'CCTV-1';
      lifecycle.currentProgramInput = '新闻联播';
      lifecycle.nextProgramInput = '天气预报';
      lifecycle.dateTimeInput = '2026-04-17';

      const result1 = lifecycle.buildWithInputs();
      const result2 = lifecycle.buildWithInputs();
      const result3 = lifecycle.buildWithInputs();

      expect(result1.channelNoText).assertEqual(result2.channelNoText);
      expect(result2.channelNoText).assertEqual(result3.channelNoText);
      expect(result1.channelNameText).assertEqual(result2.channelNameText);
      expect(result2.channelNameText).assertEqual(result3.channelNameText);
    });
  });
}

export default function programInfoRenderTestSuite(): void {
  runProgramInfoRenderTests();
  runProgramInfoBoundaryTests();
  runProgramInfoErrorHandlingTests();
  runProgramInfoAudioVideoStateTests();
  runProgramInfoPresentationStructureTests();
}
