-- Ruff settings
return {
  settings = {
    -- Any extra CLI arguments for ruff go here
    args = {
      "--config=~/.config/ruff/ruff.toml",
    },
  },
  on_attach = function(client)
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
}
