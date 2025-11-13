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
// Define the CommonEventModule interface with all required methods
// Define the interface explicitly
interface CommonEventModule {
  // Core NAPI functions
  createSubscribeInfo(): boolean;
  destroySubscribeInfo(): boolean;
  createSubscriber(): boolean;
  destroySubscriber(): boolean;
  subscribe(): boolean;
  unsubscribe(): boolean;
  publish(): boolean;
  publishWithInfo(): boolean;
  abortCommonEvent(): boolean;
  clearAbortCommonEvent(): boolean;
  add?(a: number, b: number): number;
  
  // State checking methods
  getSubscribeInfoState(): boolean;
  getSubscriberState(): boolean;
  getSubscribeState(): boolean;
  getPublishedEvents(): string[];
}

// Mock state variables
let isSubscribeInfoCreated = false;
let isSubscriberCreated = false;
let isSubscribed = false;
let publishedEvents: string[] = [];

// Implement the interface with a class
class NativeMockImpl implements CommonEventModule {
  // Create subscribe information
  createSubscribeInfo(): boolean {
    isSubscribeInfoCreated = true;
    console.log('Mock: createSubscribeInfo called, state set to true');
    return true;
  }

  // Destroy subscribe information
  destroySubscribeInfo(): boolean {
    isSubscribeInfoCreated = false;
    console.log('Mock: destroySubscribeInfo called, state set to false');
    return true;
  }

  // Create subscriber
  createSubscriber(): boolean {
    // Simulate real behavior: subscriber can only be created if subscribeInfo exists
    if (isSubscribeInfoCreated) {
      isSubscriberCreated = true;
    }
    console.log(`Mock: createSubscriber called, state set to ${isSubscriberCreated}`);
    return isSubscriberCreated;
  }

  // Destroy subscriber
  destroySubscriber(): boolean {
    isSubscriberCreated = false;
    isSubscribed = false; // Unsubscribe when destroying subscriber
    console.log('Mock: destroySubscriber called, state set to false');
    return true;
  }

  // Subscribe to event
  subscribe(): boolean {
    // Simulate real behavior: can only subscribe if subscriber exists
    if (isSubscriberCreated) {
      isSubscribed = true;
    }
    console.log(`Mock: subscribe called, state set to ${isSubscribed}`);
    return isSubscribed;
  }

  // Unsubscribe from event
  unsubscribe(): boolean {
    isSubscribed = false;
    console.log('Mock: unsubscribe called, state set to false');
    return true;
  }

  // Publish event
  publish(): boolean {
    publishedEvents.push('usual.event.TEST');
    console.log('Mock: publish called, event added to publishedEvents');
    return true;
  }

  // Publish event with info
  publishWithInfo(): boolean {
    publishedEvents.push('usual.event.TEST_WITH_INFO');
    console.log('Mock: publishWithInfo called, event added to publishedEvents');
    return true;
  }

  // Abort common event
  abortCommonEvent(): boolean {
    console.log('Mock: abortCommonEvent called');
    return isSubscriberCreated;
  }

  // Clear abort common event
  clearAbortCommonEvent(): boolean {
    console.log('Mock: clearAbortCommonEvent called');
    return isSubscriberCreated;
  }

  // Add method
  add(a: number, b: number): number {
    return a + b;
  }

  // State checking methods
  getSubscribeInfoState(): boolean {
    return isSubscribeInfoCreated;
  }
  
  getSubscriberState(): boolean {
    return isSubscriberCreated;
  }
  
  getSubscribeState(): boolean {
    return isSubscribed;
  }
  
  getPublishedEvents(): string[] {
    return [...publishedEvents]; // Return a copy to prevent external modification
  }
}

// Create an instance and export it
export default new NativeMockImpl();