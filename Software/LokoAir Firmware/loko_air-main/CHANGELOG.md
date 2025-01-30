## Unreleased

### Feat

- **tx-power**: set tx power
- **format**: new binary format
- **set-mode, response**: add wait for response
- **gnss-mode**: add settings and cli for it
- **extended-packet**: add settings and cli for it
- **debug-output**: add possibility to enable or disable debug output

### Fix

- **gnss-enable**: add workaround to reduce deep voltage drop
- **adc**: increase adc measurement time
- **log**: remove misunderstanding in log data
- **python, parser**: fix string type checking
- **power-on**: fix power on
- **info, gnss-mode**: add gnss mode info
- **power-on**: add small delay to fix debounce
- **button**: power on by button
- **debug-mode**: do not disable gnss in debug mode
- **debug-output**: keep gnss enabled when debug output enabled
- **debug-log**: debug log timeout
- **power-on, log-debug**: lunch button refactor and debug output

### Refactor

- **adc, battery**: use filter for adc measurements
- **clean-style**: clean code style
- **stack**: increase stack size
- **cleanup**: clean code style
- **gnss.valid**: use gnss valid flag
- **power-on**: change power on approach
