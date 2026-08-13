# iasi-lua-docs

Documentation for the Lua extensions distributed by the IASI ecosystem.

Publications:

- `00-landing/` — multiproject landing page.
- `01-user-guide/` — installation, configuration, usage, and troubleshooting.
- `02-technical-guide/` — temporary technical-guide copy for multiproject testing.

`iasi.quarto::publish()` assembles every Quarto project into the repository-level
`publish/` directory. Numeric ordering prefixes are removed from public URLs,
so `01-user-guide/` is published at `user-guide/`. GitHub Pages deploys that
composed directory directly.
