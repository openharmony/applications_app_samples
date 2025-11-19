if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Parent_Params {
}
interface MyComponent_Params {
    count?: number;
    increaseBy?: number;
}
class MyComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__count = new ObservedPropertySimplePU(0, this, "count");
        this.increaseBy = 1;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MyComponent_Params) {
        if (params.count !== undefined) {
            this.count = params.count;
        }
        if (params.increaseBy !== undefined) {
            this.increaseBy = params.increaseBy;
        }
    }
    updateStateVars(params: MyComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__count.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__count.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __count: ObservedPropertySimplePU<number>;
    get count() {
        return this.__count.get();
    }
    set count(newValue: number) {
        this.__count.set(newValue);
    }
    private increaseBy: number;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // [StartExclude state_management_overview]
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`Count: ${this.count}`);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`increaseBy: ${this.increaseBy}`);
        }, Text);
        Text.pop();
        // [StartExclude state_management_overview]
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
class Parent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Parent_Params) {
    }
    updateStateVars(params: Parent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 从父组件初始化，覆盖本地定义的默认值
                    MyComponent(this, { count: 1, increaseBy: 2 }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/managementoverview/stateManagementOverview.ets", line: 38, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            count: 1,
                            increaseBy: 2
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "MyComponent" });
        }
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Parent";
    }
}
// [End state_management_overview]
const myComponentOverview = MyComponent;
export default myComponentOverview;
registerNamedRoute(() => new Parent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "managementoverview/stateManagementOverview", pageFullPath: "entry/src/main/ets/managementoverview/stateManagementOverview", integratedHsp: "false", moduleType: "followWithHap" });
