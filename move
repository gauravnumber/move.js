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
// console.log(process.argv)

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

	// console.log(process.argv)
	// console.log(sourceStat.isDirectory())
	// process.exit(1)

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

	} else if (sourceStat.isDirectory() && destinationStat.isDirectory()) {
		// rename source directory
		// console.log('both are directory')
		const sourceDirectoryname = path.dirname(source)
		const sourceBasename = path.basename(source)

		const destinationDirectoryname = path.dirname(destination)
		const destinationBasename = path.basename(destination)

		// console.log(source, sourceBasename, sourceDirectoryname)
		// console.log(destination, destinationBasename, destinationDirectoryname)

		// const sourceDirectoryLists = fs.readdirSync(source)
		// const destinationDirectoryLists = fs.readdirSync(destination).filter(f => f.startsWith(sourceBasename))
		const destinationDirectoryLists = fs.readdirSync(destination).filter(f => f === sourceBasename)
		// const destinationLists = fs.readdirSync(destination).filter(f => !f.endsWith(".txt"))
		//? Select directories.
		const destinationLists = fs.readdirSync(destination).filter(f => !/\.\w+$/.test(f))
		console.log('destinationDirectoryLists', destinationDirectoryLists)
		console.log('destinationLists', destinationLists)
		// process.exit(1)

		if (destinationDirectoryLists.length) {
			// console.log('source file exists')
			// for (let i = 0; i < destinationLists.length; i++) {
			const singleDirectory = destinationDirectoryLists[0]
			let destinationNewName
			let index = 1
			console.log(sourceBasename)
			// const extname = path.extname(source)
			// let basename = path.basename(source, extname)

			//? Generating new name for destination
			do {
				destinationNewName = `${singleDirectory}_${index}`
				index++
			} while (destinationLists.indexOf(destinationNewName) !== -1)

			console.log('singleDirectory', singleDirectory)
			console.log(`destinationNewName`, destinationNewName)
			console.log('destination', destination)

			fs.renameSync(source, `${destination}/${destinationNewName}`)


			// }
		} else {
			console.log('source file not exists')
			// console.log(`${sourceDirectoryname}/${sourceBasename}`, `${destinationDirectoryname}/${destinationBasename}`)
			// console.log(source, destination)
			fs.renameSync(source, `${destination}/${source}`)
			// fs.renameSync(`${sourceDirectoryname}/${sourceBasename}`, `${destinationDirectoryname}/${destinationBasename}`)
		}

		// console.log(sourceDirectoryLists)
		// console.log(destinationDirectoryLists)

		// for (let i = 0; i < sourceDirectoryLists.length; i++) {
		// 	const singleFile = sourceDirectoryLists[i]

		// 	if (destinationDirectoryLists.includes(singleFile)) {
		// 		console.log('file exists')
		// 	} else {
		// 		console.log('file not exists')
		// 		// fs.renameSync(singleFile, `${destination}/${singleFile}`)
		// 	}
		// }

		// Intersection in array
		// console.log(sourceDirectoryLists.includes(destinationDirectoryLists))
	}
}

if (totalNumOfArguments > 4) {
	const destination = process.argv[totalNumOfArguments - 1]

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