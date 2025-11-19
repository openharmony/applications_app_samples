if (!("finalizeConstruction" in ViewPU.prototype)) {
    Reflect.set(ViewPU.prototype, "finalizeConstruction", () => { });
}
interface Index_Params {
    createNavigationListIndex?: CreateRouter[];
}
/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
class CreateRouter {
    public pageName: string;
    public routerName: string;
    constructor(pageName: string, routerName: string) {
        this.pageName = pageName;
        this.routerName = routerName;
    }
}
const createRouterList: CreateRouter[] = [
    new CreateRouter('ParentComponentPage', 'component/ParentComponent'),
    new CreateRouter('ParameterSpecificationPage', 'component/ParameterSpecification'),
    new CreateRouter('ParentFunctionPage', 'component/ParentFunction'),
    new CreateRouter('MyComponentBuildPage', 'component/MyComponentBuild'),
    new CreateRouter('MyComponentStylePage', 'component/MyComponentStyle'),
    new CreateRouter('StaticCodeV1Page', 'component/StaticCodeV1'),
    new CreateRouter('StaticCodeV2Page', 'component/StaticCodeV2'),
    new CreateRouter('stateManagementOverviewPage', 'managementoverview/stateManagementOverview'),
    new CreateRouter('ComponentPage', 'component/Component'),
    new CreateRouter('FreezeWhenInactivePage', 'component/FreezeWhenInactive'),
    new CreateRouter('BuildFunctionPage', 'component/BuildFunction'),
    new CreateRouter('EntryPage', 'component/Entry'),
    new CreateRouter('RouteNamePage', 'component/RouteName'),
    new CreateRouter('ReusablePage', 'component/Reusable'),
    new CreateRouter('BuilderMethodPage', 'component/BuilderMethod'),
    new CreateRouter('IfPage', 'component/If'),
    new CreateRouter('ModuleComponentPage', 'component/ModuleComponent'),
    new CreateRouter('ForEachFilterPage', 'component/ForEachFilter'),
];
class Index extends ViewPU {
    constructor(parent, params, __localStorage, elmtId = -1, paramsLambda = undefined, extraInfo) {
        super(parent, __localStorage, elmtId, extraInfo);
        if (typeof paramsLambda === "function") {
            this.paramsGenerator_ = paramsLambda;
        }
        this.__createNavigationListIndex = new ObservedPropertyObjectPU(createRouterList, this, "createNavigationListIndex");
        this.setInitiallyProvidedValue(params);
        this.finalizeConstruction();
    }
    setInitiallyProvidedValue(params: Index_Params) {
        if (params.createNavigationListIndex !== undefined) {
            this.createNavigationListIndex = params.createNavigationListIndex;
        }
    }
    updateStateVars(params: Index_Params) {
    }
    purgeVariableDependenciesOnElmtId(rmElmtId) {
        this.__createNavigationListIndex.purgeDependencyOnElmtId(rmElmtId);
    }
    aboutToBeDeleted() {
        this.__createNavigationListIndex.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id__());
        this.aboutToBeDeletedInternal();
    }
    private __createNavigationListIndex: ObservedPropertyObjectPU<CreateRouter[]>;
    get createNavigationListIndex() {
        return this.__createNavigationListIndex.get();
    }
    set createNavigationListIndex(newValue: CreateRouter[]) {
        this.__createNavigationListIndex.set(newValue);
    }
    initialRender() {
        this.observeComponentCreation2((elmtId, isInitialRender) => {
            List.create({ space: 3 });
            List.alignListItem(ListItemAlign.Center);
            List.height('auto');
            List.width('auto');
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
                    };
                    const deepRenderFunction = (elmtId, isInitialRender) => {
                        itemCreation(elmtId, isInitialRender);
                        this.observeComponentCreation2((elmtId, isInitialRender) => {
                            Text.create(item.pageName);
                            Text.textAlign(TextAlign.Center);
                            Text.width('90%');
                            Text.height(30);
                            Text.borderRadius(5);
                            Text.backgroundColor('#f5f5f5');
                            Text.onClick(() => {
                                this.getUIContext().getRouter().pushUrl({
                                    url: `${item.routerName}`
                                });
                            });
                        }, Text);
                        Text.pop();
                        ListItem.pop();
                    };
                    this.observeComponentCreation2(itemCreation2, ListItem);
                    ListItem.pop();
                }
            };
            this.forEachUpdateFunction(elmtId, this.createNavigationListIndex, forEachItemGenFunction, (item: CreateRouter, index: number) => JSON.stringify(item), false, true);
        }, ForEach);
        ForEach.pop();
        List.pop();
    }
    rerender() {
        this.updateDirtyElements();
    }
    static getEntryName(): string {
        return "Index";
    }
}
registerNamedRoute(() => new Index(undefined, {}), "", { bundleName: "com.samples.createcustomcomponents", moduleName: "entry", pagePath: "pages/Index", pageFullPath: "entry/src/main/ets/pages/Index", integratedHsp: "false", moduleType: "followWithHap" });
