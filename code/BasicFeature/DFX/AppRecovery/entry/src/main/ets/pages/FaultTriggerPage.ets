
/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import appRecovery from '@ohos.app.ability.appRecovery';
import testNapi from 'libentry.so'
import { TitleBar } from '../common/TitleBar'

@Entry
@Component
struct FaultTriggerPage {
  storage = LocalStorage.GetShared();
  @State counter: number =  0;
  @State callingAbility : string = "";
  @State launchReason : string = "";
  @State lastExitReason : string = "";

  aboutToAppear() {
    this.counter = this.storage.get<number>("FaultTriggerPageCounter") ?? 0;
    this.callingAbility = this.storage.get<string>("CurrentAbilityName") ?? "UnknownCallingAbility";
    this.launchReason = this.storage.get<string>("launchReason") ?? "Unknown";
    this.lastExitReason = this.storage.get<string>("lastExitReason") ?? "Unknown";
  }

  doHeavyWork() {
    let i = 0;
    while (i < 1000000000) {
      i++;
      let j = 0;
      while (j < 1000000000) {
        j++;
        let k = 0;
        while (k < 1000000000) {
          k++;
        }
      }
    }
  }

  build() {
    Column() {
      Column() {
        Column() {
          Text($r('app.string.current_status'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)

          Row() {
            Text($r('app.string.current_ability'))
              .fontSize(30)
            Text(this.callingAbility)
              .fontSize(30)
          }

          Row() {
            Text($r('app.string.launch_reason'))
              .fontSize(30)
            Text(this.launchReason)
              .fontSize(30)
          }

          Row() {
            Text($r('app.string.last_exit_reason'))
              .fontSize(30)
            Text(this.lastExitReason)
              .fontSize(30)
          }

          Row() {
            Text($r('app.string.click_counter'))
              .fontSize(30)
            Text(this.counter.toString())
              .fontSize(30)
          }

          Button($r('app.string.counter_name'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .onClick(()=> {
              this.counter++;
              this.storage.setOrCreate("FaultTriggerPageCounter", this.counter);
              this.storage.setOrCreate("FaultTriggerPageString", "TestFaultTriggerPageString");
            })
            .margin(5)
        }
        .width('100%')
      }
      .height('35%')
      Column() {
        Column() {
          Text($r('app.string.recover_settings'))
            .fontSize(40)
            .fontWeight(FontWeight.Bold)
            .margin(5)

          Button($r('app.string.save_current_ability_status'))
            .fontSize(30)
            .onClick(()=> {
              appRecovery.saveAppState(globalThis.curActiveAbility.context);
            })
            .margin(5)

          Button($r('app.string.save_all_ability_status'))
            .fontSize(30)
            .onClick(()=> {
              appRecovery.saveAppState();
            })
            .margin(5)

          Button($r('app.string.set_recovery_ability'))
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .onClick(()=> {
              let want = {
                bundleName: "com.samples.recovery",
                abilityName: "RecoveryAbility"
              };
              appRecovery.setRestartWant(want);
            })
            .margin(5)

          Button($r('app.string.route_to_second_ability'))
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
            .onClick(()=> {
              if (globalThis.curActiveAbility == undefined) {
                console.log("Maple curAbility is not exist?");
                return;
              }
              let want = {
                bundleName: "com.samples.recovery",
                abilityName: "SecondAbility"
              };
              globalThis.curActiveAbility.context.startAbility(want);
            })
            .margin(5)
        }
        .height('35%')

        Column() {
          Column() {
            Text($r('app.string.trigger_fault_items'))
              .fontSize(40)
              .fontWeight(FontWeight.Bold)
              .margin(5)

            Button($r('app.string.trigger_js_error'))
              .fontSize(30)
              .onClick(()=> {
                throw new Error("Force Crash");
              })
              .margin(5)

            Button($r('app.string.trigger_freeze_in_js_code'))
              .fontSize(30)
              .onClick(()=> {
                this.doHeavyWork();
              })
              .margin(5)

            Button($r('app.string.trigger_freeze_in_native_code'))
              .fontSize(30)
              .fontWeight(FontWeight.Bold)
              .onClick(()=> {
                let i = 0;
                testNapi.add(1,1);
              })
              .margin(5)
          }
        }
        .height('30%')
      }
    }
  }
}