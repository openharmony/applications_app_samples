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
 
// 自定义卡片对象格式
export interface CASES {
  name: string,
  url: string,
  describe: string,
  img: string
}

const CASES_MAX_LENGTH: number = 5; // 卡片展示最大案例数

export class CaseCardUtils {
  // 案例字符串格式化
  public static formatData(data: string) {
    let result: CASES[] = [];
    if (data.indexOf('**下面是详细的案例列表：**') > -1) {
      let casesArray: string[] = data.split('**下面是详细的案例列表：**')[1].split('####');
      for (let i = 1; i <= CASES_MAX_LENGTH; i++) {
        const cases: CASES = {
          name: CaseCardUtils.nameFormat(casesArray[i]),
          url: CaseCardUtils.urlFormat(casesArray[i]),
          describe: CaseCardUtils.introduceFormat(casesArray[i]),
          img: CaseCardUtils.imageFormat(casesArray[i])
        }
        result.push(cases);
      }
    }
    return result;
  }

  // 案例图片地址格式化
  public static imageFormat(casesTexts: string): string {
    let casesText: string = casesTexts;
    let reg1 = /<img\s+[^>]*>/i;
    let reg2 = /\/base\/media\/[^.]*/;
    const matches1 = casesText.match(reg1);
    const matches2 = matches1?.[0].match(reg2);
    casesText = matches2?.[0].replace(/\/base\/media\//, '') || '';
    return casesText;
  }

  // 案例名称格式化
  public static nameFormat(casesText: string): string {
    const part1: string[] = casesText.split('.');
    if (part1.length > 1) {
      const part2: string[] = part1[1].split('（');
      const part3: string[] = part1[1].split('(');
      if (part2.length > 1) {
        return part2[0].trim();
      } else if (part3.length > 1) {
        return part3[0].trim();
      }
    }
    return '';
  }

  // 案例概述格式化
  public static introduceFormat(casesTexts: string): string {
    let casesText: string = casesTexts;
    let reg1 = /\[([^\]]*)]\(([^)]*)\)/g;
    let reg2 = /<img\s+[^>]*>/gi;
    const matches1 = casesText.matchAll(reg1);
    for (const match1 of matches1) {
      casesText = casesText.replace(match1[0], match1[1]);
    }
    const matches2 = casesText.matchAll(reg2);
    for (const match2 of matches2) {
      casesText = casesText.replace(match2[0], '');
    }
    casesText = casesText.replace(/\s+/g, '').replace('详细说明文档', '');
    return casesText;
  }

  // 案例地址格式化
  public static urlFormat(casesText: string): string {
    const part1: string[] = casesText.split('CommonAppDevelopment/feature/');
    const part2: string[] = part1[1]?.split('/') || [];
    if (part2.length > 1) {
      return part2[0].trim();
    }
    return '';
  }
}