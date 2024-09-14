#!/usr/bin/env node

const fs = require('fs')
const path = require('path')

const totalNumOfArguments = process.argv.length

if (totalNumOfArguments === 2) {
	console.error("Source and Destination needed.")
	process.exit(1)
}

if (totalNumOfArguments === 3) {
	console.error("Destination needed.")
	process.exit(1)
}

//? Source and destination given
if (totalNumOfArguments === 4) {
	//? Absolute path of source and destination
	const source = path.resolve(process.argv[2])
	const destination = path.resolve(process.argv[3])

	const isSourceExist = fs.existsSync(source)
	const isDestinationExist = fs.existsSync(destination)

	if (!isSourceExist) {
		console.error("Source not exist.")
		process.exit(1)
	}

	if (!isDestinationExist) {
		fs.renameSync(source, destination)
		process.exit(0)
	}

	const sourceStat = fs.statSync(source)
	const destinationStat = fs.statSync(destination)

	if (sourceStat.isFile() && destinationStat.isFile()) {
		let destinationNewName
		let index = 1

		const extname = path.extname(destination)
		let basename = path.basename(destination, extname)
		const destinationDirname = path.dirname(destination)
		const lists = fs.readdirSync(destinationDirname)

		//? Generating new name for destination
		do {
			destinationNewName = `${basename}_${index}${extname}`
			index++
		} while (lists.indexOf(destinationNewName) !== -1)

		const destinationPath = path.join(destinationDirname, destinationNewName)

		fs.renameSync(source, destinationPath)
	} else if (sourceStat.isFile() && destinationStat.isDirectory()) {
		const basename = path.basename(source)
		const lists = fs.readdirSync(destination)

		const isSourceExistInDestination = lists.indexOf(basename) !== -1

		if (isSourceExistInDestination) {
			let destinationNewName
			let index = 1
			const extname = path.extname(basename)
			let fileNameWithoutExtension = path.basename(basename, extname)

			//? Generating new name for destination
			do {
				destinationNewName = `${fileNameWithoutExtension}_${index}${extname}`
				index++
			} while (lists.indexOf(destinationNewName) !== -1)

			const destinationPath = path.join(destination, destinationNewName)

			fs.renameSync(source, destinationPath)
		} else {
			const basename = path.basename(source)
			const destinationPath = path.join(destination, basename)

			fs.renameSync(source, destinationPath)
		}

	} else if (sourceStat.isDirectory() && destinationStat.isDirectory()) {
		const sourceBasename = path.basename(source)
		const destinationDirectoryLists = fs.readdirSync(destination).filter(f => f === sourceBasename)

		//? Select directories.
		const destinationLists = fs.readdirSync(destination).filter(f => !/\.\w+$/.test(f))

		if (destinationDirectoryLists.length) {
			const singleDirectory = destinationDirectoryLists[0]
			let destinationNewName
			let index = 1

			//? Generating new name for destination
			do {
				destinationNewName = `${singleDirectory}_${index}`
				index++
			} while (destinationLists.indexOf(destinationNewName) !== -1)

			const destinationPath = path.join(destination, destinationNewName)
			fs.renameSync(source, destinationPath)
		} else {
			const basename = path.basename(source)
			const destinationPath = path.join(destination, basename)

			fs.renameSync(source, destinationPath)
		}
	}
}

if (totalNumOfArguments > 4) {
	let destination = process.argv[totalNumOfArguments - 1]
	destination = path.resolve(destination)

	if (!fs.existsSync(destination)) {
		console.error('Destination not exists.')
		process.exit(1)
	}

	const destinationStat = fs.statSync(destination)

	if (destinationStat.isDirectory()) {
		const destinationLists = fs.readdirSync(destination)
		const sources = process.argv.slice(2, totalNumOfArguments - 1)

		for (let i = 0; i < sources.length; i++) {
			const singleFile = path.basename(sources[i])
			const directoryPath = path.dirname(sources[i])

			if (destinationLists.includes(singleFile)) {
				let destinationNewName
				let index = 1
				const extname = path.extname(singleFile)
				let basename = path.basename(singleFile, extname)

				//? Generating new name for destination
				do {
					destinationNewName = `${basename}_${index}${extname}`
					index++
				} while (destinationLists.indexOf(destinationNewName) !== -1)

				fs.renameSync(`${directoryPath}/${singleFile}`, destination + '/' + destinationNewName)
			} else {
				fs.renameSync(`${directoryPath}/${singleFile}`, `${destination}/${singleFile}`)
			}
		}
	} else {
		console.error(`${destination} should be directory!`)
		process.exit(1)
	}
}
