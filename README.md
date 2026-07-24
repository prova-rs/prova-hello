# prova-hello

A plugin for [Prova](https://github.com/prova-rs/prova) — Hello — the registry lifecycle demo plugin (create → release → registered → removed).

In Prova a **package** is one `prova.toml`-rooted unit; it can act as a **plugin** (exports a
namespace) and a **suite** (runs its own proofs). This repo is such a package — author the plugin in
`init.lua`, prove it in `proofs/`, ship both.

## Use it


Declare it in your project's `prova.toml`, pinned to a released tag:

```toml
[plugins]
hello = { git = "https://github.com/prova-rs/prova-hello", tag = "v1" }
```

Then `require` it in a test:


```lua
local hello = require("hello")

prova.test("does the thing", function(t)
  t:expect(hello.greet("world")):equals("hello, world")
end)
```

## What to build

The generated `init.lua` returns a table whose fields are the API. Two common shapes it can grow into:

- **A resource** — an ephemeral container the suite talks to (`prova.containerized`, docker-exec, zero
  native code); a consumer does `require("hello").container(ctx)`.
- **A topology** — a whole environment `prova up` can stand up, advertised via `[[plugin.topologies]]`
  in `prova.toml` and gated on the tools it needs.

`init.lua` carries commented starting points for both.

## Develop

```bash
prova                        # run the self-test in proofs/ (hermetic by default)
prova plugin lint init.lua   # check the plugin conforms to the namespacing grammar
```


The **Test** workflow runs the self-test on every push; the **Release** workflow (dispatched
manually) tags the next version so consumers can pin `prova-rs/prova-hello@vX.Y.Z`.

MIT licensed.

