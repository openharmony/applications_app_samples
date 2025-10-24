if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Page_UIAbilityComponentsInteractive_Params {
    context?;
}
import type common from "@ohos:app.ability.common";
import type Want from "@ohos:app.ability.Want";
import wantConstant from "@ohos:app.ability.wantConstant";
import hilog from "@ohos:hilog";
import type { BusinessError as BusinessError } from "@ohos:base";
const TAG: string = '[Page_UIAbilityComponentsInteractive]';
const DOMAIN_NUMBER: number = 0xFF00;
class Page_UIAbilityComponentsInteractive extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Page_UIAbilityComponentsInteractive_Params) {
        if (params.context !== undefined) {
            this.context = params.context;
        }
    }
    updateStateVars(params: Page_UIAbilityComponentsInteractive_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private context;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ initialIndex: 0 });
        }, List);
        {
            const itemCreation = (elmtId, isInitialRender) => {
                ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                ListItem.create(deepRenderFunction, true);
                if (!isInitialRender) {
                    ListItem.pop();
                }
                ViewStackProcessor.StopGetAccessRecording();
            };
            const itemCreation2 = (elmtId, isInitialRender) => {
                ListItem.create(deepRenderFunction, true);
            };
            const deepRenderFunction = (elmtId, isInitialRender) => {
                itemCreation(elmtId, isInitialRender);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                    Row.onClick(() => {
                        // context为UIAbility对象的成员
                        let wantInfo: Want = {
                            deviceId: '',
                            action: 'xxxx',
                            flags: wantConstant.Flags.FLAG_START_WITHOUT_TIPS,
                        };
                        // context为调用方UIAbility的UIAbilityContext
                        this.context.startAbility(wantInfo).then(() => {
                            hilog.info(DOMAIN_NUMBER, TAG, 'startAbility success.');
                        }).catch((error: BusinessError) => {
                            hilog.error(DOMAIN_NUMBER, TAG, 'startAbility failed.');
                        });
                    });
                }, Row);
                Row.pop();
                ListItem.pop();
            };
            this.observeComponentCreation2(itemCreation2, ListItem);
            ListItem.pop();
        }
        List.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Page_UIAbilityComponentsInteractive";
    }
}
registerNamedRoute(() => new Page_UIAbilityComponentsInteractive(undefined, {}), "", { bundleName: "com.example.pulllinking", moduleName: "entry", pagePath: "pages/OpenAppPage1", pageFullPath: "entry/src/main/ets/pages/OpenAppPage1", integratedHsp: "false", moduleType: "followWithHap" });
