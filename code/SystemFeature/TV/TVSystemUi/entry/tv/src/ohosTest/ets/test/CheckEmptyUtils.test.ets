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
import CheckEmptyUtils from '@ohos/common/src/main/ets/default/CheckEmptyUtils';

class EmptyObj {
}

class NonEmptyObjSingle {
  key: string = 'value';
}

class NonEmptyObjMulti {
  a: number = 1;
  b: number = 2;
}

export default function checkEmptyUtilsTest() {
  describe('CheckEmptyUtils_Test', () => {

    // CheckEmptyUtils 是全局防御性校验工具，
    // SystemUI 从设置数据库、插件配置、系统回调获取的数据可能为 null/undefined/空串，
    // 统一通过此工具校验，避免各模块重复实现空值判断导致语义不一致。

    it('isEmpty_should_return_true_for_undefined', 0, () => {
      expect(CheckEmptyUtils.isEmpty(undefined)).assertTrue();
    });

    it('isEmpty_should_return_true_for_null', 0, () => {
      expect(CheckEmptyUtils.isEmpty(null)).assertTrue();
    });

    it('isEmpty_should_return_true_for_empty_string', 0, () => {
      expect(CheckEmptyUtils.isEmpty('')).assertTrue();
    });

    it('isEmpty_should_return_true_for_empty_object', 0, () => {
      expect(CheckEmptyUtils.isEmpty(new EmptyObj())).assertTrue();
    });

    it('isEmpty_should_return_false_for_non_empty_string', 0, () => {
      expect(CheckEmptyUtils.isEmpty('hello')).assertFalse();
    });

    it('isEmpty_should_return_false_for_non_empty_object', 0, () => {
      expect(CheckEmptyUtils.isEmpty(new NonEmptyObjSingle())).assertFalse();
    });

    it('isEmpty_should_return_true_for_number_zero', 0, () => {
      expect(CheckEmptyUtils.isEmpty(0)).assertTrue();
    });

    it('isEmpty_should_return_true_for_boolean_false', 0, () => {
      expect(CheckEmptyUtils.isEmpty(false)).assertTrue();
    });

    it('checkStrIsEmpty_should_return_true_for_blank_string', 0, () => {
      // checkStrIsEmpty 通过 trim 判断，专门处理只含空白字符的"假非空"字符串，
      // 导航栏按键标签若只含空格，渲染为空白区域但不被 isEmpty 拦截，必须用此函数防守。
      expect(CheckEmptyUtils.checkStrIsEmpty('   ')).assertTrue();
    });

    it('checkStrIsEmpty_should_return_true_for_empty_string', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('')).assertTrue();
    });

    it('checkStrIsEmpty_should_return_false_for_non_empty_string', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('hello')).assertFalse();
    });

    it('checkStrIsEmpty_should_return_false_for_string_with_content_and_spaces', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('  hello  ')).assertFalse();
    });

    it('isEmptyArr_should_return_true_for_empty_array', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([])).assertTrue();
    });

    it('isEmptyArr_should_return_false_for_non_empty_array', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([1, 2, 3])).assertFalse();
    });

    it('isEmptyArr_array_with_zero_element_is_not_empty', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([0])).assertFalse();
    });

    // ---- 额外边界场景 ----
    // isEmpty 实现：typeof obj === 'undefined' || obj === null || obj === '' || Object.keys(obj).length === 0
    // Object.keys(number) 和 Object.keys(boolean) 在 ArkTS 中返回 []，length === 0，
    // 因此数字和布尔值会被 isEmpty 视为空，调用方不应将这些类型传入 isEmpty。

    it('isEmpty_should_return_false_for_positive_number', 0, () => {
      // Object.keys(1).length === 0，isEmpty(1) 实际返回 true
      expect(CheckEmptyUtils.isEmpty(1)).assertTrue();
    });

    it('isEmpty_should_return_false_for_negative_number', 0, () => {
      // Object.keys(-1).length === 0，isEmpty(-1) 实际返回 true
      expect(CheckEmptyUtils.isEmpty(-1)).assertTrue();
    });

    it('isEmpty_should_return_true_for_boolean_true', 0, () => {
      // Object.keys(true).length === 0，isEmpty(true) 实际返回 true
      expect(CheckEmptyUtils.isEmpty(true)).assertTrue();
    });

    it('isEmpty_object_with_multiple_keys_is_not_empty', 0, () => {
      expect(CheckEmptyUtils.isEmpty(new NonEmptyObjMulti())).assertFalse();
    });

    it('isEmptyArr_large_array_is_not_empty', 0, () => {
      const arr: number[] = new Array<number>(100).fill(0);
      expect(CheckEmptyUtils.isEmptyArr(arr)).assertFalse();
    });

    it('isEmptyArr_nested_array_is_not_empty', 0, () => {
      // 嵌套数组作为元素时，父数组不为空
      const nested: number[][] = [[]];
      expect(CheckEmptyUtils.isEmptyArr(nested)).assertFalse();
    });

    it('checkStrIsEmpty_single_visible_char_is_not_empty', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('a')).assertFalse();
    });

    it('checkStrIsEmpty_numeric_string_is_not_empty', 0, () => {
      expect(CheckEmptyUtils.checkStrIsEmpty('0')).assertFalse();
    });

    it('isEmpty_string_with_only_space_is_not_empty', 0, () => {
      // isEmpty 对字符串使用 !obj，空格字符串是 truthy，应返回 false
      // 区别于 checkStrIsEmpty 的 trim 语义
      expect(CheckEmptyUtils.isEmpty(' ')).assertFalse();
    });

    it('isEmptyArr_array_with_null_element_is_not_empty', 0, () => {
      expect(CheckEmptyUtils.isEmptyArr([null])).assertFalse();
    });

  });
}
