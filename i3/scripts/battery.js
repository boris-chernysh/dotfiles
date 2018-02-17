#!/usr/bin/env node

const { exec } = require('child_process')

const execComand = comand => new Promise((resolve, reject) => exec(comand, (err, stdout) => {
    if (err) {
        reject()

        return;
    }

    resolve(stdout)
}))

execComand('acpi -b')
    .then(stdout => {
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
            if (percent < 20) color = '#FF0000'
            else if (percent < 40) color = '#FFAE00'
            else if (percent < 60) color = '#FFF600'
            else if (percent < 85) color = '#A8FF00'
            else color = '#00FF00'
        }

        const pangoColor = color && ` color="${color}"`

        process.stdout.write(
            `<span${pangoColor}>${percent}%</span>` + (isCharging ? '⚡' : '')
        )

        if (percent < 10) process.exit(33)

        process.exit(0)
    })
    .catch(() => {
        console.log('error')
        process.exit(33)
    })
