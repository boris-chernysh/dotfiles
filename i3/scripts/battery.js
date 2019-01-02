#!/usr/bin/env node

const { promisify } = require('util')
const exec = promisify(require('child_process').exec)

exec('acpi -b')
    .then(({ stdout }) => {
        const [, batteryStatus] = stdout.split(': ')
        const [chargeState, percentString] = batteryStatus.split(', ')

        const percent = parseInt(percentString, 10)

        if (chargeState !== 'Unknown') {
            return {
                percent,
                isCharging: chargeState === 'Charging'
            }
        }

        return execComand('acpi -a')
            .then(stdout => ({
                percent,
                isCharging: /on-line/.test(stdout)
            }))
    })
    .then(({ percent, isCharging }) => {
        let color = ''

        if (!isCharging) {
            if (percent < 20) color = '#FFFFFF'
            else if (percent < 40) color = '#FFAE00'
        }

        const pangoColor = color && ` color="${color}"`

        process.stdout.write(
            `<span${pangoColor}>${percent}%</span>` + (isCharging ? '⚡' : '')
        )

        if (percent < 15) process.exit(33)

        process.exit(0)
    })
    .catch(() => {
        console.log('error')
        process.exit(33)
    })
