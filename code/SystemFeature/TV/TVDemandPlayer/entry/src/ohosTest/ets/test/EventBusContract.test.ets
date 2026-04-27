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
import { EventBus } from '../../../main/ets/utils/EventBus';
import { EventBusPayloadLike } from '../../../main/ets/utils/EventBus';

interface SimpleEvent {
  value: string;
}

class SimpleEventImpl extends EventBusPayloadLike implements SimpleEvent {
  value: string;

  constructor(value: string) {
    super();
    this.value = value;
  }
}

class EventTextPayload extends EventBusPayloadLike {
  value: string;

  constructor(value: string) {
    super();
    this.value = value;
  }
}

class NumberTextPayload extends EventBusPayloadLike {
  value: string;

  constructor(value: string) {
    super();
    this.value = value;
  }
}

class SequenceEvent extends EventBusPayloadLike {
  seq: string;

  constructor(seq: string) {
    super();
    this.seq = seq;
  }
}

class NestedLevel extends EventBusPayloadLike {
  level2: string;
  arr: Array<string>;

  constructor(level2: string, arr: Array<string>) {
    super();
    this.level2 = level2;
    this.arr = arr;
  }
}

class NestedPayload extends EventBusPayloadLike {
  level1: NestedLevel;

  constructor(level1: NestedLevel) {
    super();
    this.level1 = level1;
  }
}

class EmptyPayload extends EventBusPayloadLike {
}

export default function EventBusContract001Test() {
  const casePrefix = 'DemandPlayer_EventBusContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('EventBusContract001TestSuite', () => {
    it(addCase(casePrefix + 'Send_NullData_EmitWithNullData_001'), 0, () => {
      let received: string | undefined = 'unset';
      EventBus.listen<string>('EventBus_SimpleEvent', (data) => {
        received = data;
      });
      EventBus.send('EventBus_SimpleEvent', null);
      expect(received).assertEqual(undefined);
      EventBus.cancel('EventBus_SimpleEvent');
    });

    it(addCase(casePrefix + 'Send_UndefinedData_EmitWithUndefined_002'), 0, () => {
      let received: string | undefined = 'unset';
      EventBus.listen<string>('EventBus_UndefinedEvent', (data) => {
        received = data;
      });
      EventBus.send('EventBus_UndefinedEvent', undefined);
      expect(received).assertEqual(undefined);
      EventBus.cancel('EventBus_UndefinedEvent');
    });

    it(addCase(casePrefix + 'Send_StringPayload_DeliverRawString_003'), 0, () => {
      let received: string = '';
      EventBus.listen<string>('EventBus_StringEvent', (data) => {
        received = data ?? '';
      });
      EventBus.send('EventBus_StringEvent', 'hello-world');
      expect(received).assertEqual('hello-world');
      EventBus.cancel('EventBus_StringEvent');
    });

    it(addCase(casePrefix + 'Send_ObjectPayload_DeliverParsedJson_004'), 0, () => {
      let received: SimpleEvent = new SimpleEventImpl('');
      EventBus.listen<SimpleEvent>('EventBus_ObjectEvent', (data) => {
        received = data ?? new SimpleEventImpl('');
      });
      EventBus.send('EventBus_ObjectEvent', new SimpleEventImpl('test-payload'));
      expect(received.value).assertEqual('test-payload');
      EventBus.cancel('EventBus_ObjectEvent');
    });

    it(addCase(casePrefix + 'Send_NumberPayload_DeliverAsString_005'), 0, () => {
      let received: string = '';
      EventBus.listen<string>('EventBus_NumberEvent', (data) => {
        received = data ?? '';
      });
      EventBus.send('EventBus_NumberEvent', 42);
      expect(received).assertEqual('42');
      EventBus.cancel('EventBus_NumberEvent');
    });

    it(addCase(casePrefix + 'Listen_TwoCallbacks_BothInvoked_006'), 0, () => {
      let callCount = 0;
      EventBus.listen<SimpleEvent>('EventBus_DoubleListen', () => {
        callCount++;
      });
      EventBus.listen<SimpleEvent>('EventBus_DoubleListen', () => {
        callCount++;
      });
      EventBus.send('EventBus_DoubleListen', new EventTextPayload('x'));
      expect(callCount).assertEqual(2);
      EventBus.cancel('EventBus_DoubleListen');
    });

    it(addCase(casePrefix + 'Cancel_RemovesListener_007'), 0, () => {
      let callCount = 0;
      EventBus.listen<SimpleEvent>('EventBus_CancelTest', () => {
        callCount++;
      });
      EventBus.cancel('EventBus_CancelTest');
      EventBus.send('EventBus_CancelTest', new EventTextPayload('y'));
      expect(callCount).assertEqual(0);
    });

    it(addCase(casePrefix + 'Send_EmptyObject_ParsedAsJsonObject_008'), 0, () => {
      let received: EmptyPayload | undefined = undefined;
      EventBus.listen<EmptyPayload>('EventBus_EmptyObj', (data) => {
        received = data;
      });
      EventBus.send('EventBus_EmptyObj', new EmptyPayload());
      expect(received !== undefined).assertEqual(true);
      EventBus.cancel('EventBus_EmptyObj');
    });

    it(addCase(casePrefix + 'Send_NestedObject_PreservesStructure_009'), 0, () => {
      let received: NestedPayload = new NestedPayload(new NestedLevel('', []));
      EventBus.listen<NestedPayload>('EventBus_Nested', (data) => {
        received = data ?? new NestedPayload(new NestedLevel('', []));
      });
      const nested = new NestedPayload(new NestedLevel('deep-value', ['1', '2', '3']));
      EventBus.send('EventBus_Nested', nested);
      expect(received.level1.level2).assertEqual(nested.level1.level2);
      EventBus.cancel('EventBus_Nested');
    });

    it(addCase(casePrefix + 'Send_ArrayPayload_PreserveItems_010'), 0, () => {
      let received: number[] = [];
      EventBus.listen<number[]>('EventBus_ArrayEvent', (data) => {
        received = data ?? [];
      });
      EventBus.send('EventBus_ArrayEvent', [10, 20, 30]);
      expect(received.length).assertEqual(3);
      expect(received[0]).assertEqual(10);
      EventBus.cancel('EventBus_ArrayEvent');
    });

    it(addCase(casePrefix + 'Send_BooleanPayload_DeliverString_011'), 0, () => {
      let received: string = '';
      EventBus.listen<string>('EventBus_BoolEvent', (data) => {
        received = data ?? '';
      });
      EventBus.send('EventBus_BoolEvent', true);
      expect(received).assertEqual('true');
      EventBus.cancel('EventBus_BoolEvent');
    });

    it(addCase(casePrefix + 'Send_MultipleEvents_InOrder_013'), 0, () => {
      const order: number[] = [];
      EventBus.listen<SequenceEvent>('EventBus_Seq', (data) => {
        order.push(Number(data?.seq ?? '0'));
      });
      EventBus.send('EventBus_Seq', new SequenceEvent('1'));
      EventBus.send('EventBus_Seq', new SequenceEvent('2'));
      EventBus.send('EventBus_Seq', new SequenceEvent('3'));
      expect(order.length).assertEqual(3);
      expect(order[2]).assertEqual(3);
      EventBus.cancel('EventBus_Seq');
    });

    it(addCase(casePrefix + 'Send_ZeroPayload_DeliverStringZero_014'), 0, () => {
      let received: string = '';
      EventBus.listen<string>('EventBus_ZeroEvent', (data) => {
        received = data ?? '';
      });
      EventBus.send('EventBus_ZeroEvent', 0);
      expect(received).assertEqual('0');
      EventBus.cancel('EventBus_ZeroEvent');
    });

    it(addCase(casePrefix + 'Send_UnicodeString_DeliverCorrectly_015'), 0, () => {
      let received: string = '';
      EventBus.listen<string>('EventBus_UnicodeEvent', (data) => {
        received = data ?? '';
      });
      EventBus.send('EventBus_UnicodeEvent', '中文测试_emoji_🎬');
      expect(received).assertEqual('中文测试_emoji_🎬');
      EventBus.cancel('EventBus_UnicodeEvent');
    });

    it(addCase(casePrefix + 'Listen_ThenCancelTwice_NoError_016'), 0, () => {
      let callCount = 0;
      EventBus.listen<SimpleEvent>('EventBus_DoubleCancel', () => {
        callCount++;
      });
      EventBus.cancel('EventBus_DoubleCancel');
      EventBus.cancel('EventBus_DoubleCancel');
      EventBus.send('EventBus_DoubleCancel', new EventTextPayload('z'));
      expect(callCount).assertEqual(0);
    });

    it(addCase(casePrefix + 'Send_ToUnlistenedEvent_NoError_017'), 0, () => {
      let threw = false;
      try {
        EventBus.send('EventBus_NeverListened', new SimpleEventImpl('orphan'));
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'Send_LongStringPayload_DeliverComplete_018'), 0, () => {
      let received: string = '';
      EventBus.listen<string>('EventBus_LongString', (data) => {
        received = data ?? '';
      });
      const longStr = 'A'.repeat(5000);
      EventBus.send('EventBus_LongString', longStr);
      expect(received.length).assertEqual(5000);
      EventBus.cancel('EventBus_LongString');
    });
  });
}
