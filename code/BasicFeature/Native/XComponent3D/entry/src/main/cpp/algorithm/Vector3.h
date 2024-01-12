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
#ifndef MY_X_COMPONENT_VEC3_H
#define MY_X_COMPONENT_VEC3_H


class Vector3 {
public:
    Vector3(float x, float y, float z) : dataX(x), dataY(y), dataZ(z) {}

    static Vector3 Add(Vector3 lhs, Vector3 rhs);
    static Vector3 Add(Vector3 lhs, float rhs);
    static Vector3 Subtract(Vector3 lhs, Vector3 rhs);
    static Vector3 Subtract(Vector3 lhs, float rhs);
    static Vector3 Multiply(Vector3 lhs, Vector3 rhs);
    static Vector3 Multiply(Vector3 lhs, float rhs);
    static Vector3 Divide(Vector3 lhs, Vector3 rhs);
    static Vector3 Divide(Vector3 lhs, float rhs);
    static Vector3 Distance(Vector3 lhs, Vector3 rhs);
    static float Dot(Vector3 lhs, Vector3 rhs);
    static Vector3 Cross(Vector3 lhs, Vector3 rhs);
    static float Length(Vector3 lhs);
    static Vector3 Normalize(Vector3 lhs);

    float GetDataX();
    void SetDataX(float dataX);
    float GetDataY();
    void SetDataY(float dataY);
    float GetDataZ();
    void SetDataZ(float dataZ);

private:
    float dataX;
    float dataY;
    float dataZ;
};
#endif // MY_X_COMPONENT_VEC3_H