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

#ifndef JSON_UTILS_H
#define JSON_UTILS_H

#include <string>
#include <map>

class Json {
public:
    // 代理类，用于设置值
    class JsonValueProxy {
    public:
        JsonValueProxy(Json& parent, const std::string& key);
        void operator=(const float value);
        void operator=(const char* value);
        void operator=(const std::string& value);
        void operator=(const Json& value);

    private:
        Json& parent_;
        std::string key_;
    };

    // 重载operator[]以返回代理对象
    JsonValueProxy operator[](const std::string& key);

    // 设置浮点值
    void Set(const std::string& key, float value);
    // 设置字符串值
    void Set(const std::string& key, const std::string& value);
    // 设置const char*值
    void Set(const std::string& key, const char* value);
    // 设置json值
    void Set(const std::string& key, const Json& value);

    // 将json对象转成字符串
    std::string Dump() const;

    // 解析json字符串获取json格式的key和value
    static std::map<std::string, std::string> Parse(const std::string& jsonStr);

private:
    std::map<std::string, std::string> values_;
};

#endif // JSON_UTILS_H
