if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
class MyComponent extends ViewV2 {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda, extraInfo) {
        super(parent, elmtId, extraInfo);
        this.finalizeConstruction();
    }
    public resetStateVarsOnReuse(params: Object): void {
    }
    static a: string = '';
    // 静态代码块生效，a的值变为'hello world'
    static {
        this.a = 'hello world';
    }
    // [StartExclude Static_code_V2]
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(MyComponent.a);
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
// [End Static_code_V2]
const myComponentV2 = MyComponent;
export default myComponentV2;
registerNamedRoute(() => new MyComponent(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "component/StaticCodeV2", pageFullPath: "entry/src/main/ets/component/StaticCodeV2", integratedHsp: "false", moduleType: "followWithHap" });
