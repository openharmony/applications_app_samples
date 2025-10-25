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

// [Start monitor_limitation_callback_wireless_loop]
@ObservedV2
class Info {
  @Trace public count: number = 0;

  @Monitor('count')
  onCountChange(monitor: IMonitor) {
    this.count++; // 应避免这种写法，会导致无限循环
  }
}
// [End monitor_limitation_callback_wireless_loop]