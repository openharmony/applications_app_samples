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
 
import { hilog } from '@kit.PerformanceAnalysisKit';

const isConsole = false;
const isHilog = true;
const domain = 0xc000;
const consoleStr = '0xc00C';
const hilogStr = '0xc00H';

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
    console.info(`${domain}/${consoleStr}-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.info(domain, `${hilogStr}-${tag}`, '%{public}s', msg);
  }
}
function emitDebug(tag: string, msg: string): void {
  if (isConsole) {
    console.debug(`${domain}/${consoleStr}-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.debug(domain, `${hilogStr}-${tag}`, '%{public}s', msg);
  }
}
function emitError(tag: string, msg: string): void {
  if (isConsole) {
    console.error(`${domain}/${consoleStr}-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.error(domain, `${hilogStr}-${tag}`, '%{public}s', msg);
  }
}
function emitWarn(tag: string, msg: string): void {
  if (isConsole) {
    console.warn(`${domain}/${consoleStr}-${tag}: ${msg}`);
  }
  if (isHilog) {
    hilog.warn(domain, `${hilogStr}-${tag}`, '%{public}s', msg);
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

let timeLog = initInfo('utils');
let timer: Map<string, number> = new Map<string, number>();
export function logTime(str: string): void {
  let t1: number = new Date().getTime();
  if (timer.has(str)) {
    let t0 = timer.get(str);
    if (t0 === undefined) {
      return;
    }
    timeLog(`${str} end: ${t1}`);
    timeLog(`${str} run time: ${t1 - t0} ms`);
    timer.delete(str);
  } else {
    timer.set(str, t1);
    timeLog(`${str} start: ${t1}`);
  }
}

interface LoggerApi {
  log: LogFn; err: LogFn; info: LogFn; warn: LogFn; debug: LogFn;
  initLog: (str?: string) => LogFn; initErr: (str?: string) => LogFn;
  initInfo: (str?: string) => LogFn; initWarn: (str?: string) => LogFn;
  initDebug: (str?: string) => LogFn;
  logTime: (str: string) => void;
}

export const logger: LoggerApi = {
  log, err, info, warn, debug, initLog, initErr, initInfo, initWarn, initDebug, logTime
};
export { logger as Logger };
