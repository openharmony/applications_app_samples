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

import { describe, expect, it } from '@ohos/hypium';
import abilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import { Driver, ON } from '@ohos.UiTest';
import hilog from '@ohos.hilog';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
const TAG = '[Sample_DistributedJotNote]';
const DOMAIN = 0xF811;
const BUNDLE = 'DistributedJotNote_';
const driver = Driver.create();

async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager;
  let text = await manage.getStringValue(resource);
  return text;
}

export default function appTest() {
  describe('ActsAbilityTest', () => {

    /**
     * 拉起应用
     */
    it('StartAbility_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 begin');
      let abilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.distributedjotnote',
          abilityName: 'EntryAbility'
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbility_001 end');
    })

    /**
     * 点击允许进行授权
     */
    it('ClickAccept_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAccept_001 begin');
      let driver = Driver.create();
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAccept_001 clickAccept');
      // 点击允许
      let arr = await driver.findComponents(ON.type(await getResourceString($r('app.string.accept'))));
      hilog.info(DOMAIN, TAG, 'arr : ' + arr);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.accept'))));
      let btnAccept = await driver.findComponent(ON.text(await getResourceString($r('app.string.accept'))));
      await btnAccept.click();
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickAccept_001 end');
    })

    /**
     * 欢迎页展示，点击按钮，进入主页面
     */
    it('ClickEnter_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnter_001 begin');
      // 点击进入按钮
      await driver.assertComponentExist(ON.id('enter_in_jot'));
      let enterButton = await driver.findComponent(ON.id('enter_in_jot'));
      await enterButton.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnter_001 end');
    })

    /**
     * 进入主页，滑动轮播图
     */
    it('ClickEnterSwiper_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterSwiper_002 begin');
      // 滑动轮播图
      await driver.assertComponentExist(ON.id('swiper'));
      let swiper = await driver.findComponent(ON.id('swiper'));
      await swiper.isScrollable();
      if (await swiper.isScrollable()) {
        hilog.info(DOMAIN, TAG, 'This scrollBar can be operated');
      } else {
        hilog.info(DOMAIN, TAG, 'This scrollBar can not be operated');
      }
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('swiper'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterSwiper_002 end');
    })

    /**
     * 点击主页右上角：设置图标
     */
    it('ClickSettings_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSettings_001 begin');
      // 点击设置图标
      await driver.assertComponentExist(ON.id('settingsImg'));
      let settingsImg = await driver.findComponent(ON.id('settingsImg'));
      await settingsImg.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickSettings_001 end');
    })

    /**
     * 进入迁移设置页：点击开关(迁移能力)
     */
    it('ClickToggle_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_001 begin');
      // 点击开关
      await driver.assertComponentExist(ON.id('toggle_ability_isOn'));
      let toggle = await driver.findComponent(ON.id('toggle_ability_isOn'));
      await toggle.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_001 end');
    })

    /**
     * 进入迁移设置页：点击开关(迁移页面栈)
     */
    it('ClickToggle_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_002 begin');
      // 点击开关
      await driver.assertComponentExist(ON.id('toggle_pageStack_isOn'));
      let toggle = await driver.findComponent(ON.id('toggle_pageStack_isOn'));
      await toggle.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toggle_pageStack_isOn'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_002 end');
    })

    /**
     * 进入迁移设置页：点击开关(迁移是否退出源端)
     */
    it('ClickToggle_003', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_003 begin');
      // 点击开关
      await driver.assertComponentExist(ON.id('toggle_sourceEnd_isOn'));
      let toggle = await driver.findComponent(ON.id('toggle_sourceEnd_isOn'));
      await toggle.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('toggle_sourceEnd_isOn'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickToggle_003 end');
    })

    /**
     * 返回主页
     */
    it('ClickBackArrow_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_001 begin');
      // 点击返回箭头
      await driver.assertComponentExist(ON.id('back_arrow_setting'));
      let backArrow = await driver.findComponent(ON.id('back_arrow_setting'));
      await backArrow.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_001 end');
    })

    /**
     * 点击笔记页：进入笔记页界面
     */
    it('ClickEnterNotes_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterNotes_001 begin');
      // 点击笔记页
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.NOTE_PAGE'))));
      let notesBar = await driver.findComponent(ON.text(await getResourceString($r('app.string.NOTE_PAGE'))));
      await notesBar.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.NOTE_PAGE'))));

      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterNotes_001 end');
    })

    /**
     * 笔记页界面:输入笔记标题
     */
    it('InputText_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputText_001 begin');
      // 输入笔记标题
      await driver.assertComponentExist(ON.id('textInput'));
      let textInput = await driver.findComponent(ON.id('textInput'));
      await textInput.inputText(await getResourceString($r('app.string.TEST_DATA')));
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('textInput'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputText_001 end');
    })

    /**
     * 笔记页界面:输入笔记内容
     */
    it('TextArea_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'InputText_001 begin');
      // 输入笔记内容
      await driver.assertComponentExist(ON.id('textArea'));
      let textInput = await driver.findComponent(ON.id('textArea'));
      await textInput.inputText(await getResourceString($r('app.string.TEST_DATA')));
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('textArea'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'TextArea_001 end');
    })

    /**
     * 返回主页
     */
    it('ClickBackArrow_002', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_002 begin');
      // 点击返回箭头
      await driver.assertComponentExist(ON.id('back_arrow_notes'));
      let backArrow = await driver.findComponent(ON.id('back_arrow_notes'));
      await backArrow.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_002 end');
    })


    /**
     * 点击待办事项：进入待办事项页界面
     */
    it('ClickEnterToDoList_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterToDoList_001 begin');
      // 点击待办事项
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.TODO_LIST'))));
      let itemChosen = await driver.findComponent(ON.text(await getResourceString($r('app.string.TODO_LIST'))));
      await itemChosen.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.TODO_LIST'))));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterToDoList_001 end');
    })

    /**
     * 待办事项页：滑动待办事项页list
     */
    it('ScrollToDoList_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ScrollToDoList_001 begin');
      // 滑动待办事项页list
      await driver.assertComponentExist(ON.id('Scroll_List'));
      let scrollList = await driver.findComponent(ON.id('Scroll_List'));
      await scrollList.scrollToBottom(20);
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Scroll_List'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ScrollToDoList_001 end');
    })

    /**
     * 待办事项页：点击待办事项页勾选框
     */
    it('ClickCheckBox_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCheckBox_001 begin');
      // 点击待办事项页勾选框
      await driver.assertComponentExist(ON.id('Checkbox'));
      let checkBox = await driver.findComponent(ON.id('Checkbox'));
      await checkBox.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('Checkbox'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickCheckBox_001 end');
    })

    /**
     * 返回主页
     */
    it('ClickBackArrow_003', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_003 begin');
      // 点击返回箭头
      await driver.assertComponentExist(ON.id('back_arrow_todolist'));
      let backArrow = await driver.findComponent(ON.id('back_arrow_todolist'));
      await backArrow.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_003 end');
    })

    /**
     * 点击图片墙页：进入图片墙页界面
     */
    it('ClickEnterImgWall_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterImgWall_001 begin');
      // 点击图片墙
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.IMG_WALL'))));
      let itemChosen = await driver.findComponent(ON.text(await getResourceString($r('app.string.IMG_WALL'))));
      await itemChosen.click();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.text(await getResourceString($r('app.string.IMG_WALL'))));
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterImgWall_001 end');
    })

    /**
     * 图片墙页：滑动瀑布流组件
     */
    it('ScrollWaterFlow_001', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ScrollWaterFlow_001 begin');
      // 滑动瀑布流组件
      await driver.assertComponentExist(ON.id('WaterFlow_row'));
      let WaterFlow = await driver.findComponent(ON.id('WaterFlow_row'));
      await WaterFlow.scrollToBottom(10);
      await driver.delayMs(2000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ScrollWaterFlow_001 end');
    })

    /**
     * 返回主页
     */
    it('ClickBackArrow_004', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_004 begin');
      // 点击返回箭头
      await driver.assertComponentExist(ON.id('back_arrow_imgWall'));
      let backArrow = await driver.findComponent(ON.id('back_arrow_imgWall'));
      await backArrow.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickBackArrow_004 end');
    })

    /**
     * 点击迁移时使用异步接口保存数据：进入异步接口保存数据页界面
     */
    it('ClickEnterAsyncMigration', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterAsyncMigration begin');
      // 点击异步接口
      await driver.assertComponentExist(ON.id('async_save_data'));
      let itemChosen = await driver.findComponent(ON.id('async_save_data'));
      await itemChosen.click();
      await driver.delayMs(1000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'ClickEnterAsyncMigration end');
    })

    /**
     * 异步接口保存数据页界面:输入内容
     */
    it('AsyncTextInput', 0, async () => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'AsyncTextInput begin');
      // 输入内容
      await driver.assertComponentExist(ON.id('asyncTextInput'));
      let textInput = await driver.findComponent(ON.id('asyncTextInput'));
      await textInput.inputText(await getResourceString($r('app.string.TEST_DATA')));
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('asyncTextInput'));
      hilog.info(DOMAIN, TAG, BUNDLE + 'AsyncTextInput end');
    })
  })
}