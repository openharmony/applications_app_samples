if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ForEachFilter_Params {
    arr?: number[];
}
class ForEachFilter extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__arr = new ObservedPropertyObjectPU([0, 1, 2, 3], this, "arr");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ForEachFilter_Params) {
        if (params.arr !== undefined) {
            this.arr = params.arr;
        }
    }
    updateStateVars(params: ForEachFilter_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__arr.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__arr.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __arr: ObservedPropertyObjectPU<number[]>;
    get arr() {
        return this.__arr.get();
    }
    set arr(newValue: number[]) {
        this.__arr.set(newValue);
    }
    For() {
        // [Start filter_New_array]
        // 正确的执行方式为：filter返回一个新数组，后面的sort方法才不会改变原数组this.arr
        ForEach(this.arr.filter((item, index) => index >= 2).sort(), (item: number) => {
            // ...
        });
        // [End filter_New_array]
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            RelativeContainer.create();
            RelativeContainer.height('100%');
            RelativeContainer.width('100%');
        }, RelativeContainer);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Hello World');
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Column.pop();
        RelativeContainer.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ForEachFilter";
    }
}
registerNamedRoute(() => new ForEachFilter(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/ForEachFilter", pageFullPath: "entry/src/main/ets/component/ForEachFilter", integratedHsp: "false", moduleType: "followWithHap" });
