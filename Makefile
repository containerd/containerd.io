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

clean:
	rm -rf public resources

containerd-1.7.x:
	git clone --branch v1.7.0 --depth 1 https://github.com/containerd/containerd.git containerd-1.7.x

content/v1.7.x: containerd-1.7.x
	cp -r containerd-1.7.x/docs content/v1.7.x

containerd-1.6.x:
	git clone --branch v1.6.19 --depth 1 https://github.com/containerd/containerd.git containerd-1.6.x

content/v1.6.x: containerd-1.6.x
	cp -r containerd-1.6.x/docs content/v1.6.x

serve: content/v1.7.x content/v1.6.x
	hugo server \
		--buildDrafts \
		--buildFuture \
		--disableFastRender

production-build: content/v1.7.x content/v1.6.x
	hugo \
	--minify

preview-build: content/v1.7.x content/v1.6.x
	hugo \
		--baseURL $(DEPLOY_PRIME_URL) \
		--buildDrafts \
		--buildFuture

install-link-checker:
	curl https://raw.githubusercontent.com/wjdp/htmltest/master/godownloader.sh | bash

run-link-checker:
	bin/htmltest

check-links: clean production-build install-link-checker run-link-checker
