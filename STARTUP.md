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
- OpenAI-compatible API base on this PC: <http://127.0.0.1:8080/v1>
- LAN chat page: <http://192.168.2.202:8080/>
- LAN API base: <http://192.168.2.202:8080/v1>
- Anthropic-compatible messages endpoint: <http://127.0.0.1:8080/v1/messages>
- Stop a foreground server: press **Ctrl+C** in its terminal and wait for it to exit.

## Compare the launchers

The sizes are the sum of the installed GGUF shard files, in decimal GB. They
exclude packs and other supporting files. They are not GPU memory requirements.
No speed or quality comparison is implied by this table.

| Script | Model variant | Installed shards | Context limit | Images | Saved access settings |
| --- | --- | --- | --- | --- | --- |
| `run-iq3_s.sh` | Qwen3.8-Flash-Next GSQ-RCO IQ3_S | 2 files, 83.6 GB | 262,144 tokens (256K) | Enabled | LAN access; shared API key required |
| `run-unsloth-ud-iq4_xs.sh` | Unsloth UD-IQ4_XS | 3 files, 93.7 GB | 262,144 tokens (256K) | Enabled | LAN access; shared API key required |
| `run-unsloth-ud-q6_k_xl.sh` | Unsloth UD-Q6_K_XL | 6 files, 169.2 GB | 262,144 tokens (256K) | Enabled | LAN access; shared API key required |
| `run-orca-q4_k_s.sh` | OrcaRouter Uncensored Q4_K_S | 3 files, 111.8 GB | 262,144 tokens (256K) | Enabled | LAN access; shared API key required |

Context is the space available for the prompt, conversation history and reply.
Longer conversations use more memory. All four saved configurations now have
a vision encoder enabled.

## Q4_K_S versus UD-IQ4_XS

The launcher named `run-unsloth-ud-iq4_xs.sh` uses **UD-IQ4_XS**, sometimes
shortened in conversation to "Q4_XS". Its full name matters: it is a different
quantization format from Q4_K_S. Both compress model weights to roughly four
bits per weight, with scales and some weights kept at other precisions.

| Difference | Installed OrcaRouter Q4_K_S | Installed Unsloth UD-IQ4_XS |
| --- | --- | --- |
| Model source | OrcaRouter's Uncensored variant | Unsloth's quantization of Qwen3.8-Flash-Next |
| Compression format | Q4_K is a block-based K-quant format; S identifies the small preset | IQ4_XS uses a nonlinear i-quant encoding; XS identifies the extra-small preset; UD identifies Unsloth Dynamic quantization |
| Installed model files | 111.8 GB | 93.7 GB |
| Current server context | 256K | 256K |
| Current image support | Uncensored model's vision projector enabled | Vision encoder enabled |
| Current PLE storage | Kept in RAM (`ram`) | Kept in RAM (`ram`) |

The S and XS labels describe presets within their respective format families.
They are not a common quality scale. The installed Q4_K_S download is 18.1 GB
larger, but that alone does not establish better answers. These two downloads
also contain different model variants, so a comparison would mix the effects
of model changes and compression.

"Uncensored" describes the OrcaRouter model variant, not the Q4_K_S format.
It does not mean that every Q4_K_S model is uncensored, or that an IQ4_XS model
cannot use an uncensored variant.

Both saved server configurations now use 256K context. Q4_K_S was first set up
at 32K following the manual guide, then raised to 256K for this PC. Context is
a server setting, not a limit imposed by either quantization name. Keep the
server configuration and the corresponding OpenCode entry in agreement.

OpenCode's Q4_K_S entry allows 4,096 output tokens and 258,048 input tokens
within its 262,144-token context budget, matching UD-IQ4_XS. The output allowance
is a client setting, not a measured maximum for this model. Weight precision,
conversation-memory precision (`--kv int8` here), context length and output
limits are separate settings.

No matched speed or answer-quality benchmark of these two installed models has
been run for this comparison. Use the smaller UD-IQ4_XS files when disk footprint
is the deciding factor; use the installed OrcaRouter model when you specifically
want that Uncensored variant. Consult the [llama.cpp quantizer definitions](https://github.com/ggml-org/llama.cpp/blob/master/tools/quantize/quantize.cpp),
the [Unsloth model files](https://huggingface.co/unsloth/Qwen3.8-Flash-Next-GGUF/tree/main/UD-IQ4_XS),
and the [OrcaRouter model files](https://huggingface.co/orcarouter/Qwen3.8-Flash-Next-Uncensored-GGUF/tree/main)
for the format names and download sources.

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
sizing the expert cache. It listens on all network interfaces and requires the
shared API key.

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
its default PLE storage mode. It listens on all network interfaces and requires
the shared API key.

### OrcaRouter Uncensored Q4_K_S

```sh
./run-orca-q4_k_s.sh
```

Loads `~/Strata-data/configs/strata-orca-q4_k_s.json`. Its API model ID is
`orcarouter-qwen3.8-flash-next-uncensored-q4_k_s`.

The three original model shards are in `~/Strata-data/models/orca-Q4_K_S/`.
The compatibility pack is in `~/Strata-data/packs/orca-q4_k_s/`. Keep the shards:
the pack reads their expert weights and PLE table in place.

This configuration uses INT8 conversation memory, keeps the PLE table in RAM
(`--ple-io ram`) and reserves 1,024 MiB of VRAM when sizing the expert cache.
It uses 256K context, automatic prefill and a 32K resident KV window, matching
the UD-IQ4_XS setup except for the larger VRAM reserve. The resident window is
not the full context limit; Strata manages the remaining conversation memory
outside that GPU-resident window.

Images use the Uncensored model's own
`mmproj-Qwen3.8-Flash-Next-Uncensored-F16.gguf`, stored beside its model shards.
The vision encoder runs on the GPU and allows up to 1,024 image tokens. The
server listens on all network interfaces and requires the saved API key. The
original manual setup is documented in [the Q4_K_S guide](docs/ORCA_Q4_K_S.md).

### Validation and RAM locking

On this PC (RTX 3090 with 24 GiB VRAM and 152 GiB system RAM), the installed
0.1.50 CUDA engine started Q4_K_S with 262,144-token context and image support.
A short arithmetic request and a 40,038-token synthetic prompt both returned
the expected answer. A near-limit synthetic prompt of 250,044 tokens also
returned the expected arithmetic answer, completing in 129.27 seconds. The
vision encoder identified a generated red image.
These are startup and capacity checks, not a long-document accuracy benchmark.

The engine reported that locking the PLE table failed under this Linux account's
memory-lock limit. It loaded the table's pages into RAM, but Linux may reclaim
them under memory pressure. `--ple-io ram` is configured; permanent RAM residency
is not guaranteed on this account. No system memory-lock limits were changed.

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

- **`ECONNREFUSED` during startup:** wait for the server to print `ready`. The
  API may not listen on port 8080 until the model has loaded.
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

All four launchers explicitly bind to `0.0.0.0`, and their saved configurations
require the same API key. OpenCode uses `http://192.168.2.202:8080/v1` for this
PC. Its main and small-model defaults both select
`strata/orcarouter-qwen3.8-flash-next-uncensored-q4_k_s`, matching the active
server. Change these selections when serving a different model. Its `apiKey` is a file reference,
`{file:~/.config/opencode/strata-api-key}`, using
[OpenCode's file substitution](https://docs.opencode.ai/docs/config/#files).
The private key file is outside the repository and readable only by its owner.
If you copy OpenCode's configuration to another computer, create that key file
there too, using the shared key.

OpenCode also has a `macstudio/iq3_s` model at
`http://192.168.2.10:47832/v1`, using the same key-file reference. Its client
entry requests 524,288-token context and up to 32,768 output tokens, as supplied
for that machine. Those limits depend on the Mac Studio server's configuration. The connection
check from this PC returned `No route to host`; remote availability and model
limits have not been verified.

The four `run-*.sh` launchers and local configuration files are ignored by Git.
This page documents them, but cloning the repository does not recreate them or
install their models. Keep local API keys and model downloads out of commits.
