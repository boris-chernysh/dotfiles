#!/usr/bin/env node

const wallpaperFilename = process.argv[2]

const PICSUM_URL = 'https://picsum.photos'
const { promisify } = require('util')
const { spawn } = require('child_process')
const exec = promisify(require('child_process').exec)
const { request } = require('https')
const { createWriteStream } = require('fs')

Promise.resolve()
    .then(() => exec('xdpyinfo | grep dimensions'))
    .then(({ stdout }) => {
        const resolutionMatch = stdout.match(/\d+x\d+/)

        if (!resolutionMatch) throw new Error('Resolution not found!')

        return resolutionMatch[0]
            .split('x')
            .map(Number)
    })
    .then(([ width, heigth ]) => new Promise((resolve, reject) =>
        request(`${PICSUM_URL}/${width}/${heigth}?random`, (res) => {
            resolve(res.headers.location)
        }).on('error', reject).end()
    ))
    .then((pictureUrl) => new Promise(
        (resolve, reject) => request(pictureUrl, (res) => {
            const file = createWriteStream(wallpaperFilename)

            res.pipe(file)
            file.on('finish', () => resolve())
        }).on('error', reject).end()
    ))
    .then(() => {
        const fehProcess = spawn('feh', ['--bg-fill', wallpaperFilename])

        fehProcess.on('close', (code) => {
            if (code !== 0) {
                console.log('😡')
                process.exit(33)
            }

            console.log('🖼️')
            process.exit(0)
        })
    })
    .catch((err) => {
        console.log('😡')
        console.log(err.message)
        console.log(err.stack)
        process.exit(1)
    })
