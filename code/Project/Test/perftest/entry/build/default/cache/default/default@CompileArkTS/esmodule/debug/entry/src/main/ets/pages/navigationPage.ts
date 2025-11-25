if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    pageInfos?: NavPathStack;
}
interface Dialog01_Params {
    pageInfos?: NavPathStack;
}
interface Page01_Params {
    pageInfos?: NavPathStack;
}
class Page01 extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__pageInfos = this.initializeConsume('pageInfos', "pageInfos");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Page01_Params) {
    }
    updateStateVars(params: Page01_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__pageInfos.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__pageInfos.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __pageInfos: ObservedPropertyAbstractPU<NavPathStack>;
    get pageInfos() {
        return this.__pageInfos.get();
    }
    set pageInfos(newValue: NavPathStack) {
        this.__pageInfos.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            NavDestination.create(() => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Button.createWithLabel({ "id": 16777226, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
                    Button.width('80%');
                    Button.onClick(() => {
                        this.pageInfos.pushPathByName('Page01', '');
                    });
                    Button.margin({ top: 10, bottom: 10 });
                }, Button);
                Button.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Button.createWithLabel({ "id": 16777221, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
                    Button.width('80%');
                    Button.onClick(() => {
                        this.pageInfos.pushPathByName('Dialog01', '');
                    });
                    Button.margin({ top: 10, bottom: 10 });
                }, Button);
                Button.pop();
            }, { moduleName: "entry", pagePath: "entry/src/main/ets/pages/navigationPage" });
            NavDestination.title({ "id": 16777225, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
        }, NavDestination);
        NavDestination.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
class Dialog01 extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__pageInfos = this.initializeConsume('pageInfos', "pageInfos");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Dialog01_Params) {
    }
    updateStateVars(params: Dialog01_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__pageInfos.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__pageInfos.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __pageInfos: ObservedPropertyAbstractPU<NavPathStack>;
    get pageInfos() {
        return this.__pageInfos.get();
    }
    set pageInfos(newValue: NavPathStack) {
        this.__pageInfos.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            NavDestination.create(() => {
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Stack.create();
                }, Stack);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.width('100%');
                    Column.height('100%');
                    Column.backgroundColor(Color.Gray);
                    Column.opacity(0.1);
                    Column.onClick(() => {
                        this.pageInfos.pop();
                    });
                }, Column);
                Column.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Column.create();
                    Column.padding(10);
                    Column.width(250);
                    Column.backgroundColor(Color.White);
                    Column.borderRadius(10);
                }, Column);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Text.create({ "id": 16777220, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
                    Text.fontSize(30);
                    Text.fontWeight(2);
                }, Text);
                Text.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Button.createWithLabel({ "id": 16777226, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
                    Button.width('80%');
                    Button.onClick(() => {
                        this.pageInfos.pushPathByName('Page01', '');
                    });
                    Button.margin({ top: 10, bottom: 10 });
                }, Button);
                Button.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Button.createWithLabel({ "id": 16777221, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
                    Button.width('80%');
                    Button.onClick(() => {
                        this.pageInfos.pushPathByName('Dialog01', '');
                    });
                    Button.margin({ top: 10, bottom: 10 });
                }, Button);
                Button.pop();
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    Button.createWithLabel({ "id": 16777229, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
                    Button.width('80%');
                    Button.onClick(() => {
                        this.pageInfos.pop();
                    });
                    Button.margin({ top: 10, bottom: 10 });
                }, Button);
                Button.pop();
                Column.pop();
                Stack.pop();
            }, { moduleName: "entry", pagePath: "entry/src/main/ets/pages/navigationPage" });
            NavDestination.hideTitleBar(true);
            NavDestination.mode(NavDestinationMode.DIALOG);
        }, NavDestination);
        NavDestination.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
}
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__pageInfos = new ObservedPropertyObjectPU(new NavPathStack(), this, "pageInfos");
        this.addProvidedVar("pageInfos", this.__pageInfos, false);
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.pageInfos !== undefined) {
            this.pageInfos = params.pageInfos;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__pageInfos.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__pageInfos.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __pageInfos: ObservedPropertyObjectPU<NavPathStack>;
    get pageInfos() {
        return this.__pageInfos.get();
    }
    set pageInfos(newValue: NavPathStack) {
        this.__pageInfos.set(newValue);
    }
    PagesMap(name: string, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            If.create();
            if (name == 'Page01') {
                this.ifElseBranchUpdateFunction(0, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new Page01(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/navigationPage.ets", line: 96, col: 7 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {};
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, { name: "Page01" });
                    }
                });
            }
            else if (name == 'Dialog01') {
                this.ifElseBranchUpdateFunction(1, () => {
                    {
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            if (isInitialRender) {
                                let componentCall = new Dialog01(this, {}, undefined, elmtId, () => { }, { page: "entry/src/main/ets/pages/navigationPage.ets", line: 98, col: 7 });
                                ViewPU.create(componentCall);
                                let paramsLambda = () => {
                                    return {};
                                };
                                componentCall.paramsGenerator_ = paramsLambda;
                            }
                            else {
                                this.updateStateVarsOfChildByElmtId(elmtId, {});
                            }
                        }, { name: "Dialog01" });
                    }
                });
            }
            else {
                this.ifElseBranchUpdateFunction(2, () => {
                });
            }
        }, If);
        If.pop();
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Navigation.create(this.pageInfos, { moduleName: "entry", pagePath: "entry/src/main/ets/pages/navigationPage", isUserCreateStack: true });
            Navigation.mode(NavigationMode.Stack);
            Navigation.titleMode(NavigationTitleMode.Mini);
            Navigation.title({ "id": 16777230, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
            Navigation.navDestination({ builder: this.PagesMap.bind(this) });
        }, Navigation);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Button.createWithLabel({ "id": 16777226, "type": 10003, params: [], "bundleName": "com.samples.test.perftest", "moduleName": "entry" });
            Button.width('80%');
            Button.onClick(() => {
                this.pageInfos.pushPathByName('Page01', '');
            });
        }, Button);
        Button.pop();
        Navigation.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.samples.test.perftest", moduleName: "entry", pagePath: "pages/navigationPage", pageFullPath: "entry/src/main/ets/pages/navigationPage", integratedHsp: "false", moduleType: "followWithHap" });
