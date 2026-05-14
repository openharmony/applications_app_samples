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

export const log = (tag: string|number = '', log?: string|number)=> {
    let label = 'OH';
    if(tag){
        if(log) {
                isConsole?
            console.info(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                isHilog?
            hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
        }else{
                isConsole?
            console.info(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                isHilog?
            hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
        }
    }else{
        if(log) {
                isConsole?
            console.info(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                isHilog?
            hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
        }
    }
}

export const debug = (tag: string|number = '', log?: string|number)=> {
    let label = 'OH';
    if(tag){
        if(log) {
                isConsole?
            console.debug(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                isHilog?
            hilog.debug(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
        }else{
                isConsole?
            console.debug(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                isHilog?
            hilog.debug(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
        }
    }else{
        if(log) {
                isConsole?
            console.debug(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                isHilog?
            hilog.debug(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
        }
    }
}

export const info = (tag: string|number = '', log?: string|number)=> {
    let label = 'OH';
    if(tag){
        if(log) {
                isConsole?
            console.info(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                isHilog?
            hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
        }else{
                isConsole?
            console.info(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                isHilog?
            hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
        }
    }else{
        if(log) {
                isConsole?
            console.info(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                isHilog?
            hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
        }
    }
}

export const err = (tag: string|number = '', log?: string|number)=> {
    let label = 'OH';
    if(tag){
        if(log) {
                isConsole?
            console.error(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                isHilog?
            hilog.error(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
        }else{
                isConsole?
            console.error(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                isHilog?
            hilog.error(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
        }
    }else{
        if(log) {
                isConsole?
            console.error(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                isHilog?
            hilog.error(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
        }
    }
}

export const warn = (tag: string|number = '', log?: string|number)=> {
    let label = 'OH';
    if(tag){
        if(log) {
                isConsole?
            console.warn(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                isHilog?
            hilog.warn(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
        }else{
                isConsole?
            console.warn(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                isHilog?
            hilog.warn(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
        }
    }else{
        if(log) {
                isConsole?
            console.warn(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                isHilog?
            hilog.warn(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
        }
    }
}

export const initLog = (str?:string) => {
    let label = str?str:'OH';
    return (tag: string|number = '', log?: string|number)=> {
        if(tag){
            if(log) {
                    isConsole?
                console.info(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                    isHilog?
                hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
            }else{
                    isConsole?
                console.info(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                    isHilog?
                hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
            }
        }else{
            if(log) {
                    isConsole?
                console.info(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                    isHilog?
                hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
            }
        }
    }
}

export const initDebug = (str?:string) => {
    let label = str?str:'OH';
    return (tag: string|number = '', log?: string|number)=> {
        if(tag){
            if(log) {
                    isConsole?
                console.debug(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                    isHilog?
                hilog.debug(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
            }else{
                    isConsole?
                console.debug(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                    isHilog?
                hilog.debug(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
            }
        }else{
            if(log) {
                    isConsole?
                console.debug(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                    isHilog?
                hilog.debug(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
            }
        }
    }
}

export const initInfo = (str?:string) => {
    let label = str?str:'OH';
    return (tag: string|number = '', log?: string|number)=> {
        if(tag){
            if(log) {
                    isConsole?
                console.info(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                    isHilog?
                hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
            }else{
                    isConsole?
                console.info(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                    isHilog?
                hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
            }
        }else{
            if(log) {
                    isConsole?
                console.info(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                    isHilog?
                hilog.info(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
            }
        }
    }
}

export const initErr = (str?:string) => {
    let label = str?str:'OH';
    return (tag: string|number = '', log?: string|number)=> {
        if(tag){
            if(log) {
                    isConsole?
                console.error(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                    isHilog?
                hilog.error(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
            }else{
                    isConsole?
                console.error(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                    isHilog?
                hilog.error(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
            }
        }else{
            if(log) {
                    isConsole?
                console.error(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                    isHilog?
                hilog.error(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
            }
        }
    }
}

export const initWarn = (str?:string) => {
    let label = str?str:'OH';
    return (tag: string|number = '', log?: string|number)=> {
        if(tag){
            if(log) {
                    isConsole?
                console.warn(`${domain}/${domainStr}-C-${label}: ${tag} -> ${log}`):null;
                    isHilog?
                hilog.warn(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag} -> ${log}`):null;
            }else{
                    isConsole?
                console.warn(`${domain}/${domainStr}-C-${label}: ${tag}`):null;
                    isHilog?
                hilog.warn(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${tag}`):null;
            }
        }else{
            if(log) {
                    isConsole?
                console.warn(`${domain}/${domainStr}-C-${label}: ${log}`):null;
                    isHilog?
                hilog.warn(domain, `${domainStr}-H-${label}`, '%{public}s', ` ${log}`):null;
            }
        }
    }
}

interface LoggerType {
  log: (tag: string|number, log?: string|number) => void;
  err: (tag: string|number, log?: string|number) => void;
  info: (tag: string|number, log?: string|number) => void;
  warn: (tag: string|number, log?: string|number) => void;
  debug: (tag: string|number, log?: string|number) => void;
  initLog: (str?: string) => (tag: string|number, log?: string|number) => void;
  initErr: (str?: string) => (tag: string|number, log?: string|number) => void;
  initInfo: (str?: string) => (tag: string|number, log?: string|number) => void;
  initWarn: (str?: string) => (tag: string|number, log?: string|number) => void;
  initDebug: (str?: string) => (tag: string|number, log?: string|number) => void;
}

export const logger: LoggerType = { log, err, info, warn, debug, initLog, initErr, initInfo, initWarn, initDebug };