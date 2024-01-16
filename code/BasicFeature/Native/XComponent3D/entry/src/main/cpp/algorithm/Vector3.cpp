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

#include "Vector3.h"
#include <cmath>
#include "cmath"
Vector3 Vector3::Add(Vector3 lhs, Vector3 rhs)
{
    return Vector3(lhs.dataX + rhs.dataX, lhs.dataY + rhs.dataY, lhs.dataZ + rhs.dataZ);
}

Vector3 Vector3::Subtract(Vector3 lhs, Vector3 rhs)
{
    return Vector3(lhs.dataX - rhs.dataX, lhs.dataY - rhs.dataY, lhs.dataZ - rhs.dataZ);
}

Vector3 Vector3::Multiply(Vector3 lhs, float rhs) { return Vector3(lhs.dataX * rhs, lhs.dataY * rhs, lhs.dataZ * rhs); }
float Vector3::GetDataX() { return this->dataX; }
void Vector3::SetDataX(float xData) { this->dataX = xData; }
float Vector3::GetDataY() { return this->dataY; }
void Vector3::SetDataY(float yData) { this->dataY = yData; }
float Vector3::GetDataZ() { return this->dataZ; }
void Vector3::SetDataZ(float zData) { this->dataZ = zData; }

float Vector3::Length(Vector3 lhs)
{
    return static_cast<float>(std::sqrt(lhs.dataX * lhs.dataX + lhs.dataY * lhs.dataY + lhs.dataZ * lhs.dataZ));
}

Vector3 Vector3::Normalize(Vector3 lhs)
{
    float oneOverLen = 1.0F / Length(lhs);
    return isfinite(oneOverLen) ? Vector3(lhs.dataX * oneOverLen, lhs.dataY * oneOverLen, lhs.dataZ * oneOverLen)
                                : Vector3(0, 0, 0);
}

Vector3 Vector3::Cross(Vector3 lhs, Vector3 rhs)
{
    float newDataX = lhs.dataY * rhs.dataZ - lhs.dataZ * rhs.dataY;
    float newDataY = lhs.dataZ * rhs.dataX - lhs.dataX * rhs.dataZ;
    float newDataZ = lhs.dataX * rhs.dataY - lhs.dataY * rhs.dataX;
    return Vector3(newDataX, newDataY, newDataZ);
}

float Vector3::Dot(Vector3 lhs, Vector3 rhs)
{
    return lhs.dataX * rhs.dataX + lhs.dataY * rhs.dataY + lhs.dataZ * rhs.dataZ;
}
