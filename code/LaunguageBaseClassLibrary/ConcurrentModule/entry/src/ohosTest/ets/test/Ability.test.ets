/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import worker from '@ohos.worker';
import taskpool from '@ohos.taskpool';
import { SendableClass} from '../../../main/ets/component/SendableTest';
import { TestA, TestB } from '../../../main/ets/component/test';
import { BusinessError } from '@kit.BasicServicesKit';
import utils from '@arkts.utils';

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

function promiseCase() : Promise<Object | void> {
  let p: Promise<Object | void> = new Promise<Object>((resolve: Function, reject: Function) => {
    setTimeout(() => {
      resolve(1)
    }, 100)
  }).then(undefined, () => {
  })
  return p;
}

async function executeWorkerFunc(inPutArr: string[]): Promise<string> {
  let myWorker: worker.ThreadWorker = new worker.ThreadWorker("entry/ets/workers/Worker.ts");
  myWorker.postMessage(inPutArr);
  let outPutStr: string = '';
  let strFlag = false;
  myWorker.onmessage = (e) => {
    outPutStr = e.data.toString();
    strFlag = true;
  }
  while(!strFlag) {
    await promiseCase();
  }
  return outPutStr;

}

@Concurrent
function strSort(inPutArr: string[]) : string[] {
  let newArr: string[] = inPutArr.sort();
  return newArr;
}

@Concurrent
function strSortDelay(inPutArr: string[]) : string[] {
  let start: number= new Date().getTime();
  while (new Date().getTime() - start < 3000) {
    continue;
  }
  let newArr: string[] = inPutArr.sort();
  return newArr;
}

@Concurrent
async function createSendableData(data: SendableClass): Promise<void> {
  // 定义taskpool子线程异步锁sendableTask_lock
  let lock: utils.locks.AsyncLock = utils.locks.AsyncLock.request("testTask_lock");

  // 构造TestA、TestB实例，组装SendableClass实例
  let d1: TestA = new TestA();
  d1.v1 = 1010;
  d1.v2 = "aaa";
  d1.v3 = true;
  let d2: TestB = new TestB();
  d2.v2.set(100, "aaa");
  for(let i = 0;i < 1000;i++) {
    d2.v1.push(i);
    d2.v3.add("hello");
  }

  lock.lockAsync(async () => {
    // 子线程调用实例方法setCount、getCount
    await d1.setCount(10);
    console.info("taskpool: this data1 count is: " + await d1.getCount());
  })

  data.data1 = d1;
  data.data2 = d2;
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
      let driver = Driver.create();
      await driver.delayMs(1000);
      await driver.assertComponentExist(ON.id('copyFile'));
      let copyFile = await driver.findComponent(ON.id('copyFile'));
      await copyFile.click();
      await driver.assertComponentExist(ON.id('copyFile'));
      let copyFileLog = await driver.findComponent(ON.id('copyFileLog'));
      let strValue = await copyFileLog.getText();
      expect(strValue).assertEqual(await resourceManager.getStringValue($r('app.string.workerLogChooseFile')));
      await driver.delayMs(500);
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
      await driver.delayMs(500);
      // 使用id寻找组件并点击，时间超过3min，因此采用坐标点击
      let copy1 = await driver.findComponent(ON.id('checkbox0'));
      await copy1.click();
      let copy2 = await driver.findComponent(ON.id('checkbox1'));
      await copy2.click();
      let copy3 = await driver.findComponent(ON.id('checkbox2'));
      await copy3.click();
      let copyFileLog = await driver.findComponent(ON.id('copyFileLog'));
      let strValue = await copyFileLog.getText();
      expect(strValue).assertEqual(await resourceManager.getStringValue($r('app.string.workerLogChooseFile')));
      await driver.delayMs(200);
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerCopyFileFunction_002 end');
    })

    /**
     * @tc.number    : WorkerFunction_001
     * @tc.name      : Worker string sorting
     * @tc.desc      : Enter the string to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // worker执行排序字符串
    it('WorkerFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_001 begin');

      let value: string = "add,dses,ssdf";
      let arr = value.trim().split(',');
      let outPutStr = await executeWorkerFunc(arr);
      expect(outPutStr).assertEqual('add,dses,ssdf');
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'WorkerFunction_001 end');
    })

    /**
     * @tc.number    : TaskPoolFunction_001
     * @tc.name      : TaskPool string sorting
     * @tc.desc      : Click on the TaskPool tab
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // TaskPool立即执行字符串排序
    it('TaskPoolFunction_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_001 begin');
      let value: string = "add,dses,ssdf";
      let arr = value.trim().split(',');
      let taskPoolOutPutStr = '';
      let task = new taskpool.Task(strSort, arr);
      try {
        let result: taskpool.Task = await taskpool.execute(task) as taskpool.Task;
        taskPoolOutPutStr += "Task executed successfully: "+ result.toString()+ "\n";
      } catch(e) {
        taskPoolOutPutStr += "Task executed failed: "+ (e as BusinessError).toString()+ "\n";
      }
      expect(taskPoolOutPutStr).assertEqual("Task executed successfully: add,dses,ssdf\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_001 end');
    })

    /**
     * @tc.number    : TaskPoolFunction_002
     * @tc.name      : TaskPool execute string sorting task
     * @tc.desc      : Enter the string to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // TaskPool延时执行字符串排序任务
    it('TaskPoolFunction_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 begin');
      let value: string = "add,dses,ssdf";
      let arr = value.trim().split(',');
      let taskPoolOutPutStr = '';
      let task = new taskpool.Task(strSortDelay, arr);
      try {
        let result: taskpool.Task = await taskpool.execute(task) as taskpool.Task;
        taskPoolOutPutStr += "Task executed successfully: "+ result.toString()+ "\n";
      } catch(e) {
        taskPoolOutPutStr += "Task executed failed: "+ (e as BusinessError).toString()+ "\n";
      }
      expect(taskPoolOutPutStr).assertEqual("Task executed successfully: add,dses,ssdf\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 end')
    })

    /**
     * @tc.number    : TaskPoolFunction_003
     * @tc.name      : TaskPool execute string sorting func
     * @tc.desc      : Enter the string to be sorted
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // TaskPool延时执行字符串排序任务
    it('TaskPoolFunction_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 begin');
      let value: string = "add,dses,ssdf";
      let arr = value.trim().split(',');
      let taskPoolOutPutStr = '';
      try {
        let result: taskpool.Task = await taskpool.execute(strSortDelay, arr) as taskpool.Task;
        taskPoolOutPutStr += "Task executed successfully: "+ result.toString()+ "\n";
      } catch(e) {
        taskPoolOutPutStr += "Task executed failed: "+ (e as BusinessError).toString()+ "\n";
      }
      expect(taskPoolOutPutStr).assertEqual("Task executed successfully: add,dses,ssdf\n");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 end')
    })

    /**
     * @tc.number    : TaskPoolFunction_004
     * @tc.name      : TaskPool cancel string sorting task
     * @tc.desc      : Cancel string sorting task
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // TaskPool延时执行字符串排序
    it('TaskPoolFunction_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 begin');
      let value: string = "add,dses,ssdf";
      let arr = value.trim().split(',');
      let taskPoolOutPutStr = '';
      let task = new taskpool.Task(strSortDelay, arr);
      try {
        taskpool.execute(task).then((res) => {
          taskPoolOutPutStr += "Task executed successfully: "+ res.toString()+ "\n";
        }).catch((e: BusinessError) => {
          taskPoolOutPutStr += "Task executed failed: "+ e.toString()+ "\n";
        });
        taskpool.cancel(task);
      } catch(e) {
        taskPoolOutPutStr += "Task executed failed: "+ (e as BusinessError).toString()+ "\n";
      }
      expect(taskPoolOutPutStr).assertEqual("");
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_002 end')
    })

    /**
     * @tc.number    : TaskPoolFunction_005
     * @tc.name      : TaskPool Group execute string sorting
     * @tc.desc      : Execute string sorting TaskPool Group
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    // TaskPool Group执行字符串排序
    it('TaskPoolFunction_005', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_003 begin');
      let value: string = "add,dses,ssdf";
      let arr = value.trim().split(',');
      let value1: string = "mnf,csfg,brsf";
      let arr1 = value1.trim().split(',');
      let value2: string = "rkg,abhg,ungb";
      let arr2 = value2.trim().split(',');
      let taskPoolOutPutStr = '';
      try {
        let task1: taskpool.Task = new taskpool.Task(strSort, arr);
        let task2: taskpool.Task = new taskpool.Task(strSort, arr1);
        let task3: taskpool.Task = new taskpool.Task(strSort, arr2);

        let taskGroup:taskpool.TaskGroup = new taskpool.TaskGroup();
        taskGroup.addTask(task1);
        taskGroup.addTask(task2);
        taskGroup.addTask(task3);
        let res: string[] = await taskpool.execute(taskGroup) as string[];
        taskPoolOutPutStr += "TaskGroup executed successfully: "+ res.toString()+ "\n";
        expect(taskPoolOutPutStr).assertEqual("TaskGroup executed successfully: add,dses,ssdf,brsf,csfg,mnf,abhg,rkg,ungb\n");
      } catch (e) {
        taskPoolOutPutStr += "TaskGroup executed failed: "+ (e as BusinessError).toString()+ "\n";
      }
      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolFunction_003 end');
    })

    /**
     * @tc.number    : TaskPoolSendable_006
     * @tc.name      : TaskPool execute SendableClass task
     * @tc.desc      : Inspection results
     * @tc.size      : MEDIUM
     * @tc.type      : Function
     * @tc.level     : Level 0
     */
    it('TaskPoolSendable_006', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolSendable_001 begin');
      let a: SendableClass = new SendableClass();
      // 定义主线程异步锁sendableTask_lock
      let lock: utils.locks.AsyncLock = utils.locks.AsyncLock.request("testTask_lock");
      let count: number = 0;
      lock.lockAsync(async () => {
        // 主线程调用实例a.data1的方法setCount、getCount
        a.data1.setCount(111);
        count = await a.data1.getCount();
        console.info("this data1 count is: " + await a.data1.getCount());
      })
      let task: taskpool.Task = new taskpool.Task(createSendableData, a);
      let taskPoolOutPutStr1 = '';
      let taskPoolOutPutStr2 = '';
      let taskPoolOutPutStr3 = '';
      let taskPoolOutPutStr4 = '';
      let taskPoolOutPutStr5 = '';
      let taskPoolOutPutStr6 = '';
      let taskPoolOutPutStr7 = '';
      let taskPoolOutPutStr8 = '';

      try {
        await taskpool.execute(task);
        taskPoolOutPutStr1 = "sendableTask execute successfully.";
        // 访问子线程返回的实例a中的各个属性
        taskPoolOutPutStr2 = "Sendable data TestA v1 is: " + a.data1.v1;
        taskPoolOutPutStr3 = "Sendable data TestA v2 is: " + a.data1.v2;
        taskPoolOutPutStr4 = "Sendable data TestA v3 is: " + a.data1.v3;
        taskPoolOutPutStr5 = "Sendable data TestA count is: " + count;
        taskPoolOutPutStr6 = "Sendable data TestB v1 length is: " + a.data2.v1.length;
        taskPoolOutPutStr7 = "Sendable data TestB v2 has key: " + a.data2.v2.has(100);
        taskPoolOutPutStr8 = "Sendable data TestB v3 size is: " + a.data2.v2.size;
      } catch(e) {
        taskPoolOutPutStr1 = "Task execute failed: "+ (e as BusinessError).toString()+ "\n";
      }
      expect(taskPoolOutPutStr1).assertEqual("sendableTask execute successfully.")
      expect(taskPoolOutPutStr2).assertEqual("Sendable data TestA v1 is: 1010")
      expect(taskPoolOutPutStr3).assertEqual("Sendable data TestA v2 is: aaa")
      expect(taskPoolOutPutStr4).assertEqual("Sendable data TestA v3 is: true")
      expect(taskPoolOutPutStr5).assertEqual("Sendable data TestA count is: 111")
      expect(taskPoolOutPutStr6).assertEqual("Sendable data TestB v1 length is: 1000")
      expect(taskPoolOutPutStr7).assertEqual("Sendable data TestB v2 has key: true")
      expect(taskPoolOutPutStr8).assertEqual("Sendable data TestB v3 size is: 1")

      done();
      hilog.info(DOMAIN, TAG, BUNDLE + 'TaskPoolSendable_001 end');
    })
  })
}