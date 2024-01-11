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

#ifndef CAMERA_H
#define CAMERA_H

#include "Algorithm.h"
#include "Matrix4x4.h"
#include "Vector3.h"

// 定义相机移动的几个可能选项。用作抽象，以远离特定于窗口系统的输入方法
enum CameraMovement { FORWARD, BACKWARD, LEFT, RIGHT };

// Default camera values
const float YAW = -90.0f;
const float PITCH = 0.0f;
const float SPEED = 2.5f;
const float SENSITIVITY = 0.1f;
const float ZOOM = 45.0f;

// 一个抽象的相机类，用于处理输入并计算相应的欧拉角、矢量和矩阵，以便在OpenGL中使用
class Camera {
public:
    // 相机属性值
    Vector3 Position{0.0f, 0.0f, 0.0f};
    Vector3 Front{0.0f, 0.0f, -1.0f};
    Vector3 Up{0.0f, 1.0f, 0.0f};
    Vector3 Right{0.0f, 0.0f, 0.0f};
    Vector3 WorldUp{0.0f, 0.0f, 0.0f};
    // 欧拉角度
    float Yaw = YAW;
    float Pitch = PITCH;
    // 相机选项
    float MovementSpeed = SPEED;
    float MouseSensitivity = SENSITIVITY;
    float Zoom = ZOOM;

    // 向量的构造函数
    Camera(Vector3 position)
    {
        Position = position;
        WorldUp = Up;
        updateCameraVectors();
    }
    // 返回使用“欧拉角”和“注视矩阵”计算的视图矩阵
    Matrix4x4 GetViewMatrix() { return Algorithm::LookAt(Position, Vector3::Add(Position, Front), Up); }

private:
    // 根据摄影机的（更新的）Euler角度计算前向量
    void updateCameraVectors()
    {
        // 计算新的Front矢量
        Vector3 front = {0, 0, 0};
        front.SetDataX(cos(Algorithm::Radians(Yaw)) * cos(Algorithm::Radians(Pitch)));
        front.SetDataY(Algorithm::Radians(Pitch));
        front.SetDataZ(Algorithm::Radians(Yaw) * cos(Algorithm::Radians(Pitch)));
        Front = front.Normalize(front);
        // 同时重新计算向右和向上矢量
        // 对向量进行归一化，因为向上或向下看得越多，它们的长度就越接近0，这会导致移动速度变慢。
        Right = Vector3::Normalize(Vector3::Cross(Front, WorldUp));
        Up = Vector3::Normalize(Vector3::Cross(Right, Front));
    }
};
#endif