import UIAbility from "@ohos:app.ability.UIAbility";
import ConfigurationConstant from "@ohos:app.ability.ConfigurationConstant";
import hilog from "@ohos:hilog";
import type window from "@ohos:window";
export default class MyAbility extends UIAbility {
    onWindowStageCreate(windowStage: window.WindowStage) {
        windowStage.loadContent('pages/Index', (err, data) => {
            if (err.code) {
                hilog.error(0x0000, 'testTag', 'Failed to load the content.');
                return;
            }
            let applicationContext = this.context.getApplicationContext();
            applicationContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
        });
    }
}
