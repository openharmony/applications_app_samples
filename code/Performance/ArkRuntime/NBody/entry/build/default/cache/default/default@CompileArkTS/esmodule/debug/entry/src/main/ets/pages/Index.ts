interface Index_Params {
    message?: string;
    timeCost?: String;
}
import { computeNBodyByTaskPool, computeNBodyByWorker } from "@bundle:com.example.nbody/entry/ets/model/CalculateUtil";
import Logger from "@bundle:com.example.nbody/entry/ets/utils/Logger";
import Constants from "@bundle:com.example.nbody/entry/ets/utils/Constants";
const TAG: string = 'Index';
const WHILE_CALCULATE: string = 'Calculating...';
const ID_BUTTON_TASK_POOL_CALCULATE: string = "id_btn_task_pool_calculate";
const ID_BUTTON_WORKER_CALCULATE: string = "id_btn_worker_calculate";
const ID_TEXT_MESSAGE: string = "id_text_message";
const ID_TOP_IMAGE: string = "id_top_image";
const ID_TOP_TEXT: string = "id_top_text";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined) {
        super(parent, __localStorage, elmtId);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('Click button to calculate.', this, "message");
        this.__timeCost = this.createStorageLink('timeCost', '', "timeCost");
        this.setInitiallyProvidedValue(params);
        this.declareWatch("timeCost", this.timeCostChanged);
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
        this.__timeCost.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        this.__timeCost.aboutToBeDeleted();
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
    private __timeCost: ObservedPropertyAbstractPU<String>;
    get timeCost() {
        return this.__timeCost.get();
    }
    set timeCost(newValue: String) {
        this.__timeCost.set(newValue);
    }
    timeCostChanged(): void {
        this.message = AppStorage.get('timeCost');
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width({ "id": 16777234, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Column.height({ "id": 16777234, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Column.justifyContent(FlexAlign.Center);
            Column.alignItems(HorizontalAlign.Center);
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.Center });
            Stack.height({ "id": 16777235, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Stack.width({ "id": 16777234, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 16777243, "type": 20000, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Image.width({ "id": 16777234, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Image.height({ "id": 16777234, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Image.borderRadius({ "id": 16777225, "type": 10007, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Image.autoResize(false);
            Image.id(ID_TOP_IMAGE);
        }, Image);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create({ "id": 16777240, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Text.fontSize({ "id": 16777222, "type": 10007, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Text.fontColor(Color.White);
            Text.textAlign(TextAlign.Center);
            Text.id(ID_TOP_TEXT);
        }, Text);
        Text.pop();
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.message);
            Text.fontSize({ "id": 16777221, "type": 10007, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Bold);
            Text.height({ "id": 16777233, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Text.id(ID_TEXT_MESSAGE);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel({ "id": 16777231, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Button.onClick(() => {
                // 使用任务池执行计算任务
                if (this.message === WHILE_CALCULATE) {
                    this.reCalculateAlert();
                }
                else {
                    this.message = WHILE_CALCULATE;
                    computeNBodyByTaskPool(Constants.TIME_STEPS_TASK_POOL);
                }
            });
            Button.margin({
                top: { "id": 16777219, "type": 10007, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" }
            });
            Button.id(ID_BUTTON_TASK_POOL_CALCULATE);
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel({ "id": 16777232, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" });
            Button.onClick(() => {
                // 使用Worker执行计算任务
                if (this.message === WHILE_CALCULATE) {
                    this.reCalculateAlert();
                }
                else {
                    this.message = WHILE_CALCULATE;
                    computeNBodyByWorker(Constants.TIME_STEPS_WORKER);
                }
            });
            Button.margin({
                top: { "id": 16777220, "type": 10007, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" }
            });
            Button.id(ID_BUTTON_WORKER_CALCULATE);
        }, Button);
        Button.pop();
        Column.pop();
    }
    private reCalculateAlert(): void {
        AlertDialog.show({
            title: { "id": 16777228, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" },
            message: { "id": 16777226, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" },
            autoCancel: true,
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: { "id": 16777218, "type": 10007, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" } },
            confirm: {
                value: { "id": 16777227, "type": 10003, params: [], "bundleName": "com.example.nbody", "moduleName": "entry" },
                action: () => {
                    Logger.info(TAG, 'Callback when confirm button is clicked');
                }
            },
            cancel: () => {
                Logger.info(TAG, 'Closed callbacks');
            }
        });
    }
    rerender() {
        this.updateDirtyElements();
    }
}
ViewStackProcessor.StartGetAccessRecordingFor(ViewStackProcessor.AllocateNewElmetIdForNextComponent());
loadDocument(new Index(undefined, {}));
ViewStackProcessor.StopGetAccessRecording();
