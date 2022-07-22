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

DEPLOY_PRIME_URL?=/
HUGO?=npx hugo

clean:
	rm -rf public/* resources

serve:
	$(HUGO) serve -DEF --disableFastRender

build:
	$(HUGO) --cleanDestinationDir -e dev -DEF

production-build:
	$(HUGO) --cleanDestinationDir
# --minify

preview-build:
	$(HUGO) --cleanDestinationDir -e dev -DEF --baseURL $(DEPLOY_PRIME_URL)

install-link-checker:
	curl https://raw.githubusercontent.com/wjdp/htmltest/master/godownloader.sh | bash

run-link-checker:
	bin/htmltest

check-links: clean production-build install-link-checker run-link-checker
