if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ScreenExample_Params {
    myScale?: number;
    myScaleOut?: number;
}
class ScreenExample extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__myScale = new ObservedPropertySimplePU(1, this, "myScale");
        this.__myScaleOut = new ObservedPropertySimplePU(1, this, "myScaleOut");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ScreenExample_Params) {
        if (params.myScale !== undefined) {
            this.myScale = params.myScale;
        }
        if (params.myScaleOut !== undefined) {
            this.myScaleOut = params.myScaleOut;
        }
    }
    updateStateVars(params: ScreenExample_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__myScale.purgeDependencyOnElmtId(rmElmtId);
        this.__myScaleOut.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__myScale.aboutToBeDeleted();
        this.__myScaleOut.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __myScale: ObservedPropertySimplePU<number>;
    get myScale() {
        return this.__myScale.get();
    }
    set myScale(newValue: number) {
        this.__myScale.set(newValue);
    }
    private __myScaleOut: ObservedPropertySimplePU<number>;
    get myScaleOut() {
        return this.__myScaleOut.get();
    }
    set myScaleOut(newValue: number) {
        this.__myScaleOut.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.myScale.toString());
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777252, "type": 20000, params: [], "bundleName": "com.samples.test.uitest", "moduleName": "entry" });
            Image.objectFit(ImageFit.Auto);
            Image.height(200);
            Image.width(200);
            Image.id('pinch_ima');
            Image.scale({ x: this.myScale, y: this.myScale, z: this.myScale });
            Gesture.create(GesturePriority.Low);
            PinchGesture.create();
            PinchGesture.onActionStart((event: GestureEvent) => {
                console.info('Pinch start');
            });
            PinchGesture.onActionUpdate((event: GestureEvent) => {
                this.myScale = event.scale;
            });
            PinchGesture.onActionEnd(() => {
                console.info('Pinch end');
            });
            PinchGesture.pop();
            Gesture.pop();
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777252, "type": 20000, params: [], "bundleName": "com.samples.test.uitest", "moduleName": "entry" });
            Image.objectFit(ImageFit.Auto);
            Image.height(200);
            Image.width(200);
            Image.margin({ top: 100 });
            Image.id('pinch_ima_out');
            Image.scale({ x: this.myScaleOut, y: this.myScaleOut, z: this.myScaleOut });
            Gesture.create(GesturePriority.Low);
            PinchGesture.create();
            PinchGesture.onActionStart((event: GestureEvent) => {
                console.info('Pinch start');
            });
            PinchGesture.onActionUpdate((event: GestureEvent) => {
                this.myScaleOut = event.scale;
            });
            PinchGesture.onActionEnd(() => {
                console.info('Pinch end');
            });
            PinchGesture.pop();
            Gesture.pop();
        }, Image);
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ScreenExample";
    }
}
registerNamedRoute(() => new ScreenExample(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Pinch", pageFullPath: "entry/src/main/ets/pages/Pinch", integratedHsp: "false", moduleType: "followWithHap" });
