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

// [Start order1_sample]
import { describe, beforeAll, beforeEach, afterEach, afterAll, it, expect, Level } from '@ohos/hypium';

export default function exampleTest() {
  
  describe('order1_sample', () =>{
    let testNumA : number = 1;
    let testNumB : number = 1;
    
    beforeAll(() => {
      testNumA++;
    })
  
    beforeEach(() => {
      testNumA++;
      testNumB++;
    })
 
    afterEach(() => {
      testNumA++;
    })
  
    afterAll(() => {
      let expectValue : number = 5;
      expect(testNumA).assertEqual(expect);
    })
     
    it('testExampleA',Level.LEVEL1, async (done: Function) => {
      let expectA : number = 3;
      let expectB : number = 2;
      expect(testNumA).assertEqual(expectA);
      expect(testNumB).assertEqual(expectB);
      done();
    })

    it('testExampleB',Level.LEVEL1, async (done: Function) => {
      let expectA : number = 5;
      let expectB : number = 3;
      expect(testNumA).assertEqual(expectA);
      expect(testNumB).assertEqual(expectB);
      done();
    })
  })
}
// [End order1_sample]