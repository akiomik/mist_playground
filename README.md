# mist_playground

## Envionments

- PC: Apple MacBookPro 2021 M1 Max (aarch64)
- `gleam`: 0.32.2
- `golang`: 1.21.3
- `xk6-nostr`: 0.1.0

## Run websocket server

```sh
gleam run
```

## Run benchmark

Using [k6](https://k6.io) by grafana and [xk6-nostr](https://github.com/akiomik/xk6-nostr).

1. Install `xk6`

See https://github.com/grafana/xk6/#local-installation

```bash
go install go.k6.io/xk6/cmd/xk6@latest
```

2. Build k6 with extension

```bash
xk6 build --with github.com/akiomik/xk6-nostr@latest
```

3. Run benchmark script

In my environment, the error occurs around 350,000 completes and 30 seconds elapsed.

```bash
# Run benchmark with 5 virtual users for 1 miniute
./k6 run --vus 5 --duration 1m bench/benchmark.js
```
