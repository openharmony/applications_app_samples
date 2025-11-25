if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ScrollExample_Params {
    scroller?: Scroller;
    arr?: number[];
    ListArr?: String[];
}
class ScrollExample extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.scroller = new Scroller();
        this.arr = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
        this.ListArr = ['test1', 'test2', 'test3', 'test4', 'test5', 'test6', 'test7', 'test8', 'test9', 'test10', 'test11'];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ScrollExample_Params) {
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.arr !== undefined) {
            this.arr = params.arr;
        }
        if (params.ListArr !== undefined) {
            this.ListArr = params.ListArr;
        }
    }
    updateStateVars(params: ScrollExample_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private scroller: Scroller;
    private arr: number[];
    private ListArr: String[];
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.height('100%');
            Row.alignItems(VerticalAlign.Top);
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.TopStart });
            Stack.width('100%');
            Stack.height('30%');
            Stack.backgroundColor(0xDCDCDC);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Scroll.create(this.scroller);
            Scroll.id('scroll_test');
            Scroll.scrollable(ScrollDirection.Vertical);
            Scroll.scrollBar(BarState.On);
            Scroll.scrollBarColor(Color.Gray);
            Scroll.scrollBarWidth(30);
            Scroll.edgeEffect(EdgeEffect.None);
            Scroll.onScroll((xOffset: number, yOffset: number) => {
                console.info(xOffset + ' ' + yOffset);
            });
            Scroll.onScrollEdge((side: Edge) => {
                console.info('To the edge');
            });
            Scroll.onScrollEnd(() => {
                console.info('Scroll Stop');
            });
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
            Column.width('100%');
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.toString());
                    Text.width('90%');
                    Text.height(50);
                    Text.backgroundColor(0xFFFFFF);
                    Text.borderRadius(15);
                    Text.fontSize(16);
                    Text.textAlign(TextAlign.Center);
                    Text.margin({ top: 10 });
                    Text.id('scroller_item_text');
                }, Text);
                Text.pop();
            };
            this.forEachUpdateFunction(elmtId, this.arr, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        Column.pop();
        Scroll.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('scroll 150');
            Button.onClick(() => {
                this.scroller.scrollBy(0, 150);
            });
            Button.margin({ top: 10, left: 20 });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('back top');
            Button.onClick(() => {
                this.scroller.scrollEdge(Edge.Top);
            });
            Button.margin({ top: 110, left: 20 });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('next page');
            Button.onClick(() => {
                this.scroller.scrollPage({ next: true });
            });
            Button.margin({ top: 170, left: 20 });
        }, Button);
        Button.pop();
        Stack.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Stack.create({ alignContent: Alignment.TopStart });
            Stack.width('100%');
            Stack.height('30%');
            Stack.backgroundColor(0xDCDCDC);
        }, Stack);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ space: 20, initialIndex: 0 });
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
                            Text.id('list_item_text');
                            Text.width('100%');
                            Text.height(100);
                            Text.fontSize(16);
                            Text.textAlign(TextAlign.Center);
                            Text.borderRadius(10);
                            Text.backgroundColor(0xFFFFFF);
                        }, Text);
                        Text.pop();
                        ListItem.pop();
                    };
                    this.observeComponentCreation2(itemCreation2, ListItem);
                    ListItem.pop();
                }
            };
            this.forEachUpdateFunction(elmtId, this.ListArr, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        List.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('scroll 150');
            Button.onClick(() => {
                this.scroller.scrollBy(0, 150);
            });
            Button.margin({ top: 10, left: 20 });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('back top');
            Button.onClick(() => {
                this.scroller.scrollEdge(Edge.Top);
            });
            Button.margin({ top: 110, left: 20 });
        }, Button);
        Button.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel('next page');
            Button.onClick(() => {
                this.scroller.scrollPage({ next: true });
            });
            Button.margin({ top: 170, left: 20 });
        }, Button);
        Button.pop();
        Stack.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ScrollExample";
    }
}
registerNamedRoute(() => new ScrollExample(undefined, {}), "", { bundleName: "com.samples.test.uitest", moduleName: "entry", pagePath: "pages/Scroller", pageFullPath: "entry/src/main/ets/pages/Scroller", integratedHsp: "false", moduleType: "followWithHap" });
