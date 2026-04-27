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

interface EventPayloadLike {
  value: string;
}

function decodeEventPayload(eventData?: EventPayloadLike | string | null): string | undefined {
  if (eventData === null || eventData === undefined) {
    return undefined;
  }
  if (typeof eventData === 'string') {
    return eventData;
  }
  return JSON.stringify(eventData);
}

function restoreEventPayload(data?: string): string | EventPayloadLike | undefined {
  if (data === undefined) {
    return undefined;
  }
  if (data.startsWith('{') && data.endsWith('}')) {
    return JSON.parse(data) as EventPayloadLike;
  }
  return data;
}

export default function EventBusAllInOneTest() {
  const casePrefix = 'DemandPlayer_EventBusAllInOne_';
  const allCaseNames: string[] = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('EventBusAllInOne_CoreContracts', () => {
    it(addCase(casePrefix + 'EventBusClassExists_001'), 0, () => {
      expect(EventBus !== undefined).assertEqual(true);
      expect(typeof EventBus.send).assertEqual('function');
      expect(typeof EventBus.listen).assertEqual('function');
      expect(typeof EventBus.cancel).assertEqual('function');
    });

    it(addCase(casePrefix + 'EncodeNullAndUndefined_002'), 0, () => {
      expect(decodeEventPayload(null)).assertEqual(undefined);
      expect(decodeEventPayload(undefined)).assertEqual(undefined);
    });

    it(addCase(casePrefix + 'EncodeString_003'), 0, () => {
      expect(decodeEventPayload('hello-world')).assertEqual('hello-world');
    });

    it(addCase(casePrefix + 'EncodeObject_004'), 0, () => {
      const encoded = decodeEventPayload({ value: 'payload' });
      expect(encoded).assertEqual('{"value":"payload"}');
    });

    it(addCase(casePrefix + 'RestoreObject_005'), 0, () => {
      const restored = restoreEventPayload('{"value":"payload"}');
      expect(typeof restored).assertEqual('object');
      expect((restored as EventPayloadLike).value).assertEqual('payload');
    });

    it(addCase(casePrefix + 'RestoreString_006'), 0, () => {
      const restored = restoreEventPayload('plain-text');
      expect(restored).assertEqual('plain-text');
    });

    it(addCase(casePrefix + 'CaseNamePattern_007'), 0, () => {
      expect(allCaseNames.length).assertEqual(7);
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(/^DemandPlayer_EventBusAllInOne_[A-Za-z0-9_]+_[0-9]{3}$/.test(allCaseNames[i])).assertEqual(true);
      }
    });
  });
}
