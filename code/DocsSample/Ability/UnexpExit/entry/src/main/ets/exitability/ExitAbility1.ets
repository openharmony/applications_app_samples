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
  hilog.info(DOMAIN_NUMBER, TAG, 'do Something');
}

function doAnotherThing() {
  hilog.info(DOMAIN_NUMBER, TAG, 'do Another Thing');
}

export default class ExitAbility1 extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
    // 获取退出原因
    let reason: number = launchParam.lastExitReason;
    let subReason: number = -1;
    if (launchParam.lastExitDetailInfo) {
      subReason = launchParam.lastExitDetailInfo.exitSubReason;
    }
    let exitMsg: string = launchParam.lastExitMessage;

    if (launchParam.lastExitDetailInfo) {
      // 获取Ability上次退出时所在进程的信息
      let pid = launchParam.lastExitDetailInfo.pid;
      let processName: string = launchParam.lastExitDetailInfo.processName;
      let rss: number = launchParam.lastExitDetailInfo.rss;
      let pss: number = launchParam.lastExitDetailInfo.pss;
      // 其他信息
      let uid: number = launchParam.lastExitDetailInfo.uid;
      let timestamp: number = launchParam.lastExitDetailInfo.timestamp;
    }
  }
}
// [End unexp_exit]