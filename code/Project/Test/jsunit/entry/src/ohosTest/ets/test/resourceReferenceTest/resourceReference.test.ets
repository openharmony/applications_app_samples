/*
* Copyright (c) 2023-2024 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License")
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

import { describe, it, expect } from '@ohos/hypium';
import { abilityDelegatorRegistry } from '@kit.TestKit';
import { Want } from '@kit.AbilityKit';
import fs from '@ohos.file.fs';
import buffer from '@ohos.buffer';

const delegator = abilityDelegatorRegistry.getAbilityDelegator();
const bundleName = abilityDelegatorRegistry.getArguments().bundleName;

function sleep(time: number) {
  return new Promise<void>((resolve: Function) => setTimeout(resolve, time));
}

export default function resourceReferenceTest() {
  describe('resourceReferenceTest', () => {
    /**
     * @tc.number: testResourceReference_001
     * @tc.name: testResourceReference
     * @tc.desc: 在ohosTest测试用例中获取资源文件，资源文件存储在 ohosTest/resources/resfile 下，用例执行过程中保持屏幕开启，否则无法获取到topAbility
     */
    it('testResourceReference', 0, async (done: Function) => {
      console.info("uitest: TestUiExample begin");
      const want: Want = {
        bundleName: bundleName,
        abilityName: 'TestAbility'
      };
      await delegator.startAbility(want);
      await sleep(1000);
      // 获取当前top的ability
      let topAbility = await delegator.getCurrentTopAbility();
      expect(topAbility.context.abilityInfo.name).assertEqual('TestAbility');
      // 获取资源文件路径，并读取文件
      let resDir = topAbility.context.resourceDir;
      expect(resDir != '').assertTrue();
      let resFileList = await fs.listFile(resDir);
      expect(resFileList).assertContain('test.txt');
      let filePath = resDir + "/test.txt";
      let file = fs.openSync(filePath, fs.OpenMode.READ_ONLY);
      let arrayBuffer = new ArrayBuffer(4096);
      let readLen = await fs.read(file.fd, arrayBuffer);
      expect(readLen != 0).assertTrue();
      let buf = buffer.from(arrayBuffer, 0, readLen);
      expect(buf.toString()).assertEqual('Resource Reference Test');
      done();
    })
  })
}