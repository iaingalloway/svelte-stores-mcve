# Svelte stores MCVE

An MCVE to illustrate issues with svelte stores and static values that are not known until runtime.

## How to edit

Develop it locally with a docker container:

```bash
docker run --rm -it -v $(pwd):/src -w /src --user $(id -u):$(id -g) -p 5000:5000 --name svelte-stores-mcve-dev --env-file .env.development --entrypoint bash node:lts-hydrogen
```

Run it locally inside the container:

```bash
npm install
npm run dev
```

Attach vscode to the running container using the Dev Containers extension. (ctrl-shift-p -> "Attach to Running Container...")

## How to reproduce

Build it locally using the dockerfile:

```bash
docker build -t svelte-stores-mcve:local .
```

And run it locally with:

```bash
docker run --rm -it -p 5001:5001 --env-file .env.runtime --name svelte-stores-mcve-local svelte-stores-mcve:local
```

Notice that the static message isn't set when the application is run using the docker image. This is because the empty placeholder value in .env is baked into the `$env/static/public` store at build time, and cannot be changed at runtime. If we don't want to ship this value with the container, we must either use `$env/dynamic/public` or we must defer our build to runtime.

Baking these values into the container is not ideal as it means building a different container image for each environment. [The documentation advises against using the dynamic store where possible.](https://kit.svelte.dev/docs/modules#$env-dynamic-public) Deferring the build until runtime is not ideal, because it means the container image is much larger, much more complicated, and has a much larger attack surface.

When we're developing with containers, it is quite common to have values that we don't know at build time (or do not want to ship with the container), but that we do know at startup time, and we know will never change over the lifetime of the application. It may be that this isn't a problem in practise, and that using the dynamic store for these kinds of values is an acceptable workaround. It may be that there is a better way, such as writing the values to a static file on application startup.
