/*
 * Copyright (c) 2021 Huawei Device Co., Ltd.
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

import router from '@ohos.router'
import systemParameter from '@ohos.systemparameter';

let self = null

export default {
  data: {
    results: ''
  },
  onInit() {
    self = this
  },
  getKey() {
    try {
      var promise = systemParameter.get("test.parameter.key", "default");
      promise.then(function (data) {
        self.results = "getKey pass";
        console.log("get test.parameter.key success:" + JSON.stringify(data));
      }).catch(function (err) {
        self.results = "get test.parameter.key error:" + err.code;
        console.log("get test.parameter.key error:" + err.code);
      });
    } catch (e) {
      self.results = "get unexpected error:" + e;
      console.log("get unexpected error:" + e);
    }
  },
  getSync() {
    try {
      var getSync = systemParameter.getSync("test.parameter.key", "default");
      console.log("getSync test.parameter.key value success:" + JSON.stringify(getSync));
      this.results = "getSync pass";
    } catch (e) {
      this.results = "getSync unexpected error:" + e;
      console.log("getSync unexpected error");
    }
  },
  getAsyncCallback() {
    try {
      systemParameter.get("test.parameter.key", function (err, data) {
        if (err == undefined) {
          self.results = "getAsyncCallback pass";
          console.log("get test.parameter.key value success:" + data);
        } else {
          self.results = "get test.parameter.key value err:" + err.code;
          console.log("get test.parameter.key value err:" + err.code);
        }
      });
    } catch (e) {
      self.results = "getSync unexpected error:" + e;
      console.log("getSync unexpected error:" + e);
    }
  },
  getDefAsyncCallback() {
    try {
      systemParameter.get("test.parameter.key", "default", function (err, data) {
        if (err == undefined) {
          self.results = "getDefAsyncCallback pass";
          console.log("get test.parameter.key value success:" + data);
        } else {
          self.results = "get test.parameter.key value err:" + err.code;
          console.log("get test.parameter.key value err:" + err.code);
        }
      });
    } catch (e) {
      self.results = "get test.parameter.key value err:" + e;
      console.log("get test.parameter.key value err:" + e);
    }
  },
  back() {
    router.back();
  }
}