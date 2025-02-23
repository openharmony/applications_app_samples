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

/**
 * 列表信息，包括图标、名字、是否可见
 * icon: 列表项图标
 * name: 列表项名称
 */
@Observed
export class ListInfo {
  public icon: ResourceStr = '';
  public name: ResourceStr = '';

  constructor(icon: ResourceStr = '', name: ResourceStr = '') {
    this.icon = icon;
    this.name = name;
  }
}