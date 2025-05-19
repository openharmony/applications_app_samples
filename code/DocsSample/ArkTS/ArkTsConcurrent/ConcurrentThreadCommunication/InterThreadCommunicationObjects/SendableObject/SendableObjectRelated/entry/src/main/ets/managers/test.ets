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

// 不允许使用side-effects-import
// [Start constrained_test]
// import "./sharedModule"

export let num = 1;
export let str = 'aaa';

// 共享模块
'use shared'

// export * from './test'; // 编译报错，不允许直接导出模块
// export {num, str} from './test'; // 正确示例，导出对象合集
// [End constrained_test]
