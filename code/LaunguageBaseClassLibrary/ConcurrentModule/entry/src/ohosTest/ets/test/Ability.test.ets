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

import hilog from '@ohos.hilog';
import { describe, it, expect } from '@ohos/hypium';
import { Driver, ON} from '@ohos.UiTest';
import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry';
import inputMethod from '@ohos.inputMethod';

const TAG = '[Sample_JSConcurrent]';
const DOMAIN = 0xF811;
const BUNDLE = 'JSConcurrent_';

let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()
let resourceManager = abilityDelegator.getAppContext().resourceManager;
// 资源本地化
async function getResourceString(resource: Resource): Promise<string> {
  let manage = abilityDelegator.getAppContext().resourceManager
  let text = await manage.getStringValue(resource)
  return text
}

export default function abilityTest() {
  describe('abilityTest', () => {
    /**
     * @tc.number    : StartAbilityFunction_001
     * @tc.name      : Start ability
     * @tc.desc      : Start an application
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('StartAbilityFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 begin');
      let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator();
      try {
        await abilityDelegator.startAbility({
          bundleName: "com.samples.concurrentmodule",
          abilityName: "EntryAbility"
        });
        done();
      } catch (err) {
        expect(err.code).assertEqual(0);
        done();
      }
      hilog.info(DOMAIN, TAG, BUNDLE + 'StartAbilityFunction_001 end');
    })

    /**
     * @tc.number    : WorkerCopyFileFunction_001
     * @tc.name      : WorkerCopyFile
     * @tc.desc      : Click the copy file button
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 点击拷贝文件按钮
    it('WorkerCopyFileFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('fileCopy'));
      let fileCopy = await driver.findComponent(ON.id('fileCopy'));
      await fileCopy.click();
      let copyFileLog1 = await getResourceString($r('app.string.copyFileLog1'))
      expect(copyFileLog1).assertEqual(await resourceManager.getStringValue($r('app.string.copyFileLog1')));
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileFunction_001 end');
    })

    /**
     * @tc.number    : WorkerCopyFileButtonFunction_001
     * @tc.name      : WorkerCopyFile
     * @tc.desc      : Click the copy file button
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 进入页面直接点击拷贝文件按钮
    it('WorkerCopyFileButtonFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileButtonFunction_001 begin');
      let driver = await Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('copyFile'));
      let copyFile = await driver.findComponent(ON.id('copyFile'));
      await copyFile.click();
      await driver.assertComponentExist(ON.id('copyFile'));
      let copyFileLog = await driver.findComponent(ON.id('copyFileLog'));
      let strValue = await copyFileLog.getText();
      expect(strValue).assertEqual(await resourceManager.getStringValue($r('app.string.workerLogChooseFile')));
      await driver.delayMs(1000);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileButtonFunction_001 end');
    })

    /**
     * @tc.number    : WorkerCopyFileFunction_002
     * @tc.name      : WorkerCopyFile
     * @tc.desc      : Select file copy
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 选择文件拷贝
    it('WorkerCopyFileFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileFunction_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      // 使用id寻找组件并点击，时间超过3min，因此采用坐标点击
      await driver.click(630, 272);
      await driver.click(630, 372);
      await driver.click(630, 472);
      let copyFileLog = await driver.findComponent(ON.id('copyFileLog'));
      let strValue = await copyFileLog.getText();
      expect(strValue).assertEqual(await resourceManager.getStringValue($r('app.string.workerLogChooseFile')));
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileFunction_002 end');
    })

    /**
     * @tc.number    : WorkerCopyFileFunction_003
     * @tc.name      : WorkerCopyFile
     * @tc.desc      : Copy the file
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 拷贝文件
    it('WorkerCopyFileFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileFunction_003 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('copyFile'));
      let copyFile = await driver.findComponent(ON.id('copyFile'));
      await copyFile.click();
      let copyFileLog1 = await getResourceString($r('app.string.copyFileLog1'))
      let copyFileLog2 = await getResourceString($r('app.string.copyFileLog2'))
      expect(copyFileLog1).assertEqual(await resourceManager.getStringValue($r('app.string.copyFileLog1')));
      expect(copyFileLog2).assertEqual(await resourceManager.getStringValue($r('app.string.copyFileLog2')));
      await driver.assertComponentExist(ON.text(copyFileLog1));
      await driver.assertComponentExist(ON.text(copyFileLog2));
      await driver.assertComponentExist(ON.id('backIndex2'));
      let backIndex = await driver.findComponent(ON.id('backIndex2'));
      await backIndex.click();
      await driver.delayMs(500);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileFunction_003 end');
    })

    /**
     * @tc.number    : WorkerFunction_000
     * @tc.name      : Worker string sorting
     * @tc.desc      : Click the string sorting button
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 点击字符串排序按钮
    it('WorkerFunction_000', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_000 begin');
      let driver = Driver.create();
      await driver.delayMs(500);
      await driver.assertComponentExist(ON.id('strSort'));
      let strSortBt = await driver.findComponent(ON.id('strSort'));
      await strSortBt.click();
      await driver.assertComponentExist(ON.id('jsWorkerInPutTextArea'));
      let strInput  = await driver.findComponent(ON.id('jsWorkerInPutTextArea'));
      let strValue = await strInput.getText();
      expect(strValue).assertEqual("");
      await driver.delayMs(500);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_000 end');
    })

    /**
     * @tc.number    : WorkerFunction_001
     * @tc.name      : Worker string sorting
     * @tc.desc      : Enter the string to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 输入待排序字符串
    it('WorkerFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('jsWorkerInPutTextArea'));
      let strInput  = await driver.findComponent(ON.id('jsWorkerInPutTextArea'));
      await strInput.inputText('dses,ssdf,add');
      let strValue = await strInput.getText();
      expect(strValue).assertEqual("dses,ssdf,add");
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_001 end');
    })

    /**
     * @tc.number    : WorkerFunction_002
     * @tc.name      : Worker string sorting
     * @tc.desc      : Click the string sorting button
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 点击字符串排序按钮
    it('WorkerFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_002 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('workerStrSort'));
      let workerStrBtn  = await driver.findComponent(ON.id('workerStrSort'));
      await workerStrBtn.click();
      await driver.assertComponentExist(ON.id('jsWorkerOutPutScroll'));
      let outPutScroll = await driver.findComponent(ON.id('jsWorkerOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('jsWorkerOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual('add,dses,ssdf');
      await driver.delayMs(500);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_002 end');
    })

    /**
     * @tc.number    : WorkerFunction_003
     * @tc.name      : Worker string sorting
     * @tc.desc      : Obtain sorting results and check
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 获取排序结果并检查
    it('WorkerFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_003 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('jsWorkerOutPutScroll'));
      let outPutScroll = await driver.findComponent(ON.id('jsWorkerOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('jsWorkerOutPutText'));
      let strValue = await strOutput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_003 readValue：' + strValue);
      expect(strValue).assertEqual('add,dses,ssdf');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_003 end');
    })

    /**
     * @tc.number    : WorkerFunction_004
     * @tc.name      : Worker string sorting
     * @tc.desc      : Click the clear button
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 点击清空按钮
    it('WorkerFunction_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_004 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('workerClearButton'));
      let workerClearBtn  = await driver.findComponent(ON.id('workerClearButton'));
      await workerClearBtn.click();
      let outPutScroll = await driver.findComponent(ON.id('jsWorkerOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('jsWorkerOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual("");
      await driver.delayMs(500);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_004 end');
    })

    /**
     * @tc.number    : TaskPoolFunction_001
     * @tc.name      : TaskPool string sorting
     * @tc.desc      : Click on the TaskPool tab
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 点击TaskPool页签
    it('TaskPoolFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_001 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('tabTaskPool'));
      let tabTaskPool = await driver.findComponent(ON.id('tabTaskPool'));
      await tabTaskPool.click();
      await driver.assertComponentExist(ON.id('taskPoolInPutTextArea'));
      let strInput  = await driver.findComponent(ON.id('taskPoolInPutTextArea'));
      let strValue = await strInput.getText();
      expect(strValue).assertEqual("");
      await driver.delayMs(500);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_001 end');
    })

    /**
     * @tc.number    : TaskPoolFunction_002
     * @tc.name      : TaskPool string sorting
     * @tc.desc      : Enter the string to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 输入待排序字符串
    it('TaskPoolFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);

      await driver.assertComponentExist(ON.id('taskPoolInPutTextArea'));
      let strInput  = await driver.findComponent(ON.id('taskPoolInPutTextArea'));
      await strInput.inputText('dses,ssdf,add');
      let strValue = await strInput.getText();
      expect(strValue).assertEqual("dses,ssdf,add");
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 end')
    })

    /**
     * @tc.number    : TaskPoolFunction_003
     * @tc.name      : TaskPool string sorting
     * @tc.desc      : Click to execute immediately
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 点击立即执行
    it('TaskPoolFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_003 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('exeImmButton'));
      let exeImmBtn  = await driver.findComponent(ON.id('exeImmButton'));
      await exeImmBtn.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 readValue：' + strValue);
      expect(strValue).assertEqual("Task executed successfully: add,dses,ssdf\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_003 end');
    })

    /**
     * @tc.number    : TaskPoolFunction_005
     * @tc.name      : TaskPool string sorting
     * @tc.desc      : Verify inspection results
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 验证检查结果
    it('TaskPoolFunction_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_004 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolOutPutScroll'));
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 readValue：' + strValue);
      expect(strValue).assertEqual("Task executed successfully: add,dses,ssdf\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_004 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_000
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Enter the first set of strings to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 输入第一组待排序字符串
    it('TaskPoolGroup_000', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_000 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolInPutTextArea'));
      let strInput  = await driver.findComponent(ON.id('taskPoolInPutTextArea'));
      await strInput.inputText('dses,ssdf,add');
      let strValue = await strInput.getText();
      expect(strValue).assertEqual("dses,ssdf,add");
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_000 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_001
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Add to task group
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 添加至任务组
    it('TaskPoolGroup_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_001 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('addButton'));
      let addButton  = await driver.findComponent(ON.id('addButton'));
      await addButton.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual("TaskGroup addTask successfully.\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_001 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_002
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Clean up
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 清除
    it('TaskPoolGroup_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_002 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolClearButton'));
      let clearButton  = await driver.findComponent(ON.id('taskPoolClearButton'));
      await clearButton.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual("");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_002 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_003
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Enter the second set of strings to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 输入第二组待排序字符串
    it('TaskPoolGroup_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_003 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolInPutTextArea'));
      let strInput  = await driver.findComponent(ON.id('taskPoolInPutTextArea'));
      await strInput.inputText('mnf,csfg,brsf');
      let strValue = await strInput.getText();
      expect(strValue).assertEqual("mnf,csfg,brsf");
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_003 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_004
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Add the second task to the task group
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 添加第二个任务至任务组
    it('TaskPoolGroup_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_004 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('addButton'));
      let addButton  = await driver.findComponent(ON.id('addButton'));
      await addButton.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual("TaskGroup addTask successfully.\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_004 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_005
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Second Clear
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 第二次清除
    it('TaskPoolGroup_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_005 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolClearButton'));
      let clearButton  = await driver.findComponent(ON.id('taskPoolClearButton'));
      await clearButton.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual("");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_005 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_006
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Enter the third set of strings to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 输入第三组待排序字符串
    it('TaskPoolGroup_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_006 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolInPutTextArea'));
      let strInput  = await driver.findComponent(ON.id('taskPoolInPutTextArea'));
      await strInput.inputText('rkg,abhg,ungb');
      let strValue = await strInput.getText();
      expect(strValue).assertEqual("rkg,abhg,ungb");
      let inputMethodController = inputMethod.getController();
      inputMethodController.stopInputSession();
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_006 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_007
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Add the third task to the task group
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 添加第三个任务至任务组
    it('TaskPoolGroup_007', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_007 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('addButton'));
      let addButton  = await driver.findComponent(ON.id('addButton'));
      await addButton.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual("TaskGroup addTask successfully.\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_007 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_008
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Third clearing
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 第三次清除
    it('TaskPoolGroup_008', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_008 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolClearButton'));
      let clearButton  = await driver.findComponent(ON.id('taskPoolClearButton'));
      await clearButton.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      expect(strValue).assertEqual("");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_008 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_009
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Execute Task Group
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 执行任务组
    it('TaskPoolGroup_009', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_009 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('exeImmButton'));
      let executeButton  = await driver.findComponent(ON.id('exeImmButton'));
      await executeButton.click();
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_010 readValue：' + strValue);
      expect(strValue).assertEqual("TaskGroup executed successfully: add,dses,ssdf,brsf,csfg,mnf,abhg,rkg,ungb\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_009 end');
    })

    /**
     * @tc.number    : TaskPoolGroup_0010
     * @tc.name      : TaskPoolGroup string sorting
     * @tc.desc      : Inspection results
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // 检查结果
    it('TaskPoolGroup_010', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_010 begin');
      let driver = Driver.create();
      await driver.delayMs(500);

      await driver.assertComponentExist(ON.id('taskPoolOutPutScroll'));
      let outPutScroll = await driver.findComponent(ON.id('taskPoolOutPutScroll'));
      let strOutput = await outPutScroll.scrollSearch(ON.id('taskPoolOutPutText'));
      let strValue = await strOutput.getText();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_010 readValue：' + strValue);
      expect(strValue).assertEqual("TaskGroup executed successfully: add,dses,ssdf,brsf,csfg,mnf,abhg,rkg,ungb\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolGroup_010 end');
    })
  })
}