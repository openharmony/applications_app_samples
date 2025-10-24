import FormExtensionAbility from "@ohos:app.form.FormExtensionAbility";
import type { Configuration as Configuration } from "@ohos:app.ability.Configuration";
import hilog from "@ohos:hilog";
const TAG: string = '[EntryAbility]';
const DOMAIN_NUMBER: number = 0xFF00;
export default class EntryFormAbility extends FormExtensionAbility {
    onConfigurationUpdate(newConfig: Configuration) {
        hilog.info(DOMAIN_NUMBER, TAG, '[EntryFormAbility] onConfigurationUpdate: ' + JSON.stringify(newConfig));
    }
}
