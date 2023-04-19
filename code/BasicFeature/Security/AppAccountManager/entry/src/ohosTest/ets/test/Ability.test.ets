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
import AbilityDelegatorRegistry from '@ohos.application.abilityDelegatorRegistry'
import hilog from '@ohos.hilog'

const TAG = '[Sample_AppAccountManager]'
const DOMAIN = 0xF811
const BUNDLE = 'AppAccountManager_'

let driver: Driver = Driver.create()
//通过id验证有没有这个组件 有的话点击一下
async function checkButtonAndClickWithID(text:string) {
  let atom = text
  await driver.assertComponentExist(ON.id(atom))
  let button = await driver.findComponent(ON.id(atom))
  await button.click()
  await driver.delayMs(1000)
}
// 注册信息
async function applicationRegister(username:string, usernameValue:string, email:string, emailValue:string, sign:string, signValue:string, password:string, passwordValue:string, confirmPassword:string, confirmPasswordValue:string, completeText:string) {
  // 填写用户名
  let registerUserName = username
  let registerUsernameValue = usernameValue
  await driver.assertComponentExist(ON.id(registerUserName))
  let usernameInput  = await driver.findComponent(ON.id(registerUserName))
  await usernameInput.inputText(registerUsernameValue)
  // 填写邮箱
  let registerEmail = email
  let registerEmailValue = emailValue
  await driver.assertComponentExist(ON.id(registerEmail))
  let emailInput = await driver.findComponent(ON.id(registerEmail))
  await emailInput.inputText(registerEmailValue)
  // 填写个性签名
  let registerSign = sign
  let registerSignValue = signValue
  await driver.assertComponentExist(ON.id(registerSign))
  let signInput = await driver.findComponent(ON.id(registerSign))
  await signInput.inputText(registerSignValue)
  // 填写密码
  let registerPassword = password
  let registerPasswordValue = passwordValue
  await driver.assertComponentExist(ON.id(registerPassword))
  let passwordInput = await driver.findComponent(ON.id(registerPassword))
  await passwordInput.inputText(registerPasswordValue)
  // 确认密码
  let registerConfirmPassword = confirmPassword
  let registerConfirmPasswordValue = confirmPasswordValue
  await driver.assertComponentExist(ON.id(registerConfirmPassword))
  let confirmPasswordInput = await driver.findComponent(ON.id(registerConfirmPassword))
  await confirmPasswordInput.inputText(registerConfirmPasswordValue)
  // 点击设置完成
  let complete = completeText
  await checkButtonAndClickWithID(complete)
  // 点击弹窗关闭
  let registerClose = await driver.findComponent(ON.type('AlertDialog'))
  await registerClose.click()
}
// 登录账号
async function applicationLogin(username:string, usernameValue:string, password:string, passwordValue:string) {
  // 填写用户名
  let loginUserName = username
  let loginUsernameValue = usernameValue
  await driver.assertComponentExist(ON.id(loginUserName))
  let usernameInput  = await driver.findComponent(ON.id(loginUserName))
  await usernameInput.inputText(loginUsernameValue)
  // 填写密码
  let loginPassword = password
  let loginPasswordValue = passwordValue
  await driver.assertComponentExist(ON.id(loginPassword))
  let passwordInput = await driver.findComponent(ON.id(loginPassword))
  await passwordInput.inputText(loginPasswordValue)
}
// 修改信息
async function applicationModify(email:string, emailValue:string, sign:string, signValue:string, password:string, passwordValue:string, confirmPassword:string, confirmPasswordValue:string, completeText:string) {
  // 填写邮箱
  let modifyEmail = email
  let modifyEmailValue = emailValue
  await driver.assertComponentExist(ON.id(modifyEmail))
  let emailInput = await driver.findComponent(ON.id(modifyEmail))
  await emailInput.inputText(modifyEmailValue)
  // 填写个性签名
  let modifySign = sign
  let modifySignValue = signValue
  await driver.assertComponentExist(ON.id(modifySign))
  let signInput = await driver.findComponent(ON.id(modifySign))
  await signInput.inputText(modifySignValue)
  // 填写密码
  let modifyPassword = password
  let modifyPasswordValue = passwordValue
  await driver.assertComponentExist(ON.id(modifyPassword))
  let passwordInput = await driver.findComponent(ON.id(modifyPassword))
  await passwordInput.inputText(modifyPasswordValue)
  // 确认密码
  let modifyConfirmPassword = confirmPassword
  let modifyConfirmPasswordValue = confirmPasswordValue
  await driver.assertComponentExist(ON.id(modifyConfirmPassword))
  let confirmPasswordInput = await driver.findComponent(ON.id(modifyConfirmPassword))
  await confirmPasswordInput.inputText(modifyConfirmPasswordValue)
  // 点击设置完成
  let complete = completeText
  await checkButtonAndClickWithID(complete)
  // 点击弹窗关闭
  let registerClose = await driver.findComponent(ON.type('AlertDialog'))
  await registerClose.click()
}
// 点击确定
async function confirmCheck() {
  let buttonConfirm = await driver.findComponents(ON.type('Button').within(ON.type('AlertDialog')))
  await buttonConfirm[0].click()
}
export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
      await abilityDelegator.startAbility({
        bundleName: "ohos.samples.etsappaccountmanager",
        abilityName: "EntryAbility"
      }, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })
    it(BUNDLE + 'ClickMusicFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMusicFunction_001 begin')
      let driver: Driver = Driver.create()
      await driver.delayMs(1000)
      // 进入到音乐
      await checkButtonAndClickWithID('MusicApp')
      // 点击注册
      await checkButtonAndClickWithID('register')
      // 注册信息
      await applicationRegister('Register1', 'testName_Music', 'Register2', '123456@qq.com', 'Register3', '测试音乐应用', 'Register4', '123456', 'Register5', '123456', 'complete')
      // 输入账号密码
      await applicationLogin('nameInput', 'testName_Music', 'passwordInput', '123456')
      // 点击登录
      await checkButtonAndClickWithID('login')
      // 点击修改信息
      await checkButtonAndClickWithID('modify')
      // 修改信息
      await applicationModify('Modify1', '123456789@qq.com', 'Modify2', 'test Music', 'Modify3', '123456789', 'Modify4', '123456789', 'modComplete')
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
      await applicationRegister('Register1', 'testName_Video', 'Register2', '123456@qq.com', 'Register3', '测试视频应用', 'Register4', '123456', 'Register5', '123456', 'complete')
      // 输入账号密码
      await applicationLogin('nameInput', 'testName_Video', 'passwordInput', '123456')
      // 点击登录
      await checkButtonAndClickWithID('login')
      // 点击修改信息
      await checkButtonAndClickWithID('modify')
      // 修改信息
      await applicationModify('Modify1', '123456789@qq.com', 'Modify2', 'test Video', 'Modify3', '123456789', 'Modify4', '123456789', 'modComplete')
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
      await applicationRegister('Register1', 'testName_Map', 'Register2', '123456@qq.com', 'Register3', '测试地图应用', 'Register4', '123456', 'Register5', '123456', 'complete')
      // 输入账号密码
      await applicationLogin('nameInput', 'testName_Map', 'passwordInput', '123456')
      // 点击登录
      await checkButtonAndClickWithID('login')
      // 点击修改信息
      await checkButtonAndClickWithID('modify')
      // 修改信息
      await applicationModify('Modify1', '123456789@qq.com', 'Modify2', 'test Map', 'Modify3', '123456789', 'Modify4', '123456789', 'modComplete')
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
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickMapFunction_001 end')
    })
  })
}