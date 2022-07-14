#!/bin/node

const fs = require('fs')
const path = require('path')

// console.log(process.argv[2])
// console.log(process.argv.length)
const totalNumOfArguments = process.argv.length

if (totalNumOfArguments === 2) {
	// throw new Error("Arguments needed.")
	console.error("Source and Destination needed.")
	process.exit(1)
}

if (totalNumOfArguments === 3) {
	console.error("Destination needed.")
	process.exit(1)
}

// console.log(totalNumOfArguments)

//? Source and destination given
if (totalNumOfArguments === 4) {
	const source = process.argv[2]
	const destination = process.argv[3]

	const isSourceExist = fs.existsSync(source)
	const isDestinationExist = fs.existsSync(destination)

	if (!isSourceExist) {
		console.error("Source not exist.")
		process.exit(1)
	}

	if (!isDestinationExist) {
		console.error("Destination not exist")
		fs.renameSync(source, destination)
		process.exit(1)
	}

	const sourceStat = fs.statSync(source)
	const destinationStat = fs.statSync(destination)

	//? Source and Destination are files
	if (sourceStat.isFile() && destinationStat.isFile()) {
		let destinationNewName
		let index = 1
		const extname = path.extname(destination)
		let basename = path.basename(destination, extname)

		let destinationDirectory = path.resolve(__dirname, destination)
		destinationDirectory = path.dirname(destinationDirectory)

		const lists = fs.readdirSync(destinationDirectory)

		//? Generating new name for destination
		do {
			destinationNewName = `${basename}_${index}${extname}`
			index++
		} while (lists.indexOf(destinationNewName) !== -1)

		fs.renameSync(source, destinationNewName)
	} else if (sourceStat.isFile() && destinationStat.isDirectory()) {
		const lists = fs.readdirSync(destination)
		const isSourceExistInDestination = lists.indexOf(source) !== -1

		if (isSourceExistInDestination) {
			let destinationNewName
			let index = 1
			const extname = path.extname(source)
			let basename = path.basename(source, extname)

			//? Generating new name for destination
			do {
				destinationNewName = `${basename}_${index}${extname}`
				index++
			} while (lists.indexOf(destinationNewName) !== -1)

			fs.renameSync(source, destination + '/' + destinationNewName)
		} else {
			fs.renameSync(source, destination + '/' + source)
		}
	}
}