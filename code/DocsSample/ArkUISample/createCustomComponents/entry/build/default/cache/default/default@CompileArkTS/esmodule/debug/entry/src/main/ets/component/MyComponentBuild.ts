if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ChildComponent_Params {
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 根节点唯一且必要，必须为容器组件
            Row.create();
        }, Row);
        {
            this.observeComponentCreation2((elmtId, isInitialRender) => {
                if (isInitialRender) {
                    let componentCall = new ChildComponent(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/component/MyComponentBuild.ets", line: 22, col: 7 });
                    ViewPU.create(componentCall);
                    let paramsLambda = () => {
                        return {};
                    };
                    componentCall.paramsGenerator_ = paramsLambda;
                }
                else {
                    this.updateStateVarsOfChildByElmtId(elmtId, {});
                }
            }, { name: "ChildComponent" });
        }
        // 根节点唯一且必要，必须为容器组件
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "MyComponent";
    }
}
class ChildComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ChildComponent_Params) {
    }
    updateStateVars(params: ChildComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            // 根节点唯一且必要，可为非容器组件
            // $r('app.media.startIcon')需要替换为开发者所需的资源文件
            Image.create({ "id": 16777226, "type": 20000, params: [], "bundleName": "com.samples.createcustomcomponents", "moduleName": "entry" });
        }, Image);
    }
    rerender() {
        this.updateDirtyElements();
    }
}
// [End build_function]
const childComponentBuildFunction = ChildComponent;
export default childComponentBuildFunction;
registerNamedRoute(() => new MyComponent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/MyComponentBuild", pageFullPath: "entry/src/main/ets/component/MyComponentBuild", integratedHsp: "false", moduleType: "followWithHap" });
