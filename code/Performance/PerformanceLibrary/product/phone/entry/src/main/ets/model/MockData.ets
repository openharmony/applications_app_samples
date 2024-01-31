/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import { PerformanceMsg } from './DataType';

export let performanceTypeArray: Array<PerformanceMsg> = [
  {
    name: 'HiDumper',
    uri: 'pages/hiDumper/HiDumperPage'
  },
  {
    name: 'StaticImport',
    uri: 'pages/staticImport/StaticEntryView'
  },
  {
    name: 'DynamicImport',
    uri: 'pages/dynamicImport/DynamicEntryView'
  },
  {
    name: 'IfOrVisibility',
    uri: 'pages/ifOrVisibility/IfOrVisibilityPage'
  },
  {
    name: 'Grid',
    uri: 'pages/grid/GridPage'
  },
  {
    name: 'SmartPerf Editor',
    uri: 'pages/smartPerfEditor/SmartPerfEditorPage'
  },
  {
    name: 'SmartPerfHost',
    uri: 'pages/smartPerfHost/SmartPerfHostPage'
  },
  {
    name: 'Trace',
    uri: 'pages/trace/TracePage'
  },
  {
    name: 'BackgroundTask',
    uri: 'pages/backgroundTask/BackgroundTaskPage'
  },
  {
    name: 'ThreadDataTransfer',
    uri: 'pages/ThreadDataTransfer/ThreadDataTransferPage'
  },
  {
    name: 'MemoryShared',
    uri: 'pages/memoryShared/MemorySharedHomePage'
  },
  {
    name: 'DFX StateManagement',
    uri: 'pages/DFXStateManagement/DFXStateManagementPage'
  },
  {
    name: 'WaterFlow',
    uri: 'pages/waterFlow/WaterFlowPage'
  },
  {
    name: 'NativeThreadsCallJS',
    uri: 'pages/nativeThreadsCallJS/NativeThreadsCallJS'
  },
  {
    name: 'ThreadCommunication',
    uri: 'pages/ThreadCommunication/ThreadCommunicationHomePage'
  },
  {
    name: 'WebPerformance',
    uri: 'pages/webPerformance/WebHomePage'
  }
]