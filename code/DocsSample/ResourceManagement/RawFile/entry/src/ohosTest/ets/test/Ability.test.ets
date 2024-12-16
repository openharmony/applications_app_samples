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
 */

import { hilog } from '@kit.PerformanceAnalysisKit';
import { describe, expect, it } from '@ohos/hypium';
import { UIAbility } from '@kit.AbilityKit';
import { abilityDelegatorRegistry, Driver, ON } from '@kit.TestKit';

const TAG = '[Sample_rawfile]';
const DOMAIN = 0xF811;
const BUNDLE = 'com.samples.rawfile';
const delegator = abilityDelegatorRegistry.getAbilityDelegator();

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function abilityTest() {
  describe('RawFileTest', () => {
it('StartAbility_001', 0, async (done: Function) => {
      console.info("uitest: StartAbility_001 begin");
      const want: Want = {
        bundleName: BUNDLE,
        abilityName: 'EntryAbility',
      };
      await delegator.startAbility(want);
      await sleep(3000);
      const ability: UIAbility = await delegator.getCurrentTopAbility();
      expect(ability.context.abilityInfo.name).assertEqual('EntryAbility');
      done();
      console.info("uitest: StartAbility_001 end");
    });
    
    it(BUNDLE + 'clickTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'clickTest begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let Textbutton = await driver.findComponent(ON.id('hello_world'));
      Textbutton.click();
      await sleep(3000);
      hilog.info(DOMAIN, TAG, BUNDLE + 'clickTest end');
      done();
    })

    it(BUNDLE + 'getRawFileTest_001', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFileListTest begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let fileListText = await driver.findComponent(ON.id('get_file_list'));
      expect(await fileListText.getText() === 'FileList = rawfile.txt,rawfile1.txt,subrawfile').assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetFileListTest end');
      done();
    })

    it(BUNDLE + 'getRawFileTest_002', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'IsRawDirTest begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let rawDirText = await driver.findComponent(ON.id('is_raw_dir'));
      expect(await rawDirText.getText() === 'isRawDir = true').assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'IsRawDirTest end');
      done();
    })

    it(BUNDLE + 'getRawFileTest_003', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentTest begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let fileContentText = await driver.findComponent(ON.id('get_raw_file_content'));
      expect(await fileContentText.getText() === 'RawFileContent = 115,100,103,100,102,103').assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileContentTest end');
      done();
    })

    it(BUNDLE + 'getRawFileTest_004', 0, async (done: Function) => {
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileDescriptor begin');
      let driver = Driver.create();
      await driver.delayMs(1000);
      let fileDescriptorText = await driver.findComponent(ON.id('get_raw_file_descriptor'));
      expect(await fileDescriptorText.getText() === 'RawFileDescriptor.length = 6').assertTrue();
      hilog.info(DOMAIN, TAG, BUNDLE + 'GetRawFileDescriptor end');
      done();
    })
  })
}