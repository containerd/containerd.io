---
title: containerd downloads
---

containerd [releases](#releases) can be downloaded in each of the following ways:

* As a tarball containing all containerd binaries (`containerd`, `ctr`, etc.)
* As a zip file containing the source code
* As a tarball containing the source code

{{< info >}}
For a more comprehensive guide to installing and running containerd, see the [Getting started](https://github.com/containerd/containerd/blob/main/docs/getting-started.md) guide.
{{< /info >}}

## Installing binaries

To install the binaries for containerd version **{{< latest >}}** (latest), click on the **Binaries (.tar.gz)** button for that version in the [Releases](#releases) table below. That will copy the tarball URL to your clipboard. Use [`wget`](https://www.gnu.org/software/wget/) to download the tarball and untar it.

```shell
wget https://github.com/containerd/containerd/releases/download/v{{< latest >}}/containerd-{{< latest >}}-linux-amd64.tar.gz
tar xvf containerd-{{< latest >}}-linux-amd64.tar.gz
```

## Releases

The table below lists recent releases of containerd.

{{< success >}}
Clicking on the buttons in the **Copy link** column in the middle will copy the URL of the ZIP file or tarball into your clipboard. Clicking on the buttons in the **Direct download** column on the right will initiate a download of the ZIP file or tarball.
{{< /success >}}

{{< releases >}}
