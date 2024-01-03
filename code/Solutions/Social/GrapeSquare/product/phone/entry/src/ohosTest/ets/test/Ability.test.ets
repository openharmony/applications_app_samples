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

import { describe,  it, expect, beforeAll } from '@ohos/hypium';
import Logger from './Logger'
import { Driver, ON } from '@ohos.UiTest'
import Want from '@ohos.app.ability.Want';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

const BUNDLE = 'Weibo';
const TAG = '[Sample_Weibo_Test]';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const DELAY_TIME = 1000;

async function getResourceString<T extends Resource>(resource: T): Promise<string> {
  let manage = delegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  let driver = Driver.create();
  describe('ActsAbilityTest', () => {
    beforeAll(async ()=>{
      let want: Want = {
        bundleName : 'com.samples.grapesquare',
        abilityName : "EntryAbility"
      }
      await delegator.startAbility(want);
    })

    it("pass_advertisment", 0,async ()=> {
      await driver.delayMs(DELAY_TIME);
      Logger.info(TAG,BUNDLE + 'pass_advertisment begin');
      await driver.assertComponentExist(ON.id('skip'));
      let passButton = await driver.findComponent(ON.id('skip'));
      await passButton.click();
      Logger.info(TAG,BUNDLE + 'pass_advertisment end');
    })

    //保存图片到媒体库
    it("Save_001", 0, async (done: Function) => {
      Logger.info(TAG, BUNDLE + 'Save_001 begin');
      //点击进入微博展示页
      await driver.assertComponentExist(ON.id('textDetail'))
      let viewList = await driver.findComponent(ON.id('textDetail'))
      await driver.delayMs(500);
      await viewList.click()
      Logger.info(TAG, BUNDLE + 'Save_001 displayDetails')
      //长按图片保存
      await driver.delayMs(DELAY_TIME)
      await driver.assertComponentExist(ON.type('Image').isAfter(ON.id('textDetail')))
      let imageButton = await driver.findComponent(ON.type('Image').isAfter(ON.id('textDetail')))
      await driver.delayMs(500);
      await imageButton.longClick()
      //点击保存按钮
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.save'))));
      let saveButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.save'))));
      await driver.delayMs(500);
      await saveButton.click()
      Logger.info(TAG, BUNDLE + 'Save_001 imageSaveSuccess')
      await driver.delayMs(DELAY_TIME)
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.known'))));
      let know = await driver.findComponent(ON.text(await getResourceString($r('app.string.known'))));
      await know.click();
      //返回
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      Logger.info( TAG,  BUNDLE + 'Save_001 end');
      await driver.delayMs(DELAY_TIME)
      done()
    })


    //获取剪贴板内容
    it("GetPasteContent_001", 0, async (done: Function) => {
      await driver.delayMs(500);
      Logger.info(TAG, BUNDLE + 'GetPasteContent_001 begin')
      //点击进入微博展示页
      await driver.assertComponentExist(ON.id('textDetail'))
      let viewList = await driver.findComponent(ON.id('textDetail'))
      await viewList.click()
      Logger.info(TAG, BUNDLE + 'GetPasteContent_001 displayDetails')
      //点击评论按钮
      let paste = await driver.findComponent(ON.id('commentButton').text(await getResourceString($r('app.string.comment'))));
      await driver.delayMs(500);
      await paste.click();
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 addComment')
      //点击输入框，调起输入法
      let textInput = await driver.findComponent(ON.id('comment_add'))
      await textInput.click()
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 inputText')
      //在输入框输入example
      await textInput.inputText('example')
      let inputValue = await textInput.getText()
      Logger.info(TAG, BUNDLE + 'InputMessageFunction_001 inputValue=' + inputValue)
      //长按输入框调起复制
      await textInput.click()
      await textInput.longClick()
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.copy'))));
      let copyButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.copy'))));
      await copyButton.click()
      Logger.info(TAG, BUNDLE + 'SendMessageFunction_001 copySuccess')
      //长按输入框调起粘贴
      await textInput.longClick()
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.paste'))));
      let pasteButton = await driver.findComponent(ON.text(await getResourceString($r('app.string.paste'))));
      await pasteButton.click()
      await driver.delayMs(DELAY_TIME)
      let pasteValue = await textInput.getText()
      Logger.info(TAG, BUNDLE + 'pasteMessageFunction_001 inputValue=' + pasteValue)
      Logger.info(TAG, BUNDLE + 'PasteMessageFunction_001 pasteSuccess')
      //返回
      let backBtn = await driver.findComponent(ON.id('backBtn'));
      await backBtn.click();
      Logger.info( TAG,  BUNDLE + 'Save_001 end');
      done()
    })

    //获取定位信息
    it("GetLocation_001", 0, async (done: Function) => {
      await driver.delayMs(DELAY_TIME)
      Logger.info(TAG, BUNDLE + 'GetLocation_001 begin')
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.discover'))));
      let square = await driver.findComponent(ON.text(await getResourceString($r('app.string.discover'))));
      await square.click()
      Logger.info(TAG,BUNDLE + 'GetLocation_001 squareView')
      //点击"同城"获取定位信息
      await driver.assertComponentExist(ON.type('LocationButton'))
      Logger.info(TAG, BUNDLE + 'GetLocation_001 begin')
      let location = await driver.findComponent(ON.type('LocationButton'))
      await location.click()
      Logger.info(TAG,BUNDLE + 'GetLocation_001 clickLocationButton')
      // 点击确定
      await driver.delayMs(DELAY_TIME)
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.known'))));
      let Button = await driver.findComponent(ON.text(await getResourceString($r('app.string.known'))));
      await Button.click();
      //获取定位城市信息
      await driver.assertComponentExist(ON.id('locationDisplay'))
      let locationValue = await driver.findComponent(ON.id('locationDisplay'))
      let locationCity =await locationValue.getText()
      await driver.delayMs(500);
      Logger.info(TAG, BUNDLE + 'GetLocation_001 inputValue=' + locationCity)
      // 返回
      let backBtn = await driver.findComponent(ON.id('locationbackBtn'))
      await backBtn.click()
      done()
    })
  })
}