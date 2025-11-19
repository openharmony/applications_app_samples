if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface SwitchColorMode_Params {
    message?: string;
    colorMode?: ThemeColorMode;
}
class SwitchColorMode extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('Hello World', this, "message");
        this.__colorMode = new ObservedPropertySimplePU(ThemeColorMode.DARK, this, "colorMode");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: SwitchColorMode_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
        if (params.colorMode !== undefined) {
            this.colorMode = params.colorMode;
        }
    }
    updateStateVars(params: SwitchColorMode_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
        this.__colorMode.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        this.__colorMode.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __message: ObservedPropertySimplePU<string>;
    get message() {
        return this.__message.get();
    }
    set message(newValue: string) {
        this.__message.set(newValue);
    }
    private __colorMode: ObservedPropertySimplePU<ThemeColorMode>;
    get colorMode() {
        return this.__colorMode.get();
    }
    set colorMode(newValue: ThemeColorMode) {
        this.__colorMode.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            WithTheme.create({ colorMode: this.colorMode });
        }, WithTheme);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.backgroundColor({ "id": 125831061, "type": 10001, params: [], "bundleName": "com.samples.ColorAdaption", "moduleName": "entry" });
            Row.height('100%');
            Row.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.END, SafeAreaEdge.BOTTOM, SafeAreaEdge.START]);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.message);
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Switch ColorMode');
            Button.onClick(() => {
                if (this.colorMode === ThemeColorMode.LIGHT) {
                    this.colorMode = ThemeColorMode.DARK;
                }
                else if (this.colorMode === ThemeColorMode.DARK) {
                    this.colorMode = ThemeColorMode.LIGHT;
                }
            });
        }, Button);
        Button.pop();
        Column.pop();
        Row.pop();
        WithTheme.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "SwitchColorMode";
    }
}
registerNamedRoute(() => new SwitchColorMode(undefined, {}), "", { bundleName: "com.samples.ColorAdaption", moduleName: "entry", pagePath: "pages/SwitchColorMode", pageFullPath: "entry/src/main/ets/pages/SwitchColorMode", integratedHsp: "false", moduleType: "followWithHap" });
