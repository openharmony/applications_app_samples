if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Fling_Params {
    message?: string;
    swiperController?: SwiperController;
    result?;
    scroller?: Scroller;
    arr?: number[];
}
class Fling extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__message = new ObservedPropertySimplePU('Hello World', this, "message");
        this.swiperController = new SwiperController();
        this.result = ['jsunit', 'uitest', 'arkUI', 'tdd'];
        this.scroller = new Scroller();
        this.arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Fling_Params) {
        if (params.message !== undefined) {
            this.message = params.message;
        }
        if (params.swiperController !== undefined) {
            this.swiperController = params.swiperController;
        }
        if (params.result !== undefined) {
            this.result = params.result;
        }
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.arr !== undefined) {
            this.arr = params.arr;
        }
    }
    updateStateVars(params: Fling_Params) {
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
    private swiperController: SwiperController;
    private result;
    private scroller: Scroller;
    private arr: number[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.alignItems(VerticalAlign.Top);
            Row.height('100%');
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithChild();
        }, Button);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('next page');
            Text.fontSize(25);
            Text.fontWeight(FontWeight.Bold);
        }, Text);
        Text.pop();
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(this.message);
            Text.fontSize(50);
            Text.fontWeight(FontWeight.Bold);
            Text.id('swiper_text');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Swiper.create(this.swiperController);
            Swiper.id('swiper');
            Swiper.cachedCount(2);
            Swiper.index(0);
            Swiper.autoPlay(false);
            Swiper.interval(4000);
            Swiper.indicator(true);
            Swiper.loop(true);
            Swiper.duration(500);
            Swiper.itemSpace(0);
            Swiper.curve(Curve.Linear);
            Swiper.onChange((index: number) => {
                this.message = this.result[index];
                console.info(index.toString());
            });
        }, Swiper);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item);
                    Text.width('90%');
                    Text.height(160);
                    Text.backgroundColor(0xAFEEEE);
                    Text.textAlign(TextAlign.Center);
                    Text.fontSize(30);
                }, Text);
                Text.pop();
            };
            this.forEachUpdateFunction(elmtId, this.result, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        Swiper.pop();
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
            Column.create();
            Column.height('300');
            Column.width('100%');
            Column.backgroundColor('#99FF33');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ space: 20, initialIndex: 0 });
            List.listDirection(Axis.Vertical);
            List.divider({
                strokeWidth: 2,
                color: 0xFFFFFF,
                startMargin: 20,
                endMargin: 20
            });
            List.edgeEffect(EdgeEffect.None);
            List.chainAnimation(false);
            List.onScrollIndex((firstIndex: number, lastIndex: number) => {
                console.info('first' + firstIndex);
                console.info('last' + lastIndex);
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
                        ListItem.editable(true);
                    };
                    const deepRenderFunction = (elmtId, isInitialRender) => {
                        itemCreation(elmtId, isInitialRender);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create('' + item);
                            Text.width('100%');
                            Text.height(100);
                            Text.fontSize(16);
                            Text.textAlign(TextAlign.Center);
                            Text.borderRadius(10);
                            Text.backgroundColor('#CC0000');
                        }, Text);
                        Text.pop();
                        ListItem.pop();
                    };
                    this.observeComponentCreation2(itemCreation2, ListItem);
                    ListItem.pop();
                }
            };
            this.forEachUpdateFunction(elmtId, this.arr, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        List.pop();
        Column.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Fling";
    }
}
registerNamedRoute(() => new Fling(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Fling", pageFullPath: "entry/src/main/ets/pages/Fling", integratedHsp: "false", moduleType: "followWithHap" });
