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

import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';

const TAG = '[Sample_DistributedNote]';
const DOMAIN = 0xF811;
const BUNDLE = 'DistributedNote_';
const DRIVER = Driver.create();

export default function appTest() {
  describe('appTest', function () {

    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbilityFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'ohos.samples.distributednote',
          abilityName: 'MainAbility'
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })

    /**
     * 点击允许进行授权
     */
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async function (done) {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 begin');
      await DRIVER.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 clickAccept');
      // 点击允许
      await DRIVER.assertComponentExist(ON.text('允许'));
      let btnAccept = await DRIVER.findComponent(ON.text('允许'));
      await btnAccept.click();
      await DRIVER.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAcceptFunction_001 end');
    })

    /**
     * 点击添加按钮进入添加界面
     */
    it(BUNDLE + 'AddFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 begin');
      // 点击添加按钮
      await DRIVER.assertComponentExist(ON.id('addNote'));
      let btnAdd = await DRIVER.findComponent(ON.id('addNote'));
      await btnAdd.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text('添加备忘录'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'AddFunction_001 end');
    })

    /**
     * 编辑标题、内容、标记颜色，点击提交按钮添加备忘录
     */
    it(BUNDLE + 'EditFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 begin');
      // 输入标题
      await DRIVER.assertComponentExist(ON.id('titleInput'));
      let title = await DRIVER.findComponent(ON.id('titleInput'));
      await title.inputText('music');
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 inputContent');
      // 输入内容
      await DRIVER.assertComponentExist(ON.id('contentInput'));
      let content = await DRIVER.findComponent(ON.id('contentInput'));
      await content.inputText('this is a folk music');
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 clickSaveNote');
      // 点击保存
      await DRIVER.assertComponentExist(ON.id('saveNote'));
      let btnSave = await DRIVER.findComponent(ON.id('saveNote'));
      await btnSave.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('music'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 end');
    })

    /**
     * 修改备忘录
     */
    it(BUNDLE + 'UpdateNoteFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UpdateNoteFunction_001 begin');
      let noteData = await DRIVER.findComponent(ON.id('music'));
      await noteData.click();
      await DRIVER.delayMs(1000);
      // 输入标题
      await DRIVER.assertComponentExist(ON.id('titleInput'));
      let title = await DRIVER.findComponent(ON.id('titleInput'));
      await title.inputText('book');
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 inputContent');
      // 输入内容
      await DRIVER.assertComponentExist(ON.id('contentInput'));
      let content = await DRIVER.findComponent(ON.id('contentInput'));
      await content.inputText('this is a history book');
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 clickSaveNote');
      // 点击保存
      await DRIVER.assertComponentExist(ON.id('saveNote'));
      let btnSave = await DRIVER.findComponent(ON.id('saveNote'));
      await btnSave.click();
      await DRIVER.delayMs(1000);
      // 验证首页数据
      await DRIVER.assertComponentExist(ON.id('book'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'UpdateNoteFunction_001 end');
    })

    /**
     * 点击清除可以清除备忘录
     */
    it(BUNDLE + 'ClearNoteFunction_001', 0, async function () {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClearNoteFunction_001 begin');
      // 点击清除
      await DRIVER.assertComponentExist(ON.id('clearNote'));
      let btnClear = await DRIVER.findComponent(ON.id('clearNote'));
      await btnClear.click();
      await DRIVER.delayMs(1000);
      // 验证首页结果
      let noteData = await DRIVER.findComponent(ON.id('book'));
      expect(noteData).assertNull();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClearNoteFunction_001 end');
    })
  })
}