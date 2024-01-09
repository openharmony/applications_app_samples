/*
 * * Copyright (c) TD Tdch Communication Technologies Ltd.2023-2023.All rights reserved.
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