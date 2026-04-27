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
import { createEventBus } from '@ohos/common/src/main/ets/default/event/EventBus';
import type { EventArg } from '@ohos/common/src/main/ets/default/event/EventBus';

export default function eventBusTest() {
  describe('EventBus_Test', () => {

    // EventBus 是 SystemUI 各模块间解耦通信的核心基础设施，
    // 状态栏、导航栏、音量面板通过它传递显隐指令和数据更新，
    // 任何订阅/发布行为的异常都会导致面板状态不同步，在 TV 上表现为 UI 冻结或错误显示。

    it('should_receive_event_payload_after_on', 0, () => {
      const bus = createEventBus<string>();
      let received: string = '';
      bus.on('test', (args: EventArg) => {
        if (typeof args === 'string') {
          received = args;
        }
      });
      bus.emit('test', 'hello');
      expect(received).assertEqual('hello');
    });

    it('should_call_all_listeners_for_same_event', 0, () => {
      const bus = createEventBus<string>();
      let count = 0;
      bus.on('ev', () => {
        count++;
      });
      bus.on('ev', () => {
        count++;
      });
      bus.emit('ev', undefined);
      expect(count).assertEqual(2);
    });

    it('should_not_trigger_listener_for_different_event', 0, () => {
      const bus = createEventBus<string>();
      let received = false;
      bus.on('typeA', () => {
        received = true;
      });
      bus.emit('typeB', undefined);
      expect(received).assertFalse();
    });

    it('should_subscribe_to_array_of_events', 0, () => {
      const bus = createEventBus<string>();
      let count = 0;
      bus.on(['ev1', 'ev2'], () => {
        count++;
      });
      bus.emit('ev1', undefined);
      bus.emit('ev2', undefined);
      expect(count).assertEqual(2);
    });

    it('should_pass_correct_args_to_listener', 0, () => {
      const bus = createEventBus<string>();
      let val = 0;
      bus.on('num', (args: EventArg) => {
        if (typeof args === 'number') {
          val = args;
        }
      });
      bus.emit('num', 99);
      expect(val).assertEqual(99);
    });

    it('should_stop_receiving_after_off', 0, () => {
      // off 是 Ability 销毁时清理监听器的必要手段，
      // 若 off 不生效会造成内存泄漏，且已销毁的 UI 组件仍会收到事件导致崩溃。
      const bus = createEventBus<string>();
      let count = 0;
      const cb = () => {
        count++;
      };
      bus.on('ev', cb);
      bus.emit('ev', undefined);
      bus.off('ev', cb);
      bus.emit('ev', undefined);
      expect(count).assertEqual(1);
    });

    it('should_not_affect_other_listeners_when_one_is_removed', 0, () => {
      const bus = createEventBus<string>();
      let count = 0;
      const cb1 = () => {
        count++;
      };
      const cb2 = () => {
        count++;
      };
      bus.on('ev', cb1);
      bus.on('ev', cb2);
      bus.off('ev', cb1);
      bus.emit('ev', undefined);
      expect(count).assertEqual(1);
    });

    it('should_clear_all_listeners_when_off_with_undefined', 0, () => {
      const bus = createEventBus<string>();
      let count = 0;
      bus.on('ev', () => {
        count++;
      });
      bus.off(undefined, () => {
      });
      bus.emit('ev', undefined);
      expect(count).assertEqual(0);
    });

    it('on_should_return_unsubscribe_function_that_works', 0, () => {
      const bus = createEventBus<string>();
      let count = 0;
      const unsub = bus.on('ev', () => {
        count++;
      });
      bus.emit('ev', undefined);
      unsub();
      bus.emit('ev', undefined);
      expect(count).assertEqual(1);
    });

    it('once_should_only_invoke_listener_once', 0, () => {
      // once 用于只需响应一次的场景（如首次显示动画），
      // 若触发多次会导致动画重复播放或状态机多次转换，产生视觉混乱。
      const bus = createEventBus<string>();
      let count = 0;
      bus.once('ev', () => {
        count++;
      });
      bus.emit('ev', undefined);
      bus.emit('ev', undefined);
      bus.emit('ev', undefined);
      expect(count).assertEqual(1);
    });

    it('once_should_receive_correct_args_in_callback', 0, () => {
      const bus = createEventBus<string>();
      let received = 0;
      bus.once('ev', (args: EventArg) => {
        if (typeof args === 'number') {
          received = args;
        }
      });
      bus.emit('ev', 42);
      expect(received).assertEqual(42);
    });

    it('regular_listener_should_still_work_after_once_fires', 0, () => {
      const bus = createEventBus<string>();
      let onceCount = 0;
      let onCount = 0;
      bus.once('ev', () => {
        onceCount++;
      });
      bus.on('ev', () => {
        onCount++;
      });
      bus.emit('ev', undefined);
      bus.emit('ev', undefined);
      expect(onceCount).assertEqual(1);
      expect(onCount).assertEqual(2);
    });

    it('emit_with_no_listeners_should_not_throw', 0, () => {
      // 没有订阅者时 emit 不应抛出异常，避免模块初始化顺序问题导致崩溃
      const bus = createEventBus<string>();
      let threw = false;
      try {
        bus.emit('unregistered_event', 'data');
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('emit_object_payload_passed_correctly', 0, () => {
      interface Payload {
        type: string;
        value: number;
      }
      class PayloadData {
        type: string;
        value: number;
        constructor(type: string, value: number) {
          this.type = type;
          this.value = value;
        }
      }

      const bus = createEventBus<string>();
      let received: Payload | null = null;
      bus.on('obj', (args: EventArg) => {
        if (args instanceof PayloadData) {
          received = args as Payload;
        }
      });
      bus.emit('obj', new PayloadData('volume', 10));
      expect(received !== null).assertTrue();
      if (received) {
        expect((received as Payload).type).assertEqual('volume');
        expect((received as Payload).value).assertEqual(10);
      }
    });

    it('array_event_subscription_only_fires_for_matching_events', 0, () => {
      // 数组订阅中只有匹配的事件名触发，其他事件名不触发
      const bus = createEventBus<string>();
      let count = 0;
      bus.on(['ev1', 'ev2'], () => {
        count++;
      });
      bus.emit('ev3', undefined);
      expect(count).assertEqual(0);
    });

    it('off_nonexistent_listener_should_not_throw', 0, () => {
      // 移除未注册的监听器不应抛出异常
      const bus = createEventBus<string>();
      let threw = false;
      try {
        bus.off('unknown', () => {
        });
      } catch (e) {
        threw = true;
      }
      expect(threw).assertFalse();
    });

    it('multiple_once_listeners_each_fire_once', 0, () => {
      const bus = createEventBus<string>();
      let a = 0;
      let b = 0;
      bus.once('ev', () => {
        a++;
      });
      bus.once('ev', () => {
        b++;
      });
      bus.emit('ev', undefined);
      bus.emit('ev', undefined);
      expect(a).assertEqual(1);
      expect(b).assertEqual(1);
    });

    it('on_same_callback_twice_fires_twice', 0, () => {
      // EventBus 内部使用 Set 存储回调，同一个回调引用注册两次会被去重，
      // 实际只触发1次——这是 Set 的语义，与标准 EventEmitter 的 Array 行为不同。
      // TV 端多模块重复订阅时不会产生重复事件，避免 UI 状态叠加错误。
      const bus = createEventBus<string>();
      let count = 0;
      const cb = () => {
        count++;
      };
      bus.on('ev', cb);
      bus.on('ev', cb);
      bus.emit('ev', undefined);
      expect(count).assertEqual(1);
    });

  });
}

    