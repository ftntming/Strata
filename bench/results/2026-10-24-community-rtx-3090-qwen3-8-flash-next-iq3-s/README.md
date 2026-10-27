# Community benchmark on NVIDIA GeForce RTX 3090

Measured on 2026-10-24 with `tools/strata_bench.py` (suite 1, 3 runs per test, medians with ranges). Speeds are the engine's own timings; first-token times are measured by the client over HTTP. Speed only: no correctness check was run.

## Hardware and software

- GPU and VRAM: NVIDIA GeForce RTX 3090, 24 GiB VRAM
- CPU: 13th Gen Intel(R) Core(TM) i9-13900K (24 cores, 32 threads); installed RAM: 61.5 GiB; storage: not measured
- OS: Linux 7.0.0-38-generic; GPU driver: 595.99.02; CUDA: 13.2
- Strata: project 0.1.49.1, commit 8183c6b6; engine 0.1.48
- Background workloads and power limits: not recorded

## Model and configuration

- Model and quantization: qwen3.8-flash-next-iq3_s
- Context: 131072 tokens; parallel slots: 1
- Settings: the install's own configuration, unchanged; thinking off for the suite; temperature 0

```text
strata --pack iq3_s --native Qwen3.8-Flash-Next-GSQ-RCO-IQ3_S-00001-of-00002.gguf --ple-gguf Qwen3.8-Flash-Next-GSQ-RCO-IQ3_S-00002-of-00002.gguf --expert-profile expert-profile.bin --expert-cache auto --prefill auto --spec 4 --mtp rt --max-context 131072 --kv int8 --vision --vram-reserve-mib 700 --pcie-frac 0.00 --spec-min-p 0.70 --adapt-every 1 --adapt-swaps 160 --adapt-decay 0.97
```

## Method

Run by `python tools/strata_bench.py` against the HTTP API of a Strata server (started by the benchmark from the install configuration); model loading is not timed. One warm-up chat and a 1K prompt are discarded first. Every prompt starts with a unique tag, so the conversation cache cannot help the fresh-prompt tests.

- short chat: the three questions of `tools/ab_engine.py`, up to 100 new tokens, 3 runs
- 4K / 16K prompts: generated word lists sized by a calibration request, 24 new tokens, 3 fresh prompts each
- agent session: system prompt and four tools, then 5 turns that each add about 1500 words of a project file and continue from the model's own earlier answers (the way agent clients resend a conversation), 64 new tokens per turn, 3 sessions; the cache numbers come from the answer's usage (`cached_tokens`) and timings (`prompt_n`)
- concurrency (when run): N requests sent at the same moment, total tokens over the wall time of the burst, latency over all requests

## Results

| Configuration | Actual prompt tokens | Reused tokens | Generated tokens | Runs | Prompt tok/s median and range | Decode tok/s median and range | TTFT seconds median and range |
| --- | ---: | ---: | ---: | ---: | --- | --- | --- |
| short chat | 46 (43-51) | 0 | 100 (100-100) | 9 | not measured | 114.1 (101.7-140.1) | 0.27 (0.25-0.32) |
| 4K prompt, fresh | 4019 (4019-4019) | 0 (0-0) | 24 cap | 3 | 1148.4 (1147.4-1153.8) | not measured | 3.52 (3.50-3.52) |
| 16K prompt, fresh | 16058 (16058-16058) | 0 (0-0) | 24 cap | 3 | 2226.1 (2221.6-2236.5) | not measured | 7.24 (7.20-7.25) |
| agent session, follow-up turns | 14569 (14535-14581) at the last turn | see below | up to 64 | 3 | see below | 126.1 (100.2-157.4) | 3.44 (3.29-3.63) |

Ranges are the lowest and highest of the runs; `Runs` counts requests that returned a token.

### Agent session (conversation cache)

Cache hit over the follow-up turns: 69.6 % (69.6-69.6); earlier-turn tokens read again per session: 4 (3-4) (earlier turns that the cache did not hold; the 13729 (13729-13729) new tokens of the files are read once); first turn (nothing cached) first token: 1.35 s (1.33-1.37).

| Turn (run 1) | Prompt tokens | Reused | Read | Prompt tok/s | First token (s) | Decode tok/s |
| ---: | ---: | ---: | ---: | ---: | ---: | ---: |
| 0 | 609 | 0 | 609 | 456.9 | 1.349 | 91.1 |
| 1 | 4091 | 623 | 3468 | 961.1 | 3.631 | 100.2 |
| 2 | 5624 | 4155 | 1469 | 443.5 | 3.33 | 137.0 |
| 3 | 9057 | 5687 | 3370 | 947.6 | 3.576 | 109.8 |
| 4 | 11796 | 9088 | 2708 | 781.9 | 3.483 | 126.1 |
| 5 | 14535 | 11818 | 2717 | 793.3 | 3.444 | 104.3 |

Per-request data: `results.json`. Engine log lines from the start: `engine-log-excerpt.txt` (when this run started the server).

## Correctness and limitations

Not measured: this is a speed suite. The conversation uses the model's own replies, so token counts differ a little between runs. Machine details come from the server, `nvidia-smi`/`rocm-smi` and the OS; background load and power limits are not recorded. Total time of the suite: 109 s.
