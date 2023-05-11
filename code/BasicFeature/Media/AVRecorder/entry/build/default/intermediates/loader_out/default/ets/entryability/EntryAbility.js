var _dc2c5df44f596112a82eb663dbdeca82;
/******/ (() => { // webpackBootstrap
/******/ 	var __webpack_modules__ = ({

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\entryability\\EntryAbility.ts?entry":
/*!********************************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\entryability\EntryAbility.ts?entry ***!
  \********************************************************************************************************************************************/
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
var _ohos_app_ability_UIAbility_1  = globalThis.requireNapi('app.ability.UIAbility') || (isSystemplugin('app.ability.UIAbility', 'ohos') ? globalThis.ohosplugin.app.ability.UIAbility : isSystemplugin('app.ability.UIAbility', 'system') ? globalThis.systemplugin.app.ability.UIAbility : undefined);
__webpack_require__(/*! @ohos.window */ "../../api/@ohos.window.d.ts");
var _ohos_abilityAccessCtrl_1  = globalThis.requireNapi('abilityAccessCtrl') || (isSystemplugin('abilityAccessCtrl', 'ohos') ? globalThis.ohosplugin.abilityAccessCtrl : isSystemplugin('abilityAccessCtrl', 'system') ? globalThis.systemplugin.abilityAccessCtrl : undefined);
const Logger_1 = __importDefault(__webpack_require__(/*! ../utils/Logger */ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets"));
/**
 * Lift cycle management of Ability.
 */
class EntryAbility extends _ohos_app_ability_UIAbility_1 {
    onCreate(want, launchParam) {
        Logger_1.default.info('testTag', 'Ability onCreate');
        let permissionNames = ['ohos.permission.MEDIA_LOCATION', 'ohos.permission.READ_MEDIA',
            'ohos.permission.WRITE_MEDIA', 'ohos.permission.CAMERA', 'ohos.permission.MICROPHONE'];
        globalThis.abilityWant = this.launchWant;
        globalThis.abilityContext = this.context;
        let atManager = _ohos_abilityAccessCtrl_1.createAtManager();
        atManager.requestPermissionsFromUser(globalThis.abilityContext, permissionNames).then((data) => {
            Logger_1.default.info('testTag', 'requestPermissionsFromUser called');
        });
    }
    onDestroy() {
        Logger_1.default.info('testTag', 'Ability onDestroy');
    }
    onWindowStageCreate(windowStage) {
        // Main window is created, set main page for this ability
        Logger_1.default.info('testTag', 'Ability onWindowStageCreate');
        windowStage.loadContent('pages/ListPage', (err, data) => {
            if (err.code) {
                Logger_1.default.error('testTag', 'Failed to load the content.');
                return;
            }
            Logger_1.default.info('testTag', 'Succeeded in loading the content.');
        });
    }
    onWindowStageDestroy() {
        // Main window is destroyed, release UI related resources
        Logger_1.default.info('testTag', 'Ability onWindowStageDestroy');
    }
    onForeground() {
        // Ability has brought to foreground
        Logger_1.default.info('testTag', 'Ability onForeground');
    }
    onBackground() {
        // Ability has back to background
        Logger_1.default.info('testTag', 'Ability onBackground');
    }
}
globalThis.exports.default = EntryAbility;


/***/ }),

/***/ "D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\utils\\Logger.ets":
/*!**************************************************************************************************************************!*\
  !*** D:\0510sample\applications_app_samples_0510\code\BasicFeature\Media\AVRecorder\entry\src\main\ets\utils\Logger.ets ***!
  \**************************************************************************************************************************/
/***/ (function(__unused_webpack_module, exports) {

"use strict";

var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", ({ value: true }));
let __generate__Id = 0;
function generateId() {
    return "Logger_" + ++__generate__Id;
}
/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
var _ohos_hilog_1  = globalThis.requireNapi('hilog') || (isSystemplugin('hilog', 'ohos') ? globalThis.ohosplugin.hilog : isSystemplugin('hilog', 'system') ? globalThis.systemplugin.hilog : undefined);
class Logger {
    constructor(prefix) {
        this.format = "%{public}s, %{public}s";
        this.prefix = prefix;
        this.domain = 0xFF00;
    }
    debug(...args) {
        _ohos_hilog_1.debug(this.domain, this.prefix, this.format, args);
    }
    info(...args) {
        _ohos_hilog_1.info(this.domain, this.prefix, this.format, args);
    }
    warn(...args) {
        _ohos_hilog_1.warn(this.domain, this.prefix, this.format, args);
    }
    error(...args) {
        _ohos_hilog_1.error(this.domain, this.prefix, this.format, args);
    }
}
exports["default"] = new Logger('AVRecorderSample');


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
/******/ 		var commonCachedModule = globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"] ? globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"][moduleId]: null;
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
/******/ 		                if (globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"]) {
/******/ 		                  const length = globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"].length;
/******/ 		                  switch (length) {
/******/ 		                    case 1:
/******/ 		                      return globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][0][1][moduleId];
/******/ 		                    case 2:
/******/ 		                      return globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][0][1][moduleId] ||
/******/ 		                      globalThis["webpackChunk_dc2c5df44f596112a82eb663dbdeca82"][1][1][moduleId];
/******/ 		                  }
/******/ 		                }
/******/ 		                return undefined;
/******/ 		              }
/******/ 		if (globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"] && String(moduleId).indexOf("?name=") < 0 && isCommonModue(moduleId)) {
/******/ 		  globalThis["__common_module_cache___dc2c5df44f596112a82eb663dbdeca82"][moduleId] = module;
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
/******/ 	var __webpack_exports__ = __webpack_require__("D:\\0510sample\\applications_app_samples_0510\\code\\BasicFeature\\Media\\AVRecorder\\entry\\src\\main\\ets\\entryability\\EntryAbility.ts?entry");
/******/ 	_dc2c5df44f596112a82eb663dbdeca82 = __webpack_exports__;
/******/ 	
/******/ })()
;
//# sourceMappingURL=EntryAbility.js.map