import type AbilityConstant from "@ohos:app.ability.AbilityConstant";
import UIAbility from "@ohos:app.ability.UIAbility";
import type Want from "@ohos:app.ability.Want";
import hilog from "@ohos:hilog";
import url from "@ohos:url";
export default class EntryAbility extends UIAbility {
    onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
        // 从want中获取传入的链接信息。
        // 如传入的url为：https://www.example.com/programs?action=showall
        let uri = want?.uri;
        if (uri) {
            // 从链接中解析query参数，拿到参数后，开发者可根据自己的业务需求进行后续的处理。
            try {
                let urlObject = url.URL.parseURL(want?.uri);
                let action = urlObject.params.get('action');
                // 例如，当action为showall时，展示所有的节目。
                if (action === 'showall') {
                }
            }
            catch (error) {
                hilog.error(0x0000, 'testTag', `Failed to parse url.`);
            }
        }
    }
}
