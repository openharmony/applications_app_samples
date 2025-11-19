if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ParentComponent_Params {
}
class ParentComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ParentComponent_Params) {
    }
    updateStateVars(params: ParentComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    calcTextValue(): string {
        return 'Hello World';
    }
    doSomeRender(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`Hello World`);
        }, Text);
        Text.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        // 正例：可以调用
        this.doSomeRender.bind(this)();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 正例：参数可以为调用TS方法的返回值
            Text.create(this.calcTextValue());
        }, Text);
        // 正例：参数可以为调用TS方法的返回值
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ParentComponent";
    }
}
// [End Builder_decoration]
const builderMethod = ParentComponent;
export default builderMethod;
registerNamedRoute(() => new ParentComponent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/BuilderMethod", pageFullPath: "entry/src/main/ets/component/BuilderMethod", integratedHsp: "false", moduleType: "followWithHap" });
