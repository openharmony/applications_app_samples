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

#include "json_utils.h"
#include <iostream>
#include <sstream>
#include <iomanip>

// 表示小数点后保留的位数
constexpr int PRECISION = 2;
// 构造函数
Json::JsonValueProxy::JsonValueProxy(Json& parent, const std::string& key) : parent_(parent), key_(key) {}

// 设置浮点值
void Json::JsonValueProxy::operator=(const float value)
{
    parent_.Set(key_, value);
}

// 设置const char*值
void Json::JsonValueProxy::operator=(const char* value)
{
    parent_.Set(key_, value);
}

// 设置字符串值
void Json::JsonValueProxy::operator=(const std::string& value)
{
    parent_.Set(key_, value);
}

// 设置json值
void Json::JsonValueProxy::operator=(const Json& value)
{
    parent_.Set(key_, value);
}

// 重载operator[]以返回代理对象
Json::JsonValueProxy Json::operator[](const std::string& key)
{
    return JsonValueProxy(*this, key);
}

// 设置浮点值
void Json::Set(const std::string& key, float value)
{
    std::ostringstream oss;
    // 将浮点数 value 转换为字符串时，保留小数点后两位
    oss << std::fixed << std::setprecision(PRECISION) << value;
    values_[key] = oss.str();
}

// 设置字符串值
void Json::Set(const std::string& key, const std::string& value)
{
    values_[key] = "\"" + value + "\"";
}

// 设置const char*值
void Json::Set(const std::string& key, const char* value)
{
    values_[key] = "\"" + std::string(value) + "\"";
}

// 设置json值
void Json::Set(const std::string& key, const Json& value)
{
    values_[key] = value.Dump();
}

// 将json对象转成字符串
std::string Json::Dump() const
{
    std::ostringstream oss;
    oss << "{";
    bool first = true;
    for (const auto& pair : values_) {
        if (!first) {
            oss << ", ";
        }
        oss << "\"" << pair.first << "\": " << pair.second;
        first = false;
    }
    oss << "}";
    return oss.str();
}

// 解析json字符串获取json格式的key和value
std::map<std::string, std::string> Json::Parse(const std::string& jsonStr)
{
    std::map<std::string, std::string> result;
    std::string key;
    std::string value;
    bool inKey = false;
    bool inValue = false;
    for (size_t i = 0; i < jsonStr.size(); ++i) {
        char c = jsonStr[i];
        if (c == '"') {
            if (inKey) {
                inKey = false;
            } else if (inValue) {
                inValue = false;
                result[key] = value;
                key.clear();
                value.clear();
            } else {
                inKey = true;
            }
        } else if (c == ':') {
            inKey = false;
            inValue = true;
        } else if (c == ',') {
            inValue = false;
        } else if (inKey) {
            key += c;
        } else if (inValue) {
            value += c;
        }
    }
    return result;
}