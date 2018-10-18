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
