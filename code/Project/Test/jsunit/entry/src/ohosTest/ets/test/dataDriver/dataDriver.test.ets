/*
* Copyright (c) 2025 Huawei Device Co., Ltd.
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

// [Start dataDriver_sample]
 import { describe, it } from '@ohos/hypium';

 export default function abilityTest() {
  describe('AbilityTest', () => {
    it('testDataDriverAsync', 0, async (done: Function, data: ParmObj) => {
      console.info('name: ' + data.name);
      console.info('value: ' + data.value);
      done();
    });

    it('testDataDriver', 0, () => {
      console.info('stress test');
    })
  })
}
 interface ParmObj {
   name: string,
   value: string
 }
// [End dataDriver_sample]