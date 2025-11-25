if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    controller?: web_webview.WebviewController;
    storageLink?: web_webview.WebviewController;
}
import web_webview from "@ohos:web.webview";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.controller = new web_webview.WebviewController();
        this.__storageLink = this.createStorageLink('controller', this.controller, "storageLink");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.controller !== undefined) {
            this.controller = params.controller;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__storageLink.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__storageLink.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private controller: web_webview.WebviewController;
    // 将 WebviewController 存储到应用全局状态，TestAbility 中可获取并使用该对象
    private __storageLink: ObservedPropertyAbstractPU<web_webview.WebviewController>;
    get storageLink() {
        return this.__storageLink.get();
    }
    set storageLink(newValue: web_webview.WebviewController) {
        this.__storageLink.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Web.create({ src: { "id": 0, "type": 30000, params: ['index.html'], "bundleName": "com.samples.test.uitest", "moduleName": "entry" }, controller: this.controller });
            Web.javaScriptAccess(true);
            Web.onPageEnd(e => {
                console.info(`webview onPageEnd`);
            });
            Web.id('webComponent');
            Web.width('80%');
            Web.height('80%');
            Web.align(Alignment.Center);
            Web.borderColor(Color.Black);
            Web.borderWidth(5);
        }, Web);
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Web", pageFullPath: "entry/src/main/ets/pages/Web", integratedHsp: "false", moduleType: "followWithHap" });
