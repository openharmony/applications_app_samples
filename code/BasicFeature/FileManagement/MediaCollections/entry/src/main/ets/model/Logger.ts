/*
 * Copyright (c) 2022-2024 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';

type ArgsType = string | number;
const DEFAULT_DOMAIN_VALUE: number = 0xFF00;

class Logger {
  private domain: number;
  private prefix: string;
  private format: string;

  constructor(domain: number = DEFAULT_DOMAIN_VALUE, prefix: string = '[Sample_MediaCollections]', format: string = '%{public}s') {
    this.domain = domain;
    this.prefix = prefix;
    this.format = format;
  }

  /**
   * 根据传参修改 format
   * @param args
   * @returns
   */
  changeFormat(args: ArgsType[]): boolean {
    if (!args?.length) { // 未传参数
      args = ['[No Parameter]'];
      hilog.warn(this.domain, this.prefix, this.format, args);
      return false;
    }

    let strTmp: string = '%{public}s';
    let numTmp: string = '%{public}d';
    let separator: string = ',';
    let tmpStr: string = '';

    for (let i: number = 0; i < args.length; i++) {
      if (args.length === 1 || i === args.length - 1) {
        tmpStr += typeof args[i] === 'string' ? strTmp : numTmp;
      } else {
        tmpStr += (typeof args[i] === 'string' ? strTmp : numTmp) + separator;
      }
    }
    this.format = tmpStr;
    return true;
  }

  debug(tag: string, ...args: ArgsType[]): void {
    if (!this.changeFormat(args)) {
      return;
    }
    hilog.debug(this.domain, `${this.prefix}-${tag}`, this.format, args);
  }

  info(tag: string, ...args: ArgsType[]): void {
    if (!this.changeFormat(args)) {
      return;
    }
    hilog.info(this.domain, `${this.prefix}-${tag}`, this.format, args);
  }

  warn(tag: string, ...args: ArgsType[]): void {
    if (!this.changeFormat(args)) {
      return;
    }
    hilog.warn(this.domain, `${this.prefix}-${tag}`, this.format, args);
  }

  error(tag: string, ...args: ArgsType[]): void {
    if (!this.changeFormat(args)) {
      return;
    }
    hilog.error(this.domain, `${this.prefix}-${tag}`, this.format, args);
  }

  fatal(tag: string, ...args: ArgsType[]): void {
    if (!this.changeFormat(args)) {
      return;
    }
    hilog.fatal(this.domain, `${this.prefix}-${tag}`, this.format, args);
  }
}

export default new Logger();