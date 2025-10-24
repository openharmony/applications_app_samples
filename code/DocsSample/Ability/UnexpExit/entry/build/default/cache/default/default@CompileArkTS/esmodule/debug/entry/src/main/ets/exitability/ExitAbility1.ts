import UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import hilog from "@ohos:hilog";
const DOMAIN_NUMBER = 0xF811;
const TAG = '[Sample_MyApp]';
// [EndExclude  hilogtag]
const MAX_RSS_THRESHOLD: number = 100000;
const MAX_PSS_THRESHOLD: number = 100000;
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
