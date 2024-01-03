#  Copyright (c) 2023 Huawei Device Co., Ltd.
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at

#      http://www.apache.org/licenses/LICENSE-2.0

#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

#!/bin/bash


#npm
npm config set @ohos:registry=https://repo.harmonyos.com/npm/

date_time=`date +"%Y%m%d%H%M%S"`
CUR_PATH=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
BASE_PATH=$(dirname ${CUR_PATH})
TEMP_SDK_PAK=${BASE_PATH}/temp_sdk_${date_time}

function clear_dir(){
        if [ ! -d "$1" ]; then
                mkdir -p $1
        else
                rm -rf $1/*
        fi
}

function create_dir(){
        if [ ! -d "$1" ]; then
                mkdir -p $1
        fi
}

arg_sdk_path=${BASE_PATH}/sdk
arg_full_sdk_path=${BASE_PATH}/sdk-full
arg_conf_path=${BASE_PATH}/config/init_sdk.config
arg_help="0"

function print_help() {
  cat <<EOF
  use assembleHap [options] <mainclass> [args...]

    --sdk_path=[public sdk absolute address] (default:$arg_sdk_path)
    --full_sdk_path=[full sdk absolute address] (default:$arg_full_sdk_path)
    --conf_path=[config absolute address] (default:$arg_conf_path)]

    --help  - prints help screen

EOF
}

function parse_arguments() {
        local helperKey="";
        local helperValue="";
        local current="";

        while [ "$1" != "" ]; do
                current=$1;
                helperKey=${current#*--};
                helperKey=${helperKey%%=*};
                helperKey=$(echo "$helperKey" | tr '-' '_');
                helperValue=${current#*=};
                if [ "$helperValue" == "$current" ]; then
                        helperValue="1";
                fi
                # echo "eval arg_$helperKey=\"$helperValue\"";

                eval "arg_$helperKey=\"$helperValue\"";
                shift
        done
}

parse_arguments ${@};

if [ "$arg_help" != "0" ]; then
        print_help;
        exit 1;
fi


function init_sdk_dir(){
        echo "init sdk dir..."
        clear_dir ${arg_sdk_path}
	clear_dir ${arg_full_sdk_path}
}

function load_sdk(){
        source_path=""
	sdk_type=${1}
	sdk_version=${2}
        sdk_url=${3}
	echo "loading sdk from ${sdk_url}..."
	target_path=${BASE_PATH}
        if [[ "${sdk_type}" == "public" ]]; then
        	target_path=${arg_sdk_path}
	elif [[ "${sdk_type}" == "full" ]]; then
        	target_path=${arg_full_sdk_path}
	else
		echo "the ${sdk_url} is invalid"
        	exit 1
        fi
        clear_dir ${TEMP_SDK_PAK}
        cd ${TEMP_SDK_PAK}
        wget ${sdk_url}
        
        for z in `ls`
        do
                if [ "${z##*.}" == "gz" ]; then
                        tar -zxf ${z}
                fi
        done
        
        for z in ${TEMP_SDK_PAK}/*
        do
                if [ -d ${z}/linux ]; then
                        source_path=${z}
                fi
        done
        
        cd ${source_path}/linux/
        for z in `ls`
        do
                if [ "${z##*.}" != "zip" ]; then
                        continue
                fi
                echo "unzip ${z}ing..."
                unzip -oq ${z}
        done
        
        for z in ${source_path}/linux/*
        do
                if [ "${z##*.}" == "zip" ]; then
                        continue
                fi
                if [ -f "${z}" ]; then
                        continue
                fi
                create_dir ${target_path}/${sdk_version}
                echo "moving... ${z} to ${target_path}/${sdk_version}/${z##*/}"
                mv ${z} ${target_path}/${sdk_version}/${z##*/}
                if [ ${z##*/} == "ets" ]; then
                        echo "ets npm install"
                        cd ${target_path}/${sdk_version}/${z##*/}/build-tools/ets-loader
                        npm install > /dev/null 2>&1
                fi
                if [ ${z##*/} == "js" ]; then
                        echo "js npm install"
                        cd ${target_path}/${sdk_version}/${z##*/}/build-tools/ace-loader
                        npm install > /dev/null 2>&1
                fi
        
        done
        rm -rf ${TEMP_SDK_PAK}
}


init_sdk_dir

while read line
do
	if [ ${line:0:1} == "#" ]; then
		continue
	fi
	sdk_desc=(${line//;/ })
        load_sdk ${sdk_desc[0]} ${sdk_desc[1]} ${sdk_desc[2]}         
done < ${arg_conf_path}

echo "sdk init success.."
exit 0
