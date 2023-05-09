/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required ON applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import featureAbility from '@ohos.ability.featureAbility'
import hilog from '@ohos.hilog'

const TAG = '[Sample_Chat]'
const DOMAIN = 0xF811
const BUNDLE = 'Chat_'

export default function abilityTest() {
  describe('ActsAbilityTest', function () {
    /**
     * 打开应用
     */
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin')
      let parameter = {
        'want': {
          bundleName: 'ohos.samples.chat',
          abilityName: 'ohos.samples.chat.MainAbility'
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001,err.code:' + JSON.stringify(err.code))
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end')
      })
    })

    /**
     * 点击进入聊天信息页面
     */
    it(BUNDLE + 'EnterChatNewsFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickChatList')
      // 点击聊天列表
      await driver.assertComponentExist(ON.text('朋友0', MatchPattern.CONTAINS))
      let chatList = await driver.findComponent(ON.text('朋友0', MatchPattern.CONTAINS))
      await chatList.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickMoreBtn')
      // 点击更多
      await driver.assertComponentExist(ON.id('moreBtn'))
      let moreBtn = await driver.findComponent(ON.id('moreBtn'))
      await moreBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickLeftBtn')
      // 点击返回聊天内容页
      await driver.assertComponentExist(ON.id('leftBtn'))
      let leftBtn = await driver.findComponent(ON.id('leftBtn'))
      await leftBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 clickReturnBtn')
      // 点击返回主页
      await driver.assertComponentExist(ON.id('returnBtn'))
      let returnChatListPageBtn = await driver.findComponent(ON.id('returnBtn'))
      await returnChatListPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 existAddBtn')
      await driver.assertComponentExist(ON.id('addBtn'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'EnterChatNewsFunction_001 end')
    })

    /**
     * 点击搜索进入搜索页面
     */
    it(BUNDLE + 'ClickSearchFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickSearch')
      // 点击搜索
      await driver.assertComponentExist(ON.id('search'))
      let searchBtn = await driver.findComponent(ON.id('search'))
      await searchBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 clickCancelSearch')
      // 点击取消
      await driver.assertComponentExist(ON.id('cancelSearchBtn'))
      let cancelSearchBtn = await driver.findComponent(ON.id('cancelSearchBtn'))
      await cancelSearchBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSearchFunction_001 end')
    })

    /**
     * 点击添加按钮进入添加好友和发起群聊页面
     */
    it(BUNDLE + 'ClickAddFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001　begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddBtn')
      // 点击添加按钮
      await driver.assertComponentExist(ON.id('addBtn'))
      let btnAdd = await driver.findComponent(ON.id('addBtn'))
      await btnAdd.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddFriend')
      // 点击添加好友
      await driver.assertComponentExist(ON.text('添加好友', MatchPattern.CONTAINS))
      let addFriend = await driver.findComponent(ON.text('添加好友', MatchPattern.CONTAINS))
      await addFriend.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickLeftAddFriendPageBtn')
      // 点击返回
      await driver.assertComponentExist(ON.id('leftAddFriendPageBtn'))
      let leftAddFriendPageBtn = await driver.findComponent(ON.id('leftAddFriendPageBtn'))
      await leftAddFriendPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickAddBtn')
      // 点击添加按钮
      await btnAdd.click()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickGroupChat')
      // 点击发起群聊
      await driver.delayMs(1000)
      await driver.assertComponentExist(ON.text('发起群聊', MatchPattern.CONTAINS))
      let groupChat = await driver.findComponent(ON.text('发起群聊', MatchPattern.CONTAINS))
      await groupChat.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 clickLeftCurrentPage')
      // 点击返回
      await driver.assertComponentExist(ON.id('leftCurrentPageBtn'))
      let leftCurrentPageBtn = await driver.findComponent(ON.id('leftCurrentPageBtn'))
      await leftCurrentPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAddFunction_001 end')
    })

    /**
     * 点击进入聊天内容页输入信息和发送表情
     */
    it(BUNDLE + 'SendMessageFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001　begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 clickChatList')
      // 点击聊天列表
      await driver.assertComponentExist(ON.text('朋友0', MatchPattern.CONTAINS))
      let chatList = await driver.findComponent(ON.text('朋友0', MatchPattern.CONTAINS))
      await chatList.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 inputText')
      // 底部输入框输入内容
      await driver.assertComponentExist(ON.id('bottomTextInput'))
      let bottomTextInput = await driver.findComponent(ON.id('bottomTextInput'))
      await bottomTextInput.inputText('good')
      let inputValue = await bottomTextInput.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 inputValue=' + inputValue)
      expect('good').assertEqual(inputValue)
      await driver.triggerKey(2054)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 clickChatExpression')
      // 点击表情图标
      await driver.assertComponentExist(ON.id('chatExpression'))
      let chatExpression = await driver.findComponent(ON.id('chatExpression'))
      await chatExpression.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 clickReturnBtn')
      // 点击返回主页
      await driver.assertComponentExist(ON.id('returnBtn'))
      let returnChatListPageBtn = await driver.findComponent(ON.id('returnBtn'))
      await returnChatListPageBtn.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 existAddBtn')
      await driver.assertComponentExist(ON.id('addBtn'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'SendMessageFunction_001 end')
    })

    /**
     * 点击发现进入聊天社区
     */
    it(BUNDLE + 'ChatCommunityFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001　begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击发现
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001 clickDiscover')
      await driver.assertComponentExist(ON.text('发现'))
      let discover = await driver.findComponent(ON.text('发现'))
      await discover.click()
      await driver.delayMs(1000)
      // 点击聊天社区
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001 clickChatCommunity')
      await driver.assertComponentExist(ON.id('chatCommunity'))
      let chatCommunity = await driver.findComponent(ON.id('chatCommunity'))
      await chatCommunity.click()
      await driver.delayMs(1000)
      // 点击图片
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001 clickImageList')
      await driver.assertComponentExist(ON.id('3'))
      let imageList = await driver.findComponent(ON.id('3'))
      await imageList.click()
      await driver.delayMs(1000)
      // 捏合图片
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001 pinchImage')
      await driver.assertComponentExist(ON.id('pinchImage'))
      let pinchImage = await driver.findComponent(ON.id('pinchImage'))
      await pinchImage.pinchOut(1.5)
      await driver.delayMs(1000)
      await pinchImage.pinchIn(0.5)
      await driver.delayMs(1000)
      // 返回到聊天社区页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001 backToChatCommunity')
      await driver.pressBack()
      await driver.assertComponentExist(ON.id('1'))
      // 返回到发现页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001 backToDiscover')
      await driver.pressBack()
      await driver.assertComponentExist(ON.id('chatCommunity'))
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChatCommunityFunction_001 end')
    })

    /**
     * 点击我进入页面
     */
    it(BUNDLE + 'MyPageFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001　begin')
      let driver = await Driver.create()
      await driver.delayMs(1000)
      // 点击我
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 clickMine')
      await driver.assertComponentExist(ON.text('我'))
      let mine = await driver.findComponent(ON.text('我'))
      await mine.click()
      await driver.delayMs(1000)
      // 点击自己查看信息
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 clickMineMessage')
      await driver.assertComponentExist(ON.id('mineMessage'))
      let mineMessage = await driver.findComponent(ON.id('mineMessage'))
      await mineMessage.click()
      await driver.delayMs(1000)
      // 返回到我页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 backToMine')
      await driver.pressBack()
      await driver.assertComponentExist(ON.id('mineMessage'))
      // 点击设置
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 clickSetting')
      await driver.assertComponentExist(ON.id('setting'))
      let setting = await driver.findComponent(ON.id('setting'))
      await setting.click()
      await driver.delayMs(1000)
      // 点击负载开关
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 clickLoadSwitch')
      await driver.assertComponentExist(ON.id('loadSwitch'))
      let loadSwitch = await driver.findComponent(ON.id('loadSwitch'))
      await loadSwitch.click()
      await driver.delayMs(1000)
      // 点击启动加载5000类
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 clickFirstSwitch')
      await driver.assertComponentExist(ON.id('firstSwitch'))
      let firstSwitch = await driver.findComponent(ON.id('firstSwitch'))
      await firstSwitch.click()
      await driver.delayMs(1000)
      // 返回到设置页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 backToSetting')
      await driver.pressBack()
      await driver.assertComponentExist(ON.id('loadSwitch'))
      // 返回到我页面
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 backToMine')
      await driver.pressBack()
      await driver.assertComponentExist(ON.id('setting'))
      // 返回到桌面
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 backToHome')
      await driver.pressBack()
      await driver.delayMs(2000)
      // 再次进入应用查看负载情况
      let parameter = {
        'want': {
          bundleName: 'ohos.samples.chat',
          abilityName: 'ohos.samples.chat.MainAbility'
        }
      }
      featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 enterAgain, err.code:' + JSON.stringify(err.code))
        expect(0).assertEqual(err.code)
        hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 enterAgain end')
      })
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 clickMineAgain')
      await mine.click()
      await driver.delayMs(1000)
      await setting.click()
      await driver.delayMs(1000)
      await loadSwitch.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MyPageFunction_001 end')
    })
  })
}