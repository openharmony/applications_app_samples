import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
import hilog from "@ohos:hilog";
const DOMAIN_NUMBER = 0xF811;
const TAG = '[Sample_MyApp]';
// [StartExclude  hilogtag]
export default class EntryAbility extends UIAbility {
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        try {
            let value = this.context.resourceManager.getConfigurationSync();
            // 屏幕方向
            let direction = value.direction;
            // 语言文字国家地区
            let locale = value.locale;
        }
        catch (error) {
            hilog.error(DOMAIN_NUMBER, TAG, 'getConfigurationSync error is ' + error);
        }
    }
}
