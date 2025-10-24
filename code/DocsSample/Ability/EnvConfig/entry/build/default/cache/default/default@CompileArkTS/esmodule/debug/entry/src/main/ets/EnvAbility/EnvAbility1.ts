import UIAbility from "@ohos:app.ability.UIAbility";
import type window from "@ohos:window";
export default class MyAbility extends UIAbility {
    onWindowStageCreate(windowStage: window.WindowStage) {
        windowStage.loadContent('pages/Index', (err, data) => {
            if (err.code) {
                return;
            }
        });
        let applicationContext = this.context.getApplicationContext();
        applicationContext.setFontSizeScale(2);
    }
}
