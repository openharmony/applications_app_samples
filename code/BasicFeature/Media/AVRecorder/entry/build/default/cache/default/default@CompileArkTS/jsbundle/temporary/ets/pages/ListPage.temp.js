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
        this.updateWithValueParams(params);
    }
    updateWithValueParams(params) {
    }
    aboutToBeDeleted() {
        SubscriberManager.Get().delete(this.id());
    }
    render() {
        Column.create();
        Column.backgroundColor('#F1F3F5');
        Column.width('100%');
        Column.height('100%');
        Column.alignItems(HorizontalAlign.Start);
        Text.create({ "id": 16777225, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.fontFamily('HarmonyHeiTi-Bold');
        Text.fontSize(24);
        Text.fontColor("#182431");
        Text.height(33);
        Text.width(312);
        Text.margin({ left: 24, right: 24, top: 12, bottom: 12 });
        Text.pop();
        Button.createWithChild();
        Button.height(48);
        Button.backgroundColor('#FFFFFF');
        Button.borderRadius(24);
        Button.onClick(() => {
            _ohos_router_1.push({
                url: 'recorder/VRecorder',
            });
        });
        Button.margin({ left: 12, right: 12, top: 0, bottom: 12 });
        Text.create({ "id": 16777227, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.fontFamily('HarmonyHeiTi-Medium');
        Text.width(64);
        Text.height(20);
        Text.fontColor('#000000');
        Text.fontSize(16);
        Text.margin({ left: 12, right: 336, top: 12, bottom: 12 });
        Text.pop();
        Button.pop();
        Button.createWithChild();
        Button.height(48);
        Button.backgroundColor('#FFFFFF');
        Button.borderRadius(24);
        Button.onClick(() => {
            _ohos_router_1.push({
                url: 'recorder/ARecorder',
            });
        });
        Button.margin({ left: 12, right: 12, top: 0, bottom: 12 });
        Text.create({ "id": 16777226, "type": 10003, params: [], "bundleName": "com.samples.avrecorder", "moduleName": "entry" });
        Text.fontFamily('HarmonyHeiTi-Medium');
        Text.width(64);
        Text.height(20);
        Text.fontColor('#000000');
        Text.fontSize(16);
        Text.margin({ left: 12, right: 336, top: 12, bottom: 12 });
        Text.pop();
        Button.pop();
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