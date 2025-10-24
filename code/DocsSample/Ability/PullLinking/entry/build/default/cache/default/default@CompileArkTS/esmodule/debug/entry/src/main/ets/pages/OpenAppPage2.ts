if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Page_UIAbilityComponentsInteractive_Params {
    context?;
    canOpen?: boolean;
}
import type common from "@ohos:app.ability.common";
import bundleManager from "@ohos:bundle.bundleManager";
import type { BusinessError as BusinessError } from "@ohos:base";
import hilog from "@ohos:hilog";
// [End quick_start0]
const TAG: string = '[Page_UIAbilityComponentsInteractive]';
const DOMAIN_NUMBER: number = 0xFF00;
class Page_UIAbilityComponentsInteractive extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.context = this.getUIContext().getHostContext() as common.UIAbilityContext;
        this.canOpen = false;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Page_UIAbilityComponentsInteractive_Params) {
        if (params.context !== undefined) {
            this.context = params.context;
        }
        if (params.canOpen !== undefined) {
            this.canOpen = params.canOpen;
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
    public canOpen: boolean;
    aboutToAppear() {
        let link = 'app1Scheme://test.example.com/home';
        // [Start quick_start1]
        try {
            let link = 'app1Scheme://test.example.com/home';
            let canOpen = bundleManager.canOpenLink(link);
            // [Start_EXclude quick_start1]
            this.canOpen = canOpen;
            // [End_EXclude quick_start1]
            hilog.info(0x0000, 'testTag', 'canOpenLink successfully: %{public}s', JSON.stringify(canOpen));
        }
        catch (err) {
            let message = (err as BusinessError).message;
            hilog.error(0x0000, 'testTag', 'canOpenLink failed: %{public}s', message);
        }
        // [End quick_start1]
    }
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
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Button.createWithLabel('MyAbility');
                    Button.onClick(() => {
                    });
                }, Button);
                Button.pop();
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
registerNamedRoute(() => new Page_UIAbilityComponentsInteractive(undefined, {}), "", { bundleName: "com.example.pulllinking", moduleName: "entry", pagePath: "pages/OpenAppPage2", pageFullPath: "entry/src/main/ets/pages/OpenAppPage2", integratedHsp: "false", moduleType: "followWithHap" });
