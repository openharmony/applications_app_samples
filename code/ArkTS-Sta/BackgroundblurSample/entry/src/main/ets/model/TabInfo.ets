'use static';
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

import { ResourceStr } from '@ohos.arkui.component';

/**
 * TabBar data type.
 */
export class TabInfo {
  public id: number;
  public title: string | ResourceStr;
  public selectedIcon: ResourceStr;
  public defaultIcon: ResourceStr;

  /**
   * @param id
   * @param title
   * @param selectedIcon
   * @param defaultIcon
   */
  constructor(id: number, title: string | ResourceStr, selectedIcon: ResourceStr, defaultIcon: ResourceStr
  ) {
    this.id = id;
    this.title = title;
    this.selectedIcon = selectedIcon;
    this.defaultIcon = defaultIcon;
  }
}

