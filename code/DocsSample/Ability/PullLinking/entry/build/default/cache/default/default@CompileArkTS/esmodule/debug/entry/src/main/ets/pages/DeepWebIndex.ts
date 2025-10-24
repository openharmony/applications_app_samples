if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface WebComponent_Params {
    controller?: webview.WebviewController;
}
import webview from "@ohos:web.webview";
import type { BusinessError as BusinessError } from "@ohos:base";
import type common from "@ohos:app.ability.common";
import hilog from "@ohos:hilog";
const DOMAIN_NUMBER = 0xF811;
const TAG = '[Sample_MyApp]';
class WebComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.controller = new webview.WebviewController();
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: WebComponent_Params) {
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
    }
    updateStateVars(params: WebComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private controller: webview.WebviewController;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Web.create({ src: { "id": 0, "type": 30000, params: ['index.html'], "bundleName": "com.example.pulllinking", "moduleName": "entry" }, controller: this.controller });
            Web.onLoadIntercept((event) => {
                const url: string = event.data.getRequestUrl();
                if (url === 'link://www.example.com') {
                    (this.getUIContext().getHostContext() as common.UIAbilityContext).openLink(url)
                        .then(() => {
                        hilog.info(DOMAIN_NUMBER, TAG, 'openLink success.');
                    }).catch((err: BusinessError) => {
                        hilog.error(DOMAIN_NUMBER, TAG, `openLink failed, err: ${JSON.stringify(err)}.`);
                    });
                    return true;
                }
                // 返回true表示阻止此次加载，否则允许此次加载
                return false;
            });
        }, Web);
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "WebComponent";
    }
}
registerNamedRoute(() => new WebComponent(undefined, {}), "", { bundleName: "com.example.pulllinking", moduleName: "entry", pagePath: "pages/DeepWebIndex", pageFullPath: "entry/src/main/ets/pages/DeepWebIndex", integratedHsp: "false", moduleType: "followWithHap" });
