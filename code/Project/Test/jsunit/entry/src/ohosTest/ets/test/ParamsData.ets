/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
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

/*
** API12中 在TestAbility中导入json文件编译失败,使用函数的方式构造如下对象数据
{
  "suites": [{
    "describe": ["paramExampleTest"],
    "stress": 4,
    "params": {
      "suiteParams1": "suiteParams001",
      "suiteParams2": "suiteParams002"
    },
    "items": [{
      "it": "testDataDriverAsync"
    },
      {
        "it": "testDataDriverParam",
        "stress": 2,
        "params":[
          {
            "ts1": "ts1",
            "ts2": "ts2"
          }
        ]
      }]
  }]
}
 */

interface ItType {
  it: string,
  stress?: number,
  params?: [Object]
}

interface SuiteType {
  describe: Array<string>,
  stress: number,
  params: Object,
  items: Array<ItType>
}

interface AllDataType {
  suites: Array<SuiteType>;
}

interface ItParamType {
  ts1: string,
  ts2: string
}

interface SuiteParmaType {
  suiteParams1: string,
  suiteParams2: string
}

export default function getParamsData() {
  let testDataDriverAsyncIt: ItType = {
    it: "ItType",
  }

  let testDataDriverParam: ItParamType = {
    ts1: "ts1",
    ts2: "ts2"
  }

  let testDataDriverParamIt: ItType = {
    it: "testDataDriverParam",
    stress: 2,
    params: [testDataDriverParam]
  }

  let items = [testDataDriverAsyncIt, testDataDriverParamIt];
  let suiteParam: SuiteParmaType = {
    suiteParams1: "suiteParams001",
    suiteParams2: "suiteParams002"
  }
  let suite: SuiteType = {
    describe: ["paramExampleTest"],
    stress: 4,
    params: suiteParam,
    items: items
  }

  let data: AllDataType = {
    suites: [suite]
  }
  return data;
}