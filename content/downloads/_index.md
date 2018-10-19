---
title: containerd downloads
---

containerd [releases](#releases) can be downloaded in each of the following ways:

* As a tarball containing all containerd binaries (`containerd`, `ctr`, etc.)
* As a zip file containing the source code
* As a tarball containing the source code

## Installing binaries

To install the binaries for containerd version **{{< latest >}}**, for example:

```shell
wget https://github.com/containerd/containerd/releases/download/v{{< latest >}}/containerd-{{< latest >}}.linux-amd64.tar.gz
tar xvf containerd-{{< latest >}}.linux-amd64.tar.gz
```

This will extract all containerd binaries into a `bin` folder.

{{< info >}}
For a more comprehensive guide to installing and running containerd, see the [Getting started](../docs/getting-started) guide.
{{< /info >}}

## Releases

{{< releases >}}
