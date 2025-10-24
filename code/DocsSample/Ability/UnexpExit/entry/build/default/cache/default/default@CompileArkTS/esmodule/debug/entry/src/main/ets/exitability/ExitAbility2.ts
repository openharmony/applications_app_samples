import UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
import AbilityConstant from "@ohos:app.ability.AbilityConstant";
import hilog from "@ohos:hilog";
const MAX_RSS_THRESHOLD: number = 100000;
const MAX_PSS_THRESHOLD: number = 100000;
const DOMAIN_NUMBER = 0xF811;
const TAG = '[Sample_MyApp]';
function doSomething() {
    hilog.info(DOMAIN_NUMBER, TAG, 'do Something');
}
function doAnotherThing() {
    hilog.info(DOMAIN_NUMBER, TAG, 'do Another Thing');
}
export default class MyAbility extends UIAbility {
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam) {
        // 获取退出原因
        let reason: number = launchParam.lastExitReason;
        let subReason: number = -1;
        if (launchParam.lastExitDetailInfo) {
            subReason = launchParam.lastExitDetailInfo.exitSubReason;
        }
        let exitMsg: string = launchParam.lastExitMessage;
        // [Start quick_start0]
        if (reason === AbilityConstant.LastExitReason.APP_FREEZE) {
            // Ability上次因无响应而退出，此处可增加处理逻辑。
            doSomething();
        }
        else if (reason === AbilityConstant.LastExitReason.SIGNAL && subReason === 9) {
            // Ability上次所在进程因kill -9信号而退出，此处可增加处理逻辑。
            doAnotherThing();
        }
        else if (reason === AbilityConstant.LastExitReason.RESOURCE_CONTROL) {
            // Ability上次因rss管控而退出，此处可实现处理逻辑，最简单的就是打印出来。
            hilog.info(DOMAIN_NUMBER, TAG, `The ability has exit last because the rss control，the lastExitReason is ${reason}, subReason is ${subReason}, lastExitMessage is ${exitMsg}.`);
        }
        // [End quick_start0]
        if (launchParam.lastExitDetailInfo) {
            // 获取Ability上次退出时所在进程的信息
            let pid = launchParam.lastExitDetailInfo.pid;
            let processName: string = launchParam.lastExitDetailInfo.processName;
            let rss: number = launchParam.lastExitDetailInfo.rss;
            let pss: number = launchParam.lastExitDetailInfo.pss;
            // [Start quick_start1]
            if (rss > MAX_RSS_THRESHOLD || pss > MAX_PSS_THRESHOLD) {
                // RSS或PSS值过大，说明内存使用率接近或达到上限，打印告警，或者增加处理逻辑。
                hilog.warn(DOMAIN_NUMBER, TAG, `Process ${processName}(${pid}) memory usage approaches or reaches the upper limit.`);
            }
            // [End quick_start1]
            let uid: number = launchParam.lastExitDetailInfo.uid;
            let timestamp: number = launchParam.lastExitDetailInfo.timestamp;
            // [Start quick_start2]
            hilog.info(DOMAIN_NUMBER, TAG, `App ${uid} terminated at ${timestamp}.`);
            // [End quick_start2]
        }
    }
}
