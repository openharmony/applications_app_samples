if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Mouse_Params {
    message?: string;
    count?: number;
    hoverText?: string;
    hoverMsg?: string;
    scroller?: Scroller;
    arr?: number[];
}
import router from "@ohos:router";
class Mouse extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('Hello World', this, "message");
        this.__count = new ObservedPropertySimplePU(0, this, "count");
        this.__hoverText = new ObservedPropertySimplePU('jump', this, "hoverText");
        this.__hoverMsg = new ObservedPropertySimplePU('hoverText', this, "hoverMsg");
        this.scroller = new Scroller();
        this.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18.19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Mouse_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
        if (params.count !== undefined) {
            this.count = params.count;
        }
        if (params.hoverText !== undefined) {
            this.hoverText = params.hoverText;
        }
        if (params.hoverMsg !== undefined) {
            this.hoverMsg = params.hoverMsg;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.arr !== undefined) {
            this.arr = params.arr;
        }
    }
    updateStateVars(params: Mouse_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__message.purgeDependencyOnElmtId(rmElmtId);
        this.__count.purgeDependencyOnElmtId(rmElmtId);
        this.__hoverText.purgeDependencyOnElmtId(rmElmtId);
        this.__hoverMsg.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__message.aboutToBeDeleted();
        this.__count.aboutToBeDeleted();
        this.__hoverText.aboutToBeDeleted();
        this.__hoverMsg.aboutToBeDeleted();
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
    private __hoverText: ObservedPropertySimplePU<string>;
    get hoverText() {
        return this.__hoverText.get();
    }
    set hoverText(newValue: string) {
        this.__hoverText.set(newValue);
    }
    private __hoverMsg: ObservedPropertySimplePU<string>;
    get hoverMsg() {
        return this.__hoverMsg.get();
    }
    set hoverMsg(newValue: string) {
        this.__hoverMsg.set(newValue);
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
            Button.createWithChild();
            Button.id('hover_bt');
            Button.onHover((isHover: boolean | undefined, event?: HoverEvent | undefined) => {
                if (isHover) {
                    this.hoverMsg = 'hover';
                }
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.hoverMsg);
            Text.id('hoverText');
            Text.fontSize(25);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.onClick((event?: ClickEvent) => {
                router.pushUrl({
                    url: 'pages/five'
                });
            });
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('toMouseDrag');
            Text.id('toMouseDrag');
            Text.fontSize(15);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
            Button.id('mouse_test');
            Button.type(ButtonType.Capsule);
            Button.margin({ top: 20 });
            Button.onHover((isHover: boolean | undefined, event?: HoverEvent | undefined) => {
                if (isHover) {
                    this.hoverText = 'hover';
                }
            });
            Button.onMouse((event: MouseEvent) => {
                switch (event.button) {
                    case MouseButton.Left:
                        console.log('ljl', 'left');
                        this.hoverText = 'left';
                        break;
                    case MouseButton.Right:
                        this.hoverText = 'right';
                        break;
                    case MouseButton.Middle:
                        this.hoverText = 'middle';
                        break;
                    default:
                        console.log('ljl', 'defaultTest');
                        break;
                }
            });
            Gesture.create(GesturePriority.Low);
            TapGesture.create({ count: 2 });
            TapGesture.onAction(() => {
                router.pushUrl({
                    url: 'pages/Third'
                });
            });
            TapGesture.pop();
            Gesture.pop();
            Gesture.create(GesturePriority.Low);
            LongPressGesture.create({ repeat: false });
            LongPressGesture.onAction(() => {
                router.pushUrl({
                    url: 'pages/Fourth'
                });
            });
            LongPressGesture.pop();
            Gesture.pop();
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.hoverText);
            Text.id('mouse_test_result');
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
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Mouse";
    }
}
registerNamedRoute(() => new Mouse(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Mouse", pageFullPath: "entry/src/main/ets/pages/Mouse", integratedHsp: "false", moduleType: "followWithHap" });
