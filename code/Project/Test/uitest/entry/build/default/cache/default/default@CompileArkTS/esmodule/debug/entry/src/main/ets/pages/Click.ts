if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Click_Params {
    message?: string;
}
import router from "@ohos:router";
class Click extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('Hello World', this, "message");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Click_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
    }
    updateStateVars(params: Click_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
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
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.message);
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
            Text.id('result_text');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('singleClick');
            Button.id('click_bt');
            Button.onClick(() => {
                this.message = 'singleClick';
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.type(ButtonType.Capsule);
            Button.margin({ top: 20 });
            Gesture.create(GesturePriority.Low);
            TapGesture.create({ count: 2 });
            TapGesture.onAction(() => {
                router.pushUrl({ url: 'pages/Third' });
            });
            TapGesture.pop();
            Gesture.pop();
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Click twice');
            Text.fontSize(25);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.type(ButtonType.Capsule);
            Button.margin({ top: 20 });
            Gesture.create(GesturePriority.Low);
            LongPressGesture.create({ repeat: false });
            LongPressGesture.onAction(() => {
                router.pushUrl({ url: 'pages/Fourth' });
            });
            LongPressGesture.pop();
            Gesture.pop();
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('LongClick');
            Text.fontSize(25);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Click";
    }
}
registerNamedRoute(() => new Click(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Click", pageFullPath: "entry/src/main/ets/pages/Click", integratedHsp: "false", moduleType: "followWithHap" });
