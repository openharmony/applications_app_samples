/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { UiDriver, BY, UiComponent, MatchPattern } from '@ohos.uitest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Chat]'
const DOMAIN = 0xF811
const BUNDLE = 'Chat_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.chat",
          abilityName: "ohos.samples.chat.MainAbility"
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })
    /**
     * 点击进入聊天信息页面
     */
    it(BUNDLE + 'EnterChatNewsFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickChatList')
      // 点击聊天列表
      await driver.assertComponentExist(BY.text('朋友0', MatchPattern.CONTAINS))
      let chatList = await driver.findComponent(BY.text('朋友0', MatchPattern.CONTAINS))
      await chatList.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickMoreBtn')
      // 点击更多
      await driver.assertComponentExist(BY.key('moreBtn'))
      let moreBtn = await driver.findComponent(BY.key('moreBtn'))
      await moreBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickLeftBtn')
      // 点击返回聊天内容页
      await driver.assertComponentExist(BY.key('leftBtn'))
      let leftBtn = await driver.findComponent(BY.key('leftBtn'))
      await leftBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickReturnBtn')
      // 点击返回主页
      await driver.assertComponentExist(BY.key('returnBtn'))
      let returnChatListPageBtn = await driver.findComponent(BY.key('returnBtn'))
      await returnChatListPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 existAddBtn')
      await driver.assertComponentExist(BY.key('addBtn'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 end')
    })
    /**
     * 点击搜索进入搜索页面
     */
    it(BUNDLE + 'ClickSearchFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickSearch')
      // 点击搜索
      await driver.assertComponentExist(BY.key('search'))
      let searchBtn = await driver.findComponent(BY.key('search'))
      await searchBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickCancelSearch')
      // 点击取消
      await driver.assertComponentExist(BY.key('cancelSearchBtn'))
      let cancelSearchBtn = await driver.findComponent(BY.key('cancelSearchBtn'))
      await cancelSearchBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 end')
    })
    /**
     * 点击添加按钮进入添加好友和发起群聊页面
     */
    it(BUNDLE + 'ClickAddFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001　begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddBtn')
      // 点击添加按钮
      await driver.assertComponentExist(BY.key('addBtn'))
      let btnAdd = await driver.findComponent(BY.key('addBtn'))
      await btnAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddFriend')
      // 点击添加好友
      await driver.assertComponentExist(BY.text('添加好友', MatchPattern.CONTAINS))
      let addFriend = await driver.findComponent(BY.text('添加好友', MatchPattern.CONTAINS))
      await addFriend.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickLeftAddFriendPageBtn')
      // 点击返回
      await driver.assertComponentExist(BY.key('leftAddFriendPageBtn'))
      let leftAddFriendPageBtn = await driver.findComponent(BY.key('leftAddFriendPageBtn'))
      await leftAddFriendPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddBtn')
      // 点击添加按钮
      await btnAdd.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickGroupChat')
      // 点击发起群聊
      await driver.delayMs(1000)
      await driver.assertComponentExist(BY.text('发起群聊', MatchPattern.CONTAINS))
      let groupChat = await driver.findComponent(BY.text('发起群聊', MatchPattern.CONTAINS))
      await groupChat.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickLeftCurrentPage')
      // 点击返回
      await driver.assertComponentExist(BY.key('leftCurrentPageBtn'))
      let leftCurrentPageBtn = await driver.findComponent(BY.key('leftCurrentPageBtn'))
      await leftCurrentPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 end')
    })
    /**
     * 点击进入聊天内容页输入信息和发送表情
     */
    it(BUNDLE + 'SendMessageFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001　begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 clickChatList')
      // 点击聊天列表
      await driver.assertComponentExist(BY.text('朋友0', MatchPattern.CONTAINS))
      let chatList = await driver.findComponent(BY.text('朋友0', MatchPattern.CONTAINS))
      await chatList.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 inputText')
      // 底部输入框输入内容
      await driver.assertComponentExist(BY.key('bottomTextInput'))
      let bottomTextInput = await driver.findComponent(BY.key('bottomTextInput'))
      await bottomTextInput.inputText('good')
      let inputValue = await bottomTextInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 inputValue')
      expect('good').assertEqual(inputValue)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 clickChatExpression')
      // 点击表情图标
      await driver.assertComponentExist(BY.key('chatExpression'))
      let chatExpression = await driver.findComponent(BY.key('chatExpression'))
      await chatExpression.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 clickReturnBtn')
      // 点击返回主页
      await driver.assertComponentExist(BY.key('returnBtn'))
      let returnChatListPageBtn = await driver.findComponent(BY.key('returnBtn'))
      await returnChatListPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 existAddBtn')
      await driver.assertComponentExist(BY.key('addBtn'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 end')
    })
  })
}