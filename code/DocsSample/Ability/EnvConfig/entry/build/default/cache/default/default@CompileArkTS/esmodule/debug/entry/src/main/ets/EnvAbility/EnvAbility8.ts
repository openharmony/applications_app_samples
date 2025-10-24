import AbilityStage from "@ohos:app.ability.AbilityStage";
import type { Configuration as Configuration } from "@ohos:app.ability.Configuration";
import hilog from "@ohos:hilog";
const TAG: string = '[MyAbilityStage]';
const DOMAIN_NUMBER: number = 0xFF00;
let systemLanguage: string | undefined; // 系统当前语言
export default class MyAbilityStage extends AbilityStage {
    onCreate(): void {
        systemLanguage = this.context.config.language; // Module首次加载时，获取系统当前语言
        hilog.info(DOMAIN_NUMBER, TAG, `systemLanguage is ${systemLanguage}`);
        //...
    }
    onConfigurationUpdate(newConfig: Configuration): void {
        hilog.info(DOMAIN_NUMBER, TAG, `onConfigurationUpdate, language: ${newConfig.language}`);
        hilog.info(DOMAIN_NUMBER, TAG, `onConfigurationUpdated systemLanguage is ${systemLanguage}, newConfig: ${JSON.stringify(newConfig)}`);
        if (systemLanguage !== newConfig.language) {
            hilog.info(DOMAIN_NUMBER, TAG, `systemLanguage from ${systemLanguage} changed to ${newConfig.language}`);
            systemLanguage = newConfig.language; // 将变化之后的系统语言保存，作为下一次变化前的系统语言
        }
    }
}
