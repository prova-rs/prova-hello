-- prova-hello — Hello — the registry lifecycle demo plugin (create → release → registered → removed).
--
-- A Prova plugin is just a module: `require("hello")` returns this table, and whatever you hang
-- on it is the plugin's API. That's the entire contract — everything below is a starting point to
-- replace.
--
--   local hello = require("hello")
--   hello.greet("world")            -- → "hello, world"
--
-- Two common shapes, when you're ready for them:
--
--   • A RESOURCE — an ephemeral container the suite talks to (docker-exec, zero native code):
--       local hello = prova.containerized{
--         name = "hello", image = "…", port = 1234,
--         url    = function(host_port) return "tcp://127.0.0.1:" .. host_port end,
--         client = function(url, opts, container) return make_client(container) end,
--       }
--     A consumer then does `require("hello").container(ctx)`.
--
--   • A TOPOLOGY — a whole environment `prova up` can stand up. Advertise it in prova.toml:
--       [[package.topologies]]
--       name     = "…"        # the public name a project references in [topologies]
--       factory  = "…"        # the field on THIS table it resolves to
--       requires = ["…"]      # tools/daemons it needs — gates `prova up` and any test that uses it
--     and export that factory as `function(ctx, opts) … end` returning the live environment.

local hello = {}

--- Replace me with the plugin's real API.
function hello.greet(who)
  return "hello, " .. tostring(who)
end

--- v1.1: the update-leg demo — a release that bumps `latest` in the registry.
function hello.shout(who)
  return hello.greet(who):upper()
end

return hello
