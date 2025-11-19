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
    static a: string = '';
    // [StartExclude Static_code_V1]
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // app.string.static_code资源文件中的value值为'静态代码块不生效'
            Text.create(MyComponent.a === '' ? { "id": 16777223, "type": 10003, params: [], "bundleName": "com.samples.createcustomcomponents", "moduleName": "entry" } : MyComponent.a);
        }, Text);
        // app.string.static_code资源文件中的value值为'静态代码块不生效'
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
// [End Static_code_V1]
const myComponentCodeV1 = MyComponent;
export default myComponentCodeV1;
registerNamedRoute(() => new MyComponent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/StaticCodeV1", pageFullPath: "entry/src/main/ets/component/StaticCodeV1", integratedHsp: "false", moduleType: "followWithHap" });
