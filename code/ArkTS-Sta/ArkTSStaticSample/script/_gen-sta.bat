@echo off

cd %~dp0
cd ..
cd

node script\copy.js library\src\main\ets\components\dyn\DataModel.ts   library\src\main\ets\components\sta\DataModel.ets
@REM node script\copy.js library\src\main\ets\components\dyn\DataParser.ts  library\src\main\ets\components\sta\DataParser.ets
@REM node script\copy.js library\src\main\ets\components\dyn\DataSource.ts  library\src\main\ets\components\sta\DataSource.ets
@REM node script\copy.js library\src\main\ets\components\dyn\FLCardData.ts  library\src\main\ets\components\sta\FLCardData.ets
node script\copy.js library\src\main\ets\components\dyn\IndexDyn.ts    library\src\main\ets\components\sta\IndexSta.ets
@REM node script\copy.js library\src\main\ets\components\dyn\CommonType.ts  library\src\main\ets\components\sta\CommonType.ets
node script\copy.js library\src\main\ets\components\dyn\Workload.ts  library\src\main\ets\components\sta\Workload.ets
