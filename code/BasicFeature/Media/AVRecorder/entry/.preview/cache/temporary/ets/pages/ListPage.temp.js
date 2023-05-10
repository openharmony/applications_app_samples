var _33e685f0ccb1747dd30a147821965b5a;
/******/ (() => { // webpackBootstrap
/******/ 	"use strict";
/******/ 	var __webpack_modules__ = ({

/***/ "D:\\avRecorder\\applications_app_samples\\media\\AVRecorder\\entry\\src\\main\\ets\\pages\\ListPage.ets?entry":
/*!***********************************************************************************************************!*\
  !*** D:\avRecorder\applications_app_samples\media\AVRecorder\entry\src\main\ets\pages\ListPage.ets?entry ***!
  \***********************************************************************************************************/
/***/ (function(__unused_webpack_module, exports) {


var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "ListPage_" + ++__generate__Id;
}
/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
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
var _ohos_router_1  = globalThis.requireNapi('router') || (isSystemplugin('router', 'ohos') ? globalThis.ohosplugin.router : isSystemplugin('router', 'system') ? globalThis.systemplugin.router : undefined);
class ListPage extends View {
    constructor(compilerAssignedUniqueChildId, parent, params) {
        super(compilerAssignedUniqueChildId, parent);
        this.__currentTabIndex = new ObservedPropertySimple(0, this, "currentTabIndex");
        this.updateWithValueParams(params);
    }
    updateWithValueParams(params) {
        if (params.currentTabIndex !== undefined) {
            this.currentTabIndex = params.currentTabIndex;
        }
    }
    aboutToBeDeleted() {
        this.__currentTabIndex.aboutToBeDeleted();
        SubscriberManager.Get().delete(this.id());
    }
    get currentTabIndex() {
        return this.__currentTabIndex.get();
    }
    set currentTabIndex(newValue) {
        this.__currentTabIndex.set(newValue);
    }
    NavigationTitle(parent = undefined) {
        Column.create();
        Column.debugLine("pages/ListPage.ets(24:5)");
        Text.create({ "id": 16777229, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.debugLine("pages/ListPage.ets(25:7)");
        Text.fontFamily('HarmonyHeiTi-Bold');
        Text.fontSize('24sp');
        Text.fontColor("#182431");
        Text.height('33dp');
        Text.width('312dp');
        Text.pop();
        Column.pop();
    }
    render() {
        Column.create();
        Column.debugLine("pages/ListPage.ets(35:5)");
        Column.backgroundColor({ "id": 16777301, "type": 10001, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Navigation.create();
        Navigation.debugLine("pages/ListPage.ets(36:7)");
        Navigation.backgroundColor({ "id": 16777301, "type": 10001, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Navigation.hideBackButton(true);
        Navigation.title({ builder: () => {
                this.NavigationTitle();
            } });
        Navigation.margin({
            top: '12dp',
            left: '24dp',
            right: '24dp',
            bottom: '0dp'
        });
        Navigation.width('360dp');
        Navigation.height('56dp');
        Navigation.pop();
        Column.create();
        Column.debugLine("pages/ListPage.ets(48:7)");
        Column.width('100%');
        Column.height('100%');
        Column.margin({
            top: '0dp'
        });
        Button.createWithChild();
        Button.debugLine("pages/ListPage.ets(49:9)");
        Button.width('336dp');
        Button.height('48dp');
        Button.backgroundColor('#FFFFFFFF');
        Button.borderRadius('24dp');
        Button.onClick(() => {
            _ohos_router_1.push({
                url: 'recorder/VRecorder',
            });
        });
        Button.margin({
            top: '12dp',
            left: '12dp',
        });
        Text.create({ "id": 16777231, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.debugLine("pages/ListPage.ets(50:11)");
        Text.fontFamily('HarmonyHeiTi-Medium');
        Text.width('64dp');
        Text.height('20dp');
        Text.fontColor('#000000');
        Text.fontSize('16sp');
        Text.margin({
            top: '14dp',
            left: '12dp',
            right: '260dp',
            bottom: '14dp'
        });
        Text.pop();
        Button.pop();
        Button.createWithChild();
        Button.debugLine("pages/ListPage.ets(75:9)");
        Button.width('336dp');
        Button.height('48dp');
        Button.backgroundColor('#FFFFFFFF');
        Button.borderRadius('24dp');
        Button.onClick(() => {
            _ohos_router_1.push({
                url: 'recorder/ARecorder',
            });
        });
        Button.margin({
            top: '12dp',
            left: '12dp',
        });
        Text.create({ "id": 16777230, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.debugLine("pages/ListPage.ets(76:11)");
        Text.fontFamily('HarmonyHeiTi-Medium');
        Text.width('64dp');
        Text.height('20dp');
        Text.fontColor('#000000');
        Text.fontSize('16sp');
        Text.margin({
            top: '14dp',
            left: '12dp',
            right: '260dp',
            bottom: '14dp'
        });
        Text.pop();
        Button.pop();
        Column.pop();
        Column.pop();
    }
}
loadDocument(new ListPage("1", undefined, {}));


/***/ })

/******/ 	});
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module is referenced by other modules so it can't be inlined
/******/ 	var __webpack_exports__ = {};
/******/ 	__webpack_modules__["D:\\avRecorder\\applications_app_samples\\media\\AVRecorder\\entry\\src\\main\\ets\\pages\\ListPage.ets?entry"](0, __webpack_exports__);
/******/ 	_33e685f0ccb1747dd30a147821965b5a = __webpack_exports__;
/******/ 	
/******/ })()
;
//# sourceMappingURL=ListPage.js.map