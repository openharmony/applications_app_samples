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
import Log, { filterKey } from '@ohos/common/src/main/ets/default/Log';

class MessageHolder {
  message: string = '';

  setMessage(content: string): string {
    this.message = content;
    return this.message;
  }
}

class DescriptorHolder {
  value: (msg: string) => string;

  constructor(fn: (msg: string) => string) {
    this.value = fn;
  }
}

export default function logTest() {
  describe('Log_Test', () => {

    // ---- 各级别独立不抛异常（独立用例便于精准定位失败的级别）----

    it('Log_showDebug_does_not_throw', 0, () => {
      let threw = false;
      try {
        Log.showDebug('TEST', 'debug message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('Log_showInfo_does_not_throw', 0, () => {
      let threw = false;
      try {
        Log.showInfo('TEST', 'info message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('Log_showWarn_does_not_throw', 0, () => {
      let threw = false;
      try {
        Log.showWarn('TEST', 'warn message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('Log_showError_does_not_throw', 0, () => {
      let threw = false;
      try {
        Log.showError('TEST', 'error message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('Log_showFatal_does_not_throw', 0, () => {
      let threw = false;
      try {
        Log.showFatal('TEST', 'fatal message');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ---- 边界参数 ----

    it('Log_empty_tag_does_not_throw', 0, () => {
      // 空 tag 是合法调用，不应因参数校验抛出异常
      let threw = false;
      try {
        Log.showInfo('', 'message with empty tag');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('Log_empty_message_does_not_throw', 0, () => {
      // 空消息是合法调用，对应无额外信息的状态变化日志
      let threw = false;
      try {
        Log.showInfo('TEST', '');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('Log_both_tag_and_message_empty_does_not_throw', 0, () => {
      let threw = false;
      try {
        Log.showDebug('', '');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    // ---- filterKey 装饰器 ----

    it('filterKey_should_mask_hide_keyword', 0, () => {
      // 含 hide 关键字的敏感内容必须被遮掩，防止日志泄露用户隐私
      const holder = new MessageHolder();
      const descriptor: PropertyDescriptor =
        new DescriptorHolder((msg: string) => holder.setMessage(msg)) as PropertyDescriptor;
      filterKey(holder, 'setMessage', descriptor);
      const wrapped = descriptor.value as (msg: string) => void;
      wrapped('please hide content');
      expect(holder.message.includes('**')).assertTrue();
    });

    it('filterKey_without_hide_keyword_passes_through', 0, () => {
      // 不含 hide 关键字的消息不应被遮掩，避免正常日志内容被误处理
      const holder = new MessageHolder();
      const descriptor: PropertyDescriptor =
        new DescriptorHolder((msg: string) => holder.setMessage(msg)) as PropertyDescriptor;
      filterKey(holder, 'setMessage', descriptor);
      const wrapped = descriptor.value as (msg: string) => void;
      wrapped('normal log message');
      expect(holder.message.includes('**')).assertFalse();
    });

    it('filterKey_mask_replaces_hide_with_stars', 0, () => {
      // 遮掩后原始 hide 内容不应出现在返回值中
      const holder = new MessageHolder();
      const descriptor: PropertyDescriptor =
        new DescriptorHolder((msg: string) => holder.setMessage(msg)) as PropertyDescriptor;
      filterKey(holder, 'setMessage', descriptor);
      const wrapped = descriptor.value as (msg: string) => void;
      wrapped('hide secret');
      expect(holder.message.includes('hide secret')).assertFalse();
    });

    it('filterKey_empty_message_does_not_throw', 0, () => {
      // 空消息经过 filterKey 装饰后不应抛出异常
      const holder = new MessageHolder();
      const descriptor: PropertyDescriptor =
        new DescriptorHolder((msg: string) => holder.setMessage(msg)) as PropertyDescriptor;
      filterKey(holder, 'setMessage', descriptor);
      const wrapped = descriptor.value as (msg: string) => string;
      let threw = false;
      try {
        wrapped('');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

  });
}
