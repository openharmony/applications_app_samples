/*
* Copyright (C) 2024 Huawei Device Co., Ltd.
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
export function harInit(path: string): void{
  // 动态引入要跳转的页面
  switch (path) {
    case "./src/main/ets/components/mainpage/page1":
      import("./src/main/ets/components/mainpage/page1");
      break;
    case "./src/main/ets/components/mainpage/page2":
      import("./src/main/ets/components/mainpage/page2");
      break;
    case "./src/main/ets/components/mainpage/page3":
      import("./src/main/ets/components/mainpage/page3");
      break;
    default:
      break;
  }
}
