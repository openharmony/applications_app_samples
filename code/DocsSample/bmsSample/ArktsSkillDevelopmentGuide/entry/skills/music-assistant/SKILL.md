---
name: music-assistant
description: 提供音乐搜索播放与播控能力，响应"放首歌"、"切歌"、"暂停"等播放控制类指令
---

# music-assistant

本Skill基于ArkTS函数`playMusicByName`与`controlPlayback`,
响应自然语言中"听歌"、"放歌"、"暂停"、"下一首"等播放意图,
通过调用宿主应用内的ArkTS函数完成播放并将结果回传给系统智能体。

## 触发场景

当用户明确表达**播放音乐**或**控制当前播放**时调用。典型话术:

- "放一首SingerA的《SongA》"
- "我想听点轻音乐"
- "来首《SongA》"
- "暂停"
- "继续播放"
- "切歌"、"下一首"、"上一曲"

不要调用的情况:

- 用户说"把这首歌加入收藏"——意图是修改歌单,本Skill仅支持播放与播控。
- 用户说"今天有什么演唱会"——意图是查询资讯,非播放。
- 用户没有明确指向播放(如"这首歌真好听")——情绪表达,无需调用。
- 用户说"调小音量"——意图是系统音量控制,应走系统能力。

### 场景1:按名称播放音乐(playMusicByName)

**触发场景**:用户说"放一首《SongA》"、"来首SingerA的歌"等

**执行参数**:
示例如下:

```
exec-cli(command: ohos-arkTSScript --skillName 'music-assistant' --scriptPath 'scripts/MusicSkill.ets' --functionName 'playMusicByName' --args '{
    "arg1": "SongA",
    "arg2": "SingerA"
}'
)
```

约束如下:

```
{
    "type": "object",
    "properties": {
        "command": {
            "type": "string",
            "description": "命令行",
            "const": "ohos-arkTSScript"
        },
        "skillName": {
            "type": "string",
            "description": "skill名称",
            "const": "music-assistant"
        },
        "scriptPath": {
            "type": "string",
            "description": "ETS文件路径",
            "const": "scripts/MusicSkill.ets"
        },
        "functionName": {
            "type": "string",
            "description": "函数名称",
            "const": "playMusicByName"
        },
        "args": {
            "type": "object",
            "description": "Object类型的参数,由系统智能体填入。举例:{'arg1':'SongA','arg2':'SingerA'}",
            "properties": {
                "arg1": {
                    "type": "string",
                    "description": "歌曲名,如《SongA》"
                },
                "arg2": {
                    "type": "string",
                    "description": "歌手名,如SingerA"
                }
            },
            "anyOf": [
                { "required": ["arg1"] },
                { "required": ["arg2"] }
            ]
        }
    },
    "required": [
        "command",
        "skillName",
        "scriptPath",
        "functionName",
        "args"
    ]
}
```

**执行返回值**:
示例如下:

1. 成功播放

```
{
  "type": "result",
  "status": "success",
  "data": {
    "playingTrack": { "name": "SongA", "singer": "SingerA", "duration": 269 },
    "matchedCount": 1
  }
}
```

2. 入参非法

```
{
   "type": "result",
   "status": "failed",
   "errCode": "ERR_INVALID_PARAMS",
   "errMsg": "songName and singer are both empty",
   "suggestion": "我没听清,你想听哪首歌?"
}
```

3. 未命中

```
{
   "type": "result",
   "status": "failed",
   "errCode": "ERR_NOT_FOUND",
   "data": { "searchedKeywords": ["SongA", "SingerA"] },
   "suggestion": "没有找到SingerA的《SongA》"
}
```

4. 内部错误

```
{
   "type": "result",
   "status": "failed",
   "errCode": "ERR_INTERNAL",
   "errMsg": "network timeout",
   "suggestion": "播放失败了,稍后再试试"
}
```

约束如下:

```
{
  "type": "object",
  "required": ["type", "status"],
  "properties": {
    "type": {
      "type": "string",
      "description": "结果类型标识",
      "const": "result"
    },
    "status": {
      "type": "string",
      "description": "执行状态: success表示成功, failed表示失败",
      "enum": ["success", "failed"]
    },
    "data": {
      "type": "object",
      "description": "开发者返回的自定义业务数据,结构由具体分支决定"
    },
    "errCode": {
      "type": "string",
      "description": "错误码,仅在status=failed时出现",
      "enum": [
        "ERR_INVALID_PARAMS",
        "ERR_NOT_FOUND",
        "ERR_INTERNAL"
      ]
    },
    "errMsg": {
      "type": "string",
      "description": "错误描述",
      "minLength": 1
    },
    "suggestion": {
      "type": "string",
      "description": "建议的下一步操作,可由系统智能体直接组织成自然语言回复",
      "minLength": 1
    }
  },
  "oneOf": [
    {
      "description": "成功: 已开始播放,至少命中一条歌曲",
      "properties": {
        "status": { "const": "success" },
        "data": {
          "type": "object",
          "required": ["playingTrack", "matchedCount"],
          "properties": {
            "playingTrack": {
              "type": "object",
              "required": ["name", "singer", "duration"],
              "properties": {
                "name":     { "type": "string", "minLength": 1 },
                "singer":   { "type": "string", "minLength": 1 },
                "duration": { "type": "integer", "minimum": 0 }
              }
            },
            "matchedCount": {
              "type": "integer",
              "description": "命中数量",
              "minimum": 1
            }
          }
        }
      },
      "required": ["type", "status", "data"]
    },
    {
      "description": "失败-参数: 入参非法,不可重试(同入参)",
      "properties": {
        "status":  { "const": "failed" },
        "errCode": { "const": "ERR_INVALID_PARAMS" },
        "errMsg":  { "type": "string", "minLength": 1 },
        "suggestion": {
          "type": "string",
          "description": "例如:我没听清,你想听哪首歌?"
        }
      },
      "required": ["type", "status", "errCode", "errMsg", "suggestion"]
    },
    {
      "description": "失败-未命中: 关键词合法但歌库中无匹配歌曲,不可重试",
      "properties": {
        "status":  { "const": "failed" },
        "errCode": { "const": "ERR_NOT_FOUND" },
        "data": {
          "type": "object",
          "required": ["searchedKeywords"],
          "properties": {
            "searchedKeywords": {
              "type": "array",
              "description": "实际执行查询时使用的关键词数组",
              "minItems": 1,
              "items": { "type": "string", "minLength": 1 }
            }
          },
          "additionalProperties": false
        },
        "suggestion": {
          "type": "string",
          "description": "例如:没有找到SingerA的《SongA》"
        }
      },
      "required": ["type", "status", "errCode", "data", "suggestion"]
    },
    {
      "description": "失败-内部: 网络异常或未知异常,可重试(建议节流)",
      "properties": {
        "status":  { "const": "failed" },
        "errCode": { "const": "ERR_INTERNAL" },
        "errMsg":  { "type": "string", "minLength": 1 },
        "suggestion": {
          "type": "string",
          "description": "例如:播放失败了,稍后再试试"
        }
      },
      "required": ["type", "status", "errCode", "errMsg", "suggestion"]
    }
  ]
}
```

### 场景2:播放控制(controlPlayback)

**触发场景**:用户说"暂停"、"继续"、"下一首"、"上一曲"

**执行参数**:
示例如下:

```
exec-cli(command: ohos-arkTSScript --skillName 'music-assistant' --scriptPath 'scripts/MusicSkill.ets' --functionName 'controlPlayback' --args '{
    "arg1": "next"
}'
)
```

约束如下:

```
{
    "type": "object",
    "properties": {
        "command": {
            "type": "string",
            "description": "命令行",
            "const": "ohos-arkTSScript"
        },
        "skillName": {
            "type": "string",
            "description": "skill名称",
            "const": "music-assistant"
        },
        "scriptPath": {
            "type": "string",
            "description": "ETS文件路径",
            "const": "scripts/MusicSkill.ets"
        },
        "functionName": {
            "type": "string",
            "description": "函数名称",
            "const": "controlPlayback"
        },
        "args": {
            "type": "object",
            "description": "Object类型的参数,由系统智能体填入。举例:{'arg1':'next'}",
            "properties": {
                "arg1": {
                    "type": "string",
                    "description": "控制指令,合法值:pause | resume | next | previous",
                    "enum": ["pause", "resume", "next", "previous"]
                }
            },
            "required": ["arg1"]
        }
    },
    "required": [
        "command",
        "skillName",
        "scriptPath",
        "functionName",
        "args"
    ]
}
```

**执行返回值**:
示例如下:

1. 控制成功

```
{
  "type": "result",
  "status": "success",
  "data": {
    "action": "next",
    "currentTrack": { "name": "SongB", "singer": "SingerA" }
  }
}
```

2. 入参非法

```
{
   "type": "result",
   "status": "failed",
   "errCode": "ERR_INVALID_PARAMS",
   "errMsg": "invalid action: stop",
   "suggestion": "我没听清,你想暂停、继续还是切换歌曲?"
}
```

3. 内部错误

```
{
   "type": "result",
   "status": "failed",
   "errCode": "ERR_INTERNAL",
   "errMsg": "player not initialized",
   "suggestion": "操作失败了,稍后再试试"
}
```

约束如下:

```
{
  "type": "object",
  "required": ["type", "status"],
  "properties": {
    "type":   { "type": "string", "const": "result" },
    "status": { "type": "string", "enum": ["success", "failed"] },
    "data":   { "type": "object" },
    "errCode": {
      "type": "string",
      "enum": ["ERR_INVALID_PARAMS", "ERR_INTERNAL"]
    },
    "errMsg":     { "type": "string", "minLength": 1 },
    "suggestion": { "type": "string", "minLength": 1 }
  },
  "oneOf": [
    {
      "description": "成功: 控制指令已执行",
      "properties": {
        "status": { "const": "success" },
        "data": {
          "type": "object",
          "required": ["action"],
          "properties": {
            "action": {
              "type": "string",
              "enum": ["pause", "resume", "next", "previous"]
            },
            "currentTrack": {
              "type": "object",
              "required": ["name", "singer"],
              "properties": {
                "name":   { "type": "string", "minLength": 1 },
                "singer": { "type": "string", "minLength": 1 }
              }
            }
          }
        }
      },
      "required": ["type", "status", "data"]
    },
    {
      "description": "失败-参数: 控制指令非法,不可重试(同入参)",
      "properties": {
        "status":  { "const": "failed" },
        "errCode": { "const": "ERR_INVALID_PARAMS" },
        "errMsg":  { "type": "string", "minLength": 1 },
        "suggestion": {
          "type": "string",
          "description": "例如:我没听清,你想暂停、继续还是切换歌曲?"
        }
      },
      "required": ["type", "status", "errCode", "errMsg", "suggestion"]
    },
    {
      "description": "失败-内部: 播放器异常或未知异常,可重试(建议节流)",
      "properties": {
        "status":  { "const": "failed" },
        "errCode": { "const": "ERR_INTERNAL" },
        "errMsg":  { "type": "string", "minLength": 1 },
        "suggestion": {
          "type": "string",
          "description": "例如:操作失败了,稍后再试试"
        }
      },
      "required": ["type", "status", "errCode", "errMsg", "suggestion"]
    }
  ]
}
```