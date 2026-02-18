return {
  settings = {
    pyright = {
      -- Let Ruff handle organizing imports
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        -- "None" or "OpenedFilesOnly" avoids Pyright bloating memory
        -- on large projects. "Standard" is best for safety.
        typeCheckingMode = "standard",
        -- Tell Pyright to ignore these because Ruff handles them better/faster:
        diagnosticSeverityOverrides = {
          -- FORCE types for my code
          reportUnknownParameterType = "error",
          reportMissingParameterType = "error",

          -- For untyped libraries zzz
          reportArgumentType = "warning",

          -- Ignore untyped external libraries
          reportMissingTypeStubs = "none",
          reportUnknownMemberType = "none",

          reportUnusedImport = "none",
          reportUnusedVariable = "none",
          reportShadowedVariable = "none",
        },
      },
    },
  },
}
