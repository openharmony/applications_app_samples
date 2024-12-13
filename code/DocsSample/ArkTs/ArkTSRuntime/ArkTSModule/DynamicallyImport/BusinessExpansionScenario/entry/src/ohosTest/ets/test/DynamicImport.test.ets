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

import { describe, it, expect } from '@ohos/hypium';

export default function dynamicImportTest() {
  describe('dynamicImportTest', () => {

    it('testDynamicImport001', 0, async () => {
      console.info('uitest: testDynamicImport001 begin');
      let har: ESObject = await import('harlibrary');
      expect(har.Calc.staticAdd(8, 9)).assertEqual(17);
      let calc: ESObject = new har.Calc();
      expect(calc.instanceAdd(10, 11)).assertEqual(21);
      expect(har.addHarlibrary(6, 7)).assertEqual(13);

      let className = 'Calc';
      let methodName = 'instanceAdd';
      let staticMethod = 'staticAdd';
      let functionName = 'addHarlibrary';
      expect(har[className][staticMethod](12, 13)).assertEqual(25);
      let calc1: ESObject = new har[className]();
      expect(calc1[methodName](14, 15)).assertEqual(29);
      expect(har[functionName](16, 17)).assertEqual(33);
      console.info('uitest: testDynamicImport001 end');
    })
  })
}