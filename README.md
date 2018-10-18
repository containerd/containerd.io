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

The site is published automatically by Netlify. Whenever changes are merged to the `master` branch, Netlify will build and deploy the site to the https://containerd-io.netlify.com address (which is mapped to the containerd.io address via DNS). The site *cannot be published manually*.

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

All of containerd's documentation is written in [GitHub-flavored Markdown](https://github.github.com/gfm/) and contained in the [`content/docs`](content/docs) folder.

### Adding new docs

To create a new doc, add a Markdown file to `content/docs`. The name of the file will determine its URL. This doc, for example, would be available at `https://containerd.io/docs/client-libraries`:

```shell
touch content/docs/client-libraries.md
```

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

---
```
