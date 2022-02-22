---
title: Getting started with containerd
short: Getting started
weight: 2
---

There are many different ways to use containerd:

* If you are a developer working on containerd you can use the `ctr` tool to quickly test features and functionality without writing extra code
* If you want to integrate containerd into your project, you can use a simple client package. In this guide, we will pull and run a Redis server with containerd using that client package.

We will assume that you are running a modern Linux host for this example with a compatible build of `runc`.

{{< info >}}
This project requires Go 1.9.x or above.
{{< /info >}}

If you need to install Go or update your currently installed one, please refer to [Go installation page](https://golang.org/doc/install).

## Starting containerd

You can download the latest source build for containerd from the [Downloads](/downloads) page and then use your favorite process supervisor to get the daemon started.

### Systemd-based distributions
To install version {{< latest >}} on a distribution with Systemd, run the following commands:

```shell
wget https://github.com/containerd/containerd/releases/download/v{{< latest >}}/cri-containerd-cni-{{< latest >}}-linux-amd64.tar.gz
sudo tar --no-overwrite-dir -C / -xzf cri-containerd-cni-{{< latest >}}-linux-amd64.tar.gz
sudo systemctl daemon-reload
sudo systemctl enable --now containerd
```
### Non-Systemd distributions
> &#x26a0;&#xfe0f; **The directory containerd is extracted to has to be included in your PATH variable!**

Example:
```shell
wget https://github.com/containerd/containerd/releases/download/v{{< latest >}}/cri-containerd-cni-{{< latest >}}-linux-amd64.tar.gz
sudo tar --no-overwrite-dir -C /usr/local/containerd -xzf cri-containerd-cni-{{< latest >}}-linux-amd64.tar.gz
```
After extracting containerd, start the `containerd` binary with your desired service manager e.g. `supervisord` or `upstart`.

The daemon also uses a configuration file located in `/etc/containerd/config.toml` for specifying daemon level options.
The default configuration file looks like this:

```toml
version = 2
root = "/var/lib/containerd"
state = "/run/containerd"
plugin_dir = ""
disabled_plugins = []
required_plugins = []
oom_score = 0

[grpc]
  address = "/run/containerd/containerd.sock"
  tcp_address = ""
  tcp_tls_cert = ""
  tcp_tls_key = ""
  uid = 0
  gid = 0
  max_recv_message_size = 16777216
  max_send_message_size = 16777216

[ttrpc]
  address = ""
  uid = 0
  gid = 0

[debug]
  address = ""
  uid = 0
  gid = 0
  level = ""

[metrics]
  address = ""
  grpc_histogram = false

[cgroup]
  path = ""

[timeouts]
  "io.containerd.timeout.shim.cleanup" = "5s"
  "io.containerd.timeout.shim.load" = "5s"
  "io.containerd.timeout.shim.shutdown" = "3s"
  "io.containerd.timeout.task.state" = "2s"

[plugins]
  [plugins."io.containerd.gc.v1.scheduler"]
    pause_threshold = 0.02
    deletion_threshold = 0
    mutation_threshold = 100
    schedule_delay = "0s"
    startup_delay = "100ms"
  [plugins."io.containerd.grpc.v1.cri"]
    disable_tcp_service = true
    stream_server_address = "127.0.0.1"
    stream_server_port = "0"
    stream_idle_timeout = "4h0m0s"
    enable_selinux = false
    selinux_category_range = 1024
    sandbox_image = "k8s.gcr.io/pause:3.2"
    stats_collect_period = 10
    systemd_cgroup = false
    enable_tls_streaming = false
    max_container_log_line_size = 16384
    disable_cgroup = false
    disable_apparmor = false
    restrict_oom_score_adj = false
    max_concurrent_downloads = 3
    disable_proc_mount = false
    unset_seccomp_profile = ""
    tolerate_missing_hugetlb_controller = true
    disable_hugetlb_controller = true
    ignore_image_defined_volumes = false
    [plugins."io.containerd.grpc.v1.cri".containerd]
      snapshotter = "overlayfs"
      default_runtime_name = "runc"
      no_pivot = false
      disable_snapshot_annotations = true
      discard_unpacked_layers = false
      [plugins."io.containerd.grpc.v1.cri".containerd.default_runtime]
        runtime_type = ""
        runtime_engine = ""
        runtime_root = ""
        privileged_without_host_devices = false
        base_runtime_spec = ""
      [plugins."io.containerd.grpc.v1.cri".containerd.untrusted_workload_runtime]
        runtime_type = ""
        runtime_engine = ""
        runtime_root = ""
        privileged_without_host_devices = false
        base_runtime_spec = ""
      [plugins."io.containerd.grpc.v1.cri".containerd.runtimes]
        [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc]
          runtime_type = "io.containerd.runc.v2"
          runtime_engine = ""
          runtime_root = ""
          privileged_without_host_devices = false
          base_runtime_spec = ""
          [plugins."io.containerd.grpc.v1.cri".containerd.runtimes.runc.options]
    [plugins."io.containerd.grpc.v1.cri".cni]
      bin_dir = "/opt/cni/bin"
      conf_dir = "/etc/cni/net.d"
      max_conf_num = 1
      conf_template = ""
    [plugins."io.containerd.grpc.v1.cri".registry]
      [plugins."io.containerd.grpc.v1.cri".registry.mirrors]
        [plugins."io.containerd.grpc.v1.cri".registry.mirrors."docker.io"]
          endpoint = ["https://registry-1.docker.io"]
    [plugins."io.containerd.grpc.v1.cri".image_decryption]
      key_model = ""
    [plugins."io.containerd.grpc.v1.cri".x509_key_pair_streaming]
      tls_cert_file = ""
      tls_key_file = ""
  [plugins."io.containerd.internal.v1.opt"]
    path = "/opt/containerd"
  [plugins."io.containerd.internal.v1.restart"]
    interval = "10s"
  [plugins."io.containerd.metadata.v1.bolt"]
    content_sharing_policy = "shared"
  [plugins."io.containerd.monitor.v1.cgroups"]
    no_prometheus = false
  [plugins."io.containerd.runtime.v1.linux"]
    shim = "containerd-shim"
    runtime = "runc"
    runtime_root = ""
    no_shim = false
    shim_debug = false
  [plugins."io.containerd.runtime.v2.task"]
    platforms = ["linux/amd64"]
  [plugins."io.containerd.service.v1.diff-service"]
    default = ["walking"]
  [plugins."io.containerd.snapshotter.v1.devmapper"]
    root_path = ""
    pool_name = ""
    base_image_size = ""
    async_remove = false
```

The default configuration can be generated via `containerd config default > /etc/containerd/config.toml`.

## Connecting to containerd

We will start a new `main.go` file and import the containerd root package that contains the client.


```go
package main

import (
	"log"

	"github.com/containerd/containerd"
)

func main() {
	if err := redisExample(); err != nil {
		log.Fatal(err)
	}
}

func redisExample() error {
	client, err := containerd.New("/run/containerd/containerd.sock")
	if err != nil {
		return err
	}
	defer client.Close()
	return nil
}
```

This will create a new client with the default containerd socket path.
Because we are working with a daemon over GRPC we need to create a `context` for use with calls to client methods.
containerd is also namespaced for callers of the API.
We should also set a namespace for our guide after creating the context.

```go
	ctx := namespaces.WithNamespace(context.Background(), "example")
```

Having a namespace for our usage ensures that containers, images, and other resources without containerd do not conflict with other users of a single daemon.

## Pulling the redis image

Now that we have a client to work with we need to pull an image.
We can use the redis image based on Alpine Linux from the DockerHub.

```go
	image, err := client.Pull(ctx, "docker.io/library/redis:alpine", containerd.WithPullUnpack)
	if err != nil {
		return err
	}
```

The containerd client uses the `Opts` pattern for many of the method calls.
We use the `containerd.WithPullUnpack` so that we not only fetch and download the content into containerd's content store but also unpack it into a snapshotter for use as a root filesystem.

Let's put the code together that will pull the redis image based on alpine linux from Dockerhub and then print the name of the image on the console's output.

```go
package main

import (
        "context"
        "log"

        "github.com/containerd/containerd"
        "github.com/containerd/containerd/namespaces"
)

func main() {
        if err := redisExample(); err != nil {
                log.Fatal(err)
        }
}

func redisExample() error {
        client, err := containerd.New("/run/containerd/containerd.sock")
        if err != nil {
                return err
        }
        defer client.Close()

        ctx := namespaces.WithNamespace(context.Background(), "example")
        image, err := client.Pull(ctx, "docker.io/library/redis:alpine", containerd.WithPullUnpack)
        if err != nil {
                return err
        }
        log.Printf("Successfully pulled %s image\n", image.Name())

        return nil
}
```

```bash
> go build main.go
> sudo ./main

2017/08/13 17:43:21 Successfully pulled docker.io/library/redis:alpine image
```

## Creating an OCI Spec and Container

Now that we have an image to base our container off of, we need to generate an OCI runtime specification that the container can be based off of as well as the new container.

containerd provides reasonable defaults for generating OCI runtime specs.
There is also an `Opt` for modifying the default config based on the image that we pulled.

The container will be based off of the image, use the runtime information in the spec that was just created, and we will allocate a new read-write snapshot so the container can store any persistent information.

```go
	container, err := client.NewContainer(
		ctx,
		"redis-server",
		containerd.WithNewSnapshot("redis-server-snapshot", image),
		containerd.WithNewSpec(oci.WithImageConfig(image)),
	)
	if err != nil {
		return err
	}
	defer container.Delete(ctx, containerd.WithSnapshotCleanup)
```

If you have an existing OCI specification created you can use `containerd.WithSpec(spec)` to set it on the container.

When creating a new snapshot for the container we need to provide a snapshot ID as well as the Image that the container will be based on.
By providing a separate snapshot ID than the container ID we can easily reuse, existing snapshots across different containers.

We also add a line to delete the container along with its snapshot after we are done with this example.

Here is example code to pull the redis image based on alpine linux from Dockerhub, create an OCI spec, create a container based on the spec and finally delete the container.
```go
package main

import (
        "context"
        "log"

        "github.com/containerd/containerd"
        "github.com/containerd/containerd/oci"
        "github.com/containerd/containerd/namespaces"
)

func main() {
        if err := redisExample(); err != nil {
                log.Fatal(err)
        }
}

func redisExample() error {
        client, err := containerd.New("/run/containerd/containerd.sock")
        if err != nil {
                return err
        }
        defer client.Close()

        ctx := namespaces.WithNamespace(context.Background(), "example")
        image, err := client.Pull(ctx, "docker.io/library/redis:alpine", containerd.WithPullUnpack)
        if err != nil {
                return err
        }
        log.Printf("Successfully pulled %s image\n", image.Name())

        container, err := client.NewContainer(
                ctx,
                "redis-server",
                containerd.WithNewSnapshot("redis-server-snapshot", image),
                containerd.WithNewSpec(oci.WithImageConfig(image)),
        )
        if err != nil {
                return err
        }
        defer container.Delete(ctx, containerd.WithSnapshotCleanup)
        log.Printf("Successfully created container with ID %s and snapshot with ID redis-server-snapshot", container.ID())

        return nil
}
```

Let's see it in action.

```bash
> go build main.go
> sudo ./main

2017/08/13 18:01:35 Successfully pulled docker.io/library/redis:alpine image
2017/08/13 18:01:35 Successfully created container with ID redis-server and snapshot with ID redis-server-snapshot
```

## Creating a running Task

One thing that may be confusing at first for new containerd users is the separation between a `Container` and a `Task`.
A container is a metadata object that resources are allocated and attached to.
A task is a live, running process on the system.
Tasks should be deleted after each run while a container can be used, updated, and queried multiple times.

```go
	task, err := container.NewTask(ctx, cio.NewCreator(cio.WithStdio))
	if err != nil {
		return err
	}
	defer task.Delete(ctx)
```

The new task that we just created is actually a running process on your system.
We use `cio.WithStdio` so that all IO from the container is sent to our `main.go` process.
This is a `cio.Opt` that configures the `Streams` used by `NewCreator` to return a `cio.IO`
for the new task.

If you are familiar with the OCI runtime actions, the task is currently in the "created" state.
This means that the namespaces, root filesystem, and various container level settings have been initialized but the user defined process, in this example "redis-server", has not been started.
This gives users a chance to setup network interfaces or attach different tools to monitor the container.
containerd also takes this opportunity to monitor your container as well.
Waiting on things like the container's exit status and cgroup metrics are setup at this point.

If you are familiar with prometheus you can curl the containerd metrics endpoint (in the `config.toml` that we created) to see your container's metrics:

```bash
> curl 127.0.0.1:1338/v1/metrics
```

Pretty cool right?

## Task Wait and Start

Now that we have a task in the created state we need to make sure that we wait on the task to exit.
It is essential to wait for the task to finish so that we can close our example and cleanup the resources that we created.
You always want to make sure you `Wait` before calling `Start` on a task.
This makes sure that you do not encounter any races if the task has a simple program like `/bin/true` that exits promptly after calling start.

```go
	exitStatusC, err := task.Wait(ctx)
	if err != nil {
		return err
	}

	if err := task.Start(ctx); err != nil {
		return err
	}
```

Now we should see the `redis-server` logs in our terminal when we run the `main.go` file.

## Killing the task

Since we are running a long running server we will need to kill the task in order to exit out of our example.
To do this we will simply call `Kill` on the task after waiting a couple of seconds so we have a chance to see the redis-server logs.

```go
	time.Sleep(3 * time.Second)

	if err := task.Kill(ctx, syscall.SIGTERM); err != nil {
		return err
	}

	status := <-exitStatusC
	code, exitedAt, err := status.Result()
	if err != nil {
		return err
	}
	fmt.Printf("redis-server exited with status: %d\n", code)
```

We wait on our exit status channel that we setup to ensure the task has fully exited and we get the exit status.
If you have to reload containers or miss waiting on a task, `Delete` will also return the exit status when you finally delete the task.
We got you covered.

```go
status, err := task.Delete(ctx)
```

## Full Example

Here is the full example that we just put together.

```go
package main

import (
	"context"
	"fmt"
	"log"
	"syscall"
	"time"

	"github.com/containerd/containerd"
	"github.com/containerd/containerd/cio"
	"github.com/containerd/containerd/oci"
	"github.com/containerd/containerd/namespaces"
)

func main() {
	if err := redisExample(); err != nil {
		log.Fatal(err)
	}
}

func redisExample() error {
	// create a new client connected to the default socket path for containerd
	client, err := containerd.New("/run/containerd/containerd.sock")
	if err != nil {
		return err
	}
	defer client.Close()

	// create a new context with an "example" namespace
	ctx := namespaces.WithNamespace(context.Background(), "example")

	// pull the redis image from DockerHub
	image, err := client.Pull(ctx, "docker.io/library/redis:alpine", containerd.WithPullUnpack)
	if err != nil {
		return err
	}

	// create a container
	container, err := client.NewContainer(
		ctx,
		"redis-server",
		containerd.WithImage(image),
		containerd.WithNewSnapshot("redis-server-snapshot", image),
		containerd.WithNewSpec(oci.WithImageConfig(image)),
	)
	if err != nil {
		return err
	}
	defer container.Delete(ctx, containerd.WithSnapshotCleanup)

	// create a task from the container
	task, err := container.NewTask(ctx, cio.NewCreator(cio.WithStdio))
	if err != nil {
		return err
	}
	defer task.Delete(ctx)

	// make sure we wait before calling start
	exitStatusC, err := task.Wait(ctx)
	if err != nil {
		fmt.Println(err)
	}

	// call start on the task to execute the redis server
	if err := task.Start(ctx); err != nil {
		return err
	}

	// sleep for a lil bit to see the logs
	time.Sleep(3 * time.Second)

	// kill the process and get the exit status
	if err := task.Kill(ctx, syscall.SIGTERM); err != nil {
		return err
	}

	// wait for the process to fully exit and print out the exit status

	status := <-exitStatusC
	code, _, err := status.Result()
	if err != nil {
		return err
	}
	fmt.Printf("redis-server exited with status: %d\n", code)

	return nil
}
```

We can build this example and run it as follows to see our hard work come together.

```bash
> go build main.go
> sudo ./main

1:C 04 Aug 20:41:37.682 # oO0OoO0OoO0Oo Redis is starting oO0OoO0OoO0Oo
1:C 04 Aug 20:41:37.682 # Redis version=4.0.1, bits=64, commit=00000000, modified=0, pid=1, just started
1:C 04 Aug 20:41:37.682 # Warning: no config file specified, using the default config. In order to specify a config file use redis-server /path/to/redis.conf
1:M 04 Aug 20:41:37.682 # You requested maxclients of 10000 requiring at least 10032 max file descriptors.
1:M 04 Aug 20:41:37.682 # Server can't set maximum open files to 10032 because of OS error: Operation not permitted.
1:M 04 Aug 20:41:37.682 # Current maximum open files is 1024. maxclients has been reduced to 992 to compensate for low ulimit. If you need higher maxclients increase 'ulimit -n'.
1:M 04 Aug 20:41:37.683 * Running mode=standalone, port=6379.
1:M 04 Aug 20:41:37.683 # WARNING: The TCP backlog setting of 511 cannot be enforced because /proc/sys/net/core/somaxconn is set to the lower value of 128.
1:M 04 Aug 20:41:37.684 # Server initialized
1:M 04 Aug 20:41:37.684 # WARNING overcommit_memory is set to 0! Background save may fail under low memory condition. To fix this issue add 'vm.overcommit_memory = 1' to /etc/sysctl.conf and then reboot or run the command 'sysctl vm.overcommit_memory=1' for this to take effect.
1:M 04 Aug 20:41:37.684 # WARNING you have Transparent Huge Pages (THP) support enabled in your kernel. This will create latency and memory usage issues with Redis. To fix this issue run the command 'echo never > /sys/kernel/mm/transparent_hugepage/enabled' as root, and add it to your /etc/rc.local in order to retain the setting after a reboot. Redis must be restarted after THP is disabled.
1:M 04 Aug 20:41:37.684 * Ready to accept connections
1:signal-handler (1501879300) Received SIGTERM scheduling shutdown...
1:M 04 Aug 20:41:40.791 # User requested shutdown...
1:M 04 Aug 20:41:40.791 * Saving the final RDB snapshot before exiting.
1:M 04 Aug 20:41:40.794 * DB saved on disk
1:M 04 Aug 20:41:40.794 # Redis is now ready to exit, bye bye...
redis-server exited with status: 0
```

In the end, we really did not write that much code when you use the client package.

I hope this guide helped to get you up and running with containerd.
Feel free to join the [slack channel](https://dockr.ly/community) if you have any questions and like all things, if you want to help contribute to containerd or this guide, submit a pull request.
