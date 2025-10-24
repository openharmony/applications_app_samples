import ShareExtensionAbility from "@ohos:app.ability.ShareExtensionAbility";
import ConfigurationConstant from "@ohos:app.ability.ConfigurationConstant";
export default class MyAbility extends ShareExtensionAbility {
    onForeground() {
        let uiExtensionContext = this.context;
        uiExtensionContext.setColorMode(ConfigurationConstant.ColorMode.COLOR_MODE_DARK);
    }
}
