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

const TAG = '[Sample_AppAccountManager]'
const DOMAIN = 0xF811
const BUNDLE = 'AppAccountManager_'

export default function appTest() {
  describe('appTest', function () {
    it(BUNDLE + 'StartAbility_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin')
      let parameter = {
        "want": {
          bundleName: "ohos.samples.etsappaccountmanager",
          abilityName: "ohos.samples.etsappaccountmanager.MainAbility"
        }
      }
      await featureAbility.startAbility(parameter, (err, data) => {
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001,err.code:' + err.code)
        expect(0).assertEqual(err.code)
        done()
        hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end')
      })
    })

    /**
     * 音乐账户登录
     */
    it(BUNDLE + 'MusicLoginFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 enter')
      await driver.assertComponentExist(BY.key('MusicApp'))
      let btnMusic = await driver.findComponent(BY.key('MusicApp'))
      await btnMusic.click()
      await driver.delayMs(1000)
      // 验证无账号下的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 loginClick')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      //  验证未注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput1 = await driver.findComponent(BY.key('nameInput'))
      await nameInput1.inputText('zyy')
      let nameVal1 = await nameInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 nameVal1')
      expect('zyy').assertEqual(nameVal1)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput1 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput1.inputText('123456')
      let passwordVal1 = await passwordInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 passwordVal1')
      expect('123456').assertEqual(passwordVal1)
      await driver.delayMs(1000)
      // 登录
      await btnLogin.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      await btnClose.click()
      await driver.delayMs(1000)
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOK = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOK.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicLoginFunction_001 end')
    })

    /**
     * 音乐账户注册
     */
    it(BUNDLE + 'MusicRegisterFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 enter')
      await driver.assertComponentExist(BY.key('MusicApp'))
      let btnMusic = await driver.findComponent(BY.key('MusicApp'))
      await btnMusic.click()
      await driver.delayMs(1000)
      // 直接注册
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 register')
      await driver.assertComponentExist(BY.key('register'))
      let btnRegister = await driver.findComponent(BY.key('register'))
      await btnRegister.click()
      await driver.delayMs(1000)
      // 注册详情
      // 用户名
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 nameRegisterInput')
      await driver.assertComponentExist(BY.key('Register1'))
      let nameRegister1 = await driver.findComponent(BY.key('Register1'))
      await nameRegister1.inputText('zzn')
      let nameRegVal1 = await nameRegister1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 nameRegVal1')
      expect('zzn').assertEqual(nameRegVal1)
      await driver.delayMs(1000)
      // 个性签名
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 signRegisterInput')
      await driver.assertComponentExist(BY.key('Register3'))
      let signRegister1 = await driver.findComponent(BY.key('Register3'))
      await signRegister1.inputText('hhhhhh')
      let signRegVal1 = await signRegister1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 signRegVal1')
      expect('hhhhhh').assertEqual(signRegVal1)
      await driver.delayMs(1000)
      // 密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 passwordRegisterInput')
      await driver.assertComponentExist(BY.key('Register4'))
      let passwordRegister1 = await driver.findComponent(BY.key('Register4'))
      await passwordRegister1.inputText('123456')
      let passwordRegVal1 = await passwordRegister1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 passwordRegVal1')
      expect('123456').assertEqual(passwordRegVal1)
      await driver.delayMs(1000)
      // 确认密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 confirmRegisterInput')
      await driver.assertComponentExist(BY.key('Register5'))
      let confirmRegister1 = await driver.findComponent(BY.key('Register5'))
      await confirmRegister1.inputText('123456')
      let confirmRegVal1 = await confirmRegister1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 confirmRegVal1')
      expect('123456').assertEqual(confirmRegVal1)
      await driver.delayMs(1000)
      // 设置完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 completeClick')
      await driver.assertComponentExist(BY.key('complete'))
      let btnComplete = await driver.findComponent(BY.key('complete'))
      await btnComplete.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicRegisterFunction_001 end')
    })

    /**
     * 音乐账户注册后登录
     */
    it(BUNDLE + 'MusicAfterLoginFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicAfterLoginFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 验证已注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicAfterLoginFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput1 = await driver.findComponent(BY.key('nameInput'))
      await nameInput1.inputText('zzn')
      let nameVal1 = await nameInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicAfterLoginFunction_001 nameVal1')
      expect('zzn').assertEqual(nameVal1)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicAfterLoginFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput1 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput1.inputText('123456')
      let passwordVal1 = await passwordInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicAfterLoginFunction_001 passwordVal1')
      expect('123456').assertEqual(passwordVal1)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicAfterLoginFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicAfterLoginFunction_001 end')
    })

    /**
     * 音乐账户修改信息
     */
    it(BUNDLE + 'MusicEditFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 modify')
      await driver.assertComponentExist(BY.key('modify'))
      let btnModify = await driver.findComponent(BY.key('modify'))
      await btnModify.click()
      await driver.delayMs(1000)
      // 个性签名
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 signModifyInput')
      await driver.assertComponentExist(BY.key('Modify2'))
      let signModify1 = await driver.findComponent(BY.key('Modify2'))
      await signModify1.inputText('666666')
      let signModVal1 = await signModify1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 signModVal1')
      expect('666666').assertEqual(signModVal1)
      await driver.delayMs(1000)
      // 密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 passwordModifyInput')
      await driver.assertComponentExist(BY.key('Modify3'))
      let passwordModify1 = await driver.findComponent(BY.key('Modify3'))
      await passwordModify1.inputText('123789')
      let passwordModVal1 = await passwordModify1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 passwordModVal1')
      expect('123789').assertEqual(passwordModVal1)
      await driver.delayMs(1000)
      // 确认密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 confirmModifyInput')
      await driver.assertComponentExist(BY.key('Modify4'))
      let confirmModify1 = await driver.findComponent(BY.key('Modify4'))
      await confirmModify1.inputText('123789')
      let confirmModVal1 = await confirmModify1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 confirmModVal1')
      expect('123789').assertEqual(confirmModVal1)
      await driver.delayMs(1000)
      // 设置完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 completeClick')
      await driver.assertComponentExist(BY.key('modComplete'))
      let modComplete = await driver.findComponent(BY.key('modComplete'))
      await modComplete.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 切换应用
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 changeApp')
      await driver.assertComponentExist(BY.key('application'))
      let btnApp = await driver.findComponent(BY.key('application'))
      await btnApp.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOk = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOk.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicEditFunction_001 end')
    })

    /**
     * 音乐账户切换应用后登录
     */
    it(BUNDLE + 'MusicChangeFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 enter')
      await driver.assertComponentExist(BY.key('MusicApp'))
      let btnMusic = await driver.findComponent(BY.key('MusicApp'))
      await btnMusic.click()
      await driver.delayMs(1000)
      // 验证已注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput1 = await driver.findComponent(BY.key('nameInput'))
      await nameInput1.inputText('zzn')
      let nameVal1 = await nameInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 nameVal1')
      expect('zzn').assertEqual(nameVal1)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput1 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput1.inputText('123789')
      let passwordVal1 = await passwordInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 passwordVal1')
      expect('123789').assertEqual(passwordVal1)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      // 删除账号
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 delete')
      await driver.assertComponentExist(BY.key('delete'))
      let btnDelete = await driver.findComponent(BY.key('delete'))
      await btnDelete.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOk = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOk.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicChangeFunction_001 end')
    })

    /**
     * 音乐账户删除后登录
     */
    it(BUNDLE + 'MusicDeleteFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 验证已删除账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput1 = await driver.findComponent(BY.key('nameInput'))
      await nameInput1.inputText('zzn')
      let nameVal1 = await nameInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 nameVal1')
      expect('zzn').assertEqual(nameVal1)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput1 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput1.inputText('123789')
      let passwordVal1 = await passwordInput1.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 passwordVal1')
      expect('123789').assertEqual(passwordVal1)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOK = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOK.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MusicDeleteFunction_001 end')
    })

    /**
     * 视频账户登录
     */
    it(BUNDLE + 'VideoLoginFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 enter')
      await driver.assertComponentExist(BY.key('VideoApp'))
      let btnVideo = await driver.findComponent(BY.key('VideoApp'))
      await btnVideo.click()
      await driver.delayMs(1000)
      // 验证无账号下的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 loginClick')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 验证未注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput2 = await driver.findComponent(BY.key('nameInput'))
      await nameInput2.inputText('zqq')
      let nameVal2 = await nameInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 nameVal2')
      expect('zqq').assertEqual(nameVal2)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput2 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput2.inputText('333999')
      let passwordVal2 = await passwordInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 passwordVal2')
      expect('333999').assertEqual(passwordVal2)
      await driver.delayMs(1000)
      // 登录
      await btnLogin.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      await btnClose.click()
      await driver.delayMs(1000)
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOK = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOK.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoLoginFunction_001 end')
    })

    /**
     * 视频账户注册
     */
    it(BUNDLE + 'VideoRegisterFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 enter')
      await driver.assertComponentExist(BY.key('VideoApp'))
      let btnVideo = await driver.findComponent(BY.key('VideoApp'))
      await btnVideo.click()
      await driver.delayMs(1000)
      // 直接注册
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 register')
      await driver.assertComponentExist(BY.key('register'))
      let btnRegister = await driver.findComponent(BY.key('register'))
      await btnRegister.click()
      await driver.delayMs(1000)
      // 注册详情
      // 用户名
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 nameRegisterInput')
      await driver.assertComponentExist(BY.key('Register1'))
      let nameRegister2 = await driver.findComponent(BY.key('Register1'))
      await nameRegister2.inputText('zyy')
      let nameRegVal2 = await nameRegister2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 nameRegVal2')
      expect('zyy').assertEqual(nameRegVal2)
      await driver.delayMs(1000)
      // 个性签名
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 signRegisterInput')
      await driver.assertComponentExist(BY.key('Register3'))
      let signRegister2 = await driver.findComponent(BY.key('Register3'))
      await signRegister2.inputText('ptptptptpt')
      let signRegVal2 = await signRegister2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 signRegVal2')
      expect('ptptptptpt').assertEqual(signRegVal2)
      await driver.delayMs(1000)
      // 密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 passwordRegisterInput')
      await driver.assertComponentExist(BY.key('Register4'))
      let passwordRegister2 = await driver.findComponent(BY.key('Register4'))
      await passwordRegister2.inputText('777777')
      let passwordRegVal2 = await passwordRegister2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 passwordRegVal2')
      expect('777777').assertEqual(passwordRegVal2)
      await driver.delayMs(1000)
      // 确认密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 confirmRegisterInput')
      await driver.assertComponentExist(BY.key('Register5'))
      let confirmRegister2 = await driver.findComponent(BY.key('Register5'))
      await confirmRegister2.inputText('777777')
      let confirmRegVal2 = await confirmRegister2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 confirmRegVal2')
      expect('777777').assertEqual(confirmRegVal2)
      await driver.delayMs(1000)
      // 设置完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 complete')
      await driver.assertComponentExist(BY.key('complete'))
      let btnComplete = await driver.findComponent(BY.key('complete'))
      await btnComplete.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoRegisterFunction_001 end')
    })

    /**
     * 视频账户注册后登录
     */
    it(BUNDLE + 'VideoAfterLoginFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 验证已注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput2 = await driver.findComponent(BY.key('nameInput'))
      await nameInput2.inputText('zyy')
      let nameVal2 = await nameInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 nameVal2')
      expect('zyy').assertEqual(nameVal2)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput2 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput2.inputText('777777')
      let passwordVal2 = await passwordInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 passwordVal2')
      expect('777777').assertEqual(passwordVal2)
      await driver.delayMs(1000)
      console.log("Sample_AppAccountManager 103")
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 loginClick')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 end')
    })

    /**
     * 视频账户修改信息
     */
    it(BUNDLE + 'VideoEditFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 modify')
      await driver.assertComponentExist(BY.key('modify'))
      let btnModify = await driver.findComponent(BY.key('modify'))
      await btnModify.click()
      await driver.delayMs(1000)
      // 个性签名
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 signModifyInput')
      await driver.assertComponentExist(BY.key('Modify2'))
      let signModify2 = await driver.findComponent(BY.key('Modify2'))
      await signModify2.inputText('wwwwwwww')
      let signModVal2 = await signModify2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 signModVal2')
      expect('wwwwwwww').assertEqual(signModVal2)
      await driver.delayMs(1000)
      // 密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 passwordModifyInput')
      await driver.assertComponentExist(BY.key('Modify3'))
      let passwordModify2 = await driver.findComponent(BY.key('Modify3'))
      await passwordModify2.inputText('999999')
      let passwordModVal2 = await passwordModify2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 passwordModVal2')
      expect('999999').assertEqual(passwordModVal2)
      await driver.delayMs(1000)
      // 确认密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 confirmModifyInput')
      await driver.assertComponentExist(BY.key('Modify4'))
      let confirmModify2 = await driver.findComponent(BY.key('Modify4'))
      await confirmModify2.inputText('999999')
      let confirmModVal2 = await confirmModify2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 confirmModVal2')
      expect('999999').assertEqual(confirmModVal2)
      await driver.delayMs(1000)
      // 设置完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 modComplete')
      await driver.assertComponentExist(BY.key('modComplete'))
      let modComplete = await driver.findComponent(BY.key('modComplete'))
      await modComplete.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 切换应用
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 changApp')
      await driver.assertComponentExist(BY.key('application'))
      let btnApp = await driver.findComponent(BY.key('application'))
      await btnApp.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOk = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOk.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoAfterLoginFunction_001 end')
    })

    /**
     * 视频账户切换应用后登录
     */
    it(BUNDLE + 'VideoChangeFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 enter')
      await driver.assertComponentExist(BY.key('VideoApp'))
      let btnVideo = await driver.findComponent(BY.key('VideoApp'))
      await btnVideo.click()
      await driver.delayMs(1000)
      // 验证已注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput2 = await driver.findComponent(BY.key('nameInput'))
      await nameInput2.inputText('zyy')
      let nameVal2 = await nameInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 nameVal2')
      expect('zyy').assertEqual(nameVal2)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput2 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput2.inputText('999999')
      let passwordVal2 = await passwordInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 passwordVal2')
      expect('999999').assertEqual(passwordVal2)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      // 删除账号
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 deleteClick')
      await driver.assertComponentExist(BY.key('delete'))
      let btnDel = await driver.findComponent(BY.key('delete'))
      await btnDel.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 sure')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnSure = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnSure.click()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoChangeFunction_001 end')
    })

    /**
     * 视频账户删除后登录
     */
    it(BUNDLE + 'VideoDeleteFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 验证已删除账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput2 = await driver.findComponent(BY.key('nameInput'))
      await nameInput2.inputText('zyy')
      let nameVal2 = await nameInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 nameVal2')
      expect('zyy').assertEqual(nameVal2)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput2 = await driver.findComponent(BY.key('passwordInput1'))
      await passwordInput2.inputText('999999')
      let passwordVal2 = await passwordInput2.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 passwordVal2')
      expect('999999').assertEqual(passwordVal2)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOK = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOK.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'VideoDeleteFunction_001 end')
    })

    /**
     * 地图账户登录
     */
    it(BUNDLE + 'MapLoginFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 enter')
      await driver.assertComponentExist(BY.key('MapApp'))
      let btnMap = await driver.findComponent(BY.key('MapApp'))
      await btnMap.click()
      await driver.delayMs(1000)
      // 验证无账号下的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 验证未注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput3 = await driver.findComponent(BY.key('nameInput'))
      await nameInput3.inputText('111')
      let nameVal3 = await nameInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 nameVal3')
      expect('111').assertEqual(nameVal3)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput1'))
      let passwordInput3 = await driver.findComponent(BY.key('passwordInput1'))
      await passwordInput3.inputText('000000')
      let passwordVal3 = await passwordInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 passwordVal3')
      expect('000000').assertEqual(passwordVal3)
      await driver.delayMs(1000)
      // 登录
      await btnLogin.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      await btnClose.click()
      await driver.delayMs(1000)
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOK = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOK.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapLoginFunction_001 end')
    })

    /**
     * 地图账户注册
     */
    it(BUNDLE + 'MapRegisterFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 enter')
      await driver.assertComponentExist(BY.key('MapApp'))
      let btnMap = await driver.findComponent(BY.key('MapApp'))
      await btnMap.click()
      await driver.delayMs(1000)
      // 直接注册
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 register')
      await driver.assertComponentExist(BY.key('register'))
      let btnRegister = await driver.findComponent(BY.key('register'))
      await btnRegister.click()
      await driver.delayMs(1000)
      // 注册详情
      // 用户名
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 nameRegisterInput')
      await driver.assertComponentExist(BY.key('Register1'))
      let nameRegister3 = await driver.findComponent(BY.key('Register1'))
      await nameRegister3.inputText('666')
      let nameRegVal3 = await nameRegister3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 nameRegVal3')
      expect('666').assertEqual(nameRegVal3)
      await driver.delayMs(1000)
      // 个性签名
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 signRegisterInput')
      await driver.assertComponentExist(BY.key('Register3'))
      let signRegister3 = await driver.findComponent(BY.key('Register3'))
      await signRegister3.inputText('678')
      let signRegVal3 = await signRegister3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 signRegVal3')
      expect('678').assertEqual(signRegVal3)
      await driver.delayMs(1000)
      // 密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 passwordRegisterInput')
      await driver.assertComponentExist(BY.key('Register4'))
      let passwordRegister3 = await driver.findComponent(BY.key('Register4'))
      await passwordRegister3.inputText('11111hh')
      let passwordRegVal3 = await passwordRegister3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 passwordRegVal3')
      expect('11111hh').assertEqual(passwordRegVal3)
      await driver.delayMs(1000)
      // 确认密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 confirmRegisterInput')
      await driver.assertComponentExist(BY.key('Register5'))
      let confirmRegister3 = await driver.findComponent(BY.key('Register5'))
      await confirmRegister3.inputText('11111hh')
      let confirmRegVal3 = await confirmRegister3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 confirmRegVal3')
      expect('11111hh').assertEqual(confirmRegVal3)
      await driver.delayMs(1000)
      // 设置完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 complete')
      await driver.assertComponentExist(BY.key('complete'))
      let btnComplete = await driver.findComponent(BY.key('complete'))
      await btnComplete.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapRegisterFunction_001 end')
    })

    /**
     * 地图账户注册后登录
     */
    it(BUNDLE + 'MapAfterLoginFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapAfterLoginFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      // 验证已注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapAfterLoginFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput3 = await driver.findComponent(BY.key('nameInput'))
      await nameInput3.inputText('666')
      let nameVal3 = await nameInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapAfterLoginFunction_001 nameVal3')
      expect('666').assertEqual(nameVal3)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapAfterLoginFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput3 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput3.inputText('11111hh')
      let passwordVal3 = await passwordInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapAfterLoginFunction_001 passwordVal3')
      expect('11111hh').assertEqual(passwordVal3)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapAfterLoginFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapAfterLoginFunction_001 end')
    })

    /**
     * 地图账户修改信息
     */
    it(BUNDLE + 'MapEditFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 modify')
      await driver.assertComponentExist(BY.key('modify'))
      let btnModify = await driver.findComponent(BY.key('modify'))
      await btnModify.click()
      await driver.delayMs(1000)
      // 个性签名
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 signModifyInput')
      await driver.assertComponentExist(BY.key('Modify2'))
      let signModify3 = await driver.findComponent(BY.key('Modify2'))
      await signModify3.inputText('3q')
      let signModVal3 = await signModify3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 signModVal3')
      expect('3q').assertEqual(signModVal3)
      await driver.delayMs(1000)
      // 密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 passwordModifyInput')
      await driver.assertComponentExist(BY.key('Modify3'))
      let passwordModify3 = await driver.findComponent(BY.key('Modify3'))
      await passwordModify3.inputText('121212')
      let passwordModVal3 = await passwordModify3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 passwordModVal3')
      expect('121212').assertEqual(passwordModVal3)
      await driver.delayMs(1000)
      // 确认密码
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 confirmModifyInput')
      await driver.assertComponentExist(BY.key('Modify4'))
      let confirmModify3 = await driver.findComponent(BY.key('Modify4'))
      await confirmModify3.inputText('121212')
      let confirmModVal3 = await confirmModify3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 confirmModVal3')
      expect('121212').assertEqual(confirmModVal3)
      await driver.delayMs(1000)
      // 设置完成
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 modComplete')
      await driver.assertComponentExist(BY.key('modComplete'))
      let modComplete = await driver.findComponent(BY.key('modComplete'))
      await modComplete.click()
      await driver.delayMs(1000)
      // 关闭弹出框
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 切换应用
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 changeApp')
      await driver.assertComponentExist(BY.key('application'))
      let btnApp = await driver.findComponent(BY.key('application'))
      await btnApp.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOk = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOk.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapEditFunction_001 end')
    })

    /**
     * 地图账户切换应用后登录
     */
    it(BUNDLE + 'MapChangeFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 enter')
      await driver.assertComponentExist(BY.key('MapApp'))
      let btnMap = await driver.findComponent(BY.key('MapApp'))
      await btnMap.click()
      await driver.delayMs(1000)
      // 验证已注册账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput3 = await driver.findComponent(BY.key('nameInput'))
      await nameInput3.inputText('666')
      let nameVal3 = await nameInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 nameVal3')
      expect('666').assertEqual(nameVal3)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput3 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput3.inputText('121212')
      let passwordVal3 = await passwordInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 passwordVal3')
      expect('121212').assertEqual(passwordVal3)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      // 删除账号
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 delete')
      await driver.assertComponentExist(BY.key('delete'))
      let btnDel = await driver.findComponent(BY.key('delete'))
      await btnDel.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 sure')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnSure = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnSure.click()
      await driver.delayMs(2000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapChangeFunction_001 end')
    })

    /**
     * 地图账户删除后登录
     */
    it(BUNDLE + 'MapDeleteFunction_001', 0, async function () {
      // create UiDriver
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 begin')
      let driver = await UiDriver.create()
      await driver.delayMs(2000)
      // 验证已删除账号的登录情况
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 nameInput')
      await driver.assertComponentExist(BY.key('nameInput'))
      let nameInput3 = await driver.findComponent(BY.key('nameInput'))
      await nameInput3.inputText('666')
      let nameVal3 = await nameInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 nameVal3')
      expect('666').assertEqual(nameVal3)
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 passwordInput')
      await driver.assertComponentExist(BY.key('passwordInput'))
      let passwordInput3 = await driver.findComponent(BY.key('passwordInput'))
      await passwordInput3.inputText('121212')
      let passwordVal3 = await passwordInput3.getText()
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 passwordVal3')
      expect('121212').assertEqual(passwordVal3)
      await driver.delayMs(1000)
      // 登录
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 login')
      await driver.assertComponentExist(BY.key('login'))
      let btnLogin = await driver.findComponent(BY.key('login'))
      await btnLogin.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 closeClick')
      await driver.assertComponentExist(BY.text('关闭', MatchPattern.CONTAINS))
      let btnClose = await driver.findComponent(BY.text('关闭', MatchPattern.CONTAINS))
      await btnClose.click()
      await driver.delayMs(1000)
      // 返回
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 back')
      await driver.assertComponentExist(BY.key('back'))
      let btnBack = await driver.findComponent(BY.key('back'))
      await btnBack.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 ok')
      await driver.assertComponentExist(BY.text('确认', MatchPattern.CONTAINS))
      let btnOK = await driver.findComponent(BY.text('确认', MatchPattern.CONTAINS))
      await btnOK.click()
      await driver.delayMs(1000)
      hilog.info(DOMAIN, TAG, BUNDLE + 'MapDeleteFunction_001 end')
    })
  })
}