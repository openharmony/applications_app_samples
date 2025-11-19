if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface dark_light_color_adaptation_Params {
}
class dark_light_color_adaptation extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: dark_light_color_adaptation_Params) {
    }
    updateStateVars(params: dark_light_color_adaptation_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            RelativeContainer.create();
            RelativeContainer.height('100%');
            RelativeContainer.width('100%');
        }, RelativeContainer);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Use app-defined colors');
            Text.fontColor({ "id": 125829210, "type": 10001, params: [], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 0, "type": 30000, params: ['app.media.pic_svg.svg'], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
            Image.width(100);
            Image.margin({ top: 20 });
            Image.fillColor({ "id": 125829210, "type": 10001, params: [], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
        }, Image);
        RelativeContainer.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "dark_light_color_adaptation";
    }
}
registerNamedRoute(() => new dark_light_color_adaptation(undefined, {}), "", { bundleName: "com.samples.ColorAdaption", moduleName: "entry", pagePath: "pages/ImageAdaptation", pageFullPath: "entry/src/main/ets/pages/ImageAdaptation", integratedHsp: "false", moduleType: "followWithHap" });
