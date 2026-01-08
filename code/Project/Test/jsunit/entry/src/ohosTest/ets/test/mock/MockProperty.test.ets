/*
* Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start mockProperty_sample]
import { describe, it, expect, MockKit, when, ArgumentMatchers } from '@ohos/hypium';

class ClassName {
  constructor() {
  }
  data = 1;
  private priData = 2;
  method() {
    return this.priData;
  }
}

export default function staticTest() {
  describe('propertyTest', () => {
    it('property_001', 0, () => {
      let claser: ClassName = new ClassName(); 
      let data = claser.data;
      expect(data).assertEqual(1);
      let priData = claser.method();
      expect(priData).assertEqual(2);
      // 1.创建MockKit对象
      let mocker: MockKit = new MockKit();
      // 2.Mock类ClassName对象的成员变量data
      mocker.mockProperty(claser, "data", 3);
      mocker.mockProperty(claser, "priData", 4);
      // 3.期望被Mock后的成员和私有成员的值分别为3，4
      let mock_result = claser.data;
      let mock_private_result = claser.method();
      expect(mock_result).assertEqual(3);
      expect(mock_private_result).assertEqual(4);
      // 清除Mock能力
      mocker.ignoreMock(claser, "data");
      mocker.ignoreMock(claser, "priData");
      let really_result = claser.data;
      expect(really_result).assertEqual(1);
      let really_private_result = claser.method();
      expect(really_private_result).assertEqual(2);
    })
  })
}

// [End mockProperty_sample]