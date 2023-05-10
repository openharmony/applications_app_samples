var _33e685f0ccb1747dd30a147821965b5a;
/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "D:\\avRecorder\\applications_app_samples\\media\\AVRecorder\\entry\\src\\main\\ets\\entryability\\EntryAbility.ts?entry":
/*!*********************************************************************************************************************!*\
  !*** D:\avRecorder\applications_app_samples\media\AVRecorder\entry\src\main\ets\entryability\EntryAbility.ts?entry ***!
  \*********************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports, __webpack_require__) {

"use strict";

/*
 * Copyright (C) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
var _ohos_hilog_1  = globalThis.requireNapi('hilog') || (isSystemplugin('hilog', 'ohos') ? globalThis.ohosplugin.hilog : isSystemplugin('hilog', 'system') ? globalThis.systemplugin.hilog : undefined);
var _ohos_app_ability_UIAbility_1  = globalThis.requireNapi('app.ability.UIAbility') || (isSystemplugin('app.ability.UIAbility', 'ohos') ? globalThis.ohosplugin.app.ability.UIAbility : isSystemplugin('app.ability.UIAbility', 'system') ? globalThis.systemplugin.app.ability.UIAbility : undefined);
__webpack_require__(/*! @ohos.window */ "../../api/@ohos.window.d.ts");
var _ohos_abilityAccessCtrl_1  = globalThis.requireNapi('abilityAccessCtrl') || (isSystemplugin('abilityAccessCtrl', 'ohos') ? globalThis.ohosplugin.abilityAccessCtrl : isSystemplugin('abilityAccessCtrl', 'system') ? globalThis.systemplugin.abilityAccessCtrl : undefined);
/**
 * Lift cycle management of Ability.
 */
class EntryAbility extends _ohos_app_ability_UIAbility_1 {
    onCreate(want, launchParam) {
        _ohos_hilog_1.info(0x0000, 'testTag', '%{public}s', 'Ability onCreate');
        let permissionNames = ['ohos.permission.MEDIA_LOCATION', 'ohos.permission.READ_MEDIA',
            'ohos.permission.WRITE_MEDIA', 'ohos.permission.CAMERA', 'ohos.permission.MICROPHONE'];
        globalThis.abilityWant = this.launchWant;
        globalThis.abilityContext = this.context;
        let atManager = _ohos_abilityAccessCtrl_1.createAtManager();
        atManager.requestPermissionsFromUser(globalThis.abilityContext, permissionNames).then((data) => {
            _ohos_hilog_1.info(0x0000, 'testTag', '%{public}s', 'requestPermissionsFromUser called');
        });
    }
    onDestroy() {
        _ohos_hilog_1.info(0x0000, 'testTag', '%{public}s', 'Ability onDestroy');
    }
    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        _ohos_hilog_1.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/ListPage', (err, data) => {
            var _a, _b;
            if (err.code) {
                _ohos_hilog_1.error(0x0000, 'testTag', 'Failed to load the content. Cause: %{public}s', (_a = JSON.stringify(err)) !== null && _a !== void 0 ? _a : '');
                return;
            }
            _ohos_hilog_1.info(0x0000, 'testTag', 'Succeeded in loading the content. Data: %{public}s', (_b = JSON.stringify(data)) !== null && _b !== void 0 ? _b : '');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        _ohos_hilog_1.info(0x0000, 'testTag', '%{public}s', 'Ability onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        _ohos_hilog_1.info(0x0000, 'testTag', '%{public}s', 'Ability onForeground');
    }
    onBackground() {
        // Ability has back to background
        _ohos_hilog_1.info(0x0000, 'testTag', '%{public}s', 'Ability onBackground');
    }
}
globalThis.exports.default = EntryAbility;


/***/ }),

/***/ "../../api/@ohos.window.d.ts":
/*!***********************************!*\
  !*** ../../api/@ohos.window.d.ts ***!
  \***********************************/
/***/ (() => {



/***/ })

/******/ 	});
/************************************************************************/
/******/ 	// The module cache
/******/ 	var __webpack_module_cache__ = {};
/******/ 	
/******/ 	// The require function
/******/ 	function __webpack_require__(moduleId) {
/******/ 		var commonCachedModule = globalThis["__common_module_cache___33e685f0ccb1747dd30a147821965b5a"] ? globalThis["__common_module_cache___33e685f0ccb1747dd30a147821965b5a"][moduleId]: null;
/******/ 		if (commonCachedModule) { return commonCachedModule.exports; }
/******/ 		// Check if module is in cache
/******/ 		var cachedModule = __webpack_module_cache__[moduleId];
/******/ 		if (cachedModule !== undefined) {
/******/ 			return cachedModule.exports;
/******/ 		}
/******/ 		// Create a new module (and put it into the cache)
/******/ 		var module = __webpack_module_cache__[moduleId] = {
/******/ 			// no module.id needed
/******/ 			// no module.loaded needed
/******/ 			exports: {}
/******/ 		};
/******/ 	
/******/ 		function isCommonModue(moduleId) {
/******/ 		                if (globalThis["webpackChunk_33e685f0ccb1747dd30a147821965b5a"]) {
/******/ 		                  const length = globalThis["webpackChunk_33e685f0ccb1747dd30a147821965b5a"].length;
/******/ 		                  switch (length) {
/******/ 		                    case 1:
/******/ 		                      return globalThis["webpackChunk_33e685f0ccb1747dd30a147821965b5a"][0][1][moduleId];
/******/ 		                    case 2:
/******/ 		                      return globalThis["webpackChunk_33e685f0ccb1747dd30a147821965b5a"][0][1][moduleId] ||
/******/ 		                      globalThis["webpackChunk_33e685f0ccb1747dd30a147821965b5a"][1][1][moduleId];
/******/ 		                  }
/******/ 		                }
/******/ 		                return undefined;
/******/ 		              }
/******/ 		if (globalThis["__common_module_cache___33e685f0ccb1747dd30a147821965b5a"] && String(moduleId).indexOf("?name=") < 0 && isCommonModue(moduleId)) {
/******/ 		  globalThis["__common_module_cache___33e685f0ccb1747dd30a147821965b5a"][moduleId] = module;
/******/ 		}
/******/ 		__webpack_modules__[moduleId].call(module.exports, module, module.exports, __webpack_require__);
/******/ 	
/******/ 		// Return the exports of the module
/******/ 		return module.exports;
/******/ 	}
/******/ 	
/************************************************************************/
/******/ 	
/******/ 	// startup
/******/ 	// Load entry module and return exports
/******/ 	// This entry module is referenced by other modules so it can't be inlined
/******/ 	var __webpack_exports__ = __webpack_require__("D:\\avRecorder\\applications_app_samples\\media\\AVRecorder\\entry\\src\\main\\ets\\entryability\\EntryAbility.ts?entry");
/******/ 	_33e685f0ccb1747dd30a147821965b5a = __webpack_exports__;
/******/ 	
/******/ })()
;
//# sourceMappingURL=EntryAbility.js.map