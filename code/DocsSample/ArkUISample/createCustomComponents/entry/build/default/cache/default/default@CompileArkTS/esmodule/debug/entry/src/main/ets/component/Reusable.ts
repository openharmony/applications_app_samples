if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface MyComponent_Params {
}
class MyComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MyComponent_Params) {
    }
    updateStateVars(params: MyComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    updateRecycleElmtId(oldElmtId, newElmtId) {
    }
    // [StartExclude Reusable_MyComponent]
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            if (isInitialRender) {
                Column.width('100%');
                Column.height('100%');
            }
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Hello World');
            if (isInitialRender) {
                Text.fontSize(50);
                Text.fontWeight(FontWeight.Bold);
            }
        }, Text);
        Text.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "MyComponent";
    }
}
// [End Reusable_MyComponent]
const myComponentReusable = MyComponent;
export default myComponentReusable;
registerNamedRoute(() => new MyComponent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/Reusable", pageFullPath: "entry/src/main/ets/component/Reusable", integratedHsp: "false", moduleType: "followWithHap" });
