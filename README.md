# move

![GitHub tag (latest SemVer)](https://img.shields.io/npm/v/%40gauravnumber%2Fmove)
[![Twitter Follow](https://img.shields.io/twitter/follow/gauravnumber)](https://x.com/gauravnumber)

A Node.js utility that enhances file and directory moving capabilities with smart conflict resolution. Unlike the standard `mv` command, `move` automatically handles naming conflicts by appending indices to filenames.

## Features

- 🚀 Zero dependencies
- 📦 Simple installation
- 🔄 Smart conflict resolution
- 📁 Supports both files and directories
- 🔢 Handles multiple sources
- ⚡ Fast and efficient

## Installation

```bash
npm install -g @gauravnumber/move
```

## Usage

```bash
# Basic usage
move <source_path> <destination_path>

# Move multiple files to a directory
move <file1> <file2> ... <directory>
```

## Examples

### 1. Moving a Single File

Initial structure:

```
.
├── 1.txt
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── 6.txt
```

Command:

```bash
move 1.txt 2.txt
```

Result:

```
.
├── 2_1.txt  # 1.txt was moved and renamed to avoid conflict
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── 6.txt
```

### 2. Moving Multiple Files

Command:

```bash
move 1.txt 2.txt 3.txt destination_folder/
```

### 3. Moving Directories

Command:

```bash
move source_directory/ destination_directory/
```

## Supported Operations

- `move filename1 filename2` - Move/rename a single file
- `move onefile twofile threefile andManyMoreFile directoryName` - Move multiple files to a directory
- `move directory1 directory2` - Move a directory to another directory

## How It Works

When a naming conflict occurs, `move` automatically:

1. Detects the existing file/directory
2. Appends an incremental index to the filename
3. Ensures no data is lost during the move operation

## License

MIT
