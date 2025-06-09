---
title: "Collaboration with Kubernetes SIG-Node"
---

containerd is a popular container runtime used with
[Kubernetes](https://kubernetes.io).  containerd implements the Kubernetes
Container Runtime Interface (CRI) and particpates in the development and
implementation of CRI.

The containerd project is adopting a new process to improve collaboration on
[KEPs](https://github.com/kubernetes/enhancements) and other integrations
between containerd and Kubernetes.

## What you need to know as a Kubernetes SIG-Node member, KEP author, or contributor?

### Roles

The containerd project has established two specific roles for facilitating new
KEP implementation:

* SIG-Node member liaison - a containerd maintainer responsible for
  facilitating communication between SIG-Node and the containerd project
  regarding KEP status, targeted containerd releases, and any other integration
  work or pain points.
* KEP shepherd - for each KEP, at least one (preferably two) containerd
  maintainer(s) responsible for helping a KEP move through the implementation
  and release process in containerd.

### Issue management

* Create an issue in the
  [containerd/containerd repository](https://github.com/containerd/containerd)
  tracking the individual KEP as soon as possible
  * containerd KEP tracking issues may be opened by one of the KEP owners,
    an interested maintainer, or by a group within SIG-Node that is managing
    the KEP process
  * Use one issue to track each KEP throughout its lifecycle (Draft, Approved,
    alpha(s), beta(s), and GA)
  * The new issue title should include both the KEP number and a short title or
    description of the goal of the KEP
* containerd maintainers will triage the new issue and assign a KEP shepherd
* A containerd maintainer will add a label to the issue corresponding to the
  Kubernetes release cycle within the containerd/containerd repository during
  triage
* A containerd maintainer will also add a milestone indicating the targeted
  containerd minor release for the KEP (usually the next minor release in our
  [6-month release cadence]({{< ref "releases.md#release-cadence" >}}))
* Use this issue for tracking the status of the KEP and for any
  containerd-specific discussion

## More information
You can find the full description of roles and process in
[the containerd project repository](https://github.com/containerd/project/blob/main/SIG-NODE.md).
