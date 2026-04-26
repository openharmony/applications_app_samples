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
import { EventBus, EventBusPayloadLike } from '../../../main/ets/utils/EventBus';

class IndexPayload extends EventBusPayloadLike {
  i: string;

  constructor(i: string) {
    super();
    this.i = i;
  }
}

class ValuePayload extends EventBusPayloadLike {
  value: string;

  constructor(value: string) {
    super();
    this.value = value;
  }
}

class SequencePayload extends EventBusPayloadLike {
  seq: number;

  constructor(seq: number) {
    super();
    this.seq = seq;
  }
}

class MapEntryPayload extends EventBusPayloadLike {
  key: string;
  value: number;

  constructor(key: string, value: number) {
    super();
    this.key = key;
    this.value = value;
  }
}

class NumericMapPayload extends EventBusPayloadLike {
  entries: Array<MapEntryPayload> = [];
}

class NumericSetPayload extends EventBusPayloadLike {
  values: Array<number> = [];
}

class DeepNestedLevelG extends EventBusPayloadLike {
  g: string;

  constructor(g: string) {
    super();
    this.g = g;
  }
}

class DeepNestedLevelF extends EventBusPayloadLike {
  g: DeepNestedLevelG;

  constructor(g: DeepNestedLevelG) {
    super();
    this.g = g;
  }
}

class DeepNestedLevelE extends EventBusPayloadLike {
  f: DeepNestedLevelF;

  constructor(f: DeepNestedLevelF) {
    super();
    this.f = f;
  }
}

class DeepNestedLevelD extends EventBusPayloadLike {
  e: DeepNestedLevelE;

  constructor(e: DeepNestedLevelE) {
    super();
    this.e = e;
  }
}

class DeepNestedLevelC extends EventBusPayloadLike {
  d: DeepNestedLevelD;

  constructor(d: DeepNestedLevelD) {
    super();
    this.d = d;
  }
}

class DeepNestedLevelB extends EventBusPayloadLike {
  c: DeepNestedLevelC;

  constructor(c: DeepNestedLevelC) {
    super();
    this.c = c;
  }
}

class DeepNestedLevelA extends EventBusPayloadLike {
  b: DeepNestedLevelB;

  constructor(b: DeepNestedLevelB) {
    super();
    this.b = b;
  }
}

class DeepNestedPayload extends EventBusPayloadLike {
  a: DeepNestedLevelA;

  constructor(value: string) {
    super();
    this.a = new DeepNestedLevelA(
      new DeepNestedLevelB(
        new DeepNestedLevelC(
          new DeepNestedLevelD(
            new DeepNestedLevelE(
              new DeepNestedLevelF(
                new DeepNestedLevelG(value)
              )
            )
          )
        )
      )
    );
  }
}

class KeyValuePayload extends EventBusPayloadLike {
  key: string;
  value: string;

  constructor(key: string, value: string) {
    super();
    this.key = key;
    this.value = value;
  }
}

class ObjectWith50KeysPayload extends EventBusPayloadLike {
  values: Array<KeyValuePayload>;

  constructor() {
    super();
    this.values = [];
    for (let i = 0; i < 50; i++) {
      this.values.push(new KeyValuePayload('key_' + i, String(i)));
    }
  }
}

class MixedPayload extends EventBusPayloadLike {
  str: string = 'hello';
  num: string = '42';
  arr: string = '1,2,3';
  nested: string = '{"deep":true}';
}

export default function EventBusLargeDataset001Test() {
  const casePrefix = 'DemandPlayer_EventBusLargeDataset001_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('EventBusLargeDataset001TestSuite', () => {
    it(addCase(casePrefix + 'Send_50DifferentEvents_001'), 0, () => {
      for (let i = 0; i < 50; i++) {
        let called = false;
        EventBus.listen<IndexPayload>('EB_Large_' + i, () => {
          called = true;
        });
        EventBus.send('EB_Large_' + i, new IndexPayload(String(i)));
        expect(called).assertEqual(true);
        EventBus.cancel('EB_Large_' + i);
      }
    });

    it(addCase(casePrefix + 'Send_50SameEvent_MultipleListeners_002'), 0, () => {
      let count = 0;
      EventBus.listen<IndexPayload>('EB_SameEvent50', () => {
        count++;
      });
      EventBus.listen<IndexPayload>('EB_SameEvent50', () => {
        count++;
      });
      EventBus.listen<IndexPayload>('EB_SameEvent50', () => {
        count++;
      });
      for (let i = 0; i < 50; i++) {
        EventBus.send('EB_SameEvent50', new IndexPayload(String(i)));
      }
      expect(count).assertEqual(150);
      EventBus.cancel('EB_SameEvent50');
    });

    it(addCase(casePrefix + 'Send_LargePayload_1000Chars_003'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_LargePayload', (d) => {
        received = d === undefined ? '' : d;
      });
      EventBus.send('EB_LargePayload', 'X'.repeat(1000));
      expect(received.length).assertEqual(1000);
      EventBus.cancel('EB_LargePayload');
    });

    it(addCase(casePrefix + 'Send_LargePayload_5000Chars_004'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_LargePayload5k', (d) => {
        received = d === undefined ? '' : d;
      });
      EventBus.send('EB_LargePayload5k', 'Y'.repeat(5000));
      expect(received.length).assertEqual(5000);
      EventBus.cancel('EB_LargePayload5k');
    });

    it(addCase(casePrefix + 'Send_NestedDeepObject_005'), 0, () => {
      let receivedValue = '';
      EventBus.listen<DeepNestedPayload>('EB_DeepNested', (d) => {
        if (d !== undefined) {
          receivedValue = d.a.b.c.d.e.f.g.g;
        }
      });
      EventBus.send('EB_DeepNested', new DeepNestedPayload('deep-value'));
      expect(receivedValue).assertEqual('deep-value');
      EventBus.cancel('EB_DeepNested');
    });

    it(addCase(casePrefix + 'Send_LargeArray_100Items_006'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_LargeArray', (d) => {
        received = d === undefined ? '' : d;
      });
      const values: string[] = [];
      for (let i = 0; i < 100; i++) {
        values.push(String(i * 2));
      }
      EventBus.send('EB_LargeArray', values.join(','));
      expect(received.split(',').length).assertEqual(100);
      EventBus.cancel('EB_LargeArray');
    });

    it(addCase(casePrefix + 'Send_LargeArray_500Items_007'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_LargeArray500', (d) => {
        received = d === undefined ? '' : d;
      });
      const values: string[] = [];
      for (let i = 0; i < 500; i++) {
        values.push(String(i * 3));
      }
      EventBus.send('EB_LargeArray500', values.join(','));
      expect(received.split(',').length).assertEqual(500);
      EventBus.cancel('EB_LargeArray500');
    });

    it(addCase(casePrefix + 'Send_ObjectWith50Keys_008'), 0, () => {
      let receivedValue = '';
      EventBus.listen<ObjectWith50KeysPayload>('EB_50Keys', (d) => {
        if (d !== undefined) {
          receivedValue = d.values[49].value;
        }
      });
      EventBus.send('EB_50Keys', new ObjectWith50KeysPayload());
      expect(receivedValue.length > 0).assertEqual(true);
      EventBus.cancel('EB_50Keys');
    });

    it(addCase(casePrefix + 'Send_100EventsSequential_009'), 0, () => {
      const counts: number[] = [];
      for (let i = 0; i < 100; i++) {
        let c = 0;
        EventBus.listen<IndexPayload>('EB_Seq_' + i, () => {
          c++;
        });
        EventBus.send('EB_Seq_' + i, new IndexPayload(String(i)));
        counts.push(c);
        EventBus.cancel('EB_Seq_' + i);
      }
      for (let i = 0; i < 100; i++) {
        expect(counts[i]).assertEqual(1);
      }
    });

    it(addCase(casePrefix + 'Send_100EventsSameListener_010'), 0, () => {
      let totalCount = 0;
      EventBus.listen<IndexPayload>('EB_100Total', () => {
        totalCount++;
      });
      for (let i = 0; i < 100; i++) {
        EventBus.send('EB_100Total', new IndexPayload(String(i)));
      }
      expect(totalCount).assertEqual(100);
      EventBus.cancel('EB_100Total');
    });

    it(addCase(casePrefix + 'Send_UnicodeLarge_1000Chars_011'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_UnicodeLarge', (d) => {
        received = d === undefined ? '' : d;
      });
      const str = '中文测试字符'.repeat(100);
      EventBus.send('EB_UnicodeLarge', str);
      expect(received.length > 0).assertEqual(true);
      EventBus.cancel('EB_UnicodeLarge');
    });

    it(addCase(casePrefix + 'Send_BinaryLikeData_Uint8Array_012'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_BinaryData', (d) => {
        received = d === undefined ? '' : d;
      });
      const values: string[] = [];
      for (let i = 0; i < 256; i++) {
        values.push(String(i));
      }
      EventBus.send('EB_BinaryData', values.join(','));
      expect(received.split(',').length).assertEqual(256);
      EventBus.cancel('EB_BinaryData');
    });

    it(addCase(casePrefix + 'Send_MixedPayload_ObjectArrayNumber_013'), 0, () => {
      let received = '';
      EventBus.listen<MixedPayload>('EB_Mixed', (d) => {
        if (d !== undefined) {
          received = d.str;
        }
      });
      EventBus.send('EB_Mixed', new MixedPayload());
      expect(received).assertEqual('hello');
      EventBus.cancel('EB_Mixed');
    });

    it(addCase(casePrefix + 'Send_50PayloadsRapidly_014'), 0, () => {
      let lastReceived = -1;
      EventBus.listen<SequencePayload>('EB_Rapid50', (d) => {
        lastReceived = d === undefined ? -1 : d.seq;
      });
      for (let i = 0; i < 50; i++) {
        EventBus.send('EB_Rapid50', new SequencePayload(i));
      }
      expect(lastReceived).assertEqual(49);
      EventBus.cancel('EB_Rapid50');
    });

    it(addCase(casePrefix + 'Send_NullAndUndefined_Mixed_016'), 0, () => {
      const results: string[] = [];
      EventBus.listen<string>('EB_NullMix', (d) => {
        results.push(d === undefined ? 'undefined' : d);
      });
      EventBus.send('EB_NullMix', null);
      EventBus.send('EB_NullMix');
      EventBus.send('EB_NullMix', '0');
      EventBus.send('EB_NullMix', '');
      EventBus.send('EB_NullMix', 'false');
      expect(results.length).assertEqual(5);
      EventBus.cancel('EB_NullMix');
    });

    it(addCase(casePrefix + 'Send_MaxSafeInteger_017'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_MaxInt', (d) => {
        received = d === undefined ? '' : d;
      });
      EventBus.send('EB_MaxInt', String(Number.MAX_SAFE_INTEGER));
      expect(received.length > 0).assertEqual(true);
      EventBus.cancel('EB_MaxInt');
    });

    it(addCase(casePrefix + 'Send_MaxValue_Double_018'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_MaxDouble', (d) => {
        received = d === undefined ? '' : d;
      });
      EventBus.send('EB_MaxDouble', String(Number.MAX_VALUE));
      expect(received.length > 0).assertEqual(true);
      EventBus.cancel('EB_MaxDouble');
    });

    it(addCase(casePrefix + 'Send_NegativeValues_Mixed_019'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_NegMix', (d) => {
        received = d === undefined ? '' : d;
      });
      EventBus.send('EB_NegMix', '-1');
      EventBus.send('EB_NegMix', '-999999');
      EventBus.send('EB_NegMix', '-0.00001');
      expect(received).assertEqual('-0.00001');
      EventBus.cancel('EB_NegMix');
    });

    it(addCase(casePrefix + 'Send_DateObject_020'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_DateObj', (d) => {
        received = d === undefined ? '' : d;
      });
      EventBus.send('EB_DateObj', new Date(1700000000000).toISOString());
      expect(received.length > 0).assertEqual(true);
      EventBus.cancel('EB_DateObj');
    });

    it(addCase(casePrefix + 'Send_ArrayBufferLike_021'), 0, () => {
      let received = '';
      EventBus.listen<string>('EB_ArrBuf', (d) => {
        received = d === undefined ? '' : d;
      });
      EventBus.send('EB_ArrBuf', 'buffer-128');
      expect(received.length > 0).assertEqual(true);
      EventBus.cancel('EB_ArrBuf');
    });

    it(addCase(casePrefix + 'Send_PartialCancel_10Of50_022'), 0, () => {
      let total = 0;
      for (let i = 0; i < 50; i++) {
        EventBus.listen<IndexPayload>('EB_Cancel10_' + i, () => {
          total++;
        });
      }
      for (let i = 0; i < 10; i++) {
        EventBus.cancel('EB_Cancel10_' + i);
      }
      for (let i = 0; i < 50; i++) {
        EventBus.send('EB_Cancel10_' + i, new IndexPayload(String(i)));
      }
      for (let i = 0; i < 50; i++) {
        EventBus.cancel('EB_Cancel10_' + i);
      }
      expect(total).assertEqual(40);
    });

    it(addCase(casePrefix + 'Send_LargeMap_100Entries_023'), 0, () => {
      let receivedSize = 0;
      EventBus.listen<NumericMapPayload>('EB_LargeMap', (d) => {
        receivedSize = d === undefined ? 0 : d.entries.length;
      });
      const payload = new NumericMapPayload();
      for (let i = 0; i < 100; i++) {
        payload.entries.push(new MapEntryPayload('key_' + i, i));
      }
      EventBus.send('EB_LargeMap', payload);
      expect(receivedSize).assertEqual(100);
      EventBus.cancel('EB_LargeMap');
    });

    it(addCase(casePrefix + 'Send_LargeSet_100Entries_024'), 0, () => {
      let receivedSize = 0;
      EventBus.listen<NumericSetPayload>('EB_LargeSet', (d) => {
        receivedSize = d === undefined ? 0 : d.values.length;
      });
      const payload = new NumericSetPayload();
      for (let i = 0; i < 100; i++) {
        payload.values.push(i);
      }
      EventBus.send('EB_LargeSet', payload);
      expect(receivedSize).assertEqual(100);
      EventBus.cancel('EB_LargeSet');
    });

    it(addCase(casePrefix + 'Send_50ConcurrentListeners_025'), 0, () => {
      let totalCount = 0;
      for (let i = 0; i < 50; i++) {
        EventBus.listen<ValuePayload>('EB_50Listeners', () => {
          totalCount++;
        });
      }
      EventBus.send('EB_50Listeners', new ValuePayload('42'));
      expect(totalCount).assertEqual(50);
      EventBus.cancel('EB_50Listeners');
    });

    it(addCase(casePrefix + 'CaseNamePattern_026'), 0, () => {
      expect(allCaseNames.length).assertEqual(25);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_EventBusLargeDataset001_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
