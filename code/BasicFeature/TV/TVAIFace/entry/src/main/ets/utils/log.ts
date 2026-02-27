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

const isConsole: boolean = false;
const isHilog: boolean = true;
const domain: number = 0xc000;
const domainStr: string = "0xc000";
const privateNum: number = 3;

export const log = (tag: string | number = "", log?: string | number) => {
  let Tag: string = 'OH';
  if (tag) {
    if (log) {
      isConsole ?
        console.info(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
      isHilog ?
        hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) : null;
    } else {
      isConsole ?
        console.info(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
      isHilog ?
        hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
    }
  } else {
    if (log) {
      isConsole ?
        console.info(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
      isHilog ?
        hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
    }
  }
};

export const debug = (tag: string | number = "", log?: string | number) => {
  let Tag: string = 'OH';
  if (tag) {
    if (log) {
      isConsole ?
        console.debug(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
      isHilog ?
        hilog.debug(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) : null;
    } else {
      isConsole ?
        console.debug(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
      isHilog ?
        hilog.debug(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
    }
  } else {
    if (log) {
      isConsole ?
        console.debug(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
      isHilog ?
        hilog.debug(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
    }
  }
};

export const info = (tag: string | number = "", log?: string | number) => {
  let Tag: string = 'OH';
  if (tag) {
    if (log) {
      isConsole ?
        console.info(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
      isHilog ?
        hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) : null;
    } else {
      isConsole ?
        console.info(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
      isHilog ?
        hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
    }
  } else {
    if (log) {
      isConsole ?
        console.info(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
      isHilog ?
        hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
    }
  }
};

export const err = (tag: string | number = "", log?: string | number) => {
  let Tag: string = 'OH';
  if (tag) {
    if (log) {
      isConsole ?
        console.error(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
      isHilog ?
        hilog.error(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) : null;
    } else {
      isConsole ?
        console.error(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
      isHilog ?
        hilog.error(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
    }
  } else {
    if (log) {
      isConsole ?
        console.error(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
      isHilog ?
        hilog.error(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
    }
  }
};

export const warn = (tag: string | number = "", log?: string | number) => {
  let Tag: string = 'OH';
  if (tag) {
    if (log) {
      isConsole ?
        console.warn(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
      isHilog ?
        hilog.warn(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) : null;
    } else {
      isConsole ?
        console.warn(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
      isHilog ?
        hilog.warn(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
    }
  } else {
    if (log) {
      isConsole ?
        console.warn(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
      isHilog ?
        hilog.warn(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
    }
  }
};

export const initLog = (str?: string) => {
  let Tag: string = str ? str : 'OH';
  return (tag: string | number = "", log?: string | number) => {
    if (tag) {
      if (log) {
        isConsole ?
          console.info(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
        isHilog ?
          hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) :
          null;
      } else {
        isConsole ?
          console.info(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
        isHilog ?
          hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
      }
    } else {
      if (log) {
        isConsole ?
          console.info(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
        isHilog ?
          hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
      }
    }
  };
};

export const initDebug = (str?: string) => {
  let Tag: string = str ? str : 'OH';
  return (tag: string | number = "", log?: string | number) => {
    if (tag) {
      if (log) {
        isConsole ?
          console.debug(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
        isHilog ?
          hilog.debug(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) :
          null;
      } else {
        isConsole ?
          console.debug(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
        isHilog ?
          hilog.debug(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
      }
    } else {
      if (log) {
        isConsole ?
          console.debug(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
        isHilog ?
          hilog.debug(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
      }
    }
  };
};

export const initInfo = (str?: string) => {
  let Tag: string = str ? str : 'OH';
  return (tag: string | number = "", log?: string | number) => {
    if (tag) {
      if (log) {
        isConsole ?
          console.info(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
        isHilog ?
          hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) :
          null;
      } else {
        isConsole ?
          console.info(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
        isHilog ?
          hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
      }
    } else {
      if (log) {
        isConsole ?
          console.info(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
        isHilog ?
          hilog.info(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
      }
    }
  };
};

export const initErr = (str?: string) => {
  let Tag: string = str ? str : 'OH';
  return (tag: string | number = "", log?: string | number) => {
    if (tag) {
      if (log) {
        isConsole ?
          console.error(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
        isHilog ?
          hilog.error(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) :
          null;
      } else {
        isConsole ?
          console.error(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
        isHilog ?
          hilog.error(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
      }
    } else {
      if (log) {
        isConsole ?
          console.error(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
        isHilog ?
          hilog.error(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
      }
    }
  };
};

export const initWarn = (str?: string) => {
  let Tag: string = str ? str : 'OH';
  return (tag: string | number = "", log?: string | number) => {
    if (tag) {
      if (log) {
        isConsole ?
          console.warn(`${domain}/${domainStr}-C-${Tag}: ${tag} --> ${log}`) : null;
        isHilog ?
          hilog.warn(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag} --> ${log}`, privateNum) :
          null;
      } else {
        isConsole ?
          console.warn(`${domain}/${domainStr}-C-${Tag}: ${tag}`) : null;
        isHilog ?
          hilog.warn(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${tag}`, privateNum) : null;
      }
    } else {
      if (log) {
        isConsole ?
          console.warn(`${domain}/${domainStr}-C-${Tag}: ${log}`) : null;
        isHilog ?
          hilog.warn(domain, `${domainStr}-H-${Tag}`, "%{public}s %{private}d", ` ${log}`, privateNum) : null;
      }
    }
  };
};

export const Logger = {
  log,
  err,
  info,
  warn,
  debug,
  initLog,
  initErr,
  initInfo,
  initWarn,
  initDebug
};