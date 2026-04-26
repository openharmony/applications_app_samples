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
 
/* eslint-disable */
import { hilog } from '@kit.PerformanceAnalysisKit';

const isConsole = false;
const isHilog = true;
const domain = 0xc000;
const domainStr = '0xc000';

type LogArg = string | number;
type LogFn = (tag?: LogArg, log?: LogArg) => void;

function normalizeTag(tagArg?: LogArg): string {
  if (tagArg === undefined || tagArg === '') {
    return 'OH';
  }
  return String(tagArg);
}

function normalizeMsg(tag: string, msg?: LogArg): string {
  return msg === undefined || msg === '' ? tag : `${tag} -> ${String(msg)}`;
}

function emitInfo(tag: string, msg: string): void {
  if (isConsole) {
    console.info(`${domain}/${domainStr}-C-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.info(domain, `${domainStr}-H-${tag}`, '%{public}s', ` ${msg}`);
  }
}
function emitDebug(tag: string, msg: string): void {
  if (isConsole) {
    console.debug(`${domain}/${domainStr}-C-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.debug(domain, `${domainStr}-H-${tag}`, '%{public}s', ` ${msg}`);
  }
}
function emitError(tag: string, msg: string): void {
  if (isConsole) {
    console.error(`${domain}/${domainStr}-C-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.error(domain, `${domainStr}-H-${tag}`, '%{public}s', ` ${msg}`);
  }
}
function emitWarn(tag: string, msg: string): void {
  if (isConsole) {
    console.warn(`${domain}/${domainStr}-C-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.warn(domain, `${domainStr}-H-${tag}`, '%{public}s', ` ${msg}`);
  }
}

function make(defaultTag: string, emit: (tag: string, msg: string) => void): LogFn {
  return (tagArg?: LogArg, msgArg?: LogArg) => {
    const t = tagArg === undefined || tagArg === '' ? defaultTag : String(tagArg);
    emit(t, normalizeMsg(t, msgArg));
  };
}

export const log: LogFn = (tagArg?: LogArg, msgArg?: LogArg) => {
  const t = normalizeTag(tagArg);
  emitInfo(t, normalizeMsg(t, msgArg));
};
export const debug: LogFn = (tagArg?: LogArg, msgArg?: LogArg) => {
  const t = normalizeTag(tagArg);
  emitDebug(t, normalizeMsg(t, msgArg));
};
export const info: LogFn = log;
export const err: LogFn = (tagArg?: LogArg, msgArg?: LogArg) => {
  const t = normalizeTag(tagArg);
  emitError(t, normalizeMsg(t, msgArg));
};
export const warn: LogFn = (tagArg?: LogArg, msgArg?: LogArg) => {
  const t = normalizeTag(tagArg);
  emitWarn(t, normalizeMsg(t, msgArg));
};

export const initLog = (str?: string): LogFn => make(str || 'OH', emitInfo);
export const initDebug = (str?: string): LogFn => make(str || 'OH', emitDebug);
export const initInfo = (str?: string): LogFn => make(str || 'OH', emitInfo);
export const initErr = (str?: string): LogFn => make(str || 'OH', emitError);
export const initWarn = (str?: string): LogFn => make(str || 'OH', emitWarn);

interface LoggerApi {
  log: LogFn; err: LogFn; info: LogFn; warn: LogFn; debug: LogFn;
  initLog: (str?: string) => LogFn; initErr: (str?: string) => LogFn;
  initInfo: (str?: string) => LogFn; initWarn: (str?: string) => LogFn;
  initDebug: (str?: string) => LogFn;
}

export const logger: LoggerApi = {
  log, err, info, warn, debug, initLog, initErr, initInfo, initWarn, initDebug
};
export { logger as Logger };
