/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
 * 执行动作数据
 */
export default class ActionItem {
  public id: string = '';
  public name: string = '';
  public type: string = '';
  public check: boolean = false;

  constructor(id: string, name: string, type: string, check: false) {
    this.id = id;
    this.name = name;
    this.type = type;
    this.check = check;
  }
};
