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
import inputMethod from '@ohos.inputMethod';

const TAG = '[Sample_DistributedNote]';
const DOMAIN = 0xF811;
const BUNDLE = 'DistributedNote_';
const DRIVER = Driver.create();

export default function appTest() {
  describe('ActsAbilityTest', () => {

    /**
     * 拉起应用
     */
    it(BUNDLE + 'StartAbilityFunction_001', 0, async (done: Function) => {
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
    it(BUNDLE + 'ClickAcceptFunction_001', 0, async (done: Function) => {
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
     * 点击canvas item 进入分布式canvas界面
     */
    it(BUNDLE + 'ChosenFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChosenFunction_001 begin');
      // 点击note的listitem进入note界面
      await DRIVER.assertComponentExist(ON.id('chose0'));
      let itemChosen = await DRIVER.findComponent(ON.id('chose0'));
      await itemChosen.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text('Distributed'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChosenFunction_001 end');
    })

    /**
     * canvas界面点击按钮绘制ellipse，rect，点击delete删除与点击back回到主界面
     */
    it(BUNDLE + 'CanvasFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'CanvasFunction_001 begin');
      // ellipse
      hilog.info(DOMAIN, TAG, BUNDLE + 'CanvasFunction_001 ellipse');
      await DRIVER.assertComponentExist(ON.id('ellipse'));
      let ellipseBtn = await DRIVER.findComponent(ON.id('ellipse'));
      await ellipseBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('ellipseready'));

      // delete
      hilog.info(DOMAIN, TAG, BUNDLE + 'CanvasFunction_001 delete');
      await DRIVER.assertComponentExist(ON.id('delete'));
      let deleteBtn = await DRIVER.findComponent(ON.id('delete'));
      await deleteBtn.click();
      await DRIVER.delayMs(1000);

      // rect
      hilog.info(DOMAIN, TAG, BUNDLE + 'CanvasFunction_001 rect');
      await DRIVER.assertComponentExist(ON.id('rect'));
      let rectBtn = await DRIVER.findComponent(ON.id('rect'));
      await rectBtn.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.id('rectready'));

      // back
      hilog.info(DOMAIN, TAG, BUNDLE + 'CanvasFunction_001 rect');
      await DRIVER.assertComponentExist(ON.id('back'));
      let backBtn = await DRIVER.findComponent(ON.id('back'));
      await backBtn.click();
      await DRIVER.delayMs(1000)
      await DRIVER.assertComponentExist(ON.id('chose1'));
    })

    /**
     * 点击note item 进入分布式note界面
     */
    it(BUNDLE + 'ChosenFunction_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChosenFunction_002 begin');
      // 点击note的listitem进入note界面
      await DRIVER.assertComponentExist(ON.id('chose1'));
      let itemChosen = await DRIVER.findComponent(ON.id('chose1'));
      await itemChosen.click();
      await DRIVER.delayMs(1000);
      await DRIVER.assertComponentExist(ON.text('Distributed'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ChosenFunction_002 end');
    })

    /**
     * 点击添加按钮进入添加界面
     */
    it(BUNDLE + 'AddFunction_001', 0, async () => {
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
    it(BUNDLE + 'EditFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 begin');
      // 输入标题
      let inputMethodController = inputMethod.getController();
      await DRIVER.assertComponentExist(ON.id('titleInput'));
      let title = await DRIVER.findComponent(ON.id('titleInput'));
      await title.inputText('music');
      inputMethodController.stopInputSession();
      hilog.info(DOMAIN, TAG, BUNDLE + 'EditFunction_001 inputContent');
      // 输入内容
      await DRIVER.assertComponentExist(ON.id('contentInput'));
      let content = await DRIVER.findComponent(ON.id('contentInput'));
      await content.inputText('this is a folk music');
      inputMethodController.stopInputSession();
      await DRIVER.delayMs(1000);
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
    it(BUNDLE + 'UpdateNoteFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'UpdateNoteFunction_001 begin');
      let noteData = await DRIVER.findComponent(ON.id('music'));
      await noteData.click();
      // 输入标题
      let inputMethodController = inputMethod.getController();
      await DRIVER.assertComponentExist(ON.id('titleInput'));
      let title = await DRIVER.findComponent(ON.id('titleInput'));
      await title.inputText('book');
      inputMethodController.stopInputSession();
      hilog.info(DOMAIN, TAG, BUNDLE + 'SaveNoteFunction_001 inputContent');
      // 输入内容
      await DRIVER.assertComponentExist(ON.id('contentInput'));
      let content = await DRIVER.findComponent(ON.id('contentInput'));
      await content.inputText('this is a history book');
      inputMethodController.stopInputSession();
      await DRIVER.delayMs(1000);
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
    it(BUNDLE + 'ClearNoteFunction_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClearNoteFunction_001 begin');
      // 点击清除
      await DRIVER.assertComponentExist(ON.id('clearNote'));
      let btnClear = await DRIVER.findComponent(ON.id('clearNote'));
      await btnClear.click();
      // 验证首页结果
      let noteData = await DRIVER.findComponent(ON.id('book'));
      expect(noteData).assertNull();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClearNoteFunction_001 end');
    })
  })
}