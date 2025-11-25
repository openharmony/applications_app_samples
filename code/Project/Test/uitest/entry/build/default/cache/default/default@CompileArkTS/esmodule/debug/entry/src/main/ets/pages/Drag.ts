if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface DragExample_Params {
    numbers?: string[];
    text?: string;
    bool?: boolean;
    dragBool?: boolean;
    appleVisible?: Visibility;
    orangeVisible?: Visibility;
    bananaVisible?: Visibility;
    select?: number;
}
class DragExample extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__numbers = new ObservedPropertyObjectPU(['one', 'two', 'three', 'four', 'five', 'six'], this, "numbers");
        this.__text = new ObservedPropertySimplePU('', this, "text");
        this.__bool = new ObservedPropertySimplePU(false, this, "bool");
        this.__dragBool = new ObservedPropertySimplePU(false, this, "dragBool");
        this.__appleVisible = new ObservedPropertySimplePU(Visibility.Visible, this, "appleVisible");
        this.__orangeVisible = new ObservedPropertySimplePU(Visibility.Visible, this, "orangeVisible");
        this.__bananaVisible = new ObservedPropertySimplePU(Visibility.Visible, this, "bananaVisible");
        this.__select = new ObservedPropertySimplePU(0, this, "select");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: DragExample_Params) {
        if (params.numbers !== undefined) {
            this.numbers = params.numbers;
        }
        if (params.text !== undefined) {
            this.text = params.text;
        }
        if (params.bool !== undefined) {
            this.bool = params.bool;
        }
        if (params.dragBool !== undefined) {
            this.dragBool = params.dragBool;
        }
        if (params.appleVisible !== undefined) {
            this.appleVisible = params.appleVisible;
        }
        if (params.orangeVisible !== undefined) {
            this.orangeVisible = params.orangeVisible;
        }
        if (params.bananaVisible !== undefined) {
            this.bananaVisible = params.bananaVisible;
        }
        if (params.select !== undefined) {
            this.select = params.select;
        }
    }
    updateStateVars(params: DragExample_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__numbers.purgeDependencyOnElmtId(rmElmtId);
        this.__text.purgeDependencyOnElmtId(rmElmtId);
        this.__bool.purgeDependencyOnElmtId(rmElmtId);
        this.__dragBool.purgeDependencyOnElmtId(rmElmtId);
        this.__appleVisible.purgeDependencyOnElmtId(rmElmtId);
        this.__orangeVisible.purgeDependencyOnElmtId(rmElmtId);
        this.__bananaVisible.purgeDependencyOnElmtId(rmElmtId);
        this.__select.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__numbers.aboutToBeDeleted();
        this.__text.aboutToBeDeleted();
        this.__bool.aboutToBeDeleted();
        this.__dragBool.aboutToBeDeleted();
        this.__appleVisible.aboutToBeDeleted();
        this.__orangeVisible.aboutToBeDeleted();
        this.__bananaVisible.aboutToBeDeleted();
        this.__select.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __numbers: ObservedPropertyObjectPU<string[]>;
    get numbers() {
        return this.__numbers.get();
    }
    set numbers(newValue: string[]) {
        this.__numbers.set(newValue);
    }
    private __text: ObservedPropertySimplePU<string>;
    get text() {
        return this.__text.get();
    }
    set text(newValue: string) {
        this.__text.set(newValue);
    }
    private __bool: ObservedPropertySimplePU<boolean>;
    get bool() {
        return this.__bool.get();
    }
    set bool(newValue: boolean) {
        this.__bool.set(newValue);
    }
    private __dragBool: ObservedPropertySimplePU<boolean>;
    get dragBool() {
        return this.__dragBool.get();
    }
    set dragBool(newValue: boolean) {
        this.__dragBool.set(newValue);
    }
    private __appleVisible: ObservedPropertySimplePU<Visibility>;
    get appleVisible() {
        return this.__appleVisible.get();
    }
    set appleVisible(newValue: Visibility) {
        this.__appleVisible.set(newValue);
    }
    private __orangeVisible: ObservedPropertySimplePU<Visibility>;
    get orangeVisible() {
        return this.__orangeVisible.get();
    }
    set orangeVisible(newValue: Visibility) {
        this.__orangeVisible.set(newValue);
    }
    private __bananaVisible: ObservedPropertySimplePU<Visibility>;
    get bananaVisible() {
        return this.__bananaVisible.get();
    }
    set bananaVisible(newValue: Visibility) {
        this.__bananaVisible.set(newValue);
    }
    private __select: ObservedPropertySimplePU<number>;
    get select() {
        return this.__select.get();
    }
    set select(newValue: number) {
        this.__select.set(newValue);
    }
    pixelMapBuilder(parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.text);
            Text.width('50%');
            Text.height(60);
            Text.fontSize(16);
            Text.borderRadius(10);
            Text.textAlign(TextAlign.Center);
            Text.backgroundColor(Color.Yellow);
        }, Text);
        Text.pop();
        Column.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.padding({ top: 20 });
            Column.margin({ top: 20 });
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('There are three Text elements here');
            Text.fontSize(12);
            Text.fontColor(0xCCCCCC);
            Text.width('90%');
            Text.textAlign(TextAlign.Start);
            Text.margin(5);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('Show Item');
            Button.id('show_item');
            Button.onClick(() => {
                this.appleVisible = Visibility.Visible;
                this.bananaVisible = Visibility.Visible;
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ direction: FlexDirection.Row, alignItems: ItemAlign.Center, justifyContent: FlexAlign.SpaceAround });
            Flex.border({ width: 1 });
            Flex.width('90%');
            Flex.padding({ top: 10, bottom: 10 });
            Flex.margin(10);
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('apple');
            Text.width('25%');
            Text.height(35);
            Text.fontSize(16);
            Text.textAlign(TextAlign.Center);
            Text.backgroundColor(0xAFEEEE);
            Text.visibility(this.appleVisible);
            Text.onDragStart(() => {
                this.bool = true;
                this.text = 'apple';
                this.appleVisible = Visibility.Hidden;
                return { builder: this.pixelMapBuilder.bind(this) };
            });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('orange');
            Text.width('25%');
            Text.height(35);
            Text.fontSize(16);
            Text.textAlign(TextAlign.Center);
            Text.backgroundColor(0xAFEEEE);
            Text.visibility(this.orangeVisible);
            Text.onDragStart(() => {
                this.bool = true;
                this.text = 'orange';
                this.orangeVisible = Visibility.Hidden;
                return { builder: this.pixelMapBuilder.bind(this) };
            });
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('banana');
            Text.width('25%');
            Text.height(35);
            Text.fontSize(16);
            Text.textAlign(TextAlign.Center);
            Text.backgroundColor(0xAFEEEE);
            Text.visibility(this.bananaVisible);
            Text.onDragStart((event: DragEvent, extraParams: string) => {
                console.log('Text onDragStarts, ' + extraParams);
                this.bool = true;
                this.text = 'banana';
                this.bananaVisible = Visibility.Hidden;
                return { builder: this.pixelMapBuilder.bind(this) };
            });
        }, Text);
        Text.pop();
        Flex.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('This is a List element');
            Text.fontSize(12);
            Text.fontColor(0xCCCCCC);
            Text.width('90%');
            Text.textAlign(TextAlign.Start);
            Text.margin(15);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ space: 20, initialIndex: 0 });
            List.editMode(true);
            List.height('50%');
            List.width('90%');
            List.border({ width: 1 });
            List.divider({
                strokeWidth: 2,
                color: 0xFFFFFF,
                startMargin: 20,
                endMargin: 20
            });
            List.onDragEnter((event: DragEvent | undefined, extraParams: string | undefined) => {
                console.log('List onDragEnter, ' + extraParams);
            });
            List.onDragMove((event: DragEvent | undefined, extraParams: string | undefined) => {
                console.log('List onDragMove, ' + extraParams);
            });
            List.onDragLeave((event: DragEvent | undefined, extraParams: string | undefined) => {
                console.log('List onDragLeave, ' + extraParams);
            });
            List.onDrop((event: DragEvent | undefined, extraParams: string | undefined) => {
                if (extraParams == undefined) {
                    return;
                }
                let jsonString: ObjTest = JSON.parse(extraParams);
                if (this.bool) {
                    this.numbers.splice(jsonString.insertIndex, 0, this.text);
                    this.bool = false;
                }
                else if (this.dragBool) {
                    this.numbers.splice(jsonString.selectedIndex, 1);
                    this.numbers.splice(jsonString.insertIndex, 0, this.text);
                    this.bool = false;
                    this.dragBool = false;
                }
            });
        }, List);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                {
                    const itemCreation = (elmtId, isInitialRender) => {
                        ViewStackProcessor.StartGetAccessRecordingFor(elmtId);
                        ListItem.create(deepRenderFunction, true);
                        if (!isInitialRender) {
                            ListItem.pop();
                        }
                        ViewStackProcessor.StopGetAccessRecording();
                    };
                    const itemCreation2 = (elmtId, isInitialRender) => {
                        ListItem.create(deepRenderFunction, true);
                        ListItem.onDragStart((event: DragEvent | undefined, extraParams: string | undefined) => {
                            if (extraParams == undefined) {
                                return;
                            }
                            console.log('ListItem onDragStarts, ' + extraParams);
                            let jsonString: ObjTest = JSON.parse(extraParams);
                            this.dragBool = true;
                            this.text = this.numbers[jsonString.selectedIndex];
                            this.select = jsonString.selectedIndex;
                            return { builder: this.pixelMapBuilder.bind(this) };
                        });
                    };
                    const deepRenderFunction = (elmtId, isInitialRender) => {
                        itemCreation(elmtId, isInitialRender);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create('' + item);
                            Text.width('100%');
                            Text.height(80);
                            Text.fontSize(16);
                            Text.borderRadius(10);
                            Text.textAlign(TextAlign.Center);
                            Text.backgroundColor(0xAFEEEE);
                        }, Text);
                        Text.pop();
                        ListItem.pop();
                    };
                    this.observeComponentCreation2(itemCreation2, ListItem);
                    ListItem.pop();
                }
            };
            this.forEachUpdateFunction(elmtId, this.numbers, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        List.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "DragExample";
    }
}
interface ObjTest {
    insertIndex: number;
    selectedIndex: number;
}
registerNamedRoute(() => new DragExample(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Drag", pageFullPath: "entry/src/main/ets/pages/Drag", integratedHsp: "false", moduleType: "followWithHap" });
