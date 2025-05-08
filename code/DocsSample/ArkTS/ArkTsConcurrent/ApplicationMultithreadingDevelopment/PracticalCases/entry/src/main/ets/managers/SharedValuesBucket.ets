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

// [Start define_data_format]
export interface IValueBucket {
  id: number;
  name: string;
  age: number;
  salary: number;
}

@Sendable
export class SharedValuesBucket implements IValueBucket {
  public id: number = 0;
  public name: string = '';
  public age: number = 0;
  public salary: number = 0;

  constructor(v: IValueBucket) {
    this.id = v.id;
    this.name = v.name;
    this.age = v.age;
    this.salary = v.salary;
  }
}
// [End define_data_format]