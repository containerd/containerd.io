# containerd website

The containerd website can be accessed at https://containerd.io. This site includes the containerd [documentation](https://containerd.io/docs) as well as general project information and more.

The containerd site is built using the [Hugo](https://gohugo.io) static site generator and published using [Netlify](https://netlify.com).

## Running locally

In order to run the site locally, you'll need to install the version of Hugo specified using the `HUGO_VERSION` environment variable in [`netlify.toml`](netlify.toml). Instructions can be found in the [official Hugo documentation](https://gohugo.io/getting-started/installing/).

Once you have the proper Hugo version installed, run:

```shell
make serve
```

This will run Hugo in "watch" mode. You can open up your browser to http://localhost:1313 to see the rendered site. The site auto-refreshes when you modify files locally.

## Publishing the site

The site is published automatically by Netlify. Whenever changes are merged to the `main` branch, Netlify will build and deploy the site to the https://containerd-io.netlify.com address (which is mapped to the containerd.io address via DNS). The site *cannot be published manually*.

## Deploy previews

Whenever you submit a pull request to this repo, Netlify will automatically create a [deploy preview](https://www.netlify.com/blog/2016/07/20/introducing-deploy-previews-in-netlify/) with the requested changes. The URL for the deploy preview is:

```
https://deploy-preview-${PULL_REQUEST_NUMBER}--containerd-io.netlify.com/
```

The deploy preview URL for pull request number 100, for example, would be:

```
https://deploy-preview-100--containerd-io.netlify.com/
```

You can also access the deploy preview for a pull request by clicking **Show all checks** and then **Details** (next to the **deploy/netlify** check).

## Contributing to the documentation

The source of truth for containerd's documentation is the [`docs folder`](https://github.com/containerd/containerd/tree/main/docs) in the containerd/containerd repo. Documentation is syncronized to this repo daily using the [Sync-Documentation](/.github/workflows/sync-documentation.yml) workflow.

### Adding new docs

All of containerd's documentation is written in [GitHub-flavored Markdown](https://github.github.com/gfm/). To create a new doc, add a Markdown file in the [`docs folder`](https://github.com/containerd/containerd/tree/main/docs) in the containerd/containerd repo, and it will automatically be cloned into this repo. **DO NOT WRITE DOCUMENTATION DIRECTLY TO THIS REPO -- IT WILL BE DELETED BY THE SYNC-DOCUMENTATION WORKFLOW.**

The name, path, and release branch of the file in the containerd/containerd repo will determine its URL on this site. For example, a document committed to `https://github.com/containerd/containerd/blob/release/1.7/docs/NRI.md` would be available at `https://containerd.io/docs/v1.7.x/nri/`.

Once you've added the doc you'll need to add the following page metadata at the top, as YAML:

* The `title` of the page
* The `weight` of the page. This determines where in the documentation nav the doc appears. Docs with higher weight will be "lower" in the nav. Check the `weight` parameter of other docs to see where your new doc should fit in, and don't hesitate to modify the weight of other docs if the ordering needs to be changed.

Here's an example:

```yaml
---
title: containerd client libraries
weight: 5
---
```

> Technically Hugo also supports [JSON](http://json.org/) and [TOML](https://github.com/toml-lang/toml) for metadata, but please use YAML only for the sake of consistency.

Here are some optional parameters:

* A `description` will show up underneath the doc's title at the top of the page. `description`s can be Markdown.
* If you add `draft: true` to a page's metadata, it will be rendered when you [run the site locally](#running-locally) and in [deploy preview](#deploy-previews) but not on the production site at https://containerd.io. Drafts can be useful for stubbing out and collaborating on documentation content that you want to release at a later date.
* The `short` parameter determines how the doc appears in the documentation navigation. If you add `short: Clients` to the example client libraries doc, it will show up as `Clients` in the nav.

Here's a YAML metadata example with optional parameters:

```yaml
---
title: containerd client libraries
short: Clients
weight: 5
description: Use containerd in conjunction with a variety of programming languages
draft: true
---
```

### Admonition blocks

There are five admonition blocks available for the containerd docs:

* `info` (blue)
* `success` (green)
* `warning` (yellow)
* `danger` (red)
* `requirement` (purple)

To use an admonition block (in this case a success block):

```
Here is some normal documentation.

{{< success >}}
And here is a green "success" block
{{< /success >}}
```

> You can use Markdown inside of admonition blocks.

## Checking links

To check the site's internal links for 404s and other issues, run `make check-links`. This deletes the `public` directory, builds the production version of the site, and checks the output.
