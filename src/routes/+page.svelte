<script>
	import { PUBLIC_STATIC_MESSAGE } from '$env/static/public';
	import { env } from '$env/dynamic/public';
</script>

<h1>Svelte stores MCVE</h1>
<ul>
	<li>Static message: {PUBLIC_STATIC_MESSAGE}</li>
	<li>Dynamic message: {env.PUBLIC_DYNAMIC_MESSAGE}</li>
</ul>

<p>
	Notice that the static message isn't set when the application is run using the docker image. This
	is because the empty placeholder value in .env is baked into the
	<code>$env/static/public</code> store at build time, and cannot be changed at runtime. If we don't
	want to ship this value with the container, we must either use
	<code>$env/dynamic/public</code> or we must defer our build to runtime.
</p>

<p>
	Baking these values into the container is not ideal as it means building a different container
	image for each environment.

	<a href="https://kit.svelte.dev/docs/modules#$env-dynamic-public">
		The documentation advises against using the dynamic store where possible.
	</a>

	Deferring the build until runtime is not ideal, because it means the container image is much
	larger, much more complicated, and has a much larger attack surface.
</p>

<p>
	When we're developing with containers, it is quite common to have values that we don't know at
	build time (or do not want to ship with the container), but that we do know at startup time, and
	we know will never change over the lifetime of the application. It may be that this isn't a
	problem in practise, and that using the dynamic store for these kinds of values is an acceptable
	workaround. It may be that there is a better way, such as writing the values to a static file on
	application startup.
</p>
