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
import { abilityDelegatorRegistry, Component, Driver, ON, } from '@kit.TestKit';

import { dataShare } from '@kit.ArkData';
import { BusinessError } from '@kit.BasicServicesKit';
import { UIAbility, Want } from '@kit.AbilityKit';

let TAG = 'SharedConfigPublishTest ';
const DELAY_TIME = 1500; // delay time 1.5 second

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
const abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();

const newConfigData: dataShare.ProxyData[] = [
  {
    uri: 'datashareproxy://com.samples.shareconfig/config1',
    value: 'Value1',
    allowList: [
      'appIdentifier1',
      'appIdentifier2'
    ]
  },
  {
    uri: 'datashareproxy://com.samples.shareconfig/config2',
    value: 'Value2',
    allowList: [
      'appIdentifier3',
      'appIdentifier4'
    ]
  }
];

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(() => {
      // Presets an action, which is performed only once before all test cases of the test suite start.
      // This API supports only one parameter: preset action function.
    });
    beforeEach(() => {
      // Presets an action, which is performed before each unit test case starts.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: preset action function.
    });
    afterEach(() => {
      // Presets a clear action, which is performed after each unit test case ends.
      // The number of execution times is the same as the number of test cases defined by **it**.
      // This API supports only one parameter: clear action function.
    });
    afterAll(() => {
      // Presets a clear action, which is performed after all test cases of the test suite end.
      // This API supports only one parameter: clear action function.
    });

    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it('StartAbility_001', 0, async (done: Function) => {
      console.info(TAG + 'StartAbility_001 begin');
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };

      await delegator.startAbility(want);
      let driver: Driver = Driver.create();
      await driver.delayMs(DELAY_TIME);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      console.info(TAG + 'get top ability');
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      console.info(TAG + 'StartAbility_001 end');
    });

    /**
     * @tc.number SharedConfigPublishTest001
     * @tc.name SharedConfigPublishTest001
     * @tc.desc 发布指定配置项
     */
    it('SharedConfigPublishTest001', 0, async (done: Function) => {
      console.info(TAG + 'SharedConfigPublishTest001 start');
      let str = await getResourceString($r('app.string.publishSharedConfig'));
      let driver: Driver = Driver.create();
      await driver.assertComponentExist(ON.text(str));
      let button: Component = await driver.findComponent(ON.text(str));
      await button.click();
      await driver.delayMs(DELAY_TIME);
      // publishSharedConfig();

      // get config published before
      let testUri1 = 'datashareproxy://com.samples.shareconfig/config1';
      let urisToGet = [testUri1];
      let config: dataShare.DataProxyConfig = {
        type: dataShare.DataProxyType.SHARED_CONFIG
      };
      let expectedValue = 'Value1';
      let expectedAllowList = [
        'appIdentifier1',
        'appIdentifier2'
      ];
      try {
        dataShare.createDataProxyHandle().then((dataProxyHandle) => {
          dataProxyHandle!.get(urisToGet, config).then(results => {
            expect(results.length).assertEqual(urisToGet.length);
            expect(results[0].uri).assertEqual(testUri1);
            expect(results[0].result).assertEqual(dataShare.DataProxyErrorCode.SUCCESS);
            expect(results[0].value).assertEqual(expectedValue);
            // expect(results[0].allowList).assertEqual(expectedAllowList);
          }).catch((err: BusinessError) => {
            console.error(TAG + 'SharedConfigGetTest001 failed.code =' + err.code + ', message=' + err.message);
            expect().assertFail();
          });
        });
      } catch (err) {
        console.error(TAG + 'SharedConfigGetTest001 failed,code =' + err.code + ',message=' + err.message);
        expect().assertFail();
      }
      done();
      console.info(TAG + 'SharedConfigPublishTest001 end');
    });

    /**
     * @tc.number SharedConfigDeleteTest001
     * @tc.name SharedConfigDeleteTest001
     * @tc.desc 删除配置项
     */
    it('SharedConfigDeleteTest001', 0, async (done: Function) => {
      console.info(TAG + 'SharedConfigDeleteTest001 start');

      let testUri1 = 'datashareproxy://com.samples.shareconfig/config1';
      let urisToGet = [testUri1];
      let config: dataShare.DataProxyConfig = {
        type: dataShare.DataProxyType.SHARED_CONFIG
      };

      try {
        let dataProxyHandle = await dataShare.createDataProxyHandle();
        // publish config at first
        dataProxyHandle.publish(newConfigData, config).then((results: dataShare.DataProxyResult[]) => {
          results.forEach((result) => {
            console.info(`URI: ${result.uri}, Result: ${result.result}`);
          });
        }).catch((error: BusinessError) => {
          console.error('Error publishing config:', error);
        });
        // get button
        let str = await getResourceString($r('app.string.deleteSharedConfig'));
        let driver: Driver = Driver.create();
        await driver.assertComponentExist(ON.text(str));
        let button: Component = await driver.findComponent(ON.text(str));
        // click button and wait
        await button.click();
        await driver.delayMs(DELAY_TIME);

        // get return uri exist
        dataProxyHandle!.get(urisToGet, config).then(results => {
          expect(results.length).assertEqual(urisToGet.length);
          expect(results[0].uri).assertEqual(testUri1);
          expect(results[0].result).assertEqual(dataShare.DataProxyErrorCode.URI_NOT_EXIST);
          expect(results[0].value).assertEqual(undefined);
          expect(results[0].allowList).assertEqual(undefined);
        }).catch((err: BusinessError) => {
          console.error(TAG + 'SharedConfigDeleteTest001 failed.code =' + err.code + ', message=' + err.message);
          expect().assertFail();
        });
      } catch (err) {
        console.error(TAG + 'SharedConfigDeleteTest001 failed,code =' + err.code + ',message=' + err.message);
        expect().assertFail();
      }
      done();
      console.info(TAG + 'SharedConfigDeleteTest001 end');
    });

    /**
     * @tc.number SharedConfigGetTest001
     * @tc.name SharedConfigGetTest001
     * @tc.desc 获取配置项信息
     */
    it('SharedConfigGetTest001', 0, async (done: Function) => {
      console.info(TAG + 'SharedConfigGetTest001 start');

      let testUri1 = 'datashareproxy://com.samples.shareconfig/config1';
      let urisToGet = [testUri1];
      let config: dataShare.DataProxyConfig = {
        type: dataShare.DataProxyType.SHARED_CONFIG
      };

      try {
        let dataProxyHandle = await dataShare.createDataProxyHandle();
        // publish config at first
        dataProxyHandle.publish(newConfigData, config).then((results: dataShare.DataProxyResult[]) => {
          expect(results.length).assertEqual(newConfigData.length);
          expect(results[0].uri).assertEqual(testUri1);
          expect(results[0].result).assertEqual(dataShare.DataProxyErrorCode.SUCCESS);
          results.forEach((result) => {
            console.info(`URI: ${result.uri}, Result: ${result.result}`);
          });
        }).catch((error: BusinessError) => {
          console.error('Error publishing config:', error);
        });

        // get button
        let str = await getResourceString($r('app.string.getSharedConfig'));
        let driver: Driver = Driver.create();
        await driver.assertComponentExist(ON.text(str));
        let button: Component = await driver.findComponent(ON.text(str));
        // click button and wait
        await button.click();
        await driver.delayMs(DELAY_TIME);
      } catch (err) {
        console.error(TAG + 'SharedConfigGetTest001 failed,code =' + err.code + ',message=' + err.message);
        expect().assertFail();
      }
      done();
      console.info(TAG + 'SharedConfigGetTest001 end');
    });

    /**
     * @tc.number WatchSharedConfigChangeTest001
     * @tc.name WatchSharedConfigChangeTest001
     * @tc.desc 监听与取消监听配置变化
     */
    it('WatchSharedConfigChangeTest001', 0, async (done: Function) => {
      console.info(TAG + 'WatchSharedConfigChangeTest001 start');

      let config: dataShare.DataProxyConfig = {
        type: dataShare.DataProxyType.SHARED_CONFIG
      };

      try {
        let dataProxyHandle = await dataShare.createDataProxyHandle();
        // publish config at first
        dataProxyHandle.publish(newConfigData, config).then((results: dataShare.DataProxyResult[]) => {
          results.forEach((result) => {
            console.info(`URI: ${result.uri}, Result: ${result.result}`);
          });
        }).catch((error: BusinessError) => {
          console.error('Error publishing config:', error);
        });
        // get button
        let str = await getResourceString($r('app.string.watchConfigChanges'));
        let driver: Driver = Driver.create();
        await driver.assertComponentExist(ON.text(str));
        let button: Component = await driver.findComponent(ON.text(str));
        // click button and wait
        await button.click();
        await driver.delayMs(DELAY_TIME);
      } catch (err) {
        console.error(TAG + 'WatchSharedConfigChangeTest001 failed,code =' + err.code + ',message=' + err.message);
        expect().assertFail();
      }
      done();
      console.info(TAG + 'WatchSharedConfigChangeTest001 end');
    });
  });
}