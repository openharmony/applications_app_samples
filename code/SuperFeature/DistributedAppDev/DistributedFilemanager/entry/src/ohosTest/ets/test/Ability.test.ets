/*
 * Copyright (c) 2023 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import AbilityDelegatorRegistry from '@ohos.app.ability.abilityDelegatorRegistry'
import UIAbility from '@ohos.app.ability.UIAbility'
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect } from '@ohos/hypium'
import { Driver, ON, MatchPattern } from '@ohos.UiTest'
import { Logger } from '@ohos/feature-file-manager'

const TIME_OUT = 60000
const fileCopy: string = '-副本';
let ability: UIAbility | undefined = undefined
let abilityDelegator = AbilityDelegatorRegistry.getAbilityDelegator()

const TAG = '[Sample_DistributedFileManager]'

export default function abilityTest() {

  describe('ActsAbilityTest', () => {

    it('StartAbility_001', 0, async (done : () => void) => {
      Logger.info('DF_StartAbility_001 begin');
      try {
        await abilityDelegator.startAbility({
          bundleName: 'com.samples.distributedfilemanager',
          abilityName: 'EntryAbility'
        })
        done();
      } catch (exception) {
        Logger.info(`StartAbility_001 exception = ${JSON.stringify(exception)}`);
        expect().assertFail();
      }
      let onAbilityCreateCallback: () => void = (): void => {
        Logger.info("onAbilityCreateCallback");
      }
      let monitor: AbilityDelegatorRegistry.AbilityMonitor = {
        abilityName: "EntryAbility",
        onAbilityCreate: onAbilityCreateCallback
      };
      ability = await abilityDelegator.waitAbilityMonitor(monitor, TIME_OUT);
      Logger.info('StartAbility_001 end');
    })

    /**
     * 获取权限
     */
    it('RequestPermissionFunction_001', 0, async () => {
      Logger.info(TAG, 'RequestPermissionFunction begin');
      let driver = Driver.create();
      await driver.delayMs(2000);
      // 获取文件读写权限
      Logger.info(TAG, 'RequestPermissionFunction requestPermission');
      await driver.assertComponentExist(ON.text("允许"));
      let btnStart = await driver.findComponent(ON.text("允许"));
      await btnStart.click();
      Logger.info(TAG, 'RequestPermissionFunction end');
    })

    //测试文件夹的拷贝 test2拷贝至test1
    it('DF_copy_dir_001', 1, async () => {
      Logger.info('DF_copy_dir_001 begin');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.type('List'));
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem0'));
      let selectStatus = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await selectStatus.longClick();
      await driver.delayMs(200);

      let selectTest2 = await driver.findComponent(ON.type('ListItem').id('ListItem1'));
      await selectTest2.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('pasteBoard'));
      let pasteBoard = await driver.findComponent(ON.id('pasteBoard'));
      await pasteBoard.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('cancel'));
      let cancel = await driver.findComponent(ON.id('cancel'));
      await cancel.click();
      await driver.delayMs(200);

      let toTest1 = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await toTest1.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('copy'));
      let copy = await driver.findComponent(ON.id('copy'));
      await copy.click();
      await driver.delayMs(1000);

      //点击返回再进来确认，因为回调函数不一定调成功
      let left = await driver.findComponent(ON.id('left'));
      await left.click();
      await driver.delayMs(1000);
      let inTest1 = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await inTest1.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('test2'));
    })


    //测试文件的拷贝 test1中的file1.txt拷贝至test2
    it('DF_copy_file_001', 1, async () => {
      Logger.info('DF_copy_file_001 begin');
      let driver = Driver.create();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.type('List'));
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem0'));
      let selectStatus = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await selectStatus.longClick();
      await driver.delayMs(200);

      let selectFile1 = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await selectFile1.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('pasteBoard'));
      let pasteBoard = await driver.findComponent(ON.id('pasteBoard'));
      await pasteBoard.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('cancel'));
      let cancel = await driver.findComponent(ON.id('cancel'));
      await cancel.click();
      await driver.delayMs(200);

      //点击返回
      let left = await driver.findComponent(ON.id('left'));
      await left.click();
      await driver.delayMs(500);

      let inTest2 = await driver.findComponent(ON.type('ListItem').id('ListItem1'));
      await inTest2.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('copy'));
      let copy = await driver.findComponent(ON.id('copy'));
      await copy.click();
      await driver.delayMs(1000);
    })

    //确认上一步的文件拷贝成功
    it('DF_copy_file_002', 1, async () => {
      Logger.info('DF_copy_file_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      //点击返回再进来确认，因为回调函数不一定调成功
      let left2 = await driver.findComponent(ON.id('left'));
      await left2.click();
      await driver.delayMs(1000);
      let inTest1 = await driver.findComponent(ON.type('ListItem').id('ListItem1'));
      await inTest1.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('file1.txt'));
    })

    //测试本地文件拷贝有重名时的场景
    it('DF_rename_file_001', 1, async () => {
      Logger.info('DF_rename_file_001 begin');
      let driver = Driver.create();
      await driver.delayMs(200);

      //点击返回
      let left0 = await driver.findComponent(ON.id('left'));
      await left0.click();
      await driver.delayMs(500);

      let toTest1 = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await toTest1.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.type('List'));
      await driver.assertComponentExist(ON.type('ListItem').id('ListItem0'));
      let selectStatus = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await selectStatus.longClick();
      await driver.delayMs(200);

      let selectFile1 = await driver.findComponent(ON.type('ListItem').id('ListItem0'));
      await selectFile1.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('pasteBoard'));
      let pasteBoard = await driver.findComponent(ON.id('pasteBoard'));
      await pasteBoard.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('cancel'));
      let cancel = await driver.findComponent(ON.id('cancel'));
      await cancel.click();
      await driver.delayMs(200);

      //点击返回
      let left = await driver.findComponent(ON.id('left'));
      await left.click();
      await driver.delayMs(500);

      let inTest2 = await driver.findComponent(ON.type('ListItem').id('ListItem1'));
      await inTest2.click();
      await driver.delayMs(200);

      await driver.assertComponentExist(ON.id('copy'));
      let copy = await driver.findComponent(ON.id('copy'));
      await copy.click();
      await driver.delayMs(1000);
    })

    //确认上一步拷贝的文件重命名成功
    it('DF_rename_file_002', 1, async () => {
      Logger.info('DF_rename_file_002 begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      //点击返回再进来确认，防止回调函数有时调不到的情况
      let left2 = await driver.findComponent(ON.id('left'));
      await left2.click();
      await driver.delayMs(1000);
      let inTest1 = await driver.findComponent(ON.type('ListItem').id('ListItem1'));
      await inTest1.click();
      await driver.delayMs(200);
      await driver.assertComponentExist(ON.text('file1'+fileCopy+'.txt'));
    })
  })
}
