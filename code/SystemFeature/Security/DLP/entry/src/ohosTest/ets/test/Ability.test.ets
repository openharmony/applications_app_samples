/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { describe, it, expect, beforeAll } from '@ohos/hypium';
import Logger from './Logger';
import { Driver, ON } from '@ohos.UiTest';
import Want from '@ohos.app.ability.Want';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import inputMethod from '@ohos.inputMethod';
import resourceManager from '@ohos.resourceManager';

const BUNDLE = 'DLP';
const TAG = '[Sample_DLP_TEST]';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();

async function getResourceString<T extends Resource>(resource: T): Promise<string> {
  let manage = delegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {
    beforeAll(async () => {
      let want: Want = {
        bundleName: 'com.samples.dlp',
        abilityName: "EntryAbility"
      }
      await delegator.startAbility(want);
    })
    /**
     * 允许
     */
    it(BUNDLE + 'authorization', 0, async () => {
      Logger.info(TAG, BUNDLE + 'authorization begin')
      let driver = Driver.create();
      await driver.delayMs(5000);
      // 点击聊天列表
      await driver.assertComponentExist(ON.text('允许'));
      let authorizateBtn = await driver.findComponent(ON.text('允许'));
      await driver.delayMs(1000);
      await authorizateBtn.click();
      await driver.delayMs(1000);
    })
    /**
     * 添加普通文件
     */
    it(BUNDLE + 'AddFiles', 0, async () => {
      Logger.info(TAG, BUNDLE + 'AddFiles begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 添加普通文件
      await driver.assertComponentExist(ON.id('newFile'));
      let addBtn = await driver.findComponent(ON.id('newFile'));
      await driver.delayMs(1000);
      await addBtn.click();
      await driver.delayMs(1000);
      let authorizateBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.text_content'))));
      await driver.delayMs(1000);
      if(authorizateBtn) {
        await authorizateBtn.click();
        await driver.delayMs(1000);
      }
      let authorizateBtn2 = await driver.findComponent(ON.text(await getResourceString($r('app.string.text_content'))));
      await driver.delayMs(1000);
      if(authorizateBtn2) {
        await authorizateBtn2.click();
        await driver.delayMs(1000);
      }
      let timestamp = new Date().getTime();
      let textInput = await driver.findComponent(ON.type('TextInput'));
      await driver.delayMs(1000);
      await textInput.inputText(`xxx合同${timestamp}.txt`);
      await driver.delayMs(1000);
      let inputMethodController = inputMethod.getController();
      inputMethodController.hideTextInput();
      await driver.delayMs(1000);
      let ImageArray = await driver.findComponents(ON.type('Image'));
      Logger.info(TAG, `ImageArray lenth:${ImageArray.length}`);
      let finishBtn = ImageArray[2];
      await finishBtn.click();
      Logger.info(TAG, BUNDLE + 'AddFiles end');
    })
    /**
     * 加密操作
     */
    it(BUNDLE + 'AddOrdinaryFiles', 0, async () => {
      Logger.info(TAG, BUNDLE + 'AddOrdinaryFiles begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击聊天列表
      await driver.assertComponentExist(ON.id('fileItem'));
      let fileItem = await driver.findComponent(ON.id('fileItem'));
      await driver.delayMs(1000);
      await fileItem.longClick();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('encryption'));
      let encryptionBtn = await driver.findComponent(ON.id('encryption'));
      await driver.delayMs(1000);
      await encryptionBtn.click();
      await driver.delayMs(1000);
      // 设置编辑权限
      let selectBtn = await driver.findComponent(ON.text('请选择权限'));
      await selectBtn.click();
      await driver.delayMs(1000);
      let editBtn = await driver.findComponent(ON.text('编辑'));
      await editBtn.click();
      await driver.delayMs(1000);
      let confirm = await driver.findComponent(ON.text('确定'));
      await driver.delayMs(1000);
      await confirm.click();
      await driver.delayMs(1000);
    })
    /**
     * 保存
     */
    it(BUNDLE + 'SaveContent', 0, async () => {
      Logger.info(TAG, BUNDLE + 'SaveContent begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击进入编辑页面
      let authorizateBtn = await driver.findComponent(ON.text(await getResourceString($r('app.string.text_content'))));
      await driver.delayMs(1000);
      if (authorizateBtn) {
        authorizateBtn.click();
        await driver.delayMs(1000);
      }
      let fileItem = await driver.findComponent(ON.id('fileItem'));
      await fileItem.click();
      await driver.delayMs(3000);
      let webBtn = await driver.findComponent(ON.id('webComponent'));
      await driver.delayMs(1000);
      await webBtn.click();
      await webBtn.inputText('hello');
      await driver.delayMs(3000);
      // 点击保存
      let saveBtn = await driver.findComponent(ON.id('saveBtn'));
      await saveBtn.click();
      await driver.delayMs(1000);
      // 返回Home页面
      let want: Want = {
        bundleName: 'com.samples.dlp',
        abilityName: "EntryAbility"
      }
      await delegator.startAbility(want);
      Logger.info(TAG, BUNDLE + 'SaveContent end');
    })
    /**
     * 只读权限
     */
    it(BUNDLE + 'OnlyRead', 0, async () => {
      Logger.info(TAG, BUNDLE + 'OnlyRead begin');
      let driver = Driver.create();
      await driver.delayMs(3000);
      // 点击进入编辑页面
      let fileItem = await driver.findComponent(ON.id('fileItem'));
      await fileItem.longClick();
      await driver.delayMs(1000);
      let encryptionBtn = await driver.findComponent(ON.id('encryption'));
      await driver.delayMs(1000);
      await encryptionBtn.click();
      await driver.delayMs(1000);
      let file = await driver.findComponent(ON.id('fileItem'));
      await driver.delayMs(1000);
      await file.longClick();
      await driver.delayMs(1000);
      let encryption = await driver.findComponent(ON.id('encryption'));
      await encryption.click();
      await driver.delayMs(1000);
      // 设置只读权限
      let selectBtn = await driver.findComponent(ON.text('请选择权限'));
      await selectBtn.click();
      await driver.delayMs(1000);
      let readBtn = await driver.findComponent(ON.text('只读'));
      await readBtn.click();
      await driver.delayMs(1000);
      let confirm = await driver.findComponent(ON.text('确定'));
      await driver.delayMs(1000);
      await confirm.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'OnlyRead end');
    })
    /**
     * 验证只读权限
     */
    it(BUNDLE + 'CheckOnlyRead', 0, async () => {
      Logger.info(TAG, BUNDLE + 'CheckOnlyRead begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 点击进入编辑页面
      let fileItem = await driver.findComponent(ON.id('fileItem'));
      await fileItem.click();
      await driver.delayMs(1000);
      Logger.info(TAG, BUNDLE + 'CheckOnlyRead end');
    })
  })
}