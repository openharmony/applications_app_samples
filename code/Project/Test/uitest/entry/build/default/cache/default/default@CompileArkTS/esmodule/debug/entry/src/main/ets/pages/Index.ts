if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    message?: string;
    count?: number;
    scroller?: Scroller;
    arr?: number[];
}
import promptAction from "@ohos:promptAction";
import router from "@ohos:router";
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('Hello World', this, "message");
        this.__count = new ObservedPropertySimplePU(0, this, "count");
        this.scroller = new Scroller();
        this.arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
        if (params.count !== undefined) {
            this.count = params.count;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.arr !== undefined) {
            this.arr = params.arr;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
        this.__count.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        this.__count.aboutToBeDeleted();
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
    private __count: ObservedPropertySimplePU<number>;
    get count() {
        return this.__count.get();
    }
    set count(newValue: number) {
        this.__count.set(newValue);
    }
    private scroller: Scroller;
    private arr: number[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height('100%');
            Row.backgroundColor('#FF3333');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
            Column.height('100%');
            Column.alignItems(HorizontalAlign.Start);
            Column.backgroundColor('#800000');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.message);
            Text.fontSize(10);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Next');
            Text.fontSize(10);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('after click');
            Text.fontSize(10);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('idTest');
            Text.id('idTest');
            Text.fontSize(10);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.height('300');
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create(this.scroller);
            Scroll.id('scroll_test');
            Scroll.scrollBar(BarState.Off);
            Scroll.scrollable(ScrollDirection.Vertical);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ direction: FlexDirection.Column });
            Flex.margin({ right: 10 });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Row.create();
                }, Row);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.toString());
                    Text.width('90%');
                    Text.height(100);
                    Text.id('scroll_item');
                    Text.backgroundColor('#3366CC');
                    Text.borderRadius(15);
                    Text.fontSize(16);
                    Text.textAlign(TextAlign.Center);
                    Text.margin({ top: 5 });
                }, Text);
                Text.pop();
                Row.pop();
            };
            this.forEachUpdateFunction(elmtId, this.arr, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        Flex.pop();
        Scroll.pop();
        Column.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.margin({ top: 10 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.id('btnTest');
            Button.onClick(() => {
                router.replaceUrl({
                    url: 'pages/Scroller'
                });
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('ButtonTest');
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.id('btnTest');
            Button.onClick(() => {
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('ButtonTest1');
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('showToast', { type: ButtonType.Normal, stateEffect: true });
            Button.borderRadius(8);
            Button.backgroundColor(0x317aff);
            Button.width(90);
            Button.onClick(() => {
                console.log('ButtonType.Normal');
                promptAction.showToast({
                    message: 'testMessage',
                    duration: 2000
                });
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('showDialog', { type: ButtonType.Normal, stateEffect: true });
            Button.borderRadius(8);
            Button.backgroundColor(0x317aff);
            Button.width(90);
            Button.onClick(() => {
                console.log('ButtonType.Normal dialog');
                promptAction.showDialog({
                    title: 'testDialog',
                    message: 'testMessage'
                });
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.id('drag');
            Button.onClick(() => {
                router.push({
                    url: 'pages/Drag'
                });
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Drag');
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.id('inch');
            Button.onClick(() => {
                router.push({
                    url: 'pages/Pinch'
                });
            });
            Button.margin({ left: 10 });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('Pinch');
        }, Text);
        Text.pop();
        Button.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.margin({ top: 10 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Toggle.create({ type: ToggleType.Switch, isOn: false });
            Toggle.selectedColor('#007DFF');
            Toggle.switchPointColor('#FFFFFF');
            Toggle.onChange((isOn: boolean) => {
                console.info('Component status:' + isOn);
            });
            Toggle.id('Toggle_switch_false');
        }, Toggle);
        Toggle.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Toggle.create({ type: ToggleType.Switch, isOn: true });
            Toggle.selectedColor('#007DFF');
            Toggle.switchPointColor('#FFFFFF');
            Toggle.onChange((isOn: boolean) => {
                console.info('Component status:' + isOn);
            });
            Toggle.id('Toggle_switch_true');
        }, Toggle);
        Toggle.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.margin({ top: 10 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Checkbox.create({ name: 'checkbox1', group: 'checkboxGroup' });
            Checkbox.select(true);
            Checkbox.selectedColor(0xed6f21);
            Checkbox.onChange((value: boolean) => {
                console.info('Checkbox1 change is' + value);
            });
            Checkbox.id('check_test_checked');
        }, Checkbox);
        Checkbox.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Checkbox.create({ name: 'checkbox2', group: 'checkboxGroup' });
            Checkbox.select(false);
            Checkbox.selectedColor(0x39a2db);
            Checkbox.onChange((value: boolean) => {
                console.info('Checkbox2 change is' + value);
            });
            Checkbox.id('check_test_not_checked');
        }, Checkbox);
        Checkbox.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.margin({ top: 10 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Select.create([{ value: 'aaa', icon: '/common/1.png' },
                { value: 'bbb', icon: '/common/2.png' },
                { value: 'ccc', icon: '/common/3.png' },
                { value: 'ddd', icon: '/common/4.png' }]);
            Select.selected(2);
            Select.value('TTT');
            Select.font({
                size: 30,
                weight: 400,
                family: 'serif',
                style: FontStyle.Normal
            });
            Select.selectedOptionFont({
                size: 40,
                weight: 500,
                family: 'serif',
                style: FontStyle.Normal
            });
            Select.optionFont({
                size: 30,
                weight: 400,
                family: 'serif',
                style: FontStyle.Normal
            });
            Select.onSelect((index: number) => {
                console.info('Select:' + index);
            });
        }, Select);
        Select.pop();
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.margin({ top: 10 });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Radio.create({ value: 'Radio1', group: 'radioGroup' });
            Radio.checked(false);
            Radio.id('radio_test');
        }, Radio);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Radio.create({ value: 'Radio2', group: 'radioGroup' });
            Radio.checked(true);
            Radio.id('radio_test1');
        }, Radio);
        Row.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('unit_jsunit');
            Text.fontSize(30);
            Text.fontWeight(FontWeight.Bold);
            Gesture.create(GesturePriority.Low);
            TapGesture.create({ count: 2 });
            TapGesture.onAction(() => {
                router.push({ url: 'pages/Swipe' });
            });
            TapGesture.pop();
            Gesture.pop();
        }, Text);
        Text.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
