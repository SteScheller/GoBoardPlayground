yosys -p "synth_ice40 -top Switches_To_LEDs -json out/switch_led.json" switch_led.v
nextpnr-ice40 --hx1k --pcf constraints.pcf --package vq100 --asc out/switch_led.asc --json out/switch_led.json
icepack out/switch_led.asc out/switch_led.bin
iceprog out/switch_led.bin
