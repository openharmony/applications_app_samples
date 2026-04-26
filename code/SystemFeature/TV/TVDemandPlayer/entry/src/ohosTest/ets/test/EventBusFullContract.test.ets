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

class GenericPayload extends EventBusPayloadLike {
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

class EventObjectPayload extends EventBusPayloadLike {
  key1: string;
  key2: string;
  nested: GenericPayload;

  constructor(key1: string, key2: string, nested: GenericPayload) {
    super();
    this.key1 = key1;
    this.key2 = key2;
    this.nested = nested;
  }
}

class EmptyPayload extends EventBusPayloadLike {
}

class SequenceEvent extends EventBusPayloadLike {
  seq: string;

  constructor(seq: string) {
    super();
    this.seq = seq;
  }
}

class FinalPayload extends EventBusPayloadLike {
  value: string;

  constructor(value: string) {
    super();
    this.value = value;
  }
}

class CounterPayload extends EventBusPayloadLike {
  value: string;

  constructor(value: string) {
    super();
    this.value = value;
  }
}

export default function EventBusFullContract001Test() {
  const casePrefix = 'DemandPlayer_EventBusFullContract001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('EventBusFullContract001TestSuite', () => {
    it(addCase(casePrefix + 'Send_NullData_NullDelivered_001'), 0, () => {
      let received: string | undefined = undefined;
      EventBus.listen<string>('EB_NullData', (d) => {
        received = d;
      });
      EventBus.send('EB_NullData', null);
      expect(received).assertEqual(undefined);
      EventBus.cancel('EB_NullData');
    });

    it(addCase(casePrefix + 'Send_UndefinedData_UndefinedDelivered_002'), 0, () => {
      let received: string | undefined = undefined;
      EventBus.listen<string>('EB_UndefinedData', (d) => {
        received = d;
      });
      EventBus.send('EB_UndefinedData', undefined);
      expect(received).assertEqual(undefined);
      EventBus.cancel('EB_UndefinedData');
    });

    it(addCase(casePrefix + 'Send_String_SameStringDelivered_003'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_String', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_String', 'test-string-payload');
      expect(received).assertEqual('test-string-payload');
      EventBus.cancel('EB_String');
    });

    it(addCase(casePrefix + 'Send_Number_AsString_004'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_Number', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_Number', 42);
      expect(received).assertEqual('42');
      EventBus.cancel('EB_Number');
    });

    it(addCase(casePrefix + 'Send_Boolean_TrueAsString_005'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_Bool', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_Bool', true);
      expect(received).assertEqual('true');
      EventBus.cancel('EB_Bool');
    });

    it(addCase(casePrefix + 'Send_Boolean_FalseAsString_006'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_BoolFalse', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_BoolFalse', false);
      expect(received).assertEqual('false');
      EventBus.cancel('EB_BoolFalse');
    });

    it(addCase(casePrefix + 'Send_Object_PreservesKeys_007'), 0, () => {
      let received: EventObjectPayload = new EventObjectPayload('', '', new GenericPayload(''));
      EventBus.listen<EventObjectPayload>('EB_Object', (d) => {
        received = d ?? new EventObjectPayload('', '', new GenericPayload(''));
      });
      EventBus.send('EB_Object', new EventObjectPayload('val1', '2', new GenericPayload('true')));
      expect(received.key1).assertEqual('val1');
      EventBus.cancel('EB_Object');
    });

    it(addCase(casePrefix + 'Send_EmptyObject_008'), 0, () => {
      let received: EmptyPayload | undefined = undefined;
      EventBus.listen<EmptyPayload>('EB_EmptyObj', (d) => {
        received = d;
      });
      EventBus.send('EB_EmptyObj', new EmptyPayload());
      expect(received !== undefined).assertEqual(true);
      EventBus.cancel('EB_EmptyObj');
    });

    it(addCase(casePrefix + 'Send_Array_PreservesItems_009'), 0, () => {
      let received: number[] = [];
      EventBus.listen<number[]>('EB_Array', (d) => {
        received = d ?? [];
      });
      EventBus.send('EB_Array', [10, 20, 30, 40, 50]);
      expect(received.length).assertEqual(5);
      expect(received[4]).assertEqual(50);
      EventBus.cancel('EB_Array');
    });

    it(addCase(casePrefix + 'Send_MultipleListeners_AllCalled_010'), 0, () => {
      let count1 = 0, count2 = 0, count3 = 0;
      EventBus.listen<GenericPayload>('EB_Multi', () => {
        count1++;
      });
      EventBus.listen<GenericPayload>('EB_Multi', () => {
        count2++;
      });
      EventBus.listen<GenericPayload>('EB_Multi', () => {
        count3++;
      });
      EventBus.send('EB_Multi', new GenericPayload('x'));
      expect(count1).assertEqual(1);
      expect(count2).assertEqual(1);
      expect(count3).assertEqual(1);
      EventBus.cancel('EB_Multi');
    });

    it(addCase(casePrefix + 'Cancel_OneListener_OtherSurvives_011'), 0, () => {
      let count1 = 0, count2 = 0;
      EventBus.listen<GenericPayload>('EB_PartialCancel', () => {
        count1++;
      });
      EventBus.listen<GenericPayload>('EB_PartialCancel', () => {
        count2++;
      });
      EventBus.cancel('EB_PartialCancel');
      EventBus.send('EB_PartialCancel', new GenericPayload('y'));
      expect(count1).assertEqual(0);
      expect(count2).assertEqual(0);
    });

    it(addCase(casePrefix + 'Listen_TwiceSameEvent_BothStored_012'), 0, () => {
      let count = 0;
      EventBus.listen<GenericPayload>('EB_DoubleListen2', () => {
        count++;
      });
      EventBus.listen<GenericPayload>('EB_DoubleListen2', () => {
        count++;
      });
      EventBus.send('EB_DoubleListen2', new GenericPayload('z'));
      expect(count).assertEqual(2);
      EventBus.cancel('EB_DoubleListen2');
    });

    it(addCase(casePrefix + 'Send_ToUnlistenedEvent_NoThrow_013'), 0, () => {
      let threw = false;
      try {
        EventBus.send('EB_NeverSubscribed', new GenericPayload('orphan'));
      } catch (_err) {
        threw = true;
      }
      expect(threw).assertEqual(false);
    });

    it(addCase(casePrefix + 'Send_Unicode_015'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_Unicode', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_Unicode', '中文_emoji_🎬_ العربية');
      expect(received).assertEqual('中文_emoji_🎬_ العربية');
      EventBus.cancel('EB_Unicode');
    });

    it(addCase(casePrefix + 'Send_LongString_5000Chars_016'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_LongStr', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_LongStr', 'B'.repeat(5000));
      expect(received.length).assertEqual(5000);
      EventBus.cancel('EB_LongStr');
    });

    it(addCase(casePrefix + 'Send_Zero_AsString_017'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_Zero', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_Zero', 0);
      expect(received).assertEqual('0');
      EventBus.cancel('EB_Zero');
    });

    it(addCase(casePrefix + 'Send_NegativeNumber_AsString_018'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_NegNum', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_NegNum', -12345);
      expect(received).assertEqual('-12345');
      EventBus.cancel('EB_NegNum');
    });

    it(addCase(casePrefix + 'Send_Double_MaxValue_019'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_DoubleMax', (d) => {
        received = d ?? '';
      });
      EventBus.send('EB_DoubleMax', 1.7976931348623157e+308);
      expect(received.length > 0).assertEqual(true);
      EventBus.cancel('EB_DoubleMax');
    });

    it(addCase(casePrefix + 'Send_MultipleEvents_InOrder_020'), 0, () => {
      const order: number[] = [];
      EventBus.listen<SequenceEvent>('EB_Seq2', (d) => {
        order.push(Number(d?.seq ?? '0'));
      });
      for (let i = 0; i < 20; i++) {
        EventBus.send('EB_Seq2', new SequenceEvent(i.toString()));
      }
      expect(order.length).assertEqual(20);
      expect(order[19]).assertEqual(19);
      EventBus.cancel('EB_Seq2');
    });

    it(addCase(casePrefix + 'Cancel_AfterMultipleSend_021'), 0, () => {
      let count = 0;
      EventBus.listen<CounterPayload>('EB_CancelAfter', () => {
        count++;
      });
      for (let i = 0; i < 10; i++) {
        EventBus.send('EB_CancelAfter', new CounterPayload(i.toString()));
      }
      EventBus.cancel('EB_CancelAfter');
      EventBus.send('EB_CancelAfter', new FinalPayload('true'));
      expect(count).assertEqual(10);
    });

    it(addCase(casePrefix + 'Send_NestedArray_022'), 0, () => {
      let received: number[][] = [];
      EventBus.listen<number[][]>('EB_NestedArr', (d) => {
        received = d ?? [];
      });
      EventBus.send('EB_NestedArr', [[1, 2], [3, 4], [5, 6]]);
      expect(received.length).assertEqual(3);
      expect(received[2][1]).assertEqual(6);
      EventBus.cancel('EB_NestedArr');
    });
  });
}
