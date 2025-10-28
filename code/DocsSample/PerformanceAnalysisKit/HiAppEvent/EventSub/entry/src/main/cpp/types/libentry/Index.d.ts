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

// [Start EventSub_Index.d.ts_All]
export const registerWatcher: () => void;
// [Start AppEvent_C++_Index.d.ts]
export const registerWatcherCrash: () => void;
export const registerWatcherClick: () => void;
export const writeAppEvent: () => void;
// [End AppEvent_C++_Index.d.ts]

// [Start Sys_Crash_Event_C++_Index.d.ts]
export const registerWatcherClickCrash: () => void;
export const registerWatcherCrashEvent: () => void;
// [End Sys_Crash_Event_C++_Index.d.ts]

// [Start test_hicollie_timer_Index.d.ts]
export const TestHiCollieTimerNdk: () => void;
// [End test_hicollie_timer_Index.d.ts]
// [Start AsanEvent_Index.d.ts]
export const registerSanitizerReceiveWatcher: () => void;
export const addressSanitizerTest: () => void;
// [End AsanEvent_Index.d.ts]
// [Start PssLeakEvent_Index.d.ts]
export const registerLeakReceiveWatcher: () => void;
// [End PssLeakEvent_Index.d.ts]
// [Start AppKillEvent_Index.d.ts]
export const registerAppKillReceiveWatcher: () => void;
export const leak: () => void;
// [End AppKillEvent_Index.d.ts]
// [Start Register_AppHicollie_WatcherR.d.ts]
export const RegisterAppHicollieWatcherR: () => void;
// [End Register_AppHicollie_WatcherR.d.ts]
// [Start Register_AppHicollie_WatcherT.d.ts]
export const RegisterAppHicollieWatcherT: () => void;
// [End Register_AppHicollie_WatcherT.d.ts]
// [End EventSub_Index.d.ts_All]
// [Start Sys_Native_Crash_Event_C++_Index.d.ts]
export const testNullptr: () => void;
// [Start Sys_Native_Crash_Event_C++_Index.d.ts]
