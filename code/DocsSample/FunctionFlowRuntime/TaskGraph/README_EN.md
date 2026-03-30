# FFRT Task Graph Concurrency Paradigm

## Project Overview

This sample demonstrates an application that implemented using the Task Graph paradigm provided by **FFRT**, through simple implementation of a Fibonacci Sequence example and a streaming video processing example, developers are shown how to use this specific feature.

## Preview
|             Application Effect (Image)             |
|:--------------------------------:|
| ![image](res/FFRT_TaskGraph.gif) |

_The interface displays the task execution by using Task Graph C and C++ api. Click the buttons to trigger task execution._
## Key Features
The FFRT task graph supports task dependency and data dependency. Each node in the task graph indicates a task, and each edge indicates the dependency between tasks. Task dependency is classified into input dependency (in_deps) and output dependency (out_deps).

You can use either of the following ways to build a task graph:

* Use the task dependency to build a task graph. The task handle is used to indicate a task object.
* Use the data dependency to build a task graph. The data object is abstracted as a data signature, and each data signature uniquely indicates a data object.

## Example: Streaming Video Processing
A user uploads a video to the platform. The processing steps include: parsing, transcoding, generating a thumbnail, adding a watermark, and releasing the video. Transcoding and thumbnail generation can occur simultaneously. 

## Example: Fibonacci Sequence
Each number in the Fibonacci sequence is the sum of the first two numbers. The process of calculating the Fibonacci number can well express the task dependency through the data object.

## Usage Instructions

1. Open the application, Two examples are displayed at the bottom of the page, and two test blocks (C interface and C++ interface implementations) are shown in the middle.
2. Click the **Task Graph Dependency Management C Interface”** bottom.
    - Call the C interface.
    - Display the task results in hilog.
3. Click the **Dependency Management Cpp Interface”** bottom.
    - Call the C++ interface.
    - Display the task results in hilog.

## Project Structure

```plain
├──entry/src
├──common
│  └──CommonConstants.ets         // Constant definitions
├──cpp
│  ├──types/libentry
│  │  ├──index.d.ts               // NAPI interface declarations
│  │  └──oh-package.json5         // Interface registration configuration
│  ├──CMakeLists.txt              // CMake configuration
│  ├──napi_init.cpp               // NAPI interface implementation
│  ├──parallel.cpp                // Parallel task C API implementation
│  ├──parallel_cpp.cpp            // Parallel task C++ API implementation
├──ets
│  ├──entryability
│  │  └──EntryAbility.ets         // Application entry point
│  └──pages
│     └──Index.ets                // Main UI interface
└──resources                      // Resource files
```
## Implementation Details

### 1. Concurrent Task Scheduling

Use **FFRT Task Graph concurrent** mode to execute dependency tasks, supports features such as Tasks with sequence, Logic process control, Multi-level chain.

### 2. NAPI Module Encapsulation

NAPI interface registration is implemented in `napi_init.cpp`. When ArkTS calls `testNapi.ParallelDepExec(true|false)`, it submits parallel task graph task.

### 3. HarmonyOS UI

Uses ArkTS + Declarative UI components for layout. `CommonConstants` manages style constants. Buttons trigger task execution, and results are updated in the Hilog in real time.

### 4. Project Engineering and Portability

Uses CMake to build the C++ module. Employs OpenHarmony third-party library dependency management (`@ppd/ffrt` v1.1.0+). The clear directory structure facilitates extensibility.

## Required Permissions

None involved.

## Constraints and Limitations

1.  This sample only runs on standard systems. Supported devices: Huawei phones and tablets.
2.  HarmonyOS version: HarmonyOS 6.0.0 Release or later.
3.  DevEco Studio version: DevEco Studio 6.0.0 Release or later.
4.  HarmonyOS SDK version: HarmonyOS 6.0.0 Release SDK or later.

## Dependencies

1.  OpenHarmony third-party library `@ppd/ffrt` version: 1.1.0 or later.