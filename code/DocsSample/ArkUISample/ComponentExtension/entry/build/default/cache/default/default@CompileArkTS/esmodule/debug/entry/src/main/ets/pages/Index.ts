if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface ComponentExtension_Params {
    router?: NavPathStack;
    routes?: RouteGroup[];
    selection?: string | null;
}
import curves from "@native:ohos.curves";
import type { Route, RouteGroup } from './common/Index';
import type { KeyboardAvoidMode } from "@ohos:arkui.UIContext";
class ComponentExtension extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__router = new ObservedPropertyObjectPU(new NavPathStack(), this, "router");
        this.addProvidedVar("router", this.__router, false);
        this.__routes = new ObservedPropertyObjectPU([
            {
                name: 'AnimatableExtendDecorator',
                label: { "id": 16777220, "type": 10003, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" },
                children: [
                    { name: 'AnimatablePropertyExample', label: { "id": 16777221, "type": 10003, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" } },
                    { name: 'AnimatablePropertyText', label: { "id": 16777222, "type": 10003, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" } },
                ]
            },
            {
                name: 'StylesDecorator',
                label: { "id": 16777225, "type": 10003, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" },
                children: [
                    { name: 'StylesDecorator1', label: { "id": 16777226, "type": 10003, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" } },
                    { name: 'StylesDecorator2', label: { "id": 16777227, "type": 10003, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" } },
                ]
            },
        ], this, "routes");
        this.__selection = new ObservedPropertyObjectPU(null, this, "selection");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: ComponentExtension_Params) {
        if (params.router !== undefined) {
            this.router = params.router;
        }
        if (params.routes !== undefined) {
            this.routes = params.routes;
        }
        if (params.selection !== undefined) {
            this.selection = params.selection;
        }
    }
    updateStateVars(params: ComponentExtension_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__router.purgeDependencyOnElmtId(rmElmtId);
        this.__routes.purgeDependencyOnElmtId(rmElmtId);
        this.__selection.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__router.aboutToBeDeleted();
        this.__routes.aboutToBeDeleted();
        this.__selection.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __router: ObservedPropertyObjectPU<NavPathStack>;
    get router() {
        return this.__router.get();
    }
    set router(newValue: NavPathStack) {
        this.__router.set(newValue);
    }
    private __routes: ObservedPropertyObjectPU<RouteGroup[]>;
    get routes() {
        return this.__routes.get();
    }
    set routes(newValue: RouteGroup[]) {
        this.__routes.set(newValue);
    }
    private __selection: ObservedPropertyObjectPU<string | null>;
    get selection() {
        return this.__selection.get();
    }
    set selection(newValue: string | null) {
        this.__selection.set(newValue);
    }
    ListItemGroupHeader(route: RouteGroup, parent = null) {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Row.create();
            Row.borderRadius(20);
            Row.width('100%');
            Row.padding(8);
            Row.enabled(!!route.children.length);
            ViewStackProcessor.visualState("pressed");
            Context.animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 });
            Row.backgroundColor('rgba(0,0,0,0.1)');
            Row.opacity(1);
            Context.animation(null);
            ViewStackProcessor.visualState("normal");
            Context.animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 });
            Row.backgroundColor('rgba(0,0,0,0)');
            Row.opacity(1);
            Context.animation(null);
            ViewStackProcessor.visualState("disabled");
            Context.animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 });
            Row.backgroundColor('rgba(0,0,0,0)');
            Row.opacity(0.5);
            Context.animation(null);
            ViewStackProcessor.visualState();
            Row.onClick(() => {
                Context.animateTo({ curve: curves.interpolatingSpring(0, 1, 228, 25) }, () => {
                    if (this.selection === route.name) {
                        this.selection = null;
                    }
                    else {
                        this.selection = route.name;
                    }
                });
            });
        }, Row);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(route.label);
            Text.fontColor({ "id": 125829210, "type": 10001, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" });
            Text.fontWeight(FontWeight.Medium);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Blank.create();
        }, Blank);
        Blank.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create(`${route.children.length}`);
            Text.fontColor({ "id": 125829216, "type": 10001, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" });
            Text.opacity(this.selection === route.name ? 0 : 1);
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Image.create({ "id": 125830088, "type": 20000, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" });
            Context.animation({ curve: curves.interpolatingSpring(0, 1, 228, 30) });
            Image.fillColor({ "id": 125829198, "type": 10001, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" });
            Image.height(24);
            Image.width(24);
            Image.rotate({ angle: this.selection === route.name ? 90 : 0 });
            Context.animation(null);
        }, Image);
        Row.pop();
    }
    aboutToAppear(): void {
        this.getUIContext().setKeyboardAvoidMode(1);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Column.create();
        }, Column);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            Text.create('ComponentExtension');
        }, Text);
        Text.pop();
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create();
            List.padding({ bottom: 10 });
        }, List);
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            ForEach.create();
            const forEachItemGenFunction = _item => {
                const routeGroup = _item;
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    ListItemGroup.create({
                        header: this.ListItemGroupHeader.bind(this, routeGroup),
                        style: ListItemGroupStyle.CARD
                    });
                    ListItemGroup.padding(2);
                    ListItemGroup.divider({ strokeWidth: 0.5 });
                }, ListItemGroup);
                this.observeComponentCreation2((elmtId, isInitialRender) => {
                    If.create();
                    if (routeGroup.name === this.selection) {
                        this.ifElseBranchUpdateFunction(0, () => {
                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                ForEach.create();
                                const forEachItemGenFunction = _item => {
                                    const route = _item;
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
                                            ListItem.width('100%');
                                        };
                                        const deepRenderFunction = (elmtId, isInitialRender) => {
                                            itemCreation(elmtId, isInitialRender);
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Row.create();
                                                ViewStackProcessor.visualState("pressed");
                                                Context.animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 });
                                                Row.backgroundColor('rgba(0,0,0,0.1)');
                                                Row.opacity(1);
                                                Context.animation(null);
                                                ViewStackProcessor.visualState("normal");
                                                Context.animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 });
                                                Row.backgroundColor('rgba(0,0,0,0)');
                                                Row.opacity(1);
                                                Context.animation(null);
                                                ViewStackProcessor.visualState("disabled");
                                                Context.animation({ curve: curves.cubicBezierCurve(0.33, 0, 0.67, 1), duration: 100 });
                                                Row.backgroundColor('rgba(0,0,0,0)');
                                                Row.opacity(0.5);
                                                Context.animation(null);
                                                ViewStackProcessor.visualState();
                                                Row.borderRadius(20);
                                                Row.padding(8);
                                                Row.transition(TransitionEffect.OPACITY.animation({
                                                    curve: curves.interpolatingSpring(0, 1, 228, 30)
                                                }));
                                                Row.width('100%');
                                                Row.onClick(() => {
                                                    const name = `pages/${routeGroup.name}/${route.name}`;
                                                    this.getUIContext().getRouter().pushUrl({ url: name });
                                                });
                                            }, Row);
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Text.create(route.label);
                                                Text.fontSize(16);
                                            }, Text);
                                            Text.pop();
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Blank.create();
                                            }, Blank);
                                            Blank.pop();
                                            this.observeComponentCreation2((elmtId, isInitialRender) => {
                                                Image.create({ "id": 125830088, "type": 20000, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" });
                                                Image.fillColor({ "id": 125829198, "type": 10001, params: [], "bundleName": "com.example.componentextension", "moduleName": "entry" });
                                                Image.height(24);
                                                Image.width(24);
                                            }, Image);
                                            Row.pop();
                                            ListItem.pop();
                                        };
                                        this.observeComponentCreation2(itemCreation2, ListItem);
                                        ListItem.pop();
                                    }
                                };
                                this.forEachUpdateFunction(elmtId, routeGroup.children, forEachItemGenFunction);
                            }, ForEach);
                            ForEach.pop();
                        });
                    }
                    else {
                        this.ifElseBranchUpdateFunction(1, () => {
                        });
                    }
                }, If);
                If.pop();
                ListItemGroup.pop();
            };
            this.forEachUpdateFunction(elmtId, this.routes, forEachItemGenFunction);
        }, ForEach);
        ForEach.pop();
        List.pop();
        Column.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "ComponentExtension";
    }
}
registerNamedRoute(() => new ComponentExtension(undefined, {}), "", { bundleName: "com.example.componentextension", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
