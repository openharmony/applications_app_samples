if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ModuleComponent_Params {
    aVar?: number;
}
class ModuleComponent extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__aVar = new ObservedPropertySimplePU(0, this, "aVar");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ModuleComponent_Params) {
        if (params.aVar !== undefined) {
            this.aVar = params.aVar;
        }
    }
    updateStateVars(params: ModuleComponent_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__aVar.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__aVar.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __aVar: ObservedPropertySimplePU<number>;
    get aVar() {
        return this.__aVar.get();
    }
    set aVar(newValue: number) {
        this.__aVar.set(newValue);
    }
    // [Start if_component]
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            // 正例：使用if判断
            if (this.aVar > 10) {
                this.ifElseBranchUpdateFunction(0, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Text.create('...');
                    }, Text);
                    Text.pop();
                });
            }
            else {
                this.ifElseBranchUpdateFunction(1, () => {
                    this.observeComponentCreation2((elmtId, isInitialRender) => {
                        Image.create('...');
                    }, Image);
                });
            }
        }, If);
        If.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ModuleComponent";
    }
}
registerNamedRoute(() => new ModuleComponent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/ModuleComponent", pageFullPath: "entry/src/main/ets/component/ModuleComponent", integratedHsp: "false", moduleType: "followWithHap" });
