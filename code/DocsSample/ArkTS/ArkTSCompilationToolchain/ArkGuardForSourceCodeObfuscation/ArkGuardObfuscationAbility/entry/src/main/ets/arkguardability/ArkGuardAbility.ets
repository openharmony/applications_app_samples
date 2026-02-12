/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/

// [Start etsOptionExample_keepPropertyName1]
// ArkGuardAbility.ets
import testNapi from 'libentry.so';
// [StartExclude etsOptionExample_keepPropertyName1]

// [Start etsOptionExample_keepPropertyName2]
// ArkGuardAbility.ets
import { UIAbility } from '@kit.AbilityKit';
import { http } from '@kit.NetworkKit';
// [StartExclude etsOptionExample_keepPropertyName2]

// [Start etsOptionExample_keepGlobalName]
// ArkGuardAbility.ets
import { testNapi2, testNapi3 as myNapi } from 'libentry.so'; // testNapi2 和 testNapi3 应该被保留
// [StartExclude etsOptionExample_keepGlobalName]

// [Start etsOptionExample_enablePropertyObfuscation1]
// ArkGuardAbility.ets
@Component struct MyExample {
  @State message: string = "hello";
  data: number[] = [];
  // ...
  build() {
  }
}
// [End etsOptionExample_enablePropertyObfuscation1]

// [Start etsOptionExample_enablePropertyObfuscation2]
@interface MyAnnotation1 {
  authorName: string;
  revision: number = 1;
}
// [End etsOptionExample_enablePropertyObfuscation2]

// [Start etsOptionExample_useKeepInSource]
// 保留被标记的注解声明，MyAnnotation不会被混淆
// @KeepSymbol
@interface MyAnnotation2 {
  // 标记注解成员无效，authorName不会被收集到白名单
  // @KeepSymbol
  authorName: string;
  revision: number = 1;
}
// [End etsOptionExample_useKeepInSource]

// [EndExclude etsOptionExample_keepPropertyName1]
testNapi.addNum(2, 3); // add需要保留，示例如：-keep-property-name add
// [End etsOptionExample_keepPropertyName1]

// [EndExclude etsOptionExample_keepPropertyName2]
export default class EntryAbility extends UIAbility {
  onForeground(): void {
    let httpRequest = http.createHttp();
    httpRequest.request('https://www.example/Login',
      {
        method: http.RequestMethod.POST,
        header: { 'Content-Type': 'application/json' },
        extraData: { usernameTest: 'test1', passwordTest: 'test2'}, // usernameTest 和 passwordTest 需要被保留
      })
  }
}
// [End etsOptionExample_keepPropertyName2]

// [EndExclude etsOptionExample_keepGlobalName]
testNapi2();
myNapi();
// [End etsOptionExample_keepGlobalName]