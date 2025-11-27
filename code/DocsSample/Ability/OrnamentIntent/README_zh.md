# 使用装饰器开发意图
### 介绍

本示例展示了[使用装饰器开发意图](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/insight-intent-decorator-development.md)的功能集成实现方法：
1. 通过装饰器开发意图，能够将现有功能快速接入系统入口。
2. 将指南文档中装饰器开发意图的示例代码片段进行工程化落地，确保指南中的示例代码与 Sample 工程文件保持一致。

### 效果展示
不涉及。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── insightintents
 │   │   │  ├── ArtistInformationImpl.ets		//定义音乐名称和歌手信息意图实体
 │   │   │  ├── PlayMusicImpl.ets		//以开发“播放音乐”自定义意图举例
 │   │   │  ├── UsePlayMusicIntents.ets		//使用意图实体
 │   │   │  ├── ViewLogisticsImpl.ets		//通过@InsightIntentEntry装饰器开发查看快递标准意图举例
 │   │   └── pages
 │   │       └── Index.ets
 │   ├── module.json5
 │   └── resources
 │   │   ├── base
 │   │   │   └── profile
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       └── Ability.test.ets        // 自动化测试代码
 ```

### 使用说明
1. 配置：所有意图执行文件需在insightintent.json的insightIntentsSrcEntry字段中声明路径，确保文件参与编译。
2. 意图类型开发区分：开发标准意图时，需通过schema和intentVersion匹配系统标准意图规范，无需自定义参数与描述；开发自定义意图时，需完整配置llmDescription、keywords、parameters等字段，明确意图的语言描述、搜索关键词及参数格式。
3. 复杂参数传递方式：若需处理歌手信息等复杂数据，可通过@InsightIntentEntity装饰器定义意图实体类，在意图的parameters中声明实体结构，实现多字段参数的结构化传递。
4. 执行模式与组件绑定：根据业务需求配置executeMode（如前台 / 后台启动），并绑定对应的Ability组件；意图执行时，系统会根据配置的模式启动组件，开发者需在onExecute方法中实现核心业务逻辑，并返回规范的IntentResult结果。

### 具体实现
1. 意图类型选择
标准意图：如查询天气、导航等系统预定义意图，无需开发者定义意图参数。
自定义意图：如播放音乐、购物直达页面等，需自行定义意图参数及执行逻辑。
2. 配置意图入口文件;
3. 使用装饰器定义意图，通过 @InsightIntentEntry装饰器绑定意图逻辑，继承InsightIntentEntryExecutor类。

### 相关权限
不涉及。

### 依赖
不涉及。

### 约束与限制
1. 本示例为Stage模型，从 API version 20开始，支持通过装饰器开发意图；
2. 本示例需要使用DevEco Studio 5.0 及以上版本才可编译运行。

### 下载
如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/OrnamentIntent > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```