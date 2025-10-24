if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
}
import type common from "@ohos:app.ability.common";
import type Want from "@ohos:app.ability.Want";
import type { BusinessError as BusinessError } from "@ohos:base";
import hilog from "@ohos:hilog";
const TAG: string = '[UIAbilityComponentsOpenLink]';
const DOMAIN_NUMBER: number = 0xFF00;
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('start ability', { type: ButtonType.Capsule, stateEffect: true });
            Button.width('87%');
            Button.height('5%');
            Button.margin({ bottom: '12vp' });
            Button.onClick(() => {
                let context = this.getUIContext().getHostContext() as common.UIAbilityContext;
                let want: Want = {
                    uri: 'link://www.example.com'
                };
                try {
                    context.startAbility(want).then(() => {
                        hilog.info(DOMAIN_NUMBER, TAG, 'startAbility success.');
                    }).catch((err: BusinessError) => {
                        hilog.error(DOMAIN_NUMBER, TAG, `startAbility failed. Code is ${err.code}, message is ${err.message}`);
                    });
                }
                catch (paramError) {
                    hilog.error(DOMAIN_NUMBER, TAG, `Failed to start ability. Code is ${paramError.code}, message is ${paramError.message}`);
                }
            });
        }, Button);
        Button.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.pulllinking", moduleName: "entry", pagePath: "pages/DeepStartIndex", pageFullPath: "entry/src/main/ets/pages/DeepStartIndex", integratedHsp: "false", moduleType: "followWithHap" });
