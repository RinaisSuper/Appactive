#
# Copyright 1999-2022 Alibaba Group Holding Ltd.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

forbiddenFile="forbiddenRule.json"
idUnitMappingNextFile="idUnitMappingNext.json"

idSource=$(cat ./rule/idSource.json)
idTransformer=$(cat ./rule/idTransformer.json)
idUnitMapping=$(cat ./rule/$idUnitMappingNextFile)

gatewayRule="{\"idSource\" : $idSource, \"idTransformer\" : $idTransformer, \"idUnitMapping\" : $idUnitMapping}"
data="{\"key\" : \"459236fc-ed71-4bc4-b46c-69fc60d31f18_test1122\", \"value\" : $gatewayRule}"
echo $data
echo "$(date "+%Y-%m-%d %H:%M:%S") gateway 新规则推送结果: " && curl --header "Content-Type: application/json" \
--request POST \
--data "$data" \
127.0.0.1:8090/set

for file in $(ls ../appactive-demo/data/); do
  if [[ "$file" == *"path-address"* ]]; then
    echo "continue"
    continue
  fi
  echo "$(date "+%Y-%m-%d %H:%M:%S") 应用 ${file} 禁写规则推送中)"
  cp -f ./rule/$forbiddenFile "../appactive-demo/data/$file/forbiddenRule.json"
  echo "$(date "+%Y-%m-%d %H:%M:%S") 应用 ${file} 禁写规则推送完成"
done

echo "等待数据追平......"
sleep 3s

for file in $(ls ../appactive-demo/data/); do
  if [[ "$file" == *"path-address"* ]]; then
    echo "continue"
    continue
  fi
  echo "$(date "+%Y-%m-%d %H:%M:%S") 应用 ${file} 新规则推送中"
  cp -f ./rule/$idUnitMappingNextFile "../appactive-demo/data/$file/idUnitMapping.json"
  echo "$(date "+%Y-%m-%d %H:%M:%S") 应用 ${file} 新规则推送完成"
done
