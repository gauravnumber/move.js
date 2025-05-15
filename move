#!/usr/bin/env node

const fs = require("fs");
const path = require("path");

const args = process.argv.slice(2);

if (args.length < 2) {
  console.error(
    args.length === 0 ? "Source and Destination needed." : "Destination needed."
  );
  process.exit(1);
}

// Helper to generate a non-conflicting file/directory name
function getUniqueName(baseDir, originalName) {
  const ext = path.extname(originalName);
  const name = path.basename(originalName, ext);
  let index = 1;
  let newName = originalName;

  const existing = new Set(fs.readdirSync(baseDir));
  while (existing.has(newName)) {
    newName = `${name}_${index}${ext}`;
    index++;
  }

  return path.join(baseDir, newName);
}

// Rename or move a single file/directory
function moveItem(source, destination) {
  if (!fs.existsSync(source)) {
    console.error(`Source not found: ${source}`);
    process.exit(1);
  }

  const sourceStat = fs.statSync(source);
  const sourceName = path.basename(source);

  if (!fs.existsSync(destination)) {
    // Destination does not exist → simple rename
    fs.renameSync(source, destination);
    return;
  }

  const destStat = fs.statSync(destination);

  if (sourceStat.isFile()) {
    if (destStat.isFile()) {
      const newDest = getUniqueName(
        path.dirname(destination),
        path.basename(destination)
      );
      fs.renameSync(source, newDest);
    } else if (destStat.isDirectory()) {
      const newName = fs.existsSync(path.join(destination, sourceName))
        ? getUniqueName(destination, sourceName)
        : path.join(destination, sourceName);
      fs.renameSync(source, newName);
    }
  } else if (sourceStat.isDirectory()) {
    if (!destStat.isDirectory()) {
      console.error("Cannot move a directory into a file.");
      process.exit(1);
    }
    const newName = fs.existsSync(path.join(destination, sourceName))
      ? getUniqueName(destination, sourceName)
      : path.join(destination, sourceName);
    fs.renameSync(source, newName);
  }
}

// Handle single source
if (args.length === 2) {
  const [src, dest] = args.map((arg) => path.resolve(arg));
  moveItem(src, dest);
}

// Handle multiple sources (last arg is destination directory)
if (args.length > 2) {
  const dest = path.resolve(args[args.length - 1]);
  const sources = args.slice(0, -1).map((arg) => path.resolve(arg));

  if (!fs.existsSync(dest) || !fs.statSync(dest).isDirectory()) {
    console.error(`Destination must be an existing directory: ${dest}`);
    process.exit(1);
  }

  sources.forEach((src) => moveItem(src, dest));
}
