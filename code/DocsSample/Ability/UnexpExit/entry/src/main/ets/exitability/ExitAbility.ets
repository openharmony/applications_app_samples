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
// [Start unexp_exit]
import { UIAbility, Want, AbilityConstant } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN_NUMBER = 0xF811;
const TAG  = '[Sample_UnexpExit]';
const MAX_RSS_THRESHOLD: number = 100000;
const MAX_PSS_THRESHOLD: number = 100000;

function doSomething() {
  hilog.info(DOMAIN_NUMBER,TAG,'do Something');
}

function doAnotherThing() {
  hilog.info(DOMAIN_NUMBER,TAG,'do Another Thing');
}

export default class ExitAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 获取退出原因
    let reason: number = launchParam.lastExitReason;
    let subReason: number = -1;
    if (launchParam.lastExitDetailInfo) {
      subReason = launchParam.lastExitDetailInfo.exitSubReason;
    }
    let exitMsg: string = launchParam.lastExitMessage;
    // [StartExclude unexp_exit]
    // [Start unexp_freeze]
    if (reason === AbilityConstant.LastExitReason.APP_FREEZE) {
      // Ability上次因无响应而退出，此处可增加处理逻辑。
      doSomething();
    } else if (reason === AbilityConstant.LastExitReason.SIGNAL && subReason === 9) {
      // Ability上次所在进程因kill -9信号而退出，此处可增加处理逻辑。
      doAnotherThing();
    } else if (reason === AbilityConstant.LastExitReason.RESOURCE_CONTROL) {
      // Ability上次因rss管控而退出，此处可实现处理逻辑，最简单的就是打印出来。
      hilog.info(DOMAIN_NUMBER,TAG,`The ability has exit last because the rss control，the lastExitReason is ${reason}, subReason is ${subReason}, lastExitMessage is ${exitMsg}.`);
    }
    // [End unexp_freeze]
    // [EndExclude unexp_exit]
    if (launchParam.lastExitDetailInfo) {
      // 获取Ability上次退出时所在进程的信息
      let pid = launchParam.lastExitDetailInfo.pid;
      let processName: string = launchParam.lastExitDetailInfo.processName;
      let rss: number = launchParam.lastExitDetailInfo.rss;
      let pss: number = launchParam.lastExitDetailInfo.pss;
      // [StartExclude  unexp_exit]
      // [Start unexp_rss]
      if (rss > MAX_RSS_THRESHOLD || pss > MAX_PSS_THRESHOLD) {
        // RSS或PSS值过大，说明内存使用率接近或达到上限，打印告警，或者增加处理逻辑。
        hilog.warn(DOMAIN_NUMBER,TAG,`Process ${processName}(${pid}) memory usage approaches or reaches the upper limit.`);
      }
      // [End unexp_rss]
      // [EndExclude unexp_exit]
      // 其他信息
      let uid: number = launchParam.lastExitDetailInfo.uid;
      let timestamp: number = launchParam.lastExitDetailInfo.timestamp;
      // [StartExclude  unexp_exit]
      // [Start unexp_uid]
      hilog.info(DOMAIN_NUMBER,TAG,`App ${uid} terminated at ${timestamp}.`);
      // [End unexp_uid]
      // [EndExclude unexp_exit]
    }
  }
}
// [End unexp_exit]