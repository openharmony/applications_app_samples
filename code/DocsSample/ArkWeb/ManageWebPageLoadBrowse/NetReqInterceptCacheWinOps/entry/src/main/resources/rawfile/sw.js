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

// [Start add_event_listener_java_script]
self.addEventListener('install', event => {
    console.log('v1 installing');
    event.waitUntil(
        caches.open('static-v1').then(cache => cache.add('/cat.svg'))
    );
});

self.addEventListener('activate', event => {
    console.log('v1 now redy to handle fetches.');
});
// [End add_event_listener_java_script]
