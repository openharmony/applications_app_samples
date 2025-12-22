/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import { BusinessError } from '@kit.BasicServicesKit';
import commonEventModule from 'libentry.so';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG = 'CommonEventNapiTest';
const BUNDLE = 'com.samples.commoneventpublish';
const DOMAIN = 0xD001000;

function loggerInfo(msg: string): void {
  hilog.info(DOMAIN, TAG, `${BUNDLE}${msg}`);
}

function loggerError(msg: string): void {
  hilog.error(DOMAIN, TAG, `${BUNDLE}${msg}`);
}

export default function commonEventNapiTest() {
  describe('CommonEventNapiTest', () => {
    beforeAll(() => {
      loggerInfo('All tests begin');
    });

    beforeEach(() => {
      loggerInfo('Test case begin');
    });

    afterEach(() => {
      loggerInfo('Test case end, cleaning up resources');
      try {
        commonEventModule.destroySubscriber();
        commonEventModule.destroySubscribeInfo();
      } catch (error) {
        loggerError(`Cleanup error: ${JSON.stringify(error as BusinessError)}`);
      }
    });

    afterAll(() => {
      loggerInfo('All tests end');
    });

    /*
      *@tc.number CustomCommonEvent_CreateSubscribeInfo_001
      *@tc.name   CustomCommonEvent_CreateSubscribeInfo_001
      *@tc.desc   Test the functionality of creating common event subscribe information
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_CreateSubscribeInfo_001', 0, async (done: Function) => {
      loggerInfo('CreateSubscribeInfo_001 begin');
      try {
        const result = commonEventModule.createSubscribeInfo();
        loggerInfo(`CreateSubscribeInfo result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`CreateSubscribeInfo error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CreateSubscribeInfo_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_DestroySubscribeInfo_001
      *@tc.name   CustomCommonEvent_DestroySubscribeInfo_001
      *@tc.desc   Test the functionality of destroying common event subscribe information
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_DestroySubscribeInfo_001', 0, async (done: Function) => {
      loggerInfo('DestroySubscribeInfo_001 begin');
      try {
        // 先创建订阅信息
        commonEventModule.createSubscribeInfo();

        // 然后销毁订阅信息
        const result = commonEventModule.destroySubscribeInfo();
        loggerInfo(`DestroySubscribeInfo result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`DestroySubscribeInfo error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('DestroySubscribeInfo_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_CreateSubscriber_001
      *@tc.name   CustomCommonEvent_CreateSubscriber_001
      *@tc.desc   Test the functionality of creating common event subscriber with valid subscribe info
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_CreateSubscriber_001', 0, async (done: Function) => {
      loggerInfo('CreateSubscriber_001 begin');
      try {
        // 先创建订阅信息
        commonEventModule.createSubscribeInfo();

        // 然后创建订阅者
        const result = commonEventModule.createSubscriber();
        loggerInfo(`CreateSubscriber result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`CreateSubscriber error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CreateSubscriber_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_Subscribe_001
      *@tc.name   CustomCommonEvent_Subscribe_001
      *@tc.desc   Test the functionality of subscribing common event
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_Subscribe_001', 0, async (done: Function) => {
      loggerInfo('Subscribe_001 begin');
      try {
        // 先创建订阅信息和订阅者
        commonEventModule.createSubscribeInfo();
        commonEventModule.createSubscriber();

        // 然后订阅事件
        const result = commonEventModule.subscribe();
        loggerInfo(`Subscribe result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`Subscribe error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('Subscribe_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_Publish_001
      *@tc.name   CustomCommonEvent_Publish_001
      *@tc.desc   Test the functionality of publishing common event
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_Publish_001', 0, async (done: Function) => {
      loggerInfo('Publish_001 begin');
      try {
        const result = commonEventModule.publish();
        loggerInfo(`Publish result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`Publish error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('Publish_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_PublishWithInfo_001
      *@tc.name   CustomCommonEvent_PublishWithInfo_001
      *@tc.desc   Test the functionality of publishing common event with detailed information
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_PublishWithInfo_001', 0, async (done: Function) => {
      loggerInfo('PublishWithInfo_001 begin');
      try {
        const result = commonEventModule.publishWithInfo();
        loggerInfo(`PublishWithInfo result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`PublishWithInfo error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('PublishWithInfo_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_Unsubscribe_001
      *@tc.name   CustomCommonEvent_Unsubscribe_001
      *@tc.desc   Test the functionality of unsubscribing common event
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_Unsubscribe_001', 0, async (done: Function) => {
      loggerInfo('Unsubscribe_001 begin');
      try {
        // 先创建订阅信息、订阅者并订阅
        commonEventModule.createSubscribeInfo();
        commonEventModule.createSubscriber();
        commonEventModule.subscribe();

        // 然后取消订阅
        const result = commonEventModule.unsubscribe();
        loggerInfo(`Unsubscribe result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`Unsubscribe error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('Unsubscribe_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_FullFlow_001
      *@tc.name   CustomCommonEvent_FullFlow_001
      *@tc.desc   Test the complete flow of common event: create -> subscribe -> publish -> unsubscribe -> destroy
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_FullFlow_001', 0, async (done: Function) => {
      loggerInfo('FullFlow_001 begin');
      try {
        // 1. 创建订阅信息
        const createInfoResult = commonEventModule.createSubscribeInfo();
        loggerInfo(`CreateSubscribeInfo result: ${createInfoResult}`);
        expect(createInfoResult).assertEqual(true);

        // 2. 创建订阅者
        const createSubscriberResult = commonEventModule.createSubscriber();
        loggerInfo(`CreateSubscriber result: ${createSubscriberResult}`);
        expect(createSubscriberResult).assertEqual(true);

        // 3. 订阅事件
        const subscribeResult = commonEventModule.subscribe();
        loggerInfo(`Subscribe result: ${subscribeResult}`);
        expect(subscribeResult).assertEqual(true);

        // 4. 发布事件
        const publishResult = commonEventModule.publish();
        loggerInfo(`Publish result: ${publishResult}`);
        expect(publishResult).assertEqual(true);

        // 5. 取消订阅
        const unsubscribeResult = commonEventModule.unsubscribe();
        loggerInfo(`Unsubscribe result: ${unsubscribeResult}`);
        expect(unsubscribeResult).assertEqual(true);

        // 6. 销毁订阅者
        const destroySubscriberResult = commonEventModule.destroySubscriber();
        loggerInfo(`DestroySubscriber result: ${destroySubscriberResult}`);
        expect(destroySubscriberResult).assertEqual(true);

        // 7. 销毁订阅信息
        const destroyInfoResult = commonEventModule.destroySubscribeInfo();
        loggerInfo(`DestroySubscribeInfo result: ${destroyInfoResult}`);
        expect(destroyInfoResult).assertEqual(true);

      } catch (error) {
        loggerError(`FullFlow error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('FullFlow_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_GetSubscribeInfoState_001
      *@tc.name   CustomCommonEvent_GetSubscribeInfoState_001
      *@tc.desc   Test the functionality of getSubscribeInfoState
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_GetSubscribeInfoState_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_GetSubscribeInfoState_001 begin');
      try {
        // 先创建订阅信息、订阅者并订阅
        commonEventModule.createSubscribeInfo();
        commonEventModule.createSubscriber();
        commonEventModule.subscribe();

        const result = commonEventModule.getSubscribeInfoState();
        loggerInfo(`GetSubscribeInfoState result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`GetSubscribeInfoState error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_GetSubscribeInfoState_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_GetSubscriberState_001
      *@tc.name   CustomCommonEvent_GetSubscriberState_001
      *@tc.desc   Test the functionality of getSubscriberState
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_GetSubscriberState_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_GetSubscriberState_001 begin');
      try {
        // 先创建订阅信息、订阅者并订阅
        commonEventModule.createSubscribeInfo();
        commonEventModule.createSubscriber();
        commonEventModule.subscribe();

        const result = commonEventModule.getSubscriberState();
        loggerInfo(`GetSubscriberState result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`GetSubscriberState error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_GetSubscriberState_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_GetSubscribeState_001
      *@tc.name   CustomCommonEvent_GetSubscribeState_001
      *@tc.desc   Test the functionality of getSubscribeState
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_GetSubscribeState_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_GetSubscribeState_001 begin');
      try {
        // 先创建订阅信息、订阅者并订阅
        commonEventModule.createSubscribeInfo();
        commonEventModule.createSubscriber();
        commonEventModule.subscribe();

        const result = commonEventModule.getSubscribeState();
        loggerInfo(`GetSubscribeState result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`GetSubscribeState error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_GetSubscribeState_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_GetPublishedEvents_001
      *@tc.name   CustomCommonEvent_GetPublishedEvents_001
      *@tc.desc   Test the functionality of getPublishedEvents
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_GetPublishedEvents_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_GetPublishedEvents_001 begin');
      try {
        // 先创建订阅信息、订阅者并订阅
        commonEventModule.createSubscribeInfo();
        commonEventModule.createSubscriber();
        commonEventModule.subscribe();
        commonEventModule.publish();

        const result = commonEventModule.getPublishedEvents();
        loggerInfo(`GetPublishedEvents result: ${result}`);
        expect(result[0]).assertEqual("usual.event.TEST");
      } catch (error) {
        loggerError(`GetPublishedEvents error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_GetPublishedEvents_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_ClearAllStates_001
      *@tc.name   CustomCommonEvent_ClearAllStates_001
      *@tc.desc   Test the functionality of clearAllStates
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_ClearAllStates_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_ClearAllStates_001 begin');
      try {
        // 先创建订阅信息、订阅者并订阅
        commonEventModule.createSubscribeInfo();
        commonEventModule.createSubscriber();
        commonEventModule.subscribe();

        const result = commonEventModule.clearAllStates();
        loggerInfo(`ClearAllStates result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`ClearAllStates error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_ClearAllStates_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_DestroyPublishInfo_001
      *@tc.name   CustomCommonEvent_DestroyPublishInfo_001
      *@tc.desc   Test the functionality of destroyPublishInfo
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_DestroyPublishInfo_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_DestroyPublishInfo_001 begin');
      try {
        const result = commonEventModule.destroyPublishInfo();
        loggerInfo(`DestroyPublishInfo result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`DestroyPublishInfo error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_DestroyPublishInfo_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_SetToSubscriber_001
      *@tc.name   CustomCommonEvent_SetToSubscriber_001
      *@tc.desc   Test the functionality of setToSubscriber
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_SetToSubscriber_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_SetToSubscriber_001 begin');
      try {
        const result = commonEventModule.setToSubscriber();
        loggerInfo(`SetToSubscriber result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`SetToSubscriber error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_SetToSubscriber_001 end');
      done();
    });

    /*
      *@tc.number CustomCommonEvent_GetFromSubscriber_001
      *@tc.name   CustomCommonEvent_GetFromSubscriber_001
      *@tc.desc   Test the functionality of getFromSubscriber
      *@tc.size   MediumTest
      *@tc.type   Function
      *@tc.level  Level 0
      */
    it('CustomCommonEvent_GetFromSubscriber_001', 0, async (done: Function) => {
      loggerInfo('CustomCommonEvent_GetFromSubscriber_001 begin');
      try {
        const result = commonEventModule.getFromSubscriber();
        loggerInfo(`GetFromSubscriber result: ${result}`);
        expect(result).assertEqual(true);
      } catch (error) {
        loggerError(`GetFromSubscriber error: ${JSON.stringify(error as BusinessError)}`);
        expect().assertFail();
      }
      loggerInfo('CustomCommonEvent_GetFromSubscriber_001 end');
      done();
    });
  });
}