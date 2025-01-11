/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
 *
*/

import hilog from '@ohos.hilog'
import { describe, it, expect, beforeAll } from '@ohos/hypium';
import { abilityDelegatorRegistry, Driver, ON, MatchPattern } from '@kit.TestKit';
import { UIAbility, Want } from '@kit.AbilityKit';

const delegator: abilityDelegatorRegistry.AbilityDelegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;
let want: Want;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function TodoListTest () {

  describe('TodoListTest', () => {
    /**
     * 打开应用
     */
    beforeAll(async () => {
      want = {
        bundleName: bundleName,
        abilityName: 'EntryAbility'
      };
      await delegator.startAbility(want);
      await sleep(1000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
    })

    /**
     * 点击单个任务，测试切换单项任务的完成状态
     */
    it('testTask',0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testTask begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let text = await driver.findComponent(ON.text('未完成任务：', MatchPattern.CONTAINS));
      await text.getText().then(result => {
        expect(result).assertEqual('未完成任务：2');
      });
      let task = await driver.findComponent(ON.text('刷题'));
      await task.click();
      await driver.delayMs(1000);
      await text.getText().then(result => {
        expect(result).assertEqual('未完成任务：3');
      });
      await task.click();
      await driver.delayMs(1000);
      await text.getText().then(result => {
        expect(result).assertEqual('未完成任务：2');
      });
      done();
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testTask end');
    })

    /**
     * 点击全部完成，全部未完成按钮，测试切换全部任务的完成状态
     */
    it('testFinishAll_UnfinishAll',0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testFinishAll_UnfinishAll begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let unfinishAll = await driver.findComponent(ON.text('全部未完成'));
      await unfinishAll.click();
      await driver.delayMs(1000);
      let text = await driver.findComponent(ON.text('未完成任务：', MatchPattern.CONTAINS));
      await text.getText().then(result => {
        expect(result).assertEqual('未完成任务：5');
      });
      let finishAll = await driver.findComponent(ON.text('全部完成'));
      await finishAll.click();
      await driver.delayMs(1000);
      await text.getText().then(result => {
        expect(result).assertEqual('未完成任务：0');
      });
      done();
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testFinishAll_UnfinishAll end');
    })

    /**
     * 点击删除添加新任务，测试增删功能
     */
    it('testDeleteAddTask',0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testDeleteAddTask begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let deleteButton = await driver.findComponent(ON.text('删除'));
      await deleteButton.click();
      await driver.delayMs(1000);
      let button_search = await driver.findComponent(ON.text('学习ArkTS开发'));
      expect(button_search === null).assertTrue();
      let inputField = await driver.findComponent(ON.type('TextInput'));
      await inputField.inputText('test123')
      let addButton = await driver.findComponent(ON.text('+'));
      await addButton.click();
      await driver.delayMs(1000);
      let newTask = await driver.findComponent(ON.text('test123'));
      expect(newTask === null).assertFalse();
      done();
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testDeleteAddTask end');
    })

    /**
     * 点击设置按钮，测试切换显示已完成任务功能
     */
    it('testSetting',0, async (done: Function) => {
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testSetting begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let settingButton = await driver.findComponent(ON.text('设置'));
      await settingButton.click();
      await driver.delayMs(1000);
      let switchToggle = await driver.findComponent(ON.type('Toggle'));
      await switchToggle.click();
      await driver.delayMs(1000);
      let backButton = await driver.findComponent(ON.text('返回待办'));
      await backButton.click();
      await driver.delayMs(1000);
      let finishTask = await driver.findComponent(ON.text('健身'));
      expect(finishTask === null).assertTrue();
      await settingButton.click();
      await driver.delayMs(1000);
      let switchToggle1 = await driver.findComponent(ON.type('Toggle'));
      await switchToggle1.click();
      await driver.delayMs(1000);
      let backButton1 = await driver.findComponent(ON.text('返回待办'));
      await backButton1.click();
      await driver.delayMs(1000);
      let finishTask1 = await driver.findComponent(ON.text('健身'));
      expect(finishTask1 === null).assertFalse();
      done();
      hilog.info(0x0000, 'testTag', '%{public}s', 'uitest: testSetting end');
    })
  })
}
