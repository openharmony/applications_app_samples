if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface FancyUse_Params {
    heightValue?: number;
}
class FancyUse extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__heightValue = new ObservedPropertySimplePU(50, this, "heightValue");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: FancyUse_Params) {
        if (params.heightValue !== undefined) {
            this.heightValue = params.heightValue;
        }
    }
    updateStateVars(params: FancyUse_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__heightValue.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__heightValue.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __heightValue: ObservedPropertySimplePU<number>;
    get heightValue() {
        return this.__heightValue.get();
    }
    set heightValue(newValue: number) {
        this.__heightValue.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height('100%');
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('change height');
            Button.height(this.heightValue);
            Button.backgroundColor(Color.Blue);
            Button.onClick(() => {
                this.heightValue = 100;
            });
        }, Button);
        Button.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "FancyUse";
    }
}
registerNamedRoute(() => new FancyUse(undefined, {}), "", { bundleName: "com.example.componentextension", moduleName: "entry", pagePath: "pages/StylesDecorator/StylesDecorator2", pageFullPath: "entry/src/main/ets/pages/StylesDecorator/StylesDecorator2", integratedHsp: "false", moduleType: "followWithHap" });
