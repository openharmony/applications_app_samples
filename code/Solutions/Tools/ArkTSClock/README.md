# Simple Clock

### Introduction

This sample exemplifies how to implement a simple clock application using the eTS UI capability.

### Usage

The UI uses **setInterval** to update the time at regular intervals and uses **Canvas** to draw the clock, where the rotation angles of the clock hands are obtained through calculation.

For example, **2 * Math.PI / 60 * second** indicates the rotation angle of the second hand.

### Constraints

1. This sample can only be run on standard-system devices.

2. This sample demonstrates the stage model, which supports only API version 9.

3. The DevEco Studio version used in this sample must be 3.0.0.900 or later.
