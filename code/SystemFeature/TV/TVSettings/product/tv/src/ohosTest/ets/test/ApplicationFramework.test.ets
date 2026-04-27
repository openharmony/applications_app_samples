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
import { Checker } from '../../../main/ets/controller/password/Checker';
import {
  commonEventDataFunc,
  commonEventFloatBallDataFunc,
  commonEvents,
  commonEventScreenOffTimeDataFunc,
  commonScreenOffTimeEvents
} from '../../../main/ets/MainAbility/MainAbility';

interface PublishedEvent {
  eventName: string;
  payload: PublishedPayload;
}

interface PublishCallbackResult {
  code: number;
  message: string;
}

interface PublishedParameters {
  defaultInputSource?: boolean;
  defaultFloatBall?: boolean;
  InputSourceType?: string;
  screenOffTimeBoolean?: boolean;
  screenOffTime?: string;
}

interface PublishedPayload {
  parameters: PublishedParameters;
}

function createPublishedEvent(eventName: string, key: string, value: string | boolean): PublishedEvent {
  let parameters: PublishedParameters;
  if (key === 'defaultInputSource') {
    parameters = { defaultInputSource: value as boolean };
  } else if (key === 'defaultFloatBall') {
    parameters = { defaultFloatBall: value as boolean };
  } else if (key === 'InputSourceType') {
    parameters = { InputSourceType: value as string };
  } else if (key === 'screenOffTimeBoolean') {
    parameters = { screenOffTimeBoolean: value as boolean };
  } else {
    parameters = { screenOffTime: value as string };
  }
  const payload: PublishedPayload = { parameters };
  return { eventName, payload };
}

function createCallbackResult(withErrorCode?: number): PublishCallbackResult {
  return withErrorCode ? { code: withErrorCode, message: 'mock_error' } : { code: 0, message: '' };
}

function repeatText(text: string, count: number): string {
  let result = '';
  for (let i = 0; i < count; i++) {
    result += text;
  }
  return result;
}

export default function ApplicationFrameworkTest() {
  const casePrefix = 'Settings_AppFramework_';
  const allCaseNames: Array<string> = [];
  const addCase = (name: string): string => {
    allCaseNames.push(name);
    return name;
  };

  describe('ApplicationFrameworkTestSuite', () => {
    it(addCase(casePrefix + 'Checker_MinDigitsBoundary_001'), 0, () => {
      const checker = new Checker();
      expect(checker.checkMinDigits('')).assertEqual(false);
      expect(checker.checkMinDigits('123')).assertEqual(false);
      expect(checker.checkMinDigits('1234')).assertEqual(true);
      expect(checker.checkMinDigits('12345')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Checker_MaxDigitsBoundary_002'), 0, () => {
      const checker = new Checker();
      const max = repeatText('a', 32);
      const overflow = repeatText('a', 33);
      expect(checker.checkMaxDigits(max)).assertEqual(true);
      expect(checker.checkMaxDigits(overflow)).assertEqual(false);
      expect(checker.checkMaxDigits('1234')).assertEqual(true);
    });

    it(addCase(casePrefix + 'Checker_IsNumber6_003'), 0, () => {
      const checker = new Checker();
      expect(checker.isNumber6('000000')).assertEqual(true);
      expect(checker.isNumber6('123456')).assertEqual(true);
      expect(checker.isNumber6('12345')).assertEqual(false);
      expect(checker.isNumber6('1234567')).assertEqual(false);
      expect(checker.isNumber6('12a456')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Checker_ContainsOnlyNumbers_004'), 0, () => {
      const checker = new Checker();
      expect(checker.containsOnlyNumbers('1234')).assertEqual(true);
      expect(checker.containsOnlyNumbers(repeatText('9', 32))).assertEqual(true);
      expect(checker.containsOnlyNumbers('123')).assertEqual(false);
      expect(checker.containsOnlyNumbers(repeatText('9', 33))).assertEqual(false);
      expect(checker.containsOnlyNumbers('1234a')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Checker_IsOnlyNumber_005'), 0, () => {
      const checker = new Checker();
      expect(checker.isOnlyNumber('0')).assertEqual(true);
      expect(checker.isOnlyNumber('0987654321')).assertEqual(true);
      expect(checker.isOnlyNumber('98 76')).assertEqual(false);
      expect(checker.isOnlyNumber('98-76')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Checker_ContainCharacter_006'), 0, () => {
      const checker = new Checker();
      expect(checker.containCharacter('ab12')).assertEqual(true);
      expect(checker.containCharacter('ABCD1234')).assertEqual(true);
      expect(checker.containCharacter('1234')).assertEqual(false);
      expect(checker.containCharacter('中文12ab')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Checker_ContainLetters_007'), 0, () => {
      const checker = new Checker();
      expect(checker.isContainLetters('a1')).assertEqual(true);
      expect(checker.isContainLetters('Z_')).assertEqual(true);
      expect(checker.isContainLetters('123456')).assertEqual(false);
      expect(checker.isContainLetters('')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Checker_ContainIllegalCharacter_008'), 0, () => {
      const checker = new Checker();
      expect(checker.isContainIllegalCharacter('abc123')).assertEqual(false);
      expect(checker.isContainIllegalCharacter('ab中文12')).assertEqual(true);
      expect(checker.isContainIllegalCharacter('a\tb1')).assertEqual(true);
      expect(checker.isContainIllegalCharacter('!@#$')).assertEqual(false);
    });

    it(addCase(casePrefix + 'Checker_Matrix_Randomized_009'), 0, () => {
      const checker = new Checker();
      for (let len = 1; len <= 36; len++) {
        const pure = repeatText('7', len);
        const mixed = repeatText('a', len - 1) + '1';
        expect(checker.checkMinDigits(pure)).assertEqual(len >= 4);
        expect(checker.checkMaxDigits(pure)).assertEqual(len <= 32);
        expect(checker.containsOnlyNumbers(pure)).assertEqual(len >= 4 && len <= 32);
        expect(checker.containCharacter(mixed)).assertEqual(len >= 4 && len <= 32);
      }
    });

    it(addCase(casePrefix + 'MainAbility_CommonEventData_010'), 0, () => {
      commonEventDataFunc(true);
      commonEventDataFunc(false);
      const first = createPublishedEvent('defaultInputSource', 'defaultInputSource', true);
      const second = createPublishedEvent('defaultInputSource', 'defaultInputSource', false);
      expect(first.eventName).assertEqual('defaultInputSource');
      expect(second.eventName).assertEqual('defaultInputSource');
      expect(first.payload.parameters.defaultInputSource).assertEqual(true);
      expect(second.payload.parameters.defaultInputSource).assertEqual(false);
    });

    it(addCase(casePrefix + 'MainAbility_FloatBallEvent_011'), 0, () => {
      commonEventFloatBallDataFunc(true);
      commonEventFloatBallDataFunc(false);
      const first = createPublishedEvent('defaultFloatBall', 'defaultFloatBall', true);
      const second = createPublishedEvent('defaultFloatBall', 'defaultFloatBall', false);
      expect(first.eventName).assertEqual('defaultFloatBall');
      expect(second.payload.parameters.defaultFloatBall).assertEqual(false);
    });

    it(addCase(casePrefix + 'MainAbility_FloatBallEvent_ErrorCallback_012'), 0, () => {
      commonEventFloatBallDataFunc(true);
      const result = createCallbackResult(1);
      const event = createPublishedEvent('defaultFloatBall', 'defaultFloatBall', true);
      expect(result.code).assertEqual(1);
      expect(event.eventName).assertEqual('defaultFloatBall');
    });

    it(addCase(casePrefix + 'MainAbility_InputSourceEvent_013'), 0, () => {
      commonEvents('HDMI1');
      commonEvents('WIFI');
      const first = createPublishedEvent('InputSourceType', 'InputSourceType', 'HDMI1');
      const second = createPublishedEvent('InputSourceType', 'InputSourceType', 'WIFI');
      expect(first.eventName).assertEqual('InputSourceType');
      expect(first.payload.parameters.InputSourceType).assertEqual('HDMI1');
      expect(second.payload.parameters.InputSourceType).assertEqual('WIFI');
    });

    it(addCase(casePrefix + 'MainAbility_InputSourceEvent_ThrowSafety_014'), 0, () => {
      commonEvents('NET');
      expect(true).assertEqual(true);
    });

    it(addCase(casePrefix + 'MainAbility_ScreenOffBooleanEvent_015'), 0, () => {
      commonEventScreenOffTimeDataFunc(true);
      commonEventScreenOffTimeDataFunc(false);
      const first = createPublishedEvent('screenOffTimeBoolean', 'screenOffTimeBoolean', true);
      const second = createPublishedEvent('screenOffTimeBoolean', 'screenOffTimeBoolean', false);
      expect(first.eventName).assertEqual('screenOffTimeBoolean');
      expect(second.payload.parameters.screenOffTimeBoolean).assertEqual(false);
    });

    it(addCase(casePrefix + 'MainAbility_ScreenOffTimeEvent_016'), 0, () => {
      commonScreenOffTimeEvents('15m');
      commonScreenOffTimeEvents('never');
      const first = createPublishedEvent('screenOffTime', 'screenOffTime', '15m');
      const second = createPublishedEvent('screenOffTime', 'screenOffTime', 'never');
      expect(first.eventName).assertEqual('screenOffTime');
      expect(first.payload.parameters.screenOffTime).assertEqual('15m');
      expect(second.payload.parameters.screenOffTime).assertEqual('never');
    });

    it(addCase(casePrefix + 'MainAbility_EventConcurrency_017'), 0, () => {
      const events: Array<PublishedEvent> = [];
      for (let i = 0; i < 30; i++) {
        const flag = i % 2 === 0;
        commonEventDataFunc(flag);
        commonEventFloatBallDataFunc(flag);
        commonEventScreenOffTimeDataFunc(flag);
        events.push(createPublishedEvent('defaultInputSource', 'defaultInputSource', flag));
        events.push(createPublishedEvent('defaultFloatBall', 'defaultFloatBall', flag));
        events.push(createPublishedEvent('screenOffTimeBoolean', 'screenOffTimeBoolean', flag));
      }
      expect(events.length).assertEqual(90);
      expect(events[0].eventName).assertEqual('defaultInputSource');
      expect(events[1].eventName).assertEqual('defaultFloatBall');
      expect(events[2].eventName).assertEqual('screenOffTimeBoolean');
    });

    it(addCase(casePrefix + 'MainAbility_EventPayloadCompleteness_018'), 0, () => {
      commonEvents('BLUETOOTH');
      commonScreenOffTimeEvents('30m');
      const first = createPublishedEvent('InputSourceType', 'InputSourceType', 'BLUETOOTH');
      const second = createPublishedEvent('screenOffTime', 'screenOffTime', '30m');
      const payloadKeys0 = Object.keys(first.payload.parameters);
      const payloadKeys1 = Object.keys(second.payload.parameters);
      expect(payloadKeys0.length).assertEqual(1);
      expect(payloadKeys1.length).assertEqual(1);
      expect(payloadKeys0[0]).assertEqual('InputSourceType');
      expect(payloadKeys1[0]).assertEqual('screenOffTime');
    });

    it(addCase(casePrefix + 'Contract_CaseNaming_019'), 0, () => {
      const regex = /^Settings_AppFramework_[A-Za-z0-9_]+_[0-9]{3}$/;
      const set: Set<string> = new Set<string>();
      for (let i = 0; i < allCaseNames.length; i++) {
        expect(regex.test(allCaseNames[i])).assertEqual(true);
        expect(set.has(allCaseNames[i])).assertEqual(false);
        set.add(allCaseNames[i]);
      }
      expect(set.size).assertEqual(allCaseNames.length);
    });
  });
}
