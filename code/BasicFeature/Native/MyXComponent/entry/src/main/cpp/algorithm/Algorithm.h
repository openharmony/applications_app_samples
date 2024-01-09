/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
 */

#ifndef MY_X_COMPONENT_ALGORITHM_H
#define MY_X_COMPONENT_ALGORITHM_H
#include <cstddef>
#include "Matrix4x4.h"
#include "Vector3.h"
#include "cmath"
#include "util/types.h"

class Algorithm {
public:
    static float Radians(float deg) { return deg * static_cast<float>(kNumber); }

    static Matrix4x4 Perspective(float fovy, float aspect, float zNear, float zFar)
    {
        const float tanHalfFovy = tan(fovy / 2.0f);
        Matrix4x4 result;
        result.SetValue(0 * kFour + 0, 1.0f / (aspect * tanHalfFovy));
        result.SetValue(1 * kFour + 1, 1.0f / (tanHalfFovy));
        result.SetValue(kTwo * kFour + kTwo, -(zFar + zNear) / (zFar - zNear));
        result.SetValue(kTwo * kFour + kThree, -1);
        result.SetValue(kThree * kFour + kTwo, -(2.0f * zFar * zNear) / (zFar - zNear));
        return result;
    }
    static Matrix4x4 LookAt(Vector3 eye, Vector3 center, Vector3 const &up)
    {
        Vector3 f = Vector3::Normalize(Vector3::Subtract(center, eye));
        Vector3 s = Vector3::Normalize(Vector3::Cross(f, up));
        Vector3 u = Vector3::Normalize(Vector3::Cross(s, f));

        Matrix4x4 result = Matrix4x4::Identity();
        result.SetValue(0 * kFour + 0, s.GetDataX());
        result.SetValue(1 * kFour + 0, s.GetDataY());
        result.SetValue(kTwo * kFour + 0, s.GetDataZ());

        result.SetValue(0 * kFour + 1, u.GetDataX());
        result.SetValue(1 * kFour + 1, u.GetDataY());
        result.SetValue(kTwo * kFour + 1, u.GetDataZ());

        result.SetValue(0 * kFour + kTwo, -f.GetDataX());
        result.SetValue(1 * kFour + kTwo, -f.GetDataY());
        result.SetValue(kTwo * kFour + kTwo, -f.GetDataZ());

        result.SetValue(kThree * kFour + 0, -Vector3::Dot(s, eye));
        result.SetValue(kThree * kFour + 1, -Vector3::Dot(u, eye));
        result.SetValue(kThree * kFour + kTwo, Vector3::Dot(f, eye));
        return result;
    };
};

#endif // MY_X_COMPONENT_ALGORITHM_H
