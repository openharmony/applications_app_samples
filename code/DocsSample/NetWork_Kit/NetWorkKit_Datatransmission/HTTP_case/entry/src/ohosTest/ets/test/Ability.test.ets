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

import { describe, it } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import { ComponentId } from '../../../main/ets/common/CommonConstant';
import Logger from '../../../main/ets/common/Logger';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();

const BUNDLE = 'HTTPCASE_';
const BUNDLE_NAME = 'com.samples.http_case';
const ABILITY_NAME: string = 'EntryAbility';
const DELAY_MS = 3000;
let driver: Driver = Driver.create();

export default function AbilityTest() {
  describe('AbilityTest', () => {
    /**
     * @tc.number StartAbility_001
     * @tc.name StartAbility_001
     * @tc.desc 启动Ability
     */
    it(BUNDLE + 'StartAbility_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE}StartAbility_001 begin`);
      const want: Want = {
        bundleName: BUNDLE_NAME,
        abilityName: ABILITY_NAME
      };
      await delegator.startAbility(want);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_TITLE));
      await driver.delayMs(DELAY_MS);
      done();
      Logger.info(`${BUNDLE}StartAbility_001 end`);
    })

    /**
     * @tc.number Http_case_001
     * @tc.name Http_case_001
     * @tc.desc 测试 发送HTTP请求 按钮
     */
    it(BUNDLE + 'Http_case_001', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME} Http_case_001 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_BUTTON));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_BUTTON));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_001 end`);
      done();
    });

    /**
     * @tc.number Http_case_002
     * @tc.name Http_case_002
     * @tc.desc 测试 发送流式 HTTP 请求 按钮
     */
    it(BUNDLE + 'Http_case_002', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_002 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.STREAM_HTTP_BUTTON));
      let stack = await driver.findComponent(ON.id(ComponentId.STREAM_HTTP_BUTTON));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_002 end`);
      done();
    })

    /**
     * @tc.number Http_case_003
     * @tc.name Http_case_003
     * @tc.desc 测试 HTTP 扩展 WEBDAV 上传请求 按钮
     */
    it(BUNDLE + 'Http_case_003', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_003 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_BUTTON));
      let button = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_BUTTON));
      await button.click();
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_PUT));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_PUT));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_003 end`);
      done();
    })

    /**
     * @tc.number Http_case_004
     * @tc.name Http_case_004
     * @tc.desc 测试 HTTP 扩展 WEBDAV 获取请求 按钮
     */
    it(BUNDLE + 'Http_case_004', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_004 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_GET));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_GET));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_004 end`);
      done();
    })

    /**
     * @tc.number Http_case_005
     * @tc.name Http_case_005
     * @tc.desc 测试 HTTP 扩展 WEBDAV 创建请求 按钮
     */
    it(BUNDLE + 'Http_case_005', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_005 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_MKCOL));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_MKCOL));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_005 end`);
      done();
    })

    /**
     * @tc.number Http_case_006
     * @tc.name Http_case_006
     * @tc.desc 测试 HTTP 扩展 WEBDAV 删除请求 按钮
     */
    it(BUNDLE + 'Http_case_006', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_006 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_DELETE));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_DELETE));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_006 end`);
      done();
    })

    /**
     * @tc.number Http_case_007
     * @tc.name Http_case_007
     * @tc.desc 测试 HTTP 扩展 WEBDAV 拷贝请求 按钮
     */
    it(BUNDLE + 'Http_case_007', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_007 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_COPY));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_COPY));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_007 end`);
      done();
    })

    /**
     * @tc.number Http_case_008
     * @tc.name Http_case_008
     * @tc.desc 测试 HTTP 扩展 WEBDAV 移动请求 按钮
     */
    it(BUNDLE + 'Http_case_008', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_008 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_MOVE));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_MOVE));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_008 end`);
      done();
    })

    /**
     * @tc.number Http_case_009
     * @tc.name Http_case_009
     * @tc.desc 测试 HTTP 扩展 WEBDAV 修改资源请求 按钮
     */
    it(BUNDLE + 'Http_case_009', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_009 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_PROPPATCH));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_PROPPATCH));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_009 end`);
      done();
    })

    /**
     * @tc.number Http_case_010
     * @tc.name Http_case_010
     * @tc.desc 测试 HTTP 扩展 WEBDAV 查找资源请求 按钮
     */
    it(BUNDLE + 'Http_case_010', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_010 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_PROPFIND));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_PROPFIND));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_010 end`);
      done();
    })

    /**
     * @tc.number Http_case_011
     * @tc.name Http_case_011
     * @tc.desc 测试 HTTP 扩展 WEBDAV 加锁请求 按钮
     */
    it(BUNDLE + 'Http_case_011', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_011 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_LOCK));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_LOCK));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_011 end`);
      done();
    })

    /**
     * @tc.number Http_case_012
     * @tc.name Http_case_012
     * @tc.desc 测试 HTTP 扩展 WEBDAV 解锁请求 按钮
     */
    it(BUNDLE + 'Http_case_012', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_012 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_UNLOCK));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_UNLOCK));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_012 end`);
      done();
    })

    /**
     * @tc.number Http_case_013
     * @tc.name Http_case_013
     * @tc.desc 测试 非 HTTP 扩展 WEBDAV 请求方式 按钮
     */
    it(BUNDLE + 'Http_case_013', 0, async (done: Function) => {
      Logger.info(`${BUNDLE_NAME}Http_case_013 begin`);
      await driver.delayMs(DELAY_MS);
      await driver.assertComponentExist(ON.id(ComponentId.HTTP_WEBDAV_UNKNOWN));
      let stack = await driver.findComponent(ON.id(ComponentId.HTTP_WEBDAV_UNKNOWN));
      await stack.click();
      await driver.delayMs(DELAY_MS);
      Logger.info(`${BUNDLE_NAME}Http_case_013 end`);
      done();
    })
  })
}