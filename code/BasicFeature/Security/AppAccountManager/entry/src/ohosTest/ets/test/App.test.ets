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
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_AppAccountManager]'
const DOMAIN = 0xF811
const BUNDLE = 'AppAccountManager_'

let driver: Driver = Driver.create()
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}
//通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text: string) {
  let atom = text
  await driver.assertComponentExist(ON.id(atom))
  let button = await driver.findComponent(ON.id(atom))
  await button.click()
  await driver.delayMs(1000)
}

// 登录账号
async function applicationLogin(username: string, usernameValue: string, password: string, passwordValue: string) {
  // 填写用户名
  let loginUserName = username
  let loginUsernameValue = usernameValue
  await driver.assertComponentExist(ON.id(loginUserName))
  let usernameInput = await driver.findComponent(ON.id(loginUserName))
  await usernameInput.inputText(loginUsernameValue)
  // 填写密码
  let loginPassword = password
  let loginPasswordValue = passwordValue
  await driver.assertComponentExist(ON.id(loginPassword))
  let passwordInput = await driver.findComponent(ON.id(loginPassword))
  await passwordInput.inputText(loginPasswordValue)
}

// 点击确认
async function confirmCheck() {
  // await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.confirm'))))
  // let button = await driver.findComponent(ON.text(await getResourceString($r('app.string.confirm'))))
  await driver.assertComponentExist(ON.text('确认'))
  let button = await driver.findComponent(ON.text('确认'))
  await button.click()
  await driver.delayMs(1000)
}

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      try {
        await abilityDelegator.startAbility({
          bundleName: "ohos.samples.etsappaccountmanager",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
    })

    it(BUNDLE + 'ClickMusicFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMusicFunction_001 begin')
      await driver.delayMs(1000)
      // 进入到音乐
      await checkButtonAndClickWithID('MusicApp')
      // 点击注册
      await checkButtonAndClickWithID('register')
      // 注册信息
      // 填写用户名
      await driver.assertComponentExist(ON.id('Register1'))
      let usernameInput = await driver.findComponent(ON.id('Register1'))
      await usernameInput.inputText('testName_Music')
      // 填写邮箱
      await driver.assertComponentExist(ON.id('Register2'))
      let emailInput = await driver.findComponent(ON.id('Register2'))
      await emailInput.inputText('123456@qq.com')
      let emailValue = await emailInput.getText()
      hilog.info(DOMAIN,TAG,`emailValue:${emailValue}`)
      // 填写个性签名
      await driver.assertComponentExist(ON.id('Register3'))
      let signInput = await driver.findComponent(ON.id('Register3'))
      await signInput.inputText('testMusic')
      // 输入密码
      await driver.assertComponentExist(ON.id('Register4'))
      let passwordInput = await driver.findComponent(ON.id('Register4'))
      await passwordInput.inputText('123456')
      // 确认密码
      await driver.assertComponentExist(ON.id('Register5'))
      let confirmPasswordInput = await driver.findComponent(ON.id('Register5'))
      await confirmPasswordInput.inputText('123456')
      // 点击设置完成
      await checkButtonAndClickWithID('complete')
      // 点击弹窗关闭
      let registerClose = await driver.findComponent(ON.type('AlertDialog'))
      await registerClose.click()
      await driver.delayMs(3000)
      // 输入账号密码
      await applicationLogin('nameInput', 'testName_Music', 'passwordInput', '123456')
      // // 点击登录
      await checkButtonAndClickWithID('login')
      // 点击修改信息
      await checkButtonAndClickWithID('modify')
      // 修改信息
      // 填写邮箱
      await driver.assertComponentExist(ON.id('Modify1'))
      let modifyEmailInput = await driver.findComponent(ON.id('Modify1'))
      await modifyEmailInput.inputText('123456789@qq.com')
      // 填写个性签名
      await driver.assertComponentExist(ON.id('Modify2'))
      let modifySignInput = await driver.findComponent(ON.id('Modify2'))
      await modifySignInput.inputText('test Music')
      // 填写密码
      await driver.assertComponentExist(ON.id('Modify3'))
      let modifyPasswordInput = await driver.findComponent(ON.id('Modify3'))
      await modifyPasswordInput.inputText('123456789')
      // 确认密码
      await driver.assertComponentExist(ON.id('Modify4'))
      let modifyConfirmPasswordInput = await driver.findComponent(ON.id('Modify4'))
      await modifyConfirmPasswordInput.inputText('123456789')
      // 点击设置完成
      await checkButtonAndClickWithID('modComplete')
      // 点击弹窗关闭
      let modifyRegisterClose = await driver.findComponent(ON.type('AlertDialog'))
      await modifyRegisterClose.click()
      // 点击切换应用
      await checkButtonAndClickWithID('application')
      // 点击确定
      await confirmCheck()
      // 使用修改后的账号再次进入音乐应用，测试删除账号
      await checkButtonAndClickWithID('MusicApp')
      await applicationLogin('nameInput', 'testName_Music', 'passwordInput', '123456789')
      await checkButtonAndClickWithID('login')
      // 点击删除
      await checkButtonAndClickWithID('delete')
      // 点击确定
      await confirmCheck()
      // 点击返回
      await checkButtonAndClickWithID('back')
      // 点击确定
      await confirmCheck()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMusicFunction_001 end')
    })

    it(BUNDLE + 'ClickVideoFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickVideoFunction_001 begin')
      let driver: Driver = Driver.create()
      await driver.delayMs(1000)
      // 进入到视频
      await checkButtonAndClickWithID('VideoApp')
      // 点击注册
      await checkButtonAndClickWithID('register')
      // 注册信息
      // 填写用户名
      await driver.assertComponentExist(ON.id('Register1'))
      let usernameInput = await driver.findComponent(ON.id('Register1'))
      await usernameInput.inputText('testName_Video')
      // 填写邮箱
      await driver.assertComponentExist(ON.id('Register2'))
      let emailInput = await driver.findComponent(ON.id('Register2'))
      await emailInput.inputText('123456@qq.com')
      // 填写个性签名
      await driver.assertComponentExist(ON.id('Register3'))
      let signInput = await driver.findComponent(ON.id('Register3'))
      await signInput.inputText('testVideo')
      // 输入密码
      await driver.assertComponentExist(ON.id('Register4'))
      let passwordInput = await driver.findComponent(ON.id('Register4'))
      await passwordInput.inputText('123456')
      // 确认密码
      await driver.assertComponentExist(ON.id('Register5'))
      let confirmPasswordInput = await driver.findComponent(ON.id('Register5'))
      await confirmPasswordInput.inputText('123456')
      // 点击设置完成
      await checkButtonAndClickWithID('complete')
      // 点击弹窗关闭
      let registerClose = await driver.findComponent(ON.type('AlertDialog'))
      await registerClose.click()
      // 输入账号密码
      await applicationLogin('nameInput', 'testName_Video', 'passwordInput', '123456')
      // 点击登录
      await checkButtonAndClickWithID('login')
      // 点击修改信息
      await checkButtonAndClickWithID('modify')
      // 修改信息
      // 填写邮箱
      await driver.assertComponentExist(ON.id('Modify1'))
      let modifyEmailInput = await driver.findComponent(ON.id('Modify1'))
      await modifyEmailInput.inputText('123456789@qq.com')
      // 填写个性签名
      await driver.assertComponentExist(ON.id('Modify2'))
      let modifySignInput = await driver.findComponent(ON.id('Modify2'))
      await modifySignInput.inputText('test Video')
      // 填写密码
      await driver.assertComponentExist(ON.id('Modify3'))
      let modifyPasswordInput = await driver.findComponent(ON.id('Modify3'))
      await modifyPasswordInput.inputText('123456789')
      // 确认密码
      await driver.assertComponentExist(ON.id('Modify4'))
      let modifyConfirmPasswordInput = await driver.findComponent(ON.id('Modify4'))
      await modifyConfirmPasswordInput.inputText('123456789')
      // 点击设置完成
      await checkButtonAndClickWithID('modComplete')
      // 点击弹窗关闭
      let modifyRegisterClose = await driver.findComponent(ON.type('AlertDialog'))
      await modifyRegisterClose.click()
      // 点击切换应用
      await checkButtonAndClickWithID('application')
      // 点击确定
      await confirmCheck()
      // 使用修改后的账号再次进入视频应用，测试删除账号
      await checkButtonAndClickWithID('VideoApp')
      await applicationLogin('nameInput', 'testName_Video', 'passwordInput', '123456789')
      await checkButtonAndClickWithID('login')
      // 点击删除
      await checkButtonAndClickWithID('delete')
      // 点击确定
      await confirmCheck()
      // 点击返回
      await checkButtonAndClickWithID('back')
      // 点击确定
      await confirmCheck()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickVideoFunction_001 end')
    })

    it(BUNDLE + 'ClickMapFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMapFunction_001 begin')
      let driver: Driver = Driver.create()
      await driver.delayMs(1000)
      // 进入到地图
      await checkButtonAndClickWithID('MapApp')
      // 点击注册
      await checkButtonAndClickWithID('register')
      // 注册信息
      // 填写用户名
      await driver.assertComponentExist(ON.id('Register1'))
      let usernameInput = await driver.findComponent(ON.id('Register1'))
      await usernameInput.inputText('testName_Map')
      // 填写邮箱
      await driver.assertComponentExist(ON.id('Register2'))
      let emailInput = await driver.findComponent(ON.id('Register2'))
      await emailInput.inputText('123456@qq.com')
      // 填写个性签名
      await driver.assertComponentExist(ON.id('Register3'))
      let signInput = await driver.findComponent(ON.id('Register3'))
      await signInput.inputText('testMap')
       await driver.assertComponentExist(ON.id('Register4'))
      let passwordInput = await driver.findComponent(ON.id('Register4'))
      await passwordInput.inputText('123456')
      // 确认密码
      await driver.assertComponentExist(ON.id('Register5'))
      let confirmPasswordInput = await driver.findComponent(ON.id('Register5'))
      await confirmPasswordInput.inputText('123456')
      // 点击设置完成
      await checkButtonAndClickWithID('complete')
      // 点击弹窗关闭
      let registerClose = await driver.findComponent(ON.type('AlertDialog'))
      await registerClose.click()
      // 输入账号密码
      await applicationLogin('nameInput', 'testName_Map', 'passwordInput', '123456')
      // 点击登录
      await checkButtonAndClickWithID('login')
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMapFunction_001 end')
    })

    it(BUNDLE + 'ModifyInfoFunction_001',0,async function(){
      hilog.info(DOMAIN, TAG, BUNDLE + 'ModifyInfoFunction_001 begin')
      let driver = Driver.create()
      await driver.delayMs(1000)
      // 点击修改信息
      await checkButtonAndClickWithID('modify')
      // 修改信息
      // 填写邮箱
      await driver.assertComponentExist(ON.id('Modify1'))
      let modifyEmailInput = await driver.findComponent(ON.id('Modify1'))
      await modifyEmailInput.inputText('123456789@qq.com')
      // 填写个性签名
      await driver.assertComponentExist(ON.id('Modify2'))
      let modifySignInput = await driver.findComponent(ON.id('Modify2'))
      await modifySignInput.inputText('test Map')
      // 填写密码
      await driver.assertComponentExist(ON.id('Modify3'))
      let modifyPasswordInput = await driver.findComponent(ON.id('Modify3'))
      await modifyPasswordInput.inputText('123456789')
      await driver.delayMs(200)
      // 确认密码
      await driver.assertComponentExist(ON.id('Modify4'))
      let modifyConfirmPasswordInput = await driver.findComponent(ON.id('Modify4'))
      await modifyConfirmPasswordInput.inputText('123456789')
      // 点击设置完成
      await checkButtonAndClickWithID('modComplete')
      await driver.delayMs(1000)
      // 点击弹窗关闭
      let modifyRegisterClose = await driver.findComponent(ON.type('AlertDialog'))
      await modifyRegisterClose.click()
      // 点击切换应用
      await checkButtonAndClickWithID('application')
      // 点击确定
      await confirmCheck()
      // 使用修改后的账号再次进入地图应用，测试删除账号
      await checkButtonAndClickWithID('MapApp')
      await applicationLogin('nameInput', 'testName_Map', 'passwordInput', '123456789')
      await checkButtonAndClickWithID('login')
      // 点击删除
      await checkButtonAndClickWithID('delete')
      // 点击确定
      await confirmCheck()
      // 点击返回
      await checkButtonAndClickWithID('back')
      // 点击确定
      await confirmCheck()
      hilog.info(DOMAIN, TAG, BUNDLE + 'ModifyInfoFunction_001 end')
    })
  })
}