# Starting a Multi-Threaded Task


### Introduction

This sample show how to start worker threads and taskpool threads.

### Related Concepts

worker: A worker is an independent thread that runs in parallel with the main thread. The thread that creates the worker is called the hosting thread, while the worker thread itself is called the worker thread. The URL file passed to the worker when it is created is executed in the worker thread, which can handle time-consuming operations but cannot directly manipulate the UI.

taskpool: A taskpool can be used to create background tasks and manage their execution, cancellation, etc.

### Required Permissions

No permissions are required.

### Usage

worker:

1. Select the Worker tab and enter the string to be sorted, separated by commas.

2. Click the **Sort String** button, which will send the unsorted string to the worker thread for sorting. The sorted string will then be sent back to the main thread for display.

3. Click the **Clear** button to clear the string.

taskpool:

1. Select the Taskpool tab and enter the string to be sorted, separated by commas.

2. Click the **Execute Immediately** button to execute the task immediately, and the sorted string will be displayed after the task completes.

3. Click the **Execute After 3s** button to delay the task execution by 3 seconds, and the sorted string will be displayed after the task completes.

4. Click the **Function Task** button to execute the operation directly, and the sorted string will be displayed after the task completes. Note that the task created using Function Task cannot be cancelled.

5. Click the **Cancel Task** button to cancel the last unexecuted task. Note that cancellation can only be successful if the number of tasks is greater than the maximum number of threads and the task has started executing.

6. Click the **Clear** button to clear the string.

### Constraints and Limitations

1. This example only supports running on a standard system.

2. This example requires DevEco Studio 3.1 Beta2 (Build Version: 3.1.0.400, built on April 7, 2023) to compile and run.
