if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Son_Params {
    submitArrow?: () => void;
}
interface Parent_Params {
    cnt?: number;
    submit?: () => void;
}
class Parent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__cnt = new ObservedPropertySimplePU(0, this, "cnt");
        this.submit = () => {
            this.cnt++;
        };
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Parent_Params) {
        if (params.cnt !== undefined) {
            this.cnt = params.cnt;
        }
        if (params.submit !== undefined) {
            this.submit = params.submit;
        }
    }
    updateStateVars(params: Parent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__cnt.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__cnt.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __cnt: ObservedPropertySimplePU<number>;
    get cnt() {
        return this.__cnt.get();
    }
    set cnt(newValue: number) {
        this.__cnt.set(newValue);
    }
    private submit: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${this.cnt}`);
        }, Text);
        Text.pop();
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new Son(this, { submitArrow: this.submit }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/component/ParentFunction.ets", line: 27, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            submitArrow: this.submit
                        };
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "Son" });
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
class Son extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.submitArrow = undefined;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Son_Params) {
        if (params.submitArrow !== undefined) {
            this.submitArrow = params.submitArrow;
        }
    }
    updateStateVars(params: Son_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private submitArrow?: () => void;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height(56);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('add');
            Button.width(80);
            Button.onClick(() => {
                if (this.submitArrow) {
                    this.submitArrow();
                }
            });
        }, Button);
        Button.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
// [End Function_passing]
const parentFunction = Parent;
export default parentFunction;
registerNamedRoute(() => new Parent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/ParentFunction", pageFullPath: "entry/src/main/ets/component/ParentFunction", integratedHsp: "false", moduleType: "followWithHap" });
