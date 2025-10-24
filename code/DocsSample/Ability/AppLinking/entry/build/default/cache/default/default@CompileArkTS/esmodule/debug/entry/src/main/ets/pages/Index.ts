if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
}
import hilog from "@ohos:hilog";
import type { BusinessError as BusinessError } from "@ohos:base";
import { GlobalContext } from "@normalized:N&&&entry/src/main/ets/common/GlobalContext&";
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
            Button.createWithLabel('start link', { type: ButtonType.Capsule, stateEffect: true });
            Button.width('87%');
            Button.height('5%');
            Button.margin({ bottom: '12vp' });
            Button.onClick(() => {
                let context = GlobalContext.getContext();
                let link: string = 'https://www.example.com/programs?action=showall';
                // 仅以App Linking的方式打开应用
                context.openLink(link, { appLinkingOnly: true })
                    .then(() => {
                    hilog.info(0x0000, 'testTag', `Succeeded in opening link.`);
                })
                    .catch((error: BusinessError) => {
                    hilog.error(0x0000, 'testTag', `Failed to open link, code: ${error.code}, message: ${error.message}`);
                });
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
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.example.applinking", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
