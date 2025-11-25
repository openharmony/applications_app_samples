if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ListPage_Params {
    scroller?: Scroller;
    arr?: number[];
}
class ListPage extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.scroller = new Scroller();
        this.arr = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ListPage_Params) {
        if (params.scroller !== undefined) {
            this.scroller = params.scroller;
        }
        if (params.arr !== undefined) {
            this.arr = params.arr;
        }
    }
    updateStateVars(params: ListPage_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private scroller: Scroller;
    private arr: number[];
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
            Scroll.create(this.scroller);
            Scroll.width('100%');
            Scroll.height('100%');
            Scroll.scrollable(ScrollDirection.Vertical);
            Scroll.scrollBar(BarState.On);
            Scroll.scrollBarColor(Color.Gray);
        }, Scroll);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const item = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create(item.toString());
                    Text.width('90%');
                    Text.height('40%');
                    Text.fontSize(80);
                    Text.textAlign(TextAlign.Center);
                    Text.margin({ top: 10 });
                }, Text);
                Text.pop();
            };
            this.forEachUpdateFunction(elmtId, this.arr, forEachItemGenFunction, (item: string) => item, false, false);
        }, ForEach);
        ForEach.pop();
        Column.pop();
        Scroll.pop();
        Column.pop();
        Row.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ListPage";
    }
}
registerNamedRoute(() => new ListPage(undefined, {}), "", { bundleName: "com.samples.test.perftest", moduleName: "entry", pagePath: "pages/PageListPage", pageFullPath: "entry/src/main/ets/pages/PageListPage", integratedHsp: "false", moduleType: "followWithHap" });
