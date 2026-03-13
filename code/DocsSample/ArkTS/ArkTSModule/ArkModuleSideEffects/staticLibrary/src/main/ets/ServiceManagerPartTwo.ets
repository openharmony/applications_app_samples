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

// [Start export_serviceManagerPartTwo]
// har/src/main/ets/ServiceManagerPartTwo.ets
class ServiceManager {
  public inited: boolean = false;

  public init() {
    this.inited = true;
  }
  public print() {
    if (this.inited) {
      console.info('ServiceManager is inited.');
    } else {
      console.error('ServiceManager is not inited.');
    }
  }
}
export let serviceManager: ServiceManager = new ServiceManager();
// [End export_serviceManagerPartTwo]