use Mix.Config

import_config "config.secret.exs"
import_config "test.exs"

config :ecto, json_library: Jason
config :db, ecto_repos: [Db.Repo]
config :db, Db.Repo, migration_primary_key: [name: :id, type: :binary_id]

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :db, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:db, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env}.exs"
