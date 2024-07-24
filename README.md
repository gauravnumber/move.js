# move

![GitHub file size in bytes](https://img.shields.io/github/size/gauravnumber/move.js/move)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/gauravnumber/move.js)
![Twitter Follow](https://img.shields.io/twitter/follow/gauravnumber)

`mv` command doesn't support renaming file (adding an index/number) when file already exists, so I created `move`.

`move` doesn't have any dependencies.

## Install

```
node install -g @gauravnumber/move
```

## Usage

```
move <source_path> <destination_path>
```

## Example

Initial Folder Structure

```
.
├── 1.txt
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── 6.txt
```

Execute the command below

```
move 1.txt 2.txt
```

`2.txt` file already exists, so `move` appends an index to the filename. After running above command, the folder structure looks like this.

```
.
├── 2_1.txt
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── 6.txt
```
