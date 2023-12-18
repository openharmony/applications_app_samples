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

arg_url=""
arg_sdk_path=""
arg_api_version=""
arg_help="0"

function clear_dir(){
        if [ ! -d "$1" ]; then
                mkdir -p $1
        else
                rm -rf $1/*
        fi
}

function get_sdk_type(){
	sdk_url=${1}
	is_public=$(echo ${sdk_url} | grep "\-public")
	if [[ ${is_public} != "" ]]; then
                arg_sdk_type="public"
		return
        fi
        is_full=$(echo ${sdk_url} | grep "\-full")
        if [[ ${is_full} != "" ]]; then
                arg_sdk_type="full"
        fi
	arg_sdk_type="unknown"
}


function print_help() {
  cat <<EOF
  use update_sdk [options] <mainclass> [args...]

    --url=[sdk url]
    --sdk_path=[public sdk absolute address]

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

if [ "${arg_url}" == "" ]; then
        echo "--url is not null"
        exit 1;
fi

if [ "${arg_sdk_path}" == "" ]; then
        echo "--sdk_path is not null"
        exit 1;
fi



# 添加交互式判断 sdk目录是否删除 判空等操作
clear_dir ${arg_sdk_path}
clear_dir ${TEMP_SDK_PAK}
cd ${TEMP_SDK_PAK}
wget ${arg_url}

for z in `ls`
do
	if [ "${z##*.}" == "gz" ]; then
                tar -zxf ${z}
        fi
done

source_path=""
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

if [ "${arg_api_version}" == "" ]; then
	for z in ${source_path}/linux/*
	do
        	if [ "${z##*.}" == "zip" ]; then
                	continue
        	fi
        	if [ -f "${z}" ]; then
                	continue
        	fi
		if [ -f "${z}/oh-uni-package.json" ]; then
			arg_api_version=$(cat ${z}/oh-uni-package.json | grep "apiVersion")
			break
		fi
	done
fi
echo "apiVersion is ${arg_api_version##*:}"
target_path=${arg_sdk_path}
for z in ${source_path}/linux/*
do
	if [ "${z##*.}" == "zip" ]; then
		continue
	fi
	if [ -f "${z}" ]; then
                continue
        fi
	echo "moving... ${z} to ${target_path}"
	mv ${z} ${target_path}/
	if [ ${z##*/} == "ets" ]; then
		echo "ets npm install"
		cd ${target_path}/${z##*/}/build-tools/ets-loader
		npm install > /dev/null 2>&1
	fi
	if [ ${z##*/} == "js" ]; then
		echo "js npm install"
                cd ${target_path}/${z##*/}/build-tools/ace-loader
                npm install > /dev/null 2>&1
        fi

done
rm -rf ${TEMP_SDK_PAK}

echo "sdk undate success.."
exit 0
