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

class CountryCodeItem {
  public name: Resource | string;
  public pattern: RegExp;
  public code: string;

  constructor(name: Resource | string, pattern: RegExp, code: string) {
    this.name = name;
    this.pattern = pattern;
    this.code = code;
  }
}

export class CountryCodeConfig {
  public static countryCodeConfig: CountryCodeItem[] =
    [new CountryCodeItem($r('app.string.China'), /^(\+?0?86\-?)?1[345789]\d{9}$/, '+86'),
      new CountryCodeItem($r('app.string.Taiwan'), /^(\+?886\-?|0)?9\d{8}$/, '+886'),
      new CountryCodeItem($r('app.string.Hong_Kong'), /^(\+?852\-?)?[569]\d{3}\-?\d{4}$/, '+852'),
    ];
}