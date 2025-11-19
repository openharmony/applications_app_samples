if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ParentComponent_Params {
    someColor?: Color;
}
interface MyComponent_Params {
    countDownFrom?: number;
    color?: Color;
}
class MyComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.countDownFrom = 0;
        this.color = Color.Blue;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: MyComponent_Params) {
        if (params.countDownFrom !== undefined) {
            this.countDownFrom = params.countDownFrom;
        }
        if (params.color !== undefined) {
            this.color = params.color;
        }
    }
    updateStateVars(params: MyComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private countDownFrom: number;
    private color: Color;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // [StartExclude Parameter_specification]
            Text.create('test');
            // [StartExclude Parameter_specification]
            Text.backgroundColor(this.color);
        }, Text);
        // [StartExclude Parameter_specification]
        Text.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
class ParentComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.someColor = Color.Pink;
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ParentComponent_Params) {
        if (params.someColor !== undefined) {
            this.someColor = params.someColor;
        }
    }
    updateStateVars(params: ParentComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private someColor: Color;
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new 
                    // 创建MyComponent实例，并将创建MyComponent成员变量countDownFrom初始化为10，将成员变量color初始化为this.someColor
                    MyComponent(this, { countDownFrom: 10, color: this.someColor }, undefined, elmtId, () => { }, { page: "entry/src/main/ets/component/ParameterSpecification.ets", line: 37, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {
                            countDownFrom: 10,
                            color: this.someColor
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
        return "ParentComponent";
    }
}
// [End Parameter_specification]
const parentComponentParameter = ParentComponent;
export default parentComponentParameter;
registerNamedRoute(() => new ParentComponent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/ParameterSpecification", pageFullPath: "entry/src/main/ets/component/ParameterSpecification", integratedHsp: "false", moduleType: "followWithHap" });
