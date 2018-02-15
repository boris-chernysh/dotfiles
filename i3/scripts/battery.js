#!/usr/bin/env node

const { exec } = require('child_process')

exec('acpi -b', (err, stdout, stderr) => {
    if (err) {
        console.log(`<span color="#FF0000">${stderr}</span>`)
        return
    }

    const [, batteryStatus] = stdout.split(': ')
    const [chargeState, percentString] = batteryStatus.split(', ')

    const percent = parseInt(percentString, 10)

    let color = '#00FF00'

    if (percent < 20) color = '#FF0000'
    else if (percent < 40) color = '#FFAE00'
    else if (percent < 60) color = '#FFF600'
    else if (percent < 85) color = '#A8FF00'

    const isCharging = chargeState === 'Charging'
    const pangoColor = isCharging ? '' : ` color="${color}"`

    console.log(
        `<span${pangoColor}>${percentString}</span>` +
        (isCharging ? '⚡' : '')
    )

    if (percent < 5) process.exit(33)

    process.exit(0)
})
