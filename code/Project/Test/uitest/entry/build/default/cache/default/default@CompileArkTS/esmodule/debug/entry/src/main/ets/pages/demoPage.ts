if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ScrollExample_Params {
    scroller?: Scroller;
    hoverText?: string;
    pressure?: number;
    arr?: number[];
}
import router from "@native:system.router";
import promptAction from "@ohos:promptAction";
class ScrollExample extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.scroller = new Scroller();
        this.__hoverText = new ObservedPropertySimplePU('jump', this, "hoverText");
        this.__pressure = new ObservedPropertySimplePU(0.0, this, "pressure");
        this.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ScrollExample_Params) {
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.hoverText !== undefined) {
            this.hoverText = params.hoverText;
        }
        if (params.pressure !== undefined) {
            this.pressure = params.pressure;
        }
        if (params.arr !== undefined) {
            this.arr = params.arr;
        }
    }
    updateStateVars(params: ScrollExample_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__hoverText.purgeDependencyOnElmtId(rmElmtId);
        this.__pressure.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__hoverText.aboutToBeDeleted();
        this.__pressure.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private scroller: Scroller;
    private __hoverText: ObservedPropertySimplePU<string>;
    get hoverText() {
        return this.__hoverText.get();
    }
    set hoverText(newValue: string) {
        this.__hoverText.set(newValue);
    }
    private __pressure: ObservedPropertySimplePU<number>;
    get pressure() {
        return this.__pressure.get();
    }
    set pressure(newValue: number) {
        this.__pressure.set(newValue);
    }
    private arr: number[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Flex.create({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center });
        }, Flex);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('MainPage');
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.TopStart });
            Stack.width('100%');
            Stack.height('100%');
            Stack.backgroundColor(0xDCDCDC);
            Stack.onTouch((event) => {
                this.pressure = event.pressure;
            });
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create(this.scroller);
            Scroll.scrollable(ScrollDirection.Vertical);
            Scroll.scrollBar(BarState.On);
            Scroll.scrollBarColor(Color.Gray);
            Scroll.scrollBarWidth(30);
            Scroll.onScroll((xOffset: number, yOffset: number) => {
            });
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('toast');
            Button.fontSize(25);
            Button.fontWeight(FontWeight.Bold);
            Button.onClick(() => {
                try {
                    promptAction.showToast({
                        message: 'toastShow',
                        duration: 60000
                    });
                }
                catch (error) {
                }
                ;
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('dialog');
            Button.fontSize(25);
            Button.fontWeight(FontWeight.Bold);
            Button.onClick(() => {
                AlertDialog.show({
                    title: '',
                    message: 'dialogShow',
                    alignment: DialogAlignment.Bottom,
                    confirm: {
                        value: 'close',
                        action: () => {
                        }
                    }
                });
            });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.key('my-key');
            Button.type(ButtonType.Capsule);
            Button.margin({ top: 20 });
            Button.onClick(() => {
                router.push({ uri: 'pages/second' });
            });
            Gesture.create(GesturePriority.Low);
            LongPressGesture.create({ repeat: false });
            LongPressGesture.onAction((event: GestureEvent) => {
                router.push({ uri: 'pages/Fourth' });
            });
            LongPressGesture.pop();
            Gesture.pop();
            Gesture.create(GesturePriority.Low);
            LongPressGesture.create({ repeat: false, duration: 1800 });
            LongPressGesture.onAction((event: GestureEvent) => {
                router.push({ uri: 'pages/fourth' });
            });
            LongPressGesture.pop();
            Gesture.pop();
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('next page');
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
            TapGesture.create({ count: 1 });
            TapGesture.onAction(() => {
                router.push({ uri: 'pages/Third' });
            });
            TapGesture.pop();
            Gesture.pop();
            Gesture.create(GesturePriority.Low);
            LongPressGesture.create({ repeat: false });
            LongPressGesture.onAction((event: GestureEvent) => {
                router.push({ uri: 'pages/wearList' });
            });
            LongPressGesture.pop();
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
            Button.key('jump');
            Button.margin({ top: 20 });
            Button.onHover((isHover: boolean) => {
                if (isHover) {
                    this.hoverText = 'hover';
                }
            });
            Button.onMouse((event: MouseEvent) => {
                switch (event.button) {
                    case MouseButton.Left:
                        this.hoverText = 'left';
                        break;
                    case MouseButton.Right:
                        this.hoverText = 'right';
                        break;
                    case MouseButton.Middle:
                        this.hoverText = 'middle';
                        break;
                }
            });
            Button.onClick(() => {
                router.push({ uri: 'pages/Pinch' });
            });
            Gesture.create(GesturePriority.Low);
            LongPressGesture.create({ repeat: false });
            LongPressGesture.onAction((event: GestureEvent) => {
                router.push({ uri: 'pages/Drag' });
            });
            LongPressGesture.pop();
            Gesture.pop();
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.hoverText);
            Text.fontSize(25);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.type(ButtonType.Capsule);
            Button.margin({ top: 20 });
            Button.onClick(() => {
                router.push({ uri: 'pages/scroll' });
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('scroll');
            Text.fontSize(25);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Checkbox.create({ name: 'hi' });
            Checkbox.size({ width: 30, height: 30 });
        }, Checkbox);
        Checkbox.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            TextInput.create({ placeholder: 'welcome', text: 'Hello World' });
            TextInput.type(InputType.Normal);
            TextInput.width(300);
            TextInput.height(50);
            TextInput.fontSize(40);
            TextInput.enabled(true);
            TextInput.margin({ top: 20 });
        }, TextInput);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.toString());
                    Text.width('100%');
                    Text.height('30%');
                    Text.backgroundColor(0xFFFFFF);
                    Text.borderRadius(75);
                    Text.fontSize(80);
                    Text.textAlign(TextAlign.Center);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
            };
            this.forEachUpdateFunction(elmtId, this.arr, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.type(ButtonType.Capsule);
            Button.margin({
                top: 20, left: 150
            });
            Button.onClick(() => {
                router.push({ uri: 'pages/second' });
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('bottom');
            Text.fontSize(25);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        Column.pop();
        Scroll.pop();
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.pressure.toFixed(1));
            Text.id('pressure');
            Text.fontSize(20);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('MainPage_End');
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Flex.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ScrollExample";
    }
}
registerNamedRoute(() => new ScrollExample(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/demoPage", pageFullPath: "entry/src/main/ets/pages/demoPage", integratedHsp: "false", moduleType: "followWithHap" });
