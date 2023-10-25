/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON } from '@ohos.UiTest';
import Logger from '../util/Logger';
import Want from '@ohos.app.ability.Want';

const BUNDLE = 'Chat';
const TAG = '[Sample_Chat_Test]';
const delegator = AbilityDelegatorRegistry.getAbilityDelegator();
// 设置图片数组的索引值
const imageIndex = 1;

// 资源本地化
async function getResourceString<T extends Resource>(resource: T): Promise<string> {
  let manage = delegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('ActsAbilityTest', () => {

    /**
     * 打开应用
     */
    it(BUNDLE + '_startAbility', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + '_startAbility start')
      let want: Want = {
        bundleName: 'com.samples.chat',
        abilityName: 'EntryAbility'
      }
      delegator.startAbility(want, (err, data) => {
        Logger.info(TAG, 'StartAbility get err ' + JSON.stringify(err))
        expect(err).assertNull()
      })
      Logger.info(TAG, BUNDLE + '_startAbility end')
      done()
    })

    /**
     * 聊天界面测试
     */
    it(BUNDLE + 'SendMessageFunction_001', 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(2000)
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 clickChatList')
      // 点击聊天列表
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.friend'))))
      let chatList = await driver.findComponent(ON.text(await getResourceString($r('app.string.friend'))))
      await chatList.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 inputText')
      // 底部输入框内容
      await driver.assertComponentExist(ON.id('bottomTextInput'))
      let bottomTextInput = await driver.findComponent(ON.id('bottomTextInput'))
      await bottomTextInput.inputText('good')
      let inputValue = await bottomTextInput.getText()
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 inputValue=' + inputValue)
      expect('good').assertEqual(inputValue)
      await driver.triggerKey(2054)
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 clickChatExpression')
      // 点亮表情图标
      await driver.assertComponentExist(ON.id('chatExpression'))
      let chatExpression = await driver.findComponent(ON.id('chatExpression'))
      await chatExpression.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 clickReturnBtn')
      // 点击返回主页
      await driver.assertComponentExist(ON.id('returnBtn'))
      let returnChatListPageBtn = await driver.findComponent(ON.id('returnBtn'))
      await returnChatListPageBtn.click()
      await driver.delayMs(1000)
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 existAddBtn')
      await driver.assertComponentExist(ON.id('addBtn'))
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 end')
      done()
    })

    /**
     * 并发场景测试
     */
    it(BUNDLE + 'TaskPoolFunction_001', 0, async (done: Function) => {
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 begin`);
      let driver = Driver.create();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 clickDiscover`);
      // 点击发现
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.discovery'))));
      let discover = await driver.findComponent(ON.text(await getResourceString($r('app.string.discovery'))));
      await discover.click();
      await driver.delayMs(1000);
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 clickChatCommunity`);
      // 点击朋友圈
      await driver.assertComponentExist(ON.id('chatCommunity'));
      let chatCommunity = await driver.findComponent(ON.id('chatCommunity'));
      await chatCommunity.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.circle'))));
      await driver.delayMs(2000);
      await driver.assertComponentExist(ON.id('userImage'));
      await driver.delayMs(1000);
      // 点击单张图片
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 clickSingleImage`);
      let singleImage = await driver.findComponent(ON.id('singleImage'));
      await singleImage.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('mediaPage'));
      await driver.pressBack();
      await driver.delayMs(1000);
      // 点击多张图片
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 clickMultipleImage`);
      let imageArray = await driver.findComponent(ON.id(`${imageIndex}`));
      await imageArray.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('mediaPage'));
      await driver.assertComponentExist(ON.id('swiperImage'));
      await driver.delayMs(1000);
      await driver.swipe(0, 500, 600, 500, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('swiperImage'));
      await driver.swipe(600, 500, 0, 500, 600);
      await driver.delayMs(1000);
      await driver.swipe(600, 500, 0, 500, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('swiperImage'));
      await driver.swipe(600, 500, 0, 500, 600);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('swiperImage'));
      await driver.pressBack();
      await driver.delayMs(1000);
      // 点击视频
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 clickVideoComponent`);
      let videoComponent = await driver.findComponent(ON.id('videoComponent'));
      await videoComponent.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('mediaPage'));
      await driver.pressBack();
      await driver.delayMs(1000);
      // 滑动页面 循环连续向上滑动10次
      for (let index = 0; index < 10; index++) {
        await driver.swipe(0, 1200, 0, 100, 600);
        await driver.delayMs(1000);
        await driver.assertComponentExist(ON.id('userImage'));
      }
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 backToDiscover`);
      await driver.pressBack();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('chatCommunity'));
      Logger.info(TAG, `${BUNDLE}TaskPoolFunction_001 end`);
      done();
    })
  })
}