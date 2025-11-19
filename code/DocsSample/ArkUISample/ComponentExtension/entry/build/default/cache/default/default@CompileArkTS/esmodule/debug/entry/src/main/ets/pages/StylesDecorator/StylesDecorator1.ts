if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface GlobalFancy_Params {
    heightValue?: number;
}
class GlobalFancy extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__heightValue = new ObservedPropertySimplePU(100, this, "heightValue");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: GlobalFancy_Params) {
        if (params.heightValue !== undefined) {
            this.heightValue = params.heightValue;
        }
    }
    updateStateVars(params: GlobalFancy_Params) {
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
            Column.create({ space: 10 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 使用全局的@Styles封装的样式
            Text.create('FancyA');
            // 使用全局的@Styles封装的样式
            Text.width(150);
            // 使用全局的@Styles封装的样式
            Text.height(100);
            // 使用全局的@Styles封装的样式
            Text.backgroundColor(Color.Pink);
            // 使用全局的@Styles封装的样式
            Text.fontSize(30);
        }, Text);
        // 使用全局的@Styles封装的样式
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 使用组件内的@Styles封装的样式
            Text.create('FancyB');
            // 使用组件内的@Styles封装的样式
            Text.width(200);
            // 使用组件内的@Styles封装的样式
            Text.height(this.heightValue);
            // 使用组件内的@Styles封装的样式
            Text.backgroundColor(Color.Yellow);
            // 使用组件内的@Styles封装的样式
            Text.onClick(() => {
                this.heightValue = 200;
            });
            // 使用组件内的@Styles封装的样式
            Text.fontSize(30);
        }, Text);
        // 使用组件内的@Styles封装的样式
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "GlobalFancy";
    }
}
registerNamedRoute(() => new GlobalFancy(undefined, {}), "", { bundleName: "com.example.componentextension", moduleName: "entry", pagePath: "pages/StylesDecorator/StylesDecorator1", pageFullPath: "entry/src/main/ets/pages/StylesDecorator/StylesDecorator1", integratedHsp: "false", moduleType: "followWithHap" });
