# HYBRIS TRAIL

Docker what help us to up server hybris / mysql

## Installation

Put project inside folder hybris like this below:

~~~~
hybris
│
└───bin
│   │   ...
└───config
    │   ...
~~~~

## Usage

#### Development
```bash
make development
```
This command will build the required images to execute the commands below

#### Ant
Can use make command tu run anycommand ant like this:
```bash
TASK='all' make task
```
This command is like **ant all**

#### Hybris
```bash
make up
```
This command will up the server like if you execute **./hybrisserver.sh**

