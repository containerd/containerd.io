#!/bin/bash

#   Copyright The containerd Authors.

#   Licensed under the Apache License, Version 2.0 (the "License");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at

#       http://www.apache.org/licenses/LICENSE-2.0

#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an "AS IS" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.

# 1. update all submodules
# 2. copy docs/ directory in each submodule to content/docs/v${MAJOR}.${MINOR}.x
# 3. copy README to content/docs/v${MAJOR}.${MINOR}.x/_index.md
# 4. create an _index.md file in each subdirectory, setting the md title to the directory name, for the nested menu
# 5. clean up
git submodule init ;
git submodule update --recursive --remote ;

git config --file .gitmodules --get-regexp path | awk '{ print $2 }' | \
while read -r SUBMODULE ; do \
    X_VER=`echo $SUBMODULE | tr -d "containerd"` ; \
    rm -rf content/docs/v$X_VER.x ; \
    mkdir -p content/docs/v$X_VER.x/docs ; \
    cp -r $SUBMODULE/docs content/docs/v$X_VER.x/ ; \
    # create titled _index.md files in all subdirs so that hugo sees them as "sections" --
    # this is required for nested-menu-partial to behave correctly
    find content/docs/v$X_VER.x -type d -execdir bash -c 'name=$0;printf "%s\ntitle: ${name##*/}\n%s\n" "---" "---" > "$name/_index.md";' '{}' \; ; \
    # copy README into v$X_VER.x/_index.md with a title added
    printf '%s\ntitle: README\n%s\n%s\n%s\n' "---" "---" "$(cat $SUBMODULE/README.md)" > content/docs/v$X_VER.x/_index.md ; \
    # copy images to static/ since they can't be read from content/
    rsync --files-from <(find content/docs/v$X_VER.x -type f -exec file --mime-type {} \+ | awk -F: '{if ($2 ~/image\//) print $1}') . "static/" ; \
done ;
# move images from static/content/docs/v$X_VER.x/... to static/docs/v$X_VER.x/... so that docs find them where they expect to see them
rm -rf static/docs
mv static/content/* static/
