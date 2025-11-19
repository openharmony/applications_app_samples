if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ImageAdaptation_Params {
}
class ImageAdaptation extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ImageAdaptation_Params) {
    }
    updateStateVars(params: ImageAdaptation_Params) {
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
            // [Start image_adaptation]
            Text.create('Use system-defined colors');
            // [Start image_adaptation]
            Text.fontColor({ "id": 125829210, "type": 10001, params: [], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
        }, Text);
        // [Start image_adaptation]
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // [End image_adaptation]
            // [Start image_adaptation_image]
            Image.create({ "id": 0, "type": 30000, params: ['app.media.pic_svg.svg'], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
            // [End image_adaptation]
            // [Start image_adaptation_image]
            Image.width(100);
            // [End image_adaptation]
            // [Start image_adaptation_image]
            Image.margin({ top: 20 });
            // [End image_adaptation]
            // [Start image_adaptation_image]
            Image.fillColor({ "id": 125829210, "type": 10001, params: [], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
        }, Image);
        RelativeContainer.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ImageAdaptation";
    }
}
registerNamedRoute(() => new ImageAdaptation(undefined, {}), "", { bundleName: "com.samples.ColorAdaption", moduleName: "entry", pagePath: "pages/ImageAdaptation", pageFullPath: "entry/src/main/ets/pages/ImageAdaptation", integratedHsp: "false", moduleType: "followWithHap" });
