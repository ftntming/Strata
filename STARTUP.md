# Starting the installed models

This is a reference for the four local Linux launch scripts in this checkout.
They use models and packs that are already installed. They do not download or
prepare a model. The settings below describe the saved configurations when this
page was written; editing a configuration changes what its script starts.

## Quick start

From the repository folder, run one script:

```sh
./run-iq3_s.sh
./run-unsloth-ud-iq4_xs.sh
./run-unsloth-ud-q6_k_xl.sh
./run-orca-q4_k_s.sh
```

These are alternatives. Run only one at a time: all four use port **8080** and
the same GPU. Each starts the Python server in the foreground and asks it to
open the chat page in your browser. Leave the terminal open while using it.

- Chat page: <http://127.0.0.1:8080/>
- OpenAI-compatible API base: <http://127.0.0.1:8080/v1>
- Anthropic-compatible messages endpoint: <http://127.0.0.1:8080/v1/messages>
- Stop a foreground server: press **Ctrl+C** in its terminal and wait for it to exit.

## Compare the launchers

The sizes are the sum of the installed GGUF shard files, in decimal GB. They
exclude packs and other supporting files. They are not GPU memory requirements.
No speed or quality comparison is implied by this table.

| Script | Model variant | Installed shards | Context limit | Images | Saved access settings |
| --- | --- | --- | --- | --- | --- |
| `run-iq3_s.sh` | Qwen3.8-Flash-Next GSQ-RCO IQ3_S | 2 files, 83.6 GB | 262,144 tokens (256K) | Enabled | This PC only; no API key |
| `run-unsloth-ud-iq4_xs.sh` | Unsloth UD-IQ4_XS | 3 files, 93.7 GB | 262,144 tokens (256K) | Enabled | LAN access; API key required |
| `run-unsloth-ud-q6_k_xl.sh` | Unsloth UD-Q6_K_XL | 6 files, 169.2 GB | 262,144 tokens (256K) | Enabled | This PC only; no API key |
| `run-orca-q4_k_s.sh` | OrcaRouter Uncensored Q4_K_S | 3 files, 111.8 GB | 32,768 tokens (32K) | Disabled | LAN access; API key required |

Context is the space available for the prompt, conversation history and reply.
Longer conversations use more memory. An image-enabled configuration has a
vision encoder configured; the Q4_K_S configuration starts text-only.

## What each script starts

### IQ3_S

```sh
./run-iq3_s.sh
```

Loads `strata-iq3_s.json` from the repository folder. Its API model ID is
`qwen3.8-flash-next-iq3_s`.

The model files are in `~/Strata-data/models/IQ3_S/`, and its pack is in
`~/Strata-data/packs/iq3_s/`. The saved configuration uses INT8 conversation
memory, keeps the PLE lookup table in RAM and reserves 700 MiB of VRAM when
sizing the expert cache.

### Unsloth UD-IQ4_XS

```sh
./run-unsloth-ud-iq4_xs.sh
```

Loads `strata-unsloth-ud-iq4_xs.json` from the repository folder. Its API model
ID is `qwen3.8-flash-next-unsloth-ud-iq4_xs`.

The model files are in `~/Strata-data/models/unsloth-UD-IQ4_XS/`, and its pack is
in `~/Strata-data/packs/unsloth-ud-iq4_xs/`. Like IQ3_S, this configuration uses
INT8 conversation memory, keeps the PLE table in RAM and reserves 700 MiB of
VRAM. It listens on all network interfaces (`0.0.0.0`) and requires the API key
saved in its configuration. Use this PC's LAN address to connect from another device.

### Unsloth UD-Q6_K_XL

```sh
./run-unsloth-ud-q6_k_xl.sh
```

Loads `strata-unsloth-ud-q6_k_xl.json` from the repository folder. Its API model
ID is `qwen3.8-flash-next-unsloth-ud-q6_k_xl`.

The model files are in `~/Strata-data/models/unsloth-UD-Q6_K_XL/`, and its pack
is in `~/Strata-data/packs/unsloth-ud-q6_k_xl/`. This is the largest of these
four installed models. The saved configuration uses INT8 conversation memory
and reserves 700 MiB of VRAM. It does not set `--ple-io`, so the engine chooses
its default PLE storage mode. Its localhost-only configuration needs no API key.

### OrcaRouter Uncensored Q4_K_S

```sh
./run-orca-q4_k_s.sh
```

Loads `~/Strata-data/configs/strata-orca-q4_k_s.json`. Its API model ID is
`orcarouter-qwen3.8-flash-next-uncensored-q4_k_s`.

The three original model shards are in `~/Strata-data/models/orca-Q4_K_S/`.
The compatibility pack is in `~/Strata-data/packs/orca-q4_k_s/`. Keep the shards:
the pack reads their expert weights and PLE table in place.

This configuration uses INT8 conversation memory, maps the PLE table from disk
(`--ple-io mmap`) and reserves 1,024 MiB of VRAM when sizing the expert cache.
It starts with 32K context and no vision encoder. It listens on all network
interfaces and requires the saved API key. The setup procedure is documented in
[the Q4_K_S guide](docs/ORCA_Q4_K_S.md).

## Switching between models

1. Stop the current server and wait for it to release the GPU and port 8080.
2. Run the script for the model you want.
3. Wait for the server to print `ready`, then open the chat page or connect your app.

If Q4_K_S was started as the managed `orca-q4-k-s` profile, stop it with:

```sh
strata runtime stop --profile orca-q4-k-s
```

You can start that same profile in the background instead of using its script:

```sh
strata runtime start --profile orca-q4-k-s
strata runtime status --profile orca-q4-k-s
```

The managed server keeps running after its terminal closes. Do not start the
foreground script while that background server is running.

## Configuration and troubleshooting

- **Port 8080 is already in use:** stop the existing server first. Opening a new
  terminal does not stop a managed background server.
- **Authentication required:** use the API key from the selected configuration.
  API clients send it as `Authorization: Bearer YOUR_API_KEY`. The keys are not
  included in this document.
- **Missing model or pack:** check that the `~/Strata-data` drive is mounted and
  the paths in the selected configuration still exist.
- **Wrong model shown in an app:** reconnect after switching and update the
  app's model ID to the one listed above.
- **Scripts on another PC:** these launchers contain absolute paths for this
  installation. Adjust their repository, Python and configuration paths before
  using them elsewhere. `~` in this document means your home directory.

The four `run-*.sh` launchers and local configuration files are ignored by Git.
This page documents them, but cloning the repository does not recreate them or
install their models. Keep local API keys and model downloads out of commits.
