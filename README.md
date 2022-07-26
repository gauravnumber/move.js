# move

![GitHub file size in bytes](https://img.shields.io/github/size/gauravnumber/move.js/move)
![GitHub tag (latest SemVer)](https://img.shields.io/github/v/tag/gauravnumber/move.js)
![Twitter Follow](https://img.shields.io/twitter/follow/gauravnumber?style=social)

`mv` command does not support adding index when file exists so I create `move`.

`move` didn't have any dependencies.

## Install

```
node install -g @gauravnumber/move
```

## Example

Folder Structure

```
.
├── 1.txt
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── 6.txt
```

Type below command.

```
move 1.txt 2.txt
```

`2.txt` file already exists. `move` command append index on the file. After running above command. Folder structure looks like this.

```
.
├── 2_1.txt
├── 2.txt
├── 3.txt
├── 4.txt
├── 5.txt
└── 6.txt
```
