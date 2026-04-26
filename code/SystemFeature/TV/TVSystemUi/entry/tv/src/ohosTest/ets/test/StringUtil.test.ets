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
import StringUtil from '../../../../../../product/tv/navigationBar/src/main/ets/util/StringUtil';

export default function stringUtilTest() {
  describe('StringUtil_Test', () => {

    // StringUtil 是导航栏模块的字符串处理工具，
    // replaceAll 用于处理按键标签的动态拼接和分隔符清理，
    // isEmpty 用于过滤来自系统配置的无效空白字符串，两者都是高频调用路径。

    // ---- replaceAll ----

    it('replaceAll_single_occurrence', 0, () => {
      expect(StringUtil.replaceAll('hello world', 'world', 'ArkTS')).assertEqual('hello ArkTS');
    });

    it('replaceAll_multiple_occurrences', 0, () => {
      // 原生 replace 只替换首次，replaceAll 必须循环直到无匹配，此用例验证循环逻辑正确性
      expect(StringUtil.replaceAll('aaa', 'a', 'b')).assertEqual('bbb');
    });

    it('replaceAll_consecutive_matches', 0, () => {
      expect(StringUtil.replaceAll('abab', 'ab', 'x')).assertEqual('xx');
    });

    it('replaceAll_no_match_returns_original', 0, () => {
      expect(StringUtil.replaceAll('hello', 'xyz', 'abc')).assertEqual('hello');
    });

    it('replaceAll_empty_string_input', 0, () => {
      expect(StringUtil.replaceAll('', 'a', 'b')).assertEqual('');
    });

    it('replaceAll_replace_with_empty_string', 0, () => {
      // TV 导航栏拼接按键标签时需要移除多余分隔符，用空串替换是常见用法
      expect(StringUtil.replaceAll('a,b,c', ',', '')).assertEqual('abc');
    });

    it('replaceAll_replace_spaces', 0, () => {
      expect(StringUtil.replaceAll('a b c', ' ', '-')).assertEqual('a-b-c');
    });

    it('replaceAll_overlapping_pattern', 0, () => {
      expect(StringUtil.replaceAll('aabbcc', 'bb', 'X')).assertEqual('aaXcc');
    });

    it('replaceAll_special_chars', 0, () => {
      // 按键事件名称中可能含特殊字符，需确保不被正则引擎误解析
      expect(StringUtil.replaceAll('a.b.c', '.', '/')).assertEqual('a/b/c');
    });

    // ---- isEmpty ----
    // isEmpty 使用 trim 后判断长度，专门应对系统配置字段返回纯空白字符串的场景，
    // 纯空白字符串在 JS 中是 truthy，若不 trim 会被误判为有效内容，导致显示空白标签。

    it('isEmpty_returns_true_for_undefined', 0, () => {
      expect(StringUtil.isEmpty(undefined)).assertTrue();
    });

    it('isEmpty_returns_true_for_null', 0, () => {
      expect(StringUtil.isEmpty(null)).assertTrue();
    });

    it('isEmpty_returns_true_for_empty_string', 0, () => {
      expect(StringUtil.isEmpty('')).assertTrue();
    });

    it('isEmpty_returns_true_for_whitespace_only', 0, () => {
      // TV 端从设置数据库读取的字段可能只含空白，业务侧需将其视为空值处理
      expect(StringUtil.isEmpty('   ')).assertTrue();
    });

    it('isEmpty_returns_true_for_tab_only', 0, () => {
      expect(StringUtil.isEmpty('\t')).assertTrue();
    });

    it('isEmpty_returns_true_for_newline_only', 0, () => {
      expect(StringUtil.isEmpty('\n')).assertTrue();
    });

    it('isEmpty_returns_false_for_normal_string', 0, () => {
      expect(StringUtil.isEmpty('SystemUi_NavigationBar')).assertFalse();
    });

    it('isEmpty_returns_false_for_string_with_spaces_around', 0, () => {
      // 含实际内容的字符串即使有前后空格也不应被视为空，trim只用于全空白判断
      expect(StringUtil.isEmpty('  hello  ')).assertFalse();
    });

    it('isEmpty_returns_false_for_single_char', 0, () => {
      expect(StringUtil.isEmpty('a')).assertFalse();
    });

    it('isEmpty_returns_false_for_numeric_string', 0, () => {
      expect(StringUtil.isEmpty('0')).assertFalse();
    });

    it('isEmpty_returns_false_for_mixed_whitespace_content', 0, () => {
      expect(StringUtil.isEmpty('\t hello \n')).assertFalse();
    });

    it('isEmpty_returns_true_for_mixed_whitespace_only', 0, () => {
      expect(StringUtil.isEmpty('\t  \n  ')).assertTrue();
    });

    it('replaceAll_long_string_multiple_replacements', 0, () => {
      // 长字符串中多次替换，验证循环逻辑在大量匹配时的稳定性
      const input = 'ab'.repeat(20);
      const result = StringUtil.replaceAll(input, 'ab', 'x');
      expect(result).assertEqual('x'.repeat(20));
    });

    it('replaceAll_multi_char_search_value', 0, () => {
      expect(StringUtil.replaceAll('SystemUi_StatusBar', 'SystemUi_', '')).assertEqual('StatusBar');
    });

    it('replaceAll_replace_entire_string', 0, () => {
      expect(StringUtil.replaceAll('hello', 'hello', 'world')).assertEqual('world');
    });

    it('isEmpty_returns_false_for_special_chars', 0, () => {
      // 特殊字符（如冒号、下划线）是有效内容
      expect(StringUtil.isEmpty('SystemUi_Entry')).assertFalse();
    });

    it('replaceAll_empty_replace_value_with_repeated_search', 0, () => {
      expect(StringUtil.replaceAll('aaaa', 'aa', 'b')).assertEqual('bb');
    });

  });
}
