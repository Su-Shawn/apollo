#!/usr/bin/env bash

###############################################################################
# Copyright 2017 The Apollo Authors. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
###############################################################################

TOP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd -P)"
source "${TOP_DIR}/scripts/apollo_base.sh"

function setup() {
  bash scripts/canbus.sh start
  bash scripts/gps.sh start
  bash scripts/localization.sh start
  bash scripts/control.sh start
}

function start() {
  NUM_PROCESSES="$(pgrep -c -f "record_play/rtk_player")"
  if [ "${NUM_PROCESSES}" -ne 0 ]; then
    pkill -SIGKILL -f rtk_player
  fi

  ${TOP_DIR}/bazel-bin/modules/tools/record_play/rtk_player
}

function stop() {
  pkill -SIGKILL -f rtk_player
}

case $1 in
  setup)
    setup
    ;;
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  *)
    start
    ;;
esac
