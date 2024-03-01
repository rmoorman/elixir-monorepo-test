# Example repository for demonstrating dep switching based on env for libraries

This repository contains code that demonstrates how one could handle library
dependencies based on an environment variable during library development.

The idea is, that during development of the library, mix is instructed to use
a local path rather than the dependency from `hex`, which is useful in order
to develop the library locally in isolation.

## What it comes down to

Within the package you want to switch a dependency based on env, make something
like this appear in the `mix.exs` file:

```elixir
    defp deps() do
        [
            my_dep(), # <- call to a helper function that resolves the dep spec
        ]
    end

    # Helper function that will resolve the dep spec for `my_dep` based on
    # a preferrably uniquely named environment variable
    defp my_dep() do
        case System.get_env("UNIQUELY_NAMED_ENV_VAR_FOR_DEV_PURPOSES") do
            "LOCAL" -> {:my_dep, path: "../my_dep"}
            _ -> {:my_dep, "~> 0.1"}
        end
    end
```

After that, just take care that you only set that env var only when you need to
actually develop on the package itself. In order to simplify managing that
environment variable throughout development, you could opt for using
[`direnv`](https://direnv.net/) and add a `.envrc` like that:

```shell
export UNIQUELY_NAMED_ENV_VAR_FOR_DEV_PURPOSES=LOCAL
```

When `direnv` is set up correctly, and you allowed it to use the directory, you
might end up with the env var being correctly set whenever you enter the
package's directory for local development.

## What can be found in this repo then?

There are three packages that were generated using `mix new [package name]` with
minimal adjustments:

* `package/foo`: core `foo`; would have common modules used by `foo_ecto`
* `package/foo_ecto`: a companion package to `foo`; it depends on `foo` and is
  the package that library users (in our example here) would install to use
  `foo` integrated with `ecto`
* `my_app`: example package that requires `foo_ecto`

The dependency switching logic can be found in `package/foo_ecto/mix.exs`.

The env variable we switch based on is `FOO_DEV_DEP` which seems specific
enough for the example to not lead to collisions in our case.

There is also a `package/foo_ecto/.envrc` that sets the correct env var through
`direnv` when entering the directory (with the option of setting an override
using a local `.env`)

## Some examples out in the wild

Oftentimes, a characteristic of a useful pattern is that it can be found
elsewhere in one way or the other. See a few examples below:

* [wojtekmach mentioned the pattern on the forum](https://elixirforum.com/t/hex-is-there-a-way-to-use-a-completely-local-dependency-in-a-elixir-project/37107/7)

* [`ecto_sql` uses it to explicitly set dep path based on env](https://github.com/elixir-ecto/ecto_sql/blob/master/mix.exs#L75)

* [various `ex_aws` packages use it to use a predefined local path](https://github.com/ex-aws/ex_aws_s3/blob/main/mix.exs#L57)
